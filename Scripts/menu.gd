extends Control
var menu = load("res://Scenes/menu.tscn")
var config = global.saveData.config

#Define menu options
enum {OPTION_RETURN,OPTION_CONTROLLER,OPTION_PLAYER1,OPTION_PLAYER2,OPTION_MUSIC,OPTION_SOUND,
	  OPTION_RESUME,OPTION_RESTART,OPTION_SOLO,OPTION_COOP,OPTION_OPTIONS,OPTION_HISCORE,OPTION_EXIT,OPTION_FULLSCREEN}
#Define game Mode
enum {MODE_SOLO,MODE_COOP}
#Define menu Mode
enum {MENU_START,MENU_OPTIONS,MENU_PAUSE,MENU_CONTROLLER}

func _ready():
	hide()

func set_mode(mode):
	var optionsEnable = []
	
	if mode == MENU_START:
	
		optionsEnable = [OPTION_SOLO,OPTION_COOP,OPTION_OPTIONS,OPTION_HISCORE,OPTION_EXIT]
		mode(optionsEnable)
		
	elif mode == MENU_OPTIONS :
		optionsEnable = [OPTION_MUSIC,OPTION_SOUND,OPTION_RETURN,OPTION_CONTROLLER,OPTION_FULLSCREEN]
		if get_node("/root/main").worldScreen == false :
			mode(optionsEnable)
		else : 
			mode(optionsEnable,true)
		if config.music :
			get_node("buttonGroup/music").set_text("music : on")
		else : get_node("buttonGroup/music").set_text("music : off")
		if config.sound :
			get_node("buttonGroup/sound").set_text("sound : on")
		else : get_node("buttonGroup/sound").set_text("sound : off")
		if config.fullscreen :
			get_node("buttonGroup/fullscreen").set_text("fullscreen : on")
		else : get_node("buttonGroup/fullscreen").set_text("fullscreen : off")

	elif mode == MENU_PAUSE:
		optionsEnable = [OPTION_RESUME,OPTION_OPTIONS,OPTION_RESTART,OPTION_EXIT]
		
	elif mode == MENU_CONTROLLER :
		optionsEnable = [OPTION_RETURN,OPTION_PLAYER1,OPTION_PLAYER2]
	
	#set mode done and then instantiate tweak menu
	mode(optionsEnable)

func mode (enable= [],paused = false) :
	for i in enable :
		if i ==   OPTION_RETURN : get_node("buttonGroup/return").add_to_group("enable")
		elif i == OPTION_CONTROLLER :get_node("buttonGroup/Controller").add_to_group("enable")
		elif i == OPTION_PLAYER1 :get_node("buttonGroup/player1").add_to_group("enable")
		elif i == OPTION_PLAYER2 :get_node("buttonGroup/player2").add_to_group("enable")
		elif i == OPTION_MUSIC :get_node("buttonGroup/music").add_to_group("enable")
		elif i == OPTION_SOUND :get_node("buttonGroup/sound").add_to_group("enable")
		elif i == OPTION_MUSIC :get_node("buttonGroup/music").add_to_group("enable")
		elif i == OPTION_SOUND :get_node("buttonGroup/sound").add_to_group("enable")
		elif i == OPTION_RESUME :get_node("buttonGroup/resume").add_to_group("enable")
		elif i == OPTION_RESTART :get_node("buttonGroup/restart").add_to_group("enable")
		elif i == OPTION_SOLO :get_node("buttonGroup/solo").add_to_group("enable")
		elif i == OPTION_COOP :get_node("buttonGroup/coop").add_to_group("enable")
		elif i == OPTION_OPTIONS :get_node("buttonGroup/options").add_to_group("enable")
		elif i == OPTION_HISCORE :get_node("buttonGroup/hiscore").add_to_group("enable")
		elif i == OPTION_EXIT :get_node("buttonGroup/exit").add_to_group("enable")
		elif i == OPTION_FULLSCREEN :get_node("buttonGroup/fullscreen").add_to_group("enable")
			
	for node in get_node("buttonGroup").get_children() :
		if not node.is_in_group("enable") :
			node.queue_free()
	if not paused :
		get_node("paused").queue_free()
	
	yield(get_node("optionTimer"),"timeout")
	
	#set menu visible
	show()
	#set focus of firt node in buttonGroup
	get_node("buttonGroup").get_child(0).grab_focus()
	
func start_game(mode):
	if mode == MODE_SOLO :
		get_node("/root/main").coop = false
	else : get_node("/root/main").coop = true
	get_node("/root/main").goWorldScreen()
	get_node("/root/main/start").queue_free()
	queue_free()

func _on_Solo_button_down():
	start_game(MODE_SOLO)
	
func _on_Coop_button_down():
	start_game(MODE_COOP)

func _on_Exit_button_down():
	get_tree().quit()

func _on_Resume_button_down():
	get_node("/root/main").setResume()
	queue_free()

func _on_Restart_button_down():
	get_node("/root/main").setResume()
	get_node("/root/main").setRestart()
	queue_free()

func _on_Hiscore_button_down():
	get_node("/root/main").goHiscoreScreen()
	queue_free()

func _on_options_button_down():
	new_menu(MENU_OPTIONS)

func new_menu(mode):
	var m = menu.instance()
	get_parent().add_child(m)
	m.set_mode(mode)
	queue_free()
	
func _on_return_button_down():

	if get_node("/root/main").worldScreen:
		new_menu(MENU_PAUSE)
	elif get_node("/root/main").startScreen:
		new_menu(MENU_START)

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
