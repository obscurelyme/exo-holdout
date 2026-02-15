class_name CreateGameBtn
extends ChangeSceneBtn


func _ready() -> void:
    NetworkManager.host_game()
    super._ready()
