#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
output_path="${1:-/tmp/HandlingTruthSlice.app}"
godot_bin="${GODOT_BIN:-/opt/homebrew/bin/godot}"

if [[ "$output_path" != /* || "$output_path" != *.app ]]; then
	print -u2 "Output must be an absolute .app path: $output_path"
	exit 2
fi

commit="$(/usr/bin/git -C "$repo_root" rev-parse HEAD)"
dirty=false
if [[ -n "$(/usr/bin/git -C "$repo_root" status --porcelain --untracked-files=normal)" ]]; then
	dirty=true
fi
if [[ "$dirty" == true && "${ALLOW_DIRTY_HANDLING_EXPORT:-0}" != 1 ]]; then
	print -u2 "Refusing Handling Truth Slice release export from a dirty worktree. Commit the candidate first."
	print -u2 "For non-acceptance debugging only: ALLOW_DIRTY_HANDLING_EXPORT=1 $0 $output_path"
	exit 2
fi
if [[ "$dirty" == true ]]; then
	print -u2 "WARNING: dirty debug export; this build is ineligible for acceptance evidence."
fi

if [[ -e "$output_path" ]]; then
	/bin/rm -rf -- "$output_path"
fi
exported_at_utc="$(/bin/date -u +%Y-%m-%dT%H:%M:%SZ)"
godot_version="$("$godot_bin" --version | /usr/bin/head -1)"
"$godot_bin" --headless --path "$repo_root" --export-release "Handling Truth Slice macOS" "$output_path"

resources_path="$output_path/Contents/Resources"
/bin/mkdir -p "$resources_path"
asset_root="$repo_root/prototypes/handling_truth_slice/assets"
sum_source_bytes() {
	/usr/bin/find "$1" -type f ! -name '*.import' -exec /usr/bin/stat -f '%z' {} + | /usr/bin/awk '{ total += $1 } END { print total + 0 }'
}
source_asset_bytes="$(sum_source_bytes "$asset_root")"
audio_source_bytes="$(sum_source_bytes "$asset_root/audio")"
font_source_bytes="$(sum_source_bytes "$asset_root/fonts")"
visual_source_bytes="$(sum_source_bytes "$asset_root/visual")"
source_asset_count="$(/usr/bin/find "$asset_root" -type f ! -name '*.import' | /usr/bin/wc -l | tr -d ' ')"
pck_path="$resources_path/Handling Truth Slice.pck"
pck_bytes="$(/usr/bin/stat -f '%z' "$pck_path")"
/usr/bin/printf '{"commit":"%s","dirty":%s,"build_flavor":"release","export_preset":"Handling Truth Slice macOS","exported_at_utc":"%s","godot_version":"%s","source_asset_count":%s,"source_asset_bytes":%s,"audio_source_bytes":%s,"font_source_bytes":%s,"visual_source_bytes":%s,"pck_bytes":%s}\n' \
	"$commit" "$dirty" "$exported_at_utc" "$godot_version" "$source_asset_count" "$source_asset_bytes" "$audio_source_bytes" "$font_source_bytes" "$visual_source_bytes" "$pck_bytes" \
	> "$resources_path/handling-truth-slice-provenance.json"
licenses_path="$resources_path/licenses"
/bin/mkdir -p "$licenses_path"
/bin/cp "$repo_root/prototypes/handling_truth_slice/assets/fonts/OFL-Atkinson-Hyperlegible.txt" "$licenses_path/"
/bin/cp "$repo_root/prototypes/handling_truth_slice/assets/fonts/OFL-Barlow.txt" "$licenses_path/"
/bin/cp "$repo_root/prototypes/handling_truth_slice/ASSET_MANIFEST.md" "$licenses_path/"
/usr/bin/codesign --force --deep --sign - --timestamp=none "$output_path"
/usr/bin/codesign --verify --deep --strict "$output_path"
launch_log="$(/usr/bin/mktemp /tmp/handling-truth-slice-launch.XXXXXX)"
if ! "$output_path/Contents/MacOS/Handling Truth Slice" --headless --quit-after 2 >"$launch_log" 2>&1; then
	/bin/cat "$launch_log" >&2
	/bin/rm -f "$launch_log"
	print -u2 "Exported Handling Truth Slice launch smoke failed."
	exit 1
fi
if /usr/bin/grep -Eq 'SCRIPT ERROR:|ERROR:' "$launch_log"; then
	/bin/cat "$launch_log" >&2
	/bin/rm -f "$launch_log"
	print -u2 "Exported Handling Truth Slice contains a missing or invalid runtime dependency."
	exit 1
fi
/bin/rm -f "$launch_log"
app_file_bytes="$(/usr/bin/find "$output_path" -type f -exec /usr/bin/stat -f '%z' {} + | /usr/bin/awk '{ total += $1 } END { print total + 0 }')"

print "HANDLING_TRUTH_SLICE_EXPORT path=$output_path commit=$commit dirty=$dirty launch_smoke=true source_assets=$source_asset_count source_asset_bytes=$source_asset_bytes pck_bytes=$pck_bytes app_file_bytes=$app_file_bytes"
