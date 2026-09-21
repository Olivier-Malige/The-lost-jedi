extends SceneTree

var failures := 0


func _initialize() -> void:
	call_deferred("run")


func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)


func run() -> void:
	var start = load("res://scenes/menu/start.tscn").instantiate()
	root.add_child(start)
	await process_frame
	check(start.get_node("TitleArea/TitleFrame") is PanelContainer, "title screen must frame the game identity over the moving background")
	var title_frame: PanelContainer = start.get_node("TitleArea/TitleFrame")
	var title_frame_style: StyleBoxFlat = title_frame.get_theme_stylebox("panel")
	check(title_frame_style.bg_color.a < 0.4, "title frame must leave the moving background clearly visible")
	check(start.get_node("TitleArea/TitleFrame/Margin/Content/LostWarden").text == "LOST WARDEN", "title screen must retain the game title")
	check(start.get_node("TitleArea/TitleFrame/Margin/Content/Tagline").text == "ARCADE STARFIGHTER // HOLD THE VOID", "title screen must expose the new subtitle")
	check(start.get_node("ControlsHint").visible, "title screen must show navigation guidance")
	var menu_center: CenterContainer = start.get_node("menu/Center")
	check(is_equal_approx(menu_center.offset_top, 148.0), "start menu must sit below the title frame")
	var background: ParallaxBackground = start.get_node("background")
	check(is_zero_approx(background.speed_X), "title background must not scroll horizontally")
	check(background.lock_scroll_speed and is_equal_approx(background.speed_Y, -18.0), "title background must scroll vertically at a fixed slow speed")
	root.remove_child(start)
	start.free()
	print("Start screen: ", "PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
