extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Solo_button_down():
	get_node("/root/Main").coop = false
	get_node("/root/Main").goWorldScreen()
	get_node("/root/Main/Start").queue_free()
	

func _on_Coop_button_down():
	get_node("/root/Main").coop = true
	get_node("/root/Main").goWorldScreen()
	get_node("/root/Main/Start").queue_free()


func _on_Exit_button_down():
	get_tree().quit()
