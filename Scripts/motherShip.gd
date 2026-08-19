#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var shot = preload("res://Prefabs/motherShipShot.tscn").instantiate()
	var shot1 = preload("res://Prefabs/motherShipShot.tscn").instantiate()
	var shot2 = preload("res://Prefabs/motherShipShot.tscn").instantiate()
	var shot3 = preload("res://Prefabs/motherShipShot.tscn").instantiate()
	shot.position = $ShootPos.global_position
	shot1.position = $ShootPos1.global_position
	shot2.position = $ShootPos2.global_position
	shot3.position = $ShootPos3.global_position
	get_parent().add_child(shot)
	get_parent().add_child(shot1)
	get_parent().add_child(shot2)
	get_parent().add_child(shot3)
	shot.speedX = -400
	shot1.speedX = 400
	shot2.speedX = -40
	shot3.speedX = 40
	#get_node("../enemySfx").play("interceptorShot")

func _on_anim_animation_finished(n: StringName) -> void:
	if n == "explode" or $anim.current_animation == "explode":
		$droneReactorParticles4.queue_free()
		$droneReactorParticles.queue_free()
		$droneReactorParticles2.queue_free()
		$droneReactorParticles3.queue_free()
		set_process(false)
		queue_free()
	else:
		$anim.play("start")
