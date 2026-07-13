extends SceneTree

const SCENE_PATH := "res://prototypes/hybrid_region/hybrid_region_scene.tscn"
const STEP_COUNT := 3600
const STEP_SECONDS := 1.0 / 60.0
const WORLD_STEP_P95_LIMIT_MS := 4.0

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var assembly_started_usec := Time.get_ticks_usec()
	var packed: PackedScene = load(SCENE_PATH)
	_expect(packed != null, "Hybrid Proof Region scene must load for smoke")
	if packed == null:
		_finish([], 0.0, 0, 0.0)
		return
	var scene := packed.instantiate()
	scene.set("live_input_enabled", false)
	root.add_child(scene)
	await process_frame
	var assembly_ms := float(Time.get_ticks_usec() - assembly_started_usec) / 1000.0
	var contract: Dictionary = scene.playable_contract()
	_expect(bool(contract.get("bake_ok", false)), "Hybrid Proof Region must configure before smoke")
	var baseline_node_count := get_node_count()
	var peak_node_count := baseline_node_count
	var peak_distance := 0.0
	var step_samples_ms: Array[float] = []
	for step_index in STEP_COUNT:
		var cycle := step_index % 1200
		var intent := {
			"throttle": 1.0,
			"steer": sin(float(cycle) / 120.0) * 0.42,
			"handbrake": 0.0,
			"source": "smoke",
		}
		var step_started_usec := Time.get_ticks_usec()
		var result: Dictionary = scene.step_with_intent(intent, STEP_SECONDS)
		step_samples_ms.append(float(Time.get_ticks_usec() - step_started_usec) / 1000.0)
		_expect(bool(result.get("ok", false)), "every public scene step must succeed")
		var vehicle_position: Vector2 = result.get("telemetry", {}).get("position", Vector2.ZERO)
		peak_distance = maxf(peak_distance, vehicle_position.distance_to(contract.get("start_position", Vector2.ZERO)))
		peak_node_count = maxi(peak_node_count, get_node_count())
		if cycle == 1199:
			scene.reset_to_start()
	_expect(peak_distance >= 300.0, "smoke intent must materially move the vehicle")
	_expect(peak_node_count == baseline_node_count, "static scene stepping must not grow the node graph")
	step_samples_ms.sort()
	var p95_step_ms := step_samples_ms[ceili(float(step_samples_ms.size()) * 0.95) - 1]
	_expect(p95_step_ms <= WORLD_STEP_P95_LIMIT_MS, "headless public scene step p95 must stay within the provisional 4 ms world-work budget")
	scene.queue_free()
	await process_frame
	_finish(step_samples_ms, assembly_ms, peak_node_count - baseline_node_count, peak_distance)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _finish(samples: Array[float], assembly_ms: float, node_growth: int, peak_distance: float) -> void:
	var p95_step_ms := 0.0
	if not samples.is_empty():
		p95_step_ms = samples[ceili(float(samples.size()) * 0.95) - 1]
	if failures.is_empty():
		print(
			"HYBRID_REGION_SCENE_SMOKE steps=%d assembly_ms=%.3f p95_step_ms=%.3f node_growth=%d peak_distance=%.1f pass=true"
			% [STEP_COUNT, assembly_ms, p95_step_ms, node_growth, peak_distance]
		)
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	quit(1)
