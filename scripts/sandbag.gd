extends Node2D


const EventDispatcher = preload('res://scripts/event_dispatcher.gd')

@onready var event_dispatcher: EventDispatcher = $EventDispatcher


func _ready() -> void:
	event_dispatcher.event_recieved.connect(_on_event_dispatcher_event_received)


func _on_event_dispatcher_event_received(p_name: StringName, arg: Variant) -> void:
	print('sandbag received event')
