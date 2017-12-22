extends Node2D
var coop  = false
var startScreen = false
var zoomReady = false 
var worldScreen = false
var gameOverScreen = false
var input = load("res://Scripts/input.gd")
var menu = load("res://Scenes/menu.tscn")

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
		if event.is_action_pressed("start") and not event.is_echo():
			goStartScreen()
			gameOverScreen = false
			get_node("gameOver").queue_free()

func _on_Timer_timeout():
	get_node("loader").queue_free()
	goStartScreen()

func setPause():
	if (not menuShow ):
			get_tree().set_pause(true)
			var m = menu.instance()
			add_child(m)
			m.set_mode(m.MENU_PAUSE)
			menuShow = true
			get_node("world/musicStream").set_paused(true)
func setRestart():
	get_tree().reload_current_scene()
	#get_node("world").free()
	goWorldScreen()
	
func setResume():
	if (worldScreen):
		menuShow = false
		get_tree().set_pause(false)
		get_node("world/musicStream").set_paused(false)

func goStartScreen():
	startScreen = true
	var start = preload("res://Scenes/start.tscn").instance()
	add_child(start)
	if not zoomReady :
		get_node("animCamera").play("Start")
		zoomReady = true

func goHiscoreScreen():
	startScreen = false
	var hiscore = preload("res://Scenes/hiscore.tscn").instance()
	add_child(hiscore)
	get_node("/root/main/start").queue_free()


func goWorldScreen():
	
	var world = preload("res://Scenes/world.tscn").instance()
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
	