extends Node


@onready var game_viewport: SubViewport = %GameViewport
@onready var player: Node2D = game_viewport.find_child('Player', true, false)


func _process(delta: float) -> void:
	var camera := game_viewport.get_camera_2d()

	if is_instance_valid(camera):
		camera.global_position.x = player.global_position.x


func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)


func _unhandled_input(event: InputEvent) -> void:
	game_viewport.push_unhandled_input(event)
