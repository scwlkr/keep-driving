# Build 04 Vehicle Camera And Mobile Controls

Type: build
Owner: unclaimed
Status: todo
Blocked by: build-01

## Scope

- Implement Arcade-Real Handling with gas, brake/reverse, steering, Handbrake Drift, terrain speed/grip differences, impact shove/rotation, non-rotating look-ahead camera, speed zoom, and impact shake.
- Implement landscape mobile simulation controls: virtual steering plus gas, brake/reverse, and handbrake.

## Acceptance

- Terrain speed and grip multipliers affect movement.
- Handbrake state changes drift behavior.
- Camera look-ahead and zoom respond to speed.
- Collision response can shove and rotate the vehicle.
- Simulated touch inputs drive the same core controls.

## Proof

- Automated checks in `res://tests/run_all.gd`.
- Landscape mobile simulation proof notes.

## Agent Report

- Changed files: `scripts/player_vehicle.gd`, `scripts/world_entity.gd`, `.scratch/keep-driving-v0/issues/build-04-vehicle-camera-and-mobile-controls.md`, `.scratch/keep-driving-v0/issues/build-05-combat-hazards-and-pursuit-pressure.md`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- Proof outputs:
  - `Godot Engine v4.7.stable.official.5b4e0cb0f`
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
- Known gaps: no manual landscape mobile smoke drive performed in this pass; camera follow is immediate rather than smoothed, and smoothing would require `scripts/game_root.gd`, outside this worker's edit scope.
- Commit hash: pending commit
