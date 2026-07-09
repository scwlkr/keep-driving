extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const GameRoot = preload("res://scripts/game_root.gd")
const ProfileStore = preload("res://scripts/profile_store.gd")
const WorldEntity = preload("res://scripts/world_entity.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	game.simulated_mobile_viewport = Vector2(896, 414)
	game.profile = ProfileStore.default_profile()
	game.profile["scrap"] = 40
	game.start_run(909090)
	var covered := {
		"road": false,
		"offroad": false,
		"handbrake": false,
		"fuel_pickup": false,
		"repair_pickup": false,
		"scrap_pickup": false,
		"zombie_ram": false,
		"zombie_contact_damage": false,
		"obstacle_light": false,
		"obstacle_medium": false,
		"obstacle_heavy": false,
		"fuel_end": false,
		"damage_end": false,
		"results": false,
		"garage": false,
		"restart": false,
		"mobile": false,
		"mobile_touch_input": false,
		"dashboard": false,
		"feedback_audio": false,
	}
	for i in range(60 * 600):
		if game.state != "running":
			game.start_run(909090 + i)
		var steer := sin(float(i) * 0.017)
		game.simulated_controls = {
			"steer": steer,
			"gas": true,
			"brake": i % 500 > 460,
			"handbrake": i % 700 > 650,
		}
		game._process(1.0 / 60.0)
		var terrain := game.world.sample_terrain(game.player.global_position)
		if terrain == C.TERRAIN_ROAD or terrain == C.TERRAIN_DIRT_PATH:
			covered["road"] = true
		if terrain == C.TERRAIN_GRASS or terrain == C.TERRAIN_ROUGH or terrain == C.TERRAIN_SHALLOW:
			covered["offroad"] = true
		if bool(game.simulated_controls["handbrake"]):
			covered["handbrake"] = true
		covered["dashboard"] = covered["dashboard"] or _dashboard_has_core_stats(game)
		if game.fuel < 12.0:
			game.fuel = 45.0
		if game.vehicle_damage_remaining < 20.0:
			game.vehicle_damage_remaining = 60.0

	game.simulated_controls = {}
	game.vehicle_damage_remaining = C.max_damage_for(game.profile["upgrades"])
	game.fuel = C.max_fuel_for(game.profile["upgrades"])
	covered["fuel_pickup"] = _prove_pickup(game, "fuel")
	covered["repair_pickup"] = _prove_pickup(game, "repair")
	covered["scrap_pickup"] = _prove_pickup(game, "scrap")
	covered["zombie_ram"] = _prove_zombie_ram(game)
	covered["zombie_contact_damage"] = _prove_zombie_contact_damage(game)
	covered["obstacle_light"] = _prove_obstacle_contact(game, "light")
	covered["obstacle_medium"] = _prove_obstacle_contact(game, "medium")
	covered["obstacle_heavy"] = _prove_obstacle_contact(game, "heavy")
	covered["feedback_audio"] = int(game.feedback_counts["hit"]) > 0 and int(game.feedback_counts["pickup"]) > 0 and int(game.feedback_counts["audio"]) > 0

	game.fuel = 0.0
	game.sputter_seconds = C.SPUTTER_GRACE_SECONDS
	game._apply_run_resources(0.01, C.TERRAIN_ROAD)
	covered["fuel_end"] = game.state == "results" and game.run_end_reason == "Fuel"
	covered["results"] = covered["fuel_end"]

	game.show_garage()
	covered["garage"] = game.buy_upgrade("fuel_tank") and int(game.profile["upgrades"]["fuel_tank"]) == 1
	var previous_seed := game.run_seed
	var scrap_after_garage := int(game.profile["scrap"])
	game.start_run()
	game._process(1.0 / 60.0)
	covered["restart"] = game.run_seed != previous_seed and int(game.profile["upgrades"]["fuel_tank"]) == 1 and int(game.profile["scrap"]) == scrap_after_garage and game.fuel > C.MAX_FUEL

	game._touch_button("steer_left", true)
	game._touch_button("gas", true)
	game._touch_button("handbrake", true)
	var touch_controls := game._read_controls()
	covered["mobile_touch_input"] = float(touch_controls["steer"]) < 0.0 and bool(touch_controls["gas"]) and bool(touch_controls["handbrake"])
	game._touch_button("steer_left", false)
	game._touch_button("gas", false)
	game._touch_button("handbrake", false)
	var mobile_report := game.mobile_layout_report()
	covered["mobile"] = bool(mobile_report["landscape"]) and bool(mobile_report["touch_sized"]) and bool(mobile_report["controls_in_bounds"])
	covered["dashboard"] = covered["dashboard"] and bool(mobile_report["dashboard_has_core_stats"]) and bool(mobile_report["dashboard_width_ok"])

	game.apply_damage(C.max_damage_for(game.profile["upgrades"]), "manual smoke lethal")
	covered["damage_end"] = game.state == "results" and game.run_end_reason.begins_with("Vehicle Damage")

	var ok := true
	for key in covered.keys():
		ok = ok and bool(covered[key])
	print("MANUAL_SMOKE_SIMULATION seconds=600 covered=%s mobile=%s pass=%s" % [str(covered), str(mobile_report), str(ok)])
	game.queue_free()
	await process_frame
	quit(0 if ok else 1)

func _spawn_entity(game:GameRoot, id:String, kind:String, offset:Vector2) -> WorldEntity:
	var entity := WorldEntity.new()
	entity.setup({"id": id, "kind": kind}, game.player.global_position + offset, "manual_smoke")
	game.world.add_child(entity)
	game.world.active_entities[entity.marker_id] = entity
	return entity

func _prove_pickup(game:GameRoot, kind:String) -> bool:
	var id := "manual:%s" % kind
	if kind == "fuel":
		game.fuel = 10.0
	elif kind == "repair":
		game.vehicle_damage_remaining = C.max_damage_for(game.profile["upgrades"]) - 40.0
	var scrap_before := game.run_scrap
	var fuel_before := game.fuel
	var damage_before := game.vehicle_damage_remaining
	_spawn_entity(game, id, kind, Vector2(12, 0))
	game._handle_contacts(0.1)
	if kind == "fuel":
		return game.fuel > fuel_before and game.world.run_mutations.has(id)
	if kind == "repair":
		return game.vehicle_damage_remaining > damage_before and game.world.run_mutations.has(id)
	return game.run_scrap == scrap_before + C.SCRAP_PICKUP_AMOUNT and game.world.run_mutations.has(id)

func _prove_zombie_ram(game:GameRoot) -> bool:
	var id := "manual:zombie_ram"
	game.player.velocity = Vector2.RIGHT * 260.0
	_spawn_entity(game, id, "zombie", Vector2(30, 0))
	game._handle_contacts(0.1)
	return game.world.run_mutations.has(id)

func _prove_zombie_contact_damage(game:GameRoot) -> bool:
	var id := "manual:zombie_contact"
	game.player.velocity = Vector2.ZERO
	game.vehicle_damage_remaining = C.max_damage_for(game.profile["upgrades"])
	var damage_before := game.vehicle_damage_remaining
	_spawn_entity(game, id, "zombie", Vector2(30, 0))
	game._handle_contacts(1.0)
	game.world.mutate_marker(id, "proofed")
	return game.vehicle_damage_remaining < damage_before

func _prove_obstacle_contact(game:GameRoot, weight:String) -> bool:
	var id := "manual:obstacle_%s" % weight
	game.vehicle_damage_remaining = C.max_damage_for(game.profile["upgrades"])
	game.player.velocity = Vector2.RIGHT * (500.0 if weight == "medium" else 260.0)
	var damage_before := game.vehicle_damage_remaining
	_spawn_entity(game, id, "obstacle_%s" % weight, Vector2(30, 0))
	game._handle_contacts(0.1)
	var damaged := game.vehicle_damage_remaining < damage_before
	var mutation_ok := true if weight == "heavy" else game.world.run_mutations.has(id)
	game.world.mutate_marker(id, "proofed")
	return damaged and mutation_ok

func _dashboard_has_core_stats(game:GameRoot) -> bool:
	var text := game.dashboard.text
	return text.find("Fuel") >= 0 and text.find("Damage") >= 0 and text.find("Miles") >= 0 and text.find("Scrap") >= 0
