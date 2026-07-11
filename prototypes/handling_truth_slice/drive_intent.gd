class_name DriveIntent
extends RefCounted

# PROTOTYPE: one normalized input shape for keyboard, controller, and replayed intent.

const STICK_DEADZONE := 0.16
const TRIGGER_DEADZONE := 0.05

static var _simulated_intent: Dictionary = {}


static func set_simulated_intent(intent: Dictionary) -> void:
	_simulated_intent = {} if intent.is_empty() else _normalize(intent, "simulated")


static func sample(injected: Variant = null) -> Dictionary:
	if injected != null:
		var injected_intent: Dictionary = injected if injected is Dictionary else {}
		return _normalize(injected_intent, "injected")
	if not _simulated_intent.is_empty():
		return _simulated_intent.duplicate(true)

	var steer := _action_strength(&"drive_right") - _action_strength(&"drive_left")
	var throttle := _action_strength(&"drive_gas")
	var brake := _action_strength(&"drive_brake")
	var handbrake := _action_strength(&"drive_handbrake")
	var recovery_pressed := _action_strength(&"drive_recover") > 0.5
	var source := "keyboard"
	var device := -1

	var joypads := Input.get_connected_joypads()
	if not joypads.is_empty():
		device = int(joypads[0])
		var joy_steer := _deadzone_axis(Input.get_joy_axis(device, JOY_AXIS_LEFT_X), STICK_DEADZONE)
		var joy_throttle := _trigger_value(Input.get_joy_axis(device, JOY_AXIS_TRIGGER_RIGHT), TRIGGER_DEADZONE)
		var joy_brake := _trigger_value(Input.get_joy_axis(device, JOY_AXIS_TRIGGER_LEFT), TRIGGER_DEADZONE)
		var joy_handbrake := 1.0 if Input.is_joy_button_pressed(device, JOY_BUTTON_A) else 0.0
		var joy_recovery := Input.is_joy_button_pressed(device, JOY_BUTTON_Y)
		if absf(joy_steer) > absf(steer):
			steer = joy_steer
		throttle = maxf(throttle, joy_throttle)
		brake = maxf(brake, joy_brake)
		handbrake = maxf(handbrake, joy_handbrake)
		recovery_pressed = recovery_pressed or joy_recovery
		if absf(joy_steer) > 0.0 or joy_throttle > 0.0 or joy_brake > 0.0 or joy_handbrake > 0.0 or joy_recovery:
			source = "controller"

	return _normalize({
		"steer": steer,
		"throttle": throttle,
		"brake": brake,
		"handbrake": handbrake,
		"recovery_pressed": recovery_pressed,
		"source": source,
		"device": device,
	}, source)


static func _normalize(raw: Dictionary, fallback_source: String) -> Dictionary:
	return {
		"steer": clampf(float(raw.get("steer", 0.0)), -1.0, 1.0),
		"throttle": _unit_value(raw.get("throttle", raw.get("gas", 0.0))),
		"brake": _unit_value(raw.get("brake", 0.0)),
		"handbrake": _unit_value(raw.get("handbrake", 0.0)),
		"recovery_pressed": bool(raw.get("recovery_pressed", false)),
		"source": String(raw.get("source", fallback_source)),
		"device": int(raw.get("device", -1)),
	}


static func _unit_value(value: Variant) -> float:
	if typeof(value) == TYPE_BOOL:
		return 1.0 if bool(value) else 0.0
	return clampf(float(value), 0.0, 1.0)


static func _action_strength(action: StringName) -> float:
	return Input.get_action_strength(action) if InputMap.has_action(action) else 0.0


static func _deadzone_axis(value: float, deadzone: float) -> float:
	var magnitude := absf(value)
	if magnitude <= deadzone:
		return 0.0
	var direction := 1.0 if value > 0.0 else -1.0
	return direction * clampf((magnitude - deadzone) / (1.0 - deadzone), 0.0, 1.0)


static func _trigger_value(value: float, deadzone: float) -> float:
	var unit_value := (value + 1.0) * 0.5
	if unit_value <= deadzone:
		return 0.0
	return clampf((unit_value - deadzone) / (1.0 - deadzone), 0.0, 1.0)
