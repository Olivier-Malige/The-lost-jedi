
extends Node

# Member variables
var debug = true
var score = 0
var hiscoreSolo = 0
var hiscoreCoop = 0


const VERSION_NUMBER = "Alpha 5"

func _ready():
	var f = File.new()
	# Load high score
	if (f.open("user://highScoreSolo", File.READ) == OK):
		hiscoreSolo = f.get_var()
	if (f.open("user://highCoopScoreCoop", File.READ) == OK):
		hiscoreCoop = f.get_var()
func game_over():
	if (get_node("/root/Main").coop): 
		if (score > hiscoreCoop):
			hiscoreCoop = score
			# Save high score
			var f = File.new()
			f.open("user://highScoreCoop", File.WRITE)
			f.store_var(hiscoreSolo)
	else :
		if (score > hiscoreSolo):
			hiscoreSolo = score
			# Save high score
			var f = File.new()
			f.open("user://highScore", File.WRITE)
			f.store_var(hiscoreSolo)
