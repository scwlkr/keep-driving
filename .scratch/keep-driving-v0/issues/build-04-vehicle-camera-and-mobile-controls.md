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

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
