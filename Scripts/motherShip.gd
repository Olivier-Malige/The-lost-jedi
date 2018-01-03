
extends "_enemy.gd"


func _on_ShootTimer_timeout():
	$sound_Shooting.playing = true
	var shot = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot1 = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot2 = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot3 = preload("res://Prefabs/motherShipShot.tscn").instance()
	shot.position = get_node("ShootPos").global_position
	shot1.position = get_node("ShootPos1").global_position
	shot2.position = get_node("ShootPos2").global_position
	shot3.position = get_node("ShootPos3").global_position
	get_node("../").add_child(shot)
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	shot.speedX = -400
	shot1.speedX  = 400
	shot2.speedX  = -40
	shot3.speedX  = 40
	#get_node("../enemySfx").play("interceptorShot")
	
func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		$droneReactorParticles4.queue_free()
		$droneReactorParticles.queue_free()
		$droneReactorParticles2.queue_free()
		$droneReactorParticles3.queue_free()
		set_process(false)
		queue_free()
		
		
	else :
		get_node("anim").play("start")


