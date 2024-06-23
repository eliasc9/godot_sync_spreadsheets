extends Resource
class_name CsvConfig

@export var auto_sync_on_plugin_load : bool = true
@export var sheets : Array[CsvSheetConfig] = []

func _init(p_sheets : Array[CsvSheetConfig] = []):
	sheets = p_sheets
