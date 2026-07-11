class_name PrototypeVehicle
extends CharacterBody2D

# PROTOTYPE: can fixed-step Arcade-Real handling make surfaces, slip, and impacts legible?

const DriveIntentSource = preload("res://prototypes/handling_truth_slice/drive_intent.gd")

const DEFAULT_SURFACE := {
	"name": "asphalt",
	"speed_multiplier": 1.0,
	"grip": 1.0,
	"rolling_drag": 0.0,
}

const EMPTY_COLLISION := {
	"hit": false,
	"collider_id": 0,
	"weight": "none",
	"impact_speed": 0.0,
	"damage": 0.0,
}

const TUNE_PRESETS := {
	"balanced": {
		"max_speed": 1.0,
		"acceleration": 1.0,
		"turn": 1.0,
		"grip": 1.0,
		"impact_resistance": 1.0,
	},
	"scout": {
		"max_speed": 1.08,
		"acceleration": 1.12,
		"turn": 1.12,
		"grip": 0.92,
		"impact_resistance": 0.78,
	},
	"hauler": {
		"max_speed": 0.90,
		"acceleration": 0.82,
		"turn": 0.82,
		"grip": 1.15,
		"impact_resistance": 1.35,
	},
}

const BASE_MAX_SPEED := 720.0
const ACCELERATION := 560.0
const BRAKE_FORCE := 900.0
const REVERSE_ACCELERATION := 360.0
const REVERSE_SPEED_RATIO := 0.38
const REVERSE_ENTRY_SPEED := 10.0
const BASE_ROLLING_DRAG := 26.0
const HANDBRAKE_DRAG := 42.0
const OVERSPEED_RESPONSE := 2.2
const TURN_RATE := 2.45
const FULL_STEER_SPEED := 115.0
const STEER_FADE_SPEED := 330.0
const HIGH_SPEED_STEER := 0.42
const REVERSE_STEER_THRESHOLD := 8.0
const LATERAL_GRIP_RATE := 5.8
const HANDBRAKE_GRIP_SCALE := 0.16
const HANDBRAKE_TURN_BOOST := 1.42
const IMPACT_COOLDOWN := 0.28
const MIN_DAMAGE_SPEED := 35.0
const STUCK_SPEED := 9.0
const STUCK_DELAY := 1.25
const RECOVERY_HOLD := 0.45

var self_surface: Dictionary = DEFAULT_SURFACE.duplicate(true)
var last_intent: Dictionary = {}
var last_collision: Dictionary = EMPTY_COLLISION.duplicate(true)
var last_telemetry: Dictionary = {}
var tune_name := "balanced"
var tune: Dictionary = TUNE_PRESETS["balanced"].duplicate(true)

var speed := 0.0
var forward_speed := 0.0
var lateral_speed := 0.0
var max_speed := BASE_MAX_SPEED
var steer_authority := 0.0
var surface_name := "asphalt"
var surface_grip := 1.0
var surface_rolling_drag := 0.0
var handbrake_active := false
var integrity := 100.0
var impact_transition := false
var impact_count := 0
var collision_cooldown_remaining := 0.0
var contact_active := false
var stuck := false
var stuck_seconds := 0.0
var recovery_hold_seconds := 0.0
var recovered_this_step := false
var last_safe_position := Vector2.ZERO

var _contact_id := 0
var _last_safe_rotation := 0.0
var _has_safe_position := false


func _ready() -> void:
	_ensure_collision_shape()
	_ensure_safe_position()
	_update_motion_facts()
	last_telemetry = _build_telemetry()
	queue_redraw()


func _physics_process(delta: float) -> void:
	step_vehicle(DriveIntentSource.sample(), self_surface, delta)


func set_simulated_intent(intent: Dictionary) -> void:
	DriveIntentSource.set_simulated_intent(intent)


func step_vehicle(intent: Dictionary, surface: Dictionary, delta: float) -> Dictionary:
	_ensure_safe_position()
	var step_delta := maxf(delta, 0.0)
	impact_transition = false
	recovered_this_step = false
	collision_cooldown_remaining = maxf(0.0, collision_cooldown_remaining - step_delta)
	last_intent = DriveIntentSource.sample(intent)
	_read_surface(surface)

	var forward := Vector2.RIGHT.rotated(rotation)
	var starting_speed := velocity.length()
	var starting_forward_speed := velocity.dot(forward)
	handbrake_active = float(last_intent["handbrake"]) > 0.01

	var drag := BASE_ROLLING_DRAG + surface_rolling_drag
	drag += HANDBRAKE_DRAG * float(last_intent["handbrake"])
	velocity = velocity.move_toward(Vector2.ZERO, drag * step_delta)

	var throttle := float(last_intent["throttle"])
	var brake := float(last_intent["brake"])
	var current_forward_speed := velocity.dot(forward)
	if throttle > 0.0 and current_forward_speed < max_speed:
		var throttle_curve := clampf(1.0 - maxf(current_forward_speed, 0.0) / max_speed, 0.0, 1.0)
		velocity += forward * ACCELERATION * float(tune["acceleration"]) * throttle * throttle_curve * step_delta

	current_forward_speed = velocity.dot(forward)
	if brake > 0.0:
		if current_forward_speed > REVERSE_ENTRY_SPEED:
			velocity -= forward * minf(current_forward_speed, BRAKE_FORCE * brake * step_delta)
		else:
			var reverse_limit := max_speed * REVERSE_SPEED_RATIO
			var reverse_curve := clampf(1.0 - maxf(-current_forward_speed, 0.0) / reverse_limit, 0.0, 1.0)
			velocity -= forward * REVERSE_ACCELERATION * float(tune["acceleration"]) * brake * reverse_curve * step_delta

	steer_authority = _steering_authority(starting_speed)
	var steering_direction := -1.0 if starting_forward_speed < -REVERSE_STEER_THRESHOLD else 1.0
	var turn_boost := lerpf(1.0, HANDBRAKE_TURN_BOOST, float(last_intent["handbrake"]))
	rotation += float(last_intent["steer"]) * steering_direction * TURN_RATE * float(tune["turn"]) * steer_authority * turn_boost * step_delta

	forward = Vector2.RIGHT.rotated(rotation)
	var lateral_velocity := velocity - forward * velocity.dot(forward)
	var grip_scale := lerpf(1.0, HANDBRAKE_GRIP_SCALE, float(last_intent["handbrake"]))
	var grip_response := 1.0 - exp(-LATERAL_GRIP_RATE * surface_grip * float(tune["grip"]) * grip_scale * step_delta)
	velocity -= lateral_velocity * clampf(grip_response, 0.0, 1.0)
	_apply_progressive_speed_limit(step_delta)

	var collision: KinematicCollision2D = move_and_collide(velocity * step_delta)
	var collided := collision != null
	if collided:
		_handle_collision(collision)
	else:
		contact_active = false
		_contact_id = 0

	_update_recovery(last_intent, collided, step_delta)
	_update_motion_facts()
	last_telemetry = _build_telemetry()
	queue_redraw()
	return last_telemetry.duplicate(true)


func telemetry_snapshot() -> Dictionary:
	return _build_telemetry().duplicate(true)


func set_tune(next_tune: String) -> void:
	var normalized := next_tune.to_lower()
	if not TUNE_PRESETS.has(normalized):
		return
	tune_name = normalized
	tune = TUNE_PRESETS[normalized].duplicate(true)
	queue_redraw()


func camera_lookahead() -> Vector2:
	if speed < 5.0:
		return Vector2.ZERO
	return velocity.normalized() * clampf(speed * 0.38, 0.0, 240.0)


func camera_zoom() -> Vector2:
	var amount := 1.0 - clampf(speed / BASE_MAX_SPEED, 0.0, 1.25) * 0.18
	return Vector2(amount, amount)


func recover_to(safe_position: Vector2) -> void:
	global_position = safe_position
	rotation = _last_safe_rotation
	velocity = Vector2.ZERO
	last_safe_position = safe_position
	stuck = false
	stuck_seconds = 0.0
	recovery_hold_seconds = 0.0
	recovered_this_step = true
	contact_active = false
	_contact_id = 0
	_update_motion_facts()
	last_telemetry = _build_telemetry()
	queue_redraw()


func reset_prototype(spawn_position: Vector2) -> void:
	global_position = spawn_position
	rotation = 0.0
	velocity = Vector2.ZERO
	self_surface = DEFAULT_SURFACE.duplicate(true)
	last_intent = DriveIntentSource.sample({})
	last_collision = EMPTY_COLLISION.duplicate(true)
	max_speed = BASE_MAX_SPEED * float(tune["max_speed"])
	steer_authority = 0.0
	surface_name = String(DEFAULT_SURFACE["name"])
	surface_grip = float(DEFAULT_SURFACE["grip"])
	surface_rolling_drag = float(DEFAULT_SURFACE["rolling_drag"])
	handbrake_active = false
	integrity = 100.0
	impact_transition = false
	impact_count = 0
	collision_cooldown_remaining = 0.0
	contact_active = false
	_contact_id = 0
	stuck = false
	stuck_seconds = 0.0
	recovery_hold_seconds = 0.0
	recovered_this_step = false
	last_safe_position = spawn_position
	_last_safe_rotation = 0.0
	_has_safe_position = true
	_update_motion_facts()
	last_telemetry = _build_telemetry()
	queue_redraw()


func _read_surface(surface: Dictionary) -> void:
	surface_name = String(surface.get("name", DEFAULT_SURFACE["name"]))
	var speed_multiplier := clampf(float(surface.get("speed_multiplier", 1.0)), 0.05, 2.0)
	surface_grip = clampf(float(surface.get("grip", 1.0)), 0.0, 2.0)
	surface_rolling_drag = maxf(0.0, float(surface.get("rolling_drag", 0.0)))
	max_speed = BASE_MAX_SPEED * speed_multiplier * float(tune["max_speed"])


func _steering_authority(motion_speed: float) -> float:
	if motion_speed < 1.0:
		return 0.0
	var low_speed_authority := clampf(motion_speed / FULL_STEER_SPEED, 0.0, 1.0)
	if motion_speed <= STEER_FADE_SPEED:
		return low_speed_authority
	var fade_range := maxf(max_speed * 1.15 - STEER_FADE_SPEED, 1.0)
	var fade := clampf((motion_speed - STEER_FADE_SPEED) / fade_range, 0.0, 1.0)
	return lerpf(1.0, HIGH_SPEED_STEER, fade)


func _apply_progressive_speed_limit(step_delta: float) -> void:
	var current_speed := velocity.length()
	if current_speed <= max_speed or current_speed <= 0.0:
		return
	var excess := current_speed - max_speed
	var remaining_excess := excess * exp(-OVERSPEED_RESPONSE * step_delta)
	velocity = velocity.normalized() * (max_speed + remaining_excess)


func _handle_collision(collision: KinematicCollision2D) -> void:
	var collider: Object = collision.get_collider()
	var collider_id := collider.get_instance_id() if is_instance_valid(collider) else 0
	var weight := "medium"
	var base_damage := 0.0
	if is_instance_valid(collider):
		weight = String(collider.get_meta(&"weight", "medium")).to_lower()
		base_damage = float(collider.get_meta(&"damage", 0.0))
	if weight not in ["light", "medium", "heavy"]:
		weight = "medium"

	var normal := collision.get_normal()
	var impact_speed := maxf(0.0, -velocity.dot(normal))
	var is_new_contact := not contact_active or collider_id != _contact_id
	contact_active = true
	_contact_id = collider_id
	if is_new_contact and collision_cooldown_remaining <= 0.0:
		impact_transition = true
		impact_count += 1
		collision_cooldown_remaining = IMPACT_COOLDOWN
		var weight_damage: float = {"light": 0.35, "medium": 1.0, "heavy": 1.5}[weight]
		var impact_ratio := clampf((impact_speed - MIN_DAMAGE_SPEED) / (BASE_MAX_SPEED * 0.55), 0.0, 2.0)
		var applied_damage := base_damage * weight_damage * impact_ratio / maxf(float(tune["impact_resistance"]), 0.01)
		integrity = maxf(0.0, integrity - applied_damage)
		last_collision = {
			"hit": true,
			"collider_id": collider_id,
			"weight": weight,
			"impact_speed": impact_speed,
			"base_damage": base_damage,
			"damage": applied_damage,
			"normal": normal,
			"position": collision.get_position(),
			"surface": surface_name,
			"transition_index": impact_count,
		}

	var tangent_keep: float = {"light": 0.82, "medium": 0.46, "heavy": 0.12}[weight]
	var bounce: float = {"light": 0.12, "medium": 0.07, "heavy": 0.02}[weight]
	velocity = velocity.slide(normal) * tangent_keep + normal * impact_speed * bounce


func _update_recovery(intent: Dictionary, collided: bool, step_delta: float) -> void:
	var drive_demand := maxf(float(intent["throttle"]), float(intent["brake"]))
	if drive_demand > 0.4 and velocity.length() < STUCK_SPEED:
		stuck_seconds += step_delta
	else:
		stuck_seconds = maxf(0.0, stuck_seconds - step_delta * 2.0)
	stuck = stuck_seconds >= STUCK_DELAY

	if bool(intent["recovery_pressed"]):
		recovery_hold_seconds += step_delta
	else:
		recovery_hold_seconds = 0.0
	if recovery_hold_seconds >= RECOVERY_HOLD and (stuck or velocity.length() < STUCK_SPEED):
		recover_to(last_safe_position)
		return

	if not collided and velocity.length() > 28.0 and global_position.distance_to(last_safe_position) > 72.0:
		last_safe_position = global_position
		_last_safe_rotation = rotation


func _ensure_safe_position() -> void:
	if _has_safe_position:
		return
	last_safe_position = global_position
	_last_safe_rotation = rotation
	_has_safe_position = true


func _ensure_collision_shape() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			return
	var shape_node := CollisionShape2D.new()
	shape_node.name = "PrototypeCollisionShape"
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(52.0, 26.0)
	shape_node.shape = rectangle
	add_child(shape_node)


func _update_motion_facts() -> void:
	speed = velocity.length()
	var forward := Vector2.RIGHT.rotated(rotation)
	forward_speed = velocity.dot(forward)
	lateral_speed = (velocity - forward * forward_speed).length()


func _build_telemetry() -> Dictionary:
	return {
		"intent": last_intent.duplicate(true),
		"tune": tune_name,
		"tune_facts": tune.duplicate(true),
		"position": global_position,
		"velocity": velocity,
		"speed": speed,
		"forward_speed": forward_speed,
		"lateral_speed": lateral_speed,
		"max_speed": max_speed,
		"steer_authority": steer_authority,
		"surface": surface_name,
		"surface_grip": surface_grip,
		"surface_rolling_drag": surface_rolling_drag,
		"handbrake": handbrake_active,
		"integrity": integrity,
		"impact_transition": impact_transition,
		"impact_count": impact_count,
		"impact_serial": impact_count,
		"last_impact_weight": String(last_collision.get("weight", "none")),
		"contact_active": contact_active,
		"collision_cooldown": collision_cooldown_remaining,
		"last_collision": last_collision.duplicate(true),
		"stuck": stuck,
		"stuck_seconds": stuck_seconds,
		"recovered": recovered_this_step,
		"last_safe_position": last_safe_position,
		"camera_lookahead": camera_lookahead(),
		"camera_zoom": camera_zoom(),
	}


func _draw() -> void:
	var outline := PackedVector2Array([
		Vector2(31.0, 0.0), Vector2(20.0, -15.0), Vector2(-23.0, -14.0),
		Vector2(-31.0, 0.0), Vector2(-23.0, 14.0), Vector2(20.0, 15.0),
	])
	var body := PackedVector2Array([
		Vector2(27.0, 0.0), Vector2(16.0, -11.0), Vector2(-20.0, -10.0),
		Vector2(-25.0, 0.0), Vector2(-20.0, 10.0), Vector2(16.0, 11.0),
	])
	draw_polygon(outline, PackedColorArray([Color(0.04, 0.045, 0.05)]))
	var body_color := Color(0.92, 0.55, 0.14)
	if tune_name == "scout":
		body_color = Color("4fb4c3")
	elif tune_name == "hauler":
		body_color = Color("b9903c")
	draw_polygon(body, PackedColorArray([body_color]))
	draw_rect(Rect2(-8.0, -9.0, 18.0, 18.0), Color(0.08, 0.13, 0.16), true)
	draw_line(Vector2(-15.0, -14.0), Vector2(14.0, -14.0), Color(0.02, 0.02, 0.025), 5.0)
	draw_line(Vector2(-15.0, 14.0), Vector2(14.0, 14.0), Color(0.02, 0.02, 0.025), 5.0)
	draw_circle(Vector2(25.0, -6.5), 2.5, Color(1.0, 0.95, 0.58))
	draw_circle(Vector2(25.0, 6.5), 2.5, Color(1.0, 0.95, 0.58))
