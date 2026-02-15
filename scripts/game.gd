class_name GameScript
extends Node

@export var player_scene: PackedScene
@export var mini_map: MiniMapCame

@onready var _multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner


func _ready() -> void:
	if multiplayer.is_server():
		NetworkManager.player_loaded()
	else:
		NetworkManager.player_loaded.rpc_id(NetworkManager.HOST_PEER_ID)


func start_game() -> void:
	print("Game has started!")
	spawn_all_players()


func spawn_all_players() -> void:
	# NOTE: spawn all the clients
	for peer_id in multiplayer.get_peers():
		_spawn_player(peer_id)
	# NOTE: spawn host
	_spawn_player(multiplayer.get_unique_id())


func _spawn_player(peer_id: int) -> void:
	print("Spawning player", peer_id, "on", multiplayer.get_unique_id())
	var player = player_scene.instantiate()
	player.peer_id = peer_id
	player.name = "Player_%d" % peer_id
	_multiplayer_spawner.get_node(_multiplayer_spawner.spawn_path).add_child(player, true)
	if peer_id == multiplayer.get_unique_id():
		mini_map.player = player
		mini_map.camera_2d.enabled = true
