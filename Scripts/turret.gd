#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Enemy


func _ready() -> void:
	add_to_group("turret")
	super._ready()
	$ShotDelay.timeout.connect(_on_ShotDelay_timeout)
	$ShotDelay.start()

func _on_ShotDelay_timeout() -> void:
	if destroyed:
		return
	$sound_Shooting.playing = true
	var shot = preload("res://Prefabs/turretShot.tscn").instantiate()
	shot.position = $shootPos.global_position
	get_parent().add_child(shot)
	shot.speedX = randf_range(-150, 150)
	$ShotDelay.start()
