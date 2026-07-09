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

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
