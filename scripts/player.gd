extends Node2D


const Types := preload('res://scripts/types.gd')
const CharacterController := Types.CharacterController
const FrameData := preload('res://scripts/frame_data.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')

var move_axes: Vector2

@onready var character_controller: CharacterController = $CharacterController
@onready var animation_tree: AnimationTree = $PlayerAnimationRoot/AnimationPlayer/AnimationTree
@onready var animation_player: AnimationPlayer = $PlayerAnimationRoot/AnimationPlayer
@onready var audio: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer2D.get_stream_playback()
@onready var frame_data: FrameData = $PlayerAnimationRoot/FrameData as Object as FrameData
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree[&'parameters/playback']


func _ready() -> void:
	animation_player.add_user_signal('event', [
		{ 'name': 'name',   'type': TYPE_STRING_NAME, },
		{ 'name': 'stream', 'type': TYPE_OBJECT,      },
	])

	animation_player.connect(&'event', _on_animation_event)


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
	character_controller.try_move(move)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&'attack_primary'):
		playback.travel(&'jab')


func _on_animation_event(p_name: StringName, argument: Variant) -> void:
	if p_name == &'active':
		var area = animation_player.get_node(argument)


func _on_hitbox_hit(victims: Array[Node], hit_info: HitInfo) -> void:
	for victim in victims:
		if victim.owner == owner:
			continue

		audio.play_stream(preload('res://audio/sounds/hit.wav'))
