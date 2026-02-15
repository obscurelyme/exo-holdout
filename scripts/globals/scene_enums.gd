extends Node

enum SceneTypes { MAIN, LOBBY, GAME, CREDITS }

var _scene_map: Dictionary[SceneTypes, String] = {
    SceneTypes.MAIN: "res://scenes/main.tscn",
    SceneTypes.LOBBY: "res://scenes/lobby.tscn",
    SceneTypes.GAME: "res://scenes/game.tscn",
    SceneTypes.CREDITS: "res://scenes/credits.tscn"
}


func get_scene(scene: SceneTypes) -> String:
    return _scene_map.get(scene)
