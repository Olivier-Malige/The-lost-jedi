#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D
var nbr_Player = 0
func _ready():
	if (get_node("/root/main").coop):
		var player1 = preload("res://Prefabs/player.tscn").instance()
		var player2 = preload("res://Prefabs/player.tscn").instance()
		player2.set_Player_2 = true;
		player1.position = get_node("playerSpawn").global_position+Vector2(-50,0)
		player2.position = get_node("playerSpawn").global_position+Vector2(50,0)
		add_child(player1,true)
		add_child(player2,true)
		nbr_Player =2

	else :
		var player1 = preload("res://Prefabs/player.tscn").instance()
		player1.position = get_node("playerSpawn").global_position
		add_child(player1,true)
		nbr_Player =1

func _process(delta):
	if nbr_Player <=0 :
		get_node("/root/main").go_GameOver_Screen()
		queue_free()
