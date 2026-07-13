extends Node2D

# PROTOTYPE: visible, static projection of one validated Hybrid Region bake report.

const UI_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Regular.otf")
const UI_FONT_BOLD: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Bold.otf")
const SAFEHOUSE: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/safehouse.svg")
const RELAY: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/radio_relay.svg")
const OBJECTIVE: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/objective.svg")
const THREAT: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/threat.svg")

const SURFACE_PROFILES := {
	"road": {"name": "road", "speed_multiplier": 1.0, "grip": 1.0, "rolling_drag": 30.0},
	"dirt": {"name": "dirt", "speed_multiplier": 0.76, "grip": 0.68, "rolling_drag": 54.0},
	"mud": {"name": "mud", "speed_multiplier": 0.48, "grip": 0.42, "rolling_drag": 96.0},
	"rough": {"name": "rough", "speed_multiplier": 0.64, "grip": 0.55, "rolling_drag": 72.0},
	"grass": {"name": "grass", "speed_multiplier": 0.58, "grip": 0.56, "rolling_drag": 76.0},
}

const SURFACE_COLORS := {
	"road": Color("8f9692"),
	"dirt": Color("b68a55"),
	"mud": Color("765b4d"),
	"rough": Color("95806d"),
}

var _configured := false
var _errors: Array[String] = []
var _report: Dictionary = {}
var _topology: Dictionary = {}
var _overlay: Dictionary = {}
var _node_positions := {}
var _edge_by_id := {}
var _socket_by_id := {}
var _node_ids: Array[String] = []
var _edge_ids: Array[String] = []
var _route_ids: Array[String] = []
var _landmark_ids: Array[String] = []
var _crossing_ids: Array[String] = []
var _event_instance_ids: Array[String] = []
var _event_bindings := {}
var _start_position := Vector2.ZERO
var _objective_position := Vector2.ZERO
var _visual_bounds := Rect2()

var _edge_layer: Node2D
var _node_layer: Node2D
var _landmark_layer: Node2D
var _crossing_layer: Node2D
var _event_layer: Node2D


func configure_from_bake(report: Dictionary) -> Dictionary:
	_clear_projection()
	_errors = _validate_report(report)
	if not _errors.is_empty():
		return {"ok": false, "errors": _errors.duplicate()}
	_report = report.duplicate(true)
	_topology = _report.get("topology", {}).duplicate(true)
	_overlay = _report.get("expedition_overlay", {}).duplicate(true)
	_index_records()
	_build_projection()
	_configured = true
	return {"ok": true, "errors": [], "contract": playable_contract()}


func playable_contract() -> Dictionary:
	var main_route_count := 0
	var shortcut_route_count := 0
	for route in _topology.get("route_contracts", []):
		match String(route.get("purpose", "")):
			"main":
				main_route_count += 1
			"shortcut":
				shortcut_route_count += 1
	return {
		"bake_ok": _configured,
		"errors": _errors.duplicate(),
		"topology_hash": String(_report.get("topology_hash", "")),
		"overlay_hash": String(_report.get("overlay_hash", "")),
		"overlay_topology_hash": String(_overlay.get("topology_hash", "")),
		"node_count": _node_ids.size(),
		"edge_count": _edge_ids.size(),
		"route_count": _route_ids.size(),
		"main_route_count": main_route_count,
		"shortcut_route_count": shortcut_route_count,
		"landmark_count": _landmark_ids.size(),
		"crossing_count": _crossing_ids.size(),
		"active_event_count": _event_instance_ids.size(),
		"projected_node_ids": _node_ids.duplicate(),
		"projected_edge_ids": _edge_ids.duplicate(),
		"projected_route_ids": _route_ids.duplicate(),
		"projected_landmark_ids": _landmark_ids.duplicate(),
		"projected_crossing_ids": _crossing_ids.duplicate(),
		"projected_event_instance_ids": _event_instance_ids.duplicate(),
		"projected_event_bindings": _event_bindings.duplicate(true),
		"start_position": _start_position,
		"objective_position": _objective_position,
		"visible_bounds": _visual_bounds,
		"edge_target_placement": "midpoint_prototype",
	}


func surface_at(world_position: Vector2) -> Dictionary:
	var nearest_distance := INF
	var nearest_surface := "grass"
	for edge_id in _edge_ids:
		var edge: Dictionary = _edge_by_id[edge_id]
		var start: Vector2 = _node_positions.get(String(edge.get("from_node_id", "")), Vector2.ZERO)
		var finish: Vector2 = _node_positions.get(String(edge.get("to_node_id", "")), Vector2.ZERO)
		var distance := _distance_to_segment(world_position, start, finish)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_surface = String(edge.get("surface", "road"))
	if nearest_distance > 76.0 or not SURFACE_PROFILES.has(nearest_surface):
		return SURFACE_PROFILES["grass"].duplicate(true)
	return SURFACE_PROFILES[nearest_surface].duplicate(true)


func start_position() -> Vector2:
	return _start_position


func objective_position() -> Vector2:
	return _objective_position


func active_event_markers_near(world_position: Vector2, radius: float = 88.0) -> Array[String]:
	var nearby: Array[String] = []
	if _event_layer == null:
		return nearby
	for marker in _event_layer.get_children():
		if marker is Node2D and marker.global_position.distance_to(world_position) <= radius:
			nearby.append(String(marker.get_meta(&"event_instance_id", "")))
	nearby.sort()
	return nearby


func _validate_report(report: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if not bool(report.get("ok", false)):
		errors.append("bake report must be successful")
	var topology: Variant = report.get("topology", {})
	var overlay: Variant = report.get("expedition_overlay", {})
	if not topology is Dictionary or (topology as Dictionary).is_empty():
		errors.append("bake report must contain authored topology")
	if not overlay is Dictionary or (overlay as Dictionary).is_empty():
		errors.append("bake report must contain an expedition overlay")
	if not errors.is_empty():
		return errors
	var topology_dictionary := topology as Dictionary
	var overlay_dictionary := overlay as Dictionary
	var topology_hash := String(report.get("topology_hash", ""))
	var overlay_hash := String(report.get("overlay_hash", ""))
	if topology_hash.is_empty() or JSON.stringify(topology_dictionary).sha256_text() != topology_hash:
		errors.append("topology hash must bind the exact projected topology")
	if overlay_hash.is_empty() or JSON.stringify(overlay_dictionary).sha256_text() != overlay_hash:
		errors.append("overlay hash must bind the exact projected overlay")
	if String(overlay_dictionary.get("topology_hash", "")) != topology_hash:
		errors.append("overlay must bind the projected topology hash")
	var node_ids := _ids_for_records(topology_dictionary.get("nodes", []), "node", errors)
	var edge_ids := _ids_for_records(topology_dictionary.get("edges", []), "edge", errors)
	_ids_for_records(topology_dictionary.get("route_contracts", []), "route", errors)
	_ids_for_records(topology_dictionary.get("landmarks", []), "landmark", errors)
	_ids_for_records(topology_dictionary.get("crossings", []), "crossing", errors)
	var event_ids := _ids_for_records(topology_dictionary.get("event_templates", []), "event template", errors)
	var socket_ids := _ids_for_records(topology_dictionary.get("event_sockets", []), "event socket", errors)
	if not node_ids.has(String(topology_dictionary.get("start_node_id", ""))):
		errors.append("projected start has an unresolved node")
	if not node_ids.has(String(topology_dictionary.get("objective_node_id", ""))):
		errors.append("projected objective has an unresolved node")
	for edge in topology_dictionary.get("edges", []):
		if edge is Dictionary:
			for field in ["from_node_id", "to_node_id"]:
				if not node_ids.has(String(edge.get(field, ""))):
					errors.append("projected edge has an unresolved node")
	for route in topology_dictionary.get("route_contracts", []):
		if not route is Dictionary:
			continue
		for edge_id in route.get("edge_ids", []):
			if not edge_ids.has(String(edge_id)):
				errors.append("projected route has an unresolved edge")
	for landmark in topology_dictionary.get("landmarks", []):
		if landmark is Dictionary and not node_ids.has(String(landmark.get("node_id", ""))):
			errors.append("projected landmark has an unresolved node")
	for crossing in topology_dictionary.get("crossings", []):
		if crossing is Dictionary and not edge_ids.has(String(crossing.get("edge_id", ""))):
			errors.append("projected crossing has an unresolved edge")
	for event in overlay_dictionary.get("active_events", []):
		if not event is Dictionary:
			errors.append("active overlay event must be an object")
			continue
		if not socket_ids.has(String(event.get("socket_id", ""))):
			errors.append("active overlay event has an unresolved socket")
		if not event_ids.has(String(event.get("event_id", ""))):
			errors.append("active overlay event has an unresolved template")
		if String(event.get("event_instance_id", "")).is_empty():
			errors.append("active overlay event must retain an instance ID")
	for socket in topology_dictionary.get("event_sockets", []):
		if not socket is Dictionary:
			continue
		var node_id := String(socket.get("target_node_id", ""))
		var edge_id := String(socket.get("target_edge_id", ""))
		if not node_id.is_empty() and not node_ids.has(node_id):
			errors.append("event socket has an unresolved node")
		if not edge_id.is_empty() and not edge_ids.has(edge_id):
			errors.append("event socket has an unresolved edge")
	return errors


func _ids_for_records(records: Array, label: String, errors: Array[String]) -> Dictionary:
	var ids := {}
	for record in records:
		if not record is Dictionary:
			errors.append("%s projection record must be an object" % label)
			continue
		var stable_id := String(record.get("id", ""))
		if stable_id.is_empty() or ids.has(stable_id):
			errors.append("%s projection IDs must be nonempty and unique" % label)
		else:
			ids[stable_id] = true
	return ids


func _index_records() -> void:
	for node in _topology.get("nodes", []):
		var node_id := String(node.get("id", ""))
		_node_ids.append(node_id)
		_node_positions[node_id] = _vector_from_json(node.get("position", []))
	for edge in _topology.get("edges", []):
		var edge_id := String(edge.get("id", ""))
		_edge_ids.append(edge_id)
		_edge_by_id[edge_id] = edge
	for route in _topology.get("route_contracts", []):
		_route_ids.append(String(route.get("id", "")))
	for landmark in _topology.get("landmarks", []):
		_landmark_ids.append(String(landmark.get("id", "")))
	for crossing in _topology.get("crossings", []):
		_crossing_ids.append(String(crossing.get("id", "")))
	for socket in _topology.get("event_sockets", []):
		_socket_by_id[String(socket.get("id", ""))] = socket
	for event in _overlay.get("active_events", []):
		_event_instance_ids.append(String(event.get("event_instance_id", "")))
	for ids in [_node_ids, _edge_ids, _route_ids, _landmark_ids, _crossing_ids, _event_instance_ids]:
		ids.sort()
	_start_position = _node_positions.get(String(_topology.get("start_node_id", "")), Vector2.ZERO)
	_objective_position = _node_positions.get(String(_topology.get("objective_node_id", "")), Vector2.ZERO)
	_visual_bounds = _bounds_for_positions(_node_positions.values())


func _build_projection() -> void:
	var background := Polygon2D.new()
	background.name = "CountyGround"
	var margin := 520.0
	background.polygon = PackedVector2Array([
		_visual_bounds.position - Vector2.ONE * margin,
		Vector2(_visual_bounds.end.x + margin, _visual_bounds.position.y - margin),
		_visual_bounds.end + Vector2.ONE * margin,
		Vector2(_visual_bounds.position.x - margin, _visual_bounds.end.y + margin),
	])
	background.color = Color("29352d")
	background.z_index = -30
	add_child(background)

	_edge_layer = _layer("ProjectedEdges")
	_node_layer = _layer("ProjectedNodes")
	_landmark_layer = _layer("ProjectedLandmarks")
	_crossing_layer = _layer("ProjectedCrossings")
	_event_layer = _layer("ProjectedActiveEvents")
	for edge_id in _edge_ids:
		_build_edge(_edge_by_id[edge_id])
	for node in _topology.get("nodes", []):
		_build_node_marker(node)
	for landmark in _topology.get("landmarks", []):
		_build_landmark(landmark)
	for crossing in _topology.get("crossings", []):
		_build_crossing(crossing)
	for event in _overlay.get("active_events", []):
		_build_event_marker(event)


func _build_edge(edge: Dictionary) -> void:
	var edge_id := String(edge.get("id", ""))
	var holder := Node2D.new()
	holder.name = _node_name("Edge", edge_id)
	holder.set_meta(&"stable_id", edge_id)
	var points := PackedVector2Array([
		_node_positions[String(edge.get("from_node_id", ""))],
		_node_positions[String(edge.get("to_node_id", ""))],
	])
	var underlay := Line2D.new()
	underlay.name = "Roadbed"
	underlay.points = points
	underlay.width = 104.0
	underlay.default_color = Color("18201c")
	underlay.antialiased = true
	holder.add_child(underlay)
	var surface := String(edge.get("surface", "road"))
	var line := Line2D.new()
	line.name = "Surface_%s" % surface.capitalize()
	line.points = points
	line.width = 78.0
	line.default_color = SURFACE_COLORS.get(surface, Color("8f9692"))
	line.antialiased = true
	holder.add_child(line)
	_edge_layer.add_child(holder)


func _build_node_marker(node: Dictionary) -> void:
	var node_id := String(node.get("id", ""))
	var holder := Node2D.new()
	holder.name = _node_name("Node", node_id)
	holder.position = _node_positions[node_id]
	holder.set_meta(&"stable_id", node_id)
	var disc := Polygon2D.new()
	disc.polygon = _circle_polygon(24.0, 18)
	disc.color = Color("f0d18b")
	holder.add_child(disc)
	_node_layer.add_child(holder)


func _build_landmark(landmark: Dictionary) -> void:
	var landmark_id := String(landmark.get("id", ""))
	var holder := Node2D.new()
	holder.name = _node_name("Landmark", landmark_id)
	holder.position = _node_positions[String(landmark.get("node_id", ""))] + Vector2(0.0, -92.0)
	holder.set_meta(&"stable_id", landmark_id)
	var sprite := Sprite2D.new()
	sprite.texture = _landmark_texture(String(landmark.get("kind", "")))
	sprite.scale = Vector2.ONE * 0.34
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	holder.add_child(sprite)
	var label := _label(_short_id(landmark_id).to_upper(), 18, Color("f5ebd3"))
	label.position = Vector2(-76.0, 38.0)
	label.size = Vector2(152.0, 28.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	holder.add_child(label)
	_landmark_layer.add_child(holder)


func _build_crossing(crossing: Dictionary) -> void:
	var crossing_id := String(crossing.get("id", ""))
	var holder := Node2D.new()
	holder.name = _node_name("Crossing", crossing_id)
	holder.position = _edge_midpoint(String(crossing.get("edge_id", "")))
	holder.set_meta(&"stable_id", crossing_id)
	var bar := Polygon2D.new()
	bar.polygon = PackedVector2Array([Vector2(-46, -12), Vector2(46, -12), Vector2(46, 12), Vector2(-46, 12)])
	bar.color = Color("64b7c7")
	holder.add_child(bar)
	_crossing_layer.add_child(holder)


func _build_event_marker(event: Dictionary) -> void:
	var socket_id := String(event.get("socket_id", ""))
	var socket: Dictionary = _socket_by_id[socket_id]
	var target_kind := "node"
	var target_id := String(socket.get("target_node_id", ""))
	var target_position: Vector2 = _node_positions.get(target_id, Vector2.INF)
	if target_position == Vector2.INF:
		target_kind = "edge"
		target_id = String(socket.get("target_edge_id", ""))
		target_position = _edge_midpoint(target_id)
	var event_instance_id := String(event.get("event_instance_id", ""))
	_event_bindings[event_instance_id] = {
		"socket_id": socket_id,
		"target_kind": target_kind,
		"target_id": target_id,
		"target_position": target_position,
	}
	var holder := Node2D.new()
	holder.name = _node_name("Event", event_instance_id)
	holder.position = target_position + Vector2(0.0, 72.0)
	holder.set_meta(&"event_instance_id", event_instance_id)
	holder.set_meta(&"socket_id", socket_id)
	holder.set_meta(&"event_id", String(event.get("event_id", "")))
	var sprite := Sprite2D.new()
	sprite.texture = THREAT
	sprite.scale = Vector2.ONE * 0.25
	sprite.modulate = Color("f2a35e")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	holder.add_child(sprite)
	var label := _label(String(event.get("condition", "")).to_upper(), 14, Color("ffe2b8"))
	label.position = Vector2(-70.0, 28.0)
	label.size = Vector2(140.0, 24.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	holder.add_child(label)
	_event_layer.add_child(holder)


func _clear_projection() -> void:
	for child in get_children():
		child.free()
	_configured = false
	_errors.clear()
	_report.clear()
	_topology.clear()
	_overlay.clear()
	_node_positions.clear()
	_edge_by_id.clear()
	_socket_by_id.clear()
	_node_ids.clear()
	_edge_ids.clear()
	_route_ids.clear()
	_landmark_ids.clear()
	_crossing_ids.clear()
	_event_instance_ids.clear()
	_event_bindings.clear()
	_start_position = Vector2.ZERO
	_objective_position = Vector2.ZERO
	_visual_bounds = Rect2()
	_edge_layer = null
	_node_layer = null
	_landmark_layer = null
	_crossing_layer = null
	_event_layer = null


func _layer(layer_name: String) -> Node2D:
	var layer := Node2D.new()
	layer.name = layer_name
	add_child(layer)
	return layer


func _edge_midpoint(edge_id: String) -> Vector2:
	var edge: Dictionary = _edge_by_id.get(edge_id, {})
	return _node_positions.get(String(edge.get("from_node_id", "")), Vector2.ZERO).lerp(
		_node_positions.get(String(edge.get("to_node_id", "")), Vector2.ZERO), 0.5
	)


func _vector_from_json(value: Variant) -> Vector2:
	if value is Array and value.size() >= 2:
		return Vector2(float(value[0]), float(value[1]))
	return Vector2.ZERO


func _bounds_for_positions(positions: Array) -> Rect2:
	if positions.is_empty():
		return Rect2()
	var first: Vector2 = positions[0]
	var minimum := first
	var maximum := first
	for value in positions:
		var point: Vector2 = value
		minimum = Vector2(minf(minimum.x, point.x), minf(minimum.y, point.y))
		maximum = Vector2(maxf(maximum.x, point.x), maxf(maximum.y, point.y))
	return Rect2(minimum, maximum - minimum)


func _distance_to_segment(point: Vector2, start: Vector2, finish: Vector2) -> float:
	var segment := finish - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)
	var amount := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * amount)


func _circle_polygon(radius: float, point_count: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in point_count:
		points.append(Vector2.RIGHT.rotated(TAU * float(index) / float(point_count)) * radius)
	return points


func _landmark_texture(kind: String) -> Texture2D:
	match kind:
		"safehouse":
			return SAFEHOUSE
		"radio_relay":
			return RELAY
		_:
			return OBJECTIVE


func _label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_override("font", UI_FONT_BOLD)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _node_name(prefix: String, stable_id: String) -> String:
	return "%s_%s" % [prefix, stable_id.replace(".", "_").replace(":", "_")]


func _short_id(stable_id: String) -> String:
	return stable_id.get_slice(".", stable_id.get_slice_count(".") - 1)
