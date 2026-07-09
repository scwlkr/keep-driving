# Context

## Glossary

- **One-Shot Build Run**: A single user launch prompt after which Codex coordinates as many sessions and parallel agents as needed to build and verify the playable v0 without requiring the user to manage intermediate steps.
- **Playable v0**: The first complete version of the game that can be run locally, played end to end, and verified against an explicit done bar.
- **Free-Roaming World**: A full 360-degree top-down world where the player can drive in any direction across roads, paths, grass, dirt, and offroad terrain.
- **Road Advantage**: Roads and paths are faster or safer routes through the Free-Roaming World, but they are not hard boundaries; the player may leave them at any time.
- **Road Warrior Survival Expedition**: The core player fantasy for v0: driving a beat-up car across an endless hostile world where roads are fast but dangerous, and offroad routes are slower escape/exploration options.
- **Car-Only Combat**: The v0 combat model where the car is the player's weapon; the player survives by ramming, dodging, shoving, and routing through terrain rather than firing weapons.
- **Zombie**: The only active enemy type in Playable v0, a hostile threat that pressures movement and can be rammed by the car. Human raiders and armed enemies are outside v0.
- **Zombie Swarm**: The v0 enemy pressure pattern where groups of Zombies roam, drift toward the car, and become denser as danger escalates. It is not a special enemy type.
- **Vehicle Damage**: The run health state of the player's car. Collisions, Zombie contact, and hard impacts reduce it; reaching zero ends the run.
- **Route Network**: The generated world contains multiple possible roads, dirt paths, offroad traces, and terrain routes at once. The player is choosing among routes in an open world, not choosing between one road and one offroad lane.
- **Traversal Barrier**: A generated feature, such as water, cliffs, dense wreckage, or heavy debris, that meaningfully blocks or slows travel and forces route planning in the Free-Roaming World.
- **Obstacle**: A spawned physical hazard that the car can break, shove, be slowed by, or be blocked by depending on its weight class.
- **Roadblock**: A generated cluster of Obstacles that pressures route choice on or near a route, without becoming an authored puzzle gate.
- **Pursuit Pressure**: The escalating run danger that increases Zombie, blocker, and Roadblock pressure as the player gets farther from the origin or danger rises.
- **Run Seed**: The random seed used to generate one survival run. World chunks remain stable while that run is active; a new run uses a fresh Run Seed so returning to the origin starts a different adventure.
- **Miles Driven**: The headline run score for v0, based primarily on how far the player gets from the origin while surviving.
- **Fuel**: A hard but forgiving run-ending resource that drains during a run and can be restored by fuel pickups.
- **Sputter Grace Period**: The short final state after Fuel reaches zero before the run ends.
- **World Chunk**: A square generated section of the Free-Roaming World, identified by chunk coordinates and created deterministically from the Run Seed.
- **Chunk Data**: Pure generated data for a World Chunk before it becomes live Godot nodes: terrain ids, route segments, barriers, spawn markers, and proof hash.
- **Active Window**: The bounded set of World Chunks currently attached as scene nodes around the player.
- **Streaming Drag**: A brief speed/acceleration cap applied when high-speed driving approaches missing active terrain, buying the world streamer time to attach required chunks without showing blank space or blocking the player with an invisible wall.
- **Spawn Marker**: A deterministic generated record that can become a pickup, obstacle, zombie, blocker, or point of interest when its World Chunk is active.
- **Run Mutation**: Player-made change to deterministic generated content, such as collected fuel or a destroyed obstacle, saved by Spawn Marker id for the current run.
- **Arcade-Real Handling**: Vehicle feel target for v0: accessible arcade controls with believable car weight, momentum, drifting, terrain slowdown, and impact shove instead of instant twin-stick movement.
- **Handbrake Drift**: A player-triggered drift move that lets the car rotate sharply and slide through turns at the cost of traction and control.
- **Scrap**: The persistent between-run currency earned during a run and spent on simple car upgrades for later runs.
- **Permanent Upgrade**: A between-run improvement that persists across fresh Run Seeds and helps the player's car push farther in future runs.
- **Repair Pickup**: A rare in-run pickup that restores some Vehicle Damage without creating repair crafting, shop stops, or a repair economy.
- **Garage**: The between-run screen where Scrap is spent on Permanent Upgrades before starting a fresh Run Seed.
- **Stylized Survival Readability**: The v0 visual direction: bold high-contrast top-down art that makes terrain, routes, hazards, pickups, enemies, and the car instantly readable. It favors simple custom or procedural assets over photorealism or asset-pack polish.
