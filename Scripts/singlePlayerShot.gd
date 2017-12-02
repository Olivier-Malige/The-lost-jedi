extends Area2D

# Member variables
const SHOT_DMG_MAX = 3
const SHOT_DMG_BASE = 0.4
var speed = -800
var shotPower = 0.5
var dir = 0



func _process(delta):
	if (shotPower > SHOT_DMG_MAX):
		shotPower = SHOT_DMG_MAX
	translate(Vector2(delta*dir, delta*speed))
	if (shotPower >= SHOT_DMG_BASE):
		get_node("anim").play("small")
	if (shotPower >= 0.8):
		get_node("anim").play("normal")
	if (shotPower >= 1.2):
		get_node("anim").play("big")
	if (shotPower >= 1.6):
		get_node("anim").play("large")
	if (shotPower >= 2):
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
		area.touchedByPlayerShot = true
		area._hit_something(shotPower)
		queue_free()

