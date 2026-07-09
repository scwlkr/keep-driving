# Build 01 Project Shell And Proof Harness

Type: build
Owner: manager
Status: resolved
Blocked by:

## Scope

- Scaffold a native Godot 4.7 project at the repo root if `project.godot` is missing.
- Add the launchable main scene with start, garage, run, results, and restart surfaces.
- Add a headless proof runner at `res://tests/run_all.gd`.
- Document the exact Godot binary used.

## Acceptance

- Godot 4.7 opens the project from the repo root.
- Main scene launches without errors.
- Headless proof runner executes at least one trivial check.

## Proof

- `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --quit-after 1`

## Agent Report

- Changed files: `project.godot`, `scenes/main.tscn`, `scripts/*.gd`, `tests/run_all.gd`, `proofs/*.gd`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --quit-after 1`
- Proof outputs:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
  - Godot opened headlessly with `4.7.stable.official.5b4e0cb0f`
- Known gaps: none after final proof pass.
- Commit hash: b63b1f2
