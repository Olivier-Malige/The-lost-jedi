#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node2D


func _ready():

	get_node("AnimationPlayer").play("start")
	get_node("Version").set_text(global.VERSION_NUMBER)
	var m = load("res://Scenes/menu.tscn").instance()
	add_child(m)
	m.set_mode(m.MENU_START)
