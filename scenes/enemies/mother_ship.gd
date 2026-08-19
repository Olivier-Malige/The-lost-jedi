extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var shot = ProjectilePool.spawn(preload("res://scenes/combat/mother_ship_shot.tscn"), $ShootPos.global_position, get_parent())
	var shot1 = ProjectilePool.spawn(preload("res://scenes/combat/mother_ship_shot.tscn"), $ShootPos1.global_position, get_parent())
	var shot2 = ProjectilePool.spawn(preload("res://scenes/combat/mother_ship_shot.tscn"), $ShootPos2.global_position, get_parent())
	var shot3 = ProjectilePool.spawn(preload("res://scenes/combat/mother_ship_shot.tscn"), $ShootPos3.global_position, get_parent())
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
