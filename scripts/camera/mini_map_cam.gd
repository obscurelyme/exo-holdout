class_name MiniMapCame
extends SubViewport

@export var player: Player
@export var camera_2d: Camera2D


func _ready() -> void:
	world_2d = get_tree().root.world_2d


func _physics_process(_delta: float) -> void:
	camera_2d.position = player.position
