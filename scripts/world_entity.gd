extends Node2D

const C = preload("res://scripts/game_constants.gd")

var marker_id := ""
var kind := ""
var chunk_key := ""
var weight := ""
var radius := 28.0
var alive := true
var pulse := 0.0

func setup(marker:Dictionary, world_position:Vector2, owner_chunk_key:String) -> void:
	marker_id = str(marker["id"])
	kind = str(marker["kind"])
	chunk_key = owner_chunk_key
	global_position = world_position
	if kind.begins_with("obstacle_"):
		weight = kind.trim_prefix("obstacle_")
		radius = 28.0 if weight == "light" else 38.0 if weight == "medium" else 52.0
	elif kind == "zombie":
		radius = 24.0
	else:
		radius = 24.0
	queue_redraw()

func _process(delta:float) -> void:
	pulse += delta
	queue_redraw()

func _draw() -> void:
	var flash := 0.08 * sin(pulse * 8.0)
	if kind == "zombie":
		draw_circle(Vector2.ZERO, radius, Color(0.16 + flash, 0.02, 0.025))
		draw_circle(Vector2(5, -5), radius * 0.38, Color(0.75, 0.04, 0.05))
	elif kind == "fuel":
		draw_rect(Rect2(Vector2(-18, -24), Vector2(36, 48)), Color(0.92, 0.12 + flash, 0.04))
		draw_rect(Rect2(Vector2(-8, -30), Vector2(16, 8)), Color(0.98, 0.85, 0.12))
	elif kind == "scrap":
		draw_polygon(PackedVector2Array([Vector2(-24, 12), Vector2(-8, -22), Vector2(22, -12), Vector2(12, 24)]), PackedColorArray([Color(0.76, 0.72, 0.62)]))
		draw_line(Vector2(-12, 10), Vector2(14, -10), Color(0.2, 0.19, 0.17), 4.0)
	elif kind == "repair":
		draw_circle(Vector2.ZERO, radius, Color(0.06, 0.66 + flash, 0.44))
		draw_rect(Rect2(Vector2(-5, -16), Vector2(10, 32)), Color.WHITE)
		draw_rect(Rect2(Vector2(-16, -5), Vector2(32, 10)), Color.WHITE)
	elif kind.begins_with("obstacle_"):
		var color := Color(0.42, 0.38, 0.32)
		if weight == "medium":
			color = Color(0.31, 0.28, 0.25)
		elif weight == "heavy":
			color = Color(0.12, 0.12, 0.12)
		draw_rect(Rect2(Vector2(-radius, -radius * 0.7), Vector2(radius * 2.0, radius * 1.4)), color)
		draw_line(Vector2(-radius, -radius * 0.7), Vector2(radius, radius * 0.7), Color(0.78, 0.67, 0.3), 5.0)
	else:
		draw_circle(Vector2.ZERO, radius, Color.MAGENTA)

func is_pickup() -> bool:
	return kind == "fuel" or kind == "scrap" or kind == "repair"

func is_obstacle() -> bool:
	return kind.begins_with("obstacle_")
