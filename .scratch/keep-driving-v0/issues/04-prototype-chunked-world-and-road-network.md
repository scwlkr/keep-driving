# Prototype Chunked World And Road Network

Type: prototype
Status: resolved
Blocked by: 02

## Question

Can a cheap Godot prototype prove endless chunk loading, terrain variation, road/path continuity, obstacle placement, and deterministic regeneration without obvious seams or runaway memory?

The answer should link the prototype artifact and state what should be kept, changed, or avoided for the build run.

## Answer

Resolved by grilling as a prototype acceptance contract. No runnable prototype artifact was created in this pass because scwlkr explicitly chose to resolve the frontier through the grilling method.

The later cheap Godot proof scene should prove the **world tech contract only**, not the full game fun target, combat model, final art, upgrade economy, or mobile export. It should be a throwaway, local-only Godot scene/project that is ugly but real enough to verify the generation behavior before the One-Shot Build Run.

Use the already-decided world constants as the proof baseline:

- `64 px` tiles.
- `32 x 32` tile chunks.
- Active radius `2` chunks around the player.
- Optional data preload radius `3`.

The proof must demonstrate a full 360-degree Free-Roaming World with a real Route Network. The player can drive in any direction, leave roads anywhere, cut across grass/dirt/rough offroad, route around barriers, and naturally rejoin roads or paths. Roads and paths are route advantages, not rails, corridors, or lane-runner tracks.

Minimum Route Network behavior:

- Multiple simultaneous route options, including roads, dirt paths, and offroad traces.
- Route continuity across chunk edges.
- Junctions and curves often enough that the world does not read as one endless center road.
- Bridges or shallows where useful routes cross water.
- No isolated per-chunk paths that visibly break at borders.

Water and barriers should force route planning. Deep water and major barriers are hard blockers unless crossed by a bridge or shallows. Shallows/mud are passable slow zones. The proof should make barrier decisions visible enough that the player can understand why a route is blocked or risky.

Spawn markers are part of this proof, using placeholder shapes if needed. Include deterministic markers for fuel/scrap, obstacles, enemy spawn points, and blockers. Marker ids must be stable by seed/chunk, reload identically after chunk unload/load, and support mutation proof such as a collected dummy pickup staying collected within the same run.

The seam pass/fail bar:

- No visible terrain gaps at chunk borders.
- Road/path segments meet at chunk borders.
- Water and barriers continue or terminate intentionally.
- Driving across chunk boundaries never puts the player into unloaded space.
- A debug overlay can show chunk boundaries, route exits, active chunks, and marker ids.

Required proof hooks:

- Same Run Seed plus same Chunk Coord produces the same chunk hash.
- Different Run Seeds change the origin chunk.
- Adjacent route exits match neighbors.
- Active chunks stay within the configured budget while driving fast.
- Marker ids are stable.
- Unload/reload preserves run mutations.

Keep for the build run: deterministic `ChunkData` generated from `RunSeed + ChunkCoord`, bounded active chunk windows, macro Route Network generation, marker-based spawning, deep-water/barrier routing, and debug/proof hooks.

Avoid in this proof: biome polish, final art tiles, enemy AI, pickup behavior, upgrade economy, finished UI, mobile export proof, and any implementation that turns the game into a route-following or lane-runner experience.

No new tickets are needed from this resolution. Existing tickets already cover combat/hazards, resources/progression, visual/audio direction, performance budget, and final Done Bar.
