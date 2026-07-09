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
	var outline := Color(0.025, 0.02, 0.018)
	if kind == "zombie":
		draw_line(Vector2(-radius * 0.78, -radius * 0.24), Vector2(radius * 0.42, radius * 0.38), outline, 9.0)
		draw_line(Vector2(-radius * 0.58, radius * 0.6), Vector2(radius * 0.54, -radius * 0.46), outline, 9.0)
		draw_circle(Vector2.ZERO, radius + 4.0, outline)
		draw_circle(Vector2.ZERO, radius, Color(0.17 + flash, 0.025, 0.03))
		draw_circle(Vector2(7, -7), radius * 0.44 + 3.0, outline)
		draw_circle(Vector2(7, -7), radius * 0.44, Color(0.78, 0.045, 0.055))
		draw_circle(Vector2(13, -10), 2.4, Color(1.0, 0.85, 0.18))
	elif kind == "fuel":
		draw_rect(Rect2(Vector2(-22, -28), Vector2(44, 56)), outline)
		draw_rect(Rect2(Vector2(-18, -24), Vector2(36, 48)), Color(0.92, 0.12 + flash, 0.04))
		draw_rect(Rect2(Vector2(-8, -30), Vector2(16, 8)), Color(0.98, 0.85, 0.12))
	elif kind == "scrap":
		draw_polygon(PackedVector2Array([Vector2(-29, 14), Vector2(-10, -28), Vector2(28, -16), Vector2(15, 30)]), PackedColorArray([outline]))
		draw_polygon(PackedVector2Array([Vector2(-24, 12), Vector2(-8, -22), Vector2(22, -12), Vector2(12, 24)]), PackedColorArray([Color(0.76, 0.72, 0.62)]))
		draw_line(Vector2(-12, 10), Vector2(14, -10), Color(0.2, 0.19, 0.17), 4.0)
	elif kind == "repair":
		draw_circle(Vector2.ZERO, radius + 4.0, outline)
		draw_circle(Vector2.ZERO, radius, Color(0.06, 0.66 + flash, 0.44))
		draw_rect(Rect2(Vector2(-5, -16), Vector2(10, 32)), Color.WHITE)
		draw_rect(Rect2(Vector2(-16, -5), Vector2(32, 10)), Color.WHITE)
	elif kind.begins_with("obstacle_"):
		if weight == "light":
			var crate := Rect2(Vector2(-radius, -radius * 0.7), Vector2(radius * 2.0, radius * 1.4))
			draw_rect(Rect2(crate.position - Vector2(4, 4), crate.size + Vector2(8, 8)), outline)
			draw_rect(crate, Color(0.54, 0.42, 0.25))
			draw_line(Vector2(-radius, -radius * 0.7), Vector2(radius, radius * 0.7), Color(0.88, 0.72, 0.36), 4.0)
			draw_line(Vector2(-radius, radius * 0.7), Vector2(radius, -radius * 0.7), Color(0.22, 0.16, 0.1), 3.0)
		elif weight == "medium":
			var block := Rect2(Vector2(-radius, -radius * 0.62), Vector2(radius * 2.0, radius * 1.24))
			draw_rect(Rect2(block.position - Vector2(5, 5), block.size + Vector2(10, 10)), outline)
			draw_rect(block, Color(0.34, 0.33, 0.31))
			draw_rect(Rect2(Vector2(-radius * 0.75, -radius * 0.36), Vector2(radius * 1.5, radius * 0.72)), Color(0.24, 0.24, 0.23))
			draw_line(Vector2(-radius * 0.82, -radius * 0.52), Vector2(radius * 0.82, radius * 0.52), Color(0.92, 0.68, 0.18), 5.0)
		else:
			var heavy_outline := PackedVector2Array([
				Vector2(-radius - 5, -radius * 0.22),
				Vector2(-radius * 0.5, -radius * 0.78),
				Vector2(radius * 0.2, -radius * 0.86),
				Vector2(radius + 6, -radius * 0.38),
				Vector2(radius * 0.82, radius * 0.56),
				Vector2(radius * 0.08, radius * 0.88),
				Vector2(-radius * 0.72, radius * 0.58),
			])
			var heavy_body := PackedVector2Array([
				Vector2(-radius, -radius * 0.16),
				Vector2(-radius * 0.46, -radius * 0.66),
				Vector2(radius * 0.18, -radius * 0.72),
				Vector2(radius, -radius * 0.3),
				Vector2(radius * 0.72, radius * 0.44),
				Vector2(radius * 0.06, radius * 0.72),
				Vector2(-radius * 0.62, radius * 0.48),
			])
			draw_polygon(heavy_outline, PackedColorArray([outline]))
			draw_polygon(heavy_body, PackedColorArray([Color(0.13, 0.13, 0.125)]))
			draw_line(Vector2(-radius * 0.48, -radius * 0.34), Vector2(radius * 0.62, radius * 0.3), Color(0.9, 0.58, 0.12), 6.0)
			draw_line(Vector2(-radius * 0.12, radius * 0.42), Vector2(radius * 0.42, -radius * 0.48), Color(0.28, 0.27, 0.25), 5.0)
	else:
		draw_circle(Vector2.ZERO, radius, Color.MAGENTA)

func is_pickup() -> bool:
	return kind == "fuel" or kind == "scrap" or kind == "repair"

func is_obstacle() -> bool:
	return kind.begins_with("obstacle_")
