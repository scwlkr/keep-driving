extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const GameRoot = preload("res://scripts/game_root.gd")
const ProfileStore = preload("res://scripts/profile_store.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	root.size = Vector2i(1280, 720)
	var game := GameRoot.new()
	root.add_child(game)
	game.persist_enabled = false
	game._ready()
	game.profile = ProfileStore.default_profile()
	game.profile["scrap"] = 40
	game.start_run(616161)
	var layout := game.mobile_layout_report()
	for i in range(60 * 12):
		game.touch_state["gas"] = true
		game.touch_state["steer"] = -1.0 if i % 240 < 120 else 1.0
		game.touch_state["brake"] = i % 360 > 330
		game.touch_state["handbrake"] = i % 500 > 455
		game._process(1.0 / 60.0)
	if game.state != "running":
		game.start_run(616162)
	game.apply_pickup("fuel")
	game.apply_pickup("scrap")
	game.apply_damage(20.0, "mobile proof impact")
	game.miles_driven = 0.8
	game.end_run("mobile proof complete")
	var results_ok := game.state == "results" and int(game.profile["scrap"]) > 40
	game.show_garage()
	var garage_ok := game.buy_upgrade("fuel_tank") or int(game.profile["upgrades"]["fuel_tank"]) > 0
	var previous_seed := game.run_seed
	game.start_run(717171)
	var restart_ok := game.run_seed != previous_seed
	var ok := bool(layout["landscape"]) and bool(layout["touch_sized"]) and game.mobile_controls.size() >= 5 and results_ok and garage_ok and restart_ok
	print("LANDSCAPE_MOBILE_PROOF viewport=%s controls=%s results=%s garage=%s restart=%s pass=%s" % [
		str(layout["viewport"]),
		str(layout["controls"]),
		str(results_ok),
		str(garage_ok),
		str(restart_ok),
		str(ok),
	])
	game.queue_free()
	quit(0 if ok else 1)
