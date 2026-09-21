extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run() -> void:
	var background = load("res://scenes/world/background.tscn").instantiate()
	root.add_child(background)
	check(is_zero_approx(background.speed_Y), "loader background must start stationary")
	for layer_name in ["b3", "b2", "b1"]:
		var layer: ParallaxLayer = background.get_node(layer_name)
		var sprite: Sprite2D = layer.get_child(0)
		check(sprite.texture.get_size() == Vector2(640, 450), layer_name + ": texture must use the native 640 by 450 canvas")
		check(sprite.scale == Vector2.ONE, layer_name + ": texture must retain native pixel scale")
		check(layer.motion_mirroring == Vector2(640, 450), layer_name + ": repeat distance must match the texture")
		check(sprite.modulate == Color.WHITE and layer.modulate == Color.WHITE, layer_name + ": authored alpha must not be attenuated by a historical tint")
	background._process(0.1)
	check(is_equal_approx(background.speed_Y, 6.5), "background speed must retain the existing smooth ramp")
	background._on_player_motion_changed("player1", 1.0)
	background._process(1.0)
	check(is_equal_approx(background.speed_Y, 50.0), "forward player intent must retain maximum scroll speed")
	background._on_player_motion_changed("player2", -1.0)
	background._process(1.0)
	check(is_equal_approx(background.speed_Y, 40.0), "co-op intent must average both players before scrolling")
	background._on_player_motion_changed("player2", 1.0)
	background._process(1.0)
	var offset_before_cycles: float = background.scroll_base_offset.y
	background._process(54.0)
	var far_layer: ParallaxLayer = background.get_node("b3")
	var far_distance: float = (background.scroll_base_offset.y - offset_before_cycles) * far_layer.motion_scale.y
	check(is_equal_approx(far_distance, 1350.0), "far layer must traverse three complete 450-pixel repeats at maximum speed")
	background.queue_free()

	var themed_background = load("res://scenes/world/background.tscn").instantiate()
	themed_background.wave_theme_enabled = true
	root.add_child(themed_background)
	check(themed_background.get_node("b3/stars").texture.resource_path.ends_with("gameplay_background/far.png"), "waves 1 to 6 must retain the frozen graveyard")
	themed_background._on_wave_changed(7)
	check(themed_background.get_node("b3/stars").texture.resource_path.ends_with("gameplay_background/violet_orbit/far.png"), "waves 7 to 12 must use the violet orbit")
	themed_background._on_wave_changed(13)
	check(themed_background.get_node("b3/stars").texture.resource_path.ends_with("gameplay_background/red_rift/far.png"), "wave 13 onward must use the red rift")
	themed_background.queue_free()
	await process_frame
	print("Background: ", "PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
