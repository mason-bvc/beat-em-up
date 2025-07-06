extends Node


const Types := preload('res://scripts/types.gd')
const CharacterComponent := Types.CharacterComponent
const FrameData := preload('res://scripts/frame_data.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')

@export var character_component: CharacterComponent

var combo_counter: int
var move_axes: Vector2

@onready var combo_animation_player: AnimationPlayer = get_node(^'../ComboAnimationPlayer')
@onready var animation_tree: AnimationTree = (
		get_node(^'../PlayerAnimationRoot/AnimationPlayer/AnimationTree'))
@onready var audio: AudioStreamPlaybackPolyphonic = (
		get_node(^'../AudioStreamPlayer2D').get_stream_playback())
@onready var frame_data: FrameData = (
		get_node(^'../PlayerAnimationRoot/FrameData') as Object as FrameData)
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree[&'parameters/playback']


func _ready() -> void:
	combo_animation_player.animation_finished.connect(_on_combo_animation_player_animation_finished)


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
	move *= float(playback.get_current_node() != &'jab')
	character_component.try_move(move)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&'attack_primary'):
		if combo_counter == 0:
			playback.travel(&'jab')
		elif combo_counter == 1:
			playback.travel(&'uppercut')


func _on_hitbox_hit(victims: Array[Node], hit_info: HitInfo) -> void:
	for victim in victims:
		if victim.owner == owner:
			continue

		combo_counter += 1
		combo_animation_player.play(&'combo')
		audio.play_stream(preload('res://audio/sounds/hit.wav'))


func _on_combo_animation_player_animation_finished(anim_name: StringName) -> void:
	combo_counter = 0
