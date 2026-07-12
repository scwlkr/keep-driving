extends Node2D

# PROTOTYPE — Desktop Truth Slice A. No persistence. Delete or absorb after verdict.
# Question: can fixed-step production-candidate handling, real collision, one authored
# route choice, honest HUD facts, and audible feedback support Keep Driving's hero minute?

const DriveIntent = preload("res://prototypes/handling_truth_slice/drive_intent.gd")
const PrototypeVehicle = preload("res://prototypes/handling_truth_slice/prototype_vehicle.gd")
const PrototypeWorld = preload("res://prototypes/handling_truth_slice/prototype_world.gd")
const PrototypeAudio = preload("res://prototypes/handling_truth_slice/prototype_audio.gd")
const PrototypeCameraRigScript = preload("res://prototypes/handling_truth_slice/prototype_camera_rig.gd")
const TimingAccumulator = preload("res://prototypes/handling_truth_slice/timing_accumulator.gd")
const UI_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Regular.otf")
const UI_FONT_BOLD: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Bold.otf")
const DISPLAY_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/BarlowCondensed-Bold.otf")
const FUEL_ICON: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/fuel.svg")
const INTEGRITY_ICON: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/integrity.svg")
const BUILD_PROVENANCE_FILENAME := "handling-truth-slice-provenance.json"
const SHORT_RSS_SAMPLE_INTERVAL_SECONDS := 1.0
const FULL_RSS_SAMPLE_INTERVAL_SECONDS := 10.0
const FULL_RSS_MINIMUM_SAMPLES := 120
const RSS_SCHEDULE_TOLERANCE_SECONDS := 0.25
const PHYSICS_TICKS_PER_SECOND := 60
const WORLD_WORK_P95_LIMIT_MS := 4.0
const MEMORY_PLATEAU_LIMIT_PERCENT := 5.0
const CADENCE_RATE_TOLERANCE_PERCENT := 10.0
const SLOW_FRAME_THRESHOLD_MS := 50.0
const RETAINED_SLOW_FRAME_LIMIT := 32
const BENCHMARK_TRACE_SEED := 80_806_012

var world
var vehicle
var audio
var camera:Camera2D
var fuel_value:Label
var integrity_value:Label
var fuel_bar:ProgressBar
var integrity_bar:ProgressBar
var objective_title:Label
var objective:Label
var objective_detail:Label
var controls:Label
var telemetry:Label
var reached_relay := false
var completed_return := false
var last_impact_serial := 0
var telemetry_visible := false
var auto_drive := false
var auto_stop := false
var fuel := 72.0
var instruction_elapsed := 0.0
var collected_route_rewards := {}
var route_reward_message := ""
var route_reward_message_seconds := 0.0
var facilitator_lab_mode := false
var selected_lab_tune := "balanced"
var active_input_source := "keyboard"
var active_input_device := -1
var demonstrated_drive := false
var demonstrated_steer := false
var demonstrated_handbrake := false
var benchmark_enabled := false
var benchmark_mode := "feel"
var benchmark_expected_build_id := "unrecorded"
var benchmark_embedded_build_id := "unrecorded"
var benchmark_embedded_dirty := true
var benchmark_duration_seconds := 60.0
var benchmark_warmup_seconds := 5.0
var benchmark_elapsed := 0.0
var benchmark_physics_elapsed := 0.0
var benchmark_physics_ticks := 0
var benchmark_target_physics_ticks := 0
var benchmark_warmup_physics_ticks := 0
var benchmark_cycle := -1
var benchmark_frame_timing := TimingAccumulator.new()
var benchmark_world_work_timing := TimingAccumulator.new()
var benchmark_slow_frame_count := 0
var benchmark_slow_frame_samples:Array[Dictionary] = []
var benchmark_peak_static_memory_bytes := 0.0
var benchmark_peak_rss_bytes := 0.0
var benchmark_rss_sample_interval_seconds := SHORT_RSS_SAMPLE_INTERVAL_SECONDS
var benchmark_next_rss_sample_seconds := SHORT_RSS_SAMPLE_INTERVAL_SECONDS
var benchmark_rss_samples:Array[Dictionary] = []
var benchmark_rss_sample_count := 0
var benchmark_rss_sample_failures := 0
var benchmark_rss_missed_schedule_count := 0
var benchmark_rss_thread := Thread.new()
var benchmark_rss_probe_scheduled_seconds := 0.0
var benchmark_rss_probe_observed_seconds := 0.0
var benchmark_peak_nodes := 0
var benchmark_peak_draw_calls := 0
var benchmark_peak_physics_objects := 0
var benchmark_peak_texture_memory_bytes := 0.0
var benchmark_peak_buffer_memory_bytes := 0.0
var benchmark_peak_video_memory_bytes := 0.0
var benchmark_peak_texture_resources := 0
var benchmark_peak_material_resources := 0
var benchmark_collision_queries := 0
var benchmark_measured_collision_queries := 0
var benchmark_last_vehicle_collision_query_count := 0
var benchmark_collision_query_count_source := "root fixed-step fallback"
var benchmark_collision_contacts := 0
var benchmark_peak_active_effects := 0
var benchmark_peak_effect_particles := 0
var benchmark_peak_active_audio_voices := 0
var benchmark_render_hz := 0
var benchmark_effective_max_fps := 0
var benchmark_report_path := ""
var benchmark_rss_path := ""
var benchmark_artifact_paths:PackedStringArray = []
var benchmark_require_acceptance := false
var benchmark_configuration_valid := true
var benchmark_cadence_debug_unbound := false
var benchmark_report_path_explicit := false
var benchmark_rss_path_explicit := false
var benchmark_evidence_paths_absolute := true
var benchmark_package_facts := {}
var clean_exit_scheduled := false

func _ready() -> void:
	get_tree().auto_accept_quit = false
	Engine.physics_ticks_per_second = PHYSICS_TICKS_PER_SECOND
	world = PrototypeWorld.new()
	world.name = "PROTOTYPE_FirstRoad"
	add_child(world)
	vehicle = PrototypeVehicle.new()
	vehicle.name = "PROTOTYPE_FixedStepVehicle"
	vehicle.global_position = PrototypeWorld.START_POSITION
	add_child(vehicle)
	vehicle.set_physics_process(false)
	audio = PrototypeAudio.new()
	audio.name = "PROTOTYPE_RealAudio"
	add_child(audio)
	if audio.has_method("setup"):
		audio.setup()
	if audio.has_method("start"):
		audio.start()
	camera = PrototypeCameraRigScript.new()
	camera.name = "FirstRoadCameraRig"
	add_child(camera)
	camera.setup(vehicle)
	var connected_joypads := Input.get_connected_joypads()
	active_input_source = "controller" if not connected_joypads.is_empty() else "keyboard"
	active_input_device = int(connected_joypads[0]) if not connected_joypads.is_empty() else -1
	_build_ui()
	_load_build_provenance()
	_configure_benchmark()
	_update_ui({})

func _physics_process(delta:float) -> void:
	if benchmark_enabled and benchmark_physics_ticks >= benchmark_target_physics_ticks:
		return
	var intent := DriveIntent.sample()
	if benchmark_enabled:
		intent = _benchmark_intent(delta)
	elif auto_stop:
		intent = {"brake": 1.0}
		if vehicle.speed < 5.0:
			auto_stop = false
	elif auto_drive:
		intent["throttle"] = 1.0
	_update_onboarding_state(intent)
	var drive_load := maxf(float(intent.get("throttle", 0.0)), float(intent.get("brake", 0.0)) * 0.35)
	fuel = maxf(0.0, fuel - (0.08 + drive_load * 0.19) * delta)
	instruction_elapsed += delta
	route_reward_message_seconds = maxf(0.0, route_reward_message_seconds - delta)
	var world_work_started_usec := Time.get_ticks_usec()
	var surface:Dictionary = world.surface_at(vehicle.global_position)
	var world_work_ms := float(Time.get_ticks_usec() - world_work_started_usec) / 1000.0
	var snapshot:Dictionary = vehicle.step_vehicle(intent, surface, delta)
	if benchmark_enabled:
		benchmark_physics_ticks += 1
		var current_vehicle_collision_queries := int(snapshot.get("collision_query_count", -1))
		var collision_queries_this_step := 1
		if current_vehicle_collision_queries >= 0:
			collision_queries_this_step = (
				current_vehicle_collision_queries
				if current_vehicle_collision_queries < benchmark_last_vehicle_collision_query_count
				else current_vehicle_collision_queries - benchmark_last_vehicle_collision_query_count
			)
			benchmark_last_vehicle_collision_query_count = current_vehicle_collision_queries
			benchmark_collision_query_count_source = "sum of PrototypeVehicle collision_query_count telemetry deltas"
		benchmark_collision_queries += collision_queries_this_step
		benchmark_peak_active_effects = maxi(
			benchmark_peak_active_effects,
			maxi(int(snapshot.get("active_effect_emitters", 0)), int(snapshot.get("peak_effect_emitters", 0)))
		)
		if benchmark_physics_ticks > benchmark_warmup_physics_ticks:
			benchmark_world_work_timing.add_sample(world_work_ms)
			benchmark_measured_collision_queries += collision_queries_this_step
			if bool(snapshot.get("contact_active", false)):
				benchmark_collision_contacts += 1
	camera.step_camera(delta)

	var impact_serial := int(snapshot.get("impact_serial", 0))
	if impact_serial != last_impact_serial:
		last_impact_serial = impact_serial
		var impact_weight := str(snapshot.get("last_impact_weight", "medium"))
		audio.play_impact(impact_weight)
		camera.add_impact_impulse(impact_weight)

	var integrity := float(snapshot.get("integrity", 100.0))
	audio.update_vehicle(
		clampf(float(snapshot.get("speed", 0.0)) / maxf(float(snapshot.get("max_speed", 1.0)), 1.0), 0.0, 1.0),
		str(surface["name"]),
		integrity <= 25.0 or fuel <= 20.0,
		drive_load
	)
	if benchmark_enabled:
		_sample_runtime_counts()
	var route_reward:Dictionary = world.route_reward_at(vehicle.global_position)
	if not route_reward.is_empty() and not collected_route_rewards.has(String(route_reward["id"])):
		collected_route_rewards[String(route_reward["id"])] = true
		var fuel_before := fuel
		fuel = minf(100.0, fuel + float(route_reward["fuel"]))
		var fuel_gained := maxi(1, roundi(fuel - fuel_before))
		route_reward_message = "%s secured: +%d Fuel" % [String(route_reward["label"]), fuel_gained]
		route_reward_message_seconds = 3.0
		audio.play_reward()

	if not reached_relay and vehicle.global_position.distance_to(PrototypeWorld.GOAL_POSITION) <= 105.0:
		reached_relay = true
		auto_drive = false
		auto_stop = true
		audio.play_reward()
	if reached_relay and not completed_return and vehicle.global_position.distance_to(PrototypeWorld.START_POSITION) <= 145.0:
		completed_return = true
		audio.play_ui()
	_update_ui(snapshot)

func _process(delta:float) -> void:
	if not benchmark_enabled:
		return
	benchmark_elapsed += delta
	benchmark_peak_static_memory_bytes = maxf(benchmark_peak_static_memory_bytes, maxf(Performance.get_monitor(Performance.MEMORY_STATIC), float(OS.get_static_memory_usage())))
	var simulation_seconds := float(benchmark_physics_ticks) / float(PHYSICS_TICKS_PER_SECOND)
	_poll_rss_probe(false)
	if benchmark_next_rss_sample_seconds <= simulation_seconds and not benchmark_rss_thread.is_started():
		var due_sample_count := rss_due_sample_count(
			benchmark_next_rss_sample_seconds,
			simulation_seconds,
			benchmark_rss_sample_interval_seconds
		)
		if due_sample_count > 1:
			var missed_before_latest := due_sample_count - 1
			benchmark_rss_missed_schedule_count += missed_before_latest
			benchmark_next_rss_sample_seconds += float(missed_before_latest) * benchmark_rss_sample_interval_seconds
		_start_rss_probe(benchmark_next_rss_sample_seconds, simulation_seconds)
		benchmark_next_rss_sample_seconds += benchmark_rss_sample_interval_seconds
	benchmark_peak_nodes = maxi(benchmark_peak_nodes, roundi(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)))
	benchmark_peak_draw_calls = maxi(benchmark_peak_draw_calls, roundi(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	benchmark_peak_physics_objects = maxi(benchmark_peak_physics_objects, roundi(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)))
	benchmark_peak_texture_memory_bytes = maxf(benchmark_peak_texture_memory_bytes, float(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TEXTURE_MEM_USED)))
	benchmark_peak_buffer_memory_bytes = maxf(benchmark_peak_buffer_memory_bytes, float(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_BUFFER_MEM_USED)))
	benchmark_peak_video_memory_bytes = maxf(benchmark_peak_video_memory_bytes, float(RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_VIDEO_MEM_USED)))
	_sample_runtime_counts()
	if benchmark_physics_ticks > benchmark_warmup_physics_ticks:
		var frame_ms := delta * 1000.0
		benchmark_frame_timing.add_sample(frame_ms)
		if frame_ms >= SLOW_FRAME_THRESHOLD_MS:
			benchmark_slow_frame_count += 1
			if benchmark_slow_frame_samples.size() < RETAINED_SLOW_FRAME_LIMIT:
				benchmark_slow_frame_samples.append({
					"sample_ordinal": benchmark_frame_timing.sample_count,
					"frame_ms": frame_ms,
					"physics_ticks": benchmark_physics_ticks,
					"simulation_seconds": simulation_seconds,
					"benchmark_cycle": benchmark_cycle,
					"rss_probe_in_flight": benchmark_rss_thread.is_alive(),
					"monotonic_ticks_ms": Time.get_ticks_msec(),
				})
	if benchmark_physics_ticks >= benchmark_target_physics_ticks:
		_report_benchmark_and_quit()

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			_reset_slice()
		elif event.keycode == KEY_ESCAPE:
			_schedule_clean_exit(0)
		elif event.keycode == KEY_M:
			camera.toggle_reduced_motion()
		elif OS.is_debug_build() or facilitator_lab_mode:
			if event.keycode == KEY_T:
				telemetry_visible = not telemetry_visible
				telemetry.visible = telemetry_visible
			elif event.keycode == KEY_G:
				auto_drive = not auto_drive
				auto_stop = false
			elif event.keycode == KEY_1:
				_select_tune("balanced")
			elif event.keycode == KEY_2:
				_select_tune("scout")
			elif event.keycode == KEY_3:
				_select_tune("hauler")

func _build_ui() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "FirstRoadHUD"
	add_child(canvas)

	var status_panel := PanelContainer.new()
	status_panel.name = "DriveStatusCard"
	status_panel.position = Vector2(24, 24)
	status_panel.size = Vector2(430, 108)
	status_panel.add_theme_stylebox_override("panel", _panel_style(Color("171818"), Color("d6b978"), 0.94))
	canvas.add_child(status_panel)
	var status_margin := MarginContainer.new()
	status_margin.add_theme_constant_override("margin_left", 16)
	status_margin.add_theme_constant_override("margin_right", 16)
	status_margin.add_theme_constant_override("margin_top", 11)
	status_margin.add_theme_constant_override("margin_bottom", 11)
	status_panel.add_child(status_margin)
	var status_column := VBoxContainer.new()
	status_column.add_theme_constant_override("separation", 7)
	status_margin.add_child(status_column)
	status_column.add_child(_make_label("DRIVE STATUS", DISPLAY_FONT, 17, Color("d6b978")))
	var facts := HBoxContainer.new()
	facts.add_theme_constant_override("separation", 18)
	status_column.add_child(facts)
	facts.add_child(_make_icon(FUEL_ICON, Vector2(34, 34)))
	var fuel_column := VBoxContainer.new()
	fuel_column.custom_minimum_size = Vector2(150, 48)
	fuel_value = _make_label("FUEL 100", UI_FONT_BOLD, 17, Color("f1e8cf"))
	fuel_column.add_child(fuel_value)
	fuel_bar = _make_bar(Color("f0c547"))
	fuel_column.add_child(fuel_bar)
	facts.add_child(fuel_column)
	facts.add_child(_make_icon(INTEGRITY_ICON, Vector2(34, 34)))
	var integrity_column := VBoxContainer.new()
	integrity_column.custom_minimum_size = Vector2(150, 48)
	integrity_value = _make_label("INTEGRITY 100", UI_FONT_BOLD, 17, Color("f1e8cf"))
	integrity_column.add_child(integrity_value)
	integrity_bar = _make_bar(Color("63b7c5"))
	integrity_column.add_child(integrity_bar)
	facts.add_child(integrity_column)

	var objective_panel := PanelContainer.new()
	objective_panel.name = "ObjectiveCard"
	objective_panel.position = Vector2(24, 148)
	objective_panel.size = Vector2(430, 102)
	objective_panel.add_theme_stylebox_override("panel", _panel_style(Color("171818"), Color("2f7775"), 0.92))
	canvas.add_child(objective_panel)
	var objective_margin := MarginContainer.new()
	objective_margin.add_theme_constant_override("margin_left", 16)
	objective_margin.add_theme_constant_override("margin_right", 16)
	objective_margin.add_theme_constant_override("margin_top", 10)
	objective_margin.add_theme_constant_override("margin_bottom", 10)
	objective_panel.add_child(objective_margin)
	var objective_column := VBoxContainer.new()
	objective_column.add_theme_constant_override("separation", 1)
	objective_margin.add_child(objective_column)
	objective_title = _make_label("RADIO RELAY", DISPLAY_FONT, 18, Color("63b7c5"))
	objective_column.add_child(objective_title)
	objective = _make_label("→  180 m", UI_FONT_BOLD, 25, Color("f1e8cf"))
	objective_column.add_child(objective)
	objective_detail = _make_label("Choose asphalt, dirt, or mud. Bring the signal home.", UI_FONT, 15, Color("d6b978"))
	objective_column.add_child(objective_detail)

	controls = Label.new()
	controls.position = Vector2(24, 670)
	controls.text = "W / S  DRIVE"
	controls.add_theme_font_override("font", UI_FONT_BOLD)
	controls.add_theme_font_size_override("font_size", 15)
	controls.add_theme_color_override("font_color", Color("f1e8cf"))
	controls.add_theme_color_override("font_outline_color", Color("171818"))
	controls.add_theme_constant_override("outline_size", 5)
	canvas.add_child(controls)

	telemetry = Label.new()
	telemetry.position = Vector2(482, 24)
	telemetry.add_theme_font_override("font", UI_FONT)
	telemetry.add_theme_font_size_override("font_size", 14)
	telemetry.add_theme_color_override("font_color", Color("f0c547"))
	telemetry.add_theme_color_override("font_outline_color", Color("171818"))
	telemetry.add_theme_constant_override("outline_size", 4)
	telemetry.visible = false
	canvas.add_child(telemetry)

func _update_ui(snapshot:Dictionary) -> void:
	var integrity := float(snapshot.get("integrity", 100.0))
	var speed := float(snapshot.get("speed", 0.0))
	fuel_value.text = "FUEL %03d" % roundi(fuel)
	integrity_value.text = "INTEGRITY %03d" % roundi(integrity)
	fuel_bar.value = fuel
	integrity_bar.value = integrity
	if completed_return:
		objective_title.text = "FIRST ROAD COMPLETE"
		objective.text = "✓  RELAY SECURED"
		objective_detail.text = "Signal restored. Press R to drive again."
	elif reached_relay:
		var return_distance:float = vehicle.global_position.distance_to(PrototypeWorld.START_POSITION)
		objective_title.text = "RETURN ROUTE"
		objective.text = "%s  %03d m" % [_direction_arrow(PrototypeWorld.START_POSITION), roundi(return_distance / 10.0)]
		objective_detail.text = "Relay secured. Bring the signal back to the Garage."
	else:
		var distance:float = vehicle.global_position.distance_to(PrototypeWorld.GOAL_POSITION)
		objective_title.text = "RADIO RELAY"
		objective.text = "%s  %03d m" % [_direction_arrow(PrototypeWorld.GOAL_POSITION), roundi(distance / 10.0)]
		objective_detail.text = "Asphalt is fastest. Dirt and mud carry reserve caches."
	if route_reward_message_seconds > 0.0:
		objective_detail.text = route_reward_message
	var stuck := bool(snapshot.get("stuck", false))
	controls.text = _onboarding_prompt(stuck)
	controls.visible = not benchmark_enabled and not controls.text.is_empty()
	telemetry.text = "DEVELOPMENT TELEMETRY\nintent=%s\nsurface=%s\nposition=%s\nvelocity=%s\nimpact=%s" % [
		str(snapshot.get("intent", {})),
		str(snapshot.get("surface", "")),
		str(vehicle.global_position.round()),
		str(vehicle.velocity.round()),
		str(snapshot.get("last_impact_weight", "none")),
	]


func player_facing_evidence() -> Dictionary:
	var font_paths := [UI_FONT.resource_path, UI_FONT_BOLD.resource_path, DISPLAY_FONT.resource_path]
	var fonts_valid := true
	for path in font_paths:
		fonts_valid = fonts_valid and String(path).begins_with("res://") and FileAccess.file_exists(String(path))
	var visible_copy := " ".join([
		fuel_value.text,
		integrity_value.text,
		objective_title.text,
		objective.text,
		objective_detail.text,
		controls.text if controls.visible else "",
	]).to_lower()
	var forbidden := ["prototype", "test lot", "telemetry", "auto-gas", "balanced", "scout", "hauler"]
	var clean_copy := true
	for term in forbidden:
		clean_copy = clean_copy and not visible_copy.contains(term)
	var has_direction := false
	for arrow in ["→", "↘", "↓", "↙", "←", "↖", "↑", "↗"]:
		has_direction = has_direction or objective.text.contains(arrow)
	return {
		"candidate_hud_contract_pass": fonts_valid and clean_copy and has_direction and visible_copy.contains("fuel") and visible_copy.contains("integrity"),
		"font_paths": font_paths,
		"visible_copy": visible_copy,
		"has_direction": has_direction,
		"debug_vocabulary_visible": not clean_copy,
	}


func camera_evidence() -> Dictionary:
	return camera.evidence_snapshot() if camera != null and camera.has_method("evidence_snapshot") else {}


static func is_valid_benchmark_mode(value: String) -> bool:
	return value in ["feel", "capacity"]


static func benchmark_vsync_mode(value: String, render_hz: int) -> DisplayServer.VSyncMode:
	return DisplayServer.VSYNC_DISABLED if render_hz > 0 or value == "capacity" else DisplayServer.VSYNC_ENABLED


static func benchmark_max_fps(value: String, render_hz: int) -> int:
	if render_hz > 0:
		return render_hz
	return PHYSICS_TICKS_PER_SECOND if value == "feel" else 0


static func benchmark_rss_interval_seconds(duration_seconds: float) -> float:
	return FULL_RSS_SAMPLE_INTERVAL_SECONDS if duration_seconds >= 1800.0 else SHORT_RSS_SAMPLE_INTERVAL_SECONDS


static func rss_due_sample_count(next_scheduled_seconds: float, final_simulation_seconds: float, interval_seconds: float) -> int:
	if interval_seconds <= 0.0 or next_scheduled_seconds > final_simulation_seconds:
		return 0
	return floori((final_simulation_seconds - next_scheduled_seconds) / interval_seconds) + 1


static func rss_schedule_on_time(scheduled_seconds: float, observed_seconds: float) -> bool:
	return observed_seconds - scheduled_seconds <= RSS_SCHEDULE_TOLERANCE_SECONDS


static func rss_probe_result_valid(result: Dictionary, schedule_on_time: bool) -> bool:
	return (
		float(result.get("rss_bytes", 0.0)) > 0.0
		and int(result.get("probe_exit_code", -1)) == 0
		and int(result.get("thread_start_error", -1)) == 0
		and bool(result.get("worker_thread", false))
		and schedule_on_time
	)


static func memory_plateau_for_samples(
	measured_bytes: Array[float],
	duration_seconds: float,
	sample_interval_seconds: float
) -> Dictionary:
	if measured_bytes.size() < 2:
		return {
			"evidence_valid": false,
			"within_limit": false,
			"limit_percent": MEMORY_PLATEAU_LIMIT_PERCENT,
			"measured_sample_count": measured_bytes.size(),
			"window_sample_count": 0,
			"window_span_seconds": 0.0,
			"delta_percent": null,
			"absolute_delta_percent": null,
		}
	var window_sample_count := maxi(1, floori(float(measured_bytes.size()) * 0.10))
	window_sample_count = mini(window_sample_count, floori(float(measured_bytes.size()) / 2.0))
	var first_window_total := 0.0
	var final_window_total := 0.0
	for index in window_sample_count:
		first_window_total += measured_bytes[index]
		final_window_total += measured_bytes[measured_bytes.size() - window_sample_count + index]
	var first_window_mean := first_window_total / float(window_sample_count)
	var final_window_mean := final_window_total / float(window_sample_count)
	var delta_percent := (final_window_mean - first_window_mean) / maxf(first_window_mean, 1.0) * 100.0
	var evidence_valid := (
		duration_seconds >= 1800.0
		and measured_bytes.size() >= FULL_RSS_MINIMUM_SAMPLES
		and window_sample_count >= floori(float(FULL_RSS_MINIMUM_SAMPLES) * 0.10)
	)
	return {
		"evidence_valid": evidence_valid,
		"within_limit": evidence_valid and absf(delta_percent) <= MEMORY_PLATEAU_LIMIT_PERCENT,
		"limit_percent": MEMORY_PLATEAU_LIMIT_PERCENT,
		"measured_sample_count": measured_bytes.size(),
		"window_sample_count": window_sample_count,
		"window_span_seconds": float(window_sample_count) * sample_interval_seconds,
		"first_window_mean_mb": first_window_mean / (1024.0 * 1024.0),
		"final_window_mean_mb": final_window_mean / (1024.0 * 1024.0),
		"delta_percent": delta_percent,
		"absolute_delta_percent": absf(delta_percent),
	}


static func controller_glyphs_for_name(device_name: String) -> Dictionary:
	var normalized := device_name.to_lower()
	if normalized.contains("playstation") or normalized.contains("dualshock") or normalized.contains("dualsense"):
		return {"drive": "R2 / L2", "steer": "LEFT STICK", "handbrake": "CROSS", "recovery": "TRIANGLE"}
	if normalized.contains("nintendo") or normalized.contains("joy-con") or normalized.contains("switch"):
		return {"drive": "ZR / ZL", "steer": "LEFT STICK", "handbrake": "B", "recovery": "X"}
	if normalized.contains("xbox") or normalized.contains("xinput"):
		return {"drive": "RT / LT", "steer": "LEFT STICK", "handbrake": "A", "recovery": "Y"}
	return {"drive": "R2 / L2", "steer": "LEFT STICK", "handbrake": "SOUTH BUTTON", "recovery": "NORTH BUTTON"}


func configure_facilitator_lab(tune_name: String) -> bool:
	var normalized := tune_name.to_lower()
	if normalized not in ["balanced", "scout", "hauler"]:
		return false
	facilitator_lab_mode = true
	selected_lab_tune = normalized
	vehicle.set_tune(normalized)
	_reset_slice()
	return true


func facilitator_lab_evidence() -> Dictionary:
	return {
		"release_tune_selection_supported": has_method("configure_facilitator_lab"),
		"lab_mode": facilitator_lab_mode,
		"selected_tune": selected_lab_tune,
		"available_tunes": ["balanced", "scout", "hauler"],
	}


func _panel_style(background: Color, border: Color, alpha: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(background, alpha)
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(7)
	return style


func _make_label(text_value: String, font: Font, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _make_icon(texture: Texture2D, minimum_size: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = texture
	icon.custom_minimum_size = minimum_size
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon


func _make_bar(fill_color: Color) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(150, 7)
	bar.max_value = 100.0
	bar.value = 100.0
	bar.show_percentage = false
	var background := StyleBoxFlat.new()
	background.bg_color = Color("363936")
	background.set_corner_radius_all(3)
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("background", background)
	bar.add_theme_stylebox_override("fill", fill)
	return bar


func _direction_arrow(target: Vector2) -> String:
	var vehicle_position: Vector2 = vehicle.global_position
	var target_angle: float = (target - vehicle_position).angle()
	var relative := wrapf(target_angle - vehicle.rotation, -PI, PI)
	var index := posmod(roundi(relative / (PI / 4.0)), 8)
	return ["→", "↘", "↓", "↙", "←", "↖", "↑", "↗"][index]

func _configure_benchmark() -> void:
	var requested_lab_tune := "balanced"
	for argument in OS.get_cmdline_user_args():
		if argument == "--prototype-benchmark":
			benchmark_enabled = true
		elif argument.begins_with("--prototype-benchmark-seconds="):
			benchmark_enabled = true
			benchmark_duration_seconds = maxf(1.0, float(argument.get_slice("=", 1)))
		elif argument.begins_with("--prototype-benchmark-warmup="):
			benchmark_warmup_seconds = maxf(0.0, float(argument.get_slice("=", 1)))
		elif argument.begins_with("--prototype-benchmark-mode="):
			benchmark_enabled = true
			benchmark_mode = String(argument.get_slice("=", 1)).to_lower()
		elif argument.begins_with("--prototype-build-id="):
			benchmark_expected_build_id = String(argument.get_slice("=", 1)).strip_edges().to_lower()
		elif argument.begins_with("--prototype-render-hz="):
			benchmark_enabled = true
			benchmark_render_hz = int(argument.get_slice("=", 1))
		elif argument.begins_with("--prototype-benchmark-report="):
			var report_path_value := String(argument.get_slice("=", 1)).strip_edges()
			benchmark_report_path_explicit = true
			benchmark_evidence_paths_absolute = benchmark_evidence_paths_absolute and report_path_value.is_absolute_path()
			benchmark_report_path = _absolute_evidence_path(report_path_value)
		elif argument.begins_with("--prototype-benchmark-rss="):
			var rss_path_value := String(argument.get_slice("=", 1)).strip_edges()
			benchmark_rss_path_explicit = true
			benchmark_evidence_paths_absolute = benchmark_evidence_paths_absolute and rss_path_value.is_absolute_path()
			benchmark_rss_path = _absolute_evidence_path(rss_path_value)
		elif argument.begins_with("--prototype-benchmark-artifact="):
			var artifact_path_value := String(argument.get_slice("=", 1)).strip_edges()
			benchmark_evidence_paths_absolute = benchmark_evidence_paths_absolute and artifact_path_value.is_absolute_path()
			benchmark_artifact_paths.append(_absolute_evidence_path(artifact_path_value))
		elif argument == "--prototype-benchmark-require-acceptance":
			benchmark_require_acceptance = true
		elif argument == "--prototype-cadence-debug":
			benchmark_cadence_debug_unbound = true
		elif argument == "--prototype-reduced-motion":
			camera.set_reduced_motion(true)
		elif argument == "--prototype-lab-mode":
			facilitator_lab_mode = true
		elif argument.begins_with("--prototype-tune="):
			facilitator_lab_mode = true
			requested_lab_tune = String(argument.get_slice("=", 1)).to_lower()
	if not is_valid_benchmark_mode(benchmark_mode):
		benchmark_configuration_valid = false
		push_error("--prototype-benchmark-mode must be feel or capacity")
	if facilitator_lab_mode and not configure_facilitator_lab(requested_lab_tune):
		benchmark_configuration_valid = false
		push_error("--prototype-tune must be balanced, scout, or hauler")
	if benchmark_enabled:
		if benchmark_render_hz not in [0, 30, 60, 120]:
			benchmark_configuration_valid = false
			push_error("--prototype-render-hz must be 30, 60, or 120")
	if not benchmark_configuration_valid:
		call_deferred("_schedule_clean_exit", 2)
		return
	if benchmark_enabled:
		benchmark_warmup_physics_ticks = roundi(benchmark_warmup_seconds * PHYSICS_TICKS_PER_SECOND)
		benchmark_target_physics_ticks = maxi(
			1,
			roundi((benchmark_warmup_seconds + benchmark_duration_seconds) * PHYSICS_TICKS_PER_SECOND)
		)
		benchmark_rss_sample_interval_seconds = benchmark_rss_interval_seconds(benchmark_duration_seconds)
		benchmark_next_rss_sample_seconds = benchmark_rss_sample_interval_seconds
		var evidence_label := "cadence-%d" % benchmark_render_hz if benchmark_render_hz > 0 else benchmark_mode
		var evidence_stem := "handling-truth-slice-%s-%d" % [evidence_label, OS.get_process_id()]
		if benchmark_report_path.is_empty():
			benchmark_report_path = _absolute_evidence_path("user://%s-report.json" % evidence_stem)
		if benchmark_rss_path.is_empty():
			benchmark_rss_path = _absolute_evidence_path("user://%s-rss.json" % evidence_stem)
		benchmark_effective_max_fps = benchmark_max_fps(benchmark_mode, benchmark_render_hz)
		Engine.max_fps = benchmark_effective_max_fps
		DisplayServer.window_set_vsync_mode(benchmark_vsync_mode(benchmark_mode, benchmark_render_hz))
		controls.visible = false
		telemetry_visible = false

func _benchmark_intent(delta:float) -> Dictionary:
	benchmark_physics_elapsed += delta
	var cycle := int(benchmark_physics_elapsed / 8.0)
	if cycle != benchmark_cycle:
		benchmark_cycle = cycle
		_reset_slice()
		vehicle.set_tune(["balanced", "scout", "hauler"][posmod(cycle, 3)])
	var cycle_time := fmod(benchmark_physics_elapsed, 8.0)
	var intent := {"throttle": 1.0}
	var route := posmod(cycle, 3)
	if cycle_time >= 0.7 and cycle_time < 2.5:
		intent["steer"] = -0.34 if route == 1 else (0.34 if route == 2 else 0.0)
	if cycle_time >= 2.6 and cycle_time < 3.0:
		intent["handbrake"] = 0.65
	if cycle_time >= 6.0:
		intent = {"brake": 1.0}
	return intent

func _report_benchmark_and_quit() -> void:
	benchmark_enabled = false
	set_physics_process(false)
	_complete_rss_sampling(float(benchmark_physics_ticks) / float(PHYSICS_TICKS_PER_SECOND))
	if benchmark_frame_timing.sample_count <= 0:
		push_error("Prototype rendered benchmark recorded no frames")
		audio.stop()
		_schedule_clean_exit(1)
		return
	var measured_fps := benchmark_frame_timing.average_hz()
	var frame_ms_p50 := benchmark_frame_timing.percentile_ms(0.50)
	var frame_ms_p95 := benchmark_frame_timing.percentile_ms(0.95)
	var frame_ms_p99 := benchmark_frame_timing.percentile_ms(0.99)
	var frame_ms_worst := benchmark_frame_timing.worst_ms
	var world_work_p50_ms := benchmark_world_work_timing.percentile_ms(0.50)
	var world_work_p95_ms := benchmark_world_work_timing.percentile_ms(0.95)
	var world_work_worst_ms := benchmark_world_work_timing.worst_ms
	var viewport_size := get_viewport_rect().size
	var window_size := DisplayServer.window_get_size()
	var screen_size := DisplayServer.screen_get_size()
	var display_server := DisplayServer.get_name()
	var vsync_mode := DisplayServer.window_get_vsync_mode()
	var host_model := OS.get_model_name()
	var power_evidence := _power_state_evidence()
	var screen_scale := DisplayServer.screen_get_scale()
	var content_scale_factor := get_window().content_scale_factor
	var content_scale_size := get_window().content_scale_size
	var audio_output_device := AudioServer.output_device
	var timing_pass:bool = frame_ms_p95 <= 16.7 and frame_ms_p99 <= 25.0 and frame_ms_worst <= 50.0
	var rendered_valid:bool = display_server != "headless" and benchmark_peak_draw_calls > 0
	var rss_expected_samples := floori((benchmark_warmup_seconds + benchmark_duration_seconds) / benchmark_rss_sample_interval_seconds)
	var rss_valid:bool = (
		benchmark_peak_rss_bytes > 0.0
		and benchmark_rss_sample_failures == 0
		and benchmark_rss_missed_schedule_count == 0
		and benchmark_rss_sample_count >= rss_expected_samples
	)
	var static_memory_available:bool = benchmark_peak_static_memory_bytes > 0.0
	var memory_valid:bool = rss_valid
	var world_work_valid:bool = benchmark_world_work_timing.sample_count > 0 and world_work_p95_ms <= WORLD_WORK_P95_LIMIT_MS
	var expected_measured_collision_queries := benchmark_target_physics_ticks - benchmark_warmup_physics_ticks
	var collision_counter_valid:bool = benchmark_measured_collision_queries == expected_measured_collision_queries
	var resolution_valid:bool = window_size == Vector2i(1920, 1080) and Vector2i(roundi(viewport_size.x), roundi(viewport_size.y)) == Vector2i(1280, 720)
	var duration_valid:bool = benchmark_duration_seconds >= 15.0 and benchmark_warmup_seconds >= 5.0
	var vsync_valid:bool = vsync_mode == DisplayServer.VSYNC_DISABLED if benchmark_render_hz > 0 or benchmark_mode == "capacity" else vsync_mode != DisplayServer.VSYNC_DISABLED
	var fps_cap_valid := Engine.max_fps == benchmark_effective_max_fps
	var mode_rate_target := PHYSICS_TICKS_PER_SECOND if benchmark_render_hz == 0 and benchmark_mode == "feel" else 0
	var mode_rate_delta_percent := (
		absf(measured_fps - float(mode_rate_target)) / float(mode_rate_target) * 100.0
		if mode_rate_target > 0 else 0.0
	)
	var mode_rate_valid := mode_rate_target == 0 or mode_rate_delta_percent <= CADENCE_RATE_TOLERANCE_PERCENT
	var provenance_valid:bool = _is_git_sha(benchmark_embedded_build_id) and not benchmark_embedded_dirty and benchmark_expected_build_id == benchmark_embedded_build_id
	var frozen_fields_valid := (
		benchmark_report_path_explicit
		and benchmark_rss_path_explicit
		and benchmark_evidence_paths_absolute
		and not host_model.is_empty()
		and not audio_output_device.is_empty()
		and bool(power_evidence.get("valid", false))
		and BENCHMARK_TRACE_SEED > 0
	)
	var exact_physics_trace:bool = benchmark_physics_ticks == benchmark_target_physics_ticks
	var cadence_rate_delta_percent := (
		absf(measured_fps - float(benchmark_render_hz)) / float(benchmark_render_hz) * 100.0
		if benchmark_render_hz > 0 else 0.0
	)
	var cadence_rate_valid:bool = benchmark_render_hz > 0 and cadence_rate_delta_percent <= CADENCE_RATE_TOLERANCE_PERCENT
	var expected_cadence_frames := roundi(benchmark_duration_seconds * benchmark_render_hz) if benchmark_render_hz > 0 else 0
	var cadence_frame_delta_percent := (
		absf(float(benchmark_frame_timing.sample_count - expected_cadence_frames)) / float(expected_cadence_frames) * 100.0
		if expected_cadence_frames > 0 else 0.0
	)
	var cadence_frame_count_valid:bool = benchmark_render_hz > 0 and cadence_frame_delta_percent <= CADENCE_RATE_TOLERANCE_PERCENT
	var plateau := _rss_plateau_evidence()
	var rss_payload := {
		"schema": "keep-driving.handling-truth-slice.rss.v1",
		"benchmark_mode": benchmark_mode,
		"render_hz_target": benchmark_render_hz,
		"warmup_seconds": benchmark_warmup_seconds,
		"duration_seconds": benchmark_duration_seconds,
		"sample_interval_seconds": benchmark_rss_sample_interval_seconds,
		"schedule_tolerance_seconds": RSS_SCHEDULE_TOLERANCE_SECONDS,
		"missed_schedule_count": benchmark_rss_missed_schedule_count,
		"sample_attempts": benchmark_rss_samples,
		"plateau": plateau,
	}
	var rss_artifact_write_valid := _write_json_artifact(benchmark_rss_path, rss_payload)
	var evidence_paths:Array = [benchmark_report_path, benchmark_rss_path]
	for artifact_path in benchmark_artifact_paths:
		evidence_paths.append(artifact_path)
	var harness_pass:bool = (
		benchmark_configuration_valid
		and timing_pass
		and rendered_valid
		and memory_valid
		and world_work_valid
		and collision_counter_valid
		and resolution_valid
		and duration_valid
		and vsync_valid
		and fps_cap_valid
		and mode_rate_valid
		and provenance_valid
		and frozen_fields_valid
		and exact_physics_trace
		and rss_artifact_write_valid
	)
	var acceptance_eligible:bool = (
		benchmark_duration_seconds >= 1800.0
		and benchmark_warmup_seconds >= 5.0
		and benchmark_render_hz == 0
		and not OS.is_debug_build()
		and provenance_valid
		and frozen_fields_valid
	)
	var benchmark_run_acceptance_pass:bool = (
		harness_pass
		and acceptance_eligible
		and bool(plateau.get("evidence_valid", false))
		and bool(plateau.get("within_limit", false))
	)
	var cadence_provenance_valid := provenance_valid or benchmark_cadence_debug_unbound
	var retained_candidate_evidence := provenance_valid and not benchmark_cadence_debug_unbound and frozen_fields_valid
	var cadence_capture_pass:bool = (
		benchmark_configuration_valid
		and cadence_rate_valid
		and cadence_frame_count_valid
		and rendered_valid
		and memory_valid
		and world_work_valid
		and collision_counter_valid
		and resolution_valid
		and vsync_valid
		and fps_cap_valid
		and exact_physics_trace
		and rss_artifact_write_valid
		and cadence_provenance_valid
		and frozen_fields_valid
	)
	var telemetry_snapshot:Dictionary = vehicle.telemetry_snapshot() if vehicle.has_method("telemetry_snapshot") else {}
	var audio_evidence:Dictionary = audio.evidence_snapshot() if audio.has_method("evidence_snapshot") else {}
	var final_trace := {
		"position": [vehicle.global_position.x, vehicle.global_position.y],
		"velocity": [vehicle.velocity.x, vehicle.velocity.y],
		"rotation_radians": vehicle.rotation,
		"physics_ticks": benchmark_physics_ticks,
		"target_physics_ticks": benchmark_target_physics_ticks,
		"simulation_seconds": float(benchmark_physics_ticks) / float(PHYSICS_TICKS_PER_SECOND),
		"tune": String(telemetry_snapshot.get("tune", "unknown")),
		"integrity": float(telemetry_snapshot.get("integrity", 0.0)),
	}
	var report := {
		"harness_pass": harness_pass,
		"cadence_capture_pass": cadence_capture_pass,
		"benchmark_run_acceptance_pass": benchmark_run_acceptance_pass,
		"acceptance_pass": benchmark_run_acceptance_pass,
		"acceptance_eligible": acceptance_eligible,
		"milestone_acceptance_pass": false,
		"milestone_acceptance_note": "This harness cannot attest the paired feel/capacity runs, aggregate cadence comparison, physical controller, audible mix, or human cohorts.",
		"timing_pass": timing_pass,
		"rendered_valid": rendered_valid,
		"memory_valid": memory_valid,
		"rss_valid": rss_valid,
		"memory_plateau": plateau,
		"static_memory_available": static_memory_available,
		"world_work_valid": world_work_valid,
		"collision_counter_valid": collision_counter_valid,
		"resolution_valid": resolution_valid,
		"duration_valid": duration_valid,
		"vsync_valid": vsync_valid,
		"fps_cap_valid": fps_cap_valid,
		"effective_max_fps": benchmark_effective_max_fps,
		"mode_rate_target": mode_rate_target,
		"mode_rate_delta_percent": mode_rate_delta_percent,
		"mode_rate_valid": mode_rate_valid,
		"provenance_valid": provenance_valid,
		"frozen_fields_valid": frozen_fields_valid,
		"evidence_paths_absolute": benchmark_evidence_paths_absolute,
		"report_path_explicit": benchmark_report_path_explicit,
		"rss_path_explicit": benchmark_rss_path_explicit,
		"cadence_debug_unbound": benchmark_cadence_debug_unbound,
		"retained_candidate_evidence": retained_candidate_evidence,
		"exact_physics_trace": exact_physics_trace,
		"configuration_valid": benchmark_configuration_valid,
		"benchmark_mode": benchmark_mode,
		"render_hz_target": benchmark_render_hz,
		"render_hz_measured": measured_fps,
		"render_hz_delta_percent": cadence_rate_delta_percent,
		"render_hz_within_tolerance": cadence_rate_valid,
		"render_frame_count_expected": expected_cadence_frames,
		"render_frame_count_delta_percent": cadence_frame_delta_percent,
		"render_frame_count_within_tolerance": cadence_frame_count_valid,
		"render_rate_tolerance_percent": CADENCE_RATE_TOLERANCE_PERCENT,
		"build_id": benchmark_embedded_build_id,
		"expected_build_id": benchmark_expected_build_id,
		"build_dirty": benchmark_embedded_dirty,
		"sample_frames": benchmark_frame_timing.sample_count,
		"warmup_seconds": benchmark_warmup_seconds,
		"duration_seconds": benchmark_duration_seconds,
		"fps_average": measured_fps,
		"frame_ms_p50": frame_ms_p50,
		"frame_ms_p95": frame_ms_p95,
		"frame_ms_p99": frame_ms_p99,
		"frame_ms_worst": frame_ms_worst,
		"frame_timing_accumulator": benchmark_frame_timing.evidence_snapshot(),
		"slow_frame_threshold_ms": SLOW_FRAME_THRESHOLD_MS,
		"slow_frame_count": benchmark_slow_frame_count,
		"retained_slow_frame_limit": RETAINED_SLOW_FRAME_LIMIT,
		"slow_frame_samples": benchmark_slow_frame_samples,
		"peak_static_memory_mb": benchmark_peak_static_memory_bytes / (1024.0 * 1024.0),
		"max_sampled_rss_mb": benchmark_peak_rss_bytes / (1024.0 * 1024.0),
		"rss_interval_seconds": benchmark_rss_sample_interval_seconds,
		"rss_schedule_tolerance_seconds": RSS_SCHEDULE_TOLERANCE_SECONDS,
		"rss_sample_count": benchmark_rss_sample_count,
		"rss_expected_samples": rss_expected_samples,
		"rss_sample_failures": benchmark_rss_sample_failures,
		"rss_missed_schedule_count": benchmark_rss_missed_schedule_count,
		"rss_sample_attempt_count": benchmark_rss_samples.size(),
		"rss_samples_path": benchmark_rss_path,
		"report_path": benchmark_report_path,
		"artifact_paths": evidence_paths,
		"rss_artifact_write_valid": rss_artifact_write_valid,
		"report_artifact_write_valid": true,
		"peak_nodes": benchmark_peak_nodes,
		"peak_draw_calls": benchmark_peak_draw_calls,
		"peak_physics_2d_active_objects": benchmark_peak_physics_objects,
		"peak_texture_memory_mb": benchmark_peak_texture_memory_bytes / (1024.0 * 1024.0),
		"peak_buffer_memory_mb": benchmark_peak_buffer_memory_bytes / (1024.0 * 1024.0),
		"peak_video_memory_mb": benchmark_peak_video_memory_bytes / (1024.0 * 1024.0),
		"peak_unique_texture_resources": benchmark_peak_texture_resources,
		"peak_unique_material_resources": benchmark_peak_material_resources,
		"world_work_sample_count": benchmark_world_work_timing.sample_count,
		"world_work_p50_ms": world_work_p50_ms if is_finite(world_work_p50_ms) else null,
		"world_work_p95_ms": world_work_p95_ms if is_finite(world_work_p95_ms) else null,
		"world_work_worst_ms": world_work_worst_ms if is_finite(world_work_worst_ms) else null,
		"world_work_timing_accumulator": benchmark_world_work_timing.evidence_snapshot(),
		"world_work_p95_limit_ms": WORLD_WORK_P95_LIMIT_MS,
		"world_work_scope": "PrototypeWorld.surface_at lookup at each fixed step",
		"collision_queries": benchmark_collision_queries,
		"measured_collision_queries": benchmark_measured_collision_queries,
		"expected_measured_collision_queries": expected_measured_collision_queries,
		"collision_contact_steps": benchmark_collision_contacts,
		"collision_query_count_source": benchmark_collision_query_count_source,
		"peak_active_effects": benchmark_peak_active_effects,
		"peak_effect_particles_estimate": benchmark_peak_effect_particles,
		"effect_count_source": "active grouped effects plus emitting CPU/GPU particle nodes",
		"peak_active_audio_voices": benchmark_peak_active_audio_voices,
		"audio_voice_count_source": "PrototypeAudio.active_voice_count",
		"physics_ticks_per_second": PHYSICS_TICKS_PER_SECOND,
		"trace_seed": BENCHMARK_TRACE_SEED,
		"physics_ticks": benchmark_physics_ticks,
		"target_physics_ticks": benchmark_target_physics_ticks,
		"final_trace": final_trace,
		"measured_process_elapsed_seconds": benchmark_elapsed,
		"platform": OS.get_name(),
		"host_model": host_model,
		"os_version": OS.get_version(),
		"power_state": String(power_evidence.get("summary", "unavailable")),
		"power_state_source": String(power_evidence.get("source", "unavailable")),
		"power_state_probe_exit_code": int(power_evidence.get("exit_code", -1)),
		"display_server": display_server,
		"renderer": RenderingServer.get_current_rendering_method(),
		"godot": str(Engine.get_version_info().get("string", "unknown")),
		"godot_version_info": Engine.get_version_info(),
		"debug_build": OS.is_debug_build(),
		"logical_viewport": [roundi(viewport_size.x), roundi(viewport_size.y)],
		"output_window": [window_size.x, window_size.y],
		"display": [screen_size.x, screen_size.y],
		"screen_scale": screen_scale,
		"content_scale_factor": content_scale_factor,
		"content_scale_size": [content_scale_size.x, content_scale_size.y],
		"audio_output_device": audio_output_device,
		"audio_output_latency_seconds": AudioServer.get_output_latency(),
		"audio_resource_cost": audio_evidence.get("resource_cost", {}),
		"haptic_cadence": {
			"implementation": "desktop no-op; physical-device haptics are outside this desktop slice",
			"events": 0,
			"events_per_second": 0.0,
			"physical_device_acceptance": false,
		},
		"package_facts": benchmark_package_facts,
		"vsync_mode": int(vsync_mode),
		"scene": "res://prototypes/handling_truth_slice/prototype.tscn",
		"asset_set": "authored-svg-first-road-and-licensed-external-audio",
	}
	var report_artifact_write_valid := _write_json_artifact(benchmark_report_path, report)
	if not report_artifact_write_valid:
		report["report_artifact_write_valid"] = false
		report["harness_pass"] = false
		report["cadence_capture_pass"] = false
		report["benchmark_run_acceptance_pass"] = false
		report["acceptance_pass"] = false
	print("PROTOTYPE_RENDER_BENCHMARK %s" % JSON.stringify(report))
	audio.stop()
	var exit_pass := bool(report["cadence_capture_pass"]) if benchmark_render_hz > 0 else bool(report["harness_pass"])
	if benchmark_require_acceptance:
		exit_pass = bool(report["benchmark_run_acceptance_pass"])
	_schedule_clean_exit(0 if exit_pass else 1)

func _start_rss_probe(scheduled_seconds: float, observed_simulation_seconds: float) -> void:
	if benchmark_rss_thread.is_started():
		return
	benchmark_rss_probe_scheduled_seconds = scheduled_seconds
	benchmark_rss_probe_observed_seconds = observed_simulation_seconds
	var start_error := benchmark_rss_thread.start(_rss_probe_worker)
	if start_error != OK:
		_record_rss_probe_result({
			"rss_bytes": 0.0,
			"probe_exit_code": -1,
			"thread_start_error": int(start_error),
			"probe_duration_ms": 0.0,
			"worker_thread": false,
		})
		benchmark_rss_thread = Thread.new()


func _poll_rss_probe(wait_for_completion: bool) -> void:
	if not benchmark_rss_thread.is_started():
		return
	if not wait_for_completion and benchmark_rss_thread.is_alive():
		return
	var result: Dictionary = benchmark_rss_thread.wait_to_finish()
	_record_rss_probe_result(result)
	benchmark_rss_thread = Thread.new()


func _complete_rss_sampling(final_simulation_seconds: float) -> void:
	_poll_rss_probe(true)
	var due_sample_count := rss_due_sample_count(
		benchmark_next_rss_sample_seconds,
		final_simulation_seconds,
		benchmark_rss_sample_interval_seconds
	)
	if due_sample_count == 1:
		_start_rss_probe(benchmark_next_rss_sample_seconds, final_simulation_seconds)
		benchmark_next_rss_sample_seconds += benchmark_rss_sample_interval_seconds
		_poll_rss_probe(true)
	elif due_sample_count > 1:
		benchmark_rss_missed_schedule_count += due_sample_count


func _rss_probe_worker() -> Dictionary:
	var started_usec := Time.get_ticks_usec()
	var output:Array = []
	var exit_code := OS.execute(
		"/bin/ps",
		PackedStringArray(["-o", "rss=", "-p", str(OS.get_process_id())]),
		output,
		true
	)
	var resident_memory_bytes := 0.0
	if exit_code == 0 and not output.is_empty():
		resident_memory_bytes = maxf(0.0, float(String(output[0]).strip_edges()) * 1024.0)
	return {
		"rss_bytes": resident_memory_bytes,
		"probe_exit_code": exit_code,
		"thread_start_error": 0,
		"probe_duration_ms": float(Time.get_ticks_usec() - started_usec) / 1000.0,
		"worker_thread": true,
	}


func _record_rss_probe_result(result: Dictionary) -> void:
	var resident_memory_bytes := float(result.get("rss_bytes", 0.0))
	var schedule_lateness_seconds := maxf(0.0, benchmark_rss_probe_observed_seconds - benchmark_rss_probe_scheduled_seconds)
	var schedule_on_time := rss_schedule_on_time(
		benchmark_rss_probe_scheduled_seconds,
		benchmark_rss_probe_observed_seconds
	)
	var valid := rss_probe_result_valid(result, schedule_on_time)
	benchmark_rss_samples.append({
		"scheduled_seconds": benchmark_rss_probe_scheduled_seconds,
		"observed_simulation_seconds": benchmark_rss_probe_observed_seconds,
		"rss_bytes": roundi(resident_memory_bytes),
		"valid": valid,
		"probe_exit_code": int(result.get("probe_exit_code", -1)),
		"thread_start_error": int(result.get("thread_start_error", -1)),
		"probe_duration_ms": float(result.get("probe_duration_ms", 0.0)),
		"schedule_lateness_seconds": schedule_lateness_seconds,
		"schedule_on_time": schedule_on_time,
		"worker_thread": bool(result.get("worker_thread", false)),
	})
	if valid:
		benchmark_peak_rss_bytes = maxf(benchmark_peak_rss_bytes, resident_memory_bytes)
		benchmark_rss_sample_count += 1
	else:
		benchmark_rss_sample_failures += 1


func _rss_plateau_evidence() -> Dictionary:
	var measured_bytes:Array[float] = []
	for sample in benchmark_rss_samples:
		if bool(sample.get("valid", false)) and float(sample.get("scheduled_seconds", 0.0)) > benchmark_warmup_seconds:
			measured_bytes.append(float(sample.get("rss_bytes", 0.0)))
	return memory_plateau_for_samples(
		measured_bytes,
		benchmark_duration_seconds,
		benchmark_rss_sample_interval_seconds
	)

func _schedule_clean_exit(exit_code:int) -> void:
	if clean_exit_scheduled:
		return
	clean_exit_scheduled = true
	if audio != null and audio.has_method("stop"):
		audio.stop()
	var tree := get_tree()
	var teardown_timer := tree.create_timer(0.20, true, false, true)
	teardown_timer.timeout.connect(tree.quit.bind(exit_code), CONNECT_ONE_SHOT)
	queue_free()

func _notification(what:int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and is_inside_tree():
		_schedule_clean_exit(0)


func _exit_tree() -> void:
	_poll_rss_probe(true)

func _sample_runtime_counts() -> void:
	if audio != null and audio.has_method("active_voice_count"):
		benchmark_peak_active_audio_voices = maxi(benchmark_peak_active_audio_voices, int(audio.active_voice_count()))
	var active_effects := 0
	var active_particles := 0
	var texture_resources := {}
	var material_resources := {}
	var pending:Array[Node] = [self]
	while not pending.is_empty():
		var node:Node = pending.pop_back()
		var counted_effect := node != self and node.is_in_group("handling_truth_effect")
		if counted_effect:
			active_effects += 1
		if node is Sprite2D and (node as Sprite2D).texture != null:
			texture_resources[(node as Sprite2D).texture.get_instance_id()] = true
		elif node is TextureRect and (node as TextureRect).texture != null:
			texture_resources[(node as TextureRect).texture.get_instance_id()] = true
		if node is CanvasItem and (node as CanvasItem).material != null:
			material_resources[(node as CanvasItem).material.get_instance_id()] = true
		if node is GPUParticles2D and node.emitting:
			if not counted_effect:
				active_effects += 1
			active_particles += node.amount
			if node.texture != null:
				texture_resources[node.texture.get_instance_id()] = true
			if node.process_material != null:
				material_resources[node.process_material.get_instance_id()] = true
		elif node is CPUParticles2D and node.emitting:
			if not counted_effect:
				active_effects += 1
			active_particles += node.amount
		for child in node.get_children():
			pending.append(child)
	benchmark_peak_active_effects = maxi(benchmark_peak_active_effects, active_effects)
	benchmark_peak_effect_particles = maxi(benchmark_peak_effect_particles, active_particles)
	benchmark_peak_texture_resources = maxi(benchmark_peak_texture_resources, texture_resources.size())
	benchmark_peak_material_resources = maxi(benchmark_peak_material_resources, material_resources.size())

func _write_json_artifact(path:String, payload:Variant) -> bool:
	if path.is_empty():
		push_error("Prototype benchmark evidence path is empty")
		return false
	var parent_directory := path.get_base_dir()
	if not DirAccess.dir_exists_absolute(parent_directory):
		var make_directory_error := DirAccess.make_dir_recursive_absolute(parent_directory)
		if make_directory_error != OK:
			push_error("Could not create prototype benchmark evidence directory: %s" % parent_directory)
			return false
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not write prototype benchmark evidence: %s" % path)
		return false
	file.store_string(JSON.stringify(payload, "\t"))
	file.store_string("\n")
	file.flush()
	return true

func _absolute_evidence_path(path_value:String) -> String:
	var normalized := path_value.strip_edges()
	if normalized.begins_with("res://") or normalized.begins_with("user://"):
		return ProjectSettings.globalize_path(normalized).simplify_path()
	if normalized.is_absolute_path():
		return normalized.simplify_path()
	return ProjectSettings.globalize_path("res://").path_join(normalized).simplify_path()

func _power_state_evidence() -> Dictionary:
	var output:Array = []
	var exit_code := OS.execute(
		"/usr/bin/pmset",
		PackedStringArray(["-g", "batt"]),
		output,
		true
	)
	var summary := "\n".join(PackedStringArray(output)).strip_edges()
	return {
		"valid": exit_code == 0 and not summary.is_empty(),
		"source": "/usr/bin/pmset -g batt",
		"exit_code": exit_code,
		"summary": summary,
	}

func _load_build_provenance() -> void:
	var contents_directory := OS.get_executable_path().get_base_dir().get_base_dir()
	var provenance_path := contents_directory.path_join("Resources").path_join(BUILD_PROVENANCE_FILENAME)
	if not FileAccess.file_exists(provenance_path):
		return
	var file := FileAccess.open(provenance_path, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is not Dictionary:
		return
	benchmark_embedded_build_id = String(parsed.get("commit", "unrecorded")).strip_edges().to_lower()
	benchmark_embedded_dirty = bool(parsed.get("dirty", true))
	benchmark_package_facts = parsed.duplicate(true)

func _is_git_sha(value:String) -> bool:
	if value.length() != 40:
		return false
	for index in value.length():
		var code := value.unicode_at(index)
		if not (code >= 48 and code <= 57) and not (code >= 97 and code <= 102):
			return false
	return true

func _reset_slice() -> void:
	world.reset_world()
	vehicle.reset_prototype(PrototypeWorld.START_POSITION)
	audio.reset_state()
	camera.reset_at(PrototypeWorld.START_POSITION)
	reached_relay = false
	completed_return = false
	auto_drive = false
	auto_stop = false
	fuel = 72.0
	instruction_elapsed = 0.0
	collected_route_rewards.clear()
	route_reward_message = ""
	route_reward_message_seconds = 0.0
	var connected_joypads := Input.get_connected_joypads()
	active_input_source = "controller" if not connected_joypads.is_empty() else "keyboard"
	active_input_device = int(connected_joypads[0]) if not connected_joypads.is_empty() else -1
	demonstrated_drive = false
	demonstrated_steer = false
	demonstrated_handbrake = false
	last_impact_serial = 0

func _select_tune(tune_name: String) -> void:
	selected_lab_tune = tune_name
	vehicle.set_tune(tune_name)
	_reset_slice()


func _update_onboarding_state(intent: Dictionary) -> void:
	var source := String(intent.get("source", ""))
	var has_activity := (
		absf(float(intent.get("steer", 0.0))) > 0.1
		or float(intent.get("throttle", 0.0)) > 0.1
		or float(intent.get("brake", 0.0)) > 0.1
		or float(intent.get("handbrake", 0.0)) > 0.1
		or bool(intent.get("recovery_pressed", false))
	)
	if has_activity and source in ["keyboard", "controller"]:
		active_input_source = source
		active_input_device = int(intent.get("device", -1)) if source == "controller" else -1
	demonstrated_drive = demonstrated_drive or float(intent.get("throttle", 0.0)) > 0.1 or float(intent.get("brake", 0.0)) > 0.1
	demonstrated_steer = demonstrated_steer or absf(float(intent.get("steer", 0.0))) > 0.1
	demonstrated_handbrake = demonstrated_handbrake or float(intent.get("handbrake", 0.0)) > 0.1


func _onboarding_prompt(stuck: bool) -> String:
	var controller := active_input_source == "controller"
	var controller_name := Input.get_joy_name(active_input_device) if controller and active_input_device >= 0 else ""
	var glyphs := controller_glyphs_for_name(controller_name)
	if stuck:
		return "STUCK — HOLD %s TO RECOVER" % String(glyphs["recovery"]) if controller else "STUCK — HOLD E TO RECOVER"
	if not demonstrated_drive:
		return "%s  DRIVE" % String(glyphs["drive"]) if controller else "W / S  DRIVE"
	if not demonstrated_steer:
		return "%s  STEER" % String(glyphs["steer"]) if controller else "A / D  STEER"
	if not demonstrated_handbrake:
		return "%s  HANDBRAKE" % String(glyphs["handbrake"]) if controller else "SPACE  HANDBRAKE"
	return ""
