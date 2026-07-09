# Build 05 Combat Hazards And Pursuit Pressure

Type: build
Owner: unclaimed
Status: todo
Blocked by: build-02, build-04

## Scope

- Implement Zombies, Zombie Swarm behavior, Car-Only Combat, obstacle weight classes, Roadblocks, Vehicle Damage, Safe Origin Radius, spawn caps, and Pursuit Pressure escalation.
- Enforce caps: `120` Zombies, `180` Obstacles/Roadblock pieces, `60` pickups, `40` active effects/debris, `400` total live/pooled world entities, and `32` generated Spawn Markers per World Chunk.

## Acceptance

- Ramming Zombies works.
- Zombie contact damages the vehicle.
- Light, medium, and heavy obstacles behave differently.
- Vehicle Damage can end a run.
- Pursuit Pressure escalates without spawning threats on top of the player.

## Proof

- Automated checks in `res://tests/run_all.gd`.
- Manual smoke notes for ramming, obstacle weights, and damage failure.

## Agent Report

- Changed files: `scripts/player_vehicle.gd`, `scripts/world_entity.gd`, `.scratch/keep-driving-v0/issues/build-04-vehicle-camera-and-mobile-controls.md`, `.scratch/keep-driving-v0/issues/build-05-combat-hazards-and-pursuit-pressure.md`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- Proof outputs:
  - `Godot Engine v4.7.stable.official.5b4e0cb0f`
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
- Known gaps: no manual smoke notes for ramming, obstacle weights, and damage failure were captured in this pass; Pursuit Pressure spawn escalation appears distance-based only, and elapsed-time escalation / spawn-distance safety would require `scripts/world_generator.gd` or `scripts/world_runtime.gd`, outside this worker's edit scope.
- Commit hash: pending commit
