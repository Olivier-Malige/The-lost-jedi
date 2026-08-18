#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends "_shot.gd"

@export var damage: float
@export var damage_Max: float
@export var power_Small: float
@export var power_Normal: float
@export var power_Big: float
@export var power_Large: float
@export var power_Full: float
var player_Id


func _ready():
	super._ready()
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
