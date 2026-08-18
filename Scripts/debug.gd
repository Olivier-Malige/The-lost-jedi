#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D

func _ready():
	if (global.Debug):
		for child in get_children():
			child.visible = true
