
extends "_enemy.gd"


func shoot():
	var shot = preload("res://Prefabs/tieShot.tscn").instance()
	shot.position = get_node("shootFrom").global_position
	get_node("../").add_child(shot)
	#get_node("../enemySfx").play("tieShot")
	

func _on_dirTimer_timeout():
	speedX = -speedX


func _on_shootTimer_timeout():
	shoot()

