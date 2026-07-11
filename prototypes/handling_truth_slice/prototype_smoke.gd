extends SceneTree

# PROTOTYPE smoke only. This is evidence for the spike, not a production test suite.

const DriveIntent = preload("res://prototypes/handling_truth_slice/drive_intent.gd")
const PrototypeVehicle = preload("res://prototypes/handling_truth_slice/prototype_vehicle.gd")
const PrototypeWorld = preload("res://prototypes/handling_truth_slice/prototype_world.gd")
const PrototypeAudio = preload("res://prototypes/handling_truth_slice/prototype_audio.gd")

var failures:Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var normalized := DriveIntent.sample({"steer": 4.0, "gas": true, "brake": -2.0, "handbrake": 0.5})
	_expect(float(normalized["steer"]) == 1.0, "DriveIntent must clamp steering")
	_expect(float(normalized["throttle"]) == 1.0, "DriveIntent must normalize legacy gas")
	_expect(float(normalized["brake"]) == 0.0, "DriveIntent must clamp brake")
	DriveIntent.set_simulated_intent({"throttle": 1.0})
	var injected_neutral := DriveIntent.sample({})
	_expect(float(injected_neutral["throttle"]) == 0.0, "explicit neutral intent must not fall through to live or simulated input")
	DriveIntent.set_simulated_intent({})

	var road_speed := await _surface_speed({"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0})
	var dirt_speed := await _surface_speed({"name": "dirt", "speed_multiplier": 0.76, "grip": 0.68, "rolling_drag": 54.0})
	var mud_speed := await _surface_speed({"name": "mud", "speed_multiplier": 0.48, "grip": 0.42, "rolling_drag": 96.0})
	_expect(road_speed > dirt_speed and dirt_speed > mud_speed, "surface speed order must be road > dirt > mud")
	var scout_speed := await _surface_speed({"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, "scout")
	var hauler_speed := await _surface_speed({"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, "hauler")
	_expect(scout_speed > road_speed and road_speed > hauler_speed, "tune speed response must order scout > balanced > hauler")
	var balanced_turn := await _turn_response("balanced")
	var scout_turn := await _turn_response("scout")
	var hauler_turn := await _turn_response("hauler")
	_expect(scout_turn > balanced_turn and balanced_turn > hauler_turn, "tune turn response must order scout > balanced > hauler")
	var balanced_lateral := await _remaining_lateral_speed("balanced")
	var scout_lateral := await _remaining_lateral_speed("scout")
	var hauler_lateral := await _remaining_lateral_speed("hauler")
	_expect(scout_lateral > balanced_lateral and balanced_lateral > hauler_lateral, "tune lateral grip must order scout < balanced < hauler")

	var stationary := PrototypeVehicle.new()
	root.add_child(stationary)
	stationary.set_physics_process(false)
	var initial_rotation := stationary.rotation
	for i in range(60):
		stationary.step_vehicle({"steer": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	_expect(is_equal_approx(initial_rotation, stationary.rotation), "vehicle must not rotate at rest")
	stationary.queue_free()
	await process_frame

	var coasting := PrototypeVehicle.new()
	root.add_child(coasting)
	coasting.set_physics_process(false)
	for i in range(180):
		coasting.step_vehicle({"throttle": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	var powered_speed := coasting.velocity.length()
	for i in range(180):
		coasting.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	_expect(coasting.velocity.length() < powered_speed * 0.75, "rolling drag must slow an unpowered vehicle")
	coasting.queue_free()
	await process_frame

	var replay_30 := await _replay_trace(30)
	var replay_60 := await _replay_trace(60)
	var replay_120 := await _replay_trace(120)
	_expect(_replays_match(replay_30, replay_60), "30 and 60 Hz render traces must produce the same fixed-step outcome")
	_expect(_replays_match(replay_60, replay_120), "60 and 120 Hz render traces must produce the same fixed-step outcome")

	var world := PrototypeWorld.new()
	root.add_child(world)
	var impact_results:Array[Dictionary] = []
	for spec in world.obstacle_specs:
		impact_results.append(await _impact_case(world, spec))
	for index in impact_results.size():
		var impact := impact_results[index]
		var expected_weight := str(world.obstacle_specs[index]["weight"])
		_expect(int(impact["impact_count"]) == 1, "%s obstacle contact must create one impact transition" % expected_weight)
		_expect(str(impact["last_impact_weight"]) == expected_weight, "%s obstacle must report its weight" % expected_weight)
		_expect(float(impact["integrity"]) < 100.0, "%s impact must reduce prototype Integrity" % expected_weight)
	var light_damage := 100.0 - float(impact_results[0]["integrity"])
	var medium_damage := 100.0 - float(impact_results[1]["integrity"])
	var heavy_damage := 100.0 - float(impact_results[2]["integrity"])
	_expect(light_damage < medium_damage and medium_damage < heavy_damage, "impact response must order light < medium < heavy")
	var balanced_tune_impact := await _impact_case(world, world.obstacle_specs[1], "balanced")
	var scout_tune_impact := await _impact_case(world, world.obstacle_specs[1], "scout")
	var hauler_tune_impact := await _impact_case(world, world.obstacle_specs[1], "hauler")
	var balanced_tune_damage := 100.0 - float(balanced_tune_impact["integrity"])
	var scout_tune_damage := 100.0 - float(scout_tune_impact["integrity"])
	var hauler_tune_damage := 100.0 - float(hauler_tune_impact["integrity"])
	_expect(scout_tune_damage > balanced_tune_damage and balanced_tune_damage > hauler_tune_damage, "tune impact resistance must order scout < balanced < hauler")
	var reset_car := PrototypeVehicle.new()
	root.add_child(reset_car)
	reset_car.set_physics_process(false)
	reset_car.global_position = Vector2(500.0, 300.0)
	reset_car.rotation = 1.2
	reset_car.integrity = 12.0
	reset_car.impact_count = 4
	reset_car.last_collision = {"weight": "heavy"}
	reset_car.reset_prototype(PrototypeWorld.START_POSITION)
	var reset_state := reset_car.telemetry_snapshot()
	_expect(reset_car.global_position == PrototypeWorld.START_POSITION, "full reset must restore spawn position")
	_expect(is_zero_approx(reset_car.rotation), "full reset must restore spawn rotation")
	_expect(float(reset_state["integrity"]) == 100.0, "full reset must restore Integrity")
	_expect(int(reset_state["impact_count"]) == 0 and str(reset_state["last_impact_weight"]) == "none", "full reset must clear collision history")
	_expect(str(reset_state["surface"]) == "asphalt" and is_zero_approx(float(reset_state["surface_rolling_drag"])), "full reset must restore default surface facts")
	_expect(is_zero_approx(float(reset_state["steer_authority"])) and not bool(reset_state["handbrake"]), "full reset must clear steering and handbrake facts")
	_expect(is_equal_approx(float(reset_state["max_speed"]), PrototypeVehicle.BASE_MAX_SPEED), "full reset must restore tune-adjusted asphalt speed")
	reset_car.queue_free()
	world.queue_free()
	await process_frame

	var audio := PrototypeAudio.new()
	root.add_child(audio)
	audio.setup()
	audio.update_vehicle(1.0, "mud", true)
	audio.reset_state()
	var engine_player := audio.get_node("EngineLoop") as AudioStreamPlayer
	var surface_player := audio.get_node("SurfaceLoop") as AudioStreamPlayer
	_expect(is_equal_approx(engine_player.pitch_scale, 0.72) and is_equal_approx(engine_player.volume_db, -16.0), "audio reset must restore idle engine mix")
	_expect(is_equal_approx(surface_player.pitch_scale, 0.82) and is_equal_approx(surface_player.volume_db, -42.0), "audio reset must restore idle road mix")
	for player_name in ["EngineLoop", "SurfaceLoop", "ImpactCue", "RewardCue", "WarningCue", "UICue"]:
		var player := audio.get_node(player_name) as AudioStreamPlayer
		var stream := player.stream as AudioStreamWAV
		_expect(stream != null and stream.data.size() > 0, "%s must contain real PCM data" % player_name)
	audio.queue_free()
	await process_frame

	if failures.is_empty():
		print("PROTOTYPE_HANDLING_SMOKE road=%.1f dirt=%.1f mud=%.1f scout=%.1f hauler=%.1f tunes=speed_turn_grip_impact fixed_step_batch_30_60_120=true impacts=light_medium_heavy full_reset=true pcm=true pass=true" % [road_speed, dirt_speed, mud_speed, scout_speed, hauler_speed])
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("PROTOTYPE_HANDLING_SMOKE pass=false failures=%s" % str(failures))
		quit(1)

func _surface_speed(surface:Dictionary, tune_name:String = "balanced") -> float:
	var car := PrototypeVehicle.new()
	root.add_child(car)
	car.set_physics_process(false)
	car.set_tune(tune_name)
	for i in range(240):
		car.step_vehicle({"throttle": 1.0}, surface, 1.0 / 60.0)
	var result := car.velocity.length()
	car.queue_free()
	await process_frame
	return result

func _turn_response(tune_name:String) -> float:
	var car := PrototypeVehicle.new()
	root.add_child(car)
	car.set_physics_process(false)
	car.set_tune(tune_name)
	car.velocity = Vector2(260.0, 0.0)
	for i in range(30):
		car.step_vehicle({"steer": 0.55, "throttle": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	var result := absf(car.rotation)
	car.queue_free()
	await process_frame
	return result

func _remaining_lateral_speed(tune_name:String) -> float:
	var car := PrototypeVehicle.new()
	root.add_child(car)
	car.set_physics_process(false)
	car.set_tune(tune_name)
	car.velocity = Vector2(260.0, 180.0)
	for i in range(12):
		car.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	var result := car.lateral_speed
	car.queue_free()
	await process_frame
	return result

func _replay_trace(render_hz:int) -> Dictionary:
	var car := PrototypeVehicle.new()
	root.add_child(car)
	car.set_physics_process(false)
	var fixed_delta := 1.0 / 60.0
	var render_delta := 1.0 / float(render_hz)
	var accumulator := 0.0
	var physics_time := 0.0
	for _frame in range(render_hz * 6):
		accumulator += render_delta
		while accumulator + 0.0000001 >= fixed_delta:
			var intent := {"throttle": 1.0}
			if physics_time >= 0.5 and physics_time < 2.5:
				intent["steer"] = 0.42
			if physics_time >= 2.5 and physics_time < 3.0:
				intent["handbrake"] = 0.65
			if physics_time >= 4.0:
				intent = {}
			car.step_vehicle(intent, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, fixed_delta)
			physics_time += fixed_delta
			accumulator -= fixed_delta
	var result := {
		"position": car.global_position,
		"velocity": car.velocity,
		"rotation": car.rotation,
	}
	car.queue_free()
	await process_frame
	return result

func _replays_match(left:Dictionary, right:Dictionary) -> bool:
	return (
		(left["position"] as Vector2).distance_to(right["position"] as Vector2) <= 0.1
		and (left["velocity"] as Vector2).distance_to(right["velocity"] as Vector2) <= 0.1
		and absf(float(left["rotation"]) - float(right["rotation"])) <= 0.001
	)

func _impact_case(world:PrototypeWorld, spec:Dictionary, tune_name:String = "balanced") -> Dictionary:
	var car := PrototypeVehicle.new()
	root.add_child(car)
	car.set_physics_process(false)
	car.set_tune(tune_name)
	car.global_position = Vector2(float(spec["position"].x) - float(spec["radius"]) - 90.0, float(spec["position"].y))
	car.velocity = Vector2(520.0, 0.0)
	await physics_frame
	for _step in range(90):
		car.step_vehicle({}, world.surface_at(car.global_position), 1.0 / 60.0)
	var result := car.telemetry_snapshot()
	car.queue_free()
	await process_frame
	return result

func _expect(condition:bool, message:String) -> void:
	if not condition:
		failures.append(message)
