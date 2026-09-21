extends SceneTree

const ELITE_DEFINITION := preload("res://data/enemies/elite_definition.tres")

var failures := 0
var stage: Node2D

func _initialize() -> void:
	stage = Node2D.new()
	root.add_child(stage)
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func make_enemy(kind: String, is_elite := false) -> Variant:
	var enemy = load("res://scenes/enemies/" + kind + ".tscn").instantiate()
	if is_elite:
		var context := EnemySpawnContext.new()
		context.elite = true
		context.elite_definition = ELITE_DEFINITION
		enemy.configure_spawn(context)
	stage.add_child(enemy)
	enemy.position = Vector2(300, 100)
	enemy.set_physics_process(false)
	enemy.set_deferred("monitoring", false)
	for timer in enemy.find_children("*", "Timer", true, false):
		timer.stop()
	for sound in enemy.find_children("*", "AudioStreamPlayer2D", true, false):
		sound.stream = null
	enemy.life = 100
	enemy.get_node("anim").advance(0.0)
	return enemy

func make_mounted_turret() -> Variant:
	var turret = load("res://scenes/enemies/mother_ship_turret.tscn").instantiate()
	stage.add_child(turret)
	turret.position = Vector2(300, 100)
	turret.set_physics_process(false)
	turret.set_deferred("monitoring", false)
	for timer in turret.find_children("*", "Timer", true, false):
		timer.stop()
	for sound in turret.find_children("*", "AudioStreamPlayer2D", true, false):
		sound.stream = null
	turret.life = 100
	turret.get_node("anim").advance(0.0)
	return turret

func check_lethal_transition(enemy: Variant, label: String) -> void:
	enemy.life = 1
	enemy._hit_something(1)
	check(enemy.destroyed, label + ": lethal damage must mark the enemy destroyed")
	check(enemy.get_node("anim").current_animation == "explode", label + ": lethal damage must keep the explosion animation")

func check_asteroid_variants(kind: String, variant_count: int) -> void:
	for variant in range(1, variant_count + 1):
		var enemy: Variant = make_enemy(kind)
		enemy.indexSprites = variant
		enemy.get_node("anim").play("start" + str(variant))
		enemy._hit_something(1)
		check(enemy.get_node("anim").current_animation == "hit" + str(variant), kind + " variant " + str(variant) + ": must play its matching hit frame")
		enemy.queue_free()
		await process_frame

func run() -> void:
	for kind in ["drone", "interceptor", "tie", "turret", "mother_ship", "asteroid", "big_asteroid"]:
		var enemy = make_enemy(kind)
		var other = make_enemy(kind)
		var sprite: Sprite2D = enemy._hit_sprite
		var animation: AnimationPlayer = enemy.get_node("anim")
		if kind in ["drone", "interceptor", "tie"]:
			check(sprite.flip_v, kind + ": nose must face down the playfield")
		if kind in ["interceptor", "tie"]:
			check(enemy.get_node("shootFrom").position.y >= 13.0, kind + ": shots must originate at the nose")
		sprite.self_modulate = Color(0.5, 0.8, 1.0)
		enemy._hit_something(1)
		check(sprite.get_instance_shader_parameter("hit_flash") == 1.0, kind + ": each hit must flash immediately")
		check(animation.current_animation.begins_with("hit"), kind + ": ordinary damage must play its authored hit animation")
		check(other._hit_sprite.get_instance_shader_parameter("hit_flash") != 1.0, kind + ": another enemy must not flash")
		await create_timer(0.08).timeout
		check(float(sprite.get_instance_shader_parameter("hit_flash")) < 1.0, kind + ": flash must fade after its white peak")
		enemy._hit_something(1)
		check(sprite.get_instance_shader_parameter("hit_flash") == 1.0, kind + ": consecutive hits must restart the flash")
		await create_timer(0.16).timeout
		check(is_zero_approx(float(sprite.get_instance_shader_parameter("hit_flash"))), kind + ": flash must fully settle")
		check(animation.current_animation.begins_with("start"), kind + ": surviving hits must return to the idle animation")
		check(sprite.self_modulate == Color(0.5, 0.8, 1.0), kind + ": flash must preserve elite tint")
		var origin: Vector2 = enemy.position
		enemy._hit_something(1, false)
		check(sprite.get_instance_shader_parameter("hit_flash") == 1.0, kind + ": beam damage must also flash")
		check(enemy.position == origin, kind + ": beam feedback must not add recoil")
		check_lethal_transition(enemy, kind)
		enemy.queue_free()
		other.queue_free()
		await process_frame
	await check_asteroid_variants("asteroid", 3)
	await check_asteroid_variants("big_asteroid", 4)
	for kind in ["drone", "interceptor", "tie", "turret", "mother_ship"]:
		var elite: Variant = make_enemy(kind, true)
		var elite_sprite: Sprite2D = elite._hit_sprite
		check(elite.elite, kind + " elite: spawn context must be applied")
		check(elite.get_node_or_null("EliteIndicator") != null, kind + " elite: indicator must be present")
		check(elite_sprite.self_modulate == ELITE_DEFINITION.outline_color, kind + " elite: outline tint must survive setup")
		elite._hit_something(1)
		check(elite_sprite.get_instance_shader_parameter("hit_flash") == 1.0, kind + " elite: hits must flash without losing identity")
		check(elite_sprite.self_modulate == ELITE_DEFINITION.outline_color, kind + " elite: hit feedback must preserve the outline tint")
		check_lethal_transition(elite, kind + " elite")
		elite.queue_free()
		await process_frame
	var mounted: Variant = make_mounted_turret()
	var mounted_sprite: Sprite2D = mounted.get_node("Sprite2D")
	var mounted_origin: Vector2 = mounted.position
	mounted._hit_something(1)
	check(mounted_sprite.get_instance_shader_parameter("hit_flash") == 1.0, "mounted turret: hits must flash independently")
	check(mounted.get_node("anim").current_animation == "hit", "mounted turret: hits must use the dedicated hit frame")
	check(mounted.position == mounted_origin, "mounted turret: hit feedback must preserve its mount position")
	check_lethal_transition(mounted, "mounted turret")
	mounted.queue_free()
	await process_frame
	for kind in ["tie_shot", "interceptor_side_shot"]:
		var shot = load("res://scenes/combat/" + kind + ".tscn").instantiate()
		var sprite: Sprite2D = shot.get_node("Sprite2D")
		var collider: CollisionShape2D = shot.get_node("CollisionShape2D")
		check(sprite.scale == Vector2.ONE, kind + ": lasers must retain native pixel scale")
		check(sprite.texture.get_height() >= 10, kind + ": laser must be long enough to read")
		check(collider.shape.size == sprite.texture.get_size(), kind + ": collision must match the new laser dimensions")
		check(collider.position == sprite.position, kind + ": collision must be centered on the laser")
		shot.free()
	print("Enemy feedback: ", "PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
