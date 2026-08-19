#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
class_name SaveService
extends RefCounted

const PATH := "user://data.json"

static func load_data(default_data: Dictionary) -> Dictionary:
	if FileAccess.file_exists(PATH):
		var f = FileAccess.open(PATH, FileAccess.READ)
		var parsed = JSON.parse_string(f.get_as_text())
		if parsed != null:
			return parsed
	save_data(default_data)
	return default_data

static func save_data(data: Dictionary) -> void:
	var f = FileAccess.open(PATH, FileAccess.WRITE)
	f.store_line(JSON.stringify(data))
