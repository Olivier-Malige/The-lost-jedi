extends Area2D

# Member variables
var speed = -1000
var shotPower = 1.5
const SHOT_DMG_MAX = 6

func _process(delta):
	if (shotPower >= SHOT_DMG_MAX):
		shotPower = SHOT_DMG_MAX
	translate(Vector2(0, delta*speed))
	if (shotPower >= 1):
		get_node("anim").play("normal")
	if (shotPower >= 2):
		get_node("anim").play("big")
	if (shotPower >= 3):
		get_node("anim").play("veryBig")
	if (shotPower >= 5):
		get_node("anim").play("full")

func _ready():
	add_to_group("shot")
	set_process(true)

func is_enemy():
	return true

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_playerShot_area_enter( area ):
	#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area.touchedByPlayerShot = true
		area._hit_something(shotPower)
		queue_free()
