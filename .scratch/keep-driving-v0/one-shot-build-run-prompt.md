# Keep Driving v0 One-Shot Build Run Prompt

Use this as the launch prompt for the Autonomous Build Manager:

```markdown
/goal Build and verify Keep Driving Playable v0 from this repo.

You are the Autonomous Build Manager for `/Users/shanewalker/Desktop/dev/keep-driving`.

Mission: coordinate as many Codex sessions/agents as needed to build a real, impressive Playable v0 of Keep Driving: a landscape mobile, top-down, 360-degree Free-Roaming World survival driving game in Godot 4.7. Continue until the Done Bar passes or you hit a concrete blocker that requires scwlkr.

Core operating rules:

- Do the work autonomously. Ask scwlkr only for secrets, accounts, hardware access, or an irreversible scope change.
- Preserve user work. Start with `git status --short --branch`; never revert changes you did not make.
- Commit frequently. Commit the tracker setup first, then each completed slice with its proof notes.
- Use the Local Build Run Tracker in `.scratch/keep-driving-v0/issues/`. Create or update implementation tickets there using `build-XX-*.md` filenames so the existing wayfinder decision tickets stay intact.
- Claim a build ticket before editing it by adding `Owner: <agent/session>` and `Status: in-progress`.
- Use parallel agents for independent slices. Keep each agent to one claimed build ticket unless the manager explicitly reassigns it.
- Each agent must report changed files, proof commands, proof outputs, known gaps, and commit hash before the manager marks its ticket resolved.
- The manager owns integration, conflict resolution, final proof, and final reporting.
- Do not shrink the game into a lane runner, corridor runner, or disconnected tech demo.

First read:

- `AGENTS.md`
- `CONTEXT.md`
- `docs/adr/0001-use-godot-4-7.md`
- `.scratch/keep-driving-v0/map.md`
- every resolved wayfinder ticket in `.scratch/keep-driving-v0/issues/01-*.md` through `13-*.md`
- `.scratch/keep-driving-v0/research/*.md`

Repo setup:

- If `project.godot` does not exist, scaffold a native Godot 4.7 project at the repo root.
- Keep implementation source in normal Godot folders such as `scenes/`, `scripts/`, `assets/`, `tests/`, and `proofs/`.
- Prefer simple custom/procedural assets committed to the repo. Avoid external asset-pack dependency unless it is bundled-safe and clearly documented.
- Add repo-native proof scripts so future sessions can run the same checks without guessing.

Create these local build tickets before implementation:

1. `build-01-project-shell-and-proof-harness.md`
   - Godot 4.7 project opens from repo root.
   - Main scene launches to start/garage/run loop surfaces.
   - Headless proof runner exists.
   - Initial commit proves project can run at least one trivial headless check.

2. `build-02-deterministic-world-and-streaming.md`
   - Implement `RunSeed`, `WorldChunk`, `ChunkData`, deterministic generation from `RunSeed + ChunkCoord`, bounded `Active Window`, marker ids, mutation tracking, and chunk streaming.
   - Use `64 px` tiles, `32 x 32` tiles per World Chunk, active radius `2`, optional preload radius `3`.
   - Use `TileMapLayer` rendering, not one node per terrain cell.
   - Proof: stable chunk hashes, different seeds change origin, unload/reload preserves mutations, active/preload budgets hold.

3. `build-03-route-network-terrain-and-barriers.md`
   - Implement macro Route Network with roads, dirt paths, offroad traces, bridges/shallows, grass, rough offroad, water, and Traversal Barriers.
   - Roads and paths give Road Advantage but are not rails.
   - Proof: adjacent route exits match, no border gaps, water/barriers continue intentionally, player can drive anywhere and reroute.

4. `build-04-vehicle-camera-and-mobile-controls.md`
   - Implement Arcade-Real Handling, gas, brake/reverse, steering, Handbrake Drift, terrain speed/grip differences, impact shove/rotation, non-rotating look-ahead camera, speed zoom, impact shake, and landscape mobile simulation controls.
   - Proof: terrain multipliers, handbrake state, camera zoom/look-ahead, collision response, simulated touch inputs.

5. `build-05-combat-hazards-and-pursuit-pressure.md`
   - Implement Zombies, Zombie Swarm behavior, Car-Only Combat, obstacle weight classes, Roadblocks, Vehicle Damage, Safe Origin Radius, spawn caps, and Pursuit Pressure escalation.
   - Caps: `120` Zombies, `180` Obstacles/Roadblock pieces, `60` pickups, `40` active effects/debris, `400` total live/pooled world entities, `32` generated Spawn Markers per World Chunk.
   - Proof: ramming Zombies works, contact damage works, obstacle classes differ, Vehicle Damage can end a run, pressure escalates without spawning on top of player.

6. `build-06-resources-results-garage-and-persistence.md`
   - Implement Fuel, Sputter Grace Period, Repair Pickups, Scrap, Miles Driven scoring, Results, Garage, Permanent Upgrades, profile persistence, fresh Run Seed on restart, and run mutation save behavior.
   - Balance Defaults:
     - `MAX_FUEL = 100`
     - `FUEL_DRAIN_PER_SECOND = 0.33`
     - `SPUTTER_GRACE_SECONDS = 3`
     - `FUEL_PICKUP_AMOUNT = 35`
     - `MAX_VEHICLE_DAMAGE = 100`
     - `REPAIR_PICKUP_AMOUNT = 35`
     - `ZOMBIE_CONTACT_DAMAGE = 5/sec`
     - `LIGHT_OBSTACLE_DAMAGE = 5`
     - `MEDIUM_OBSTACLE_DAMAGE = 15`
     - `HEAVY_OBSTACLE_DAMAGE = 40`
     - `WATER_OR_CLIFF_DAMAGE = 100`
     - Scrap pickup = `5`
     - Run-end Scrap bonus = `1` per `0.25` Miles Driven, rounded down
     - Fuel Tank costs `20/50/100`, adds `+20/+40/+60` max Fuel
     - Armor costs `20/50/100`, adds `+20/+40/+60` max Vehicle Damage
     - Engine costs `25/60/120`, adds `+5%/+10%/+15%` road/top speed
   - Pursuit Pressure tiers:
     - Tier 0: `0-0.5` miles or `0-60s`
     - Tier 1: `0.5-1.5` miles or `60-180s`
     - Tier 2: `1.5-3` miles or `180-300s`
     - Tier 3: `3+` miles or `300s+`
   - Proof: fuel can end a run, pickups apply, Scrap earns/spends, upgrades persist and affect play, restart uses fresh Run Seed.

7. `build-07-readability-feedback-ui-and-audio.md`
   - Implement Stylized Survival Readability with simple high-contrast custom/procedural 2D visuals, readable silhouettes, rugged dashboard UI, dust/skid/hit/debris/pickup feedback, and minimal reactive audio.
   - UI only needs Fuel, Vehicle Damage, Miles Driven, Scrap, Results, Garage, and restart controls.
   - Proof: landscape phone-sized viewport remains readable, no labels required to recognize car/Zombies/pickups/obstacle weight classes, feedback makes ramming/drifting/damage/pickups clear.

8. `build-08-world-perf-proof-and-automation.md`
   - Implement `WorldPerfProof`: a 3-minute high-speed scripted drive.
   - Desktop hard gate: `60 FPS`, `p95 frame time <= 16.7ms`.
   - Streaming/spawn work target: `p95 <= 4ms`; attach/paint at most `1` new `ChunkNode` per frame.
   - Use Streaming Drag if high-speed travel approaches missing active terrain. Never show blank terrain, teleport, or invisible-wall the player.
   - Log FPS, p95 frame time, p95 world-stream time, active chunk count, preloaded `ChunkData` count, attach queue length, chunks attached this frame, entity counts by type, marker count scanned, skipped spawn count, pool usage, and Streaming Drag activations.

9. `build-09-end-to-end-playable-loop-and-final-smoke.md`
   - Integrate the full loop: launch, start fresh Run Seed, drive, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade, restart with Scrap and upgrades preserved.
   - Run all automated proofs.
   - Run one focused 10-minute desktop manual smoke session.
   - Run Landscape Mobile Simulation Proof.
   - Final ticket owns bug fixes needed to make the Done Bar pass.

Proof commands:

- Before implementation, locate Godot 4.7 with `which godot` and common macOS app paths. Document the exact binary used.
- Maintain a headless proof command equivalent to:
  - `godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- Maintain a WorldPerfProof command equivalent to:
  - `godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`
- Maintain a manual run command equivalent to:
  - `godot --path /Users/shanewalker/Desktop/dev/keep-driving`
- If the final command names differ, the manager must report the exact working commands.

Done Bar:

- The player can launch the game, start a fresh Run Seed, drive in the Free-Roaming World, collect Fuel/Scrap/Repair Pickups, take Vehicle Damage, end a run by Fuel or Vehicle Damage, see Results, buy at least one Garage upgrade, then start another fresh Run Seed with Scrap and Permanent Upgrades preserved.
- Automated Godot proofs pass for deterministic chunks, route continuity, terrain multipliers, combat rules, resource rules, progression persistence, and run restart.
- `WorldPerfProof` passes for 3 minutes at desktop-local `60 FPS` with `p95 frame time <= 16.7ms`.
- Manual 10-minute smoke covers road/path/offroad driving, terrain slowdown, water/barrier rerouting, Handbrake Drift, ramming Zombies, obstacle weight classes, pickups, fuel/damage warnings, run end, Results, Garage, restart, and Landscape Mobile Simulation Proof.
- Landscape Mobile Simulation Proof shows landscape phone-shaped viewport, touch-sized HUD, virtual steering plus gas/brake/handbrake, simulated mobile input through the core loop, readable camera/UI/terrain/action feedback.

Hard stops:

- Do not call v0 done if the world is not full 360-degree Free-Roaming.
- Do not call v0 done if roads/paths behave like lanes, corridors, or rails.
- Do not call v0 done if Route Network continuity breaks across World Chunk borders.
- Do not call v0 done if the end-to-end loop cannot complete.
- Do not call v0 done if desktop performance proof fails.
- Do not call v0 done if Landscape Mobile Simulation Proof is unusable.
- Do not call v0 done if Scrap, Permanent Upgrades, or run restart persistence breaks.
- Do not call v0 done if it feels like disconnected demos instead of one coherent Playable v0.

Final report format:

- Current commit hash.
- Build tickets completed, with one-line proof per ticket.
- Exact Godot binary and proof commands used.
- Automated proof summary.
- WorldPerfProof summary with p95 frame time and any Streaming Drag activations.
- Manual 10-minute smoke summary.
- Landscape Mobile Simulation Proof summary.
- Known limitations accepted for v0.
- Any hard blockers, if the Done Bar did not pass.
```
