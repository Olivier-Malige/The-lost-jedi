extends Control
var mode 

func _ready():
	if (mode == "start"):
		get_node("paused").queue_free()
		get_node("buttonGroup/resume").queue_free()
		get_node("buttonGroup/restart").queue_free()
		
	elif (mode == "pause"):
		get_node("buttonGroup/solo").queue_free()
		get_node("buttonGroup/coop").queue_free()
		get_node("buttonGroup/hiscore").queue_free()
		get_node("paused/AnimationPlayer").play("paused")

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

func _on_Restart_button_down():
	get_node("/root/main").setResume()
	get_node("/root/main").setRestart()
	queue_free()


func _on_Hiscore_button_down():
	get_node("/root/main").goHiscoreScreen()
	queue_free()
