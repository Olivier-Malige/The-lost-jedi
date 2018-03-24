#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Light2D
export(float) var range_Min = 0.7
export(float) var range_Max = 1
export(float) var delay = 0.02
onready var accum = 0


func _process(delta):
	accum += delta
	if accum >= delay :
		set_energy(rand_range (range_Min,range_Max))
		accum = 0


func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	visible = false


func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	visible = true
