class_name HandlingRecognitionHarness
extends Control

# Human-operated Phase-2 evidence harness. It records answers; it never supplies them.

const LOGICAL_SIZE := Vector2i(896, 414)
const EXPOSURE_MS := 500
const EXPOSURE_FRAMES := 30
const EXPOSURE_TOLERANCE_MS := 25
const FIXATION_MS := 900
const RESPONSE_TIMEOUT_MS := 10_000
const REQUIRED_CATEGORIES := [
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
const BODY_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Regular.otf")
const DISPLAY_FONT: Font = preload("res://prototypes/handling_truth_slice/assets/fonts/BarlowCondensed-Bold.otf")
const DENSITY_BACKGROUND: Texture2D = preload("res://prototypes/handling_truth_slice/assets/visual/recognition_density.svg")
const CANDIDATE_SCHEMA := "keep-driving.handling-truth-slice.candidate.v1"

enum Stage { INVALID, FIXATION, ARMING, EXPOSURE, HIDING, RESPONSE, COMPLETE }

var _candidate := ""
var _candidate_file_path := ""
var _candidate_file_sha256 := ""
var _candidate_validation := {}
var _preview_only := false
var _preview_dir := ""
var _preview_manifest_path := ""
var _preview_manifest_sha256 := ""
var _participant := ""
var _session_id := ""
var _seed := 0
var _seed_argument_matches := true
var _output_path := ""
var _trials: Array[Dictionary] = []
var _trial_index := -1
var _stage := Stage.INVALID
var _stage_started_ms := 0
var _selected_response := ""
var _selected_confidence := 0
var _exposure_started_frame := 0
var _exposure_started_ms := 0
var _exposure_frame_count := 0
var _exposure_actual_ms := 0
var _exposure_cadence_valid := false
var _exposure_draw_trace:Array[Dictionary] = []
var _all_exposures_valid := true
var _evidence_file: FileAccess
var _stimulus_cache := {}

var _stimulus: TextureRect
var _mask: ColorRect
var _fixation: Label
var _prompt: Label
var _progress: Label
var _status: Label


func _ready() -> void:
	Engine.max_fps = 60
	get_window().size = LOGICAL_SIZE
	get_window().content_scale_size = LOGICAL_SIZE
	_build_interface()
	_read_arguments()
	if not _validate_session_contract():
		return
	_trials = build_trial_plan(_seed)
	_preload_stimuli()
	if _preview_only:
		await _capture_preview_bundle()
		return
	if not _validate_preview_manifest():
		return
	if not _open_evidence_file():
		return
	_write_record({
		"event": "session_start",
		"trial_count": _trials.size(),
		"required_categories": REQUIRED_CATEGORIES,
		"trials_per_category": {"target": 1, "blank": 1, "near_neighbor": 1},
		"candidate_validation": _candidate_validation,
	})
	_write_record({"event": "trial_plan", "trials": _trials})
	_begin_next_trial()


func _process(_delta: float) -> void:
	var elapsed := Time.get_ticks_msec() - _stage_started_ms
	if _stage == Stage.FIXATION and elapsed >= FIXATION_MS:
		_begin_exposure()
	elif _stage == Stage.EXPOSURE and elapsed >= 2_000:
		_abort_stalled_exposure()
	elif _stage == Stage.RESPONSE and elapsed >= RESPONSE_TIMEOUT_MS:
		_record_response(true)


func _unhandled_key_input(event: InputEvent) -> void:
	if _stage != Stage.RESPONSE or not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	var response_keys := {KEY_P: "present", KEY_A: "absent"}
	if response_keys.has(key_event.physical_keycode):
		_selected_response = String(response_keys[key_event.physical_keycode])
	if key_event.physical_keycode >= KEY_1 and key_event.physical_keycode <= KEY_5:
		_selected_confidence = int(key_event.physical_keycode - KEY_0)
	_update_response_prompt()
	if not _selected_response.is_empty() and _selected_confidence > 0:
		_record_response(false)


static func contract_snapshot() -> Dictionary:
	return {
		"logical_size": LOGICAL_SIZE,
		"exposure_ms": EXPOSURE_MS,
		"exposure_frames": EXPOSURE_FRAMES,
		"render_hz": 60,
		"timing_origin": "first_completed_stimulus_draw",
		"draw_count_source": "RenderingServer.frame_post_draw",
		"requires_exact_exposure_frames": true,
		"records_completed_hide_draw": true,
		"stimuli_preloaded_before_session": true,
		"response_timeout_ms": RESPONSE_TIMEOUT_MS,
		"required_categories": REQUIRED_CATEGORIES.duplicate(),
		"density_background_path": DENSITY_BACKGROUND.resource_path,
		"target_trials_per_category": 1,
		"blank_trials_per_category": 1,
		"near_neighbor_trials_per_category": 1,
		"response_options": ["present", "absent"],
		"requires_candidate_contract": true,
		"candidate_schema": CANDIDATE_SCHEMA,
		"supports_retained_preview_bundle": true,
		"participant_stimulus_matches_preview": true,
		"requires_canonical_output": true,
	}


static func session_seed(candidate: String, participant: String) -> int:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update((candidate.to_lower() + "|" + participant.to_upper()).to_utf8_buffer())
	var digest := context.finish()
	return maxi(1, int(digest.decode_u32(0) & 0x7fffffff))


static func build_trial_plan(seed: int) -> Array[Dictionary]:
	var trials: Array[Dictionary] = []
	var target_stimuli := {
		"hero_car": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/hero_wagon.svg"},
		"primary_road": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/route_primary.svg"},
		"dirt_route": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/route_dirt.svg"},
		"mud_route": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/route_mud.svg"},
		"landmark": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/radio_relay.svg"},
		"safehouse": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/safehouse.svg"},
		"objective": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/objective.svg"},
		"threat": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/threat.svg"},
		"fuel": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/fuel.svg"},
		"repair": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/repair.svg"},
		"cargo": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/cargo.svg"},
		"reward": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/reward.svg"},
		"light_obstacle": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/barrier_light.svg"},
		"medium_obstacle": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/barrier_medium.svg"},
		"heavy_obstacle": {"asset_path": "res://prototypes/handling_truth_slice/assets/visual/barrier_heavy.svg"},
	}
	var neighbor_categories := {
		"hero_car": "cargo",
		"primary_road": "dirt_route",
		"dirt_route": "mud_route",
		"mud_route": "primary_road",
		"landmark": "safehouse",
		"safehouse": "landmark",
		"objective": "reward",
		"threat": "heavy_obstacle",
		"fuel": "repair",
		"repair": "fuel",
		"cargo": "reward",
		"reward": "cargo",
		"light_obstacle": "medium_obstacle",
		"medium_obstacle": "heavy_obstacle",
		"heavy_obstacle": "light_obstacle",
	}
	for category in REQUIRED_CATEGORIES:
		var positive: Dictionary = (target_stimuli[category] as Dictionary).duplicate(true)
		positive.merge({
			"target_category": category,
			"stimulus_category": category,
			"expected_presence": true,
			"control": "target",
		}, true)
		trials.append(positive)

		var neighbor_category := String(neighbor_categories[category])
		var neighbor: Dictionary = (target_stimuli[neighbor_category] as Dictionary).duplicate(true)
		neighbor.merge({
			"target_category": category,
			"stimulus_category": neighbor_category,
			"expected_presence": false,
			"control": "near_neighbor",
		}, true)
		trials.append(neighbor)

		trials.append({
			"target_category": category,
			"stimulus_category": "blank",
			"expected_presence": false,
			"control": "blank",
			"asset_path": "",
		})

	var random := RandomNumberGenerator.new()
	random.seed = seed
	for index in range(trials.size() - 1, 0, -1):
		var swap_index := random.randi_range(0, index)
		var held := trials[index]
		trials[index] = trials[swap_index]
		trials[swap_index] = held
	for index in trials.size():
		trials[index]["trial_id"] = "trial_%02d" % (index + 1)
		trials[index]["position_slot"] = random.randi_range(0, 2)
	return trials


func _build_interface() -> void:
	var theme_resource := Theme.new()
	theme_resource.default_font = BODY_FONT
	theme_resource.default_font_size = 18
	theme = theme_resource

	var background := TextureRect.new()
	background.name = "RepresentativeDensity"
	background.texture = DENSITY_BACKGROUND
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	_mask = ColorRect.new()
	_mask.color = Color("171818")
	_mask.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mask.visible = false
	add_child(_mask)

	_stimulus = TextureRect.new()
	_stimulus.name = "TimedStimulus"
	_stimulus.size = Vector2(112.0, 112.0)
	_stimulus.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_stimulus.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_stimulus.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stimulus)

	_fixation = Label.new()
	_fixation.text = "+"
	_fixation.add_theme_font_override("font", DISPLAY_FONT)
	_fixation.add_theme_font_size_override("font_size", 42)
	_fixation.add_theme_color_override("font_color", Color("f1e8cf"))
	_fixation.position = Vector2(432.0, 164.0)
	_fixation.size = Vector2(40.0, 60.0)
	_fixation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_fixation)

	_progress = Label.new()
	_progress.position = Vector2(18.0, 12.0)
	_progress.size = Vector2(360.0, 28.0)
	_progress.add_theme_color_override("font_color", Color("f1e8cf"))
	add_child(_progress)

	_status = Label.new()
	_status.position = Vector2(430.0, 12.0)
	_status.size = Vector2(448.0, 48.0)
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_status.add_theme_font_size_override("font_size", 13)
	_status.add_theme_color_override("font_color", Color("f1e8cf"))
	add_child(_status)

	_prompt = Label.new()
	_prompt.position = Vector2(48.0, 298.0)
	_prompt.size = Vector2(800.0, 92.0)
	_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_prompt.add_theme_color_override("font_color", Color("f1e8cf"))
	add_child(_prompt)


func _read_arguments() -> void:
	_candidate = _argument_value("--recognition-candidate=")
	_candidate_file_path = _argument_value("--recognition-candidate-file=")
	_preview_only = "--recognition-preview-only" in OS.get_cmdline_user_args()
	_preview_dir = _argument_value("--recognition-preview-dir=")
	_preview_manifest_path = _argument_value("--recognition-preview-manifest=")
	_participant = _argument_value("--recognition-participant=")
	_session_id = _argument_value("--recognition-session=")
	_output_path = _argument_value("--recognition-output=")
	var seed_value := _argument_value("--recognition-seed=")
	_seed = session_seed(_candidate, _participant)
	_seed_argument_matches = seed_value.is_empty() or (seed_value.is_valid_int() and int(seed_value) == _seed)


func _validate_session_contract() -> bool:
	var missing: Array[String] = []
	if _candidate.is_empty():
		missing.append("--recognition-candidate")
	if _participant.is_empty():
		missing.append("--recognition-participant")
	if _session_id.is_empty():
		missing.append("--recognition-session")
	if _candidate_file_path.is_empty():
		missing.append("--recognition-candidate-file")
	if _preview_only and _preview_dir.is_empty():
		missing.append("--recognition-preview-dir")
	if not _preview_only and _preview_manifest_path.is_empty():
		missing.append("--recognition-preview-manifest")
	if not _preview_only and _output_path.is_empty():
		missing.append("--recognition-output")
	if not missing.is_empty():
		_invalidate("Evidence session refused; required: %s" % ", ".join(missing))
		return false
	if not _is_git_sha(_candidate):
		_invalidate("Evidence session refused; candidate must be a full 40-character Git SHA")
		return false
	if not valid_participant_slot(_participant):
		_invalidate("Evidence session refused; participant must be KD08-HM-01 through KD08-HM-10")
		return false
	if not _seed_argument_matches:
		_invalidate("Evidence session refused; supplied seed does not match candidate-plus-participant derivation (%d)" % _seed)
		return false
	if not _validate_candidate_identity():
		return false
	if _preview_only and not _preview_dir.is_absolute_path():
		_invalidate("Evidence preview refused; preview directory must be absolute")
		return false
	if not _preview_only and not _preview_manifest_path.is_absolute_path():
		_invalidate("Evidence session refused; preview manifest path must be absolute")
		return false
	var canonical_preview_directory := canonical_preview_dir(_participant)
	if _preview_only and _preview_dir.simplify_path() != canonical_preview_directory:
		_invalidate("Evidence preview refused; preview directory must be the frozen canonical slot path: %s" % canonical_preview_directory)
		return false
	if not _preview_only and _preview_manifest_path.simplify_path() != canonical_preview_directory.path_join("manifest.json"):
		_invalidate("Evidence session refused; preview manifest must use the frozen canonical slot path")
		return false
	if not _preview_only:
		var canonical_output := canonical_output_path(_participant)
		if not _output_path.is_absolute_path() or _output_path.simplify_path() != canonical_output:
			_invalidate("Evidence session refused; output must be the frozen canonical slot path: %s" % canonical_output)
			return false
	var visible_size := Vector2i(get_viewport().get_visible_rect().size)
	if visible_size != LOGICAL_SIZE:
		_invalidate("Evidence session refused; logical viewport is %s, required %s" % [visible_size, LOGICAL_SIZE])
		return false
	return true


func _open_evidence_file() -> bool:
	_output_path = _output_path.simplify_path()
	if FileAccess.file_exists(_output_path):
		_invalidate("Evidence session refused; output already exists: %s" % _output_path)
		return false
	var error := DirAccess.make_dir_recursive_absolute(_output_path.get_base_dir())
	if error != OK:
		_invalidate("Evidence session refused; cannot create output directory (%s)" % error_string(error))
		return false
	_evidence_file = FileAccess.open(_output_path, FileAccess.WRITE)
	if _evidence_file == null:
		_invalidate("Evidence session refused; cannot open output: %s" % _output_path)
		return false
	_status.text = "%s | %s | seed %d\n%s" % [_candidate.left(12), _participant, _seed, _output_path]
	return true


func _begin_next_trial() -> void:
	_trial_index += 1
	if _trial_index >= _trials.size():
		_complete_session()
		return
	_selected_response = ""
	_selected_confidence = 0
	_stage = Stage.FIXATION
	_stage_started_ms = Time.get_ticks_msec()
	_mask.visible = true
	_stimulus.visible = false
	_fixation.visible = true
	_prompt.text = "LOOK FOR: %s" % _friendly_category(String(_trials[_trial_index]["target_category"]))
	_progress.text = "TRIAL %02d / %02d" % [_trial_index + 1, _trials.size()]


func _begin_exposure() -> void:
	_stage = Stage.ARMING
	_mask.visible = false
	_fixation.visible = false
	_prompt.text = ""
	var trial := _trials[_trial_index]
	var asset_path := String(trial["asset_path"])
	_stimulus.texture = _texture_for_trial(trial)
	var slots := [Vector2(246.0, 126.0), Vector2(392.0, 128.0), Vector2(536.0, 124.0)]
	_stimulus.position = slots[int(trial["position_slot"])]
	_stimulus.visible = not asset_path.is_empty()
	_status.visible = false
	_progress.visible = false
	await RenderingServer.frame_post_draw
	if _stage != Stage.ARMING:
		return
	_stage = Stage.EXPOSURE
	_stage_started_ms = Time.get_ticks_msec()
	_exposure_started_ms = _stage_started_ms
	_exposure_started_frame = Engine.get_frames_drawn()
	_exposure_frame_count = 1
	_exposure_draw_trace = [{
		"ordinal": 1,
		"draw_frame": _exposure_started_frame,
		"ticks_ms": _exposure_started_ms,
	}]
	_write_record({
		"event": "stimulus_shown",
		"trial_id": trial["trial_id"],
		"target_category": trial["target_category"],
		"control": trial["control"],
		"draw_frame": _exposure_started_frame,
		"ticks_ms": _exposure_started_ms,
	})
	_count_completed_exposure_draws()


func _count_completed_exposure_draws() -> void:
	while _stage == Stage.EXPOSURE and _exposure_frame_count < EXPOSURE_FRAMES:
		await RenderingServer.frame_post_draw
		if _stage != Stage.EXPOSURE:
			return
		_exposure_frame_count += 1
		_exposure_draw_trace.append({
			"ordinal": _exposure_frame_count,
			"draw_frame": Engine.get_frames_drawn(),
			"ticks_ms": Time.get_ticks_msec(),
		})
	if _stage == Stage.EXPOSURE:
		_finish_exposure()


func _finish_exposure() -> void:
	_stage = Stage.HIDING
	_mask.visible = true
	_stimulus.visible = false
	await RenderingServer.frame_post_draw
	if _stage != Stage.HIDING:
		return
	var hidden_frame := Engine.get_frames_drawn()
	var hidden_ms := Time.get_ticks_msec()
	_exposure_actual_ms = hidden_ms - _exposure_started_ms
	_exposure_cadence_valid = (
		_exposure_frame_count == EXPOSURE_FRAMES
		and absi(_exposure_actual_ms - EXPOSURE_MS) <= EXPOSURE_TOLERANCE_MS
	)
	_all_exposures_valid = _all_exposures_valid and _exposure_cadence_valid
	_stage = Stage.RESPONSE
	_stage_started_ms = Time.get_ticks_msec()
	_status.visible = true
	_progress.visible = true
	var trial := _trials[_trial_index]
	_write_record({
		"event": "stimulus_hidden",
		"trial_id": trial["trial_id"],
		"target_category": trial["target_category"],
		"control": trial["control"],
		"hide_completed_draw_frame": hidden_frame,
		"ticks_ms": hidden_ms,
		"exposure_frame_count": _exposure_frame_count,
		"exposure_actual_ms": _exposure_actual_ms,
		"exposure_cadence_valid": _exposure_cadence_valid,
		"completed_draw_trace": _exposure_draw_trace,
	})
	_update_response_prompt()


func _abort_stalled_exposure() -> void:
	if _stage != Stage.EXPOSURE:
		return
	_stage = Stage.RESPONSE
	_stage_started_ms = Time.get_ticks_msec()
	_exposure_actual_ms = _stage_started_ms - _exposure_started_ms
	_exposure_cadence_valid = false
	_all_exposures_valid = false
	_mask.visible = true
	_stimulus.visible = false
	_status.visible = true
	_progress.visible = true
	var trial := _trials[_trial_index]
	_write_record({
		"event": "stimulus_hidden",
		"trial_id": trial["trial_id"],
		"target_category": trial["target_category"],
		"control": trial["control"],
		"hide_completed_draw_frame": null,
		"ticks_ms": _stage_started_ms,
		"exposure_frame_count": _exposure_frame_count,
		"exposure_actual_ms": _exposure_actual_ms,
		"exposure_cadence_valid": false,
		"completed_draw_trace": _exposure_draw_trace,
		"invalid_reason": "rendered exposure stalled before 30 completed draws",
	})
	_update_response_prompt()


func _update_response_prompt() -> void:
	if _stage != Stage.RESPONSE:
		return
	var response_text := _selected_response.to_upper() if not _selected_response.is_empty() else "—"
	var confidence_text := str(_selected_confidence) if _selected_confidence > 0 else "—"
	var target := _friendly_category(String(_trials[_trial_index]["target_category"]))
	_prompt.text = "%s PRESENT?  [P] Present  [A] Absent\nCONFIDENCE [1–5]     answer: %s     confidence: %s" % [target, response_text, confidence_text]


func _record_response(timed_out: bool) -> void:
	var trial := _trials[_trial_index]
	_write_record({
		"event": "trial_response",
		"trial_id": trial["trial_id"],
		"trial_index": _trial_index,
		"control": trial["control"],
		"asset_path": trial["asset_path"],
		"target_category": trial["target_category"],
		"stimulus_category": trial["stimulus_category"],
		"expected_presence": trial["expected_presence"],
		"response": _selected_response,
		"confidence": _selected_confidence,
		"response_ms": Time.get_ticks_msec() - _stage_started_ms,
		"response_timeout_ms": RESPONSE_TIMEOUT_MS,
		"timed_out": timed_out,
		"exposure_ms": EXPOSURE_MS,
		"exposure_frame_count": _exposure_frame_count,
		"exposure_actual_ms": _exposure_actual_ms,
		"exposure_cadence_valid": _exposure_cadence_valid,
	})
	_begin_next_trial()


func _complete_session() -> void:
	_stage = Stage.COMPLETE
	_mask.visible = true
	_stimulus.visible = false
	_fixation.visible = false
	_progress.text = "SESSION COMPLETE"
	_prompt.text = "Raw answers retained. A named evidence owner must validate the session and aggregate the frozen cohort."
	_write_record({
		"event": "session_complete",
		"completed_trials": _trials.size(),
		"all_exposures_cadence_valid": _all_exposures_valid,
	})
	_evidence_file.flush()
	_evidence_file.close()


func _write_record(payload: Dictionary) -> void:
	if _evidence_file == null:
		return
	var record := payload.duplicate(true)
	record["schema"] = "handling_recognition_evidence_v1"
	record["candidate"] = _candidate
	record["candidate_file_path"] = _candidate_file_path
	record["candidate_file_sha256"] = _candidate_file_sha256
	record["preview_manifest_path"] = _preview_manifest_path
	record["preview_manifest_sha256"] = _preview_manifest_sha256
	record["participant"] = _participant
	record["session_id"] = _session_id
	record["seed"] = _seed
	record["logical_width"] = LOGICAL_SIZE.x
	record["logical_height"] = LOGICAL_SIZE.y
	record["recorded_at_utc"] = Time.get_datetime_string_from_system(true, true)
	_evidence_file.store_line(JSON.stringify(record))
	_evidence_file.flush()


func _invalidate(message: String) -> void:
	_stage = Stage.INVALID
	_mask.visible = true
	_fixation.visible = false
	_stimulus.visible = false
	_progress.text = "INVALID EVIDENCE SESSION"
	_prompt.text = message
	push_error(message)


func _argument_value(prefix: String) -> String:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with(prefix):
			return argument.trim_prefix(prefix)
	return ""


func _texture_for_trial(trial: Dictionary) -> Texture2D:
	var asset_path := String(trial.get("asset_path", ""))
	if asset_path.is_empty():
		return null
	var cache_key := _trial_texture_key(trial)
	if _stimulus_cache.has(cache_key):
		return _stimulus_cache[cache_key] as Texture2D
	return null


func _preload_stimuli() -> void:
	for trial in _trials:
		var asset_path := String(trial.get("asset_path", ""))
		if asset_path.is_empty():
			continue
		var cache_key := _trial_texture_key(trial)
		if _stimulus_cache.has(cache_key):
			continue
		var source_texture := ResourceLoader.load(asset_path, "Texture2D") as Texture2D
		var region_values: Array = trial.get("atlas_region", [])
		if region_values.size() != 4:
			_stimulus_cache[cache_key] = source_texture
			continue
		var atlas := AtlasTexture.new()
		atlas.atlas = source_texture
		atlas.region = Rect2(
			float(region_values[0]),
			float(region_values[1]),
			float(region_values[2]),
			float(region_values[3])
		)
		_stimulus_cache[cache_key] = atlas


func _trial_texture_key(trial: Dictionary) -> String:
	var asset_path := String(trial.get("asset_path", ""))
	var region_values: Array = trial.get("atlas_region", [])
	return "%s|%s" % [asset_path, str(region_values)]


func _friendly_category(category: String) -> String:
	return category.replace("_", " ").to_upper()


func _is_git_sha(value: String) -> bool:
	if value.length() != 40:
		return false
	for index in value.length():
		var code := value.to_lower().unicode_at(index)
		if not (code >= 48 and code <= 57) and not (code >= 97 and code <= 102):
			return false
	return true


static func valid_participant_slot(value: String) -> bool:
	if not value.begins_with("KD08-HM-") or value.length() != 10:
		return false
	var suffix := value.right(2)
	if not suffix.is_valid_int():
		return false
	var slot := int(suffix)
	return slot >= 1 and slot <= 10 and suffix == str(slot).pad_zeros(2)


static func canonical_output_path(participant: String) -> String:
	return ProjectSettings.globalize_path(
		"res://proofs/handling_truth_slice/ticket-08/recognition/%s.jsonl" % participant
	).simplify_path()


static func canonical_preview_dir(participant: String) -> String:
	return ProjectSettings.globalize_path(
		"res://proofs/handling_truth_slice/ticket-08/recognition/%s-previews" % participant
	).simplify_path()


static func json_size_matches(value: Variant, expected: Vector2i) -> bool:
	if value is not Array or (value as Array).size() != 2:
		return false
	var values := value as Array
	for component in values:
		if typeof(component) not in [TYPE_INT, TYPE_FLOAT]:
			return false
		if float(component) != float(int(component)):
			return false
	return int(values[0]) == expected.x and int(values[1]) == expected.y


func _capture_preview_bundle() -> void:
	_preview_dir = _preview_dir.simplify_path()
	var manifest_path := _preview_dir.path_join("manifest.json")
	if FileAccess.file_exists(manifest_path):
		_invalidate("Evidence preview refused; manifest already exists: %s" % manifest_path)
		return
	var directory_error := DirAccess.make_dir_recursive_absolute(_preview_dir)
	if directory_error != OK:
		_invalidate("Evidence preview refused; cannot create preview directory")
		return
	_mask.visible = false
	_fixation.visible = false
	_prompt.text = ""
	_status.visible = false
	_progress.visible = false
	var previews:Array[Dictionary] = []
	for index in _trials.size():
		var trial := _trials[index]
		var asset_path := String(trial["asset_path"])
		_stimulus.texture = _texture_for_trial(trial)
		var slots := [Vector2(246.0, 126.0), Vector2(392.0, 128.0), Vector2(536.0, 124.0)]
		_stimulus.position = slots[int(trial["position_slot"])]
		_stimulus.visible = not asset_path.is_empty()
		await RenderingServer.frame_post_draw
		var preview_image := get_viewport().get_texture().get_image()
		if preview_image.get_size() != LOGICAL_SIZE:
			preview_image.resize(LOGICAL_SIZE.x, LOGICAL_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var preview_path := _preview_dir.path_join(
			"%02d-%s-%s.png" % [index + 1, String(trial["target_category"]), String(trial["control"])]
		)
		var save_error := preview_image.save_png(preview_path)
		if save_error != OK:
			_invalidate("Evidence preview refused; failed to save %s" % preview_path)
			return
		previews.append({
			"trial_id": trial["trial_id"],
			"target_category": trial["target_category"],
			"stimulus_category": trial["stimulus_category"],
			"control": trial["control"],
			"expected_presence": trial["expected_presence"],
			"asset_path": trial["asset_path"],
			"position_slot": trial["position_slot"],
			"preview_path": preview_path,
			"preview_sha256": FileAccess.get_sha256(preview_path),
		})
	var manifest := {
		"schema": "keep-driving.handling-recognition-previews.v1",
		"candidate": _candidate,
		"candidate_file_sha256": _candidate_file_sha256,
		"participant": _participant,
		"seed": _seed,
		"logical_size": [LOGICAL_SIZE.x, LOGICAL_SIZE.y],
		"preview_count": previews.size(),
		"previews": previews,
	}
	var manifest_file := FileAccess.open(manifest_path, FileAccess.WRITE)
	if manifest_file == null:
		_invalidate("Evidence preview refused; cannot write preview manifest")
		return
	manifest_file.store_string(JSON.stringify(manifest, "\t"))
	manifest_file.store_string("\n")
	manifest_file.close()
	print("HANDLING_RECOGNITION_PREVIEWS candidate=%s participant=%s previews=%d manifest=%s" % [_candidate, _participant, previews.size(), manifest_path])
	_clean_quit(0)


func _validate_preview_manifest() -> bool:
	if not FileAccess.file_exists(_preview_manifest_path):
		_invalidate("Evidence session refused; preview manifest does not exist")
		return false
	var file := FileAccess.open(_preview_manifest_path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text()) if file != null else null
	if parsed is not Dictionary:
		_invalidate("Evidence session refused; preview manifest is invalid JSON")
		return false
	var manifest:Dictionary = parsed
	var valid:bool = (
		String(manifest.get("schema", "")) == "keep-driving.handling-recognition-previews.v1"
		and String(manifest.get("candidate", "")).to_lower() == _candidate.to_lower()
		and String(manifest.get("candidate_file_sha256", "")) == _candidate_file_sha256
		and String(manifest.get("participant", "")) == _participant
		and int(manifest.get("seed", 0)) == _seed
		and json_size_matches(manifest.get("logical_size", []), LOGICAL_SIZE)
		and int(manifest.get("preview_count", 0)) == _trials.size()
	)
	var previews:Array = manifest.get("previews", [])
	valid = valid and previews.size() == _trials.size()
	var preview_directory := _preview_manifest_path.get_base_dir().simplify_path()
	for index in previews.size():
		var preview:Dictionary = previews[index]
		var trial:Dictionary = _trials[index]
		var path := String(preview.get("preview_path", ""))
		valid = (
			valid
			and String(preview.get("trial_id", "")) == String(trial["trial_id"])
			and String(preview.get("target_category", "")) == String(trial["target_category"])
			and String(preview.get("stimulus_category", "")) == String(trial["stimulus_category"])
			and String(preview.get("control", "")) == String(trial["control"])
			and bool(preview.get("expected_presence", false)) == bool(trial["expected_presence"])
			and String(preview.get("asset_path", "")) == String(trial["asset_path"])
			and int(preview.get("position_slot", -1)) == int(trial["position_slot"])
			and path.is_absolute_path()
			and path.simplify_path().get_base_dir() == preview_directory
			and FileAccess.file_exists(path)
			and FileAccess.get_sha256(path) == String(preview.get("preview_sha256", ""))
		)
	if not valid:
		_invalidate("Evidence session refused; preview bundle does not match the frozen candidate/participant plan")
		return false
	_preview_manifest_path = _preview_manifest_path.simplify_path()
	_preview_manifest_sha256 = FileAccess.get_sha256(_preview_manifest_path)
	return true


func _clean_quit(exit_code:int) -> void:
	var tree := get_tree()
	var timer := tree.create_timer(0.20, true, false, true)
	timer.timeout.connect(tree.quit.bind(exit_code), CONNECT_ONE_SHOT)
	queue_free()


func _validate_candidate_identity() -> bool:
	if not _candidate_file_path.is_absolute_path() or not FileAccess.file_exists(_candidate_file_path):
		_invalidate("Evidence session refused; candidate contract must be an existing absolute path")
		return false
	var canonical_candidate_path := ProjectSettings.globalize_path(
		"res://proofs/handling_truth_slice/ticket-08/candidate.json"
	).simplify_path()
	if _candidate_file_path.simplify_path() != canonical_candidate_path:
		_invalidate("Evidence session refused; candidate contract must use the frozen canonical path: %s" % canonical_candidate_path)
		return false
	var candidate_file := FileAccess.open(_candidate_file_path, FileAccess.READ)
	if candidate_file == null:
		_invalidate("Evidence session refused; candidate contract cannot be read")
		return false
	var parsed = JSON.parse_string(candidate_file.get_as_text())
	if parsed is not Dictionary:
		_invalidate("Evidence session refused; candidate contract is not valid JSON")
		return false
	var document: Dictionary = parsed
	var required_fields := [
		"schema", "source_commit", "worktree_clean_at_export", "export_dirty",
		"created_at_utc", "exported_at_utc", "godot_version", "host_build_facts",
		"session_contract", "package_measurements", "codesign_verified",
		"build_provenance_path", "build_provenance_sha256", "executable_path", "executable_sha256",
		"pck_path", "pck_sha256", "asset_manifest_path", "asset_manifest_sha256",
		"playtest_contract_path", "playtest_contract_sha256",
		"recognition_harness_path", "recognition_harness_sha256",
		"export_preset_path", "export_preset_sha256",
	]
	for field in required_fields:
		if not document.has(field):
			_invalidate("Evidence session refused; candidate contract is missing %s" % field)
			return false
	var document_valid := (
		String(document["schema"]) == CANDIDATE_SCHEMA
		and String(document["source_commit"]).to_lower() == _candidate.to_lower()
		and bool(document["worktree_clean_at_export"])
		and not bool(document["export_dirty"])
		and bool(document["codesign_verified"])
		and not String(document["created_at_utc"]).is_empty()
		and not String(document["exported_at_utc"]).is_empty()
		and String(document["godot_version"]) == "4.7.stable.official.5b4e0cb0f"
	)
	var host_build_facts:Dictionary = document["host_build_facts"]
	var hardware:Dictionary = host_build_facts.get("hardware", {})
	var display:Dictionary = host_build_facts.get("display", {})
	var audio_output:Dictionary = host_build_facts.get("audio_output", {})
	var session_contract:Dictionary = document["session_contract"]
	var package_measurements:Dictionary = document["package_measurements"]
	var running_engine := Engine.get_version_info()
	document_valid = (
		document_valid
		and not String(host_build_facts.get("macos_product_version", "")).is_empty()
		and not String(host_build_facts.get("macos_build_version", "")).is_empty()
		and not String(host_build_facts.get("power_state", "")).is_empty()
		and not String(hardware.get("model_identifier", "")).is_empty()
		and not String(hardware.get("chip", "")).is_empty()
		and not String(hardware.get("memory", "")).is_empty()
		and not String(display.get("pixel_dimensions", "")).is_empty()
		and not String(audio_output.get("name", "")).is_empty()
		and String(session_contract.get("build_flavor", "")) == "release"
		and String(session_contract.get("export_preset", "")) == "Handling Truth Slice macOS"
		and not String(session_contract.get("release_template_identity", "")).is_empty()
		and String(session_contract.get("renderer", "")) == "gl_compatibility"
		and json_size_matches(session_contract.get("logical_viewport", []), Vector2i(1280, 720))
		and json_size_matches(session_contract.get("benchmark_output_window", []), Vector2i(1920, 1080))
		and String(session_contract.get("scene", "")) == "res://prototypes/handling_truth_slice/prototype.tscn"
		and int(session_contract.get("trace_seed", 0)) == 80_806_012
		and not String(session_contract.get("profile_fixture", "")).is_empty()
		and int(package_measurements.get("source_asset_count", 0)) > 0
		and int(package_measurements.get("source_asset_bytes", 0)) > 0
		and int(package_measurements.get("pck_bytes", 0)) > 0
		and int(package_measurements.get("executable_bytes", 0)) > 0
		and int(package_measurements.get("signed_app_file_bytes", 0)) > 0
		and int(running_engine.get("major", -1)) == 4
		and int(running_engine.get("minor", -1)) == 7
		and String(running_engine.get("status", "")) == "stable"
		and String(running_engine.get("build", "")) == "official"
		and String(running_engine.get("hash", "")).begins_with("5b4e0cb0f")
	)
	var hashed_paths := [
		["build_provenance_path", "build_provenance_sha256"],
		["executable_path", "executable_sha256"],
		["pck_path", "pck_sha256"],
		["asset_manifest_path", "asset_manifest_sha256"],
		["playtest_contract_path", "playtest_contract_sha256"],
		["recognition_harness_path", "recognition_harness_sha256"],
		["export_preset_path", "export_preset_sha256"],
	]
	for pair in hashed_paths:
		var path := String(document[pair[0]])
		document_valid = (
			document_valid
			and path.is_absolute_path()
			and FileAccess.file_exists(path)
			and FileAccess.get_sha256(path) == String(document[pair[1]])
		)
	var provenance_path := String(document["build_provenance_path"])
	var provenance_file := FileAccess.open(provenance_path, FileAccess.READ)
	var provenance = JSON.parse_string(provenance_file.get_as_text()) if provenance_file != null else null
	document_valid = (
		document_valid
		and provenance is Dictionary
		and String(provenance.get("commit", "")).to_lower() == _candidate.to_lower()
		and not bool(provenance.get("dirty", true))
		and String(provenance.get("build_flavor", "")) == "release"
		and String(provenance.get("export_preset", "")) == "Handling Truth Slice macOS"
		and String(provenance.get("exported_at_utc", "")) == String(document["exported_at_utc"])
		and String(provenance.get("godot_version", "")) == String(document["godot_version"])
		and int(provenance.get("source_asset_count", 0)) == int(package_measurements.get("source_asset_count", -1))
		and int(provenance.get("source_asset_bytes", 0)) == int(package_measurements.get("source_asset_bytes", -1))
		and int(provenance.get("pck_bytes", 0)) == int(package_measurements.get("pck_bytes", -1))
	)
	var project_root := ProjectSettings.globalize_path("res://").simplify_path()
	var head_output:Array = []
	var status_output:Array = []
	var head_exit := OS.execute("/usr/bin/git", PackedStringArray(["-C", project_root, "rev-parse", "HEAD"]), head_output, true)
	var status_exit := OS.execute("/usr/bin/git", PackedStringArray(["-C", project_root, "status", "--porcelain", "--untracked-files=no"]), status_output, true)
	var current_head := String(head_output[0]).strip_edges().to_lower() if not head_output.is_empty() else ""
	var tracked_status := "".join(status_output).strip_edges()
	document_valid = document_valid and head_exit == 0 and status_exit == 0 and current_head == _candidate.to_lower() and tracked_status.is_empty()
	if not document_valid:
		_invalidate("Evidence session refused; candidate provenance, hashes, or tracked source identity do not match")
		return false
	_candidate_file_path = _candidate_file_path.simplify_path()
	_candidate_file_sha256 = FileAccess.get_sha256(_candidate_file_path)
	_candidate_validation = {
		"schema": String(document["schema"]),
		"source_commit": current_head,
		"tracked_source_clean": true,
		"embedded_provenance_clean": true,
		"all_frozen_hashes_match": true,
		"host_build_facts_complete": true,
		"session_contract_complete": true,
		"package_measurements_complete": true,
		"running_engine_matches_candidate": true,
	}
	return true
