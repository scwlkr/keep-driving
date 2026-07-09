extends RefCounted

const C = preload("res://scripts/game_constants.gd")

static func coord_key(coord:Vector2i) -> String:
	return "%d,%d" % [coord.x, coord.y]

static func world_to_chunk(pos:Vector2) -> Vector2i:
	return Vector2i(int(floor(pos.x / C.CHUNK_WORLD_SIZE)), int(floor(pos.y / C.CHUNK_WORLD_SIZE)))

static func world_to_local_tile(pos:Vector2) -> Vector2i:
	var tx := posmod(int(floor(pos.x / C.TILE_SIZE)), C.CHUNK_TILES)
	var ty := posmod(int(floor(pos.y / C.TILE_SIZE)), C.CHUNK_TILES)
	return Vector2i(tx, ty)

static func local_tile_to_world(coord:Vector2i, tile:Vector2i) -> Vector2:
	return Vector2(
		coord.x * C.CHUNK_WORLD_SIZE + tile.x * C.TILE_SIZE + C.TILE_SIZE * 0.5,
		coord.y * C.CHUNK_WORLD_SIZE + tile.y * C.TILE_SIZE + C.TILE_SIZE * 0.5
	)

static func generate_chunk(run_seed:int, coord:Vector2i) -> Dictionary:
	var terrain := PackedByteArray()
	terrain.resize(C.CHUNK_CELL_COUNT)
	var route_mask := PackedByteArray()
	route_mask.resize(C.CHUNK_CELL_COUNT)
	var barrier_mask := PackedByteArray()
	barrier_mask.resize(C.CHUNK_CELL_COUNT)
	for y in range(C.CHUNK_TILES):
		for x in range(C.CHUNK_TILES):
			var global_tile := Vector2i(coord.x * C.CHUNK_TILES + x, coord.y * C.CHUNK_TILES + y)
			var terrain_id := _base_terrain(run_seed, global_tile)
			var idx := _idx(x, y)
			terrain[idx] = terrain_id
			barrier_mask[idx] = 1 if terrain_id == C.TERRAIN_WATER or terrain_id == C.TERRAIN_BARRIER else 0

	var exits := _route_exits(run_seed, coord)
	var center := Vector2i(
		15 + int(_rand01(run_seed, coord.x, coord.y, 501) * 4.0),
		15 + int(_rand01(run_seed, coord.x, coord.y, 502) * 4.0)
	)
	_raster_line(terrain, route_mask, barrier_mask, center, Vector2i(0, int(exits["west"])), C.TERRAIN_ROAD, 2)
	_raster_line(terrain, route_mask, barrier_mask, center, Vector2i(C.CHUNK_TILES - 1, int(exits["east"])), C.TERRAIN_ROAD, 2)
	_raster_line(terrain, route_mask, barrier_mask, center, Vector2i(int(exits["north"]), 0), C.TERRAIN_DIRT_PATH, 1)
	_raster_line(terrain, route_mask, barrier_mask, center, Vector2i(int(exits["south"]), C.CHUNK_TILES - 1), C.TERRAIN_DIRT_PATH, 1)
	_raster_line(terrain, route_mask, barrier_mask, Vector2i(0, C.CHUNK_TILES - 6), Vector2i(C.CHUNK_TILES - 1, 5), C.TERRAIN_ROUGH, 1)

	var markers := _spawn_markers(run_seed, coord, terrain, route_mask)
	var data := {
		"coord": coord,
		"run_seed": run_seed,
		"terrain": terrain,
		"route_mask": route_mask,
		"barrier_mask": barrier_mask,
		"route_exits": exits,
		"spawn_markers": markers,
		"proof_hash": 0,
	}
	data["proof_hash"] = proof_hash(data)
	return data

static func proof_hash(data:Dictionary) -> int:
	var h := _mix_int(int(data["run_seed"]) ^ _coord_hash(data["coord"], 1319))
	var terrain:PackedByteArray = data["terrain"]
	var route_mask:PackedByteArray = data["route_mask"]
	var barrier_mask:PackedByteArray = data["barrier_mask"]
	for i in range(terrain.size()):
		h = _hash_combine(h, int(terrain[i]) + int(route_mask[i]) * 11 + int(barrier_mask[i]) * 23)
	var exits:Dictionary = data["route_exits"]
	for key in ["north", "east", "south", "west"]:
		h = _hash_combine(h, int(exits[key]))
	for marker in data["spawn_markers"]:
		h = _hash_combine(h, _stable_string_hash(str(marker["id"])))
	return h

static func validate_adjacent_continuity(run_seed:int, coord:Vector2i) -> Dictionary:
	var here := generate_chunk(run_seed, coord)
	var east := generate_chunk(run_seed, coord + Vector2i.RIGHT)
	var west := generate_chunk(run_seed, coord + Vector2i.LEFT)
	var north := generate_chunk(run_seed, coord + Vector2i.UP)
	var south := generate_chunk(run_seed, coord + Vector2i.DOWN)
	var failures := []
	if int(here["route_exits"]["east"]) != int(east["route_exits"]["west"]):
		failures.append("east/west route exit mismatch")
	if int(here["route_exits"]["west"]) != int(west["route_exits"]["east"]):
		failures.append("west/east route exit mismatch")
	if int(here["route_exits"]["north"]) != int(north["route_exits"]["south"]):
		failures.append("north/south route exit mismatch")
	if int(here["route_exits"]["south"]) != int(south["route_exits"]["north"]):
		failures.append("south/north route exit mismatch")
	return {"ok": failures.is_empty(), "failures": failures}

static func _base_terrain(run_seed:int, global_tile:Vector2i) -> int:
	var seed_offset := float(abs(run_seed % 997)) * 0.0031
	var water_field := sin(float(global_tile.x) * 0.071 + seed_offset) + cos(float(global_tile.y) * 0.057 - seed_offset * 0.7)
	var rough_noise := _rand01(run_seed, int(floor(float(global_tile.x) / 3.0)), int(floor(float(global_tile.y) / 3.0)), 71)
	var detail_noise := _rand01(run_seed, global_tile.x, global_tile.y, 89)
	if water_field > 1.34:
		return C.TERRAIN_WATER
	if rough_noise > 0.93 and global_tile.length() > 10:
		return C.TERRAIN_BARRIER
	if rough_noise > 0.72:
		return C.TERRAIN_ROUGH
	if detail_noise > 0.55:
		return C.TERRAIN_GRASS
	return C.TERRAIN_GRASS

static func _route_exits(run_seed:int, coord:Vector2i) -> Dictionary:
	return {
		"west": _edge_anchor(run_seed, coord.x, coord.y, 10),
		"east": _edge_anchor(run_seed, coord.x + 1, coord.y, 10),
		"north": _edge_anchor(run_seed, coord.x, coord.y, 20),
		"south": _edge_anchor(run_seed, coord.x, coord.y + 1, 20),
	}

static func _edge_anchor(run_seed:int, a:int, b:int, salt:int) -> int:
	return 5 + int(_rand01(run_seed, a, b, salt) * 22.0)

static func _raster_line(terrain:PackedByteArray, route_mask:PackedByteArray, barrier_mask:PackedByteArray, a:Vector2i, b:Vector2i, terrain_id:int, radius:int) -> void:
	var delta := b - a
	var steps:int = maxi(abs(delta.x), abs(delta.y))
	if steps <= 0:
		_set_disc(terrain, route_mask, barrier_mask, a, terrain_id, radius)
		return
	for i in range(steps + 1):
		var t := float(i) / float(steps)
		var p := Vector2i(roundi(lerpf(float(a.x), float(b.x), t)), roundi(lerpf(float(a.y), float(b.y), t)))
		_set_disc(terrain, route_mask, barrier_mask, p, terrain_id, radius)

static func _set_disc(terrain:PackedByteArray, route_mask:PackedByteArray, barrier_mask:PackedByteArray, center:Vector2i, terrain_id:int, radius:int) -> void:
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			if x < 0 or y < 0 or x >= C.CHUNK_TILES or y >= C.CHUNK_TILES:
				continue
			if Vector2(x - center.x, y - center.y).length() > float(radius) + 0.45:
				continue
			var idx := _idx(x, y)
			if terrain[idx] == C.TERRAIN_WATER:
				terrain[idx] = C.TERRAIN_SHALLOW
			else:
				terrain[idx] = terrain_id
			route_mask[idx] = 1
			barrier_mask[idx] = 0

static func _spawn_markers(run_seed:int, coord:Vector2i, terrain:PackedByteArray, route_mask:PackedByteArray) -> Array:
	var markers := []
	var chunk_center := Vector2(coord.x * C.CHUNK_WORLD_SIZE + C.CHUNK_WORLD_SIZE * 0.5, coord.y * C.CHUNK_WORLD_SIZE + C.CHUNK_WORLD_SIZE * 0.5)
	var safe_origin := chunk_center.length() < C.SAFE_ORIGIN_RADIUS
	var distance_miles := chunk_center.length() / C.PIXELS_PER_MILE
	var danger := clampf(distance_miles / 3.0, 0.0, 1.0)
	var route_tiles := _candidate_tiles(terrain, route_mask, true)
	var offroad_tiles := _candidate_tiles(terrain, route_mask, false)
	if not safe_origin:
		_add_marker(markers, run_seed, coord, "fuel", _pick_tile(route_tiles, run_seed, coord, 301), danger, "risk")
		if _rand01(run_seed, coord.x, coord.y, 302) > 0.38:
			_add_marker(markers, run_seed, coord, "scrap", _pick_tile(offroad_tiles, run_seed, coord, 303), danger, "salvage")
		if _rand01(run_seed, coord.x, coord.y, 304) > 0.85:
			_add_marker(markers, run_seed, coord, "repair", _pick_tile(offroad_tiles, run_seed, coord, 305), danger, "rare")
		var obstacle_count := 2 + int(danger * 4.0)
		for i in range(obstacle_count):
			var weight := "light"
			if i % 5 == 3:
				weight = "heavy"
			elif i % 3 == 1:
				weight = "medium"
			_add_marker(markers, run_seed, coord, "obstacle_%s" % weight, _pick_tile(route_tiles if i % 2 == 0 else offroad_tiles, run_seed, coord, 410 + i), danger, "roadblock")
		var zombie_count := 1 + int(danger * 5.0)
		for i in range(zombie_count):
			_add_marker(markers, run_seed, coord, "zombie", _pick_tile(offroad_tiles, run_seed, coord, 510 + i), danger, "swarm")
	return markers

static func _candidate_tiles(terrain:PackedByteArray, route_mask:PackedByteArray, route:bool) -> Array:
	var out := []
	for y in range(3, C.CHUNK_TILES - 3):
		for x in range(3, C.CHUNK_TILES - 3):
			var idx := _idx(x, y)
			if terrain[idx] == C.TERRAIN_WATER or terrain[idx] == C.TERRAIN_BARRIER:
				continue
			if route and route_mask[idx] == 1:
				out.append(Vector2i(x, y))
			elif not route and route_mask[idx] == 0:
				out.append(Vector2i(x, y))
	if out.is_empty():
		out.append(Vector2i(C.CHUNK_TILES / 2, C.CHUNK_TILES / 2))
	return out

static func _pick_tile(candidates:Array, run_seed:int, coord:Vector2i, salt:int) -> Vector2i:
	var idx := int(_rand01(run_seed, coord.x, coord.y, salt) * float(candidates.size())) % candidates.size()
	return candidates[idx]

static func _add_marker(markers:Array, run_seed:int, coord:Vector2i, kind:String, tile:Vector2i, danger:float, route_bias:String) -> void:
	if markers.size() >= C.MARKERS_PER_CHUNK:
		return
	markers.append({
		"id": "%d:%d:%d:%s:%d:%d" % [run_seed, coord.x, coord.y, kind, tile.x, tile.y],
		"kind": kind,
		"tile": tile,
		"danger": danger,
		"route_bias": route_bias,
	})

static func _idx(x:int, y:int) -> int:
	return y * C.CHUNK_TILES + x

static func _rand01(run_seed:int, x:int, y:int, salt:int) -> float:
	var n := _mix_int(run_seed + x * 374761393 + y * 668265263 + salt * 1442695041)
	return float(n & 0x7fffffff) / float(0x7fffffff)

static func _coord_hash(coord:Vector2i, salt:int) -> int:
	return _mix_int(coord.x * 73856093 ^ coord.y * 19349663 ^ salt)

static func _mix_int(value:int) -> int:
	var x := value
	x = ((x >> 16) ^ x) * 0x45d9f3b
	x = ((x >> 16) ^ x) * 0x45d9f3b
	x = (x >> 16) ^ x
	return x & 0x7fffffff

static func _hash_combine(hash_value:int, value:int) -> int:
	return _mix_int(hash_value ^ (value + 0x9e3779b9 + (hash_value << 6) + (hash_value >> 2)))

static func _stable_string_hash(text:String) -> int:
	var h := 2166136261
	for i in range(text.length()):
		h = _hash_combine(h, text.unicode_at(i))
	return h
