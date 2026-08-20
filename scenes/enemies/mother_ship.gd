extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var packed = preload("res://scenes/combat/mother_ship_shot.tscn")
	for spec in [[$ShootPos, -400], [$ShootPos1, 400], [$ShootPos2, -40], [$ShootPos3, 40]]:
		_spawn_shot(packed, spec[0].global_position, spec[1])

func _on_anim_animation_finished(n: StringName) -> void:
	if n == "explode" or $anim.current_animation == "explode":
		for p in [$droneReactorParticles, $droneReactorParticles2, $droneReactorParticles3, $droneReactorParticles4]:
			p.queue_free()
		set_process(false)
		queue_free()
	else:
		$anim.play("start")
