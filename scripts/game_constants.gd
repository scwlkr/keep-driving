extends RefCounted

const TILE_SIZE := 64
const CHUNK_TILES := 32
const CHUNK_CELL_COUNT := CHUNK_TILES * CHUNK_TILES
const CHUNK_WORLD_SIZE := TILE_SIZE * CHUNK_TILES
const ACTIVE_RADIUS := 2
const PRELOAD_RADIUS := 3

const TERRAIN_ROAD := 0
const TERRAIN_DIRT_PATH := 1
const TERRAIN_GRASS := 2
const TERRAIN_ROUGH := 3
const TERRAIN_SHALLOW := 4
const TERRAIN_WATER := 5
const TERRAIN_BARRIER := 6

const TERRAIN_NAMES := [
	"road",
	"dirt_path",
	"grass",
	"rough_offroad",
	"shallow",
	"water",
	"barrier",
]

const TERRAIN_SPEED := [1.0, 0.86, 0.68, 0.46, 0.34, 0.12, 0.08]
const TERRAIN_GRIP := [1.0, 0.82, 0.62, 0.44, 0.34, 0.18, 0.12]
const TERRAIN_COLORS := [
	Color(0.09, 0.095, 0.095),
	Color(0.52, 0.34, 0.17),
	Color(0.18, 0.43, 0.21),
	Color(0.31, 0.36, 0.27),
	Color(0.22, 0.51, 0.59),
	Color(0.05, 0.28, 0.62),
	Color(0.16, 0.15, 0.14),
]

const MAX_FUEL := 100.0
const FUEL_DRAIN_PER_SECOND := 0.33
const SPUTTER_GRACE_SECONDS := 3.0
const FUEL_PICKUP_AMOUNT := 35.0
const MAX_VEHICLE_DAMAGE := 100.0
const REPAIR_PICKUP_AMOUNT := 35.0

const ZOMBIE_CONTACT_DAMAGE := 5.0
const LIGHT_OBSTACLE_DAMAGE := 5.0
const MEDIUM_OBSTACLE_DAMAGE := 15.0
const HEAVY_OBSTACLE_DAMAGE := 40.0
const WATER_OR_CLIFF_DAMAGE := 100.0
const SCRAP_PICKUP_AMOUNT := 5
const PIXELS_PER_MILE := 9000.0

const ZOMBIE_CAP := 120
const OBSTACLE_CAP := 180
const PICKUP_CAP := 60
const EFFECT_CAP := 40
const TOTAL_ENTITY_CAP := 400
const MARKERS_PER_CHUNK := 32
const SAFE_ORIGIN_RADIUS := 1450.0

const FUEL_TANK_COSTS := [20, 50, 100]
const FUEL_TANK_BONUS := [20.0, 40.0, 60.0]
const ARMOR_COSTS := [20, 50, 100]
const ARMOR_BONUS := [20.0, 40.0, 60.0]
const ENGINE_COSTS := [25, 60, 120]
const ENGINE_BONUS := [0.05, 0.10, 0.15]

static func terrain_speed(terrain_id:int) -> float:
	var idx := clampi(terrain_id, 0, TERRAIN_SPEED.size() - 1)
	return TERRAIN_SPEED[idx]

static func terrain_grip(terrain_id:int) -> float:
	var idx := clampi(terrain_id, 0, TERRAIN_GRIP.size() - 1)
	return TERRAIN_GRIP[idx]

static func terrain_name(terrain_id:int) -> String:
	var idx := clampi(terrain_id, 0, TERRAIN_NAMES.size() - 1)
	return TERRAIN_NAMES[idx]

static func obstacle_damage(weight:String) -> float:
	match weight:
		"light":
			return LIGHT_OBSTACLE_DAMAGE
		"medium":
			return MEDIUM_OBSTACLE_DAMAGE
		"heavy":
			return HEAVY_OBSTACLE_DAMAGE
		_:
			return LIGHT_OBSTACLE_DAMAGE

static func max_fuel_for(upgrades:Dictionary) -> float:
	var level := int(upgrades.get("fuel_tank", 0))
	if level <= 0:
		return MAX_FUEL
	return MAX_FUEL + FUEL_TANK_BONUS[clampi(level - 1, 0, FUEL_TANK_BONUS.size() - 1)]

static func max_damage_for(upgrades:Dictionary) -> float:
	var level := int(upgrades.get("armor", 0))
	if level <= 0:
		return MAX_VEHICLE_DAMAGE
	return MAX_VEHICLE_DAMAGE + ARMOR_BONUS[clampi(level - 1, 0, ARMOR_BONUS.size() - 1)]

static func engine_multiplier_for(upgrades:Dictionary) -> float:
	var level := int(upgrades.get("engine", 0))
	if level <= 0:
		return 1.0
	return 1.0 + ENGINE_BONUS[clampi(level - 1, 0, ENGINE_BONUS.size() - 1)]

static func upgrade_cost(upgrade:String, level:int) -> int:
	var idx := clampi(level, 0, 2)
	match upgrade:
		"fuel_tank":
			return FUEL_TANK_COSTS[idx]
		"armor":
			return ARMOR_COSTS[idx]
		"engine":
			return ENGINE_COSTS[idx]
		_:
			return 999999

static func pressure_tier(miles:float, elapsed_seconds:float) -> int:
	if miles >= 3.0 or elapsed_seconds >= 300.0:
		return 3
	if miles >= 1.5 or elapsed_seconds >= 180.0:
		return 2
	if miles >= 0.5 or elapsed_seconds >= 60.0:
		return 1
	return 0
