extends "_enemy.gd"


func _ready():
	._ready()
	add_to_group("asteroid")
		

func _hit_something(dmg):
	._hit_something(dmg)
	get_node("../enemySfx").play()
	if (life <= 0) :
		get_node("../enemySfx").play()
