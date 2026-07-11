extends Node2D

# PROTOTYPE — Desktop Truth Slice A. No persistence. Delete or absorb after verdict.
# Question: can fixed-step production-candidate handling, real collision, one authored
# route choice, honest HUD facts, and audible feedback support Keep Driving's hero minute?

const DriveIntent = preload("res://prototypes/handling_truth_slice/drive_intent.gd")
const PrototypeVehicle = preload("res://prototypes/handling_truth_slice/prototype_vehicle.gd")
const PrototypeWorld = preload("res://prototypes/handling_truth_slice/prototype_world.gd")
const PrototypeAudio = preload("res://prototypes/handling_truth_slice/prototype_audio.gd")
const BUILD_PROVENANCE_FILENAME := "handling-truth-slice-provenance.json"
const RSS_SAMPLE_INTERVAL_SECONDS := 1.0

var world
var vehicle
var audio
var camera:Camera2D
var hud:Label
var objective:Label
var controls:Label
var telemetry:Label
var reached_relay := false
var completed_return := false
var last_impact_serial := 0
var telemetry_visible := false
var auto_drive := false
var auto_stop := false
var benchmark_enabled := false
var benchmark_mode := "feel"
var benchmark_expected_build_id := "unrecorded"
var benchmark_embedded_build_id := "unrecorded"
var benchmark_embedded_dirty := true
var benchmark_duration_seconds := 60.0
var benchmark_warmup_seconds := 5.0
var benchmark_elapsed := 0.0
var benchmark_physics_elapsed := 0.0
var benchmark_cycle := -1
var benchmark_frame_ms:Array[float] = []
var benchmark_peak_static_memory_bytes := 0.0
var benchmark_peak_rss_bytes := 0.0
var benchmark_memory_poll_elapsed := 0.0
var benchmark_rss_sample_count := 0
var benchmark_rss_sample_failures := 0
var benchmark_peak_nodes := 0
var benchmark_peak_draw_calls := 0

func _ready() -> void:
	Engine.physics_ticks_per_second = 60
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
	camera = Camera2D.new()
	camera.name = "PrototypeCamera"
	camera.enabled = true
	add_child(camera)
	camera.global_position = vehicle.global_position
	_build_ui()
	_load_build_provenance()
	_configure_benchmark()
	_update_ui({})

func _physics_process(delta:float) -> void:
	var intent := DriveIntent.sample()
	if benchmark_enabled:
		intent = _benchmark_intent(delta)
	elif auto_stop:
		intent = {"brake": 1.0}
		if vehicle.speed < 5.0:
			auto_stop = false
	elif auto_drive:
		intent["throttle"] = 1.0
	var surface:Dictionary = world.surface_at(vehicle.global_position)
	var snapshot:Dictionary = vehicle.step_vehicle(intent, surface, delta)
	var follow_weight := 1.0 - pow(0.001, delta)
	var lookahead:Vector2 = vehicle.camera_lookahead()
	camera.global_position = camera.global_position.lerp(vehicle.global_position + lookahead, follow_weight)
	camera.zoom = camera.zoom.lerp(vehicle.camera_zoom(), follow_weight)

	var impact_serial := int(snapshot.get("impact_serial", 0))
	if impact_serial != last_impact_serial:
		last_impact_serial = impact_serial
		audio.play_impact(str(snapshot.get("last_impact_weight", "medium")))

	var integrity := float(snapshot.get("integrity", 100.0))
	audio.update_vehicle(clampf(float(snapshot.get("speed", 0.0)) / maxf(float(snapshot.get("max_speed", 1.0)), 1.0), 0.0, 1.0), str(surface["name"]), integrity <= 25.0)

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
	benchmark_memory_poll_elapsed += delta
	benchmark_peak_static_memory_bytes = maxf(benchmark_peak_static_memory_bytes, maxf(Performance.get_monitor(Performance.MEMORY_STATIC), float(OS.get_static_memory_usage())))
	if benchmark_memory_poll_elapsed >= RSS_SAMPLE_INTERVAL_SECONDS:
		benchmark_memory_poll_elapsed -= RSS_SAMPLE_INTERVAL_SECONDS
		var resident_memory_bytes := _resident_memory_bytes()
		if resident_memory_bytes > 0.0:
			benchmark_peak_rss_bytes = maxf(benchmark_peak_rss_bytes, resident_memory_bytes)
			benchmark_rss_sample_count += 1
		else:
			benchmark_rss_sample_failures += 1
	benchmark_peak_nodes = maxi(benchmark_peak_nodes, roundi(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)))
	benchmark_peak_draw_calls = maxi(benchmark_peak_draw_calls, roundi(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	if benchmark_elapsed > benchmark_warmup_seconds:
		benchmark_frame_ms.append(delta * 1000.0)
	if benchmark_elapsed >= benchmark_warmup_seconds + benchmark_duration_seconds:
		_report_benchmark_and_quit()

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			_reset_slice()
		elif event.keycode == KEY_T:
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
		elif event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _build_ui() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "PrototypeHUD"
	add_child(canvas)
	var shade := ColorRect.new()
	shade.position = Vector2(12, 12)
	shade.size = Vector2(530, 132)
	shade.color = Color(0.035, 0.04, 0.04, 0.88)
	canvas.add_child(shade)
	hud = Label.new()
	hud.position = Vector2(28, 22)
	hud.add_theme_font_size_override("font_size", 18)
	hud.add_theme_color_override("font_color", Color("f1e8cf"))
	canvas.add_child(hud)
	objective = Label.new()
	objective.position = Vector2(28, 73)
	objective.add_theme_font_size_override("font_size", 21)
	objective.add_theme_color_override("font_color", Color("63b7c5"))
	canvas.add_child(objective)
	controls = Label.new()
	controls.position = Vector2(28, 109)
	controls.text = "W/S gas-brake  A/D steer  Space handbrake  1/2/3 tune  G auto-gas  R reset  T telemetry"
	controls.add_theme_font_size_override("font_size", 14)
	controls.add_theme_color_override("font_color", Color(0.85, 0.82, 0.72))
	canvas.add_child(controls)
	telemetry = Label.new()
	telemetry.position = Vector2(12, 155)
	telemetry.add_theme_font_size_override("font_size", 14)
	telemetry.add_theme_color_override("font_color", Color("f0c547"))
	telemetry.add_theme_color_override("font_outline_color", Color("171818"))
	telemetry.add_theme_constant_override("outline_size", 4)
	telemetry.visible = false
	canvas.add_child(telemetry)

func _update_ui(snapshot:Dictionary) -> void:
	var surface_name := str(snapshot.get("surface", "road")).capitalize()
	var integrity := float(snapshot.get("integrity", 100.0))
	var speed := float(snapshot.get("speed", 0.0))
	hud.text = "FUEL 100   INTEGRITY %03d   %s   %s %03d" % [roundi(integrity), str(snapshot.get("tune", "balanced")).to_upper(), surface_name.to_upper(), roundi(speed)]
	if completed_return:
		objective.text = "TRUTH SLICE COMPLETE — press R to drive again"
	elif reached_relay:
		objective.text = "RELAY SECURED — return to the Garage test lot"
	else:
		var distance:float = vehicle.global_position.distance_to(PrototypeWorld.GOAL_POSITION)
		objective.text = "REACH THE RADIO RELAY  %dm  — choose road, dirt, or mud" % roundi(distance / 10.0)
	telemetry.text = "PROTOTYPE STATE\nintent=%s\nsurface=%s\nposition=%s\nvelocity=%s\nimpact=%s" % [
		str(snapshot.get("intent", {})),
		str(snapshot.get("surface", "")),
		str(vehicle.global_position.round()),
		str(vehicle.velocity.round()),
		str(snapshot.get("last_impact_weight", "none")),
	]

func _configure_benchmark() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument == "--prototype-benchmark":
			benchmark_enabled = true
		elif argument.begins_with("--prototype-benchmark-seconds="):
			benchmark_enabled = true
			benchmark_duration_seconds = maxf(1.0, float(argument.get_slice("=", 1)))
		elif argument.begins_with("--prototype-benchmark-warmup="):
			benchmark_warmup_seconds = maxf(0.0, float(argument.get_slice("=", 1)))
		elif argument.begins_with("--prototype-benchmark-mode="):
			benchmark_mode = String(argument.get_slice("=", 1)).to_lower()
		elif argument.begins_with("--prototype-build-id="):
			benchmark_expected_build_id = String(argument.get_slice("=", 1)).strip_edges().to_lower()
	if benchmark_mode not in ["feel", "capacity"]:
		benchmark_mode = "feel"
	if benchmark_enabled:
		DisplayServer.window_set_vsync_mode(
			DisplayServer.VSYNC_DISABLED if benchmark_mode == "capacity" else DisplayServer.VSYNC_ENABLED
		)
		controls.text = "AUTOMATED RENDER BENCHMARK — player input disabled"
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
	if benchmark_frame_ms.is_empty():
		push_error("Prototype rendered benchmark recorded no frames")
		audio.stop()
		await get_tree().process_frame
		get_tree().quit(1)
		return
	var sorted:Array[float] = benchmark_frame_ms.duplicate()
	sorted.sort()
	var total_ms := 0.0
	for frame_ms in sorted:
		total_ms += frame_ms
	var average_ms := total_ms / sorted.size()
	var viewport_size := get_viewport_rect().size
	var window_size := DisplayServer.window_get_size()
	var screen_size := DisplayServer.screen_get_size()
	var display_server := DisplayServer.get_name()
	var vsync_mode := DisplayServer.window_get_vsync_mode()
	var timing_pass:bool = _percentile(sorted, 0.95) <= 16.7 and _percentile(sorted, 0.99) <= 25.0 and sorted[-1] <= 50.0
	var rendered_valid:bool = display_server != "headless" and benchmark_peak_draw_calls > 0
	var rss_expected_samples := floori(benchmark_warmup_seconds + benchmark_duration_seconds)
	var rss_valid:bool = benchmark_peak_rss_bytes > 0.0 and benchmark_rss_sample_failures == 0 and benchmark_rss_sample_count >= rss_expected_samples
	var memory_valid:bool = benchmark_peak_static_memory_bytes > 0.0 and rss_valid
	var resolution_valid:bool = window_size == Vector2i(1920, 1080) and Vector2i(roundi(viewport_size.x), roundi(viewport_size.y)) == Vector2i(1280, 720)
	var duration_valid:bool = benchmark_duration_seconds >= 15.0 and benchmark_warmup_seconds >= 5.0
	var vsync_valid:bool = vsync_mode == DisplayServer.VSYNC_DISABLED if benchmark_mode == "capacity" else vsync_mode != DisplayServer.VSYNC_DISABLED
	var provenance_valid:bool = _is_git_sha(benchmark_embedded_build_id) and not benchmark_embedded_dirty and benchmark_expected_build_id == benchmark_embedded_build_id
	var harness_pass:bool = timing_pass and rendered_valid and memory_valid and resolution_valid and duration_valid and vsync_valid and provenance_valid
	var acceptance_eligible:bool = benchmark_duration_seconds >= 1800.0 and benchmark_warmup_seconds >= 5.0 and not OS.is_debug_build() and provenance_valid
	var report := {
		"harness_pass": harness_pass,
		"acceptance_pass": harness_pass and acceptance_eligible,
		"acceptance_eligible": acceptance_eligible,
		"timing_pass": timing_pass,
		"rendered_valid": rendered_valid,
		"memory_valid": memory_valid,
		"rss_valid": rss_valid,
		"resolution_valid": resolution_valid,
		"duration_valid": duration_valid,
		"vsync_valid": vsync_valid,
		"provenance_valid": provenance_valid,
		"benchmark_mode": benchmark_mode,
		"build_id": benchmark_embedded_build_id,
		"expected_build_id": benchmark_expected_build_id,
		"build_dirty": benchmark_embedded_dirty,
		"sample_frames": sorted.size(),
		"warmup_seconds": benchmark_warmup_seconds,
		"duration_seconds": benchmark_duration_seconds,
		"fps_average": 1000.0 / average_ms,
		"frame_ms_p50": _percentile(sorted, 0.50),
		"frame_ms_p95": _percentile(sorted, 0.95),
		"frame_ms_p99": _percentile(sorted, 0.99),
		"frame_ms_worst": sorted[-1],
		"peak_static_memory_mb": benchmark_peak_static_memory_bytes / (1024.0 * 1024.0),
		"max_sampled_rss_mb": benchmark_peak_rss_bytes / (1024.0 * 1024.0),
		"rss_interval_seconds": RSS_SAMPLE_INTERVAL_SECONDS,
		"rss_sample_count": benchmark_rss_sample_count,
		"rss_expected_samples": rss_expected_samples,
		"rss_sample_failures": benchmark_rss_sample_failures,
		"peak_nodes": benchmark_peak_nodes,
		"peak_draw_calls": benchmark_peak_draw_calls,
		"platform": OS.get_name(),
		"os_version": OS.get_version(),
		"display_server": display_server,
		"renderer": RenderingServer.get_current_rendering_method(),
		"godot": str(Engine.get_version_info().get("string", "unknown")),
		"debug_build": OS.is_debug_build(),
		"logical_viewport": [roundi(viewport_size.x), roundi(viewport_size.y)],
		"output_window": [window_size.x, window_size.y],
		"display": [screen_size.x, screen_size.y],
		"vsync_mode": int(vsync_mode),
		"scene": "res://prototypes/handling_truth_slice/prototype.tscn",
		"asset_set": "prototype generated draw and PCM assets",
	}
	print("PROTOTYPE_RENDER_BENCHMARK %s" % JSON.stringify(report))
	audio.stop()
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit(0 if bool(report["harness_pass"]) else 1)

func _percentile(sorted:Array[float], quantile:float) -> float:
	var index := clampi(ceili(quantile * sorted.size()) - 1, 0, sorted.size() - 1)
	return sorted[index]

func _resident_memory_bytes() -> float:
	var output:Array = []
	var exit_code := OS.execute(
		"/bin/ps",
		PackedStringArray(["-o", "rss=", "-p", str(OS.get_process_id())]),
		output,
		true
	)
	if exit_code != 0 or output.is_empty():
		return 0.0
	var rss_kib := float(String(output[0]).strip_edges())
	return maxf(0.0, rss_kib * 1024.0)

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

func _is_git_sha(value:String) -> bool:
	if value.length() != 40:
		return false
	for index in value.length():
		var code := value.unicode_at(index)
		if not (code >= 48 and code <= 57) and not (code >= 97 and code <= 102):
			return false
	return true

func _reset_slice() -> void:
	vehicle.reset_prototype(PrototypeWorld.START_POSITION)
	audio.reset_state()
	camera.global_position = PrototypeWorld.START_POSITION
	camera.zoom = Vector2.ONE
	reached_relay = false
	completed_return = false
	auto_drive = false
	auto_stop = false
	last_impact_serial = 0

func _select_tune(tune_name: String) -> void:
	vehicle.set_tune(tune_name)
	_reset_slice()
