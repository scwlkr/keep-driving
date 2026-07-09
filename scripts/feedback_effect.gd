extends Node2D

var kind := "dust"
var lifetime := 0.45
var age := 0.0
var base_radius := 18.0
var color := Color(1, 1, 1, 0.35)

func setup(effect_kind:String, world_position:Vector2, effect_color:Color, radius:float = 18.0, duration:float = 0.45) -> void:
	kind = effect_kind
	global_position = world_position
	color = effect_color
	base_radius = radius
	lifetime = duration
	age = 0.0
	queue_redraw()

func _process(delta:float) -> void:
	age += delta
	if age >= lifetime:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	var t := clampf(age / lifetime, 0.0, 1.0)
	var alpha := color.a * (1.0 - t)
	var radius := base_radius * (1.0 + t * 1.7)
	var draw_color := Color(color.r, color.g, color.b, alpha)
	if kind == "skid":
		draw_line(Vector2(-radius, -5), Vector2(radius, 5), draw_color, 5.0)
		draw_line(Vector2(-radius, 9), Vector2(radius, 17), draw_color, 4.0)
	elif kind == "debris":
		for i in range(6):
			var angle := float(i) * TAU / 6.0 + t
			draw_circle(Vector2.RIGHT.rotated(angle) * radius * 0.7, 4.0, draw_color)
	elif kind == "pickup":
		draw_circle(Vector2.ZERO, radius, draw_color)
		draw_circle(Vector2.ZERO, radius * 0.45, Color(1.0, 1.0, 1.0, alpha))
	else:
		draw_circle(Vector2.ZERO, radius, draw_color)
