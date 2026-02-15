class_name AttributeHealth
extends Node

signal depleted

@export var max_health: float = 100

var hit_points: float:
    set(value):
        _health = clampf(value, 0, max_health)
        if _health == 0:
            depleted.emit()
    get:
        return _health

var _health: float


func _ready() -> void:
    hit_points = max_health
