#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D

const DESTROY_DELAY = 1
var setScore := 0
var player := 1
func _ready() -> void:
	if setScore >= 1000:
		$Label.set_scale(Vector2(2, 2))
	elif setScore >= 500:
		$Label.set_scale(Vector2(1.8, 1.8))
	elif setScore >= 200:
		$Label.set_scale(Vector2(1.6, 1.6))
	elif setScore >= 100:
		$Label.set_scale(Vector2(1.4, 1.4))
	elif setScore >= 50:
		$Label.set_scale(Vector2(1.2, 1.2))

	$Label.set_text(str(setScore))
	$anim.play("player" + str(player))
	$destroyDelay.set_wait_time(DESTROY_DELAY)

func _on_destroyDelay_timeout() -> void:
	queue_free()
