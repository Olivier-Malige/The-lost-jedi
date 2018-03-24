#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends "_shot.gd"

export(float) var damage
export(float) var damage_Max
export(float) var power_Small
export(float) var power_Normal
export(float) var power_Big
export(float) var power_Large
export(float) var power_Full
var player_Id


func _ready():
	._ready()
	if (damage > damage_Max):
		damage = damage_Max


#must be calling before shot instantiate
func setPowerAnim():
	if (damage >= power_Small):
		get_node("anim").set_autoplay(player_Id  + "_small")
	if (damage >= power_Normal):
		get_node("anim").set_autoplay(player_Id   + "_normal")
	if (damage >= power_Big):
		get_node("anim").set_autoplay(player_Id   + "_big")
	if (damage >= power_Large):
		get_node("anim").set_autoplay(player_Id  + "_large")
	if (damage >= power_Full):
		get_node("anim").set_autoplay(player_Id  + "_full")


func _on_area_entered( area ):
	#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area.hitByPlayerShot = true
		area._hit_something(damage)
		queue_free()
