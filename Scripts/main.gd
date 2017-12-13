extends Node2D
var startScreen = false
var worldScreen = false
var gameOverScreen = false
var input = load("res://Scripts/input.gd")
var start
func _ready():
	
	start = input.new("start")
	get_node("Camera2D").set_scale(Vector2 (1.5,1.5))
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process(true)
	set_process_input(true)
	

func _input(event):
	if start.key_down():
		if (worldScreen):
				pause()
		if (startScreen):
			goWorldScreen()
			get_node("Start").queue_free()
		if (gameOverScreen):
			goWorldScreen()
			get_node("gameOver").queue_free()

func _on_Timer_timeout():
	get_node("loader").queue_free()
	goStartScreen()

func pause():
	if (worldScreen == true):
		if get_tree().is_paused():
			get_tree().set_pause(false)
			get_node("menu/paused").hide()
			get_node("World/musicStream").set_paused(false)
		else:
			get_tree().set_pause(true)
			get_node("menu/paused").show()
			get_node("World/musicStream").set_paused(true)

func goStartScreen():
	
	if (not startScreen):
		var start = preload("res://Scenes/Start.tscn").instance()
		add_child(start)
		startScreen = true
		get_node("animCamera").play("Start")

func goWorldScreen():
	
	if (not worldScreen):
		var world = preload("res://Scenes/World.tscn").instance()
		add_child(world)
		worldScreen = true
		startScreen = false
		gameOverScreen = false
		get_node("animCamera").play("startToWorld")

func goGameOverScreen():
	gameOverScreen = true
	worldScreen = false
	get_node("animCamera").play("worldToGameOver")
	var gameOver = preload("res://Scenes/gameOver.tscn").instance()
	add_child(gameOver)
	