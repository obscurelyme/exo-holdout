class_name ChangeSceneBtn
extends Button

@export var scene: Scenes.SceneTypes


func _ready() -> void:
	button_up.connect(_handle_pressed)


func _handle_pressed() -> void:
	get_tree().change_scene_to_file(Scenes.get_scene(scene))
