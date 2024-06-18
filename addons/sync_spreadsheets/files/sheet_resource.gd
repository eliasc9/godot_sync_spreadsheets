extends Resource
class_name SheetResource

@export var csv_path : String
@export var sheet_id : String
@export var sheet_name : String
@export var sheet_gid : String
@export var updated_at : String
@export var update_on_auto_sync : bool

func _init(p_csv_path = "", p_sheet_id = "", p_sheet_name = "", p_sheet_gid = "", p_updated_at = "", p_update_on_auto_sync = true):
	csv_path = p_csv_path
	sheet_id = p_sheet_id
	sheet_name = p_sheet_name
	sheet_gid = p_sheet_gid
	updated_at = p_updated_at
	update_on_auto_sync = p_update_on_auto_sync
