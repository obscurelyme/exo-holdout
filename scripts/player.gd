class_name Player
extends CharacterBody2D

@export var speed: float = 400

var _movement_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass


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
