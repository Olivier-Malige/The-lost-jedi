extends Control
var mode 
var config = global.saveData.config

func _ready():
	if mode == "start":
		get_node("paused").queue_free()
		get_node("buttonGroup/resume").queue_free()
		get_node("buttonGroup/restart").queue_free()
		get_node("buttonGroup/music").queue_free()
		get_node("buttonGroup/sound").queue_free()
		get_node("buttonGroup/return").queue_free()
		get_node("buttonGroup/controller").queue_free()
	elif mode == "options" :
		if global.saveData.config.music :
			get_node("buttonGroup/music").set_text("music : on")
		else : get_node("buttonGroup/music").set_text("music : off")
		if global.saveData.config.sound :
			get_node("buttonGroup/sound").set_text("sound : on")
		else : get_node("buttonGroup/sound").set_text("sound : off")
		if get_node("/root/main").worldScreen == false :
			get_node("paused").queue_free()
		get_node("buttonGroup/resume").queue_free()
		get_node("buttonGroup/restart").queue_free()
		get_node("buttonGroup/solo").queue_free()
		get_node("buttonGroup/exit").queue_free()
		get_node("buttonGroup/coop").queue_free()
		get_node("buttonGroup/options").queue_free()
		get_node("buttonGroup/hiscore").queue_free()
	elif mode == "pause":
		get_node("buttonGroup/solo").queue_free()
		get_node("buttonGroup/coop").queue_free()
		get_node("buttonGroup/hiscore").queue_free()
		get_node("paused/AnimationPlayer").play("paused")
		get_node("buttonGroup/music").queue_free()
		get_node("buttonGroup/sound").queue_free()
		get_node("buttonGroup/return").queue_free()
		get_node("buttonGroup/controller").queue_free()

func _on_Solo_button_down():
	get_node("/root/main").coop = false
	get_node("/root/main").goWorldScreen()
	get_node("/root/main/start").queue_free()
	queue_free()
	
func _on_Coop_button_down():
	get_node("/root/main").coop = true
	get_node("/root/main").goWorldScreen()
	get_node("/root/main/start").queue_free()
	queue_free()

func _on_Exit_button_down():
	get_tree().quit()

func _on_Resume_button_down():
	get_node("/root/main").setResume()
	queue_free()

func _on_grabFocusTimer_timeout():
	if mode == "pause" :
		get_node("buttonGroup/resume").grab_focus()
	if mode == "start" :
		get_node("buttonGroup/solo").grab_focus()
	if mode == "options" :
		get_node("buttonGroup/controller").grab_focus()

func _on_Restart_button_down():
	get_node("/root/main").setResume()
	get_node("/root/main").setRestart()
	queue_free()

func _on_Hiscore_button_down():
	get_node("/root/main").goHiscoreScreen()
	queue_free()

func _on_options_button_down():
	loadMenu("options")

func _on_return_button_down():
	if get_node("/root/main").worldScreen:
		loadMenu("pause")
	elif get_node("/root/main").startScreen:
		loadMenu("start")

func loadMenu(mode,self_destroy = true) :
	var m = load("res://Scenes/menu.tscn").instance()
	m.mode = mode
	get_parent().add_child(m)
	if self_destroy :
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