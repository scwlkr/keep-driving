#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
godot_bin="${GODOT_BIN:-/opt/homebrew/bin/godot}"
python_bin="${PYTHON_BIN:-/opt/homebrew/bin/python3}"
output_dir="${1:-/tmp/keep-driving-handling-cadence-$(/bin/date -u +%Y%m%dT%H%M%SZ)}"
output_dir="${output_dir:A}"
duration_seconds="${CADENCE_SECONDS:-6}"
warmup_seconds="${CADENCE_WARMUP_SECONDS:-1}"
position_tolerance="${CADENCE_POSITION_TOLERANCE:-0.5}"
velocity_tolerance="${CADENCE_VELOCITY_TOLERANCE:-0.5}"
rotation_tolerance="${CADENCE_ROTATION_TOLERANCE:-0.005}"
candidate_sha="${HANDLING_TRUTH_SLICE_SHA:-}"
typeset -a provenance_args

if [[ ! -x "$godot_bin" && -z "${HANDLING_TRUTH_SLICE_BIN:-}" ]]; then
	print -u2 "Godot executable not found: $godot_bin"
	exit 2
fi
if [[ ! -x "$python_bin" ]]; then
	print -u2 "Python executable not found: $python_bin"
	exit 2
fi
if [[ -n "${HANDLING_TRUTH_SLICE_BIN:-}" ]]; then
	if [[ -z "$candidate_sha" ]]; then
		candidate_sha="$(/usr/bin/git -C "$repo_root" rev-parse HEAD)"
	fi
	if [[ ${#candidate_sha} -ne 40 || "$candidate_sha" == *[^0-9a-f]* ]]; then
		print -u2 "HANDLING_TRUTH_SLICE_SHA must be a full lowercase Git SHA"
		exit 2
	fi
	provenance_args+=("--prototype-build-id=$candidate_sha")
else
	provenance_args+=("--prototype-cadence-debug")
fi

/bin/mkdir -p "$output_dir"

typeset -a reports
for render_hz in 30 60 120; do
	report_path="$output_dir/cadence-${render_hz}-report.json"
	rss_path="$output_dir/cadence-${render_hz}-rss.json"
	log_path="$output_dir/cadence-${render_hz}.log"
	reports+=("$report_path")

	if [[ -n "${HANDLING_TRUTH_SLICE_BIN:-}" ]]; then
		"$HANDLING_TRUTH_SLICE_BIN" \
			--audio-driver Dummy \
			--resolution 1920x1080 \
			--position 20,20 \
			-- \
			--prototype-benchmark \
			--prototype-benchmark-mode=capacity \
			--prototype-render-hz="$render_hz" \
			--prototype-benchmark-seconds="$duration_seconds" \
			--prototype-benchmark-warmup="$warmup_seconds" \
			--prototype-benchmark-report="$report_path" \
			--prototype-benchmark-rss="$rss_path" \
			--prototype-benchmark-artifact="$log_path" \
			"${provenance_args[@]}" \
			2>&1 | /usr/bin/tee "$log_path"
	else
		"$godot_bin" \
			--path "$repo_root" \
			--scene res://prototypes/handling_truth_slice/prototype.tscn \
			--audio-driver Dummy \
			--resolution 1920x1080 \
			--position 20,20 \
			-- \
			--prototype-benchmark \
			--prototype-benchmark-mode=capacity \
			--prototype-render-hz="$render_hz" \
			--prototype-benchmark-seconds="$duration_seconds" \
			--prototype-benchmark-warmup="$warmup_seconds" \
			--prototype-benchmark-report="$report_path" \
			--prototype-benchmark-rss="$rss_path" \
			--prototype-benchmark-artifact="$log_path" \
			"${provenance_args[@]}" \
			2>&1 | /usr/bin/tee "$log_path"
	fi

	"$python_bin" - "$report_path" "$render_hz" "$candidate_sha" <<'PY'
import json
import sys

report_path, expected_hz, candidate_sha = sys.argv[1], int(sys.argv[2]), sys.argv[3]
with open(report_path, encoding="utf-8") as report_file:
    report = json.load(report_file)
if report.get("render_hz_target") != expected_hz:
    raise SystemExit(f"wrong render target in {report_path}")
if not report.get("cadence_capture_pass"):
    raise SystemExit(f"cadence capture failed: {report_path}")
if candidate_sha:
    if not report.get("provenance_valid") or not report.get("retained_candidate_evidence"):
        raise SystemExit(f"candidate cadence is not bound to clean provenance: {report_path}")
    if report.get("build_id") != candidate_sha:
        raise SystemExit(f"wrong candidate SHA in {report_path}")
elif not report.get("cadence_debug_unbound") or report.get("retained_candidate_evidence"):
    raise SystemExit(f"editor cadence must be explicitly unbound debug evidence: {report_path}")
PY
done

summary_path="$output_dir/cadence-comparison.json"
"$python_bin" - \
	"${reports[1]}" "${reports[2]}" "${reports[3]}" \
	"$summary_path" "$position_tolerance" "$velocity_tolerance" "$rotation_tolerance" "$candidate_sha" <<'PY'
import json
import math
import sys

report_paths = sys.argv[1:4]
summary_path = sys.argv[4]
position_tolerance = float(sys.argv[5])
velocity_tolerance = float(sys.argv[6])
rotation_tolerance = float(sys.argv[7])
candidate_sha = sys.argv[8]

reports = {}
for report_path in report_paths:
    with open(report_path, encoding="utf-8") as report_file:
        report = json.load(report_file)
    reports[int(report["render_hz_target"])] = report

if set(reports) != {30, 60, 120}:
    raise SystemExit(f"expected 30/60/120 reports, got {sorted(reports)}")

reference = reports[60]["final_trace"]
comparisons = []
for render_hz in (30, 120):
    candidate = reports[render_hz]["final_trace"]
    position_delta = [abs(a - b) for a, b in zip(candidate["position"], reference["position"])]
    velocity_delta = [abs(a - b) for a, b in zip(candidate["velocity"], reference["velocity"])]
    rotation_delta = abs(math.remainder(candidate["rotation_radians"] - reference["rotation_radians"], math.tau))
    ticks_match = candidate["physics_ticks"] == reference["physics_ticks"]
    comparison_pass = (
        ticks_match
        and max(position_delta) <= position_tolerance
        and max(velocity_delta) <= velocity_tolerance
        and rotation_delta <= rotation_tolerance
    )
    comparisons.append({
        "render_hz": render_hz,
        "reference_hz": 60,
        "physics_ticks_match": ticks_match,
        "position_axis_delta": position_delta,
        "velocity_axis_delta": velocity_delta,
        "rotation_delta_radians": rotation_delta,
        "pass": comparison_pass,
    })

summary = {
    "schema": "keep-driving.handling-truth-slice.render-cadence.v1",
    "pass": all(comparison["pass"] for comparison in comparisons),
    "actual_scene_tree_rendering": all(reports[hz]["rendered_valid"] for hz in reports),
    "candidate_sha": candidate_sha or None,
    "retained_candidate_evidence": bool(candidate_sha) and all(reports[hz]["retained_candidate_evidence"] for hz in reports),
    "debug_unbound": not bool(candidate_sha),
    "physics_ticks_per_second": reports[60]["physics_ticks_per_second"],
    "duration_seconds": reports[60]["duration_seconds"],
    "warmup_seconds": reports[60]["warmup_seconds"],
    "tolerances": {
        "position_axis_units": position_tolerance,
        "velocity_axis_units_per_second": velocity_tolerance,
        "rotation_radians": rotation_tolerance,
    },
    "reports": {str(hz): reports[hz]["report_path"] for hz in sorted(reports)},
    "comparisons": comparisons,
    "milestone_acceptance_pass": False,
    "milestone_acceptance_note": "Cadence evidence is one gate; full performance, controller, audio, and human evidence remain separate.",
}

with open(summary_path, "w", encoding="utf-8") as summary_file:
    json.dump(summary, summary_file, indent=2)
    summary_file.write("\n")

if not summary["pass"]:
    raise SystemExit(f"render cadence traces diverged: {summary_path}")
PY

print "HANDLING_TRUTH_SLICE_RENDER_CADENCE pass=true summary=$summary_path reports=${reports[*]}"
