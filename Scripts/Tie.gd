
extends "_enemy.gd"


func shoot():
	var shot = preload("res://Prefabs/tieShot.tscn").instance()
	shot.set_pos(get_node("shootFrom").get_global_pos())
	get_node("../").add_child(shot)
	get_node("../enemySfx").play("tieShot")
	
func _on_Tie_area_enter( area ):
		if (area.has_method("_hit_something")):
			area._hit_something(3)

func _on_dirTimer_timeout():
	speedX = -speedX


func _on_shootTimer_timeout():
	shoot()
