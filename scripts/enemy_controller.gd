extends Node


enum State {
	LOOKING,
	CHASING,
	ATTACKING,
	HURTING,
	DYING,
}


const ChainGuy := preload('res://scripts/chain_guy.gd')

var previous_state: State
var state: State
var target: Node2D

@onready var chain_guy: ChainGuy = owner
@onready var attack_cooldown: float


func _ready() -> void:
	await chain_guy.ready

	chain_guy.health.damaged.connect(func (amount: float) -> void:
		state = State.HURTING)

	chain_guy.health.depleted.connect(func () -> void:
		state = State.DYING)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var just_switched_states: bool = previous_state != state

	previous_state = state

	if state == State.LOOKING:
		if chain_guy.global_position.distance_squared_to(target.global_position) < 128 * 128:
			state = State.CHASING
	elif state == State.CHASING:
		chain_guy.character_visuals.animation_tree_playback.travel(&'walk')
		chain_guy.character_visuals.scale.x = signf(target.global_position.x - chain_guy.global_position.x)

		if chain_guy.global_position.distance_squared_to(target.global_position) > 32 * 32:
			chain_guy.character_component.try_move(chain_guy.global_position.direction_to(target.global_position) * 40 * delta)
		else:
			state = State.ATTACKING
	elif state == State.ATTACKING:
		if just_switched_states:
			attack_cooldown = 3
			chain_guy.character_visuals.animation_tree_playback.travel(&'whip')

		if attack_cooldown <= 0:
			state = State.CHASING
	elif state == State.HURTING:
		if just_switched_states:
			attack_cooldown = 0.6
			chain_guy.character_visuals.animation_tree_playback.start(&'hurt')

		if attack_cooldown <= 0:
			state = State.CHASING
	elif state == State.DYING:
		if just_switched_states:
			chain_guy.character_visuals.animation_tree_playback.start(&'die')
			(get_tree().create_tween()
					.tween_property(chain_guy, ^'global_position', chain_guy.global_position + Vector2.RIGHT * -chain_guy.character_visuals.scale.x * 64, 1)
					.set_ease(Tween.EASE_OUT)
					.set_trans(Tween.TRANS_CUBIC))

	attack_cooldown -= delta
	attack_cooldown = maxf(attack_cooldown, 0)
