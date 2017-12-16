extends Control
var mode 

func _ready():
	if (mode == "start"):
		get_node("Paused").queue_free()
		get_node("ButtonGroup/Resume").queue_free()
		get_node("ButtonGroup/Restart").queue_free()
		
	elif (mode == "pause"):
		get_node("ButtonGroup/Solo").queue_free()
		get_node("ButtonGroup/Coop").queue_free()
		get_node("ButtonGroup/Hiscore").queue_free()
		get_node("Paused/AnimationPlayer").play("paused")

func _on_Solo_button_down():
	get_node("/root/Main").coop = false
	get_node("/root/Main").goWorldScreen()
	get_node("/root/Main/Start").queue_free()
	queue_free()
	
func _on_Coop_button_down():
	get_node("/root/Main").coop = true
	get_node("/root/Main").goWorldScreen()
	get_node("/root/Main/Start").queue_free()
	queue_free()

func _on_Exit_button_down():
	get_tree().quit()

func _on_Resume_button_down():
	get_node("/root/Main").setResume()
	queue_free()

func _on_grabFocusTimer_timeout():
	if mode == "pause" :
		get_node("ButtonGroup/Resume").grab_focus()
	if mode == "start" :
		get_node("ButtonGroup/Solo").grab_focus()

func _on_Restart_button_down():
	get_node("/root/Main").setResume()
	get_node("/root/Main").setRestart()
	queue_free()


func _on_Hiscore_button_down():
	get_node("/root/Main").goHiscoreScreen()
	queue_free()
