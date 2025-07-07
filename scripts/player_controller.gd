extends Node


const Types := preload('res://scripts/types.gd')
const CharacterComponent := Types.CharacterComponent
const FrameData := preload('res://scripts/frame_data.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')

@export var character_component: CharacterComponent

var _combo_string: Array[Callable] = [
	func () -> bool:
		return true
]

var combo_counter: int
var move_axes: Vector2

@onready var animation_tree: AnimationTree = (
		get_node(^'../PlayerAnimationRoot/AnimationPlayer/AnimationTree'))
@onready var audio: AudioStreamPlaybackPolyphonic = (
		get_node(^'../AudioStreamPlayer2D').get_stream_playback())
@onready var frame_data: FrameData = (
		get_node(^'../PlayerAnimationRoot/FrameData') as Object as FrameData)
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree[&'parameters/playback']


func _process(delta: float) -> void:
	move_axes.x = Input.get_axis(&'move_left', &'move_right')
	move_axes.y = Input.get_axis(&'move_down', &'move_up')
	move_axes = move_axes.normalized()

	var is_not_walking := not is_equal_approx(move_axes.length_squared(), 0)

	animation_tree[&'parameters/conditions/is_walking'] = is_not_walking
	animation_tree[&'parameters/conditions/is_not_walking'] = not is_not_walking


func _physics_process(delta: float) -> void:
	var move := move_axes * 75 * delta

	move.y *= -1
	character_component.try_move(move)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&'attack_primary'):
		pass


func _on_hitbox_hit(victims: Array[Node], hit_info: HitInfo) -> void:
	for victim in victims:
		if victim.owner == owner:
			continue

		combo_counter += 1

		if hit_info.damage > 34:
			audio.play_stream(preload('res://audio/sounds/big_hit.wav'))
		else:
			audio.play_stream(preload('res://audio/sounds/hit.wav'))
