#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D


func _ready() -> void:
	$score_solo.set_text("Best score : " + str(global.saveData.solo.hiscore))
	$score_coop.set_text("Best score : " + str(global.saveData.coop.hiscore))
	$wave_solo.set_text("higher wave : " + str(global.saveData.solo.bestWave))
	$wave_coop.set_text("higher wave : " + str(global.saveData.coop.bestWave))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and not event.is_echo():
		get_tree().current_scene.go_Start_Screen()
		queue_free()
