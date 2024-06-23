extends Resource
class_name CsvSheetConfig

@export_file("*.csv") var csv_path : String
@export var spreadsheet_id : String = ""
@export var sheet_name : String = ""
@export var sheet_gid : String = ""
@export var last_updated : String = "not updated"
