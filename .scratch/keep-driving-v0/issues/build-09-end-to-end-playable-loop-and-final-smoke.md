# Build 09 End To End Playable Loop And Final Smoke

Type: build
Owner: unclaimed
Status: todo
Blocked by: build-02, build-03, build-04, build-05, build-06, build-07, build-08

## Scope

- Integrate the full loop: launch, start fresh Run Seed, drive, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade, and restart with Scrap and upgrades preserved.
- Run all automated proofs.
- Run one focused 10-minute desktop manual smoke session.
- Run Landscape Mobile Simulation Proof.
- Own final bug fixes needed to make the Done Bar pass.

## Acceptance

- Automated Godot proofs pass.
- WorldPerfProof passes.
- Manual 10-minute smoke covers the full Done Bar.
- Landscape Mobile Simulation Proof passes.
- No hard stop condition remains.

## Proof

- `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`
- `/opt/homebrew/bin/godot --path /Users/shanewalker/Desktop/dev/keep-driving`

## Agent Report

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
