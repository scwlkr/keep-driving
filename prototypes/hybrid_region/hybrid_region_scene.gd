extends Node2D

# PROTOTYPE: disposable keyboard-playable consumer of one Hybrid Region bake report.

const HybridRegionBake = preload("res://prototypes/hybrid_region/hybrid_region_bake.gd")
const HybridRegionWorld = preload("res://prototypes/hybrid_region/hybrid_region_world.gd")
const DriveIntent = preload("res://prototypes/handling_truth_slice/drive_intent.gd")
const PrototypeVehicle = preload("res://prototypes/handling_truth_slice/prototype_vehicle.gd")
const PrototypeCameraRig = preload("res://prototypes/handling_truth_slice/prototype_camera_rig.gd")
const UI_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Regular.otf")
const UI_FONT_BOLD: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Bold.otf")

const SOURCE_PATH := "res://prototypes/hybrid_region/hybrid_region_source.json"
const DEFAULT_OVERLAY_ID := "overlay.lowlands.playable.0001"
const DEFAULT_SEED := 4101
const KEYBOARD_BINDINGS := {
	"drive_gas": KEY_W,
	"drive_brake": KEY_S,
	"drive_left": KEY_A,
	"drive_right": KEY_D,
	"drive_handbrake": KEY_SPACE,
	"drive_recover": KEY_E,
}

var live_input_enabled := true
var world
var vehicle
var camera
var _bake_report: Dictionary = {}
var _configuration_errors: Array = []
var _triggered_event_ids := {}
var _local_handbrake_pressed := false
var _status_label: Label
var _surface_label: Label


func _ready() -> void:
	_build_hud()
	if _bake_report.is_empty():
		var loaded: Dictionary = HybridRegionBake.load_source(SOURCE_PATH)
		if not bool(loaded.get("ok", false)):
			_configuration_errors = loaded.get("errors", []).duplicate()
			_update_hud({})
			return
		configure_from_bake(HybridRegionBake.bake(loaded.get("source", {}), DEFAULT_OVERLAY_ID, DEFAULT_SEED))


func configure_from_bake(report: Dictionary) -> Dictionary:
	_clear_runtime()
	_bake_report = report.duplicate(true)
	var next_world = HybridRegionWorld.new()
	next_world.name = "HybridRegionProjection"
	var configured: Dictionary = next_world.configure_from_bake(_bake_report)
	if not bool(configured.get("ok", false)):
		_configuration_errors = configured.get("errors", []).duplicate()
		next_world.free()
		_update_hud({})
		return {"ok": false, "errors": _configuration_errors.duplicate()}
	world = next_world
	add_child(world)
	vehicle = PrototypeVehicle.new()
	vehicle.name = "HybridRegionVehicle"
	vehicle.global_position = world.start_position()
	add_child(vehicle)
	vehicle.set_physics_process(false)
	vehicle.reset_prototype(world.start_position())
	camera = PrototypeCameraRig.new()
	camera.name = "HybridRegionCamera"
	add_child(camera)
	camera.setup(vehicle)
	_configuration_errors.clear()
	_triggered_event_ids.clear()
	_update_hud(vehicle.telemetry_snapshot())
	return {"ok": true, "errors": [], "contract": playable_contract()}


func step_with_intent(intent: Dictionary, delta: float) -> Dictionary:
	if world == null or vehicle == null:
		return {"ok": false, "errors": _configuration_errors.duplicate()}
	var surface: Dictionary = world.surface_at(vehicle.global_position)
	var telemetry: Dictionary = vehicle.step_vehicle(intent, surface, delta)
	camera.step_camera(delta)
	for event_instance_id in world.active_event_markers_near(vehicle.global_position):
		_triggered_event_ids[event_instance_id] = true
	_update_hud(telemetry)
	return {
		"ok": true,
		"telemetry": telemetry,
		"surface": surface,
		"triggered_event_ids": triggered_event_ids(),
		"objective_distance": vehicle.global_position.distance_to(world.objective_position()),
	}


func surface_at(world_position: Vector2) -> Dictionary:
	if world == null:
		return {}
	return world.surface_at(world_position)


func reset_to_start() -> void:
	if world == null or vehicle == null:
		return
	vehicle.reset_prototype(world.start_position())
	camera.reset_at(world.start_position())
	_local_handbrake_pressed = false
	_triggered_event_ids.clear()
	_update_hud(vehicle.telemetry_snapshot())


func playable_contract() -> Dictionary:
	var contract: Dictionary = {} if world == null else world.playable_contract()
	contract["vehicle_ready"] = vehicle != null and vehicle.is_inside_tree()
	contract["camera_ready"] = camera != null and camera.is_inside_tree() and get_viewport().get_camera_2d() == camera
	contract["vehicle_single_step"] = vehicle != null and not vehicle.is_physics_processing()
	contract["keyboard_actions"] = KEYBOARD_BINDINGS.keys()
	contract["keyboard_actions_ready"] = _keyboard_actions_ready()
	contract["keyboard_bindings"] = KEYBOARD_BINDINGS.duplicate()
	contract["keyboard_bindings_ready"] = _keyboard_bindings_ready()
	contract["live_input_enabled"] = live_input_enabled
	contract["triggered_event_ids"] = triggered_event_ids()
	contract["configuration_errors"] = _configuration_errors.duplicate()
	return contract


func runtime_snapshot() -> Dictionary:
	return {
		"configured": world != null and vehicle != null,
		"vehicle": {} if vehicle == null else vehicle.telemetry_snapshot(),
		"surface": {} if world == null or vehicle == null else world.surface_at(vehicle.global_position),
		"triggered_event_ids": triggered_event_ids(),
	}


func triggered_event_ids() -> Array[String]:
	var ids: Array[String] = []
	for event_instance_id in _triggered_event_ids:
		ids.append(String(event_instance_id))
	ids.sort()
	return ids


func _physics_process(delta: float) -> void:
	if live_input_enabled:
		var intent: Dictionary = DriveIntent.sample()
		if _local_handbrake_pressed:
			intent["handbrake"] = 1.0
			intent["source"] = "keyboard"
		step_with_intent(intent, delta)


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if event.keycode == int(KEYBOARD_BINDINGS["drive_handbrake"]):
		_local_handbrake_pressed = event.pressed
		get_viewport().set_input_as_handled()
		return
	if not event.pressed or event.echo:
		return
	if event.keycode == KEY_R:
		reset_to_start()
	elif event.keycode == KEY_ESCAPE:
		get_tree().quit(0)


func _clear_runtime() -> void:
	for runtime_node in [camera, vehicle, world]:
		if runtime_node != null and is_instance_valid(runtime_node):
			runtime_node.free()
	camera = null
	vehicle = null
	world = null
	_configuration_errors.clear()
	_triggered_event_ids.clear()
	_local_handbrake_pressed = false


func _keyboard_actions_ready() -> bool:
	for action in KEYBOARD_BINDINGS:
		if not InputMap.has_action(action):
			return false
	return true


func _keyboard_bindings_ready() -> bool:
	for action in KEYBOARD_BINDINGS:
		var expected_key := int(KEYBOARD_BINDINGS[action])
		if action == "drive_handbrake":
			continue
		var key_found := false
		for event in InputMap.action_get_events(action):
			if event is InputEventKey and (event.keycode == expected_key or event.physical_keycode == expected_key):
				key_found = true
				break
		if not key_found:
			return false
	return true


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_local_handbrake_pressed = false


func _build_hud() -> void:
	if _status_label != null:
		return
	var canvas := CanvasLayer.new()
	canvas.name = "HybridRegionHUD"
	add_child(canvas)
	var panel := PanelContainer.new()
	panel.position = Vector2(22.0, 22.0)
	panel.size = Vector2(500.0, 132.0)
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("d91b2220")
	panel_style.border_color = Color("d6b978")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", panel_style)
	canvas.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 4)
	margin.add_child(column)
	var title := _label("HYBRID PROOF REGION", UI_FONT_BOLD, 19, Color("d6b978"))
	column.add_child(title)
	_status_label = _label("Loading authored county...", UI_FONT, 16, Color("f1e8cf"))
	column.add_child(_status_label)
	_surface_label = _label("SURFACE —", UI_FONT_BOLD, 15, Color("c8d5c2"))
	column.add_child(_surface_label)
	var controls := _label(_controls_text(), UI_FONT, 14, Color("aab7aa"))
	column.add_child(controls)


func _update_hud(telemetry: Dictionary) -> void:
	if _status_label == null or _surface_label == null:
		return
	if world == null or vehicle == null:
		_status_label.text = "PROJECTION REJECTED — %s" % "; ".join(PackedStringArray(_configuration_errors))
		_surface_label.text = "SURFACE —"
		return
	var distance: float = vehicle.global_position.distance_to(world.objective_position())
	var event_text := "  •  EVENT MARKERS %d" % _triggered_event_ids.size() if not _triggered_event_ids.is_empty() else ""
	_status_label.text = "RADIO RELAY  %.0f DISTANCE%s" % [distance, event_text]
	_surface_label.text = "SURFACE %s  •  SPEED %.0f" % [String(telemetry.get("surface", "road")).to_upper(), float(telemetry.get("speed", 0.0))]


func _label(text: String, font: Font, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _controls_text() -> String:
	return "%s/%s drive  •  %s/%s steer  •  %s handbrake  •  %s recover  •  R reset" % [
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_gas"]),
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_brake"]),
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_left"]),
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_right"]),
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_handbrake"]),
		OS.get_keycode_string(KEYBOARD_BINDINGS["drive_recover"]),
	]
