extends SceneTree

const HybridRegionBake = preload("res://prototypes/hybrid_region/hybrid_region_bake.gd")
const SCENE_PATH := "res://prototypes/hybrid_region/hybrid_region_scene.tscn"
const SOURCE_PATH := "res://prototypes/hybrid_region/hybrid_region_source.json"

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE_PATH)
	_expect(packed != null, "the Hybrid Proof Region must expose a loadable desktop scene")
	if packed == null:
		_finish()
		return
	var scene := packed.instantiate()
	scene.set("live_input_enabled", false)
	root.add_child(scene)
	await process_frame
	var loaded: Dictionary = HybridRegionBake.load_source(SOURCE_PATH)
	var report: Dictionary = HybridRegionBake.bake(loaded.get("source", {}), "overlay.lowlands.scene-contract", 4101)
	var configured: Dictionary = scene.configure_from_bake(report)
	_expect(bool(configured.get("ok", false)), "the public scene seam must accept one valid bake report")

	var contract: Dictionary = scene.playable_contract()
	_expect(bool(contract.get("bake_ok", false)), "the visible scene must consume one valid authored bake")
	_expect(String(contract.get("topology_hash", "")) == String(report.get("topology_hash", "")), "the visible projection must bind the exact topology hash")
	_expect(String(contract.get("overlay_hash", "")) == String(report.get("overlay_hash", "")), "the visible projection must bind the exact overlay hash")
	_expect(String(contract.get("overlay_topology_hash", "")) == String(report.get("topology_hash", "")), "the visible overlay must bind the projected topology")
	_expect(int(contract.get("node_count", 0)) == 6, "the visible scene must assemble all six authored nodes")
	_expect(int(contract.get("edge_count", 0)) == 7, "the visible scene must assemble all seven authored edges")
	_expect(int(contract.get("main_route_count", 0)) == 2, "the visible scene must retain two complete main routes")
	_expect(int(contract.get("shortcut_route_count", 0)) == 1, "the visible scene must retain one complete shortcut")
	_expect(int(contract.get("landmark_count", 0)) == 3, "the visible scene must assemble three authored landmarks")
	_expect(int(contract.get("crossing_count", 0)) == 1, "the visible scene must assemble one authored crossing")
	_expect(int(contract.get("active_event_count", 0)) >= 1, "the fixed overlay must expose at least one visible dynamic event")
	_expect(bool(contract.get("vehicle_ready", false)), "the visible scene must instantiate the fixed-step prototype vehicle")
	_expect(bool(contract.get("camera_ready", false)), "the visible scene must instantiate its drive camera")
	_expect(bool(contract.get("vehicle_single_step", false)), "the scene must disable the vehicle's autonomous physics loop to prevent double stepping")
	_expect(contract.get("keyboard_actions", []) == ["drive_gas", "drive_brake", "drive_left", "drive_right", "drive_handbrake", "drive_recover"], "the playable seam must expose the existing keyboard action contract")
	_expect(bool(contract.get("keyboard_actions_ready", false)), "every required keyboard action must exist in the project input map")
	_expect(bool(contract.get("keyboard_bindings_ready", false)), "the playable scene must bind W/S/A/D/Space/E to its six drive actions")
	_expect(contract.get("keyboard_bindings", {}) == {
		"drive_gas": KEY_W,
		"drive_brake": KEY_S,
		"drive_left": KEY_A,
		"drive_right": KEY_D,
		"drive_handbrake": KEY_SPACE,
		"drive_recover": KEY_E,
	}, "the playable scene must expose the literal desktop keyboard map")
	var event_bindings: Dictionary = contract.get("projected_event_bindings", {})
	_expect(event_bindings.size() == int(contract.get("active_event_count", 0)), "every visible active event must expose one resolved socket binding")
	for event_instance_id in contract.get("projected_event_instance_ids", []):
		var binding: Dictionary = event_bindings.get(String(event_instance_id), {})
		_expect(not binding.is_empty(), "active event %s must retain its projected binding" % event_instance_id)
		_expect(not String(binding.get("socket_id", "")).is_empty(), "active event %s must resolve one stable socket" % event_instance_id)
		_expect(String(binding.get("target_kind", "")) in ["node", "edge"], "active event %s must resolve to one node or edge target" % event_instance_id)
		_expect(not String(binding.get("target_id", "")).is_empty(), "active event %s must retain its target stable ID" % event_instance_id)
		_expect(binding.get("target_position", null) is Vector2, "active event %s must expose its resolved world position" % event_instance_id)
	_expect(contract.get("projected_node_ids", []) == [
		"county.lowlands_proof.node.creek",
		"county.lowlands_proof.node.fork",
		"county.lowlands_proof.node.garage",
		"county.lowlands_proof.node.orchard",
		"county.lowlands_proof.node.quarry",
		"county.lowlands_proof.node.relay",
	], "the visible projection must retain the exact authored node IDs")
	_expect(contract.get("projected_edge_ids", []) == [
		"county.lowlands_proof.edge.creek_relay",
		"county.lowlands_proof.edge.fork_creek",
		"county.lowlands_proof.edge.fork_quarry",
		"county.lowlands_proof.edge.garage_fork",
		"county.lowlands_proof.edge.orchard_relay",
		"county.lowlands_proof.edge.quarry_orchard",
		"county.lowlands_proof.edge.quarry_relay_shortcut",
	], "the visible projection must retain the exact authored edge IDs")
	_expect(contract.get("projected_route_ids", []) == [
		"county.lowlands_proof.route.dirt",
		"county.lowlands_proof.route.primary",
		"county.lowlands_proof.route.quarry_shortcut",
	], "the visible projection must retain the exact authored route IDs")
	_expect(contract.get("projected_landmark_ids", []) == [
		"county.lowlands_proof.landmark.garage",
		"county.lowlands_proof.landmark.quarry",
		"county.lowlands_proof.landmark.relay",
	], "the visible projection must retain the exact authored landmark IDs")
	_expect(contract.get("projected_crossing_ids", []) == ["county.lowlands_proof.crossing.creek"], "the visible projection must retain the exact authored crossing ID")
	var expected_event_ids: Array[String] = []
	for event in report.get("expedition_overlay", {}).get("active_events", []):
		expected_event_ids.append(String(event.get("event_instance_id", "")))
	expected_event_ids.sort()
	_expect(contract.get("projected_event_instance_ids", []) == expected_event_ids, "only active overlay events may appear in the visible projection")
	_expect(contract.get("start_position", Vector2.INF) == Vector2(0.0, 0.0), "the visible vehicle start must resolve from the authored Garage node")
	_expect(contract.get("objective_position", Vector2.INF) == Vector2(3040.0, 0.0), "the visible objective must resolve from the authored relay node")
	var visible_bounds: Rect2 = contract.get("visible_bounds", Rect2())
	_expect(visible_bounds.size.x >= 3000.0 and visible_bounds.size.y >= 1000.0, "the projected graph must occupy nonempty visible world bounds")
	_expect(String(scene.surface_at(Vector2(450.0, 0.0)).get("name", "")) == "road", "the primary edge midpoint must project road handling")
	_expect(String(scene.surface_at(Vector2(1240.0, 280.0)).get("name", "")) == "dirt", "the quarry edge midpoint must project dirt handling")
	_expect(String(scene.surface_at(Vector2(1980.0, 580.0)).get("name", "")) == "mud", "the orchard edge midpoint must project mud handling")
	_expect(String(scene.surface_at(Vector2(2310.0, 280.0)).get("name", "")) == "rough", "the shortcut midpoint must project rough handling")

	var authored_start: Vector2 = contract.get("start_position", Vector2.INF)
	scene.set("live_input_enabled", true)
	Input.action_press("drive_gas")
	for frame in 45:
		await physics_frame
	Input.action_release("drive_gas")
	var moved_position: Vector2 = scene.runtime_snapshot().get("vehicle", {}).get("position", authored_start)
	_expect(moved_position.distance_to(authored_start) >= 40.0, "the real drive_gas InputMap action must move the fixed-step vehicle")
	scene.reset_to_start()
	var reset_position: Vector2 = scene.runtime_snapshot().get("vehicle", {}).get("position", Vector2.INF)
	_expect(reset_position == authored_start, "reset must return the vehicle exactly to the authored start")
	var handbrake_press := InputEventKey.new()
	handbrake_press.keycode = KEY_SPACE
	handbrake_press.pressed = true
	root.push_input(handbrake_press)
	await process_frame
	await physics_frame
	var pressed_handbrake := float(scene.runtime_snapshot().get("vehicle", {}).get("intent", {}).get("handbrake", 0.0))
	_expect(pressed_handbrake >= 0.99, "a real Space key event must reach the scene-owned handbrake bridge")
	var handbrake_release := InputEventKey.new()
	handbrake_release.keycode = KEY_SPACE
	handbrake_release.pressed = false
	root.push_input(handbrake_release)
	await process_frame
	await physics_frame
	var released_handbrake := float(scene.runtime_snapshot().get("vehicle", {}).get("intent", {}).get("handbrake", 1.0))
	_expect(released_handbrake <= 0.01, "releasing Space must clear the scene-owned handbrake bridge")

	var repeated_scene := packed.instantiate()
	repeated_scene.set("live_input_enabled", false)
	root.add_child(repeated_scene)
	await process_frame
	var repeated_configuration: Dictionary = repeated_scene.configure_from_bake(report)
	_expect(bool(repeated_configuration.get("ok", false)), "the same bake report must configure a second scene")
	var repeated_contract: Dictionary = repeated_scene.playable_contract()
	for field in [
		"topology_hash",
		"overlay_hash",
		"projected_node_ids",
		"projected_edge_ids",
		"projected_route_ids",
		"projected_landmark_ids",
		"projected_crossing_ids",
		"projected_event_instance_ids",
		"projected_event_bindings",
		"start_position",
		"objective_position",
		"visible_bounds",
	]:
		_expect(repeated_contract.get(field) == contract.get(field), "same bake report must reproduce projection field %s" % field)
	repeated_scene.queue_free()
	await process_frame

	var malformed: Dictionary = report.duplicate(true)
	var malformed_topology: Dictionary = malformed.get("topology", {}).duplicate(true)
	var malformed_landmarks: Array = malformed_topology.get("landmarks", []).duplicate(true)
	var malformed_landmark: Dictionary = malformed_landmarks[0].duplicate(true)
	malformed_landmark["node_id"] = "county.lowlands_proof.node.missing"
	malformed_landmarks[0] = malformed_landmark
	malformed_topology["landmarks"] = malformed_landmarks
	malformed["topology"] = malformed_topology
	malformed["topology_hash"] = JSON.stringify(malformed_topology).sha256_text()
	var malformed_overlay: Dictionary = malformed.get("expedition_overlay", {}).duplicate(true)
	malformed_overlay["topology_hash"] = malformed["topology_hash"]
	malformed["expedition_overlay"] = malformed_overlay
	malformed["overlay_hash"] = JSON.stringify(malformed_overlay).sha256_text()
	var rejected: Dictionary = scene.configure_from_bake(malformed)
	_expect(not bool(rejected.get("ok", true)), "a hash-consistent report with an unresolved landmark must fail closed")
	var rejected_contract: Dictionary = scene.playable_contract()
	_expect(not bool(rejected_contract.get("vehicle_ready", true)), "a rejected projection must leave no partial vehicle")
	_expect(int(rejected_contract.get("node_count", 0)) == 0, "a rejected projection must leave no partial world")

	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("HYBRID_REGION_SCENE_CONTRACT pass=true")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	quit(1)
