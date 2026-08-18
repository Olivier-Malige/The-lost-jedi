#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node

var action = ""
var was_key_down = false
var is_held = false

func _init(p_action):
	action = p_action

func pressed():
	if Input.is_action_pressed(action):
		is_held = true
	else:
		is_held = false
		was_key_down = false
	return is_held

func key_down():
	if pressed() and not was_key_down:
		was_key_down = true
		return true
	else:
		return false
