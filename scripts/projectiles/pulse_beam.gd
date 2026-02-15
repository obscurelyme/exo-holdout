class_name PulseBeam
extends CharacterBody2D

@export var speed: float = 400
@export var damage: float = 100

@onready var _timer: Timer = $Timer


func _ready() -> void:
	velocity = Vector2.from_angle(rotation) * speed
	_timer.timeout.connect(_clean_up, CONNECT_ONE_SHOT)


func _physics_process(_delta: float) -> void:
	var collision = move_and_collide(velocity)
	if collision:
		var collider = collision.get_collider()

		# Check if the collider has a health component
		var health = collider.get_node_or_null("Attributes/Health")
		if health:
			health.hit_points -= damage

		_timer.stop()
		_clean_up()


func _clean_up() -> void:
	queue_free()
