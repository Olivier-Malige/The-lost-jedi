
extends "_enemy.gd"


func _on_ShootTimer_timeout():
	var shot1 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	var shot2 = preload("res://Prefabs/tieShot.tscn").instance()
	var shot3 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	shot1.set_pos(get_node("shootFrom").get_global_pos())
	shot2.set_pos(get_node("shootFrom").get_global_pos())
	shot3.set_pos(get_node("shootFrom").get_global_pos())
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	get_node("../enemySfx").play("interceptorShot")
	shot1.set_rotd(-20)
	shot1.speedX = -200
	shot2.speedX = 0
	shot3.set_rotd(20)
	shot3.speedX = 200
	

