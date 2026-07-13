extends RefCounted

const SOURCE_SCHEMA := "keep-driving.hybrid-region-source.v1"


static func load_source(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "errors": ["source file does not exist: %s" % path], "source": {}}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["source file could not be opened: %s" % path], "source": {}}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["source file must contain one JSON object"], "source": {}}
	return {"ok": true, "errors": [], "source": parsed}


static func bake(source: Dictionary, overlay_id: String, seed: int) -> Dictionary:
	var errors := _validate_source(source, overlay_id)
	if not errors.is_empty():
		return {"ok": false, "errors": errors}
	var topology := _canonical_topology(source)
	var topology_hash := JSON.stringify(topology).sha256_text()
	var socket_resolutions := _build_overlay(source, overlay_id, seed)
	var active_events := []
	for resolution in socket_resolutions:
		if bool(resolution.get("active", false)):
			active_events.append(resolution)
	var expedition_overlay := {
		"schema": "keep-driving.hybrid-region-overlay.v1",
		"overlay_id": overlay_id,
		"county_id": String(source.get("county_id", "")),
		"topology_version": int(source.get("version", 0)),
		"topology_hash": topology_hash,
		"seed": seed,
		"active_events": active_events,
	}
	var overlay_hash := JSON.stringify(expedition_overlay).sha256_text()
	var route_analysis := _analyze_routes(source.get("route_contracts", []))
	return {
		"ok": true,
		"errors": [],
		"county_id": String(source.get("county_id", "")),
		"overlay_id": overlay_id,
		"seed": seed,
		"topology": topology,
		"topology_hash": topology_hash,
		"expedition_overlay": expedition_overlay,
		"overlay_hash": overlay_hash,
		"bake_hash": (topology_hash + "|" + overlay_hash).sha256_text(),
		"contract": {
			"main_route_count": int(route_analysis.get("main_route_count", 0)),
			"shortcut_route_count": int(route_analysis.get("shortcut_route_count", 0)),
			"landmark_count": source.get("landmarks", []).size(),
			"crossing_count": source.get("crossings", []).size(),
			"event_template_count": source.get("event_templates", []).size(),
			"event_socket_count": source.get("event_sockets", []).size(),
		},
	}


static func _validate_source(source: Dictionary, overlay_id: String) -> Array[String]:
	var errors: Array[String] = []
	if String(source.get("schema", "")) != SOURCE_SCHEMA:
		errors.append("source schema must be %s" % SOURCE_SCHEMA)
	var county_id := String(source.get("county_id", ""))
	if county_id.is_empty():
		errors.append("county_id must be nonempty")
	if overlay_id.is_empty():
		errors.append("overlay_id must be nonempty")

	var nodes: Array = source.get("nodes", [])
	var edges: Array = source.get("edges", [])
	var routes: Array = source.get("route_contracts", [])
	var landmarks: Array = source.get("landmarks", [])
	var crossings: Array = source.get("crossings", [])
	var event_templates: Array = source.get("event_templates", [])
	var sockets: Array = source.get("event_sockets", [])
	var node_ids := _record_ids(nodes, county_id, "node", errors)
	var edge_ids := _record_ids(edges, county_id, "edge", errors)
	_record_ids(routes, county_id, "route", errors)
	_record_ids(landmarks, county_id, "landmark", errors)
	_record_ids(crossings, county_id, "crossing", errors)
	var event_ids := _record_ids(event_templates, county_id, "event template", errors)
	_record_ids(sockets, county_id, "event socket", errors)
	var all_ids := {}
	for records in [nodes, edges, routes, landmarks, crossings, event_templates, sockets]:
		for record in records:
			if not record is Dictionary:
				continue
			var stable_id := String(record.get("id", ""))
			if all_ids.has(stable_id):
				errors.append("duplicate stable id %s" % stable_id)
			else:
				all_ids[stable_id] = true

	var edge_by_id := {}
	for edge in edges:
		if not edge is Dictionary:
			continue
		var edge_id := String(edge.get("id", ""))
		edge_by_id[edge_id] = edge
		for field in ["from_node_id", "to_node_id"]:
			var node_id := String(edge.get(field, ""))
			if not node_ids.has(node_id):
				errors.append("edge %s has unresolved node %s" % [edge_id, node_id])

	var start_node_id := String(source.get("start_node_id", ""))
	var objective_node_id := String(source.get("objective_node_id", ""))
	if not node_ids.has(start_node_id):
		errors.append("start_node_id has unresolved node %s" % start_node_id)
	if not node_ids.has(objective_node_id):
		errors.append("objective_node_id has unresolved node %s" % objective_node_id)

	var route_analysis := _analyze_routes(routes)
	var main_route_edge_sets: Array[Dictionary] = route_analysis.get("main_route_edge_sets", [])
	for route in routes:
		if not route is Dictionary:
			continue
		var route_id := String(route.get("id", ""))
		var purpose := String(route.get("purpose", ""))
		if purpose not in ["main", "shortcut"]:
			errors.append("route %s has unsupported purpose %s" % [route_id, purpose])
		var expected_from := start_node_id
		var route_edge_ids: Array = route.get("edge_ids", [])
		if route_edge_ids.is_empty():
			errors.append("route %s must contain at least one edge" % route_id)
		for edge_id_value in route_edge_ids:
			var edge_id := String(edge_id_value)
			if not edge_ids.has(edge_id):
				errors.append("route %s has unresolved edge %s" % [route_id, edge_id])
				continue
			var edge: Dictionary = edge_by_id[edge_id]
			if String(edge.get("from_node_id", "")) != expected_from:
				errors.append("route %s is not a continuous chain at edge %s" % [route_id, edge_id])
			expected_from = String(edge.get("to_node_id", ""))
		if not route_edge_ids.is_empty() and expected_from != objective_node_id:
			errors.append("route %s does not end at objective node" % route_id)
	if int(route_analysis.get("main_route_count", 0)) != 2:
		errors.append("source must contain exactly two main routes")
	if int(route_analysis.get("shortcut_route_count", 0)) != 1:
		errors.append("source must contain exactly one shortcut route")
	if main_route_edge_sets.size() == 2:
		var first_has_distinct_edge := false
		var second_has_distinct_edge := false
		for edge_id in main_route_edge_sets[0]:
			first_has_distinct_edge = first_has_distinct_edge or not main_route_edge_sets[1].has(edge_id)
		for edge_id in main_route_edge_sets[1]:
			second_has_distinct_edge = second_has_distinct_edge or not main_route_edge_sets[0].has(edge_id)
		if not first_has_distinct_edge or not second_has_distinct_edge:
			errors.append("main routes must each contain at least one distinct edge")

	for landmark in landmarks:
		if landmark is Dictionary and not node_ids.has(String(landmark.get("node_id", ""))):
			errors.append("landmark %s has unresolved node %s" % [landmark.get("id", ""), landmark.get("node_id", "")])
	for crossing in crossings:
		if crossing is Dictionary and not edge_ids.has(String(crossing.get("edge_id", ""))):
			errors.append("crossing %s has unresolved edge %s" % [crossing.get("id", ""), crossing.get("edge_id", "")])
	for socket in sockets:
		if not socket is Dictionary:
			continue
		var socket_id := String(socket.get("id", ""))
		var target_node_id := String(socket.get("target_node_id", ""))
		var target_edge_id := String(socket.get("target_edge_id", ""))
		if target_node_id.is_empty() == target_edge_id.is_empty():
			errors.append("event socket %s must target exactly one node or edge" % socket_id)
		elif not target_node_id.is_empty() and not node_ids.has(target_node_id):
			errors.append("event socket %s has unresolved node %s" % [socket_id, target_node_id])
		elif not target_edge_id.is_empty() and not edge_ids.has(target_edge_id):
			errors.append("event socket %s has unresolved edge %s" % [socket_id, target_edge_id])
		if socket.get("condition_options", []).is_empty():
			errors.append("event socket %s must define condition options" % socket_id)
		var eligible_event_ids: Array = socket.get("eligible_event_ids", [])
		if eligible_event_ids.size() < 2:
			errors.append("event socket %s must define at least two eligible events" % socket_id)
		for event_id_value in eligible_event_ids:
			var event_id := String(event_id_value)
			if not event_ids.has(event_id):
				errors.append("event socket %s has unresolved event %s" % [socket_id, event_id])
	if landmarks.size() != 3:
		errors.append("source must contain exactly three landmarks")
	if crossings.size() != 1:
		errors.append("source must contain exactly one crossing")
	if sockets.is_empty():
		errors.append("source must contain at least one event socket")
	return errors


static func _analyze_routes(routes: Array) -> Dictionary:
	var main_route_count := 0
	var shortcut_route_count := 0
	var main_route_edge_sets: Array[Dictionary] = []
	for route in routes:
		if not route is Dictionary:
			continue
		match String(route.get("purpose", "")):
			"main":
				main_route_count += 1
				var main_edge_set := {}
				for edge_id in route.get("edge_ids", []):
					main_edge_set[String(edge_id)] = true
				main_route_edge_sets.append(main_edge_set)
			"shortcut":
				shortcut_route_count += 1
	return {
		"main_route_count": main_route_count,
		"shortcut_route_count": shortcut_route_count,
		"main_route_edge_sets": main_route_edge_sets,
	}


static func _record_ids(records: Array, id_namespace: String, label: String, errors: Array[String]) -> Dictionary:
	var ids := {}
	for record in records:
		if not record is Dictionary:
			errors.append("%s record must be an object" % label)
			continue
		var id := String(record.get("id", ""))
		if id.is_empty():
			errors.append("%s id must be nonempty" % label)
		elif not id.begins_with(id_namespace + "."):
			errors.append("%s id must be namespaced by %s: %s" % [label, id_namespace, id])
		elif ids.has(id):
			errors.append("duplicate %s id %s" % [label, id])
		else:
			ids[id] = true
	return ids


static func _canonical_topology(source: Dictionary) -> Dictionary:
	return {
		"county_id": String(source.get("county_id", "")),
		"version": int(source.get("version", 0)),
		"start_node_id": String(source.get("start_node_id", "")),
		"objective_node_id": String(source.get("objective_node_id", "")),
		"nodes": _records_sorted_by_id(source.get("nodes", [])),
		"edges": _records_sorted_by_id(source.get("edges", [])),
		"route_contracts": _records_sorted_by_id(source.get("route_contracts", [])),
		"landmarks": _records_sorted_by_id(source.get("landmarks", [])),
		"crossings": _records_sorted_by_id(source.get("crossings", [])),
		"event_templates": _records_sorted_by_id(source.get("event_templates", [])),
		"event_sockets": _records_sorted_by_id(source.get("event_sockets", [])),
	}


static func _build_overlay(source: Dictionary, overlay_id: String, seed: int) -> Array:
	var overlay := []
	for socket in _records_sorted_by_id(source.get("event_sockets", [])):
		var socket_id := String(socket.get("id", ""))
		var selector := _mix_int(seed ^ _stable_string_hash(socket_id))
		var conditions: Array = socket.get("condition_options", [])
		var eligible_event_ids: Array = socket.get("eligible_event_ids", [])
		overlay.append({
			"socket_id": socket_id,
			"event_instance_id": "%s::%s" % [overlay_id, socket_id],
			"active": selector % 4 != 0,
			"condition": String(conditions[selector % conditions.size()]),
			"event_id": String(eligible_event_ids[(selector / 7) % eligible_event_ids.size()]),
		})
	return overlay


static func _records_sorted_by_id(records: Array) -> Array:
	var by_id := {}
	var ids: Array[String] = []
	for record in records:
		if not record is Dictionary:
			continue
		var id := String(record.get("id", ""))
		by_id[id] = record
		ids.append(id)
	ids.sort()
	var sorted := []
	for id in ids:
		sorted.append((by_id[id] as Dictionary).duplicate(true))
	return sorted


static func _stable_string_hash(text: String) -> int:
	var hash_value := 2166136261
	for byte in text.to_utf8_buffer():
		hash_value = ((hash_value ^ int(byte)) * 16777619) & 0x7fffffff
	return hash_value


static func _mix_int(value: int) -> int:
	var mixed := value
	mixed = ((mixed >> 16) ^ mixed) * 0x45d9f3b
	mixed = ((mixed >> 16) ^ mixed) * 0x45d9f3b
	mixed = (mixed >> 16) ^ mixed
	return mixed & 0x7fffffff
