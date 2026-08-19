extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("start")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("start"):
		get_parent().go_Start_Screen()
		queue_free()
