extends Node


const Player := preload('res://scripts/player.gd')
const HitInfo := preload('res://scripts/resources/hit_info.gd')
const Health := preload('res://scripts/health.gd')

var attack_timer: float
var move_axes: Vector2

@onready var player: Player = owner


func _process(delta: float) -> void:
	move_axes.x = Input.get_axis(&'move_left', &'move_right')
	move_axes.y = Input.get_axis(&'move_down', &'move_up')
	move_axes = move_axes.normalized()

	var is_not_walking := not is_equal_approx(move_axes.length_squared(), 0)

	player.character_visuals.animation_tree[&'parameters/conditions/is_walking'] = is_not_walking
	player.character_visuals.animation_tree[&'parameters/conditions/is_not_walking'] = not is_not_walking

	attack_timer -= delta
	attack_timer = maxf(attack_timer, 0)


func _physics_process(delta: float) -> void:
	var move := move_axes * 75 * delta

	move.y *= -1
	move *= float(attack_timer <= 0)
	player.character_component.try_move(move)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&'attack_primary'):
		if attack_timer <= 0:
			attack_primary()


func attack_primary() -> void:
	attack_timer = 0.2
	player.character_visuals.animation_tree_playback.travel(&'jab')


func _on_hitbox_hit(victims: Array[Node], hit_info: HitInfo) -> void:
	for victim in victims:
		if victim.owner == owner:
			continue

		var snd := preload('res://audio/sounds/big_hit.wav')
		var victim_health = Health.try_get_from(victim)

		if victim_health is Health:
			if victim_health.amount - hit_info.damage <= 0:
				snd = preload('res://audio/sounds/bigger_hit.wav')

		player.character_visuals.audio.play_stream(snd)
