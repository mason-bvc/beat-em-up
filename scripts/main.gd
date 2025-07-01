extends Node


@onready var game_viewport: SubViewport = %GameViewport


func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)


func _unhandled_input(event: InputEvent) -> void:
	game_viewport.push_unhandled_input(event)
