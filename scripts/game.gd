extends Node


const Hitbox := preload('res://scripts/hitbox.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')
const Sandbag := preload('res://scripts/sandbag.gd')
const Health := preload('res://scripts/health.gd')

@onready var audio_playback: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer.get_stream_playback()


func try_damaging(victim: Node, hit_info: HitInfo) -> void:
	var victim_health = Health.try_get_from(victim)

	if victim_health is Health:
		victim_health.damage(hit_info.damage)
		audio_playback.play_stream(preload('res://audio/sounds/hit.wav'))


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_tree_node_added)


func _on_tree_node_added(node: Node) -> void:
	if node is Hitbox:
		node.hit_something.connect(_on_hitbox_hit_something)


func _on_hitbox_hit_something(victims: Array[Node], hit_info: HitInfo) -> void:
	var max := hit_info.max_victims

	if max <= 0:
		max = victims.size()

	for i in mini(max, victims.size()):
		var victim := victims[i]
		try_damaging(victim, hit_info)
