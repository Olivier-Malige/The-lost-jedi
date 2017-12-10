
extends "_enemy.gd"
 
func _hit_something(dmg):
	._hit_something(dmg)
	get_node("anim").play("hit")

