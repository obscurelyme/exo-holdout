class_name Player
extends CharacterBody2D

@export var speed: float = 400
var peer_id: int = 0

var _movement_dir: Vector2 = Vector2.ZERO
@onready var _health_attr: AttributeHealth = $Attributes/Health
@onready var _camera: Camera2D = $Camera2D
# @onready var _sync: MultiplayerSynchronizer = $MultiplayerSynchronizer


func _enter_tree() -> void:
	# Extract peer_id from node name (format: "Player_123")
	# This works on clients where peer_id property hasn't synced yet
	if peer_id == 0:
		peer_id = int(name.get_slice("_", 1))
	set_multiplayer_authority(peer_id)


## Enables the camera if we are the multiplayer authority
func enable_camera() -> void:
	if is_multiplayer_authority():
		_camera.enabled = true


func _ready() -> void:
	_health_attr.depleted.connect(_on_health_depleted)
	enable_camera()
	print(
		"Player",
		name,
		" authority:",
		get_multiplayer_authority(),
		" local:",
		multiplayer.get_unique_id()
	)


func _process(_delta: float) -> void:
	velocity = _movement_dir * speed


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		# Movement
		_movement_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

		# Rotation
		look_at(get_global_mouse_position())
		move_and_slide()


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("special_1"):
			print("Special Ability #1")


func _on_health_depleted() -> void:
	## TODO: Player should be allowed to spectate other players in the scene while dead
	## for now just go back to the lobby to reset the game.
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
