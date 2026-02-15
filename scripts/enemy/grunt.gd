class_name GruntEnemy
extends CharacterBody2D

@export var speed: float = 200.0
var nav_goal: Marker2D

@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var _health_attr: AttributeHealth = $Attributes/Health


func _ready() -> void:
	if not nav_goal:
		push_warning(
			"No navigation goal found {node}:{id} will not move.".format(
				{"node": name, "id": get_instance_id()}
			)
		)
		return

	_health_attr.depleted.connect(_on_health_depleted, CONNECT_ONE_SHOT)
	_nav_agent.target_position = nav_goal.global_position
	_nav_agent.velocity_computed.connect(_on_computed_velocity)


func _physics_process(_delta: float) -> void:
	_navigate_safe()


func _navigate_safe() -> void:
	if _nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_pos: Vector2 = _nav_agent.get_next_path_position()
	_nav_agent.velocity = global_position.direction_to(next_pos) * speed


func _on_computed_velocity(safe_velocty: Vector2) -> void:
	velocity = safe_velocty
	move_and_slide()
	rotation = lerp_angle(rotation, safe_velocty.angle(), 0.1)


## NOTE: Die when health is gone
func _on_health_depleted() -> void:
	queue_free()
