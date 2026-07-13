extends SceneTree

const HybridRegionBake = preload("res://prototypes/hybrid_region/hybrid_region_bake.gd")
const SOURCE_PATH := "res://prototypes/hybrid_region/hybrid_region_source.json"

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var loaded: Dictionary = HybridRegionBake.load_source(SOURCE_PATH)
	_expect(bool(loaded.get("ok", false)), "authored region source must load: %s" % str(loaded.get("errors", [])))
	var source: Dictionary = loaded.get("source", {})
	if source.is_empty():
		_finish()
		return

	var first: Dictionary = HybridRegionBake.bake(source, "overlay.lowlands.0001", 4101)
	var repeated: Dictionary = HybridRegionBake.bake(source, "overlay.lowlands.0001", 4101)
	var different_seed: Dictionary = HybridRegionBake.bake(source, "overlay.lowlands.0001", 4102)
	var different_overlay: Dictionary = HybridRegionBake.bake(source, "overlay.lowlands.0002", 4101)

	_expect(bool(first.get("ok", false)), "valid authored source must bake: %s" % str(first.get("errors", [])))
	_expect(first.get("topology_hash", "") == repeated.get("topology_hash", ""), "same source must retain one topology hash")
	_expect(first.get("overlay_hash", "") == repeated.get("overlay_hash", ""), "same overlay and seed must retain one overlay hash")
	_expect(first.get("bake_hash", "") == repeated.get("bake_hash", ""), "same overlay and seed must retain one bake hash")
	_expect(first.get("topology", {}) == different_seed.get("topology", {}), "seed changes must never alter authored topology")
	_expect(first.get("topology_hash", "") == different_seed.get("topology_hash", ""), "seed changes must never alter topology identity")
	_expect(first.get("topology", {}) == different_overlay.get("topology", {}), "overlay identity must never alter authored topology")
	_expect(_overlay_decisions(first) == _overlay_decisions(different_overlay), "overlay identity must scope events without rerolling a fixed seed")
	_expect(_event_instance_ids(first) != _event_instance_ids(different_overlay), "event instance IDs must be scoped to the expedition overlay")
	var overlay: Dictionary = first.get("expedition_overlay", {})
	_expect(String(overlay.get("schema", "")) == "keep-driving.hybrid-region-overlay.v1", "bake must emit one versioned expedition overlay")
	_expect(String(overlay.get("overlay_id", "")) == "overlay.lowlands.0001", "overlay must retain its supplied stable identity")
	_expect(String(overlay.get("county_id", "")) == String(first.get("county_id", "")), "overlay must bind the authored county")
	_expect(String(overlay.get("topology_hash", "")) == String(first.get("topology_hash", "")), "overlay must bind the exact authored topology")
	_expect(not overlay.has("nodes") and not overlay.has("edges") and not overlay.has("route_contracts"), "overlay must never duplicate authored topology")

	var contract: Dictionary = first.get("contract", {})
	_expect(int(contract.get("main_route_count", 0)) == 2, "the authored macrograph must contain exactly two complete main routes")
	_expect(int(contract.get("shortcut_route_count", 0)) == 1, "the authored macrograph must contain one complete shortcut route")
	_expect(int(contract.get("landmark_count", 0)) == 3, "the authored macrograph must contain three stable landmarks")
	_expect(int(contract.get("crossing_count", 0)) == 1, "the authored macrograph must contain one crossing")
	_expect(int(contract.get("event_socket_count", 0)) >= 1, "the authored macrograph must expose at least one event socket")
	_expect(int(contract.get("event_template_count", 0)) >= 2, "the authored macrograph must define multiple eligible event templates")

	var overlay_hashes := {}
	for seed in range(100, 200):
		var baked: Dictionary = HybridRegionBake.bake(source, "overlay.lowlands.seed-proof", seed)
		_expect(bool(baked.get("ok", false)), "seed %d must preserve a valid authored bake" % seed)
		overlay_hashes[String(baked.get("overlay_hash", ""))] = true
	_expect(overlay_hashes.size() >= 8, "100 seeds must produce material overlay variation without changing topology")

	var reordered: Dictionary = source.duplicate(true)
	var sockets: Array = reordered.get("event_sockets", []).duplicate(true)
	sockets.reverse()
	reordered["event_sockets"] = sockets
	var reordered_bake: Dictionary = HybridRegionBake.bake(reordered, "overlay.lowlands.0001", 4101)
	_expect(_overlay_decisions(first) == _overlay_decisions(reordered_bake), "stable socket IDs, not authoring order, must determine overlay decisions")

	var broken: Dictionary = source.duplicate(true)
	var broken_edges: Array = broken.get("edges", []).duplicate(true)
	var broken_edge: Dictionary = broken_edges[0].duplicate(true)
	broken_edge["to_node_id"] = "county.lowlands_proof.node.missing"
	broken_edges[0] = broken_edge
	broken["edges"] = broken_edges
	var rejected: Dictionary = HybridRegionBake.bake(broken, "overlay.lowlands.invalid", 4101)
	_expect(not bool(rejected.get("ok", true)), "a dangling node reference must reject the bake")
	_expect(_errors_contain(rejected.get("errors", []), "unresolved node"), "a rejected dangling reference must name the unresolved-node failure")
	_expect(_has_no_partial_artifact(rejected), "a rejected dangling reference must emit no partial artifact")

	var unknown_event: Dictionary = source.duplicate(true)
	var unknown_event_sockets: Array = unknown_event.get("event_sockets", []).duplicate(true)
	var unknown_event_socket: Dictionary = unknown_event_sockets[0].duplicate(true)
	unknown_event_socket["eligible_event_ids"] = ["county.lowlands_proof.event.missing"]
	unknown_event_sockets[0] = unknown_event_socket
	unknown_event["event_sockets"] = unknown_event_sockets
	var unknown_event_result: Dictionary = HybridRegionBake.bake(unknown_event, "overlay.lowlands.invalid-event", 4101)
	_expect(not bool(unknown_event_result.get("ok", true)), "an unknown eligible event must reject the bake")
	_expect(_errors_contain(unknown_event_result.get("errors", []), "unresolved event"), "an unknown eligible event must name the unresolved-event failure")
	_expect(_has_no_partial_artifact(unknown_event_result), "an unknown eligible event must emit no partial artifact")

	var duplicate_id: Dictionary = source.duplicate(true)
	var duplicate_landmarks: Array = duplicate_id.get("landmarks", []).duplicate(true)
	var duplicate_landmark: Dictionary = duplicate_landmarks[0].duplicate(true)
	duplicate_landmark["id"] = "county.lowlands_proof.node.garage"
	duplicate_landmarks[0] = duplicate_landmark
	duplicate_id["landmarks"] = duplicate_landmarks
	var duplicate_id_result: Dictionary = HybridRegionBake.bake(duplicate_id, "overlay.lowlands.duplicate-id", 4101)
	_expect(not bool(duplicate_id_result.get("ok", true)), "a globally duplicated stable ID must reject the bake")
	_expect(_errors_contain(duplicate_id_result.get("errors", []), "duplicate stable id"), "a duplicate must name the global stable-ID failure")

	var duplicate_route: Dictionary = source.duplicate(true)
	var duplicate_routes: Array = duplicate_route.get("route_contracts", []).duplicate(true)
	var first_main_route: Dictionary = duplicate_routes[0]
	var second_main_route: Dictionary = duplicate_routes[1].duplicate(true)
	second_main_route["edge_ids"] = first_main_route.get("edge_ids", []).duplicate()
	duplicate_routes[1] = second_main_route
	duplicate_route["route_contracts"] = duplicate_routes
	var duplicate_route_result: Dictionary = HybridRegionBake.bake(duplicate_route, "overlay.lowlands.duplicate-route", 4101)
	_expect(not bool(duplicate_route_result.get("ok", true)), "two destination routes without distinct authored edges must reject the bake")
	_expect(_errors_contain(duplicate_route_result.get("errors", []), "distinct edge"), "duplicated routes must name the distinct-edge failure")

	_finish()


func _overlay_decisions(bake: Dictionary) -> Dictionary:
	var decisions := {}
	for item in bake.get("expedition_overlay", {}).get("active_events", []):
		decisions[String(item.get("socket_id", ""))] = {
			"active": bool(item.get("active", false)),
			"condition": String(item.get("condition", "")),
			"event_id": String(item.get("event_id", "")),
		}
	return decisions


func _event_instance_ids(bake: Dictionary) -> Array[String]:
	var ids: Array[String] = []
	for item in bake.get("expedition_overlay", {}).get("active_events", []):
		ids.append(String(item.get("event_instance_id", "")))
	return ids


func _errors_contain(errors: Array, needle: String) -> bool:
	for error in errors:
		if needle in String(error):
			return true
	return false


func _has_no_partial_artifact(result: Dictionary) -> bool:
	return result.get("topology", {}).is_empty() and result.get("expedition_overlay", {}).is_empty()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("HYBRID_REGION_BAKE_CONTRACT seeds=100 pass=true")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	quit(1)
