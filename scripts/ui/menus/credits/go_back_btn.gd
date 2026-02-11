class_name GoBackBtn
extends Button

var _main_scene_file: String = "res://scenes/main.tscn"

func _ready() -> void:
	button_up.connect(_handle_pressed)


func _handle_pressed() -> void:
	get_tree().change_scene_to_file(_main_scene_file)
