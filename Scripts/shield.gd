extends Area2D
var power = 0 setget _set_Power 
var animPower 

func _ready():
	_set_AnimPower()

func _on_shield_area_entered( shot ):

	if shot.is_in_group("enemy_Shot") and power > 0 :
		shot.trowbackByShield = true
		shot.speedY =  -shot.speedY
		shot.speedX =  -shot.speedX
		if not $AnimationPlayer.get_current_animation() == get_parent().id_player+animPower+"_Hit" :
			$AnimationPlayer.play(get_parent().id_player+animPower+"_Hit")

func _set_AnimPower():
	if power == 0 :
		visible = false
	elif power == 1 :
		animPower = "_Smallest"
		visible = true
	elif power == 2 :
		animPower = "_Small"
		visible = true
	elif power == 3 :
		animPower = "_Normal"
		visible = true
	elif power == 4 :
		animPower = "_Big"
		visible = true
	elif power == 5 :
		animPower = "_Very_Big"
		visible = true
	elif power == 6 :
		animPower = "_Full"
		visible = true

func _set_Power(up):
	power += up
	if power < 0 :
		power = 0
	elif power > 6 :
		power = 6
	_set_AnimPower()
	if power > 0 :
		$AnimationPlayer.play(get_parent().id_player +animPower)
	
	

func _on_AnimationPlayer_animation_finished(n):
	if n== get_parent().id_player+animPower+"_Hit" :
		self.power = -1