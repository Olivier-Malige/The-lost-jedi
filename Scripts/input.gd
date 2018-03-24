#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node

var action = ""
var key_down = false
var pressed = false

func _init(action):
	self.action = action

func pressed():
	if Input.is_action_pressed(action):
		pressed = true
	else:
		pressed = false
		key_down = false
	return pressed

func key_down():
	if pressed() and not key_down:
		key_down = true
		return true
	else:
		return false
