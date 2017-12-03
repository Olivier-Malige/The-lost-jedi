extends Node2D

func _ready():
	if (GameState.debug):
		for child in get_children():
			child.set_hidden(false)
	
