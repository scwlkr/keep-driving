# Choose World Generation Architecture

Type: research
Status: resolved
Blocked by: 01

## Question

What Godot 4.7 architecture should generate an endless Free-Roaming World with roads, paths, grass, dirt, offroad, obstacles, enemies, pickups, and stable deterministic chunks?

The answer should recommend data structures, chunk sizing, noise/path generation approach, spawn rules, cleanup strategy, save implications, and proof hooks for automated verification.

## Answer

Use the deterministic chunk architecture described in [World Generation Architecture Research](../research/02-world-generation-architecture.md).

The core decision: generate pure `ChunkData` from `RunSeed + ChunkCoord`, then render/spawn that data into `ChunkNode` scenes inside a bounded active window around the player. This preserves Minecraft-like stable backtracking within a run, supports fresh worlds per restart, and avoids saving huge generated maps.

For v0, use `64 px` tiles, `32 x 32` tile chunks, and an active radius of `2` chunks around the player. That keeps a normal live window of `25` chunks while still feeling broad on a landscape phone. Data-only preloading can extend to radius `3`, but attached scene nodes should stay bounded.

Terrain should come from seeded `FastNoiseLite` fields plus deterministic classification into grass, dirt, rough, water, roads, paths, bridges/shallows, and barriers. Roads and paths should not be isolated per-chunk noise. Use a larger macro Route Network: deterministic macro cells create junctions/border anchors, connect to neighbors, then rasterize route segments into chunks. This gives multiple roads/paths/offroad options while keeping chunk borders continuous.

Rendering should use multiple `TileMapLayer` nodes: base terrain, roads/paths, water/barriers, and optional detail/overlay. Avoid one node per visual item for terrain. Spawn enemies, pickups, and obstacles from deterministic spawn markers after terrain is rendered.

Spawn rules should be marker-based and budgeted. Roads/bridges attract more blockers and enemies because they are fast and tempting; offroad is slower and safer but can hide salvage. Fuel/scrap spawn near risk. Distance from origin increases danger. No hostile spawns inside an origin safe radius. Every marker gets a deterministic id so destroyed obstacles and collected pickups can stay gone after unload/reload within the same run.

Cleanup should unload scene chunks outside the active radius, pool common live entities, and store only run mutations plus optional cached `ChunkData`. Save profile/upgrades, active run seed, player/vehicle state, run stats, and mutation ids. Do not save generated terrain arrays for every chunk.

Proof hooks required for implementation: same seed/chunk hash is stable; different run seeds change origin chunks; adjacent chunks share route exits and water/bridge continuity; origin has an escape route and safe radius; high-speed simulated travel keeps active chunks within budget; marker mutations persist after chunk reload; spawn caps hold under pressure.
