#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends "_enemy.gd"


func shoot():
	var shot = preload("res://Prefabs/tieShot.tscn").instance()
	shot.position = get_node("shootFrom").global_position
	get_node("../").add_child(shot)
	$sound_Shooting.playing = true

func _on_dirTimer_timeout():
	speedX = -speedX

func _on_shootTimer_timeout():
	shoot()
