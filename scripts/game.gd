extends Node


const Types := preload('res://scripts/types.gd')
const CharacterComponent := Types.CharacterComponent
const Health := Types.Health
const YMax := Types.YMax
const Hitbox := preload('res://scripts/hitbox.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')
const Sandbag := preload('res://scripts/sandbag.gd')

const IMPACT_EFFECT_0 := preload('res://scenes/effects/impact_0.tscn')
const CHAIN_GUY := preload('res://scenes/chain_guy.tscn')

var _camera_shaker
var _y_max: YMax = null

@onready var player: Node2D = %Player
@onready var foreground: Node2D = %Foreground
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

var _node_added_handlers: Dictionary[Variant, Callable] = {
	YMax: func (node: YMax) -> void:
		_y_max = node,

	CharacterComponent: func (node: CharacterComponent) -> void:
		node.y_max = _y_max,

	Hitbox: func (node: Hitbox) -> void:
		node.hit_something.connect(_on_hitbox_hit_something),

	preload('res://scripts/shaker.gd'): func (node: Node) -> void:
		_camera_shaker = node,

	preload('res://scripts/chain_guy.gd'): func (node: Node) -> void:
		await node.ready
		node.enemy_controller.target = player,
}

@onready var audio_playback: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer.get_stream_playback()


func try_damaging(victim: Node, hit_info: HitInfo) -> int:
	var victim_health = Health.try_get_from(victim)
	var r := 0

	if victim_health is Health:
		victim_health.damage(hit_info.damage)
		r |= 1

		if victim_health.amount <= 0:
			r |= 2

		return r

	return r


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_tree_node_added)


func _ready() -> void:
	enemy_spawn_timer.timeout.connect(func () -> void:
		var chain_guy := CHAIN_GUY.instantiate()

		chain_guy.global_position = player.global_position + Vector2.RIGHT * 160 + Vector2.RIGHT * randf_range(0, 64)
		chain_guy.global_position.y += randf_range(-32, 32)
		chain_guy.global_position.y = clampf(chain_guy.global_position.y, 64, 96)
		foreground.add_child.call_deferred(chain_guy))

	enemy_spawn_timer.start()


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

			var effect := IMPACT_EFFECT_0.instantiate()

			effect.global_position = victim.global_position
			foreground.add_child.call_deferred(effect)
