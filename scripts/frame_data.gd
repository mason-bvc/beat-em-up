extends Object


enum ChainMode {
	NONE,
	QUEUE,
	CANCEL,
}


@export var chain_mode: ChainMode
@export var is_invulnerable: bool


func reset() -> void:
	chain_mode = ChainMode.NONE
	is_invulnerable = false
