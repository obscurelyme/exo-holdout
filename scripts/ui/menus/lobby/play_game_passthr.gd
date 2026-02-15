class_name PlayGamePassThr
extends Node

@export var create_game_btn: Button
@export var join_game_btn: Button
@export var leave_game_btn: Button
@export var list: VBoxContainer
@export var player_name: TextEdit


func _ready() -> void:
	create_game_btn.button_up.connect(create_game)
	join_game_btn.button_up.connect(join_game)
	leave_game_btn.button_up.connect(leave_game)
	player_name.text_changed.connect(_on_text_changed)
	NetworkManager.server_disconnected.connect(_on_disconnect)


func create_game() -> void:
	NetworkManager.host_game()


func join_game(
	address_ip: String = NetworkManager.SERVER_IP, port: int = NetworkManager.PORT
) -> void:
	NetworkManager.join_game(address_ip, port)


func leave_game() -> void:
	if NetworkManager.is_multiplayer_connected():
		print("Disconnecting...")
		NetworkManager.disconnect_from_multiplayer()


func _exit_tree() -> void:
	if NetworkManager.server_disconnected.is_connected(_on_disconnect):
		NetworkManager.server_disconnected.disconnect(_on_disconnect)


func _on_text_changed():
	NetworkManager.set_player_name(player_name.text)


func _on_disconnect() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
