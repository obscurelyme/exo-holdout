class_name NetPlayerLabel
extends Label

var net_player: NetPlayer


func _ready() -> void:
	text = net_player.name
	NetworkManager.player_disconnected.connect(_on_player_disconnected)


func _on_player_disconnected(peer_id: int) -> void:
	if peer_id == net_player.peer_id:
		queue_free()
