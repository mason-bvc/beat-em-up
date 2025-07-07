extends Node


const CharacterComponent := preload('res://scripts/character_component.gd')
const CharacterVisuals := preload('res://scripts/character_visuals.gd')
const EnemyController := preload('res://scripts/enemy_controller.gd')
const Health := preload('res://scripts/health.gd')

@onready var character_component: CharacterComponent = $CharacterComponent
@onready var character_visuals: CharacterVisuals = $CharacterVisuals
@onready var enemy_controller: EnemyController = $EnemyController
@onready var health: Health = $Health
