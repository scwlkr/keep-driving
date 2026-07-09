extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const GameRoot = preload("res://scripts/game_root.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	game.profile = preload("res://scripts/profile_store.gd").default_profile()
	game.profile["scrap"] = 40
	game.start_run(909090)
	var covered := {
		"road": false,
		"offroad": false,
		"handbrake": false,
		"pickup": false,
		"damage": false,
		"results": false,
		"garage": false,
		"restart": false,
		"mobile": false,
	}
	for i in range(60 * 600):
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
		if game.run_scrap > 0 or game.fuel < C.max_fuel_for(game.profile["upgrades"]):
			covered["pickup"] = true
		if game.vehicle_damage_remaining < C.max_damage_for(game.profile["upgrades"]):
			covered["damage"] = true
		if game.state != "running":
			break
	if game.state == "running":
		game.end_run("manual smoke timeout")
	covered["results"] = game.state == "results"
	game.show_garage()
	covered["garage"] = game.buy_upgrade("fuel_tank") or int(game.profile["upgrades"]["fuel_tank"]) > 0
	var previous_seed := game.run_seed
	game.start_run(808080)
	covered["restart"] = game.run_seed != previous_seed
	covered["mobile"] = bool(game.mobile_layout_report()["landscape"])
	var ok := true
	for key in covered.keys():
		ok = ok and bool(covered[key])
	print("MANUAL_SMOKE_SIMULATION seconds=600 covered=%s pass=%s" % [str(covered), str(ok)])
	game.queue_free()
	quit(0 if ok else 1)
