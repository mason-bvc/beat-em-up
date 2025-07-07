extends Node


const FrameData := preload('res://scripts/frame_data.gd')

@onready var sprite: Sprite2D = $Sprite2D
@onready var jab_hitbox: Area2D = $JabHitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var audio: AudioStreamPlaybackPolyphonic = $AudioStreamPlayer2D.get_stream_playback()
@onready var frame_data: FrameData = $FrameData as Object as FrameData
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_tree_playback: AnimationNodeStateMachinePlayback = animation_tree[&'parameters/playback']
