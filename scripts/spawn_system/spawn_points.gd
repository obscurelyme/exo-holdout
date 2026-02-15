class_name SpawnPoints
extends Node2D

var _spawn_points: Array[Marker2D]


func _ready() -> void:
    # TODO(mackenzie): move the randomize() seed to an autoload script,
    # I don't want to have to call this
    # or do anything to ensure rand() will work per script
    randomize()
    var child_nodes = get_children()
    for child_node in child_nodes:
        if child_node is Marker2D:
            _spawn_points.append(child_node)

    print_debug("Spawn points: %d" % _spawn_points.size())


## Returns a random, known, spawn point
func get_spawn_point() -> Marker2D:
    # TODO(mackenzie): perhaps we want some spawn points to be active/inactive?
    return _spawn_points.pick_random()
