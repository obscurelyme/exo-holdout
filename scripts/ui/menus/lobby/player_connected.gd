extends Node

@export var player_name: PackedScene


func _ready() -> void:
	NetworkManager.player_connected.connect(_on_player_connected)
	for player in NetworkManager.players.values():
		_on_player_connected(player)


func _on_player_connected(player_info: NetPlayer) -> void:
	print("Player joined %d" % player_info.peer_id)
	var player_name_label: NetPlayerLabel = player_name.instantiate()
	player_name_label.net_player = player_info
	add_child(player_name_label)
