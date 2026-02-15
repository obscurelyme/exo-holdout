class_name NetPlayerLabel
extends Label

var net_player: NetPlayer


func _ready() -> void:
	text = net_player.name
