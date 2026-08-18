#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends PointLight2D
@export var range_Min: float = 0.7
@export var range_Max: float = 1
@export var delay: float = 0.02
@onready var accum = 0


func _process(delta):
	accum += delta
	if accum >= delay :
		set_energy(randf_range (range_Min,range_Max))
		accum = 0


func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	visible = false


func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	visible = true
