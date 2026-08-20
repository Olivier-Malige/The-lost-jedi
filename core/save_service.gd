class_name SaveService
extends RefCounted

const PATH := "user://data.json"

static func load_data(default_data: Dictionary) -> Dictionary:
	if not FileAccess.file_exists(PATH):
		save_data(default_data)
		return default_data.duplicate(true)
	var f := FileAccess.open(PATH, FileAccess.READ)
	if f == null:
		return default_data.duplicate(true)
	var parsed = JSON.parse_string(f.get_as_text())
	if parsed is Dictionary:
		return _merge(default_data, parsed)
	return default_data.duplicate(true)

static func save_data(data: Dictionary) -> void:
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f:
		f.store_line(JSON.stringify(data))

static func _merge(base: Dictionary, overlay: Dictionary) -> Dictionary:
	var out := base.duplicate(true)
	for key in overlay:
		if out.get(key) is Dictionary and overlay[key] is Dictionary:
			out[key] = _merge(out[key], overlay[key])
		else:
			out[key] = overlay[key]
	return out
