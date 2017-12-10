extends "_shot.gd"

const  PLAYER_SHOT_POWER = 1.5
const  PlAYER_SHOT_SPEED_Y = -1000
const  PLAYER_SHOT_POWER_MAX = 6
const  SHOT_PLAYER_ANIME =  {POWER1 = 1 , POWER2 = 2, POWER3 = 3 ,POWER4 = 4,POWER5 = 6}
var shotPower =  PLAYER_SHOT_POWER
var player 


func _ready():
	if (shotPower > PLAYER_SHOT_POWER_MAX):
		shotPower = PLAYER_SHOT_POWER_MAX
	speedY = PlAYER_SHOT_SPEED_Y
	setPowerAnim(SHOT_PLAYER_ANIME.POWER1,SHOT_PLAYER_ANIME.POWER2,
				SHOT_PLAYER_ANIME.POWER3,SHOT_PLAYER_ANIME.POWER4,SHOT_PLAYER_ANIME.POWER5,shotPower) #set sprite scale  = to power
	
func _on_playerShot_area_enter( area ):
	#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		if (player == 1):
			area.hitByPlayer1Shot = true
		else : 
			area.hitByPlayer2Shot = true
		area._hit_something(shotPower)
		queue_free()
