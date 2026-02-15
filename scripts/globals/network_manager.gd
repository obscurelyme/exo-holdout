extends Node

signal player_connected(net_player: NetPlayer)
signal player_disconnected(net_player: NetPlayer)
signal server_disconnected

## TODO: requires port forwarding if you want to expose this and play with friends.
## Will eventually let Steam handle this so port forwarding is not required.
const SERVER_IP: String = "192.168.1.167"
const PORT = 5290
const MAX_CONNS: int = 4

var players_loaded = 0
var player_info: NetPlayer = NetPlayer.new()
var players: Dictionary[int, NetPlayer] = {}

## Sets the name of the player to be seen by other players on the network
func set_player_name(net_player_name: String) -> void:
	player_info.name = net_player_name

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func is_multiplayer_connected() -> bool:
	return multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

func disconnect_from_multiplayer():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()

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
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(player_info)


func _on_connected_fail():
	disconnect_from_multiplayer()


func _on_server_disconnected():
	disconnect_from_multiplayer()
	players.clear()
	server_disconnected.emit()
