class_name QuitBtn
extends Button


func _ready() -> void:
	button_up.connect(_handle_pressed)

func _handle_pressed() -> void:
	get_tree().quit()
