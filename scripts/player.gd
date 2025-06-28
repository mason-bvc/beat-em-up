extends Node2D


var move_axes: Vector2
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	move_axes.x = Input.get_axis(&'move_left', &'move_right')
	move_axes.y = Input.get_axis(&'move_down', &'move_up')
	move_axes = move_axes.normalized()


func _physics_process(delta: float) -> void:
	global_position.x += move_axes.x * 75 * delta
	global_position.y -= move_axes.y * 75 * delta
