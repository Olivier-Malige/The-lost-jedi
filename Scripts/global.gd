#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node

# Member variables

var Debug := false
var score := 0
var wave := 0
var hiscoreSolo := 0
var hiscoreCoop := 0
var saveData := {
	solo = {
		hiscore = 0,
		bestWave = 0,
	},
	coop = {
		hiscore = 0,
		bestWave = 0,
	},
	config = {
		music = true,
		sound = true,
		fullscreen = true,
		player1 = "gamepad1",
		player2 = "keyboard",
		graphic = "high",
	}
}
var sav_path := "user://data.json"
const VERSION_NUMBER = "Alpha 7"
func _ready() -> void:
#	save_Data()
	load_Data()
	setSound(saveData.config.sound)
	setMusic(saveData.config.music)

func setSound(state: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sounds"), not state)

func setMusic(state: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not state)

func load_Data() -> void:
	# Load all game save
	if FileAccess.file_exists(sav_path):
		var f = FileAccess.open(sav_path, FileAccess.READ)
		var parsed = JSON.parse_string(f.get_as_text())
		if parsed != null:
			saveData = parsed
	else:
		save_Data()

func save_Data() -> void:
		# Save all play data
		var f = FileAccess.open(sav_path, FileAccess.WRITE)
		f.store_line(JSON.stringify(saveData))

func update_Data() -> void:
	var mode: Dictionary = saveData.coop if get_tree().current_scene.coop else saveData.solo
	var changed := false
	if wave > mode.bestWave:
		mode.bestWave = wave
		changed = true
	if score > mode.hiscore:
		mode.hiscore = score
		changed = true
	if changed:
		save_Data()
