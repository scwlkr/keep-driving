# Keep Driving v0 Wayfinder Map

## Destination

Reach an agent-ready plan for a One-Shot Build Run that creates a real, impressive Playable v0 of **Keep Driving**: a landscape mobile, top-down, Free-Roaming World survival driving game built in Godot 4.7.

The map is complete when nothing important remains undecided before launching a manager prompt that can coordinate parallel sessions/agents to build and verify the full v0.

## Notes

- Engine is Godot 4.7. See `docs/adr/0001-use-godot-4-7.md`.
- Do not shrink the game into a lane runner or corridor runner. It must be a full 360-degree Free-Roaming World.
- Terrain includes roads, paths, grass, dirt, and offroad. Roads and paths provide a Road Advantage, but the player can travel anywhere.
- v0 must feel real and fun, not like a disposable toy demo.
- Use `/grilling` and `/domain-modeling` for HITL decisions.
- Use `/prototype` for cheap Godot artifacts that make feel/behavior decisions concrete.
- Prefer AFK research/prototype tickets where Codex can proceed without asking scwlkr.
- The final output should be a compact One-Shot Build Run prompt plus a build issue plan suitable for parallel agents.

## Decisions so far

- [Define Core Loop And Feel Target](issues/01-define-core-loop-and-feel-target.md) — v0 targets a Road Warrior Survival Expedition: open route planning across generated terrain, water as a barrier, fuel/damage/escalating pursuit, Miles Driven scoring, stable chunks per run, fresh seed per restart, readable top-down camera, and ram-first combat.
- [Choose World Generation Architecture](issues/02-choose-world-generation-architecture.md) — world generation is deterministic chunk data from RunSeed plus ChunkCoord, rendered through bounded TileMapLayer chunk nodes; roads/paths come from a macro Route Network, spawns are deterministic markers, and saves keep mutations rather than full generated terrain.
- [Prototype Vehicle Feel Camera And Terrain Speed](issues/03-prototype-vehicle-feel-camera-and-terrain-speed.md) — vehicle feel is Arcade-Real Handling with gas/brake steering, Handbrake Drift, landscape mobile steering/buttons, terrain-specific grip/speed, non-rotating look-ahead camera, speed zoom, impact shake, and collisions that shove/break/stop based on obstacle weight.
- [Prototype Chunked World And Road Network](issues/04-prototype-chunked-world-and-road-network.md) — world proof must be a throwaway Godot scene proving full 360-degree free roaming, deterministic chunk hashes, multi-route continuity, hard/slow barriers, stable spawn markers, bounded active chunks, and no visible seams.
- [Decide Combat Enemy And Obstacle Model](issues/05-decide-combat-enemy-and-obstacle-model.md) — v0 combat is car-only against simple zombie swarms and weight-classed obstacles, with Vehicle Damage as combat failure, roadblocks as route pressure, and distance/Pursuit Pressure-based spawn escalation.
- [Decide Resources Upgrades And Run Progression](issues/06-decide-resources-upgrades-and-run-progression.md) — v0 uses Fuel, Vehicle Damage, Scrap, rare Repair Pickups, and a simple Garage with three persistent upgrades: Fuel Tank, Armor, and Engine.
- [Decide Visual Audio And Asset Direction](issues/09-decide-visual-audio-and-asset-direction.md) — v0 uses Stylized Survival Readability: simple high-contrast 2D assets, readable terrain/routes/silhouettes, juicy movement/impact feedback, reactive minimal audio, and a small rugged dashboard UI.
- [Define Infinite World Performance Budget](issues/10-define-infinite-world-performance-budget.md) — v0 gates on 60 FPS desktop proof with fixed chunk/entity caps, amortized chunk attach, Streaming Drag fallback, and a 3-minute high-speed `WorldPerfProof`.
- [Decide Mobile Export Proof Depth](issues/11-decide-mobile-export-proof-depth.md) — v0 requires landscape mobile simulation proof on desktop, while real Android/iOS exports and physical-device smoke proof are deferred until after Playable v0 exists.
- [Define v0 Done Bar And Proof Plan](issues/07-define-v0-done-bar-and-proof-plan.md) — v0 passes only through an end-to-end playable loop, Godot-native automated proofs, desktop perf proof, 10-minute manual smoke, mobile simulation, readable placeholder assets, and hard stop conditions.
- [Define v0 Balance Defaults](issues/12-define-v0-balance-defaults.md) — v0 uses rough but playable numeric constants for Fuel, Vehicle Damage, pickups, Scrap rewards, upgrade tiers, and four-tier Pursuit Pressure; perfect economy tuning is out of scope for the build run.
- [Decide Build Run Tracking Model](issues/13-decide-build-run-tracking-model.md) — the first build run stays local in `.scratch/keep-driving-v0/issues/`, coordinated through tracker files and commits; GitHub issues wait until Playable v0 exists or remote/human-visible coordination is needed.

## Not yet specified

- None.

## Out of scope

- Multiplayer for v0.
- App Store / Play Store release polish for v0.
- Towns, NPC economy, questlines, or authored story for v0.
- Monetization for v0.
