extends Node


const Types := preload('res://scripts/types.gd')
const YMax := Types.YMax

@export var target: Node2D

var y_max: YMax
var velocity: Vector2


func try_move(relative: Vector2) -> void:
	var desired_pos := target.global_position + relative

	if is_instance_valid(y_max):
		desired_pos.y = clampf(desired_pos.y, y_max.global_position.y, y_max.global_position.y + y_max.height)

	target.global_position = desired_pos


func _physics_process(delta: float) -> void:
	if not is_equal_approx(velocity.length_squared(), 0):
		target.global_position += velocity * delta
