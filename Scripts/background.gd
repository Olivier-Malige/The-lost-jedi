#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends ParallaxBackground
@onready var offsetLoc_Y = 0
@onready var offsetLoc_X = 0
@export var speed_Y: int = 0
@export var speed_X: int = 0


func _process(delta):
	set_scroll_offset(Vector2(get_scroll_offset().x+offsetLoc_X,get_scroll_offset().y+offsetLoc_Y))
	offsetLoc_X = offsetLoc_X + speed_X * delta
	offsetLoc_Y = offsetLoc_Y + speed_Y * delta
