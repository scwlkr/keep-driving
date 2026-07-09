extends Node2D

const C = preload("res://scripts/game_constants.gd")
const WorldGenerator = preload("res://scripts/world_generator.gd")
const WorldEntity = preload("res://scripts/world_entity.gd")

var run_seed := 0
var render_chunks := true
var active_chunks := {}
var data_cache := {}
var attach_queue:Array[Vector2i] = []
var run_mutations := {}
var active_entities := {}
var tile_set:TileSet
var metrics := {}
var _drag_was_active := false

func _ready() -> void:
	tile_set = _make_tileset()
	_reset_metrics()

func start_run(seed:int) -> void:
	run_seed = seed
	for child in get_children():
		child.queue_free()
	active_chunks.clear()
	data_cache.clear()
	attach_queue.clear()
	active_entities.clear()
	run_mutations.clear()
	_reset_metrics()

func update_streaming(player_pos:Vector2) -> Dictionary:
	var start_usec := Time.get_ticks_usec()
	metrics["chunks_attached_this_frame"] = 0
	var center := WorldGenerator.world_to_chunk(player_pos)
	var desired_active := _coords_in_radius(center, C.ACTIVE_RADIUS)
	var desired_preload := _coords_in_radius(center, C.PRELOAD_RADIUS)

	for coord in desired_preload:
		var key := WorldGenerator.coord_key(coord)
		if not data_cache.has(key):
			data_cache[key] = WorldGenerator.generate_chunk(run_seed, coord)

	var desired_preload_keys := {}
	for coord in desired_preload:
		desired_preload_keys[WorldGenerator.coord_key(coord)] = true
	for key in data_cache.keys():
		if not desired_preload_keys.has(key):
			data_cache.erase(key)

	var desired_active_keys := {}
	for coord in desired_active:
		var key := WorldGenerator.coord_key(coord)
		desired_active_keys[key] = true
		if not active_chunks.has(key) and not attach_queue.has(coord):
			attach_queue.append(coord)

	for key in active_chunks.keys():
		if not desired_active_keys.has(key):
			_detach_chunk(key)

	if not attach_queue.is_empty():
		var coord:Vector2i = attach_queue.pop_front()
		var key := WorldGenerator.coord_key(coord)
		if data_cache.has(key) and not active_chunks.has(key):
			_attach_chunk(coord, data_cache[key])
			metrics["chunks_attached_this_frame"] = 1

	var current_key := WorldGenerator.coord_key(center)
	var drag_active := not active_chunks.has(current_key) or attach_queue.size() > 12
	if drag_active and not _drag_was_active:
		metrics["streaming_drag_activations"] += 1
	_drag_was_active = drag_active
	metrics["streaming_drag_active"] = drag_active
	metrics["last_stream_ms"] = float(Time.get_ticks_usec() - start_usec) / 1000.0
	metrics["active_chunk_count"] = active_chunks.size()
	metrics["preloaded_chunk_count"] = data_cache.size()
	metrics["attach_queue_length"] = attach_queue.size()
	metrics["entity_counts"] = entity_counts()
	return metrics

func update_entities(player_pos:Vector2, delta:float) -> void:
	for entity in active_entities.values():
		if not is_instance_valid(entity) or not entity.alive:
			continue
		if entity.kind == "zombie":
			var to_player:Vector2 = player_pos - entity.global_position
			var distance:float = to_player.length()
			if distance < 900.0 and distance > 1.0:
				var speed := 88.0 + float(pressure_tier(player_pos, 0.0)) * 22.0
				entity.global_position += to_player.normalized() * speed * delta

func sample_terrain(world_pos:Vector2) -> int:
	var coord := WorldGenerator.world_to_chunk(world_pos)
	var key := WorldGenerator.coord_key(coord)
	if not data_cache.has(key):
		data_cache[key] = WorldGenerator.generate_chunk(run_seed, coord)
	var data:Dictionary = data_cache[key]
	var local := WorldGenerator.world_to_local_tile(world_pos)
	var idx := local.y * C.CHUNK_TILES + local.x
	var terrain:PackedByteArray = data["terrain"]
	return int(terrain[idx])

func entities_overlapping(world_pos:Vector2, radius:float) -> Array:
	var hits := []
	for entity in active_entities.values():
		if not is_instance_valid(entity) or not entity.alive:
			continue
		if entity.global_position.distance_to(world_pos) <= radius + entity.radius:
			hits.append(entity)
	return hits

func mutate_marker(marker_id:String, state:String) -> void:
	run_mutations[marker_id] = state
	if active_entities.has(marker_id):
		var entity = active_entities[marker_id]
		if is_instance_valid(entity):
			entity.alive = false
			entity.queue_free()
		active_entities.erase(marker_id)

func pressure_tier(player_pos:Vector2, elapsed_seconds:float) -> int:
	var miles := player_pos.length() / C.PIXELS_PER_MILE
	return C.pressure_tier(miles, elapsed_seconds)

func entity_counts() -> Dictionary:
	var counts := {"zombies": 0, "obstacles": 0, "pickups": 0, "effects": 0, "total": 0}
	for entity in active_entities.values():
		if not is_instance_valid(entity) or not entity.alive:
			continue
		counts["total"] += 1
		if entity.kind == "zombie":
			counts["zombies"] += 1
		elif entity.is_obstacle():
			counts["obstacles"] += 1
		elif entity.is_pickup():
			counts["pickups"] += 1
	return counts

func marker_count_scanned() -> int:
	var total := 0
	for data in data_cache.values():
		total += data["spawn_markers"].size()
	return total

func _coords_in_radius(center:Vector2i, radius:int) -> Array[Vector2i]:
	var coords:Array[Vector2i] = []
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			coords.append(Vector2i(x, y))
	return coords

func _attach_chunk(coord:Vector2i, data:Dictionary) -> void:
	var key := WorldGenerator.coord_key(coord)
	var chunk := Node2D.new()
	chunk.name = "Chunk_%s" % key
	chunk.position = Vector2(coord.x * C.CHUNK_WORLD_SIZE, coord.y * C.CHUNK_WORLD_SIZE)
	if render_chunks:
		var layer := TileMapLayer.new()
		layer.name = "Terrain"
		layer.tile_set = tile_set
		var terrain:PackedByteArray = data["terrain"]
		for y in range(C.CHUNK_TILES):
			for x in range(C.CHUNK_TILES):
				var terrain_id := int(terrain[y * C.CHUNK_TILES + x])
				layer.set_cell(Vector2i(x, y), 0, Vector2i(terrain_id, 0), 0)
		chunk.add_child(layer)
	add_child(chunk)
	active_chunks[key] = chunk
	_spawn_entities_for_chunk(data, key)

func _detach_chunk(key:String) -> void:
	if active_chunks.has(key):
		var chunk = active_chunks[key]
		if is_instance_valid(chunk):
			chunk.queue_free()
		active_chunks.erase(key)
	for marker_id in active_entities.keys():
		var entity = active_entities[marker_id]
		if not is_instance_valid(entity) or entity.chunk_key == key:
			if is_instance_valid(entity):
				entity.queue_free()
			active_entities.erase(marker_id)

func _spawn_entities_for_chunk(data:Dictionary, key:String) -> void:
	var counts := entity_counts()
	for marker in data["spawn_markers"]:
		var marker_id := str(marker["id"])
		if run_mutations.has(marker_id):
			continue
		if counts["total"] >= C.TOTAL_ENTITY_CAP:
			metrics["skipped_spawn_count"] += 1
			continue
		var kind := str(marker["kind"])
		if kind == "zombie" and counts["zombies"] >= C.ZOMBIE_CAP:
			metrics["skipped_spawn_count"] += 1
			continue
		if kind.begins_with("obstacle_") and counts["obstacles"] >= C.OBSTACLE_CAP:
			metrics["skipped_spawn_count"] += 1
			continue
		if (kind == "fuel" or kind == "scrap" or kind == "repair") and counts["pickups"] >= C.PICKUP_CAP:
			metrics["skipped_spawn_count"] += 1
			continue
		var entity := WorldEntity.new()
		var coord:Vector2i = data["coord"]
		entity.setup(marker, WorldGenerator.local_tile_to_world(coord, marker["tile"]), key)
		add_child(entity)
		active_entities[marker_id] = entity
		counts = entity_counts()

func _make_tileset() -> TileSet:
	var image := Image.create(C.TILE_SIZE * C.TERRAIN_COLORS.size(), C.TILE_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(C.TERRAIN_COLORS.size()):
		image.fill_rect(Rect2i(i * C.TILE_SIZE, 0, C.TILE_SIZE, C.TILE_SIZE), C.TERRAIN_COLORS[i])
		var stripe := Color(1, 1, 1, 0.05)
		image.fill_rect(Rect2i(i * C.TILE_SIZE, 0, C.TILE_SIZE, 3), stripe)
	var texture := ImageTexture.create_from_image(image)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = texture
	atlas.texture_region_size = Vector2i(C.TILE_SIZE, C.TILE_SIZE)
	for i in range(C.TERRAIN_COLORS.size()):
		atlas.create_tile(Vector2i(i, 0))
	var set := TileSet.new()
	set.tile_size = Vector2i(C.TILE_SIZE, C.TILE_SIZE)
	set.add_source(atlas, 0)
	return set

func _reset_metrics() -> void:
	metrics = {
		"last_stream_ms": 0.0,
		"active_chunk_count": 0,
		"preloaded_chunk_count": 0,
		"attach_queue_length": 0,
		"chunks_attached_this_frame": 0,
		"skipped_spawn_count": 0,
		"streaming_drag_activations": 0,
		"streaming_drag_active": false,
		"entity_counts": {"zombies": 0, "obstacles": 0, "pickups": 0, "effects": 0, "total": 0},
	}
