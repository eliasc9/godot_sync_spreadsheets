@tool
extends EditorPlugin
var sync_instance : Node

func _enter_tree():
	# So that the scene reloads everytime we activate the plugin, allowing for quicker prototyping.
	var packed : PackedScene = load("res://addons/sync_spreadsheets/files/csv_sync.tscn")
	sync_instance = packed.instantiate()
	# Not available in godot 4.2
	# add_control_to_bottom_panel(sync_instance, "Sync CSV Spreadsheets", Shortcut.new())
	add_control_to_bottom_panel(sync_instance, "Sync CSV")

func _exit_tree():
	if sync_instance:
		remove_control_from_bottom_panel(sync_instance)
		sync_instance.queue_free()
