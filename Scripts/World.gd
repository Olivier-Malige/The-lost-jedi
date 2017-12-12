extends Node2D

func _ready():
	if (get_node("/root/Main").coop):
		var player1 = preload("res://Prefabs/player.tscn").instance()
		var player2 = preload("res://Prefabs/player2.tscn").instance()
		player1.set_pos(get_node("playerSpawn").get_global_pos()+Vector2(-50,0))
		player2.set_pos(get_node("playerSpawn").get_global_pos()+Vector2(50,0))
		add_child(player1)
		add_child(player2)
	else :
		var player1 = preload("res://Prefabs/player.tscn").instance()
		player1.set_pos(get_node("playerSpawn").get_global_pos())
		add_child(player1)