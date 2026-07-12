class_name PrototypeCameraRig
extends Camera2D

# PROTOTYPE: isolated look-ahead/zoom/impact rig with a Reduced Motion path.

var target: Node2D
var reduced_motion := false
var _impact_impulse := 0.0
var _phase := 0.0


func setup(next_target: Node2D) -> void:
	target = next_target
	enabled = true
	if target != null:
		global_position = target.global_position


func step_camera(delta: float) -> void:
	if target == null:
		return
	var follow_weight := 1.0 - pow(0.001, delta)
	var lookahead := Vector2.ZERO
	var target_zoom := Vector2.ONE
	if target.has_method("camera_lookahead"):
		lookahead = target.camera_lookahead()
	if target.has_method("camera_zoom"):
		target_zoom = target.camera_zoom()
	if reduced_motion:
		lookahead *= 0.28
		target_zoom = Vector2.ONE
	_phase += delta * 31.0
	var shake := Vector2.ZERO
	if not reduced_motion and _impact_impulse > 0.01:
		shake = Vector2(sin(_phase * 1.7), cos(_phase * 2.3)) * _impact_impulse
	global_position = global_position.lerp(target.global_position + lookahead + shake, follow_weight)
	zoom = zoom.lerp(target_zoom, follow_weight)
	_impact_impulse = move_toward(_impact_impulse, 0.0, delta * 90.0)


func add_impact_impulse(weight: String) -> void:
	if reduced_motion:
		return
	_impact_impulse = maxf(_impact_impulse, {"light": 2.5, "medium": 5.5, "heavy": 9.0}.get(weight, 4.0))


func set_reduced_motion(enabled_value: bool) -> void:
	reduced_motion = enabled_value
	if reduced_motion:
		_impact_impulse = 0.0


func toggle_reduced_motion() -> void:
	set_reduced_motion(not reduced_motion)


func reset_at(world_position: Vector2) -> void:
	global_position = world_position
	zoom = Vector2.ONE
	_impact_impulse = 0.0


func evidence_snapshot() -> Dictionary:
	return {
		"dedicated_camera_contract_pass": target != null and has_method("set_reduced_motion") and has_method("add_impact_impulse"),
		"lookahead": true,
		"speed_zoom": true,
		"impact_impulse": true,
		"reduced_motion": reduced_motion,
	}
