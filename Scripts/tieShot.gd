extends Area2D

const SPEED = 450

func _process(delta):
	translate(Vector2(0, delta*SPEED))

func _ready():
	add_to_group("shot")
	set_process(true)

func is_enemy():
	return true

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_interceptorShot_area_enter(area):
		#Hit an enemy or asteroid
	if (area.is_in_group("player") or area.is_in_group("asteroid")):
		area._hit_something(1)
		queue_free()
