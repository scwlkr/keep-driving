#!/bin/zsh

set -euo pipefail

repo_root="${0:A:h:h}"
output_path="${1:-/tmp/HandlingTruthSlice.app}"
godot_bin="${GODOT_BIN:-/opt/homebrew/bin/godot}"

if [[ "$output_path" != *.app ]]; then
	print -u2 "Output must end in .app: $output_path"
	exit 2
fi

commit="$(/usr/bin/git -C "$repo_root" rev-parse HEAD)"
dirty=false
if [[ -n "$(/usr/bin/git -C "$repo_root" status --porcelain --untracked-files=normal)" ]]; then
	dirty=true
fi

"$godot_bin" --headless --path "$repo_root" --export-release "Handling Truth Slice macOS" "$output_path"

resources_path="$output_path/Contents/Resources"
/bin/mkdir -p "$resources_path"
/usr/bin/printf '{"commit":"%s","dirty":%s}\n' "$commit" "$dirty" > "$resources_path/handling-truth-slice-provenance.json"
/usr/bin/codesign --force --deep --sign - --timestamp=none "$output_path"
/usr/bin/codesign --verify --deep --strict "$output_path"

print "HANDLING_TRUTH_SLICE_EXPORT path=$output_path commit=$commit dirty=$dirty"
