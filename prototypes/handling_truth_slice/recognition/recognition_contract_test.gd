extends SceneTree

const Harness = preload("res://prototypes/handling_truth_slice/recognition/recognition_harness.gd")

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var contract := Harness.contract_snapshot()
	_expect(contract["logical_size"] == Vector2i(896, 414), "recognition proof must use the exact 896x414 logical viewport")
	_expect(int(contract["exposure_ms"]) == 500, "recognition stimuli must remain visible for exactly 500 ms")
	_expect(int(contract["exposure_frames"]) == 30 and int(contract["render_hz"]) == 60, "recognition exposure must declare the nominal 30-frame equivalent at 60 Hz")
	_expect(
		String(contract.get("timing_origin", "")) == "first_completed_stimulus_draw"
		and String(contract.get("draw_count_source", "")) == "RenderingServer.frame_post_draw"
		and bool(contract.get("requires_exact_exposure_frames", false))
		and bool(contract.get("records_completed_hide_draw", false))
		and bool(contract.get("stimuli_preloaded_before_session", false)),
		"recognition timing must count completed draws through the completed hide frame and exclude asset loading"
	)
	_expect(int(contract["response_timeout_ms"]) == 10_000, "recognition responses must time out at ten seconds")
	_expect((contract["required_categories"] as Array).size() == 15, "all fifteen required Phase-2 categories must be fixed")
	_expect(
		bool(contract.get("requires_candidate_contract", false))
		and String(contract.get("candidate_schema", "")) == "keep-driving.handling-truth-slice.candidate.v1",
		"recognition evidence must require the frozen clean candidate contract"
	)
	_expect(bool(contract.get("supports_retained_preview_bundle", false)), "recognition sessions must bind to retained rendered previews of the exact randomized stimuli")
	_expect(
		bool(contract.get("participant_stimulus_matches_preview", false))
		and bool(contract.get("requires_canonical_output", false)),
		"participant exposures must match retained previews and write only the frozen slot artifact"
	)
	_expect(String(contract.get("density_background_path", "")).ends_with("recognition_density.svg"), "negative controls must use a semantic-neutral density backdrop, not the route artwork under test")
	var first_seed := Harness.session_seed("0123456789abcdef0123456789abcdef01234567", "KD08-HM-01")
	_expect(first_seed == Harness.session_seed("0123456789abcdef0123456789abcdef01234567", "KD08-HM-01"), "candidate-plus-participant seed derivation must be deterministic")
	_expect(first_seed != Harness.session_seed("0123456789abcdef0123456789abcdef01234567", "KD08-HM-02"), "different participant slots must receive different deterministic seeds")
	_expect(
		Harness.valid_participant_slot("KD08-HM-01")
		and Harness.valid_participant_slot("KD08-HM-10")
		and not Harness.valid_participant_slot("KD08-HM-00")
		and not Harness.valid_participant_slot("KD08-HM-11")
		and not Harness.valid_participant_slot("KD08-HM-1A"),
		"recognition cohort IDs must use the exact frozen 01-through-10 form"
	)
	_expect(
		Harness.canonical_output_path("KD08-HM-01").ends_with("/proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-01.jsonl"),
		"recognition evidence must resolve to the canonical immutable participant slot path"
	)
	_expect(
		Harness.canonical_preview_dir("KD08-HM-01").ends_with("/proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-01-previews"),
		"recognition preview evidence must resolve to the canonical retained participant directory"
	)

	var first_plan: Array[Dictionary] = Harness.build_trial_plan(40_414)
	var replay_plan: Array[Dictionary] = Harness.build_trial_plan(40_414)
	var alternate_plan: Array[Dictionary] = Harness.build_trial_plan(40_415)
	_expect(first_plan == replay_plan, "same recognition seed must reproduce the same trial order and positions")
	_expect(first_plan != alternate_plan, "different recognition seeds must randomize trial order or positions")

	var target_counts := {}
	var blank_counts := {}
	var neighbor_counts := {}
	for category in contract["required_categories"]:
		target_counts[category] = 0
		blank_counts[category] = 0
		neighbor_counts[category] = 0
	var blank_count := 0
	var neighbor_count := 0
	var asset_paths_valid := true
	var controls_valid := true
	var isolated_route_stimuli := true
	for trial in first_plan:
		var control := String(trial["control"])
		var target_category := String(trial["target_category"])
		if control == "target":
			target_counts[target_category] = int(target_counts[target_category]) + 1
			controls_valid = controls_valid and bool(trial["expected_presence"]) and String(trial["stimulus_category"]) == target_category
		elif control == "blank":
			blank_count += 1
			blank_counts[target_category] = int(blank_counts[target_category]) + 1
			controls_valid = controls_valid and not bool(trial["expected_presence"]) and String(trial["stimulus_category"]) == "blank"
		elif control == "near_neighbor":
			neighbor_count += 1
			neighbor_counts[target_category] = int(neighbor_counts[target_category]) + 1
			controls_valid = controls_valid and not bool(trial["expected_presence"]) and String(trial["stimulus_category"]) != target_category
		var asset_path := String(trial["asset_path"])
		if not asset_path.is_empty():
			asset_paths_valid = asset_paths_valid and asset_path.begins_with("res://") and FileAccess.file_exists(asset_path)
		if target_category in ["primary_road", "dirt_route", "mud_route"]:
			isolated_route_stimuli = isolated_route_stimuli and not trial.has("atlas_region")
			if control == "blank":
				isolated_route_stimuli = isolated_route_stimuli and asset_path.is_empty()
			else:
				isolated_route_stimuli = isolated_route_stimuli and asset_path.get_file().begins_with("route_")
	_expect(first_plan.size() == 45, "recognition plan must contain fifteen targets and thirty category-specific controls")
	for category in target_counts:
		_expect(int(target_counts[category]) == 1, "%s must have one positive target trial" % category)
		_expect(int(blank_counts[category]) == 1, "%s must have one blank control" % category)
		_expect(int(neighbor_counts[category]) == 1, "%s must have one near-neighbor control" % category)
	_expect(blank_count == 15, "recognition plan must include fifteen category-specific blank controls")
	_expect(neighbor_count == 15, "recognition plan must include fifteen category-specific near-neighbor controls")
	_expect(controls_valid, "every positive and negative trial must preserve category-specific presence truth")
	_expect(asset_paths_valid, "every nonblank recognition stimulus must resolve to an imported project asset")
	_expect(isolated_route_stimuli, "route positives and near-neighbor negatives must use isolated single-class assets, never overlapping world crops")

	if failures.is_empty():
		print("HANDLING_RECOGNITION_CONTRACT viewport=896x414 exposure_ms=500 frames=30 categories=15 targets=15 blank=15 near_neighbor=15 deterministic_seed=true pass=true")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("HANDLING_RECOGNITION_CONTRACT pass=false failures=%s" % str(failures))
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
