extends Node
"""

@export var camera_root: Node2D
@onready var sub_viewport: SubViewport = %GameViewport
@onready var player: Node2D = sub_viewport.find_child('Player', true, false)


func _process(delta: float) -> void:
	var camera := sub_viewport.get_camera_2d()

	if is_instance_valid(camera):
		camera.global_position.x = player.global_position.x


func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
"""


const MENU := preload('res://scenes/menu.tscn')
const GAME := preload('res://scenes/game.tscn')

var _current_root: Node
@onready var sub_viewport: SubViewport = %SubViewport
@onready var fade_color_rect: ColorRect = %FadeColorRect


func _ready() -> void:
	var menu: Control = MENU.instantiate()

	sub_viewport.add_child(menu)

	while not menu.is_node_ready():
		await get_tree().process_frame

	menu.size = sub_viewport.size
	menu.start_pressed.connect(change_scene.bind(func () -> Node:
		return GAME.instantiate()))
	_current_root = menu


func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event.xformed_by(Transform2D.IDENTITY.scaled(Vector2.ONE * sub_viewport.size.y / get_viewport().size.y)))


func change_scene(factory: Callable) -> void:
	await get_tree().create_tween().tween_property(fade_color_rect, ^'color:a', 1.0, 0.5).finished
	_current_root.queue_free()
	await get_tree().process_frame
	_current_root = factory.call()
	sub_viewport.add_child.call_deferred(_current_root)
	await get_tree().process_frame
	await get_tree().create_tween().tween_property(fade_color_rect, ^'color:a', 0.0, 0.5).finished
