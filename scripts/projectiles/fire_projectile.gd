class_name FireProjectile
extends Node2D

@export var projectile: PackedScene

var _spawner: MultiplayerSpawner
var _locked: bool = false
@onready var _timer: Timer = $Timer


func _ready() -> void:
	_timer.timeout.connect(_on_timeout)
	_spawner = get_tree().current_scene.get_node("%MultiplayerProjectileSpawner")


func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		if Input.is_action_pressed("fire") and not _locked:
			if multiplayer.is_server():
				_spawn_projectile(global_position, global_rotation)
			else:
				_request_spawn.rpc_id(NetworkManager.HOST_PEER_ID, global_position, global_rotation)
			_locked = true
			_timer.start()


@rpc("any_peer", "reliable")
func _request_spawn(pos: Vector2, rot: float) -> void:
	if multiplayer.is_server():
		_spawn_projectile(pos, rot)


func _spawn_projectile(pos: Vector2, rot: float) -> void:
	var new_projectile: PulseBeam = projectile.instantiate()
	new_projectile.global_rotation = rot
	new_projectile.global_position = pos
	_spawner.get_node(_spawner.spawn_path).add_child(new_projectile, true)


func _on_timeout() -> void:
	_locked = false
