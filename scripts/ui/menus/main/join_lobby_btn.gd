class_name JoinLobbyBtn
extends Button

var _lobby_scene_file: String = "res://scenes/lobby.tscn"

func _ready() -> void:
	button_up.connect(_handle_pressed)

func _handle_pressed() -> void:
	get_tree().change_scene_to_file(_lobby_scene_file)
