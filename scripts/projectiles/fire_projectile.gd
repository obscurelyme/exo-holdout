class_name FireProjectile
extends Node2D

@export var projectile: PackedScene

var _locked: bool = false
@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.timeout.connect(_on_timeout)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire") and not _locked:
		var new_projectile: PulseBeam = projectile.instantiate()
		new_projectile.global_rotation = global_rotation
		new_projectile.global_position = global_position
		get_tree().root.get_node("Game").add_child(new_projectile)
		_locked = true
		_timer.start()

func _on_timeout() -> void:
	_locked = false
