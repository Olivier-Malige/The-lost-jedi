
extends Node

# Member variables
var debug = true
var points = 0
var max_points = 0
var nubVersion = "Alpha 3"


func _ready():
	var f = File.new()
	# Load high score
	if (f.open("user://highscore", File.READ) == OK):
		max_points = f.get_var()


func game_over():
	if (points > max_points):
		max_points = points
		# Save high score
		var f = File.new()
		f.open("user://highscore", File.WRITE)
		f.store_var(max_points)
