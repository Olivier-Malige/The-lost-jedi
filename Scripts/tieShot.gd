extends "_shot.gd"

const SPEED_Y = 450

func _ready():
	speedY = SPEED_Y

func is_enemy():
	return true

func _on_interceptorShot_area_enter(area):
		#Hit an enemy or asteroid
	if (area.is_in_group("player") or area.is_in_group("asteroid")):
		area._hit_something(1)
		queue_free()
