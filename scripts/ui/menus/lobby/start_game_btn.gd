class_name StartGameBtn
extends ChangeSceneBtn


func _ready() -> void:
	super._ready()


func _handle_pressed() -> void:
	if NetworkManager.is_multiplayer_connected() && is_multiplayer_authority():
		rpc("_start_game")


@rpc("authority", "call_local", "reliable")
func _start_game() -> void:
	super._handle_pressed()
