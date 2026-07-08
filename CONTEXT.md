# Context

## Glossary

- **One-Shot Build Run**: A single user launch prompt after which Codex coordinates as many sessions and parallel agents as needed to build and verify the playable v0 without requiring the user to manage intermediate steps.
- **Playable v0**: The first complete version of the game that can be run locally, played end to end, and verified against an explicit done bar.
- **Free-Roaming World**: A full 360-degree top-down world where the player can drive in any direction across roads, paths, grass, dirt, and offroad terrain.
- **Road Advantage**: Roads and paths are faster or safer routes through the Free-Roaming World, but they are not hard boundaries; the player may leave them at any time.
- **Road Warrior Survival Expedition**: The core player fantasy for v0: driving a beat-up car across an endless hostile world where roads are fast but dangerous, and offroad routes are slower escape/exploration options.
- **Route Network**: The generated world contains multiple possible roads, dirt paths, offroad traces, and terrain routes at once. The player is choosing among routes in an open world, not choosing between one road and one offroad lane.
- **Traversal Barrier**: A generated feature, such as water, cliffs, dense wreckage, or heavy debris, that meaningfully blocks or slows travel and forces route planning in the Free-Roaming World.
- **Run Seed**: The random seed used to generate one survival run. World chunks remain stable while that run is active; a new run uses a fresh Run Seed so returning to the origin starts a different adventure.
- **Miles Driven**: The headline run score for v0, based primarily on how far the player gets from the origin while surviving.
