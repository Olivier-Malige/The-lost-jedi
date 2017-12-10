
extends "_enemy.gd"


func _on_ShootTimer_timeout():
	var shot = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot1 = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot2 = preload("res://Prefabs/motherShipShot.tscn").instance()
	var shot3 = preload("res://Prefabs/motherShipShot.tscn").instance()
	shot.set_pos(get_node("ShootPos").get_global_pos())
	shot1.set_pos(get_node("ShootPos1").get_global_pos())
	shot2.set_pos(get_node("ShootPos2").get_global_pos())
	shot3.set_pos(get_node("ShootPos3").get_global_pos())
	get_node("../").add_child(shot)
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	shot.speedX = -400
	shot1.speedX  = 400
	shot2.speedX  = -40
	shot3.speedX  = 40
	get_node("../enemySfx").play("interceptorShot")
	

