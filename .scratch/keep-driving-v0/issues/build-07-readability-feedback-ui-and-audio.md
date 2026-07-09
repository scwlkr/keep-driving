# Build 07 Readability Feedback UI And Audio

Type: build
Owner: Codex
Status: done
Blocked by: build-01

## Scope

- Implement Stylized Survival Readability with simple high-contrast procedural/custom 2D visuals.
- Add readable silhouettes for car, Zombies, pickups, and obstacle weight classes.
- Add rugged dashboard UI for Fuel, Vehicle Damage, Miles Driven, Scrap, Results, Garage, and restart.
- Add dust/skid/hit/debris/pickup feedback and minimal reactive audio.

## Acceptance

- Landscape phone-sized viewport remains readable.
- Car, Zombies, pickups, and obstacle weights are recognizable without labels.
- Feedback makes ramming, drifting, damage, and pickups clear.

## Proof

- Automated UI/mobile checks in `res://tests/run_all.gd`.
- Manual smoke readability notes.

## Agent Report

- Changed files:
  - `scripts/game_root.gd`
  - `proofs/manual_smoke_proof.gd`
  - `.scratch/keep-driving-v0/issues/build-07-readability-feedback-ui-and-audio.md`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/manual_smoke_proof.gd`
- Proof outputs:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
  - Manual smoke reported `viewport=(896.0, 414.0)`, `touch_sized=true`, `controls_in_bounds=true`, `dashboard_has_core_stats=true`, `dashboard_width_ok=true`, and `pass=true`.
- Known gaps:
  - None for build-07 scope.
- Commit hash: 546f034
  - Final worker report.
