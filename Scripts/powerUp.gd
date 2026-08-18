#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
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

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_powerUp_area_enter( area ):
	if (area.is_in_group("player")):
		var current = get_node("anim").current_animation
		if (current == "speedUp"):
			area.increase_Speed()
			$sound_Speed_Up.playing = true
		elif (current == "energieUp"):
			area.energy += 1
			area.update_energy()
			$sound_Energy_Up.playing = true
		elif (current == "lateralShot"):
			area.increase_SideShot()
			$sound_Lateral_Shot.playing = true
		elif (current == "laserUp"):
			area.increase_Shot()
			$sound_Shot_Up.playing = true
		elif (current == "shieldUp"):
			area.increase_Shield()
			$sound_Shield.playing = true

		$anim.queue_free()
		$Sprite2D.queue_free()
		$CollisionShape2D.queue_free()


func _on_audio_finished():
	queue_free()
