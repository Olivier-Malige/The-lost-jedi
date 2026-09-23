extends SceneTree

var _failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		push_error(message)

func _check_sprites(node: Node, path: String) -> void:
	if node is Sprite2D:
		var compact_laser := node.name == &"Sprite2D" and path.get_file() in ["tie_shot.tscn", "interceptor_shot.tscn", "interceptor_side_shot.tscn"]
		var expected_scale := Vector2.ONE
		if compact_laser:
			expected_scale = Vector2(0.75, 0.75)
		elif path.get_file() == "turret.tscn" and node.name == &"Sprite2D":
			expected_scale = Vector2(1.25, 1.25)
		_check(node.scale == expected_scale, path + ": " + node.name + " must retain its intended pixel scale")
	for child in node.get_children():
		_check_sprites(child, path)

func _run() -> void:
	_check(ProjectSettings.get_setting("display/window/size/viewport_width") == 640, "native width")
	_check(ProjectSettings.get_setting("display/window/size/viewport_height") == 400, "native height")
	_check(ProjectSettings.get_setting("display/window/stretch/scale_mode") == "fractional", "display must fit the available screen space")
	_check(ProjectSettings.get_setting("display/window/stretch/aspect") == "expand", "display must reveal extra background without distorting sprites")
	for directory in ["player", "enemies", "combat", "world", "ui", "menu", "main"]:
		for file in DirAccess.get_files_at("res://scenes/" + directory):
			if not file.ends_with(".tscn"):
				continue
			var path: String = "res://scenes/" + directory + "/" + file
			var scene = load(path).instantiate()
			_check_sprites(scene, path)
			scene.free()
	var stats = load("res://data/player/player_stats.tres")
	var small = load("res://scenes/enemies/asteroid.tscn").instantiate()
	var large = load("res://scenes/enemies/big_asteroid.tscn").instantiate()
	var carrier = load("res://scenes/enemies/mother_ship.tscn").instantiate()
	var standalone_turret = load("res://scenes/enemies/turret.tscn").instantiate()
	var carrier_turret = load("res://scenes/enemies/mother_ship_turret.tscn").instantiate()
	_check(small.scale == Vector2.ONE, "small asteroids must retain their native footprint")
	_check(large.scale == Vector2(2, 2), "large asteroids must visibly differ at an integer scale")
	var large_sprite: Sprite2D = large.get_node("SpriteAsteroid")
	var large_width: float = large_sprite.texture.get_width() / float(large_sprite.hframes) * large.scale.x
	_check(large_width == 64.0, "large asteroid frames must occupy 64 world pixels")
	_check(large.get_node("CollisionShape2D").shape.radius * large.scale.x == 26.0, "large asteroid collision must grow with its sprite")
	_check(small.get_node("SpriteAsteroid").hframes == 8, "small asteroid atlas must exclude obsolete hit frames")
	_check(large_sprite.hframes == 14 and large_sprite.vframes == 1, "large asteroid atlas must exclude obsolete hit frames")
	var carrier_sprite: Sprite2D = carrier.get_node("Sprite2D")
	var carrier_frame_size := carrier_sprite.texture.get_size() / Vector2(carrier_sprite.hframes, carrier_sprite.vframes)
	_check(carrier_frame_size == Vector2(48, 56), "carrier hull must use the broader production sprite")
	_check(carrier.scale == Vector2(2, 2), "carrier assembly must read as a 96 by 112 capital ship")
	_check(carrier_sprite.scale == Vector2.ONE, "carrier sprite must preserve native pixel sampling")
	_check(carrier.get_node("CollisionShape2D").shape.size * carrier.scale == Vector2(80, 96), "carrier hull collision must fit the broad hull")
	var carrier_animations: AnimationPlayer = carrier.get_node("anim")
	_check(not carrier_animations.has_animation(&"hit"), "carrier atlas must rely on the shared hit shader")
	_check(carrier.get_node("ExplosionSprite").hframes == 10, "carrier explosion must retain the authored sequence")
	_check(carrier.get_node("LeftTurretMount").position == Vector2(-14, -5) and carrier.get_node("RightTurretMount").position == Vector2(14, -5), "carrier turret mounts must align with hull sockets")
	_check(carrier.get_node("LeftFrontCannon").position == Vector2(-14, 15) and carrier.get_node("RightFrontCannon").position == Vector2(14, 15), "carrier shots must start from the two front cannon muzzles")
	var standalone_sprite: Sprite2D = standalone_turret.get_node("Sprite2D")
	_check(standalone_sprite.hframes == 8 and standalone_sprite.vframes == 6, "standalone siege turret must use its action animation sheet")
	_check(standalone_sprite.scale == Vector2(1.25, 1.25), "standalone siege turret must be slightly larger than its 32-pixel source frame")
	_check(standalone_turret.get_node("CollisionShape2D").shape.size == Vector2(28, 26), "standalone siege turret collision must fit its larger visual")
	var standalone_anim: AnimationPlayer = standalone_turret.get_node("anim")
	_check(standalone_anim.get_animation("aim_charge").track_get_key_count(0) == 6, "siege turret aim charge must play all authored frames")
	_check(standalone_anim.get_animation("ring_charge").track_get_key_count(0) == 7, "siege turret radial warning must play all authored frames")
	var turret_sprite: Sprite2D = carrier_turret.get_node("Sprite2D")
	_check(turret_sprite.scale == Vector2.ONE, "carrier-mounted turret must retain its original scale")
	var turret_frame_size := turret_sprite.texture.get_size() / Vector2(turret_sprite.hframes, turret_sprite.vframes)
	_check(turret_frame_size == Vector2(32, 32), "carrier turret source frames must retain the authored 32 by 32 grid")
	_check(carrier_turret.get_node("CollisionShape2D").shape.size == Vector2(12, 13), "carrier turret collision must cover the redesigned armored housing")
	_check(carrier_turret.get_node("shootPos").position == Vector2(0, 10), "carrier turret shots must leave from the twin barrel muzzles")
	var fragment = large.definition.drop_scene.instantiate()
	_check(fragment.scale == small.scale, "detached fragments must retain the small asteroid footprint")
	fragment.free()
	carrier_turret.free()
	standalone_turret.free()
	carrier.free()
	large.free()
	small.free()
	var world = load("res://scenes/world/world.tscn").instantiate()
	_check(world.get_node("CombatFeedback").position == Vector2(320, 200), "camera must center the native viewport")
	_check(world.get_node("CombatFeedback").zoom == Vector2.ONE, "camera must not zoom sprites")
	_check(world.get_node("hud/LeftColumn").offset_right == 104, "left HUD must have room for readable labels")
	_check(world.get_node("hud/RightColumn").offset_left == 536, "right HUD must leave the combat area clear")
	_check(world.get_node("hud/leftRail").color.a < 0.5 and world.get_node("hud/rightRail").color.a < 0.5, "HUD rails must leave the gameplay background visible")
	world._layout_for_width(960.0)
	_check(world.get_node("CombatFeedback").position.x == 480.0, "wide screens must center the fixed combat camera")
	_check(is_zero_approx(world.get_node("background").scroll_base_offset.x), "wide screens must not reveal a parallax repeat seam")
	_check(world.get_node("hud").offset.x == 160.0, "wide screens must center the fixed HUD rails")
	_check(world.get_node("hud/leftRail").offset_left == -160.0 and world.get_node("hud/leftRail").offset_right == 104.0, "wide screens must extend the left HUD background to the window edge")
	_check(world.get_node("hud/rightRail").offset_left == 536.0 and world.get_node("hud/rightRail").offset_right == 800.0, "wide screens must extend the right HUD background to the window edge")
	_check(world.get_node("playerSpawn").position.x == 480.0, "wide screens must center the fixed player spawn")
	_check(world.get_node("waveGenerator").position.x == 160.0, "wide screens must shift wave lanes with the combat area")
	for lane in range(12):
		var marker = world.get_node("waveGenerator/spawnPos" + str(lane))
		_check(marker.position.x > 104 and marker.position.x < 536, "spawn lanes must stay between HUD panels")
	world.free()
	_check(stats.bound_min == Vector2(112.5, 12) and stats.bound_max == Vector2(527.5, 392), "player must remain inside the new playfield")
	_check(is_equal_approx(stats.speed / 400.0, 360.0 / 800.0), "relative travel speed must be preserved")
	_check(stats.beam_width == 8.0 and stats.beam_overdrive_width == 16.0, "beam texels must match sprite pixels")
	for file in DirAccess.get_files_at("res://data/enemies/movement"):
		if not file.ends_with(".tres"):
			continue
		var profile = load("res://data/enemies/movement/" + file)
		_check(profile.is_valid(), file + ": movement profile must remain valid")
		_check(profile.max_x <= 640.0, file + ": movement bounds must fit native width")
	for name in ["far", "mid", "near"]:
		var texture = load("res://assets/sprites/world/gameplay_background/" + name + ".png")
		_check(texture.get_size() == Vector2(640, 450), "background must match the native parallax repeat")
	print("Native scale: ", "PASS" if _failures == 0 else "FAIL")
	quit(0 if _failures == 0 else 1)
