class_name CreateLobbyBtn
extends Button

var lobby_scene = preload("res://scenes/lobby.tscn")

func _ready() -> void:
	button_up.connect(_handle_pressed)

func _handle_pressed() -> void:
	get_tree().change_scene_to_packed(lobby_scene)
