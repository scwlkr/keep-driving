extends Node

# PROTOTYPE: licensed/owned external audio tranche for Desktop Truth Slice A.

const ENGINE_IDLE: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/engine_idle.wav")
const ENGINE_LOAD: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/engine_load.wav")
const ENGINE_HIGH: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/engine_high.wav")
const SURFACE_ASPHALT: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/surface_asphalt.ogg")
const SURFACE_DIRT: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/surface_dirt.ogg")
const SURFACE_MUD: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/surface_mud.ogg")
const SURFACE_GRASS: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/surface_grass.ogg")
const IMPACT_LIGHT: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/impact_light.ogg")
const IMPACT_MEDIUM: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/impact_medium.ogg")
const IMPACT_HEAVY: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/impact_heavy.ogg")
const REWARD: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/reward.ogg")
const WARNING: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/warning.ogg")
const UI_CONFIRM: AudioStream = preload("res://prototypes/handling_truth_slice/assets/audio/ui_confirm.ogg")

const REQUIRED_BUSES := [&"Master", &"Music", &"Vehicle", &"World", &"UI"]
const IMPACT_VOICES_PER_FAMILY := 3
const ROUTINE_UI_VOICES := 2
const MEASURED_VOICE_CAP := 24
const CRITICAL_RESERVED_VOICES := 4

var _engine_idle: AudioStreamPlayer
var _engine_load: AudioStreamPlayer
var _engine_high: AudioStreamPlayer
var _surface: AudioStreamPlayer
var _impact_players: Dictionary = {}
var _reward: AudioStreamPlayer
var _warning: AudioStreamPlayer
var _ui_players:Array[AudioStreamPlayer] = []
var _players: Array[AudioStreamPlayer] = []
var _surface_streams: Dictionary = {}
var _last_cue_ms: Dictionary = {}
var _voice_cursor: Dictionary = {}
var _setup_complete := false
var _started := false
var _desktop_audio := false
var _critical := false
var _surface_key := "road"
var _tree_was_paused := false


func _ready() -> void:
	setup()
	_tree_was_paused = _tree_is_paused()
	if _started:
		_start_loops()


func _process(_delta: float) -> void:
	var paused := _tree_is_paused()
	if paused != _tree_was_paused:
		set_paused(paused)


func setup() -> void:
	if _setup_complete:
		return
	_setup_complete = true
	_desktop_audio = DisplayServer.get_name() != "headless"
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_bus("Master", "", 0.0)
	_ensure_bus("Music", "Master", -8.0)
	_ensure_bus("Vehicle", "Master", -3.0)
	_ensure_bus("World", "Master", -7.0)
	_ensure_bus("UI", "Master", -4.0)

	for stream in [ENGINE_IDLE, ENGINE_LOAD, ENGINE_HIGH, SURFACE_ASPHALT, SURFACE_DIRT, SURFACE_MUD, SURFACE_GRASS]:
		_configure_loop(stream)
	_surface_streams = {
		"road": SURFACE_ASPHALT,
		"dirt": SURFACE_DIRT,
		"grass": SURFACE_GRASS,
		"rough": SURFACE_DIRT,
		"water": SURFACE_MUD,
	}
	_engine_idle = _add_player("EngineIdle", "Vehicle", ENGINE_IDLE, -9.0, 1)
	_engine_load = _add_player("EngineLoad", "Vehicle", ENGINE_LOAD, -34.0, 1)
	_engine_high = _add_player("EngineHigh", "Vehicle", ENGINE_HIGH, -42.0, 1)
	_surface = _add_player("SurfaceLoop", "World", _surface_streams[_surface_key], -42.0, 1)
	for impact_spec in [
		{"key": "light", "stream": IMPACT_LIGHT, "volume_db": -10.0},
		{"key": "medium", "stream": IMPACT_MEDIUM, "volume_db": -7.0},
		{"key": "heavy", "stream": IMPACT_HEAVY, "volume_db": -4.0},
	]:
		var pool:Array[AudioStreamPlayer] = []
		for voice_index in IMPACT_VOICES_PER_FAMILY:
			pool.append(_add_player(
				"Impact%s%d" % [String(impact_spec["key"]).capitalize(), voice_index + 1],
				"Vehicle",
				impact_spec["stream"],
				float(impact_spec["volume_db"]),
				1
			))
		_impact_players[String(impact_spec["key"])] = pool
	_reward = _add_player("RewardCue", "UI", REWARD, -5.0, 1)
	_warning = _add_player("WarningCue", "UI", WARNING, -8.0, 1)
	for voice_index in ROUTINE_UI_VOICES:
		_ui_players.append(_add_player("UICue%d" % (voice_index + 1), "UI", UI_CONFIRM, -9.0, 1))


func start() -> void:
	setup()
	_started = true
	set_paused(_tree_is_paused())
	_start_loops()


func stop() -> void:
	_started = false
	_critical = false
	for player in _players:
		player.stop()
		player.stream_paused = false


func reset_state() -> void:
	setup()
	_critical = false
	_surface_key = "road"
	_last_cue_ms.clear()
	_engine_idle.pitch_scale = 0.90
	_engine_idle.volume_db = -9.0
	_engine_load.pitch_scale = 0.88
	_engine_load.volume_db = -34.0
	_engine_high.pitch_scale = 0.90
	_engine_high.volume_db = -42.0
	_voice_cursor.clear()
	for pool in _impact_players.values():
		for player in pool:
			(player as AudioStreamPlayer).stop()
	for player in [_reward, _warning]:
		player.stop()
	for player in _ui_players:
		player.stop()
	_surface.stop()
	_surface.stream = _surface_streams[_surface_key]
	_surface.pitch_scale = 0.90
	_surface.volume_db = -42.0
	if _started:
		_start_loops()


func set_paused(paused: bool) -> void:
	_tree_was_paused = paused
	for player in _players:
		player.stream_paused = paused and player.playing
	if not paused and _started:
		_start_loops()


func update_vehicle(speed_ratio: float, surface_name: String, critical: bool, engine_load: float = -1.0) -> void:
	setup()
	var speed := clampf(speed_ratio, 0.0, 1.0)
	var load := speed if engine_load < 0.0 else clampf(engine_load, 0.0, 1.0)
	_engine_idle.pitch_scale = lerpf(0.90, 1.14, speed)
	_engine_idle.volume_db = lerpf(-9.0, -18.0, speed)
	_engine_load.pitch_scale = lerpf(0.88, 1.28, speed)
	_engine_load.volume_db = lerpf(-34.0, -7.0, maxf(load, speed * 0.45))
	_engine_high.pitch_scale = lerpf(0.94, 1.34, speed)
	_engine_high.volume_db = lerpf(-42.0, -8.0, smoothstep(0.48, 1.0, speed))

	var next_surface := _normalize_surface(surface_name)
	if next_surface != _surface_key:
		_surface_key = next_surface
		_surface.stop()
		_surface.stream = _surface_streams[_surface_key]
		_configure_loop(_surface.stream)
		if _can_play_now():
			_surface.play()
	_surface.pitch_scale = lerpf(0.88, 1.18, speed)
	_surface.volume_db = lerpf(-42.0, _surface_peak_db(_surface_key), sqrt(speed))

	if critical and not _critical:
		_play_cue(_warning, "warning", 1_200)
	_critical = critical
	_start_loops()


func play_impact(weight: Variant) -> void:
	setup()
	var key := _normalize_impact(weight)
	_play_pooled_cue(_impact_players[key], "impact_%s" % key, 70)


func play_reward() -> void:
	setup()
	_play_cue(_reward, "reward", 180)


func play_ui() -> void:
	setup()
	_play_pooled_cue(_ui_players, "ui", 55)


func active_voice_count() -> int:
	var count := 0
	for player in _players:
		if player.playing and not player.stream_paused:
			count += 1
	return count


func evidence_snapshot() -> Dictionary:
	setup()
	var resources := {
		"engine_idle": ENGINE_IDLE,
		"engine_load": ENGINE_LOAD,
		"engine_high": ENGINE_HIGH,
		"surface_asphalt": SURFACE_ASPHALT,
		"surface_dirt": SURFACE_DIRT,
		"surface_mud": SURFACE_MUD,
		"surface_grass": SURFACE_GRASS,
		"impact_light": IMPACT_LIGHT,
		"impact_medium": IMPACT_MEDIUM,
		"impact_heavy": IMPACT_HEAVY,
		"reward": REWARD,
		"warning": WARNING,
		"ui_confirm": UI_CONFIRM,
	}
	var resource_paths := {}
	var resources_valid := true
	for key in resources:
		var stream: AudioStream = resources[key]
		var path := stream.resource_path if stream != null else ""
		resource_paths[key] = path
		resources_valid = resources_valid and path.begins_with("res://") and FileAccess.file_exists(path)
	var buses_valid := true
	for bus_name in REQUIRED_BUSES:
		buses_valid = buses_valid and AudioServer.get_bus_index(bus_name) >= 0
	var player_names := {}
	var unique_player_names := true
	for player in _players:
		var key := String(player.name)
		unique_player_names = unique_player_names and not player_names.has(key)
		player_names[key] = true
	var routing_valid := (
		_engine_idle.bus == &"Vehicle"
		and _engine_load.bus == &"Vehicle"
		and _engine_high.bus == &"Vehicle"
		and _surface.bus == &"World"
		and _reward.bus == &"UI"
		and _warning.bus == &"UI"
	)
	for pool in _impact_players.values():
		for player in pool:
			routing_valid = routing_valid and (player as AudioStreamPlayer).bus == &"Vehicle"
	for player in _ui_players:
		routing_valid = routing_valid and player.bus == &"UI"
	var monophonic_voice_contract := true
	for player in _players:
		monophonic_voice_contract = monophonic_voice_contract and player.max_polyphony == 1
	var voice_pool_contract := (
		_impact_players.size() == 3
		and (_impact_players["light"] as Array).size() == IMPACT_VOICES_PER_FAMILY
		and (_impact_players["medium"] as Array).size() == IMPACT_VOICES_PER_FAMILY
		and (_impact_players["heavy"] as Array).size() == IMPACT_VOICES_PER_FAMILY
		and _ui_players.size() == ROUTINE_UI_VOICES
		and _players.size() <= MEASURED_VOICE_CAP
	)
	var resource_cost := _resource_cost_evidence()
	return {
		"source_kind": "licensed_external_assets",
		"external_asset_contract_pass": resources_valid and buses_valid,
		"resource_paths": resource_paths,
		"engine_layers": 3,
		"surface_families": 4,
		"impact_families": 3,
		"buses": Array(REQUIRED_BUSES),
		"active_voices": active_voice_count(),
		"player_count": _players.size(),
		"loop_player_count": 4,
		"same_family_impact_voice_capacity": IMPACT_VOICES_PER_FAMILY,
		"routine_ui_voice_capacity": ROUTINE_UI_VOICES,
		"measured_voice_cap": MEASURED_VOICE_CAP,
		"critical_reserved_voices": CRITICAL_RESERVED_VOICES,
		"started": _started,
		"transport_paused": _tree_was_paused,
		"unique_player_names": unique_player_names,
		"routing_contract_pass": buses_valid and routing_valid and unique_player_names and _players.size() == 17,
		"monophonic_voice_contract_pass": monophonic_voice_contract,
		"voice_pool_contract_pass": voice_pool_contract,
		"resource_cost": resource_cost,
	}


func _start_loops() -> void:
	if not _can_play_now():
		return
	for player in [_engine_idle, _engine_load, _engine_high, _surface]:
		player.stream_paused = false
		if not player.playing:
			player.play()


func _play_cue(player: AudioStreamPlayer, key: String, cooldown_ms: int) -> void:
	if not _can_play_now():
		return
	var now := Time.get_ticks_msec()
	var last := int(_last_cue_ms.get(key, -1_000_000))
	if now - last < cooldown_ms:
		return
	_last_cue_ms[key] = now
	player.stream_paused = false
	player.play()


func _play_pooled_cue(pool: Array, key: String, cooldown_ms: int) -> void:
	if not _can_play_now() or pool.is_empty():
		return
	var now := Time.get_ticks_msec()
	var last := int(_last_cue_ms.get(key, -1_000_000))
	if now - last < cooldown_ms:
		return
	_last_cue_ms[key] = now
	var selected_index := -1
	for index in pool.size():
		if not (pool[index] as AudioStreamPlayer).playing:
			selected_index = index
			break
	if selected_index < 0:
		selected_index = int(_voice_cursor.get(key, 0)) % pool.size()
	_voice_cursor[key] = (selected_index + 1) % pool.size()
	var player := pool[selected_index] as AudioStreamPlayer
	player.stream_paused = false
	player.play()


func _can_play_now() -> bool:
	return _desktop_audio and _started and is_inside_tree() and not _tree_is_paused()


func _tree_is_paused() -> bool:
	return is_inside_tree() and get_tree().paused


func _ensure_bus(bus_name: String, send_name: String, volume_db: float) -> void:
	if AudioServer.get_bus_index(bus_name) >= 0:
		return
	AudioServer.add_bus()
	var index := AudioServer.bus_count - 1
	AudioServer.set_bus_name(index, bus_name)
	AudioServer.set_bus_volume_db(index, volume_db)
	if not send_name.is_empty():
		AudioServer.set_bus_send(index, send_name)


func _add_player(
	player_name: String,
	bus_name: String,
	stream: AudioStream,
	volume_db: float,
	polyphony: int
) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.name = player_name
	player.bus = bus_name
	player.stream = stream
	player.volume_db = volume_db
	player.max_polyphony = polyphony
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	_players.append(player)
	return player


func _configure_loop(stream: AudioStream) -> void:
	if stream is AudioStreamWAV:
		var wav := stream as AudioStreamWAV
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		if wav.loop_end <= 0:
			wav.loop_end = maxi(1, roundi(wav.get_length() * wav.mix_rate))
	elif stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true


func _normalize_surface(surface_name: String) -> String:
	var value := surface_name.to_lower()
	if value.contains("water") or value.contains("shallow") or value.contains("mud"):
		return "water"
	if value.contains("dirt") or value.contains("gravel"):
		return "dirt"
	if value.contains("grass"):
		return "grass"
	if value.contains("rough") or value.contains("barrier"):
		return "rough"
	return "road"


func _normalize_impact(weight: Variant) -> String:
	var key := str(weight).to_lower()
	return key if _impact_players.has(key) else "medium"


func _resource_cost_evidence() -> Dictionary:
	var imported_sample_payload_bytes := 0
	for stream in [ENGINE_IDLE, ENGINE_LOAD, ENGINE_HIGH]:
		imported_sample_payload_bytes += (stream as AudioStreamWAV).data.size()
	var streamed_packet_payload_bytes := 0
	for stream in [
		SURFACE_ASPHALT, SURFACE_DIRT, SURFACE_MUD, SURFACE_GRASS,
		IMPACT_LIGHT, IMPACT_MEDIUM, IMPACT_HEAVY, REWARD, WARNING, UI_CONFIRM,
	]:
		streamed_packet_payload_bytes += _ogg_packet_payload_bytes(stream as AudioStreamOggVorbis)
	return {
		"imported_sample_payload_bytes": imported_sample_payload_bytes,
		"streamed_packet_payload_bytes": streamed_packet_payload_bytes,
		"measured_voice_capacity": _players.size(),
		"voice_cap": MEASURED_VOICE_CAP,
		"output_latency_seconds": AudioServer.get_output_latency(),
		"mix_thread_time_available": false,
		"mix_thread_time_note": "Godot 4.7 exposes output latency but no public audio-mix thread time monitor",
	}


func _ogg_packet_payload_bytes(stream: AudioStreamOggVorbis) -> int:
	if stream == null or stream.packet_sequence == null:
		return 0
	var total := 0
	for page in stream.packet_sequence.packet_data:
		for packet in page:
			if packet is PackedByteArray:
				total += (packet as PackedByteArray).size()
	return total


func _surface_peak_db(key: String) -> float:
	match key:
		"dirt":
			return -12.0
		"grass":
			return -14.0
		"rough", "water":
			return -10.0
		_:
			return -17.0
