#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var origin = $shootFrom.global_position
	var shot1 = ProjectilePool.spawn(preload("res://scenes/combat/interceptor_side_shot.tscn"), origin, get_parent())
	var shot2 = ProjectilePool.spawn(preload("res://scenes/combat/tie_shot.tscn"), origin, get_parent())
	var shot3 = ProjectilePool.spawn(preload("res://scenes/combat/interceptor_side_shot.tscn"), origin, get_parent())
	#get_node("../enemySfx").play("interceptorShot")
	shot1.rotation_degrees = -15
	shot1.speedX = -150
	shot2.speedX = 0
	shot3.rotation_degrees = 15
	shot3.speedX = 250
