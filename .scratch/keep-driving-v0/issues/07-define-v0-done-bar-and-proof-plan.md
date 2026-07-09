# Define v0 Done Bar And Proof Plan

Type: grilling
Status: resolved
Assignee: Codex
Blocked by: 02, 03, 04, 05, 06, 10, 11

## Question

What exact Done Bar proves the One-Shot Build Run succeeded?

The answer should define required playable surfaces, automated checks, manual smoke checks, desktop proof, mobile-orientation expectations, acceptable known limitations, and stop conditions.

## Grilling log

- v0 Done Bar is an end-to-end playable loop gate, not just a feature checklist. A passing Playable v0 must let the player launch the game, start a fresh Run Seed, drive in the Free-Roaming World, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end a run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade with Scrap, then start another fresh Run Seed with Scrap and Permanent Upgrades preserved.
- The automated proof gate should be Godot-native checks plus deterministic proof scenes/logs, with desktop playability as the hard target. The One-Shot Build Run should require `godot --headless` automated checks for deterministic chunks, route continuity, terrain multipliers, combat/resource/progression rules, and a `WorldPerfProof` 3-minute high-speed scripted drive at `60 FPS` / `p95 <= 16.7ms`. It should not require real mobile export proof.
- Manual smoke proof should require one focused 10-minute local desktop play session that must feel like the Road Warrior Survival Expedition. Manual pass means the session covers road/path/offroad driving, terrain slowdown, water/barrier rerouting, Handbrake Drift, ramming Zombies, obstacle weight classes, pickups, fuel/damage warnings, run end, Results, Garage, restart, and Landscape Mobile Simulation Proof. If it feels like a corridor runner, lane runner, or disconnected tech demo, it fails.
- The Done Bar should explicitly allow simple placeholder/procedural assets when readability and feedback pass. Playable v0 can pass with generated/custom simple 2D assets and minimal reactive audio, but it fails if terrain routes, hazards, pickups, Zombies, car heading, impact feedback, Fuel danger, or low Vehicle Damage are unclear at landscape phone scale.
- The Done Bar should include hard stop conditions that block calling v0 done. Stop if it is not a 360-degree Free-Roaming World, routes do not continue across chunks, the end-to-end loop cannot complete, desktop performance proof fails, Landscape Mobile Simulation Proof is unusable, saves/upgrades do not persist, or the game only feels like separate demos stitched together.

## Answer

The Playable v0 Done Bar is an end-to-end playable loop gate, not just a feature checklist.

A passing v0 must let the player launch the game, start a fresh Run Seed, drive in the Free-Roaming World, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end a run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade with Scrap, then start another fresh Run Seed with Scrap and Permanent Upgrades preserved.

The automated proof gate should be Godot-native. The One-Shot Build Run must include `godot --headless` checks or proof scenes/logs for deterministic chunk generation, route continuity, terrain multipliers, combat rules, resource rules, progression persistence, and the run restart loop. It must also include `WorldPerfProof`: a 3-minute high-speed scripted drive that holds desktop-local `60 FPS` with `p95 frame time <= 16.7ms`.

Manual smoke proof should be one focused 10-minute local desktop play session. It passes only if the game feels like the Road Warrior Survival Expedition and covers road/path/offroad driving, terrain slowdown, water/barrier rerouting, Handbrake Drift, ramming Zombies, obstacle weight classes, pickups, fuel/damage warnings, run end, Results, Garage, restart, and Landscape Mobile Simulation Proof.

Landscape Mobile Simulation Proof is required, but real Android/iOS export artifacts, signing, installable mobile builds, and physical-device smoke proof are not required for v0.

The Done Bar allows simple placeholder/procedural assets and minimal reactive audio when Stylized Survival Readability passes. It fails if terrain routes, hazards, pickups, Zombies, car heading, impact feedback, Fuel danger, or low Vehicle Damage are unclear at landscape phone scale.

Hard stop conditions:

- The world is not a full 360-degree Free-Roaming World.
- Roads/paths behave like lanes, corridors, or rails.
- Route continuity breaks across World Chunk borders.
- The end-to-end playable loop cannot complete.
- Desktop performance proof fails.
- Landscape Mobile Simulation Proof is unusable.
- Scrap, Permanent Upgrades, or run restart persistence breaks.
- The result feels like disconnected tech demos rather than one coherent Playable v0.

This resolution makes the remaining fog specific enough to ticket. Balance tuning graduated into [Define v0 Balance Defaults](12-define-v0-balance-defaults.md). Build-run coordination graduated into [Decide Build Run Tracking Model](13-decide-build-run-tracking-model.md). Both should resolve before [Write One-Shot Build Run Prompt](08-write-one-shot-build-run-prompt.md).
