class_name SpawnPoints
extends Node2D

var _spawn_points: Array[Marker2D]

func _ready() -> void:
	var child_nodes = get_children()
	for child_node in child_nodes:
		if child_node is Marker2D:
			_spawn_points.append(child_node)

	print_debug("Spawn points: %d" % _spawn_points.size())
