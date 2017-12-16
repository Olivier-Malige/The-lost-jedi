extends Node2D
var coop  = false
var startScreen = false
var zoomReady = false 
var worldScreen = false
var gameOverScreen = false
var input = load("res://Scripts/input.gd")
var menu = load("res://Scenes/Menu.tscn")


var menuShow = false

func _ready():
	
	get_node("Camera2D").set_scale(Vector2 (1.5,1.5))
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process_input(true)

func _input(event):
	if (worldScreen ):
		if event.is_action_pressed("start") and not event.is_echo():
			setPause()
	if (gameOverScreen):
		goWorldScreen()
		get_node("gameOver").queue_free()

func _on_Timer_timeout():
	get_node("loader").queue_free()
	goStartScreen()

func setPause():
	if (not menuShow ):
			get_tree().set_pause(true)
			var m = menu.instance()
			m.mode = "pause"
			add_child(m)
			menuShow = true
			get_node("World/musicStream").set_paused(true)
func setRestart():
	#get_tree().reload_current_scene()
	get_node("World").free()
	goWorldScreen()
	
func setResume():
	if (worldScreen):
		menuShow = false
		get_tree().set_pause(false)
		get_node("World/musicStream").set_paused(false)

func goStartScreen():
	var m = menu.instance()
	m.mode = "start"
	add_child(m)
	var start = preload("res://Scenes/start.tscn").instance()
	add_child(start)
	startScreen = true
	if not zoomReady :
		get_node("animCamera").play("Start")
		zoomReady = true
func goHiscoreScreen():
	startScreen = false
	var hiscore = preload("res://Scenes/hiscore.tscn").instance()
	add_child(hiscore)
	get_node("/root/Main/Start").queue_free()


func goWorldScreen():
	
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
	