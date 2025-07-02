@tool
extends EditorScript


func _run() -> void:
	print(ClassDB.class_get_method_list(&'AudioStreamPlaybackPolyphonic'))
