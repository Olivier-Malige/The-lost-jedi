
extends Node

# Member variables
var debug = true
var scorePlayer1 = 0
var hiScorePlayer1 = 0
var scorePlayer2 = 0
var hiScorePlayer2 = 0
const VERSION_NUMBER = "Alpha 5"

func _ready():
	var f = File.new()
	# Load high score
	if (f.open("user://highscore", File.READ) == OK):
		hiScorePlayer1 = f.get_var()

func game_over():
	if (scorePlayer1 > hiScorePlayer1):
		hiScorePlayer1 = scorePlayer1
		# Save high score
		var f = File.new()
		f.open("user://highscore", File.WRITE)
		f.store_var(hiScorePlayer1)
