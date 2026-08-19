#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#

class_name Shot
extends Area2D

# Member variables
@export var speedY: int = 0
@export var speedX: int = 0
@export var rotate: bool = false
@export var playerShot: bool = false
var speedRotation := 20
var trowbackByShield := false


func _process(delta: float) -> void:
	if rotate:
		rotation += speedRotation
	translate(Vector2(speedX * delta, delta * speedY))

func _ready() -> void:
	if playerShot:
		add_to_group("player_Shot")
	else:
		add_to_group("enemy_Shot")


func _on_screen_exited() -> void:
	set_process(false)
	queue_free()
