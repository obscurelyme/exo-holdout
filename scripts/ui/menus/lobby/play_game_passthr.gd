class_name PlayGamePassThr
extends Node

@export var create_game_btn: Button
@export var join_game_btn: Button
@export var leave_game_btn: Button
@export var list: VBoxContainer
@export var player_name: TextEdit


func _ready() -> void:
	create_game_btn.button_up.connect(create_game, CONNECT_ONE_SHOT)
	join_game_btn.button_up.connect(join_game)
	leave_game_btn.button_up.connect(leave_game)
	player_name.text_changed.connect(_on_text_changed)


## Creates a new multiplayer server
func create_game() -> void:
	if player_name.text:
		var peer = ENetMultiplayerPeer.new()
		peer.set_bind_ip(NetworkManager.SERVER_IP)
		var error = peer.create_server(NetworkManager.PORT, NetworkManager.MAX_CONNS)
		if error:
			push_error("Unable to create multipler server: %d" % error)
			return
		multiplayer.multiplayer_peer = peer
		NetworkManager.players[0] = NetworkManager.player_info
		NetworkManager.player_connected.emit(NetworkManager.player_info)


## Joins an existing multiplayer server
func join_game(address_ip: String = NetworkManager.SERVER_IP,
	port: int = NetworkManager.PORT) -> void:
	if player_name.text:
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client(address_ip, port)
		if error:
			push_error("Unable to create multipler server: %d" % error)
			return
		multiplayer.multiplayer_peer = peer

func leave_game() -> void:
	if NetworkManager.is_multiplayer_connected():
		NetworkManager.disconnect_from_multiplayer()

func _on_text_changed():
	NetworkManager.set_player_name(player_name.text)
