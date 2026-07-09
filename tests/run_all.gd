extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const WorldGenerator = preload("res://scripts/world_generator.gd")
const WorldRuntime = preload("res://scripts/world_runtime.gd")
const PlayerVehicle = preload("res://scripts/player_vehicle.gd")
const GameRoot = preload("res://scripts/game_root.gd")
const ProfileStore = preload("res://scripts/profile_store.gd")
const RunProgression = preload("res://scripts/run_progression.gd")

var failures := []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_project_shell()
	_test_deterministic_chunks()
	_test_streaming_and_mutations()
	_test_routes_and_barriers()
	_test_vehicle_controls()
	_test_run_progression_rules()
	_test_combat_resource_progression()
	_test_garage_upgrade_clarity()
	_test_first_minute_run_trust()
	_test_mobile_layout()
	if failures.is_empty():
		print("ALL_KEEP_DRIVING_PROOFS_PASSED")
		await process_frame
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		await process_frame
		quit(1)

func _expect(condition:bool, message:String) -> void:
	if not condition:
		failures.append(message)

func _test_project_shell() -> void:
	_expect(FileAccess.file_exists("res://project.godot"), "project.godot must exist")
	_expect(ResourceLoader.exists("res://scenes/main.tscn"), "main scene must exist")

func _test_deterministic_chunks() -> void:
	var a := WorldGenerator.generate_chunk(12345, Vector2i(0, 0))
	var b := WorldGenerator.generate_chunk(12345, Vector2i(0, 0))
	var c := WorldGenerator.generate_chunk(54321, Vector2i(0, 0))
	_expect(int(a["proof_hash"]) == int(b["proof_hash"]), "same seed/chunk must hash identically")
	_expect(int(a["proof_hash"]) != int(c["proof_hash"]), "different seeds must change origin chunk")
	_expect(a["spawn_markers"].size() <= C.MARKERS_PER_CHUNK, "spawn markers must stay capped")

func _test_streaming_and_mutations() -> void:
	var world := WorldRuntime.new()
	world.render_chunks = false
	root.add_child(world)
	world.start_run(777)
	for i in range(90):
		world.update_streaming(Vector2(i * 220.0, i * 96.0))
		_expect(int(world.metrics["active_chunk_count"]) <= 25, "active chunk budget exceeded")
		_expect(int(world.metrics["preloaded_chunk_count"]) <= 49, "preload chunk budget exceeded")
	var data := WorldGenerator.generate_chunk(777, Vector2i(1, 1))
	if not data["spawn_markers"].is_empty():
		var id := str(data["spawn_markers"][0]["id"])
		world.mutate_marker(id, "collected")
		world.update_streaming(Vector2(0, 0))
		world.update_streaming(Vector2(C.CHUNK_WORLD_SIZE * 1.2, C.CHUNK_WORLD_SIZE * 1.2))
		_expect(world.run_mutations.has(id), "run mutation must persist after unload/reload")
	world.queue_free()

func _test_routes_and_barriers() -> void:
	var result := WorldGenerator.validate_adjacent_continuity(999, Vector2i(4, -2))
	_expect(bool(result["ok"]), "adjacent route exits must match: %s" % str(result["failures"]))
	var data := WorldGenerator.generate_chunk(999, Vector2i(2, 2))
	var terrain:PackedByteArray = data["terrain"]
	var route_count := 0
	var water_or_barrier := 0
	for id in terrain:
		if int(id) == C.TERRAIN_ROAD or int(id) == C.TERRAIN_DIRT_PATH or int(id) == C.TERRAIN_ROUGH:
			route_count += 1
		if int(id) == C.TERRAIN_WATER or int(id) == C.TERRAIN_BARRIER:
			water_or_barrier += 1
	_expect(route_count > 80, "chunk must contain enough route/offroad trace cells")
	_expect(water_or_barrier > 0, "world must contain traversal barriers")

func _test_vehicle_controls() -> void:
	var car := PlayerVehicle.new()
	root.add_child(car)
	car.reset_vehicle()
	var road := car.apply_controls({"steer": 0.0, "gas": true, "brake": false, "handbrake": false}, C.TERRAIN_ROAD, 1.0)
	car.reset_vehicle()
	var rough := car.apply_controls({"steer": 0.0, "gas": true, "brake": false, "handbrake": false}, C.TERRAIN_ROUGH, 1.0)
	_expect(float(road["speed"]) > float(rough["speed"]), "road must be faster than rough offroad")
	car.reset_vehicle()
	var drift := car.apply_controls({"steer": 1.0, "gas": true, "brake": false, "handbrake": true}, C.TERRAIN_DIRT_PATH, 0.5)
	_expect(bool(drift["handbrake"]), "handbrake state must be reported")
	_expect(car.camera_zoom().x < 1.0 or car.camera_lookahead().length() > 0.0, "camera must respond to speed")
	car.reset_vehicle()
	car.velocity = Vector2.LEFT * 160.0
	car.apply_controls({"steer": 1.0, "gas": false, "brake": true, "handbrake": false}, C.TERRAIN_ROAD, 0.25)
	_expect(car.rotation < 0.0, "right steering while reversing must rotate opposite the forward direction")
	car.reset_vehicle()
	car.velocity = Vector2.RIGHT * 160.0
	car.apply_controls({"steer": 1.0, "gas": false, "brake": true, "handbrake": false}, C.TERRAIN_ROAD, 0.1)
	_expect(car.rotation > 0.0, "right steering while still braking forward must not invert")
	car.reset_vehicle()
	car.apply_controls({"steer": 1.0, "gas": false, "brake": true, "handbrake": false}, C.TERRAIN_ROAD, 0.25)
	_expect(car.rotation < 0.0, "right steering from reverse throttle must invert once the car moves backward")
	car.apply_impact(Vector2(200, 0), 0.3)
	_expect(car.impact_shake > 0.0 and absf(car.rotation) > 0.0, "collision impact must shake and rotate")
	car.queue_free()

func _test_run_progression_rules() -> void:
	var progression := RunProgression.new(_test_profile(25, 0, 0, 0))
	var run := progression.start_run(2468)
	_expect(int(run["run_seed"]) == 2468, "Run Progression must retain the supplied Run Seed")
	_expect(float(run["fuel"]) == C.MAX_FUEL, "Run Progression must initialize Fuel from Driver Profile upgrades")
	_expect(float(run["vehicle_damage_remaining"]) == C.MAX_VEHICLE_DAMAGE, "Run Progression must initialize Vehicle Damage from Driver Profile upgrades")
	var garage := progression.garage_fact("fuel_tank")
	_expect(int(garage["level"]) == 0, "Run Progression must expose Permanent Upgrade level")
	_expect(int(garage["cost"]) == 20, "Run Progression must expose next Garage cost")
	_expect(bool(garage["affordable"]), "Run Progression must expose Garage affordability")
	_expect(int(garage["missing_scrap"]) == 0, "Run Progression must expose missing Scrap")
	run = progression.advance(10.0, 0.5)
	_expect(float(run["fuel"]) < C.MAX_FUEL, "Run Progression must drain Fuel")
	_expect(float(run["miles_driven"]) == 0.5, "Run Progression must retain best Miles Driven")
	run = progression.apply_pickup("fuel")
	_expect(float(run["fuel"]) <= C.MAX_FUEL, "Fuel Pickup must cap at max Fuel")
	run = progression.apply_damage(40.0, "proof impact")
	var damaged := float(run["vehicle_damage_remaining"])
	run = progression.apply_pickup("repair")
	_expect(float(run["vehicle_damage_remaining"]) > damaged, "Repair Pickup must restore Vehicle Damage")
	run = progression.apply_pickup("scrap")
	_expect(int(run["run_scrap"]) == C.SCRAP_PICKUP_AMOUNT, "Scrap Pickup must add run Scrap")
	run = progression.finish_run("proof complete")
	var profile := progression.driver_profile_snapshot()
	_expect(not bool(run["active"]), "Run Progression must mark finished runs inactive")
	_expect(str(run["end_reason"]) == "proof complete", "Run Progression must keep result reason")
	_expect(int(run["scrap_earned"]) == C.SCRAP_PICKUP_AMOUNT + 2, "Run Progression must combine run Scrap and Miles Driven bonus")
	_expect(int(profile["scrap"]) == 25 + C.SCRAP_PICKUP_AMOUNT + 2, "Run Progression must add earned Scrap to Driver Profile")
	_expect(int(profile["runs"]) == 1, "Run Progression must increment Driver Profile run count")
	_expect(float(profile["best_miles"]) == 0.5, "Run Progression must update best Miles Driven")
	run = progression.apply_pickup("scrap")
	_expect(int(run["run_scrap"]) == C.SCRAP_PICKUP_AMOUNT, "Run Progression must ignore pickups after results")
	progression = RunProgression.new(_test_profile(0, 0, 0, 0))
	run = progression.start_run(1357)
	run = progression.advance(302.0, 0.2)
	_expect(bool(run["active"]), "Run Progression must not end before Fuel is empty")
	run = progression.advance(2.0, 0.2)
	_expect(bool(run["active"]), "Run Progression must honor Sputter Grace Period")
	run = progression.advance(1.1, 0.2)
	_expect(not bool(run["active"]) and str(run["end_reason"]) == "Fuel", "Run Progression must end after Sputter Grace Period")
	progression = RunProgression.new(_test_profile(0, 0, 0, 0))
	run = progression.start_run(9753)
	run = progression.apply_damage(C.MAX_VEHICLE_DAMAGE, "proof damage")
	_expect(not bool(run["active"]) and str(run["end_reason"]) == "Vehicle Damage: proof damage", "Run Progression must end at zero Vehicle Damage")
	progression = RunProgression.new(_test_profile(25, 0, 0, 0))
	var bought := progression.buy_upgrade("fuel_tank")
	profile = progression.driver_profile_snapshot()
	_expect(bought, "Run Progression must buy affordable Permanent Upgrades")
	_expect(int(profile["scrap"]) == 5, "Run Progression must spend exact Garage cost")
	_expect(int(profile["upgrades"]["fuel_tank"]) == 1, "Run Progression must increment Permanent Upgrade level")
	_expect(progression.max_fuel() > C.MAX_FUEL, "Run Progression must apply Permanent Upgrade effects")
	_expect(not progression.buy_upgrade("fuel_tank"), "Run Progression must reject unaffordable Permanent Upgrades")

func _test_combat_resource_progression() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	var proof := game.automated_loop_proof()
	_expect(bool(proof["ok"]), "resource/results/garage/restart proof failed: %s" % str(proof))
	game.start_run(333)
	game.player.velocity = Vector2.RIGHT * 280.0
	var zombie = preload("res://scripts/world_entity.gd").new()
	zombie.setup({"id": "proof:zombie", "kind": "zombie"}, game.player.global_position + Vector2(30, 0), "proof")
	game.world.add_child(zombie)
	game.world.active_entities[zombie.marker_id] = zombie
	game._handle_contacts(0.1)
	_expect(game.world.run_mutations.has("proof:zombie"), "ramming zombie at speed must destroy it")
	game.apply_damage(C.MAX_VEHICLE_DAMAGE, "proof damage")
	_expect(game.state == "results", "vehicle damage must end a run")
	game.queue_free()

func _test_garage_upgrade_clarity() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	game.profile = _test_profile(0, 0, 0, 0)
	game.show_garage()
	var empty_text := game.menu_label.text
	var empty_fuel_button:String = game.buttons["buy_fuel_tank"].text
	var empty_armor_button:String = game.buttons["buy_armor"].text
	var empty_engine_button:String = game.buttons["buy_engine"].text
	_expect(_has_text(empty_text, "Scrap: 0"), "garage must show current Scrap")
	_expect(_has_text(empty_fuel_button, "Fuel Tank L0/3"), "garage must show Fuel Tank level cap")
	_expect(_has_text(empty_fuel_button, "Cost: 20 Scrap"), "garage must show Fuel Tank next cost")
	_expect(_has_text(empty_fuel_button, "Effect: +20 max Fuel"), "garage must show Fuel Tank next effect")
	_expect(_has_text(empty_fuel_button, "Need 20 more Scrap"), "garage must mark Fuel Tank unaffordable")
	_expect(not game.buttons["buy_fuel_tank"].disabled, "unaffordable Fuel Tank button must preserve buy attempt behavior")
	_expect(_has_text(empty_armor_button, "Armor L0/3"), "garage must show Armor level cap")
	_expect(_has_text(empty_armor_button, "Cost: 20 Scrap"), "garage must show Armor next cost")
	_expect(_has_text(empty_armor_button, "Effect: +20 max Vehicle Damage"), "garage must show Armor next effect")
	_expect(_has_text(empty_armor_button, "Need 20 more Scrap"), "garage must mark Armor unaffordable")
	_expect(not game.buttons["buy_armor"].disabled, "unaffordable Armor button must preserve buy attempt behavior")
	_expect(_has_text(empty_engine_button, "Engine L0/3"), "garage must show Engine level cap")
	_expect(_has_text(empty_engine_button, "Cost: 25 Scrap"), "garage must show Engine next cost")
	_expect(_has_text(empty_engine_button, "Effect: +5% speed"), "garage must show Engine next effect")
	_expect(_has_text(empty_engine_button, "Need 25 more Scrap"), "garage must mark Engine unaffordable")
	_expect(not game.buttons["buy_engine"].disabled, "unaffordable Engine button must preserve buy attempt behavior")
	var unaffordable_bought := game.buy_upgrade("fuel_tank")
	_expect(not unaffordable_bought, "unaffordable Fuel Tank buy attempt must still fail")
	_expect(int(game.profile["scrap"]) == 0, "unaffordable Fuel Tank buy attempt must not spend Scrap")
	var landscape_phone := Vector2(896, 414)
	game.show_garage()
	game._layout_ui(landscape_phone)
	var menu_rect := Rect2(game.menu_panel.position, game.menu_panel.size)
	_expect(menu_rect.position.x >= 0.0 and menu_rect.end.x <= landscape_phone.x, "garage menu must fit landscape phone width")
	_expect(menu_rect.position.y >= 0.0 and menu_rect.end.y <= landscape_phone.y, "garage menu must fit landscape phone height")
	_expect(game.buttons["buy_fuel_tank"].custom_minimum_size.x <= game.menu_panel.size.x, "Fuel Tank row must fit Garage panel width")
	_expect(game.buttons["buy_armor"].custom_minimum_size.x <= game.menu_panel.size.x, "Armor row must fit Garage panel width")
	_expect(game.buttons["buy_engine"].custom_minimum_size.x <= game.menu_panel.size.x, "Engine row must fit Garage panel width")
	game.profile = _test_profile(25, 0, 0, 0)
	game.show_garage()
	_expect(not game.buttons["buy_fuel_tank"].disabled, "affordable Fuel Tank button must be enabled")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Ready"), "affordable Fuel Tank button must show ready state")
	var bought := game.buy_upgrade("fuel_tank")
	_expect(bought, "affordable Fuel Tank purchase must still work")
	_expect(int(game.profile["scrap"]) == 5, "Fuel Tank purchase must spend exact Scrap cost")
	_expect(int(game.profile["upgrades"]["fuel_tank"]) == 1, "Fuel Tank purchase must increment level")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Fuel Tank L1/3"), "garage must refresh bought level")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Cost: 50 Scrap"), "garage must refresh next Fuel Tank cost")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Effect: +40 max Fuel"), "garage must refresh next Fuel Tank effect")
	var proof_save_path := "user://keep_driving_garage_clarity_test.json"
	_remove_user_file(proof_save_path)
	game.profile_save_path = proof_save_path
	game.persist_enabled = true
	game.profile = _test_profile(25, 0, 0, 0)
	var persistent_bought := game.buy_upgrade("fuel_tank")
	var persisted_profile := ProfileStore.load_profile(proof_save_path)
	_expect(persistent_bought, "persistent Fuel Tank purchase must work")
	_expect(int(persisted_profile["scrap"]) == 5, "persistent Fuel Tank purchase must save Scrap")
	_expect(int(persisted_profile["upgrades"]["fuel_tank"]) == 1, "persistent Fuel Tank purchase must save level")
	_remove_user_file(proof_save_path)
	game.persist_enabled = false
	game.profile = _test_profile(999, 3, 3, 3)
	game.show_garage()
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Fuel Tank L3/3"), "maxed Fuel Tank level must be visible")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "MAXED"), "garage must expose maxed upgrade state")
	_expect(game.buttons["buy_fuel_tank"].disabled, "maxed Fuel Tank button must be disabled")
	_expect(_has_text(game.buttons["buy_fuel_tank"].text, "Fuel Tank L3/3 MAXED"), "maxed Fuel Tank button must explain state")
	_expect(_has_text(game.buttons["buy_armor"].text, "Armor L3/3 MAXED"), "maxed Armor button must explain state")
	_expect(game.buttons["buy_armor"].disabled, "maxed Armor button must be disabled")
	_expect(_has_text(game.buttons["buy_engine"].text, "Engine L3/3 MAXED"), "maxed Engine button must explain state")
	_expect(game.buttons["buy_engine"].disabled, "maxed Engine button must be disabled")
	game.queue_free()

func _test_first_minute_run_trust() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	for seed in [1, 333, 999, 54321, 909090]:
		game.start_run(seed)
		var terrain := game.world.sample_terrain(game.player.global_position)
		var starts_on_route := terrain == C.TERRAIN_ROAD or terrain == C.TERRAIN_DIRT_PATH
		_expect(starts_on_route, "run must start on road or dirt route: seed=%d terrain=%s position=%s" % [seed, C.terrain_name(terrain), str(game.player.global_position)])
		var chunk := WorldGenerator.generate_chunk(seed, Vector2i.ZERO)
		var connected_route_tiles := _reachable_route_tiles(chunk["route_mask"], Vector2i.ZERO)
		_expect(connected_route_tiles > 16, "origin start route must connect into the route network: seed=%d reachable_route_tiles=%d" % [seed, connected_route_tiles])
	var report := game.mobile_layout_report()
	_expect(bool(report.get("hud_has_resource_bars", false)), "HUD must expose persistent fuel and damage bars")
	var proof := game.automated_loop_proof()
	_expect(bool(proof["ok"]), "garage progression must still pass after first-minute run trust polish: %s" % str(proof))
	game.queue_free()

func _test_mobile_layout() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	var report := game.mobile_layout_report()
	_expect(bool(report["landscape"]), "viewport must be landscape")
	_expect(report["controls"].size() >= 5, "mobile controls must include steering/gas/brake/handbrake")
	_expect(bool(report["touch_sized"]), "mobile controls must be touch-sized")
	game.queue_free()

func _test_profile(scrap:int, fuel_tank:int, armor:int, engine:int) -> Dictionary:
	return {
		"scrap": scrap,
		"upgrades": {
			"fuel_tank": fuel_tank,
			"armor": armor,
			"engine": engine,
		},
		"best_miles": 0.0,
		"runs": 0,
	}

func _has_text(text:String, expected:String) -> bool:
	return text.find(expected) >= 0

func _remove_user_file(path:String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _reachable_route_tiles(route_mask:PackedByteArray, start:Vector2i) -> int:
	var start_idx:int = start.y * C.CHUNK_TILES + start.x
	if int(route_mask[start_idx]) != 1:
		return 0
	var frontier := [start]
	var seen := {"%d,%d" % [start.x, start.y]: true}
	var count:int = 0
	while not frontier.is_empty():
		var tile:Vector2i = frontier.pop_front()
		count += 1
		for neighbor:Vector2i in [tile + Vector2i.RIGHT, tile + Vector2i.LEFT, tile + Vector2i.UP, tile + Vector2i.DOWN]:
			if neighbor.x < 0 or neighbor.y < 0 or neighbor.x >= C.CHUNK_TILES or neighbor.y >= C.CHUNK_TILES:
				continue
			var key := "%d,%d" % [neighbor.x, neighbor.y]
			if seen.has(key):
				continue
			var idx:int = neighbor.y * C.CHUNK_TILES + neighbor.x
			if int(route_mask[idx]) != 1:
				continue
			seen[key] = true
			frontier.append(neighbor)
	return count
