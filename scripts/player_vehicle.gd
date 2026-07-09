extends Node2D

const C = preload("res://scripts/game_constants.gd")

var velocity := Vector2.ZERO
var engine_multiplier := 1.0
var last_controls := {"steer": 0.0, "gas": false, "brake": false, "handbrake": false}
var handbrake_active := false
var impact_shake := 0.0
var dust_intensity := 0.0

const ACCELERATION := 520.0
const BRAKE_FORCE := 680.0
const REVERSE_ACCELERATION := 320.0
const BASE_MAX_SPEED := 760.0
const TURN_RATE := 2.55

func reset_vehicle(pos:Vector2 = Vector2.ZERO) -> void:
	global_position = pos
	rotation = 0.0
	velocity = Vector2.ZERO
	impact_shake = 0.0
	dust_intensity = 0.0

func apply_controls(controls:Dictionary, terrain_id:int, delta:float) -> Dictionary:
	last_controls = controls.duplicate()
	var steer := clampf(float(controls.get("steer", 0.0)), -1.0, 1.0)
	var gas := bool(controls.get("gas", false))
	var brake := bool(controls.get("brake", false))
	var handbrake := bool(controls.get("handbrake", false))
	handbrake_active = handbrake
	var terrain_speed := C.terrain_speed(terrain_id)
	var terrain_grip := C.terrain_grip(terrain_id)
	var max_speed := BASE_MAX_SPEED * terrain_speed * engine_multiplier
	var forward := Vector2.RIGHT.rotated(rotation)
	var forward_speed := velocity.dot(forward)
	if gas:
		velocity += forward * ACCELERATION * terrain_speed * delta
	if brake:
		if forward_speed > 55.0:
			velocity -= forward * BRAKE_FORCE * delta
		else:
			velocity -= forward * REVERSE_ACCELERATION * terrain_speed * delta
	var speed_factor := clampf(velocity.length() / 240.0, 0.18, 1.4)
	var turn_boost := 1.72 if handbrake else 1.0
	rotation += steer * TURN_RATE * turn_boost * speed_factor * delta
	forward = Vector2.RIGHT.rotated(rotation)
	var lateral := velocity - forward * velocity.dot(forward)
	var grip := terrain_grip * (0.85 if handbrake else 2.8)
	velocity -= lateral * clampf(grip * delta, 0.0, 1.0)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	global_position += velocity * delta
	impact_shake = maxf(0.0, impact_shake - delta * 2.5)
	dust_intensity = clampf(velocity.length() / BASE_MAX_SPEED, 0.0, 1.0) * (1.4 if handbrake else 1.0) * (1.0 - terrain_grip * 0.45)
	queue_redraw()
	return {
		"speed": velocity.length(),
		"max_speed": max_speed,
		"terrain_speed": terrain_speed,
		"terrain_grip": terrain_grip,
		"handbrake": handbrake,
		"dust_intensity": dust_intensity,
	}

func apply_impact(push:Vector2, rotate_amount:float) -> void:
	velocity += push
	rotation += rotate_amount
	impact_shake = minf(1.0, impact_shake + push.length() / 520.0)
	queue_redraw()

func camera_lookahead() -> Vector2:
	if velocity.length() < 1.0:
		return Vector2.ZERO
	return velocity.normalized() * clampf(velocity.length() * 0.44, 0.0, 260.0)

func camera_zoom() -> Vector2:
	var z := 1.0 - clampf(velocity.length() / 1400.0, 0.0, 0.22)
	return Vector2(z, z)

func _draw() -> void:
	var body := PackedVector2Array([
		Vector2(48, 0),
		Vector2(20, -24),
		Vector2(-42, -20),
		Vector2(-48, 0),
		Vector2(-42, 20),
		Vector2(20, 24),
	])
	draw_polygon(body, PackedColorArray([Color(0.92, 0.76, 0.18)]))
	draw_line(Vector2(30, -16), Vector2(30, 16), Color(0.12, 0.1, 0.08), 8.0)
	draw_line(Vector2(-24, -22), Vector2(-24, 22), Color(0.04, 0.04, 0.04), 8.0)
	if dust_intensity > 0.05:
		var dust_color := Color(0.75, 0.67, 0.49, 0.24 * dust_intensity)
		draw_circle(Vector2(-56, -16), 18.0 + 12.0 * dust_intensity, dust_color)
		draw_circle(Vector2(-56, 16), 18.0 + 12.0 * dust_intensity, dust_color)
