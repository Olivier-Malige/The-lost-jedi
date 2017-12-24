extends Node2D
var nubWave = 0
var Wave0 = {
	asteroid = [true,2],
	bigAsteroid = [false,1],
	tie = [false,1],
	interceptor=[false,1],
	drone=[true,3],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave1 = {
	asteroid = [true,2],
	bigAsteroid = [false,1],
	tie = [true,4],
	interceptor=[false,1],
	drone=[true,3],
	motherShip=[false,1],
	turret = [false,4]
	}	
var Wave2 = {
	asteroid = [true,2],
	bigAsteroid = [false,1],
	tie = [true,4],
	interceptor=[false,1],
	drone=[true,2.5],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave3 = {
	asteroid = [true,2],
	bigAsteroid = [true,1],
	tie = [true,4],
	interceptor=[false,1],
	drone=[false,1],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave4 = {
	asteroid = [true,0.3],
	bigAsteroid = [true,0.2],
	tie = [false,1],
	interceptor=[false,2],
	drone=[false,1],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave5 = {
	asteroid = [true,1],
	bigAsteroid = [true,1],
	tie = [false,1],
	interceptor=[true,3],
	drone=[true,2],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave6 = {
	asteroid = [false,1],
	bigAsteroid = [true,3],
	tie = [false,1],
	interceptor=[true,3],
	drone=[true,2],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave7 = {
	asteroid = [false,1],
	bigAsteroid = [false,1],
	tie = [true,1],
	interceptor=[true,2],
	drone=[true,5],
	motherShip=[false,1],
	turret = [false,4]
	}
var Wave8 = {
	asteroid = [false,1],
	bigAsteroid = [false,1],
	tie = [false,2],
	interceptor=[false,1],
	drone=[true,5],
	motherShip=[true,10],
	turret = [false,4]
	}
var Wave9 = {
	asteroid = [false,2],
	bigAsteroid = [false,1],
	tie = [false,2],
	interceptor=[true,4],
	drone=[true,5],
	motherShip=[true,8],
	turret = [false,4]
	}
var Wave10 = {
	asteroid = [false,0.3],
	bigAsteroid = [false,0.4],
	tie = [false,1],
	interceptor=[true,2],
	drone=[true,2],
	motherShip=[false,5],
	turret = [false,4]
	}
var Wave11 = {
	asteroid = [false,2],
	bigAsteroid = [false,2],
	tie = [false,2],
	interceptor=[true,2],
	drone=[true,2],
	motherShip=[false,5],
	turret = [true,5]
	}
var Wave12 = {
	asteroid = [false,1],
	bigAsteroid = [false,2],
	tie = [false,1],
	interceptor=[true,2],
	drone=[true,1],
	motherShip=[true,6],
	turret = [true,5]
	}
var metaWave = [Wave0,Wave1,Wave2,Wave3,Wave4,Wave5,Wave6,Wave7,Wave8,Wave9,Wave10,Wave11,Wave12]

func _ready():
	global.wave = nubWave +1
	randomize()
	spawn(metaWave[nubWave].asteroid,metaWave[nubWave].bigAsteroid,metaWave[nubWave].tie,
	metaWave[nubWave].interceptor,metaWave[nubWave].drone,metaWave[nubWave].motherShip,metaWave[nubWave].turret)
	set_process(true)
	
func _process(delta):

	get_node("../hud/wave").set_text("Wave : "+str(nubWave+1))
	
func spawn(asteroid,bigAsteroid,tie,interceptor,drone,motherShip,turret):
	if asteroid[0] :
		$asteroidSpawnTimer.start()
		$asteroidSpawnTimer.set_wait_time(asteroid[1])
#	get_node("asteroidSpawnTimer").set_active(asteroid[0])
#	get_node("asteroidSpawnTimer").set_wait_time(asteroid[1])
#	get_node("bigAsteroidSpawnTimer").set_active(bigAsteroid[0])
#	get_node("bigAsteroidSpawnTimer").set_wait_time(bigAsteroid[1])
#	get_node("tieSpawnTimer").set_active(tie[0])
#	get_node("tieSpawnTimer").set_wait_time(tie[1])
#	get_node("interceptorSpwnTimer").set_active(interceptor[0])
#	get_node("interceptorSpwnTimer").set_wait_time(interceptor[1])
#	get_node("droneSpawnTimer").set_active(drone[0])
#	get_node("droneSpawnTimer").set_wait_time(drone[1])	
#	get_node("motherShipSpawnTimer").set_active(motherShip[0])
#	get_node("motherShipSpawnTimer").set_wait_time(motherShip[1])
#	get_node("turretSpawnTimer").set_active(turret[0])
#	get_node("turretSpawnTimer").set_wait_time(turret[1])
	
func _on_asteroidSpawnTimer_timeout():
	var rndPos = randi()%11
	var asteroid = preload("res://Prefabs/Asteroid.tscn").instance()
	asteroid.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(asteroid)

func _on_tieSpawnTimer_timeout():
	var rndPos = (randi()%9)+1 
	var tie = preload("res://Prefabs/Tie.tscn").instance()
	tie.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(tie)

func _on_bigAsteroidSpawnTimer_timeout():
	var rndPos = randi()%11
	var bigAsteroid = preload("res://Prefabs/bigAsteroid.tscn").instance()
	bigAsteroid.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(bigAsteroid)

func _on_interceptorSpwnTimer_timeout():
	var rndPos = randi()%11
	var interceptor = preload("res://Prefabs/interceptor.tscn").instance()
	interceptor.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(interceptor)

func _on_droneSpawnTimer_timeout():
	var rndPos = (randi()%9)+1 
	var drone = preload("res://Prefabs/drone.tscn").instance()
	var drone1 = preload("res://Prefabs/drone.tscn").instance()
	var drone2 = preload("res://Prefabs/drone.tscn").instance()
	
	drone.position = get_node("spawnPos"+str(rndPos)).global_position
	add_child(drone)
	get_node("droneResume").start()
	yield(get_node("droneResume"),"timeout")
	
	if (rndPos+1 <= 11):
		drone1.position = get_node("spawnPos"+str(rndPos+1)).global_position
		add_child(drone1)
		get_node("droneResume").start()
		yield(get_node("droneResume"),"timeout")
	
	if (rndPos-1 >= 0):
		drone2.position =get_node("spawnPos"+str(rndPos-1)).global_position
		drone2.position =get_node("spawnPos"+str(rndPos-1)).global_position
		add_child(drone2)
	
func _on_motherShipSpawnTimer_timeout():
	var rndPos = randi()%11
	var motherShip = preload("res://Prefabs/motherShip.tscn").instance()
	motherShip.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(motherShip)
func _on_masterTimer_timeout():
	nubWave += 1
	
	#update wave  for save higter wave in hiscore
	global.wave = nubWave +1

	if (nubWave < metaWave.size()):
		spawn(metaWave[nubWave].asteroid,metaWave[nubWave].bigAsteroid,metaWave[nubWave].tie,metaWave[nubWave].interceptor,metaWave[nubWave].drone,metaWave[nubWave].motherShip,metaWave[nubWave].turret)
	
func _on_turretSpawnTimer_timeout():
	var rndPos = randi()%11
	var turret = preload("res://Prefabs/turret.tscn").instance()
	turret.position =get_node("spawnPos"+str(rndPos)).global_position
	add_child(turret)
