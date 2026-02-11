class_name PlayGamePassThr
extends Node

var game_scene = preload("res://scenes/game.tscn")

func _ready() -> void:
	# TODO(mackenzie): this is a placeholder script to passthrough the lobby and to the game scene
	get_tree().change_scene_to_packed(game_scene)
