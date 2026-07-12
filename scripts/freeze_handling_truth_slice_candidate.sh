#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
app_path="${1:-/tmp/HandlingTruthSlice.app}"
output_path="${2:-$repo_root/proofs/handling_truth_slice/ticket-08/candidate.json}"
godot_bin="${GODOT_BIN:-/opt/homebrew/bin/godot}"
python_bin="${PYTHON_BIN:-/opt/homebrew/bin/python3}"

if [[ "$app_path" != /* || "$app_path" != *.app || "$output_path" != /* ]]; then
	print -u2 "App must be an absolute .app path and candidate output must be absolute."
	exit 2
fi
if [[ -e "$output_path" ]]; then
	print -u2 "Refusing to overwrite frozen candidate evidence: $output_path"
	exit 2
fi
if [[ -n "$(/usr/bin/git -C "$repo_root" status --porcelain --untracked-files=normal)" ]]; then
	print -u2 "Refusing to freeze a candidate from a dirty worktree."
	exit 2
fi
if [[ ! -x "$python_bin" ]]; then
	print -u2 "Python executable not found: $python_bin"
	exit 2
fi

commit="$(/usr/bin/git -C "$repo_root" rev-parse HEAD)"
provenance_path="$app_path/Contents/Resources/handling-truth-slice-provenance.json"
executable_path="$app_path/Contents/MacOS/Handling Truth Slice"
pck_path="$app_path/Contents/Resources/Handling Truth Slice.pck"
for required_path in "$provenance_path" "$executable_path" "$pck_path"; do
	if [[ ! -f "$required_path" ]]; then
		print -u2 "Missing frozen-candidate artifact: $required_path"
		exit 2
	fi
done
/usr/bin/codesign --verify --deep --strict "$app_path"

asset_manifest_path="$repo_root/prototypes/handling_truth_slice/ASSET_MANIFEST.md"
playtest_contract_path="$repo_root/prototypes/handling_truth_slice/PLAYTEST_EVIDENCE.md"
recognition_harness_path="$repo_root/prototypes/handling_truth_slice/recognition/recognition_harness.gd"
export_preset_path="$repo_root/export_presets.cfg"

/bin/mkdir -p "${output_path:h}"
godot_version="$("$godot_bin" --version | /usr/bin/head -1)"

"$python_bin" - \
	"$commit" "$app_path" "$provenance_path" "$executable_path" "$pck_path" \
	"$asset_manifest_path" "$playtest_contract_path" "$recognition_harness_path" \
	"$export_preset_path" "$output_path" "$godot_version" <<'PY'
import datetime
import hashlib
import json
import pathlib
import subprocess
import sys

(
    commit,
    app_path,
    provenance_path,
    executable_path,
    pck_path,
    asset_manifest_path,
    playtest_contract_path,
    recognition_harness_path,
    export_preset_path,
    output_path,
    godot_version,
) = sys.argv[1:]

def sha256(path: str) -> str:
    digest = hashlib.sha256()
    with open(path, "rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()

with open(provenance_path, encoding="utf-8") as source:
    provenance = json.load(source)
if provenance.get("commit") != commit or provenance.get("dirty") is not False:
    raise SystemExit("embedded provenance does not match the clean source commit")
if provenance.get("build_flavor") != "release" or provenance.get("export_preset") != "Handling Truth Slice macOS":
    raise SystemExit("embedded provenance is not the frozen release export")
if provenance.get("godot_version") != godot_version or not provenance.get("exported_at_utc"):
    raise SystemExit("embedded export engine/time facts do not match the freeze environment")

def command_text(*arguments: str) -> str:
    completed = subprocess.run(arguments, check=True, capture_output=True, text=True)
    return completed.stdout.strip()

profile = json.loads(command_text(
    "/usr/sbin/system_profiler",
    "SPHardwareDataType",
    "SPDisplaysDataType",
    "SPAudioDataType",
    "-json",
))
hardware_source = profile.get("SPHardwareDataType", [{}])[0]
hardware = {
    "model_identifier": hardware_source.get("machine_model", ""),
    "model_name": hardware_source.get("machine_name", ""),
    "chip": hardware_source.get("chip_type", ""),
    "processor_summary": hardware_source.get("number_processors", ""),
    "memory": hardware_source.get("physical_memory", ""),
}
display = {}
for gpu in profile.get("SPDisplaysDataType", []):
    for candidate in gpu.get("spdisplays_ndrvs", []):
        if candidate.get("spdisplays_main") == "spdisplays_yes":
            display = {
                "name": candidate.get("_name", ""),
                "pixel_dimensions": candidate.get("_spdisplays_pixels", ""),
                "scaled_resolution": candidate.get("_spdisplays_resolution", ""),
                "display_type": candidate.get("spdisplays_display_type", ""),
                "connection_type": candidate.get("spdisplays_connection_type", ""),
            }
            break
    if display:
        break
audio_output = {}
for group in profile.get("SPAudioDataType", []):
    for candidate in group.get("_items", []):
        if candidate.get("coreaudio_default_audio_output_device") == "spaudio_yes":
            audio_output = {
                "name": candidate.get("_name", ""),
                "manufacturer": candidate.get("coreaudio_device_manufacturer", ""),
                "sample_rate_hz": candidate.get("coreaudio_device_srate", 0),
                "output_channels": candidate.get("coreaudio_device_output", 0),
                "transport": candidate.get("coreaudio_device_transport", ""),
            }
            break
    if audio_output:
        break
power_state = command_text("/usr/bin/pmset", "-g", "batt")
host_build_facts = {
    "macos_product_version": command_text("/usr/bin/sw_vers", "-productVersion"),
    "macos_build_version": command_text("/usr/bin/sw_vers", "-buildVersion"),
    "hardware": hardware,
    "display": display,
    "audio_output": audio_output,
    "power_state": power_state,
}
if not all((
    host_build_facts["macos_product_version"],
    host_build_facts["macos_build_version"],
    hardware["model_identifier"],
    hardware["chip"],
    hardware["memory"],
    display.get("pixel_dimensions"),
    audio_output.get("name"),
    power_state,
)):
    raise SystemExit("could not freeze complete host/display/audio/power facts")

app_file_bytes = sum(
    path.stat().st_size
    for path in pathlib.Path(app_path).rglob("*")
    if path.is_file() and not path.is_symlink()
)

document = {
    "schema": "keep-driving.handling-truth-slice.candidate.v1",
    "source_commit": commit,
    "worktree_clean_at_export": True,
    "export_dirty": False,
    "created_at_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "exported_at_utc": provenance["exported_at_utc"],
    "godot_version": godot_version,
    "host_build_facts": host_build_facts,
    "session_contract": {
        "build_flavor": "release",
        "export_preset": "Handling Truth Slice macOS",
        "release_template_identity": "official Godot release template bound by executable_sha256",
        "renderer": "gl_compatibility",
        "logical_viewport": [1280, 720],
        "benchmark_output_window": [1920, 1080],
        "scene": "res://prototypes/handling_truth_slice/prototype.tscn",
        "trace_seed": 80806012,
        "profile_fixture": "clean ephemeral prototype; persistence disabled",
    },
    "package_measurements": {
        "source_asset_count": provenance["source_asset_count"],
        "source_asset_bytes": provenance["source_asset_bytes"],
        "audio_source_bytes": provenance["audio_source_bytes"],
        "font_source_bytes": provenance["font_source_bytes"],
        "visual_source_bytes": provenance["visual_source_bytes"],
        "pck_bytes": pathlib.Path(pck_path).stat().st_size,
        "executable_bytes": pathlib.Path(executable_path).stat().st_size,
        "signed_app_file_bytes": app_file_bytes,
    },
    "codesign_verified": True,
    "build_provenance_path": provenance_path,
    "build_provenance_sha256": sha256(provenance_path),
    "executable_path": executable_path,
    "executable_sha256": sha256(executable_path),
    "pck_path": pck_path,
    "pck_sha256": sha256(pck_path),
    "asset_manifest_path": asset_manifest_path,
    "asset_manifest_sha256": sha256(asset_manifest_path),
    "playtest_contract_path": playtest_contract_path,
    "playtest_contract_sha256": sha256(playtest_contract_path),
    "recognition_harness_path": recognition_harness_path,
    "recognition_harness_sha256": sha256(recognition_harness_path),
    "export_preset_path": export_preset_path,
    "export_preset_sha256": sha256(export_preset_path),
}
with open(output_path, "x", encoding="utf-8") as destination:
    json.dump(document, destination, indent=2, sort_keys=True)
    destination.write("\n")
print(f"HANDLING_TRUTH_SLICE_CANDIDATE path={output_path} commit={commit}")
PY
