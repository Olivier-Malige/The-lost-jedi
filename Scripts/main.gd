extends Node2D
var startScreenLoaded = false
var worldScreenLoaded = false


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Timer_timeout():
	get_node("loader").queue_free()
	goStartScreen()
	
func goStartScreen():
	
	if (not startScreenLoaded):
		var start = preload("res://Scenes/Start.tscn").instance()
		add_child(start)
		startScreenLoaded = true

func goWorldScreen():
	
	if (not worldScreenLoaded):
		var world = preload("res://Scenes/World.tscn").instance()
		add_child(world)
		worldScreenLoaded = true

func goGameOverScreen():
	worldScreenLoaded = false
	var gameOver = preload("res://Scenes/gameOver.tscn").instance()
	add_child(gameOver)
	