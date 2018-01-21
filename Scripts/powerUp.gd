extends Area2D
const SPEED = 100  

func _ready():
	var rndPowers = randi()%100 +1
#	var rndPowers =6   #debug
	set_process(true)
	add_to_group("powersUp")
	if (rndPowers <= 100):
		get_node("anim").play("speedUp")
	if (rndPowers <= 50):
		get_node("anim").play("laserUp")
	if (rndPowers <= 25 ):
		get_node("anim").play("lateralShot")
	if (rndPowers <= 10):
		get_node("anim").play("shieldUp")
	if (rndPowers <= 2):
		get_node("anim").play("energieUp")

func _process(delta):
	translate(Vector2(0,SPEED)*delta)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_powerUp_area_enter( area ):
	if (area.is_in_group("player")):
		if (get_node("anim").get_current_animation() == "speedUp"):
			area.increase_Speed()
			$sound_Speed_Up.playing = true
		elif (get_node("anim").get_current_animation() == "energieUp"):
			area.energy += 1
			area.update_energy()
			$sound_Energy_Up.playing = true
		elif (get_node("anim").get_current_animation() == "lateralShot"):
			area.increase_SideShot()
			$sound_Lateral_Shot.playing = true
		elif (get_node("anim").get_current_animation() == "laserUp"):
			area.increase_Shot()
			$sound_Shot_Up.playing = true
		elif (get_node("anim").get_current_animation() == "shieldUp"):
			area.increase_Shield()

		$anim.queue_free()
		$Sprite.queue_free()
		$CollisionShape2D.queue_free()


func _on_audio_finished():
	queue_free()


