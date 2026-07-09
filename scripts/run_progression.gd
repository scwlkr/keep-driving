extends RefCounted

const C = preload("res://scripts/game_constants.gd")

var driver_profile := {}
var run_state := {}

func _init(initial_profile:Dictionary = {}) -> void:
	driver_profile = initial_profile.duplicate(true)
	run_state = _empty_run_state()

func set_driver_profile(profile:Dictionary) -> void:
	driver_profile = profile.duplicate(true)

func driver_profile_snapshot() -> Dictionary:
	return driver_profile.duplicate(true)

func run_state_snapshot() -> Dictionary:
	return run_state.duplicate(true)

func start_run(seed:int) -> Dictionary:
	run_state = {
		"active": true,
		"run_seed": seed,
		"fuel": max_fuel(),
		"vehicle_damage_remaining": max_damage(),
		"miles_driven": 0.0,
		"run_scrap": 0,
		"elapsed_seconds": 0.0,
		"sputter_seconds": 0.0,
		"end_reason": "",
		"scrap_earned": 0,
	}
	return run_state_snapshot()

func advance(delta:float, miles_from_origin:float) -> Dictionary:
	if not bool(run_state.get("active", false)):
		return run_state_snapshot()
	run_state["elapsed_seconds"] = float(run_state["elapsed_seconds"]) + delta
	run_state["miles_driven"] = maxf(float(run_state["miles_driven"]), miles_from_origin)
	run_state["fuel"] = maxf(0.0, float(run_state["fuel"]) - C.FUEL_DRAIN_PER_SECOND * delta)
	if float(run_state["fuel"]) <= 0.0:
		run_state["sputter_seconds"] = float(run_state["sputter_seconds"]) + delta
		if float(run_state["sputter_seconds"]) >= C.SPUTTER_GRACE_SECONDS:
			finish_run("Fuel")
	else:
		run_state["sputter_seconds"] = 0.0
	return run_state_snapshot()

func apply_pickup(kind:String) -> Dictionary:
	if not bool(run_state.get("active", false)):
		return run_state_snapshot()
	if kind == "fuel":
		run_state["fuel"] = minf(max_fuel(), float(run_state.get("fuel", 0.0)) + C.FUEL_PICKUP_AMOUNT)
	elif kind == "repair":
		run_state["vehicle_damage_remaining"] = minf(max_damage(), float(run_state.get("vehicle_damage_remaining", 0.0)) + C.REPAIR_PICKUP_AMOUNT)
	elif kind == "scrap":
		run_state["run_scrap"] = int(run_state.get("run_scrap", 0)) + C.SCRAP_PICKUP_AMOUNT
	return run_state_snapshot()

func apply_damage(amount:float, source:String) -> Dictionary:
	if not bool(run_state.get("active", false)):
		return run_state_snapshot()
	run_state["vehicle_damage_remaining"] = maxf(0.0, float(run_state.get("vehicle_damage_remaining", 0.0)) - amount)
	if amount > 0.0 and float(run_state["vehicle_damage_remaining"]) <= 0.0:
		finish_run("Vehicle Damage: %s" % source)
	return run_state_snapshot()

func finish_run(reason:String) -> Dictionary:
	if not bool(run_state.get("active", false)):
		return run_state_snapshot()
	run_state["active"] = false
	run_state["end_reason"] = reason
	var bonus := int(floor(float(run_state.get("miles_driven", 0.0)) / 0.25))
	var earned := int(run_state.get("run_scrap", 0)) + bonus
	run_state["scrap_earned"] = earned
	driver_profile["scrap"] = int(driver_profile.get("scrap", 0)) + earned
	driver_profile["runs"] = int(driver_profile.get("runs", 0)) + 1
	driver_profile["best_miles"] = maxf(float(driver_profile.get("best_miles", 0.0)), float(run_state.get("miles_driven", 0.0)))
	return run_state_snapshot()

func buy_upgrade(upgrade:String) -> bool:
	var fact := garage_fact(upgrade)
	if bool(fact["maxed"]) or not bool(fact["affordable"]):
		return false
	driver_profile["scrap"] = int(driver_profile.get("scrap", 0)) - int(fact["cost"])
	var upgrades:Dictionary = driver_profile["upgrades"]
	upgrades[upgrade] = int(fact["level"]) + 1
	return true

func garage_fact(upgrade:String) -> Dictionary:
	var upgrades:Dictionary = driver_profile["upgrades"]
	var level := int(upgrades.get(upgrade, 0))
	var maxed := level >= 3
	var cost := 0 if maxed else C.upgrade_cost(upgrade, level)
	var scrap := int(driver_profile.get("scrap", 0))
	return {
		"upgrade": upgrade,
		"level": level,
		"max_level": 3,
		"maxed": maxed,
		"cost": cost,
		"affordable": not maxed and scrap >= cost,
		"missing_scrap": 0 if maxed else maxi(0, cost - scrap),
		"effect": _upgrade_effect(upgrade, mini(level + 1, 3)),
	}

func max_fuel() -> float:
	return C.max_fuel_for(driver_profile["upgrades"])

func max_damage() -> float:
	return C.max_damage_for(driver_profile["upgrades"])

func engine_multiplier() -> float:
	return C.engine_multiplier_for(driver_profile["upgrades"])

func is_active() -> bool:
	return bool(run_state.get("active", false))

func _empty_run_state() -> Dictionary:
	return {
		"active": false,
		"run_seed": 0,
		"fuel": 0.0,
		"vehicle_damage_remaining": 0.0,
		"miles_driven": 0.0,
		"run_scrap": 0,
		"elapsed_seconds": 0.0,
		"sputter_seconds": 0.0,
		"end_reason": "",
		"scrap_earned": 0,
	}

func _upgrade_effect(upgrade:String, level:int) -> Dictionary:
	var idx := clampi(level - 1, 0, 2)
	match upgrade:
		"fuel_tank":
			return {"stat": "max_fuel", "amount": C.FUEL_TANK_BONUS[idx], "percent": false}
		"armor":
			return {"stat": "max_vehicle_damage", "amount": C.ARMOR_BONUS[idx], "percent": false}
		"engine":
			return {"stat": "speed", "amount": C.ENGINE_BONUS[idx], "percent": true}
		_:
			return {"stat": "unknown", "amount": 0.0, "percent": false}
