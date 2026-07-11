extends Node

const MIX_RATE: int = 22_050
const LOOP_FRAMES: int = MIX_RATE / 2

var _engine: AudioStreamPlayer
var _surface: AudioStreamPlayer
var _impact: AudioStreamPlayer
var _reward: AudioStreamPlayer
var _warning: AudioStreamPlayer
var _ui: AudioStreamPlayer
var _players: Array[AudioStreamPlayer] = []
var _surface_streams: Dictionary = {}
var _last_cue_ms: Dictionary = {}
var _setup_complete: bool = false
var _started: bool = false
var _desktop_audio: bool = false
var _critical: bool = false
var _surface_key: String = "road"
var _tree_was_paused: bool = false


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
	_ensure_bus("Vehicle", "Master", -3.0)
	_ensure_bus("World", "Master", -6.0)
	_ensure_bus("UI", "Master", -4.0)

	_surface_streams = {
		"road": _make_surface_loop("road"),
		"dirt": _make_surface_loop("dirt"),
		"grass": _make_surface_loop("grass"),
		"rough": _make_surface_loop("rough"),
		"water": _make_surface_loop("water"),
	}
	_engine = _add_player("EngineLoop", "Vehicle", _make_engine_loop(), -15.0, 1)
	_surface = _add_player("SurfaceLoop", "World", _surface_streams[_surface_key], -40.0, 1)
	_impact = _add_player("ImpactCue", "Vehicle", _make_impact(), -8.0, 2)
	_reward = _add_player("RewardCue", "UI", _make_reward(), -7.0, 2)
	_warning = _add_player("WarningCue", "UI", _make_warning(), -9.0, 1)
	_ui = _add_player("UICue", "UI", _make_ui(), -12.0, 2)


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


func set_paused(paused: bool) -> void:
	_tree_was_paused = paused
	for player in _players:
		player.stream_paused = paused and player.playing
	if not paused and _started:
		_start_loops()


func update_vehicle(speed_ratio: float, surface_name: String, critical: bool) -> void:
	setup()
	var speed := clampf(speed_ratio, 0.0, 1.0)
	_engine.pitch_scale = lerpf(0.72, 1.72, speed)
	_engine.volume_db = lerpf(-16.0, -5.0, speed)

	var next_surface := _normalize_surface(surface_name)
	if next_surface != _surface_key:
		_surface_key = next_surface
		_surface.stop()
		_surface.stream = _surface_streams[_surface_key]
		if _can_play_now():
			_surface.play()
	_surface.pitch_scale = lerpf(0.82, 1.45, speed)
	_surface.volume_db = lerpf(-42.0, _surface_peak_db(_surface_key), sqrt(speed))

	if critical and not _critical:
		_play_cue(_warning, "warning", 1_200)
	_critical = critical
	_start_loops()


func play_impact(weight: Variant) -> void:
	setup()
	var strength := _impact_strength(weight)
	_impact.pitch_scale = lerpf(1.18, 0.72, strength)
	_impact.volume_db = lerpf(-14.0, -4.0, strength)
	_play_cue(_impact, "impact", 70)


func play_reward() -> void:
	setup()
	_play_cue(_reward, "reward", 180)


func play_ui() -> void:
	setup()
	_play_cue(_ui, "ui", 55)


func _start_loops() -> void:
	if not _can_play_now():
		return
	for player in [_engine, _surface]:
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
	stream: AudioStreamWAV,
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


func _impact_strength(weight: Variant) -> float:
	if weight is String or weight is StringName:
		match str(weight).to_lower():
			"light":
				return 0.25
			"medium":
				return 0.60
			"heavy":
				return 1.0
			_:
				return 0.5
	return clampf(float(weight), 0.0, 1.0)


func _surface_peak_db(key: String) -> float:
	match key:
		"dirt":
			return -9.0
		"grass":
			return -11.0
		"rough", "water":
			return -7.0
		_:
			return -15.0


func _make_engine_loop() -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	samples.resize(LOOP_FRAMES)
	for frame in LOOP_FRAMES:
		var t := float(frame) / MIX_RATE
		var phase := TAU * 84.0 * t
		samples[frame] = 0.50 * sin(phase) + 0.18 * sin(phase * 2.0) + 0.08 * sin(phase * 4.0)
	return _wav_from_samples(samples, true)


func _make_surface_loop(key: String) -> AudioStreamWAV:
	var base_cycle: int
	var stride: int
	var seed: int
	match key:
		"dirt":
			base_cycle = 13; stride = 7; seed = 23
		"grass":
			base_cycle = 8; stride = 5; seed = 37
		"rough":
			base_cycle = 4; stride = 4; seed = 51
		"water":
			base_cycle = 10; stride = 3; seed = 73
		_:
			base_cycle = 31; stride = 11; seed = 11
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var phases := PackedFloat32Array()
	phases.resize(12)
	for index in phases.size():
		phases[index] = rng.randf_range(0.0, TAU)
	var samples := PackedFloat32Array()
	samples.resize(LOOP_FRAMES)
	for frame in LOOP_FRAMES:
		var progress := float(frame) / LOOP_FRAMES
		var noise := 0.0
		for harmonic in phases.size():
			var cycles := base_cycle + harmonic * stride
			noise += sin(TAU * cycles * progress + phases[harmonic]) / sqrt(float(harmonic + 1))
		var tread := sin(TAU * max(2, base_cycle / 2) * progress)
		samples[frame] = clampf(noise * 0.13 + tread * 0.10, -0.82, 0.82)
	return _wav_from_samples(samples, true)


func _make_impact() -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	samples.resize(int(MIX_RATE * 0.28))
	var rng := RandomNumberGenerator.new()
	rng.seed = 101
	for frame in samples.size():
		var t := float(frame) / MIX_RATE
		var envelope := exp(-15.0 * t)
		var body := sin(TAU * (82.0 - 70.0 * t) * t)
		samples[frame] = envelope * (0.62 * body + 0.30 * rng.randf_range(-1.0, 1.0))
	return _wav_from_samples(samples, false)


func _make_reward() -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	samples.resize(int(MIX_RATE * 0.46))
	var notes := PackedFloat32Array([523.25, 659.25, 783.99])
	for frame in samples.size():
		var t := float(frame) / MIX_RATE
		var note_index := mini(int(t / 0.13), notes.size() - 1)
		var local_t := t - note_index * 0.13
		var envelope := minf(local_t * 55.0, 1.0) * exp(-5.5 * local_t)
		samples[frame] = 0.55 * envelope * sin(TAU * notes[note_index] * t)
	return _wav_from_samples(samples, false)


func _make_warning() -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	samples.resize(int(MIX_RATE * 0.40))
	for frame in samples.size():
		var t := float(frame) / MIX_RATE
		var pulse_t := fmod(t, 0.20)
		if pulse_t < 0.12:
			var envelope := sin(PI * pulse_t / 0.12)
			samples[frame] = 0.58 * envelope * sin(TAU * 690.0 * t)
	return _wav_from_samples(samples, false)


func _make_ui() -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	samples.resize(int(MIX_RATE * 0.09))
	for frame in samples.size():
		var t := float(frame) / MIX_RATE
		var envelope := exp(-32.0 * t)
		samples[frame] = envelope * (0.45 * sin(TAU * 880.0 * t) + 0.18 * sin(TAU * 1320.0 * t))
	return _wav_from_samples(samples, false)


func _wav_from_samples(samples: PackedFloat32Array, looped: bool) -> AudioStreamWAV:
	var data := PackedByteArray()
	data.resize(samples.size() * 2)
	for frame in samples.size():
		var pcm := int(round(clampf(samples[frame], -1.0, 1.0) * 32_767.0))
		data.encode_s16(frame * 2, pcm)
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	wav.data = data
	if looped:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		wav.loop_end = samples.size()
	return wav
