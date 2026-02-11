class_name CreditsBtn
extends Button

var _credits_scene_file: String = "res://scenes/credits.tscn"

func _ready() -> void:
	button_up.connect(_handle_pressed)


func _handle_pressed() -> void:
	get_tree().change_scene_to_file(_credits_scene_file)
