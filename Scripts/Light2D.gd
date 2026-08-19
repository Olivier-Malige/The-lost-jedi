#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends PointLight2D
@export var range_Min: float = 0.7
@export var range_Max: float = 1
@export var delay: float = 0.08
var accum := 0.0


func _process(delta: float) -> void:
	accum += delta
	if accum >= delay:
		energy = randf_range(range_Min, range_Max)
		accum = 0


func _on_screen_exited() -> void:
	set_process(false)
	visible = false


func _on_screen_entered() -> void:
	set_process(true)
	visible = true
