extends Node

@export var player_name: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    NetworkManager.player_connected.connect(_on_player_connected)
    NetworkManager.player_disconnected.connect(_on_player_disconnected)


func _on_player_connected(player_info: NetPlayer) -> void:
    print("Player joined %d" % player_info.peer_id)
    var player_name_label: NetPlayerLabel = player_name.instantiate()
    player_name_label.net_player = player_info
    add_child(player_name_label)


func _on_player_disconnected(peer_id: int) -> void:
    print("%d" % peer_id)
    var s: Node
    for child_node in get_children():
        if child_node is NetPlayerLabel:
            if child_node.net_player.peer_id == peer_id:
                s = child_node
    if s:
        remove_child(s)
