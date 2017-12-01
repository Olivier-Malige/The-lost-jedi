extends Area2D

# Member variables
var speed = -800
var shotPower = 0.5
var dir = 0

func _process(delta):
	translate(Vector2(delta*dir, delta*speed))
	if (shotPower == 0.5):
		get_node("anim").play("small")
	if (shotPower == 1):
		get_node("anim").play("normal")
	if (shotPower == 1.5):
		get_node("anim").play("big")
	if (shotPower == 2):
		get_node("anim").play("large")
	if (shotPower >= 2.5):
		get_node("anim").play("full")

func _ready():
	add_to_group("shot")
	set_process(true)

func is_enemy():
	return true

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_singleShot_area_enter( area ):
		#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area._hit_something(shotPower)
		queue_free()

