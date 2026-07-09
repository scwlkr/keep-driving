extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const WorldGenerator = preload("res://scripts/world_generator.gd")
const WorldRuntime = preload("res://scripts/world_runtime.gd")
const PlayerVehicle = preload("res://scripts/player_vehicle.gd")
const GameRoot = preload("res://scripts/game_root.gd")

var failures := []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_project_shell()
	_test_deterministic_chunks()
	_test_streaming_and_mutations()
	_test_routes_and_barriers()
	_test_vehicle_controls()
	_test_combat_resource_progression()
	_test_mobile_layout()
	if failures.is_empty():
		print("ALL_KEEP_DRIVING_PROOFS_PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
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
	car.apply_impact(Vector2(200, 0), 0.3)
	_expect(car.impact_shake > 0.0 and absf(car.rotation) > 0.0, "collision impact must shake and rotate")
	car.queue_free()

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
