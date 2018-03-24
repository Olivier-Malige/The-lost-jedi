#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends "_shot.gd"
const SPEED_Y = 500
export var damage = 10
export var noDamageToGroup = ""
# Member variables

func _ready():
	speedY = SPEED_Y

func is_enemy():
	return true

func _on_shot_area_enter( area ):

	if (area.is_in_group("player") or area.is_in_group("asteroid")or area.is_in_group("enemy") and not  area.is_in_group(noDamageToGroup)) :
		if trowbackByShield :
			area.hitByPlayerShot = true
		area._hit_something(damage)
		queue_free()
