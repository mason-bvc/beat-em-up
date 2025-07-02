extends Node


@export var target: Node


func play_stream(stream: AudioStream, from_offset: float = 0, volume_db: float = 0, pitch_scale: float = 1, playback_type: AudioServer.PlaybackType = 0, bus: StringName = &'Master') -> void:
	target.get_stream_playback().play_stream(stream, from_offset, volume_db, pitch_scale, playback_type, bus)
