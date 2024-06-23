extends Resource
class_name CsvSheetConfig

@export_file("*.csv") var csv_path : String:
	set(val):
		if csv_path != val:
			csv_path = val
			emit_changed()
@export var spreadsheet_id : String = ""
@export var sheet_name : String = ""
@export var sheet_gid : String = ""
@export var last_updated : String = "not updated":
	set(val):
		if last_updated != val:
			last_updated = val
			emit_changed()
