class_name PlayGamePassThr
extends Node

var _game_scene_file: String = "res://scenes/game.tscn"

func _ready() -> void:
	# TODO(mackenzie): this is a placeholder script to passthrough the lobby and to the game scene
	get_tree().change_scene_to_file(_game_scene_file)
