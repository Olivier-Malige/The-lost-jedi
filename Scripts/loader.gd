#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D

func _ready():
	set_process(true)
	$AnimationPlayer.play("start")

func _process(delta):
	if Input.is_action_pressed("start") :
		get_parent().go_Start_Screen()
		queue_free()
