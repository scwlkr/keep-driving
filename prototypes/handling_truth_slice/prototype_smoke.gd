extends SceneTree

# PROTOTYPE smoke only. This is evidence for the spike, not a production test suite.

const DriveIntent = preload("res://prototypes/handling_truth_slice/drive_intent.gd")
const PrototypeVehicle = preload("res://prototypes/handling_truth_slice/prototype_vehicle.gd")
const PrototypeWorld = preload("res://prototypes/handling_truth_slice/prototype_world.gd")
const PrototypeAudio = preload("res://prototypes/handling_truth_slice/prototype_audio.gd")
const PrototypeRoot = preload("res://prototypes/handling_truth_slice/prototype_root.gd")

var failures:Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_expect(InputMap.has_action(&"drive_recover"), "keyboard recovery must be present in the exported InputMap")
	_expect(PrototypeRoot.is_valid_benchmark_mode("feel") and PrototypeRoot.is_valid_benchmark_mode("capacity"), "only the two frozen benchmark modes must be valid")
	_expect(not PrototypeRoot.is_valid_benchmark_mode("feal"), "mistyped benchmark modes must be rejected")
	_expect(
		PrototypeRoot.benchmark_vsync_mode("feel", 0) == DisplayServer.VSYNC_ENABLED
		and PrototypeRoot.benchmark_vsync_mode("capacity", 0) == DisplayServer.VSYNC_DISABLED
		and PrototypeRoot.benchmark_vsync_mode("feel", 30) == DisplayServer.VSYNC_DISABLED,
		"feel must enable VSync while capacity and render-cadence captures disable it"
	)
	_expect(
		String(PrototypeRoot.controller_glyphs_for_name("DualSense Wireless Controller")["handbrake"]) == "CROSS"
		and String(PrototypeRoot.controller_glyphs_for_name("Nintendo Switch Pro Controller")["handbrake"]) == "B"
		and String(PrototypeRoot.controller_glyphs_for_name("Xbox Wireless Controller")["handbrake"]) == "A"
		and String(PrototypeRoot.controller_glyphs_for_name("Generic USB Gamepad")["recovery"]) == "NORTH BUTTON",
		"controller onboarding must resolve the connected device family instead of hard-coding Xbox glyphs"
	)
	var normalized := DriveIntent.sample({"steer": 4.0, "gas": true, "brake": -2.0, "handbrake": 0.5})
	_expect(float(normalized["steer"]) == 1.0, "DriveIntent must clamp steering")
	_expect(float(normalized["throttle"]) == 1.0, "DriveIntent must normalize legacy gas")
	_expect(float(normalized["brake"]) == 0.0, "DriveIntent must clamp brake")
	var controller_intent := DriveIntent.sample({"steer": 0.25, "source": "controller", "device": 7})
	var source_neutral := DriveIntent.sample({})
	_expect(str(controller_intent["source"]) == "controller" and int(controller_intent["device"]) == 7, "injected controller provenance must survive normalization")
	_expect(str(source_neutral["source"]) == "injected" and int(source_neutral["device"]) == -1, "explicit neutral intent must clear prior source provenance")
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

	var reverse_car := PrototypeVehicle.new()
	root.add_child(reverse_car)
	reverse_car.set_physics_process(false)
	for i in range(180):
		reverse_car.step_vehicle({"throttle": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	for i in range(240):
		reverse_car.step_vehicle({"brake": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	var reverse_start_rotation := reverse_car.rotation
	for i in range(30):
		reverse_car.step_vehicle({"brake": 1.0, "steer": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0}, 1.0 / 60.0)
	var reverse_state := reverse_car.telemetry_snapshot()
	_expect(float(reverse_state["forward_speed"]) < -20.0, "held brake must cross through stop into bounded reverse")
	_expect(reverse_car.rotation < reverse_start_rotation - 0.01, "steering direction must invert while reversing")
	_expect(int(reverse_state.get("physics_step_count", -1)) == 450 and int(reverse_state.get("collision_query_count", -1)) == 450, "vehicle telemetry must count fixed physics steps and swept collision queries")
	reverse_car.queue_free()
	await process_frame

	var grip_car := PrototypeVehicle.new()
	var handbrake_car := PrototypeVehicle.new()
	grip_car.global_position = Vector2(0.0, -220.0)
	handbrake_car.global_position = Vector2(0.0, 220.0)
	root.add_child(grip_car)
	root.add_child(handbrake_car)
	grip_car.set_physics_process(false)
	handbrake_car.set_physics_process(false)
	grip_car.velocity = Vector2(260.0, 180.0)
	handbrake_car.velocity = Vector2(260.0, 180.0)
	for i in range(12):
		grip_car.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
		handbrake_car.step_vehicle({"handbrake": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	_expect(handbrake_car.lateral_speed > grip_car.lateral_speed * 1.35, "handbrake must preserve materially more lateral slip than normal grip")
	var effect_evidence := handbrake_car.presentation_evidence()
	var effect_state := handbrake_car.telemetry_snapshot()
	_expect(bool(effect_evidence.get("final_pipeline_effect_contract_pass", false)), "vehicle dust/skid feedback must use an imported authored effect texture with a bounded particle budget")
	_expect(
		int(effect_state.get("active_effect_emitters", 0)) == 1 and int(effect_state.get("peak_effect_emitters", 0)) == 1,
		"material handbrake slip must activate exactly one bounded effect emitter; telemetry=%s" % str(effect_state)
	)
	grip_car.queue_free()
	handbrake_car.queue_free()
	await process_frame

	var recovery_car := PrototypeVehicle.new()
	recovery_car.global_position = Vector2(120.0, 180.0)
	root.add_child(recovery_car)
	recovery_car.set_physics_process(false)
	var recovery_safe_position := recovery_car.global_position
	recovery_car.global_position = Vector2(540.0, 420.0)
	for i in range(28):
		recovery_car.step_vehicle({"recovery_pressed": true}, {"name": "rough", "speed_multiplier": 0.7, "grip": 0.6, "rolling_drag": 60.0}, 1.0 / 60.0)
	var recovery_state := recovery_car.telemetry_snapshot()
	_expect(bool(recovery_state["recovered"]), "held recovery must emit a recovered transition")
	_expect(recovery_car.global_position.distance_to(recovery_safe_position) <= 0.1, "held recovery must return to the last-safe pose")
	recovery_car.queue_free()
	await process_frame

	var collision_contract := await _thin_barrier_and_recontact_contract()
	_expect(int(collision_contract["first_impact_count"]) == 1, "a swept high-speed step must detect a two-pixel barrier without tunneling")
	_expect(int(collision_contract["held_contact_count"]) == 1, "held contact must not create duplicate damage transitions")
	_expect(int(collision_contract["recontact_count"]) == 2, "leave, cooldown expiry, and deliberate recontact must create exactly one new transition")

	var replay_30 := await _replay_trace(30)
	var replay_60 := await _replay_trace(60)
	var replay_120 := await _replay_trace(120)
	_expect(_replays_match(replay_30, replay_60), "30 and 60 Hz render traces must produce the same fixed-step outcome")
	_expect(_replays_match(replay_60, replay_120), "60 and 120 Hz render traces must produce the same fixed-step outcome")

	var world := PrototypeWorld.new()
	root.add_child(world)
	var route_choice_evidence: Dictionary = world.route_choice_evidence() if world.has_method("route_choice_evidence") else {}
	_expect(
		bool(route_choice_evidence.get("connected_choice_contract_pass", false))
		and int(route_choice_evidence.get("reward_route_count", 0)) >= 2,
		"asphalt, dirt, and mud must reconnect to the endpoint while alternate routes expose meaningful payoffs"
	)
	var handling_lab_evidence: Dictionary = world.handling_lab_evidence() if world.has_method("handling_lab_evidence") else {}
	_expect(
		bool(handling_lab_evidence.get("deterministic_handling_lab_contract_pass", false))
		and (handling_lab_evidence.get("slalom_markers", []) as Array).size() == 5
		and int(handling_lab_evidence.get("stuck_fixture_wall_count", 0)) == 3,
		"handling sessions must share marked slalom, braking/reverse, wide-turn, and stuck-recovery fixtures"
	)
	await physics_frame
	var handling_lab_runtime := await _handling_lab_runtime_evidence(world)
	_expect(
		bool(handling_lab_runtime.get("slalom_driveable", false))
		and bool(handling_lab_runtime.get("marked_bay_reverse", false))
		and bool(handling_lab_runtime.get("marked_wide_turn", false))
		and bool(handling_lab_runtime.get("stuck_detected", false))
		and bool(handling_lab_runtime.get("recovered_outside_fixture", false)),
		"marked handling-lab fixtures must exercise real drive, reverse, handbrake, stuck, and outside-anchor recovery behavior: %s" % str(handling_lab_runtime)
	)
	var world_art: Dictionary = world.presentation_evidence() if world.has_method("presentation_evidence") else {}
	var art_probe := PrototypeVehicle.new()
	root.add_child(art_probe)
	var vehicle_art: Dictionary = art_probe.presentation_evidence() if art_probe.has_method("presentation_evidence") else {}
	_expect(
		bool(world_art.get("authored_asset_contract_pass", false)) and bool(vehicle_art.get("authored_asset_contract_pass", false)),
		"world and hero vehicle must use imported authored assets for every Phase-2 recognition category"
	)
	art_probe.queue_free()
	await process_frame
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
	_expect(bool((impact_results[0]["last_collision"] as Dictionary).get("barrier_broken", false)), "qualifying light-barrier impact must break the barrier")
	var broken_fixture_evidence: Dictionary = world.fixture_evidence() if world.has_method("fixture_evidence") else {}
	_expect(not bool(broken_fixture_evidence.get("light_barrier_active", true)), "a broken light barrier must leave collision and presentation inactive")
	if world.has_method("reset_world"):
		world.reset_world()
	await process_frame
	var reset_fixture_evidence: Dictionary = world.fixture_evidence() if world.has_method("fixture_evidence") else {}
	_expect(
		bool(reset_fixture_evidence.get("light_barrier_active", false))
		and int(reset_fixture_evidence.get("active_obstacle_count", 0)) == 3,
		"full world reset must restore every obstacle fixture after a broken barrier"
	)
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
	var audio_evidence: Dictionary = audio.evidence_snapshot() if audio.has_method("evidence_snapshot") else {}
	_expect(
		bool(audio_evidence.get("external_asset_contract_pass", false)),
		"audio must use licensed external resources for three engine layers, surfaces, impacts, warning, reward, and UI"
	)
	_expect(
		bool(audio_evidence.get("monophonic_voice_contract_pass", false))
		and bool(audio_evidence.get("voice_pool_contract_pass", false)),
		"benchmark voice telemetry must count each pooled impact/UI voice independently"
	)
	audio.start()
	var started_audio := audio.evidence_snapshot()
	audio.set_paused(true)
	var paused_audio := audio.evidence_snapshot()
	audio.set_paused(false)
	audio.start()
	var resumed_audio := audio.evidence_snapshot()
	_expect(
		int(started_audio.get("player_count", -1)) == 17
		and int(started_audio.get("loop_player_count", -1)) == 4
		and int(started_audio.get("same_family_impact_voice_capacity", -1)) == 3
		and int(started_audio.get("routine_ui_voice_capacity", -1)) == 2
		and bool(started_audio.get("routing_contract_pass", false)),
		"audio setup must provide countable three-per-family impact and two-voice routine UI pools"
	)
	_expect(bool(paused_audio.get("transport_paused", false)), "audio transport must expose the paused state")
	_expect(
		not bool(resumed_audio.get("transport_paused", true))
		and int(resumed_audio.get("player_count", -1)) == int(started_audio.get("player_count", -2)),
		"resume/start must be idempotent and must not duplicate loop players"
	)
	audio.update_vehicle(1.0, "mud", true)
	audio.reset_state()
	audio.queue_free()
	await process_frame

	var integrated_slice := PrototypeRoot.new()
	root.add_child(integrated_slice)
	await process_frame
	var player_facing_evidence: Dictionary = integrated_slice.player_facing_evidence() if integrated_slice.has_method("player_facing_evidence") else {}
	_expect(
		bool(player_facing_evidence.get("candidate_hud_contract_pass", false)),
		"exported slice must use licensed fonts, honest Fuel/Integrity/direction facts, and no visible debug vocabulary"
	)
	var initial_visible_copy := String(player_facing_evidence.get("visible_copy", ""))
	_expect(not initial_visible_copy.contains("recover"), "onboarding must reveal recovery only when the vehicle is actually stuck")
	_expect(not (initial_visible_copy.contains("wasd") and initial_visible_copy.contains(" y ")), "onboarding must show one active input source instead of mixed keyboard/controller glyphs")
	_expect(not PrototypeRoot.is_valid_benchmark_mode("capcity"), "unknown benchmark modes must be rejected instead of silently becoming feel mode")
	var facilitator_configured := integrated_slice.configure_facilitator_lab("scout") if integrated_slice.has_method("configure_facilitator_lab") else false
	var lab_evidence: Dictionary = integrated_slice.facilitator_lab_evidence() if integrated_slice.has_method("facilitator_lab_evidence") else {}
	_expect(
		facilitator_configured
		and bool(lab_evidence.get("release_tune_selection_supported", false))
		and String(lab_evidence.get("selected_tune", "")) == "scout",
		"frozen release handling sessions must support facilitator-only selection of every tune"
	)
	var camera_evidence: Dictionary = integrated_slice.camera_evidence() if integrated_slice.has_method("camera_evidence") else {}
	_expect(
		bool(camera_evidence.get("dedicated_camera_contract_pass", false)),
		"exported slice must use a dedicated look-ahead rig with impact impulse and Reduced Motion"
	)
	integrated_slice.queue_free()
	await process_frame

	if failures.is_empty():
		print("PROTOTYPE_HANDLING_SMOKE road=%.1f dirt=%.1f mud=%.1f scout=%.1f hauler=%.1f tunes=speed_turn_grip_impact fixed_step_batch_30_60_120=true impacts=light_medium_heavy full_reset=true external_audio=true pass=true" % [road_speed, dirt_speed, mud_speed, scout_speed, hauler_speed])
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


func _handling_lab_runtime_evidence(world: Node2D) -> Dictionary:
	var slalom_driveable := true
	for marker_position in PrototypeWorld.SLALOM_MARKER_POSITIONS:
		slalom_driveable = slalom_driveable and String(world.surface_at(marker_position)["name"]) == "road"

	var bay_car := PrototypeVehicle.new()
	root.add_child(bay_car)
	bay_car.set_physics_process(false)
	bay_car.reset_prototype(PrototypeWorld.BRAKING_REVERSE_BAY_POSITION)
	for tick in 90:
		bay_car.step_vehicle({"throttle": 1.0}, world.surface_at(bay_car.global_position), 1.0 / 60.0)
	for tick in 180:
		bay_car.step_vehicle({"brake": 1.0}, world.surface_at(bay_car.global_position), 1.0 / 60.0)
	var marked_bay_reverse := float(bay_car.telemetry_snapshot()["forward_speed"]) < -20.0
	bay_car.queue_free()

	var turn_car := PrototypeVehicle.new()
	root.add_child(turn_car)
	turn_car.set_physics_process(false)
	turn_car.reset_prototype(PrototypeWorld.WIDE_HANDBRAKE_TURN_POSITION)
	turn_car.rotation = -0.38
	for tick in 45:
		turn_car.step_vehicle({"throttle": 1.0}, world.surface_at(turn_car.global_position), 1.0 / 60.0)
	var turn_start_rotation := turn_car.rotation
	var peak_handbrake_lateral_speed := 0.0
	for tick in 45:
		var turn_state := turn_car.step_vehicle(
			{"throttle": 0.75, "steer": 0.72, "handbrake": 0.72},
			world.surface_at(turn_car.global_position),
			1.0 / 60.0
		)
		peak_handbrake_lateral_speed = maxf(peak_handbrake_lateral_speed, float(turn_state["lateral_speed"]))
	var turn_rotation_delta := absf(turn_car.rotation - turn_start_rotation)
	var marked_wide_turn := turn_rotation_delta > 0.18 and peak_handbrake_lateral_speed > 12.0
	turn_car.queue_free()

	var recovery_car := PrototypeVehicle.new()
	root.add_child(recovery_car)
	recovery_car.set_physics_process(false)
	recovery_car.reset_prototype(PrototypeWorld.STUCK_RECOVERY_ANCHOR)
	recovery_car.rotation = PI / 2.0
	var stuck_detected := false
	for tick in 240:
		var stuck_state := recovery_car.step_vehicle(
			{"throttle": 1.0},
			world.surface_at(recovery_car.global_position),
			1.0 / 60.0
		)
		stuck_detected = stuck_detected or bool(stuck_state["stuck"])
		if stuck_detected:
			break
	var recovered := false
	for tick in 40:
		var recovery_state := recovery_car.step_vehicle(
			{"recovery_pressed": true},
			world.surface_at(recovery_car.global_position),
			1.0 / 60.0
		)
		if bool(recovery_state["recovered"]):
			recovered = true
			break
	var recovered_outside_fixture := (
		recovered
		and recovery_car.global_position.distance_to(PrototypeWorld.STUCK_RECOVERY_ANCHOR) <= 1.0
		and recovery_car.global_position.y < 230.0
	)
	recovery_car.queue_free()
	return {
		"slalom_driveable": slalom_driveable,
		"marked_bay_reverse": marked_bay_reverse,
		"marked_wide_turn": marked_wide_turn,
		"turn_rotation_delta": turn_rotation_delta,
		"peak_handbrake_lateral_speed": peak_handbrake_lateral_speed,
		"stuck_detected": stuck_detected,
		"recovered_outside_fixture": recovered_outside_fixture,
	}

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

func _thin_barrier_and_recontact_contract() -> Dictionary:
	var barrier := StaticBody2D.new()
	barrier.global_position = Vector2(320.0, 760.0)
	barrier.set_meta(&"weight", "medium")
	barrier.set_meta(&"damage", 12.0)
	var shape_node := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(2.0, 180.0)
	shape_node.shape = rectangle
	barrier.add_child(shape_node)
	root.add_child(barrier)

	var car := PrototypeVehicle.new()
	car.global_position = Vector2(120.0, 760.0)
	root.add_child(car)
	car.set_physics_process(false)
	await physics_frame
	car.velocity = Vector2(2_400.0, 0.0)
	for i in range(12):
		car.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	var first_impact_count := int(car.telemetry_snapshot()["impact_count"])
	for i in range(8):
		car.step_vehicle({"throttle": 1.0}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	var held_contact_count := int(car.telemetry_snapshot()["impact_count"])

	car.global_position = Vector2(120.0, 760.0)
	car.velocity = Vector2.ZERO
	for i in range(20):
		car.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	car.velocity = Vector2(2_400.0, 0.0)
	for i in range(12):
		car.step_vehicle({}, {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 0.0}, 1.0 / 60.0)
	var result := {
		"first_impact_count": first_impact_count,
		"held_contact_count": held_contact_count,
		"recontact_count": int(car.telemetry_snapshot()["impact_count"]),
	}
	car.queue_free()
	barrier.queue_free()
	await process_frame
	return result

func _expect(condition:bool, message:String) -> void:
	if not condition:
		failures.append(message)
