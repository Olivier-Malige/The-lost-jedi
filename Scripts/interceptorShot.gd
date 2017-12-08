extends "_shot.gd"
const SPEED_Y = 400
# Member variables

func _ready():
	speedY = SPEED_Y

func is_enemy():
	return true

func _on_interceptorSideShot_area_enter( area ):
	if (area.is_in_group("player") or area.is_in_group("asteroid")):
		area._hit_something(10)
		queue_free()
