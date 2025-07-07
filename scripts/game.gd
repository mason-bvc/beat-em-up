extends Node


const Types := preload('res://scripts/types.gd')
const CharacterComponent := Types.CharacterComponent
const Health := Types.Health
const YMax := Types.YMax
const Hitbox := preload('res://scripts/hitbox.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')
const Sandbag := preload('res://scripts/sandbag.gd')

var _camera_shaker
var _y_max: YMax = null

@onready var player: Node2D = %Player

var _node_added_handlers: Dictionary[Variant, Callable] = {
	YMax: func (node: YMax) -> void:
		_y_max = node,

	CharacterComponent: func (node: CharacterComponent) -> void:
		node.y_max = _y_max,

	Hitbox: func (node: Hitbox) -> void:
		node.hit_something.connect(_on_hitbox_hit_something),

	preload('res://scripts/shaker.gd'): func (node: Node) -> void:
		_camera_shaker = node,
}

@onready var audio_playback: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer.get_stream_playback()


func try_damaging(victim: Node, hit_info: HitInfo) -> bool:
	var victim_health = Health.try_get_from(victim)

	if victim_health is Health:
		victim_health.damage(hit_info.damage)
		return true

	return false


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_tree_node_added)


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()

	if is_instance_valid(camera):
		camera.global_position.x = player.global_position.x


func _on_tree_node_added(node: Node) -> void:
	var type = node.get_script()

	if not type:
		type = node.get_class()

	if type in _node_added_handlers:
		if not is_node_ready():
			await ready

		_node_added_handlers[type].call(node)


func _on_hitbox_hit_something(victims: Array[Node], hit_info: HitInfo) -> void:
	var max := hit_info.max_victims

	if max <= 0:
		max = victims.size()

	for i in mini(max, victims.size()):
		var victim := victims[i]

		if try_damaging(victim, hit_info):
			if is_instance_valid(_camera_shaker):
				_camera_shaker.shake(0.25)
