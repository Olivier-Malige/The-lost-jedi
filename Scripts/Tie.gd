#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Enemy


func shoot() -> void:
	var shot = preload("res://Prefabs/tieShot.tscn").instantiate()
	shot.position = $shootFrom.global_position
	get_parent().add_child(shot)
	$sound_Shooting.playing = true

func _on_dirTimer_timeout() -> void:
	speedX = -speedX

func _on_shootTimer_timeout() -> void:
	shoot()
