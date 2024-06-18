extends Resource
class_name SheetsResource

@export var sheets : Array[SheetResource] = []

func _init(p_sheets : Array[SheetResource] = []):
	sheets = p_sheets
