#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#

extends Area2D

# Member variables
export(int) var speedY = 0
export(int) var speedX = 0
export(bool) var rotate = false
export(bool) var playerShot = false
var speedRotation = 20
var trowbackByShield = false


func _process(delta):
	if (rotate):
		rotation += speedRotation
	translate(Vector2(speedX*delta, delta*speedY))

func _ready():
	if playerShot :
		add_to_group("player_Shot")
	else :
		add_to_group("enemy_Shot")


func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	queue_free()
