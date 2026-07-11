extends Node2D

# PROTOTYPE — throw away after the production handling/first-road question is answered.

const START_POSITION := Vector2(-720.0, 0.0)
const GOAL_POSITION := Vector2(1080.0, 0.0)

var obstacle_specs := [
	{"position": Vector2(210, -28), "weight": "light", "damage": 6.0, "radius": 26.0},
	{"position": Vector2(560, -255), "weight": "medium", "damage": 16.0, "radius": 42.0},
	{"position": Vector2(650, 300), "weight": "heavy", "damage": 34.0, "radius": 58.0},
]

func _ready() -> void:
	for spec in obstacle_specs:
		_add_obstacle(spec)
	queue_redraw()

func surface_at(world_position:Vector2) -> Dictionary:
	if _distance_to_segment(world_position, Vector2(-40, 15), Vector2(920, 430)) <= 112.0:
		return {
			"name": "mud",
			"speed_multiplier": 0.48,
			"grip": 0.42,
			"rolling_drag": 96.0,
		}
	if _distance_to_segment(world_position, Vector2(-40, -18), Vector2(920, -420)) <= 102.0:
		return {
			"name": "dirt",
			"speed_multiplier": 0.76,
			"grip": 0.68,
			"rolling_drag": 54.0,
		}
	if absf(world_position.y) <= 126.0:
		return {
			"name": "road",
			"speed_multiplier": 1.0,
			"grip": 1.0,
			"rolling_drag": 30.0,
		}
	return {
		"name": "grass",
		"speed_multiplier": 0.58,
		"grip": 0.56,
		"rolling_drag": 76.0,
	}

func _add_obstacle(spec:Dictionary) -> void:
	var obstacle := StaticBody2D.new()
	obstacle.name = "PrototypeObstacle_%s" % str(spec["weight"])
	obstacle.position = spec["position"]
	obstacle.set_meta("weight", spec["weight"])
	obstacle.set_meta("damage", spec["damage"])
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = float(spec["radius"])
	shape_node.shape = shape
	obstacle.add_child(shape_node)
	add_child(obstacle)

func _draw() -> void:
	# Broad atlas-like land blocks.
	draw_rect(Rect2(-6000, -4000, 12000, 8000), Color("6f7d54"))
	for x in range(-1600, 1601, 320):
		for y in range(-800, 801, 260):
			var tint := Color("78845a") if posmod((x / 320) + (y / 260), 2) == 0 else Color("65754e")
			draw_rect(Rect2(x, y, 305, 245), tint)

	# Main asphalt and two genuine choices: a fast dirt arc and a risky mud shortcut.
	draw_rect(Rect2(-6000, -126, 12000, 252), Color("282a29"))
	draw_line(Vector2(-6000, 0), Vector2(6000, 0), Color(0.91, 0.75, 0.29, 0.72), 5.0, true)
	draw_line(Vector2(-40, -18), Vector2(920, -420), Color("a76f3d"), 204.0, true)
	draw_line(Vector2(-40, -18), Vector2(920, -420), Color(0.18, 0.12, 0.08, 0.28), 8.0, true)
	draw_line(Vector2(-40, 15), Vector2(920, 430), Color("526e64"), 224.0, true)
	draw_line(Vector2(-40, 15), Vector2(920, 430), Color(0.38, 0.70, 0.73, 0.28), 10.0, true)

	# Garage lot and route fork framing.
	draw_rect(Rect2(START_POSITION - Vector2(150, 150), Vector2(300, 300)), Color("343633"), true)
	draw_rect(Rect2(START_POSITION - Vector2(150, 150), Vector2(300, 300)), Color("f0c547"), false, 5.0)
	draw_string(ThemeDB.fallback_font, START_POSITION + Vector2(-88, -175), "GARAGE TEST LOT", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("f1e8cf"))
	draw_string(ThemeDB.fallback_font, Vector2(-5, -155), "FAST ROAD", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f1e8cf"))
	draw_string(ThemeDB.fallback_font, Vector2(90, -225), "DIRT / CONTROL", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f1e8cf"))
	draw_string(ThemeDB.fallback_font, Vector2(90, 245), "MUD / SHORTCUT", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f1e8cf"))

	# Goal landmark: a readable road-atlas radio tower.
	draw_circle(GOAL_POSITION, 92.0, Color(0.39, 0.72, 0.78, 0.18))
	draw_circle(GOAL_POSITION, 54.0, Color("2f7775"))
	draw_line(GOAL_POSITION + Vector2(0, 58), GOAL_POSITION + Vector2(0, -80), Color("171818"), 12.0)
	draw_line(GOAL_POSITION + Vector2(0, -55), GOAL_POSITION + Vector2(-38, 10), Color("171818"), 8.0)
	draw_line(GOAL_POSITION + Vector2(0, -55), GOAL_POSITION + Vector2(38, 10), Color("171818"), 8.0)
	draw_string(ThemeDB.fallback_font, GOAL_POSITION + Vector2(-88, 125), "RADIO RELAY", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("f1e8cf"))

	for spec in obstacle_specs:
		_draw_obstacle(spec)

func _draw_obstacle(spec:Dictionary) -> void:
	var pos:Vector2 = spec["position"]
	var radius:float = float(spec["radius"])
	var weight:String = str(spec["weight"])
	draw_circle(pos, radius + 5.0, Color("171818"))
	if weight == "light":
		draw_line(pos + Vector2(-radius, -radius * 0.4), pos + Vector2(radius, radius * 0.35), Color("d6b978"), 13.0)
		draw_line(pos + Vector2(-radius * 0.8, radius * 0.65), pos + Vector2(radius * 0.7, -radius * 0.5), Color("b66935"), 11.0)
	elif weight == "medium":
		draw_rect(Rect2(pos - Vector2(radius * 0.85, radius * 0.5), Vector2(radius * 1.7, radius)), Color("a2673f"))
		draw_line(pos + Vector2(-radius * 0.7, 0), pos + Vector2(radius * 0.7, 0), Color("f0c547"), 8.0)
	else:
		draw_colored_polygon(PackedVector2Array([
			pos + Vector2(-radius, radius * 0.45),
			pos + Vector2(-radius * 0.55, -radius * 0.78),
			pos + Vector2(radius * 0.45, -radius),
			pos + Vector2(radius, radius * 0.25),
			pos + Vector2(radius * 0.2, radius),
		]), Color("4a4842"))

func _distance_to_segment(point:Vector2, start:Vector2, finish:Vector2) -> float:
	var segment := finish - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)
	var t := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * t)
