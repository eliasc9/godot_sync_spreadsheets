@tool
extends Resource
class_name CsvConfig

@export var auto_sync_on_plugin_load : bool = false:
	set(val):
		if auto_sync_on_plugin_load != val:
			auto_sync_on_plugin_load = val
			emit_changed()
@export var sheets : Array[CsvSheetConfig] = []:
	set(val):
		if sheets != val:
			sheets = val
			emit_changed()
