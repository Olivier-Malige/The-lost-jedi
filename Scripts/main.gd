extends Node2D
var startScreenLoaded = false
var worldScreenLoaded = false
func _ready():
	get_node("Camera2D").set_scale(Vector2 (1.5,1.5))

func _on_Timer_timeout():
	get_node("loader").queue_free()
	goStartScreen()
	
func goStartScreen():
	
	if (not startScreenLoaded):
		var start = preload("res://Scenes/Start.tscn").instance()
		add_child(start)
		startScreenLoaded = true
		get_node("animCamera").play("Start")


func goWorldScreen():
	
	if (not worldScreenLoaded):
		var world = preload("res://Scenes/World.tscn").instance()
		add_child(world)
		worldScreenLoaded = true
		get_node("animCamera").play("startToWorld")

func goGameOverScreen():
	worldScreenLoaded = false
	get_node("animCamera").play("worldToGameOver")
	var gameOver = preload("res://Scenes/gameOver.tscn").instance()
	add_child(gameOver)
	