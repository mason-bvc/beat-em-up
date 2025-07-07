extends Node


const CharacterComponent := preload('res://scripts/character_component.gd')
const CharacterVisuals := preload('res://scripts/character_visuals.gd')
const PlayerController := preload('res://scripts/player_controller.gd')

@onready var character_component: CharacterComponent = $CharacterComponent
@onready var character_visuals: CharacterVisuals = $CharacterVisuals
@onready var player_controller: PlayerController = $PlayerController
