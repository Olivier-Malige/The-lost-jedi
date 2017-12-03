extends "_shot.gd"


const  PLAYER_SIDE_SHOT_POWER = 0.4
const  PlAYER_SIDE_SHOT_SPEED_Y = -900
const  PLAYER_SIDE_SHOT_POWER_MAX = 3
const  SHOT_SIDE_PLAYER_ANIME =  {POWER1 = 0.8 , POWER2 = 1.2, POWER3 = 1.6 ,POWER4 = 2,POWER5 = 2.4} 
var shotPower =  PLAYER_SIDE_SHOT_POWER

func _ready():
	if (shotPower > PLAYER_SIDE_SHOT_POWER_MAX):
		shotPower = PLAYER_SIDE_SHOT_POWER_MAX
	speedY = PlAYER_SIDE_SHOT_SPEED_Y
	
	setPowerAnim(SHOT_SIDE_PLAYER_ANIME.POWER1,SHOT_SIDE_PLAYER_ANIME.POWER2,
				SHOT_SIDE_PLAYER_ANIME.POWER3,SHOT_SIDE_PLAYER_ANIME.POWER4,SHOT_SIDE_PLAYER_ANIME.POWER5,shotPower) #set sprite scale  = to power

func _on_singleShot_area_enter( area ):
		#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area.touchedByPlayerShot = true
		area._hit_something(shotPower)
		queue_free()

