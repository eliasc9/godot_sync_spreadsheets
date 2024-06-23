@tool
extends Resource
class_name CsvConfig

@export var auto_sync_on_plugin_load : bool = true
@export var sheets : Array[CsvSheetConfig] = []:
	set(val):
		if sheets != val:
			sheets = val
			emit_changed()
