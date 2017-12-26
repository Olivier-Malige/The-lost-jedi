
extends "_enemy.gd"


func _on_ShootTimer_timeout():
	var shot1 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	var shot2 = preload("res://Prefabs/tieShot.tscn").instance()
	var shot3 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	shot1.position = get_node("shootFrom").global_position
	shot2.position = get_node("shootFrom").global_position
	shot3.position = get_node("shootFrom").global_position
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	#get_node("../enemySfx").play("interceptorShot")
	shot1.rotation = 20
	shot1.speedX = -200
	shot2.speedX = 0
	shot3.rotation =-20
	shot3.speedX = 200
	

