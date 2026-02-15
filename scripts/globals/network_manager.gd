extends Node

signal player_connected(net_player: NetPlayer)
signal player_disconnected(peer_id: int)
signal server_disconnected

## TODO: requires port forwarding if you want to expose this and play with friends.
## Will eventually let Steam handle this so port forwarding is not required.
const SERVER_IP: String = "192.168.1.167"
const PORT = 5290
const MAX_CONNS: int = 4
const HOST_PEER_ID: int = 1  # Host peer id is always 1
const TIMEOUT: int = 30000  # 30 second timeout

var players_loaded = 0
var player_info: NetPlayer = NetPlayer.new()
var players: Dictionary[int, NetPlayer] = {}


## Sets the name of the player to be seen by other players on the network
func set_player_name(net_player_name: String) -> void:
	player_info.name = net_player_name


## Creates a new multiplayer server
func host_game() -> void:
	if not is_multiplayer_connected():
		var peer = ENetMultiplayerPeer.new()
		peer.set_bind_ip(SERVER_IP)
		var error = peer.create_server(PORT, MAX_CONNS)
		if error:
			push_error("Unable to create multiplayer server: %d" % _error_to_string(error))
			return
		multiplayer.multiplayer_peer = peer
		player_info.peer_id = HOST_PEER_ID
		players[player_info.peer_id] = player_info
		player_connected.emit(player_info)
		return
	push_warning("Cannot host new game while already hosting another")


## Joins an existing multiplayer server
func join_game(
	address_ip: String = NetworkManager.SERVER_IP, port: int = NetworkManager.PORT
) -> void:
	## TODO(mackenzie): need a way to handle timeouts
	if not is_multiplayer_connected():
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client(address_ip, port)
		if error:
			push_error("Unable to create multiplayer client: %d" % _error_to_string(error))
			return
		multiplayer.multiplayer_peer = peer
		return
	push_warning("Cannot join a game while connected to another")


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func is_multiplayer_connected() -> bool:
	return (
		multiplayer.multiplayer_peer
		&& (
			multiplayer.multiplayer_peer.get_connection_status()
			== MultiplayerPeer.CONNECTION_CONNECTED
		)
		&& multiplayer.multiplayer_peer is ENetMultiplayerPeer
	)


func disconnect_from_multiplayer() -> void:
	if is_multiplayer_connected():
		multiplayer.multiplayer_peer.close()
		print("Disconnected from multiplayer")

	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	for peer_id in players.keys():
		player_disconnected.emit(peer_id)
	players.clear()
	return


@rpc("any_peer", "reliable")
func _register_player(player_data: Dictionary):
	var new_player_id = multiplayer.get_remote_sender_id()
	var new_player = NetPlayer.new()
	new_player.name = player_data.get("name", "")
	new_player.peer_id = new_player_id
	players[new_player_id] = new_player
	player_connected.emit(new_player)


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, {"name": player_info.name})


func _on_player_disconnected(id):
	player_disconnected.emit(id)
	players.erase(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_info.peer_id = peer_id
	player_connected.emit(player_info)


func _on_connected_fail():
	disconnect_from_multiplayer()


func _on_server_disconnected():
	push_warning("Connection to host was lost")
	disconnect_from_multiplayer()
	server_disconnected.emit()


func _error_to_string(error: int) -> String:
	match error:
		OK:
			return "Success"
		ERR_ALREADY_IN_USE:
			return "Peer is already active"
		ERR_CANT_CREATE:
			return "Failed to create ENet host"
		_:
			return "Unknown error: %d" % error
