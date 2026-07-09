# Build 06 Resources Results Garage And Persistence

Type: build
Owner: Codex
Status: done
Blocked by: build-01, build-05

## Scope

- Implement Fuel, Sputter Grace Period, Repair Pickups, Scrap, Miles Driven scoring, Results, Garage, Permanent Upgrades, profile persistence, fresh Run Seed on restart, and run mutation save behavior.
- Use the locked v0 balance defaults from `12-define-v0-balance-defaults.md`.

## Acceptance

- Fuel can end a run after the sputter grace period.
- Fuel, Repair, and Scrap pickups apply immediately.
- Scrap earns and spends.
- Fuel Tank, Armor, and Engine upgrades persist and affect play.
- Restart uses a fresh Run Seed while preserving Scrap and Permanent Upgrades.

## Proof

- Automated checks in `res://tests/run_all.gd`.
- Manual smoke notes for run end, Results, Garage, and restart.

## Agent Report

- Changed files:
  - `scripts/profile_store.gd`
  - `scripts/game_root.gd`
  - `proofs/manual_smoke_proof.gd`
  - `.scratch/keep-driving-v0/issues/build-06-resources-results-garage-and-persistence.md`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/manual_smoke_proof.gd`
- Proof outputs:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
  - `MANUAL_SMOKE_SIMULATION seconds=600` covered Fuel/Repair/Scrap pickups, Fuel end, Vehicle Damage end, Results, Garage, fresh restart, and `pass=true`.
- Known gaps:
  - None for build-06 scope.
- Commit hash: 546f034
  - Final worker report.
