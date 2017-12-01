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
		get_node("Camera2D").set_zoom(Vector2(1.2,1.2))

func goWorldScreen():
	
	if (not worldScreenLoaded):
		var world = preload("res://Scenes/World.tscn").instance()
		add_child(world)
		worldScreenLoaded = true
		get_node("Camera2D").set_zoom(Vector2(0.9,0.9))

func goGameOverScreen():
	worldScreenLoaded = false
	var gameOver = preload("res://Scenes/gameOver.tscn").instance()
	get_node("Camera2D").set_zoom(Vector2(1.2,1.2))
	add_child(gameOver)
	