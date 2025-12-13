extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene



func _on_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$CanvasLayer.hide()

func _on_join_pressed() -> void:
	#penguins public ip(harmless cause its public ip dw)
	peer.create_client("108.226.109.26", 1027)
	#if you are local
	#peer.create_client("127.0.0.1",1027)

	multiplayer.multiplayer_peer = peer
	$CanvasLayer.hide()

func add_player(id =1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)
	
@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()


func _on_resume_pressed() -> void:
	$CanvasLayer.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	exit_game(multiplayer.get_unique_id())

func pause():
	$CanvasLayer.show()
	player_scene
