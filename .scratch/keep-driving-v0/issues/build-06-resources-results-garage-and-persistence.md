# Build 06 Resources Results Garage And Persistence

Type: build
Owner: unclaimed
Status: todo
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
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
