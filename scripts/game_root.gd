extends Node2D

const C = preload("res://scripts/game_constants.gd")
const ProfileStore = preload("res://scripts/profile_store.gd")
const WorldRuntime = preload("res://scripts/world_runtime.gd")
const PlayerVehicle = preload("res://scripts/player_vehicle.gd")

var world:WorldRuntime
var player:PlayerVehicle
var camera:Camera2D
var canvas:CanvasLayer
var dashboard:Label
var menu_panel:PanelContainer
var menu_label:Label
var buttons := {}
var mobile_controls := {}

var state := "boot"
var profile := {}
var persist_enabled := true
var run_seed := 0
var fuel := 0.0
var vehicle_damage_remaining := 0.0
var miles_driven := 0.0
var run_scrap := 0
var elapsed_seconds := 0.0
var sputter_seconds := 0.0
var run_end_reason := ""
var touch_state := {"steer": 0.0, "gas": false, "brake": false, "handbrake": false}
var simulated_controls := {}

func _ready() -> void:
	profile = ProfileStore.load_profile()
	world = WorldRuntime.new()
	world.name = "WorldRuntime"
	add_child(world)
	player = PlayerVehicle.new()
	player.name = "PlayerVehicle"
	player.visible = false
	add_child(player)
	camera = Camera2D.new()
	camera.name = "RunCamera"
	camera.enabled = true
	add_child(camera)
	_build_ui()
	show_start()

func _process(delta:float) -> void:
	if state != "running":
		return
	var controls := _read_controls()
	player.engine_multiplier = C.engine_multiplier_for(profile["upgrades"])
	var terrain := world.sample_terrain(player.global_position)
	var movement := player.apply_controls(controls, terrain, delta)
	if bool(world.metrics.get("streaming_drag_active", false)):
		player.velocity *= 0.985
	world.update_streaming(player.global_position)
	world.update_entities(player.global_position, delta)
	_handle_contacts(delta)
	_apply_run_resources(delta, terrain)
	camera.global_position = player.global_position + player.camera_lookahead()
	camera.zoom = player.camera_zoom()
	if player.impact_shake > 0.0:
		camera.offset = Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0)) * player.impact_shake
	else:
		camera.offset = Vector2.ZERO
	_update_dashboard(terrain, movement)

func show_start() -> void:
	state = "start"
	player.visible = false
	world.visible = false
	_set_menu(true, "KEEP DRIVING\nRoad Warrior Survival Expedition\n\nStart a fresh seeded run, push farther, bring Scrap home.")
	_set_button_visibility(["start", "garage"])
	_set_mobile_visible(false)
	dashboard.visible = false

func show_garage() -> void:
	state = "garage"
	player.visible = false
	world.visible = false
	var upgrades:Dictionary = profile["upgrades"]
	var text := "GARAGE\nScrap: %d\n\nFuel Tank L%d | Armor L%d | Engine L%d\nPermanent upgrades persist across fresh Run Seeds." % [
		int(profile["scrap"]),
		int(upgrades["fuel_tank"]),
		int(upgrades["armor"]),
		int(upgrades["engine"]),
	]
	_set_menu(true, text)
	_set_button_visibility(["buy_fuel_tank", "buy_armor", "buy_engine", "back"])
	_set_mobile_visible(false)
	dashboard.visible = false

func start_run(seed:int = 0) -> void:
	state = "running"
	run_seed = seed if seed != 0 else _fresh_seed()
	world.visible = true
	world.start_run(run_seed)
	player.visible = true
	player.reset_vehicle(Vector2.ZERO)
	world.update_streaming(player.global_position)
	var upgrades:Dictionary = profile["upgrades"]
	fuel = C.max_fuel_for(upgrades)
	vehicle_damage_remaining = C.max_damage_for(upgrades)
	miles_driven = 0.0
	run_scrap = 0
	elapsed_seconds = 0.0
	sputter_seconds = 0.0
	run_end_reason = ""
	_set_menu(false, "")
	_set_button_visibility([])
	_set_mobile_visible(true)
	dashboard.visible = true

func end_run(reason:String) -> void:
	if state != "running":
		return
	state = "results"
	run_end_reason = reason
	var bonus := int(floor(miles_driven / 0.25))
	var earned := run_scrap + bonus
	profile["scrap"] = int(profile["scrap"]) + earned
	profile["runs"] = int(profile.get("runs", 0)) + 1
	profile["best_miles"] = maxf(float(profile.get("best_miles", 0.0)), miles_driven)
	if persist_enabled:
		ProfileStore.save_profile(profile)
	player.visible = false
	_set_mobile_visible(false)
	dashboard.visible = false
	_set_menu(true, "RESULTS\nReason: %s\nMiles: %.2f\nScrap earned: %d\nTotal Scrap: %d" % [reason, miles_driven, earned, int(profile["scrap"])])
	_set_button_visibility(["restart", "garage"])

func buy_upgrade(upgrade:String) -> bool:
	var upgrades:Dictionary = profile["upgrades"]
	var level := int(upgrades.get(upgrade, 0))
	if level >= 3:
		return false
	var cost := C.upgrade_cost(upgrade, level)
	if int(profile["scrap"]) < cost:
		return false
	profile["scrap"] = int(profile["scrap"]) - cost
	upgrades[upgrade] = level + 1
	if persist_enabled:
		ProfileStore.save_profile(profile)
	show_garage()
	return true

func apply_pickup(kind:String) -> void:
	if kind == "fuel":
		fuel = minf(C.max_fuel_for(profile["upgrades"]), fuel + C.FUEL_PICKUP_AMOUNT)
	elif kind == "repair":
		vehicle_damage_remaining = minf(C.max_damage_for(profile["upgrades"]), vehicle_damage_remaining + C.REPAIR_PICKUP_AMOUNT)
	elif kind == "scrap":
		run_scrap += C.SCRAP_PICKUP_AMOUNT

func apply_damage(amount:float, source:String) -> void:
	vehicle_damage_remaining = maxf(0.0, vehicle_damage_remaining - amount)
	if vehicle_damage_remaining <= 0.0:
		end_run("Vehicle Damage: %s" % source)

func mobile_layout_report() -> Dictionary:
	return {
		"landscape": get_viewport_rect().size.x >= get_viewport_rect().size.y,
		"viewport": get_viewport_rect().size,
		"controls": ["steer_left", "steer_right", "gas", "brake", "handbrake"],
		"touch_sized": true,
	}

func automated_loop_proof() -> Dictionary:
	var old_persist := persist_enabled
	persist_enabled = false
	profile = ProfileStore.default_profile()
	profile["scrap"] = 25
	start_run(11111)
	var first_seed := run_seed
	apply_pickup("fuel")
	apply_damage(30.0, "proof impact")
	apply_pickup("repair")
	apply_pickup("scrap")
	miles_driven = 0.76
	end_run("proof fuel")
	var scrap_after := int(profile["scrap"])
	var bought := buy_upgrade("fuel_tank")
	start_run(22222)
	var second_seed := run_seed
	var max_fuel_after := C.max_fuel_for(profile["upgrades"])
	var ok := first_seed != second_seed and bought and int(profile["upgrades"]["fuel_tank"]) == 1 and max_fuel_after > C.MAX_FUEL and scrap_after >= 33
	persist_enabled = old_persist
	return {
		"ok": ok,
		"first_seed": first_seed,
		"second_seed": second_seed,
		"scrap_after_results": scrap_after,
		"fuel_tank_level": int(profile["upgrades"]["fuel_tank"]),
		"max_fuel_after_upgrade": max_fuel_after,
	}

func _handle_contacts(delta:float) -> void:
	for entity in world.entities_overlapping(player.global_position, 44.0):
		if entity.is_pickup():
			apply_pickup(entity.kind)
			world.mutate_marker(entity.marker_id, "collected")
		elif entity.kind == "zombie":
			if player.velocity.length() > 180.0:
				var push:Vector2 = (entity.global_position - player.global_position).normalized() * 180.0
				entity.global_position += push
				world.mutate_marker(entity.marker_id, "destroyed")
				player.apply_impact(-push * 0.25, randf_range(-0.08, 0.08))
			else:
				apply_damage(C.ZOMBIE_CONTACT_DAMAGE * delta, "zombie contact")
		elif entity.is_obstacle():
			var damage := C.obstacle_damage(entity.weight)
			var away:Vector2 = (player.global_position - entity.global_position).normalized()
			if entity.weight == "light":
				world.mutate_marker(entity.marker_id, "destroyed")
				player.apply_impact(away * 60.0, randf_range(-0.08, 0.08))
			elif entity.weight == "medium" and player.velocity.length() > 420.0:
				world.mutate_marker(entity.marker_id, "shoved")
				player.apply_impact(away * 140.0, randf_range(-0.24, 0.24))
			else:
				player.apply_impact(away * 260.0 - player.velocity * 0.4, randf_range(-0.45, 0.45))
			apply_damage(damage, entity.weight + " obstacle")

func _apply_run_resources(delta:float, terrain:int) -> void:
	elapsed_seconds += delta
	miles_driven = maxf(miles_driven, player.global_position.length() / C.PIXELS_PER_MILE)
	fuel = maxf(0.0, fuel - C.FUEL_DRAIN_PER_SECOND * delta)
	if terrain == C.TERRAIN_WATER or terrain == C.TERRAIN_BARRIER:
		apply_damage(C.WATER_OR_CLIFF_DAMAGE * delta, C.terrain_name(terrain))
	if fuel <= 0.0:
		sputter_seconds += delta
		if sputter_seconds >= C.SPUTTER_GRACE_SECONDS:
			end_run("Fuel")
	else:
		sputter_seconds = 0.0

func _read_controls() -> Dictionary:
	if not simulated_controls.is_empty():
		return simulated_controls
	var steer := 0.0
	if Input.is_action_pressed("drive_left") or bool(touch_state["steer"]) and float(touch_state["steer"]) < 0.0:
		steer -= 1.0
	if Input.is_action_pressed("drive_right") or bool(touch_state["steer"]) and float(touch_state["steer"]) > 0.0:
		steer += 1.0
	return {
		"steer": steer,
		"gas": Input.is_action_pressed("drive_gas") or bool(touch_state["gas"]),
		"brake": Input.is_action_pressed("drive_brake") or bool(touch_state["brake"]),
		"handbrake": Input.is_action_pressed("drive_handbrake") or bool(touch_state["handbrake"]),
	}

func _update_dashboard(terrain:int, movement:Dictionary) -> void:
	var counts := world.entity_counts()
	dashboard.text = "Fuel %.0f | Damage %.0f | Miles %.2f | Scrap %d | Terrain %s | Speed %.0f | Tier %d | Z %d O %d P %d" % [
		fuel,
		vehicle_damage_remaining,
		miles_driven,
		int(profile["scrap"]) + run_scrap,
		C.terrain_name(terrain),
		float(movement.get("speed", 0.0)),
		C.pressure_tier(miles_driven, elapsed_seconds),
		int(counts["zombies"]),
		int(counts["obstacles"]),
		int(counts["pickups"]),
	]

func _build_ui() -> void:
	canvas = CanvasLayer.new()
	add_child(canvas)
	dashboard = Label.new()
	dashboard.name = "Dashboard"
	dashboard.position = Vector2(18, 16)
	dashboard.add_theme_color_override("font_color", Color(0.96, 0.91, 0.78))
	canvas.add_child(dashboard)
	menu_panel = PanelContainer.new()
	menu_panel.position = Vector2(390, 120)
	menu_panel.custom_minimum_size = Vector2(500, 290)
	canvas.add_child(menu_panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	menu_panel.add_child(vbox)
	menu_label = Label.new()
	menu_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	menu_label.add_theme_font_size_override("font_size", 22)
	vbox.add_child(menu_label)
	_add_button(vbox, "start", "Start Run", func(): start_run())
	_add_button(vbox, "restart", "Restart", func(): start_run())
	_add_button(vbox, "garage", "Garage", show_garage)
	_add_button(vbox, "buy_fuel_tank", "Buy Fuel Tank", func(): buy_upgrade("fuel_tank"))
	_add_button(vbox, "buy_armor", "Buy Armor", func(): buy_upgrade("armor"))
	_add_button(vbox, "buy_engine", "Buy Engine", func(): buy_upgrade("engine"))
	_add_button(vbox, "back", "Back", show_start)
	_build_mobile_controls()

func _add_button(parent:Node, key:String, text:String, action:Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(180, 48)
	button.pressed.connect(action)
	parent.add_child(button)
	buttons[key] = button

func _build_mobile_controls() -> void:
	var names := {
		"steer_left": ["<", Vector2(46, 560)],
		"steer_right": [">", Vector2(150, 560)],
		"gas": ["GAS", Vector2(1080, 540)],
		"brake": ["BRK", Vector2(970, 585)],
		"handbrake": ["HB", Vector2(1170, 585)],
	}
	for key in names.keys():
		var button := Button.new()
		button.text = names[key][0]
		button.position = names[key][1]
		button.custom_minimum_size = Vector2(88, 72)
		button.button_down.connect(func(): _touch_button(key, true))
		button.button_up.connect(func(): _touch_button(key, false))
		canvas.add_child(button)
		mobile_controls[key] = button

func _touch_button(key:String, pressed:bool) -> void:
	match key:
		"steer_left":
			touch_state["steer"] = -1.0 if pressed else 0.0
		"steer_right":
			touch_state["steer"] = 1.0 if pressed else 0.0
		"gas":
			touch_state["gas"] = pressed
		"brake":
			touch_state["brake"] = pressed
		"handbrake":
			touch_state["handbrake"] = pressed

func _set_menu(visible:bool, text:String) -> void:
	menu_panel.visible = visible
	menu_label.text = text

func _set_button_visibility(keys:Array) -> void:
	for key in buttons.keys():
		buttons[key].visible = keys.has(key)

func _set_mobile_visible(visible:bool) -> void:
	for button in mobile_controls.values():
		button.visible = visible

func _fresh_seed() -> int:
	return int(Time.get_ticks_usec() & 0x7fffffff)
