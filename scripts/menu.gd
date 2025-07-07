extends Control


signal start_pressed
signal quit_pressed

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	start_button.pressed.connect(start_pressed.emit)
	quit_button.pressed.connect(quit_pressed.emit)
