extends "_shot.gd"

const  PLAYER_SHOT_POWER = 1.5
const  PlAYER_SHOT_SPEED_Y = -1000
const  PLAYER_SHOT_POWER_MAX = 6
const  SHOT_PLAYER_ANIME =  {POWER1 = 1 , POWER2 = 2, POWER3 = 3 ,POWER4 = 4,POWER5 = 6}
var shot_Power =  PLAYER_SHOT_POWER
var player 


func _ready():
	if (shot_Power > PLAYER_SHOT_POWER_MAX):
		shot_Power = PLAYER_SHOT_POWER_MAX
	speedY = PlAYER_SHOT_SPEED_Y
	setPowerAnim(SHOT_PLAYER_ANIME.POWER1,SHOT_PLAYER_ANIME.POWER2,
				SHOT_PLAYER_ANIME.POWER3,SHOT_PLAYER_ANIME.POWER4,SHOT_PLAYER_ANIME.POWER5,shot_Power) #set sprite scale  = to power
	
func _on_playerShot_area_enter( area ):
	#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area.hitByPlayerShot = true
		area._hit_something(shot_Power)
		queue_free()

