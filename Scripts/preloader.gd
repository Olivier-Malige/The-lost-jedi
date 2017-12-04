extends Node2D

func _ready():
	set_process(true)
	get_node("anim").play("start")

func _process(delta):
	if Input.is_action_pressed("restart") :
		get_parent().goStartScreen()
		queue_free()

