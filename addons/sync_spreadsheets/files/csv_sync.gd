@tool
extends Control
const CONFIG_PATH : String = "user://sync_csv_spreadsheets.tres"

@onready var http : CsvHTTP = %HTTP
@onready var sheet_list : ItemList = %SheetList
var config : CsvConfig
var file_dialog : EditorFileDialog

func _ready() -> void:
	file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog.add_filter("*.csv", "CSV Files")
	file_dialog.file_selected.connect(_on_add_file_selected)
	add_child(file_dialog)
	
	load_config()
	if config.auto_sync_on_plugin_load:
		sync_sheets()
		
func update_sheet_list() -> void:
	var last := -1
	if sheet_list.is_anything_selected():
		last = sheet_list.get_selected_items()[0]
	sheet_list.clear()
	for sheet in config.sheets:
		sheet_list.add_item(sheet.csv_path + " - " + sheet.updated_at)
	if last >= 0 && last < sheet_list.item_count:
		sheet_list.select(last)
	%RemoveButton.disabled = !sheet_list.is_anything_selected()

func load_config() -> void:
	if ResourceLoader.exists(CONFIG_PATH):
		config = ResourceLoader.load(CONFIG_PATH)
	else:
		config = CsvConfig.new()
		config.resource_name = "CSV Sync Configuration"
		config.resource_path = CONFIG_PATH
		save_config()
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
		sync_sheet(sheet)
	update_sheet_list()
	# TODO: Refresh godot filesystem

func sync_sheet(sheet : CsvSheetConfig) -> bool:
	if sheet.document_id:
		var url := "https://docs.google.com/spreadsheets/d/" + sheet.document_id + "/gviz/tq"
		if sheet.sheet_name:
			http.req(url, func(r, err): sync_sheet_callback(r, err, sheet), HTTPClient.METHOD_GET, { "tqx": "out:csv", "sheet": sheet.sheet_name }, {}, [], sheet.csv_path)
			return true
		if sheet.sheet_gid:
			http.req(url, func(r, err): sync_sheet_callback(r, err, sheet), HTTPClient.METHOD_GET, { "tqx": "out:csv", "gid": sheet.sheet_gid }, {}, [], sheet.csv_path)
			return true
	return false

func sync_sheet_callback(r, err, sheet) -> void:
	sheet.updated_at = Time.get_datetime_string_from_system()
	save_config()

func sync(url, sheet_name, csv_path) -> void:
	http.req(url, func(r, err): printt(r, err), HTTPClient.METHOD_GET, { "tqx": "out:csv", "sheet": sheet_name }, {}, [], csv_path)

func get_all_file_paths(path: String, file_extension: String = "") -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name
		if dir.current_is_dir():
			file_paths += get_all_file_paths(file_path, file_extension)
		else:
			if file_path.ends_with(file_extension):
				file_paths.append(file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	return file_paths

func _on_edit_config_pressed() -> void:
	EditorInterface.edit_resource(config)

func _on_save_config_pressed() -> void:
	save_config()

func _on_sync_now_pressed() -> void:
	sync_sheets()

func _on_sheet_list_item_selected(index: int) -> void:
	update_sheet_list()
	if sheet_list.is_anything_selected():
		EditorInterface.edit_resource(config.sheets[index])

func _on_add_button_pressed() -> void:
	file_dialog.popup_centered(Vector2(1024, 512))
	
func _on_add_file_selected(path : String) -> void:
	var array := config.sheets.duplicate()
	var sheet := CsvSheetConfig.new()
	sheet.csv_path = path
	array.append(sheet)
	config.sheets = array
	save_config()

func _on_remove_button_pressed() -> void:
	if !sheet_list.is_anything_selected():
		return
	var array := config.sheets.duplicate()
	array.remove_at(sheet_list.get_selected_items()[0])
	config.sheets = array
	save_config()
