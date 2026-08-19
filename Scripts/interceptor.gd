#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var shot1 = preload("res://Prefabs/interceptorSideShot.tscn").instantiate()
	var shot2 = preload("res://Prefabs/tieShot.tscn").instantiate()
	var shot3 = preload("res://Prefabs/interceptorSideShot.tscn").instantiate()
	shot1.position = $shootFrom.global_position
	shot2.position = $shootFrom.global_position
	shot3.position = $shootFrom.global_position
	get_parent().add_child(shot1)
	get_parent().add_child(shot2)
	get_parent().add_child(shot3)
	#get_node("../enemySfx").play("interceptorShot")
	shot1.rotation_degrees = -15
	shot1.speedX = -150
	shot2.speedX = 0
	shot3.rotation_degrees = 15
	shot3.speedX = 250
