
extends Node

# Member variables

var Debug = true
var score = 0
var wave = 0
var hiscoreSolo  =0
var hiscoreCoop =0
var saveData = { solo = {
						hiscore = 0 ,
						bestWave = 0,
						},
				 coop = { 
						hiscore = 0 , 
						bestWave = 0,
						},
				 config = {
						music = true,
						sound = true,
						fullscreen = true,
						player1 = "gamepad1",
						player2 = "keyboard1",
						}}
var sav_path = "user://data.json"
const VERSION_NUMBER = "Alpha 5.1"

func _ready():
#	save_Data()
	load_Data()
	setSound(saveData.config.sound)
	setMusic(saveData.config.music)

func setSound(state):
	AudioServer.set_bus_mute(2,not state)

func setMusic(state):
	AudioServer.set_bus_mute(1,not state)

func load_Data():
	var f = File.new()
	# Load all game save
	if (f.file_exists(sav_path)):
		f.open(sav_path, File.READ)
		saveData = parse_json(f.get_as_text())
		f.close()
	else :
		f.open("sav_path", File.WRITE)
		f.store_line(to_json(saveData))
		f.close()
func save_Data():
		# Save all play data
		var f = File.new()
		f.open(sav_path, File.WRITE)
		f.store_line(to_json(saveData))
		f.close()

func update_Data():
	if (get_node("/root/main").coop): 
		if (wave > saveData.coop.bestWave) :
			saveData.coop.bestWave = wave
		if (score > saveData.coop.hiscore):
			saveData.coop.hiscore = score
			save_Data()
	else :
		if (wave > saveData.solo.bestWave) :
			saveData.solo.bestWave = wave
		if (score > saveData.solo.hiscore):
			saveData.solo.hiscore = score
			save_Data()

