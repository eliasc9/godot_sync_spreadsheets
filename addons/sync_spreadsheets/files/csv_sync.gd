@tool
extends Control
const CONFIG_PATH : String = "user://sync_csv_spreadsheets.tres"

@onready var http : CsvHTTP = %HTTP
@onready var sheet_tree : Tree = %SheetTree
@onready var remove_button : Button = %RemoveButton
var config : CsvConfig
var file_dialog : EditorFileDialog
var tree_root : TreeItem
# We don't want to do it when editing the scene file.
var should_setup : bool = false

func _ready() -> void:
	if !should_setup:
		return
		
	file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog.add_filter("*.csv", "CSV Files")
	file_dialog.file_selected.connect(_on_add_file_selected)
	add_child(file_dialog)
	
	sheet_tree.set_column_title(0, "Path")
	sheet_tree.set_column_title(1, "Last Updated")
	tree_root = sheet_tree.create_item()
	
	load_config()
	if config.auto_sync_on_plugin_load:
		sync_sheets()
		
#func _notification(what: int) -> void:
	#if what == NOTIFICATION_VISIBILITY_CHANGED:
		#if is_visible_in_tree():
			#print("woah!")
		
func update_sheet_list() -> void:
	while tree_root.get_child_count() < config.sheets.size():
		tree_root.create_child()
	while tree_root.get_child_count() > config.sheets.size():
		tree_root.get_child(tree_root.get_child_count() - 1).free()
	for i in config.sheets.size():
		var sheet := config.sheets[i]
		if !is_instance_valid(sheet):
			continue
		var item := tree_root.get_child(i)
		item.set_text(0, sheet.csv_path)
		item.set_text(1, sheet.last_updated)
		item.set_metadata(0, sheet)
	remove_button.disabled = !is_instance_valid(sheet_tree.get_selected())
	$CheckBox.button_pressed = config.auto_sync_on_plugin_load

func load_config() -> void:
	if config:
		config.changed.disconnect(update_sheet_list)
	if ResourceLoader.exists(CONFIG_PATH):
		config = ResourceLoader.load(CONFIG_PATH)
	else:
		config = CsvConfig.new()
		config.resource_name = "CSV Sync Configuration"
		config.resource_path = CONFIG_PATH
		save_config()
	config.changed.connect(update_sheet_list)
	update_sheet_list()

func save_config() -> void:
	ResourceSaver.save(config, CONFIG_PATH)
	update_sheet_list()

func sync_sheets() -> void:
	for sheet in config.sheets:
		if !sheet.csv_path.is_absolute_path():
			printerr("Invalid filename: " + sheet.csv_path)
			continue
		if !FileAccess.file_exists(sheet.csv_path):
			var f := FileAccess.open(sheet.csv_path, FileAccess.WRITE)
			f.close()
			var err := f.get_error()
			if err != OK:
				printerr("Couldn't create file: " + sheet.csv_path)
				continue # We don't want to sync this one.
			EditorInterface.get_resource_filesystem().update_file(sheet.csv_path)
		sync_sheet(sheet)
	update_sheet_list()

func sync_sheet(sheet : CsvSheetConfig) -> bool:
	if sheet.spreadsheet_id:
		var url := "https://docs.google.com/spreadsheets/d/" + sheet.spreadsheet_id + "/gviz/tq"
		if sheet.sheet_name:
			http.req(url, func(r, err): sync_sheet_callback(r, err, sheet), HTTPClient.METHOD_GET, { "tqx": "out:csv", "sheet": sheet.sheet_name }, {}, [], sheet.csv_path)
			return true
		if sheet.sheet_gid:
			http.req(url, func(r, err): sync_sheet_callback(r, err, sheet), HTTPClient.METHOD_GET, { "tqx": "out:csv", "gid": sheet.sheet_gid }, {}, [], sheet.csv_path)
			return true
	return false

func sync_sheet_callback(r, err, sheet) -> void:
	sheet.last_updated = Time.get_datetime_string_from_system()
	save_config()
	EditorInterface.get_resource_filesystem().scan_sources()

func _on_edit_config_pressed() -> void:
	_on_sheet_tree_nothing_selected()
	EditorInterface.edit_resource(config)

func _on_save_config_pressed() -> void:
	save_config()

func _on_sync_now_pressed() -> void:
	sync_sheets()

func _on_add_button_pressed() -> void:
	file_dialog.popup_centered(Vector2(1024, 512))
	
func _on_add_file_selected(path : String) -> void:
	var array := config.sheets
	if array.is_read_only():
		array = array.duplicate()
	var sheet := CsvSheetConfig.new()
	sheet.csv_path = path
	array.append(sheet)
	config.sheets = array
	save_config()

func _on_remove_button_pressed() -> void:
	if !is_instance_valid(sheet_tree.get_selected()):
		return
	var array := config.sheets
	if array.is_read_only():
		array = array.duplicate()
	array.remove_at(sheet_tree.get_selected().get_index())
	config.sheets = array
	update_sheet_list()

func _on_sheet_tree_item_selected() -> void:
	remove_button.disabled = false
	EditorInterface.edit_resource(config.sheets[sheet_tree.get_selected().get_index()])

func _on_sheet_tree_nothing_selected() -> void:
	remove_button.disabled = true
	sheet_tree.deselect_all()

func _on_check_box_toggled(toggled_on: bool) -> void:
	config.auto_sync_on_plugin_load = toggled_on
	save_config()
