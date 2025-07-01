extends Node


const EventDispatcher := preload('res://scripts/event_dispatcher.gd')

@onready var audio_playback: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer.get_stream_playback()


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_tree_node_added)


func _on_tree_node_added(node: Node) -> void:
	if node is EventDispatcher:
		await ready
		node.event.connect(_on_event.bind(node))


func _on_event(p_name: StringName, arg: Variant, event_dispatcher: EventDispatcher) -> void:
	if p_name == &'hit':
		audio_playback.play_stream(preload('res://audio/sounds/hit.wav'))

	event_dispatcher.receive_event(p_name, arg)
