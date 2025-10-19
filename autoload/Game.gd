extends Node

class_name Game

## Global game state and helpers
var player_ref: NodePath

func _ready() -> void:
	print("Game autoload ready")
