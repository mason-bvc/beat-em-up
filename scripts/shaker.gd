extends Node2D


@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func shake(duration: float = 0.25) -> void:
	_animation_player.play(&'shake')
	await get_tree().create_timer(duration).timeout
	_animation_player.stop()
