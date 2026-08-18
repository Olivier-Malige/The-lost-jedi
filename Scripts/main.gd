#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node
var coop  = false
var startScreen = false
var zoomReady = false
var worldScreen = false
var gameOverScreen = false
var menu = load("res://Scenes/menu.tscn")
var paused = load ("res://Prefabs/paused.tscn")

var menuShow = false
const ZOOM_OUT := Vector2(0.6, 0.6)
const ZOOM_IN := Vector2(1.0, 1.0)
var _camera_tween: Tween

func _ready():
	set_Graphic(global.saveData.config.graphic)
	get_window().mode = Window.MODE_FULLSCREEN
	global.saveData.config.fullscreen = true
	set_process_mode(PROCESS_MODE_ALWAYS)


func _input(event):

	if (worldScreen ):
		if event.is_action_pressed("start") and not event.is_echo():
			set_Pause()

		#CHEATCODE DEBUG
		if global.Debug :
			#Previous Wave
			if  event.is_action_pressed("debug_Key1") and not event.is_echo():
				get_node("world/waveGenerator").goto_Previous_Wave()
			#Next Wave
			elif event.is_action_pressed("debug_Key2") and not event.is_echo():
				get_node("world/waveGenerator").goto_Next_Wave()
			#Add Speed PowerUp
			elif event.is_action_pressed("debug_Key3") and not event.is_echo():
				if has_node("world/player") :
					get_node("world/player").increase_Speed()
				if has_node("world/player2") :
					get_node("world/player2").increase_Speed()
			#Add Power PowerUp
			elif event.is_action_pressed("debug_Key4") and not event.is_echo():
				if has_node("world/player") :
					get_node("world/player").increase_Shot()
				if has_node("world/player2") :
						get_node("world/player2").increase_Shot()
			#Add Lateral PowerUp
			elif event.is_action_pressed("debug_Key5") and not event.is_echo():
				if has_node("world/player") :
					get_node("world/player").increase_SideShot()
				if has_node("world/player2") :
					get_node("world/player2").increase_SideShot()

			#Add Shiel PowerUp
			elif event.is_action_pressed("debug_Key6") and not event.is_echo():
				if has_node("world/player") :
					get_node("world/player").increase_Shield()
				if has_node("world/player2") :
						get_node("world/player2").increase_Shield()

	if (gameOverScreen):
		if event.is_action_pressed("start") and not event.is_echo():
			go_Start_Screen()
			gameOverScreen = false
			get_node("gameOver").queue_free()

func _on_Timer_timeout():
	get_node("loader").queue_free()
	go_Start_Screen()

func set_Pause():
	if (not menuShow ):
			get_tree().paused = true
			var p = paused.instantiate()
			add_child(p)
			var m = menu.instantiate()
			add_child(m)
			m.set_mode(m.MENU_PAUSE)
			menuShow = true

			#hide background when paused(to prevent show bug)
			for i in $world.get_node("background").get_children() :
				i.hide()

func set_Restart():
	set_Resume()
	get_tree().reload_current_scene()

func set_Resume():
	if (worldScreen):
		menuShow = false
		$paused.queue_free()
		get_tree().paused = false

		#show background when resume paused(to prevent show bug)
		for i in $world.get_node("background").get_children() :
			i.show()


		#update controller config
		if coop :
			get_node("world/player").update_controller()
			get_node("world/player2").update_controller()
		else :
			get_node("world/player").update_controller()

func go_Start_Screen():
	worldScreen = false
	startScreen = true
	_tween_camera($camera_Pos_Out.position, ZOOM_OUT, 1.1)
	var start = preload("res://Scenes/start.tscn").instantiate()
	add_child(start)


func go_Hiscore_Screen():
	startScreen = false
	var hiscore = preload("res://Scenes/hiscore.tscn").instantiate()
	add_child(hiscore)
	get_node("/root/main/start").queue_free()


func go_World_Screen():
	_tween_camera($camera_Pos_In.position, ZOOM_IN, 1.15)
	var world = preload("res://Scenes/world.tscn").instantiate()
	add_child(world)
	worldScreen = true
	startScreen = false
	gameOverScreen = false

# Smoothly moves and zooms the camera between title and playfield views.
func _tween_camera(target_pos: Vector2, target_zoom: Vector2, duration: float) -> void:
	if _camera_tween:
		_camera_tween.kill()
	if $Camera2D.position.is_equal_approx(target_pos) and $Camera2D.zoom.is_equal_approx(target_zoom):
		return
	_camera_tween = create_tween().set_parallel(true)
	_camera_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	_camera_tween.tween_property($Camera2D, "position", target_pos, duration)
	_camera_tween.tween_property($Camera2D, "zoom", target_zoom, duration)


func go_GameOver_Screen():
	gameOverScreen = true
	worldScreen = false
	var gameOver = preload("res://Scenes/gameOver.tscn").instantiate()
	add_child(gameOver)

func set_Graphic(level):
		for ch in $background.get_node("Lights").get_children() :
			if level == "high" or level == "hight":
				ch.visible = true
			elif level == "low":
				ch.visible = false
