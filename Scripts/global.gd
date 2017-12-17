
extends Node

# Member variables
var debug = true
var score = 0
var hiscoreSolo = 0
var hiscoreCoop = 0


const VERSION_NUMBER = "Alpha 5.1"

func _ready():
	var f = File.new()
	# Load high score
	if (f.open("user://highScoreSolo", File.READ) == OK):
		hiscoreSolo = f.get_var()
	if (f.open("user://highCoopScoreCoop", File.READ) == OK):
		hiscoreCoop = f.get_var()

