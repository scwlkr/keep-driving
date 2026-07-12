extends Node2D

# PROTOTYPE — authored first-road presentation and collision substrate only.

const START_POSITION := Vector2(-720.0, 0.0)
const GOAL_POSITION := Vector2(1080.0, 0.0)
const DIRT_JOIN_POSITION := Vector2(920.0, -420.0)
const MUD_JOIN_POSITION := Vector2(920.0, 430.0)
const PRIMARY_ROAD_CORE_HALF_WIDTH := 72.0
const GOAL_MERGE_RADIUS := 132.0
const SLALOM_MARKER_POSITIONS := [
	Vector2(-518.0, -55.0),
	Vector2(-418.0, 55.0),
	Vector2(-318.0, -55.0),
	Vector2(-218.0, 55.0),
	Vector2(-118.0, -55.0),
]
const BRAKING_REVERSE_BAY_POSITION := START_POSITION
const STUCK_RECOVERY_FIXTURE_POSITION := Vector2(-542.0, 298.0)
const STUCK_RECOVERY_ANCHOR := Vector2(-542.0, 190.0)
const WIDE_HANDBRAKE_TURN_POSITION := Vector2(80.0, -90.0)
const ROUTE_REWARD_SPECS := [
	{"id": "dirt_reserve", "position": Vector2(680.0, -345.0), "label": "Dirt reserve", "fuel": 8.0},
	{"id": "mud_reserve", "position": Vector2(690.0, 350.0), "label": "Mud reserve", "fuel": 14.0},
]

const FIRST_ROAD: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/lowlands_first_road.svg")
const RELAY: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/radio_relay.svg")
const SAFEHOUSE: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/safehouse.svg")
const THREAT: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/threat.svg")
const FUEL: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/fuel.svg")
const REPAIR: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/repair.svg")
const CARGO: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/cargo.svg")
const REWARD: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/reward.svg")
const OBJECTIVE: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/objective.svg")
const BARRIER_LIGHT: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/barrier_light.svg")
const BARRIER_MEDIUM: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/barrier_medium.svg")
const BARRIER_HEAVY: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/barrier_heavy.svg")

const RECOGNITION_CATEGORIES := [
	"hero_car",
	"primary_road",
	"dirt_route",
	"mud_route",
	"landmark",
	"safehouse",
	"objective",
	"threat",
	"fuel",
	"repair",
	"cargo",
	"reward",
	"light_obstacle",
	"medium_obstacle",
	"heavy_obstacle",
]

var obstacle_specs := [
	{"position": Vector2(210, -28), "weight": "light", "damage": 6.0, "radius": 26.0, "breakable": true},
	{"position": Vector2(560, -255), "weight": "medium", "damage": 16.0, "radius": 42.0, "breakable": false},
	{"position": Vector2(650, 300), "weight": "heavy", "damage": 34.0, "radius": 58.0, "breakable": false},
]


func _ready() -> void:
	_add_world_art()
	for spec in obstacle_specs:
		_add_obstacle(spec)
	_add_handling_lab_fixtures()


func surface_at(world_position: Vector2) -> Dictionary:
	if absf(world_position.y) <= PRIMARY_ROAD_CORE_HALF_WIDTH or world_position.distance_to(GOAL_POSITION) <= GOAL_MERGE_RADIUS:
		return _road_surface()
	if (
		_distance_to_segment(world_position, Vector2(-40, 15), MUD_JOIN_POSITION) <= 112.0
		or _distance_to_segment(world_position, MUD_JOIN_POSITION, GOAL_POSITION) <= 112.0
	):
		return {
			"name": "mud",
			"speed_multiplier": 0.48,
			"grip": 0.42,
			"rolling_drag": 96.0,
		}
	if (
		_distance_to_segment(world_position, Vector2(-40, -18), DIRT_JOIN_POSITION) <= 102.0
		or _distance_to_segment(world_position, DIRT_JOIN_POSITION, GOAL_POSITION) <= 102.0
	):
		return {
			"name": "dirt",
			"speed_multiplier": 0.76,
			"grip": 0.68,
			"rolling_drag": 54.0,
		}
	if absf(world_position.y) <= 126.0:
		return _road_surface()
	return {
		"name": "grass",
		"speed_multiplier": 0.58,
		"grip": 0.56,
		"rolling_drag": 76.0,
	}


func presentation_evidence() -> Dictionary:
	var resources := {
		"first_road": FIRST_ROAD,
		"relay": RELAY,
		"safehouse": SAFEHOUSE,
		"threat": THREAT,
		"fuel": FUEL,
		"repair": REPAIR,
		"cargo": CARGO,
		"reward": REWARD,
		"objective": OBJECTIVE,
		"barrier_light": BARRIER_LIGHT,
		"barrier_medium": BARRIER_MEDIUM,
		"barrier_heavy": BARRIER_HEAVY,
	}
	var paths := {}
	var resources_valid := true
	for key in resources:
		var texture: Texture2D = resources[key]
		var path := texture.resource_path if texture != null else ""
		paths[key] = path
		resources_valid = resources_valid and path.begins_with("res://") and FileAccess.file_exists(path)
	return {
		"authored_asset_contract_pass": resources_valid and resources.size() == 12,
		"source_kind": "project_authored_svg",
		"runtime_generated_geometry": false,
		"resource_paths": paths,
		"recognition_categories": RECOGNITION_CATEGORIES.duplicate(),
	}


func route_choice_evidence() -> Dictionary:
	return {
		"connected_choice_contract_pass": (
			DIRT_JOIN_POSITION.distance_to(GOAL_POSITION) > 1.0
			and MUD_JOIN_POSITION.distance_to(GOAL_POSITION) > 1.0
			and surface_at(Vector2(500.0, 0.0))["name"] == "road"
			and surface_at(GOAL_POSITION)["name"] == "road"
			and surface_at(DIRT_JOIN_POSITION.lerp(GOAL_POSITION, 0.5))["name"] == "dirt"
			and surface_at(MUD_JOIN_POSITION.lerp(GOAL_POSITION, 0.5))["name"] == "mud"
		),
		"endpoint": GOAL_POSITION,
		"dirt_join": DIRT_JOIN_POSITION,
		"mud_join": MUD_JOIN_POSITION,
		"reward_route_count": ROUTE_REWARD_SPECS.size(),
		"route_rewards": ROUTE_REWARD_SPECS.duplicate(true),
	}


func route_reward_at(world_position: Vector2) -> Dictionary:
	for spec in ROUTE_REWARD_SPECS:
		if world_position.distance_to(spec["position"]) <= 72.0:
			return spec.duplicate(true)
	return {}


func handling_lab_evidence() -> Dictionary:
	var stuck_fixture_walls := 0
	var recovery_anchors_valid := true
	for child in get_children():
		if child is StaticBody2D and String(child.get_meta(&"lab_fixture", "")) == "stuck_recovery":
			stuck_fixture_walls += 1
			recovery_anchors_valid = recovery_anchors_valid and child.get_meta(&"recovery_anchor", Vector2.INF) == STUCK_RECOVERY_ANCHOR
	return {
		"deterministic_handling_lab_contract_pass": SLALOM_MARKER_POSITIONS.size() == 5 and stuck_fixture_walls == 3 and recovery_anchors_valid,
		"slalom_markers": SLALOM_MARKER_POSITIONS.duplicate(),
		"braking_reverse_bay": BRAKING_REVERSE_BAY_POSITION,
		"stuck_recovery_fixture": STUCK_RECOVERY_FIXTURE_POSITION,
		"stuck_recovery_anchor": STUCK_RECOVERY_ANCHOR,
		"stuck_fixture_wall_count": stuck_fixture_walls,
		"wide_handbrake_turn": WIDE_HANDBRAKE_TURN_POSITION,
	}


func fixture_evidence() -> Dictionary:
	var active_count := 0
	var light_active := false
	for child in get_children():
		if child is StaticBody2D and child.has_meta(&"weight"):
			var body := child as StaticBody2D
			var active := body.collision_layer != 0 and body.visible and not bool(body.get_meta(&"broken", false))
			if active:
				active_count += 1
			if String(body.get_meta(&"weight", "")) == "light":
				light_active = active
	return {
		"active_obstacle_count": active_count,
		"light_barrier_active": light_active,
		"expected_obstacle_count": obstacle_specs.size(),
	}


func reset_world() -> void:
	var existing_weights := {}
	for child in get_children():
		if child is StaticBody2D and child.has_meta(&"weight"):
			var body := child as StaticBody2D
			var weight := String(body.get_meta(&"weight", ""))
			existing_weights[weight] = true
			body.set_meta(&"broken", false)
			body.set_deferred("collision_layer", 1)
			body.call_deferred("show")
	for spec in obstacle_specs:
		if not existing_weights.has(String(spec["weight"])):
			_add_obstacle(spec)


func _add_world_art() -> void:
	var background := _sprite("FirstRoadArtwork", FIRST_ROAD, Vector2(128.0, 0.0), Vector2.ONE, -10)
	background.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_sprite("GarageSafehouse", SAFEHOUSE, START_POSITION + Vector2(-58.0, -218.0), Vector2(0.54, 0.54), -1)
	_sprite("RadioRelay", RELAY, GOAL_POSITION + Vector2(0.0, -55.0), Vector2(0.58, 0.58), -1)
	_sprite("ObjectiveMarker", OBJECTIVE, GOAL_POSITION + Vector2(0.0, -164.0), Vector2(0.29, 0.29), 2)
	_sprite("RewardSignal", REWARD, GOAL_POSITION + Vector2(108.0, 25.0), Vector2(0.32, 0.32), 1)
	_sprite("RoadThreat", THREAT, Vector2(390.0, 88.0), Vector2(0.38, 0.38), 1)
	_sprite("FuelReference", FUEL, START_POSITION + Vector2(-82.0, 74.0), Vector2(0.34, 0.34), 1)
	_sprite("RepairReference", REPAIR, START_POSITION + Vector2(0.0, 78.0), Vector2(0.34, 0.34), 1)
	_sprite("CargoReference", CARGO, START_POSITION + Vector2(82.0, 74.0), Vector2(0.34, 0.34), 1)
	for reward_spec in ROUTE_REWARD_SPECS:
		_sprite(
			"RouteReward_%s" % String(reward_spec["id"]),
			REWARD,
			reward_spec["position"],
			Vector2(0.32, 0.32),
			1
		)


func _add_obstacle(spec: Dictionary) -> void:
	var obstacle := StaticBody2D.new()
	obstacle.name = "PrototypeObstacle_%s" % str(spec["weight"])
	obstacle.position = spec["position"]
	obstacle.set_meta("weight", spec["weight"])
	obstacle.set_meta("damage", spec["damage"])
	obstacle.set_meta("breakable", spec["breakable"])
	obstacle.set_meta("broken", false)
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = float(spec["radius"])
	shape_node.shape = shape
	obstacle.add_child(shape_node)
	var visual := Sprite2D.new()
	visual.name = "AuthoredBarrier"
	visual.texture = _barrier_texture(str(spec["weight"]))
	var desired_diameter := float(spec["radius"]) * 2.35
	visual.scale = Vector2.ONE * desired_diameter / maxf(visual.texture.get_width(), 1.0)
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	obstacle.add_child(visual)
	add_child(obstacle)


func _add_handling_lab_fixtures() -> void:
	_add_lab_wall("StuckRecoveryBackstop", Vector2(-542.0, 386.0), Vector2(190.0, 22.0))
	_add_lab_wall("StuckRecoveryLeftRail", Vector2(-637.0, 315.0), Vector2(22.0, 164.0))
	_add_lab_wall("StuckRecoveryRightRail", Vector2(-447.0, 315.0), Vector2(22.0, 164.0))


func _add_lab_wall(node_name: String, world_position: Vector2, wall_size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.name = node_name
	wall.position = world_position
	wall.set_meta(&"lab_fixture", "stuck_recovery")
	wall.set_meta(&"recovery_anchor", STUCK_RECOVERY_ANCHOR)
	wall.set_meta(&"recovery_rotation", -PI / 2.0)
	wall.set_meta(&"damage", 0.0)
	wall.set_meta(&"breakable", false)
	var shape_node := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = wall_size
	shape_node.shape = shape
	wall.add_child(shape_node)
	add_child(wall)


func _sprite(node_name: String, texture: Texture2D, world_position: Vector2, sprite_scale: Vector2, z: int) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = texture
	sprite.position = world_position
	sprite.scale = sprite_scale
	sprite.z_index = z
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	add_child(sprite)
	return sprite


func _barrier_texture(weight: String) -> Texture2D:
	match weight:
		"light":
			return BARRIER_LIGHT
		"heavy":
			return BARRIER_HEAVY
		_:
			return BARRIER_MEDIUM


func _distance_to_segment(point: Vector2, start: Vector2, finish: Vector2) -> float:
	var segment := finish - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(start)
	var t := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * t)


func _road_surface() -> Dictionary:
	return {
		"name": "road",
		"speed_multiplier": 1.0,
		"grip": 1.0,
		"rolling_drag": 30.0,
	}
