extends Node


signal event(p_name: StringName, arg: Variant)
signal event_recieved(p_name: StringName, arg: Variant)


func emit_event(p_name: StringName, arg: Variant) -> void:
	event.emit(p_name, arg)


func receive_event(p_name: StringName, arg: Variant) -> void:
	event_recieved.emit(p_name, arg)
