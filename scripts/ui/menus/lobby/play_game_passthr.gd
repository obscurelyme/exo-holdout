class_name PlayGamePassThr
extends Node

var _game_scene: Scenes.SceneTypes = Scenes.SceneTypes.GAME

func _ready() -> void:
	# TODO(mackenzie): this is a placeholder script to passthrough the lobby and to the game scene
	get_tree().change_scene_to_file(Scenes.get_scene(_game_scene))
