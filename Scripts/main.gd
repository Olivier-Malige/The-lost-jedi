extends Node
var coop  = false
var startScreen = false
var zoomReady = false 
var worldScreen = false
var gameOverScreen = false
var input = load("res://Scripts/input.gd")
var menu = load("res://Scenes/menu.tscn")
var paused = load ("res://Prefabs/paused.tscn")

var menuShow = false

func _ready():
	OS.set_window_fullscreen(global.saveData.config.fullscreen)
#	get_node("Camera2D").set_scale(Vector2 (1.5,1.5))
	set_pause_mode(PAUSE_MODE_PROCESS)


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
			var p = paused.instance()
			add_child(p)
			var m = menu.instance()
			add_child(m)
			m.set_mode(m.MENU_PAUSE)
			menuShow = true
			
			#hide background when paused(to prevent show bug)
			for i in $world.get_node("background").get_children() :
				i.hide()

func setRestart():
	get_tree().reload_current_scene()
	goWorldScreen()
	
func setResume():
	if (worldScreen):
		menuShow = false
		$paused.queue_free()
		get_tree().set_pause(false)
		
		#show background when resume paused(to prevent show bug)
		for i in $world.get_node("background").get_children() :
			i.show()

		
		#update controller config
		if coop :
			get_node("world/player").update_controller()
			get_node("world/player2").update_controller()
		else :
			get_node("world/player").update_controller()
		#get_node("world/musicStream").set_paused(false)

func goStartScreen():
	startScreen = true
	var start = preload("res://Scenes/start.tscn").instance()
	add_child(start)
#	if not zoomReady :
#		get_node("animCamera").play("Start")
#		zoomReady = true

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
#	get_node("animCamera").play("startToWorld")

func goGameOverScreen():
	gameOverScreen = true
	worldScreen = false
#	get_node("animCamera").play("worldToGameOver")
	var gameOver = preload("res://Scenes/gameOver.tscn").instance()
	add_child(gameOver)
	