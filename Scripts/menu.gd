extends Control
var menu = load("res://Scenes/menu.tscn")
var config = global.saveData.config

#Define menu buttons
enum {RETURN,CONTROLLER,PLAYER1,PLAYER2,MUSIC,SOUND,RESUME,RESTART,SOLO,COOP,OPTIONS,HISCORE,EXIT}
#Define game Mode
enum {MODE_SOLO,MODE_COOP}
#Define menu Mode
enum {MENU_START,MENU_OPTIONS,MENU_PAUSE,MENU_CONTROLLER}

func _ready():
	set_hidden(true)

func set_mode(mode):
	var optionsEnable = []
	
	if mode == MENU_START:
		optionsEnable = [SOLO,COOP,OPTIONS,HISCORE,EXIT]
		mode(optionsEnable)
		
	elif mode == MENU_OPTIONS :
		optionsEnable = [MUSIC,SOUND,RETURN,CONTROLLER]
		if get_node("/root/main").worldScreen == false :
			mode(optionsEnable)
		else : 
			mode(optionsEnable,true)
		if global.saveData.config.music :
			get_node("buttonGroup/music").set_text("music : on")
		else : get_node("buttonGroup/music").set_text("music : off")
		if global.saveData.config.sound :
			get_node("buttonGroup/sound").set_text("sound : on")
		else : get_node("buttonGroup/sound").set_text("sound : off")

	elif mode == MENU_PAUSE:
		optionsEnable = [RESUME,OPTIONS,RESTART,EXIT]
		
	elif mode == MENU_CONTROLLER :
		optionsEnable = [RETURN,PLAYER1,PLAYER2]
	
	#set mode done and then instantiate tweak menu
	mode(optionsEnable)

func mode (enable= [],paused = false) :
	for i in enable :
		if i == RETURN : get_node("buttonGroup/return").add_to_group("enable")
		elif i == CONTROLLER :get_node("buttonGroup/Controller").add_to_group("enable")
		elif i == PLAYER1 :get_node("buttonGroup/player1").add_to_group("enable")
		elif i == PLAYER2 :get_node("buttonGroup/player2").add_to_group("enable")
		elif i == MUSIC :get_node("buttonGroup/music").add_to_group("enable")
		elif i == SOUND :get_node("buttonGroup/sound").add_to_group("enable")
		elif i == MUSIC :get_node("buttonGroup/music").add_to_group("enable")
		elif i == SOUND :get_node("buttonGroup/sound").add_to_group("enable")
		elif i == RESUME :get_node("buttonGroup/resume").add_to_group("enable")
		elif i == RESTART :get_node("buttonGroup/restart").add_to_group("enable")
		elif i == SOLO :get_node("buttonGroup/solo").add_to_group("enable")
		elif i == COOP :get_node("buttonGroup/coop").add_to_group("enable")
		elif i == OPTIONS :get_node("buttonGroup/options").add_to_group("enable")
		elif i == HISCORE :get_node("buttonGroup/hiscore").add_to_group("enable")
		elif i == EXIT :get_node("buttonGroup/exit").add_to_group("enable")
			
	for node in get_node("buttonGroup").get_children() :
		if not node.is_in_group("enable") :
			node.queue_free()
	if not paused :
		get_node("paused").queue_free()
	yield(get_node("optionTimer"),"timeout")
	set_hidden(false)
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
