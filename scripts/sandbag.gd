extends Node2D


const Types := preload('res://scripts/types.gd')
const Health := Types.Health

@onready var health: Health = $Hurtbox/Health


func _ready() -> void:
	health.damaged.connect(_on_hurtbox_damaged)
	#health.depleted.connect(queue_free.call_deferred)


func _on_hurtbox_damaged(amount: float) -> void:
	$AnimationPlayer.play(&'hit')
