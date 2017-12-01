extends Area2D
const SPEED = 100
const BONUS_SPEED_PLAYER = 5 #speedUp
const BONUS_SHOT_POWER = 0.30    #damage
const BONUS_SHOT_LATERAL = 80 #degree
const BONUS_SHOT_LATERAL_POWER = 0.15 #damage


func _ready():
	var rndPowers = randi()%100 +1
	set_process(true)
	add_to_group("powersUp")
	if (rndPowers <= 100):
		get_node("anim").play("speedUp")
	if (rndPowers <= 50):
		get_node("anim").play("laserUp")
	if (rndPowers <= 25 ):
		get_node("anim").play("lateralShot")
	if (rndPowers <= 8):
		get_node("anim").play("energieUp")

func _process(delta):
	translate(Vector2(0,SPEED)*delta)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_powerUp_area_enter( area ):
	if (area.is_in_group("player")):
		if (get_node("anim").get_current_animation() == "speedUp"):
			area.bonusSpeed += BONUS_SPEED_PLAYER
			area.get_node("sfx").play("speedUp")
		if (get_node("anim").get_current_animation() == "energieUp"):
			area.energy += 1
			area.get_node("sfx").play("energieUp")
		if (get_node("anim").get_current_animation() == "lateralShot"):
			area.shotLateral = true
			area.bonusLateralShotPower += BONUS_SHOT_LATERAL_POWER
			area.get_node("sfx").play("lateralShotUp")
		if (get_node("anim").get_current_animation() == "laserUp"):
			area.shotPower += BONUS_SHOT_POWER
			area.get_node("sfx").play("shotUp")
		queue_free()
