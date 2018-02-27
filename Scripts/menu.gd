extends Control
var menu = load("res://Scenes/menu.tscn")
var config = global.saveData.config

#Define menu options
enum {OPTION_RETURN,OPTION_CONTROLLER,OPTION_PLAYER1,OPTION_PLAYER2,OPTION_MUSIC,OPTION_SOUND,
	  OPTION_RESUME,OPTION_RESTART,OPTION_SOLO,OPTION_COOP,OPTION_OPTIONS,OPTION_HISCORE,OPTION_EXIT,OPTION_FULLSCREEN,OPTION_GRAPHIC}
#Define game Mode
enum {MODE_SOLO,MODE_COOP}
#Define menu Mode
enum {MENU_START,MENU_OPTIONS,MENU_PAUSE,MENU_CONTROLLER}
var controller = ["gamepad1","gamepad2","keyboard"]

func _input(event):
	if event.is_action_pressed("ui_up") or  event.is_action_pressed("ui_down")   and not event.is_echo():
		$sound_switch.playing = true
#	if event.is_action_pressed("ui_accept"):
#		$sound_select.playing = true

func _ready():
	hide()

func set_mode(mode):
	var optionsEnable = []
	
	if mode == MENU_START:
	
		optionsEnable = [OPTION_SOLO,OPTION_COOP,OPTION_OPTIONS,OPTION_HISCORE,OPTION_EXIT]
		mode(optionsEnable)
		
	elif mode == MENU_OPTIONS :
		optionsEnable = [OPTION_MUSIC,OPTION_SOUND,OPTION_RETURN,OPTION_CONTROLLER,OPTION_FULLSCREEN,OPTION_GRAPHIC]

		if config.music :
			get_node("buttonGroup/music").set_text("music : on")
		else : get_node("buttonGroup/music").set_text("music : off")
		if config.sound :
			get_node("buttonGroup/sound").set_text("sound : on")
		else : get_node("buttonGroup/sound").set_text("sound : off")
		if config.fullscreen :
			get_node("buttonGroup/fullscreen").set_text("fullscreen : on")
		else : get_node("buttonGroup/fullscreen").set_text("fullscreen : off")
		if config.graphic == "hight" :
			get_node("buttonGroup/graphic").set_text("graphic : hight")
		else : get_node("buttonGroup/graphic").set_text("graphic : low")

	elif mode == MENU_PAUSE:
		optionsEnable = [OPTION_RESUME,OPTION_OPTIONS,OPTION_RESTART,OPTION_EXIT]
		
	elif mode == MENU_CONTROLLER :
		optionsEnable = [OPTION_RETURN,OPTION_PLAYER1,OPTION_PLAYER2]
		$buttonGroup/player1.set_text("player 1 : "+config.player1)
		$buttonGroup/player2.set_text("player 2 : "+config.player2)
	
	#set mode done and then instantiate tweak menu
	mode(optionsEnable)

func mode (enable= []) :
	for i in enable :
		match i :
			OPTION_RETURN : get_node("buttonGroup/return").add_to_group("enable")
			OPTION_CONTROLLER :get_node("buttonGroup/Controller").add_to_group("enable")
			OPTION_PLAYER1 :get_node("buttonGroup/player1").add_to_group("enable")
			OPTION_PLAYER2 :get_node("buttonGroup/player2").add_to_group("enable")
			OPTION_MUSIC :get_node("buttonGroup/music").add_to_group("enable")
			OPTION_SOUND :get_node("buttonGroup/sound").add_to_group("enable")
			OPTION_MUSIC :get_node("buttonGroup/music").add_to_group("enable")
			OPTION_SOUND :get_node("buttonGroup/sound").add_to_group("enable")
			OPTION_RESUME :get_node("buttonGroup/resume").add_to_group("enable")
			OPTION_RESTART :get_node("buttonGroup/restart").add_to_group("enable")
			OPTION_SOLO :get_node("buttonGroup/solo").add_to_group("enable")
			OPTION_COOP :get_node("buttonGroup/coop").add_to_group("enable")
			OPTION_OPTIONS :get_node("buttonGroup/options").add_to_group("enable")
			OPTION_HISCORE :get_node("buttonGroup/hiscore").add_to_group("enable")
			OPTION_EXIT :get_node("buttonGroup/exit").add_to_group("enable")
			OPTION_FULLSCREEN :get_node("buttonGroup/fullscreen").add_to_group("enable")
			OPTION_GRAPHIC :get_node("buttonGroup/graphic").add_to_group("enable")
			
	for node in get_node("buttonGroup").get_children() :
		if not node.is_in_group("enable") :
			node.queue_free()
		else :
			node.rect_size.x = 800
	
	yield(get_node("optionTimer"),"timeout")
	#initialize size for adapative vboxContenaire
	$buttonGroup.rect_size = Vector2(800,0)

	#set ororffenu visible
	show()
	#set focus of first node in buttonGroup
	get_node("buttonGroup").get_child(0).grab_focus()
	
func start_game(mode):
	if mode == MODE_SOLO :
		get_node("/root/main").coop = false
	else : get_node("/root/main").coop = true
	get_node("/root/main").go_World_Screen()
	get_node("/root/main/start").queue_free()
	queue_free()

func _on_Solo_button_down():
	if not $sound_start.is_playing():
		$sound_start.playing = true
		yield( get_node("sound_start"), "finished" )
		start_game(MODE_SOLO)
	
func _on_Coop_button_down():
	if not $sound_start.is_playing():
		$sound_start.playing = true
		yield( get_node("sound_start"), "finished" )
		start_game(MODE_COOP)

func _on_Exit_button_down():
	get_tree().quit()

func _on_Resume_button_down():
	if not $sound_start.is_playing():
		$sound_start.playing = true
		yield( get_node("sound_start"), "finished" )
		get_node("/root/main").set_Resume()
		queue_free()

func _on_Restart_button_down():
	if not $sound_start.is_playing():
		$sound_start.playing = true
		yield( get_node("sound_start"), "finished" )
		get_node("/root/main").set_Restart()
		queue_free()
	

func _on_Hiscore_button_down():
	$sound_select.playing = true
	yield( get_node("sound_select"), "finished" )
	get_node("/root/main").go_Hiscore_Screen()
	queue_free()

func _on_options_button_down():
	$sound_select.playing = true
	yield( get_node("sound_select"), "finished" )
	new_menu(MENU_OPTIONS)

func new_menu(mode):
	var m = menu.instance()
	get_parent().add_child(m)
	m.set_mode(mode)
	queue_free()
	
func _on_return_button_down():
	$sound_select.playing = true
	yield( get_node("sound_select"), "finished" )
	if get_node("/root/main").worldScreen:
		new_menu(MENU_PAUSE)
	elif get_node("/root/main").startScreen:
		new_menu(MENU_START)
	queue_free()

func _on_sound_button_down():
	var onOff 
	config.sound = not config.sound
	if config.sound :
		onOff = "on"
	else : onOff = "off"
	
	get_node("buttonGroup/sound").set_text("Sound : "+onOff)
	global.setSound(config.sound)
	global.save_Data()
func _on_music_button_down():
	var onOff 
	config.music = not config.music
	if config.music :
		onOff = "on"
	else : onOff = "off"
	get_node("buttonGroup/music").set_text("Music : "+onOff)
	global.setMusic(config.music)
	global.save_Data()

func _on_Controller_button_down():
	$sound_select.playing = true
	yield( get_node("sound_select"), "finished" )
	new_menu(MENU_CONTROLLER)


func _on_fullscreen_button_down():
	var onOff
	config.fullscreen = not config.fullscreen
	if config.fullscreen :
		onOff = "on"
		OS.set_window_fullscreen(true)
	else : 
		onOff = "off"
		OS.set_window_fullscreen(false)
	get_node("buttonGroup/fullscreen").set_text("fullscreen : "+onOff)
	global.save_Data()


func _on_player1_button_down():
	global.saveData.config.player1 = switch_controller(1)
	if global.saveData.config.player1 == global.saveData.config.player2 :
		global.saveData.config.player1 = switch_controller(1)
	$buttonGroup/player1.set_text("player 1 : "+global.saveData.config.player1)
	global.save_Data()
	


func _on_player2_button_down():
	global.saveData.config.player2 = switch_controller(2)
	if global.saveData.config.player2 == global.saveData.config.player1 :
		global.saveData.config.player2 = switch_controller(2)
	$buttonGroup/player2.set_text("player 2 : "+global.saveData.config.player2)
	global.save_Data()
	

func switch_controller(player):
	var configPlayer
	if player == 1 :
		configPlayer = global.saveData.config.player1
	elif player == 2 :
		configPlayer = global.saveData.config.player2
	
	for i in range (controller.size()) :
		if controller[i] == configPlayer :
			if configPlayer  == controller.back() :
				configPlayer = controller.front()
				return configPlayer
			else :
				configPlayer = controller[i + 1]
				return configPlayer


func _on_graphic_button_down():
	if global.saveData.config.graphic == "hight" :
		global.saveData.config.graphic = "low"
		$buttonGroup/graphic.set_text("graphic : low")
		get_node("/root/main").set_Graphic("low")
	else :
		global.saveData.config.graphic = "hight"
		$buttonGroup/graphic.set_text("graphic : hight")
		get_node("/root/main").set_Graphic("hight")
	global.save_Data()


