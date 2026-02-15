class_name NetDebugLabel
extends Label


func _process(_delta: float) -> void:
    if not multiplayer.has_multiplayer_peer():
        text = "Not connected"
        return

    var t = ""
    t += "Peer ID: %s\n" % multiplayer.get_unique_id()
    t += "Is Server: %s\n" % multiplayer.is_server()
    t += "Connected Peers: %s\n" % str(multiplayer.get_peers())
    t += "Authority %s\n" % get_multiplayer_authority()
    t += "Am I the authority? %s\n" % is_multiplayer_authority()
    text = t
