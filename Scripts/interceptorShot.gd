extends Area2D

# Member variables
const YSPEED = 400
var xDir =0

func _process(delta):
	translate(Vector2(delta*xDir, delta*YSPEED))

func _ready():	
	set_process(true)

func is_enemy():
	return true

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_interceptorShot_area_enter( area ):
	if (area.is_in_group("player") or area.is_in_group("asteroid")):
		area._hit_something(10)
		queue_free()