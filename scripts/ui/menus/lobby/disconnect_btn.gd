class_name DisconnectBtn
extends ChangeSceneBtn


func _ready() -> void:
	super._ready()


func _handle_pressed() -> void:
	NetworkManager.disconnect_from_multiplayer()
	super._handle_pressed()
