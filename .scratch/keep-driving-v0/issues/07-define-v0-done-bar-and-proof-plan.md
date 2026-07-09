# Define v0 Done Bar And Proof Plan

Type: grilling
Status: open
Assignee: Codex
Blocked by: 02, 03, 04, 05, 06, 10, 11

## Question

What exact Done Bar proves the One-Shot Build Run succeeded?

The answer should define required playable surfaces, automated checks, manual smoke checks, desktop proof, mobile-orientation expectations, acceptable known limitations, and stop conditions.

## Grilling log

- v0 Done Bar is an end-to-end playable loop gate, not just a feature checklist. A passing Playable v0 must let the player launch the game, start a fresh Run Seed, drive in the Free-Roaming World, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end a run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade with Scrap, then start another fresh Run Seed with Scrap and Permanent Upgrades preserved.
- The automated proof gate should be Godot-native checks plus deterministic proof scenes/logs, with desktop playability as the hard target. The One-Shot Build Run should require `godot --headless` automated checks for deterministic chunks, route continuity, terrain multipliers, combat/resource/progression rules, and a `WorldPerfProof` 3-minute high-speed scripted drive at `60 FPS` / `p95 <= 16.7ms`. It should not require real mobile export proof.
