extends SceneTree

const C = preload("res://scripts/game_constants.gd")
const WorldGenerator = preload("res://scripts/world_generator.gd")
const WorldRuntime = preload("res://scripts/world_runtime.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var world := WorldRuntime.new()
	world.render_chunks = false
	root.add_child(world)
	world.start_run(424242)
	var frame_times := []
	var stream_times := []
	var player_pos := Vector2.ZERO
	var velocity := Vector2(980.0, 430.0)
	var frames := 60 * 180
	var max_active := 0
	var max_preload := 0
	var max_attach := 0
	var max_attach_queue := 0
	var streaming_drag_frames := 0
	var blank_terrain_risk_frames := 0
	var proof_start := Time.get_ticks_usec()
	for i in range(frames):
		var frame_start := Time.get_ticks_usec()
		player_pos += velocity * (1.0 / 60.0)
		if i % 900 == 0:
			velocity = velocity.rotated(0.72)
		var metrics := world.update_streaming(player_pos)
		var current_key := WorldGenerator.coord_key(WorldGenerator.world_to_chunk(player_pos))
		frame_times.append(float(Time.get_ticks_usec() - frame_start) / 1000.0)
		stream_times.append(float(metrics["last_stream_ms"]))
		max_active = maxi(max_active, int(metrics["active_chunk_count"]))
		max_preload = maxi(max_preload, int(metrics["preloaded_chunk_count"]))
		max_attach = maxi(max_attach, int(metrics["chunks_attached_this_frame"]))
		max_attach_queue = maxi(max_attach_queue, int(metrics["attach_queue_length"]))
		if bool(metrics["streaming_drag_active"]):
			streaming_drag_frames += 1
		if not world.active_chunks.has(current_key):
			blank_terrain_risk_frames += 1
	var p95_frame := _percentile(frame_times, 0.95)
	var p95_stream := _percentile(stream_times, 0.95)
	var elapsed_seconds := maxf(float(Time.get_ticks_usec() - proof_start) / 1000000.0, 0.001)
	var fps := float(frames) / elapsed_seconds
	var counts := world.entity_counts()
	var active_budget := (C.ACTIVE_RADIUS * 2 + 1) * (C.ACTIVE_RADIUS * 2 + 1)
	var preload_budget := (C.PRELOAD_RADIUS * 2 + 1) * (C.PRELOAD_RADIUS * 2 + 1)
	var ok := fps >= 60.0 and p95_frame <= 16.7 and p95_stream <= 4.0 and max_active <= active_budget and max_preload <= preload_budget and max_attach <= 1 and max_attach_queue <= active_budget - 1 and blank_terrain_risk_frames == 0
	print("WORLD_PERF_PROOF frames=%d fps=%.1f p95_frame_ms=%.3f p95_stream_ms=%.3f active_chunks=%d preloaded_chunks=%d attach_queue_max=%d chunks_attached_frame_max=%d zombies=%d obstacles=%d pickups=%d effects=%d markers_scanned=%d skipped_spawns=%d pool_total=%d pool_usage=%d/%d streaming_drag_activations=%d streaming_drag_frames=%d blank_terrain_risk_frames=%d pass=%s" % [
		frames,
		fps,
		p95_frame,
		p95_stream,
		max_active,
		max_preload,
		max_attach_queue,
		max_attach,
		int(counts["zombies"]),
		int(counts["obstacles"]),
		int(counts["pickups"]),
		int(counts["effects"]),
		world.marker_count_scanned(),
		int(world.metrics["skipped_spawn_count"]),
		int(counts["total"]),
		int(counts["total"]),
		C.TOTAL_ENTITY_CAP,
		int(world.metrics["streaming_drag_activations"]),
		streaming_drag_frames,
		blank_terrain_risk_frames,
		str(ok),
	])
	world.queue_free()
	quit(0 if ok else 1)

func _percentile(values:Array, pct:float) -> float:
	values.sort()
	if values.is_empty():
		return 0.0
	var idx := clampi(int(floor(float(values.size() - 1) * pct)), 0, values.size() - 1)
	return float(values[idx])
