extends Node

@export var player_name: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)


func _on_player_connected(player_info: NetPlayer) -> void:
	print("Player joined")
	var player_name_label: Label = player_name.instantiate()
	player_name_label.text = "{name}-{id}".format(
		{"name": player_info.name, "id": player_info.peer_id}
	)
	add_child(player_name_label)


func _on_player_disconnected(peer_id: int) -> void:
	print("%d" % peer_id)
	var s: Node
	for child_node in get_children():
		if child_node is Label:
			if child_node.text.contains("%d" % peer_id):
				s = child_node
	if s:
		remove_child(s)
