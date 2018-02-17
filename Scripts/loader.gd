extends Node2D

func _ready():
	set_process(true)
	$AnimationPlayer.play("start")

func _process(delta):
	if Input.is_action_pressed("start") :
		get_parent().go_Start_Screen()
		queue_free()


