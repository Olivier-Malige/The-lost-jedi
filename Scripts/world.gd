#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D
var nbr_Player := 0
func _ready() -> void:
	if $music.stream:
		$music.stream.loop = true
	if get_tree().current_scene.coop:
		var player1 = preload("res://Prefabs/player.tscn").instantiate()
		var player2 = preload("res://Prefabs/player.tscn").instantiate()
		player2.set_Player_2 = true
		player1.position = $playerSpawn.global_position + Vector2(-50, 0)
		player2.position = $playerSpawn.global_position + Vector2(50, 0)
		add_child(player1, true)
		add_child(player2, true)
		nbr_Player = 2
	else:
		var player1 = preload("res://Prefabs/player.tscn").instantiate()
		player1.position = $playerSpawn.global_position
		add_child(player1, true)
		nbr_Player = 1

func _process(_delta: float) -> void:
	if nbr_Player <= 0:
		get_tree().current_scene.go_GameOver_Screen()
		queue_free()
