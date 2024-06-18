@tool
extends EditorPlugin

const SyncScene = preload("res://addons/sync_spreadsheets/files/sync.tscn")

var sync_instance

func _enter_tree():
	sync_instance = SyncScene.instantiate()
	add_control_to_bottom_panel(sync_instance, "Sync CSV Spreadsheets", Shortcut.new())


func _exit_tree():
	if sync_instance:
		remove_control_from_bottom_panel(sync_instance)
		sync_instance.queue_free()
