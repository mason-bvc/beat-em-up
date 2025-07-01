extends Node


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func try_hit(attacker: Node, victim: Node) -> void:
	audio_stream_player.play()


func on_event() -> void:
	pass
