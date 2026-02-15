class_name Player
extends CharacterBody2D

@export var speed: float = 400

var _movement_dir: Vector2 = Vector2.ZERO
@onready var _health_attr: AttributeHealth = $Attributes/Health


func _ready() -> void:
	_health_attr.depleted.connect(_on_health_depleted)


func _process(_delta: float) -> void:
	velocity = _movement_dir * speed

func _physics_process(_delta: float) -> void:
	# Movement
	_movement_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Rotation
	look_at(get_global_mouse_position())
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("special_1"):
		print("Special Ability #1")

func _on_health_depleted() -> void:
	## TODO: Player should be allowed to spectate other players in the scene while dead
	## for now just go back to the lobby to reset the game.
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
