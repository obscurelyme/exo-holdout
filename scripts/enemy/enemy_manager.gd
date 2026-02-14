class_name EnemyManager
extends Node

@export var grunt_enemy: PackedScene
@export var spawn_points: SpawnPoints
@export var nav_goal: Marker2D

var _parent: Node

@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.timeout.connect(_on_timeout)
	_parent = get_parent()

func _on_timeout() -> void:
	var new_enemy: GruntEnemy = grunt_enemy.instantiate()
	new_enemy.position = spawn_points.get_spawn_point().position
	new_enemy.nav_goal = nav_goal
	_parent.add_child(new_enemy)
