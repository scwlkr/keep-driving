# World Generation Architecture Research

## Recommendation

Use a deterministic chunk pipeline:

1. Generate pure `ChunkData` from `RunSeed + ChunkCoord`.
2. Render that data into pooled `ChunkNode` scenes on the main thread.
3. Keep only an active window of chunks around the player.
4. Save run state and player-made mutations, not full generated terrain.

This keeps the world Minecraft-like in spirit: same run stays stable when backtracking, new run gets a fresh seed, and the player can push farther with upgrades without the build needing authored maps.

## Primary-source constraints

- Godot 4.7 `TileMapLayer` is the current 2D tile map node; old `TileMap` is deprecated. It is single-layer, so multiple `TileMapLayer` nodes should be used for terrain, roads, overlays, and barriers. Source: https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
- Godot docs say tilemaps are faster than placing individual `Sprite2D` nodes and support larger levels, plus collision/navigation shapes on tiles. Source: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
- `TileMapLayer` updates are batched at end of frame; runtime tile updates can be expensive and should be limited. Source: https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
- `set_cells_terrain_path()` and `set_cells_terrain_connect()` can connect terrain/path tiles, but require complete terrain combinations in the TileSet. Source: https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
- `FastNoiseLite` exists in Godot 4.7 and provides several noise algorithms suitable for terrain classification; most values are usually in `[-1, 1]`, but not all algorithms guarantee that range. Source: https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html
- Godot `RandomNumberGenerator.seed` gives reproducible pseudo-random sequences for a given seed, but similar seeds may produce similar streams unless seed quality is improved. Source: https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
- The active scene tree is not thread-safe; Godot recommends `call_deferred()`/`set_deferred()` for tree interaction from threads, and says scene chunks can be created outside the active tree then added on the main thread. Source: https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
- `WorkerThreadPool` is available for offloading regular or group tasks, but every task must be waited for completion. Source: https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
- `AStarGrid2D` is a grid-specialized A* helper. `NavigationServer2D` is useful for navigation maps/agents but is marked experimental and does not handle `AStar2D`/`AStarGrid2D`. Sources: https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html and https://docs.godotengine.org/en/stable/classes/class_navigationserver2d.html
- Godot saving guidance starts by identifying persistent objects and serializing dictionaries/JSON-like data. Source: https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

## Runtime shape

Recommended nodes/services:

- `GameRoot`: owns boot, run lifecycle, profile, and UI.
- `RunDirector`: owns current `RunSeed`, distance, danger escalation, spawn pressure, and run-end state.
- `WorldRuntime`: tracks player position, active chunk window, generation queue, chunk attach/detach, and proof metrics.
- `WorldGenerator`: pure deterministic service. Input is `RunSeed`, `ChunkCoord`, and neighboring macro-route context; output is `ChunkData`. It should not touch the scene tree.
- `ChunkNode`: rendered/interactive scene for one chunk. Owns `TileMapLayer` children and spawned obstacle/enemy/pickup instances.
- `SpawnDirector`: converts deterministic spawn markers into live entities, enforces caps, and records destroyed/collected mutations.
- `WorldProof`: debug/test API that hashes chunks, reports active counts, and validates continuity.

Recommended chunk scale for v0:

- Tile size: `64 px`.
- Chunk size: `32 x 32 tiles`.
- World size per chunk: `2048 x 2048 px`.
- Active radius: `2 chunks` around current chunk, so normally `5 x 5 = 25` chunks live.
- Optional preload radius: `3 chunks` for data-only generation, but do not attach all preloaded chunks as nodes.

## Data structures

Use small pure-data records:

- `ChunkCoord`: `Vector2i(cx, cy)`.
- `TileCoord`: `Vector2i(tx, ty)`.
- `ChunkData`:
  - `coord: Vector2i`
  - `run_seed: int`
  - `terrain: PackedByteArray` of terrain ids
  - `road_mask: PackedByteArray`
  - `barrier_mask: PackedByteArray`
  - `route_segments: Array[PackedVector2Array]`
  - `spawn_markers: Array[Dictionary]`
  - `proof_hash: int`
- `SpawnMarker` dictionary:
  - `id: String`
  - `kind: String`
  - `tile: Vector2i`
  - `danger: float`
  - `route_bias: String`
- `RunMutation`:
  - deterministic marker id -> collected/destroyed/damaged state
- `WorldIndex`:
  - active chunk coord -> `ChunkNode`
  - cached chunk coord -> `ChunkData`
  - mutation key -> `RunMutation`

For implementation, typed dictionaries or lightweight classes/resources are fine; the important boundary is pure `ChunkData` before scene nodes.

## Generation pipeline

1. Convert player world position to current `ChunkCoord`.
2. Compute desired chunk coords inside active radius.
3. For missing coords, queue `WorldGenerator.generate_chunk(run_seed, coord)`.
4. Generate terrain from seeded noise and route context:
   - base terrain: grass, dirt, rough, water
   - barriers: water, dense wreckage, heavy debris
   - routes: roads, dirt paths, bridge/shallows crossings
5. On the main thread, attach a `ChunkNode`:
   - set terrain tiles on `TileMapLayer`
   - draw road/path layer
   - draw water/barrier layer
   - spawn markers through `SpawnDirector`
6. Remove chunks outside active radius:
   - despawn/pool live entities
   - keep only `RunMutation` and optional `ChunkData` cache
7. Expose proof metrics every frame/test:
   - active chunk count
   - generated chunk count
   - spawned entity counts
   - continuity failures

## Terrain and route generation

Use two generation systems that meet inside each chunk:

1. Noise fields for terrain.
   - `FastNoiseLite` fields classify grass/dirt/rough/water.
   - Use different frequencies for broad biome shape vs local texture.
   - Water should produce route-planning barriers, not tiny random puddle noise everywhere.

2. Macro route graph for roads and paths.
   - Partition the world into larger macro cells, e.g. `4 x 4 chunks`.
   - Each macro cell deterministically creates junction candidates and border anchors from `RunSeed + MacroCoord`.
   - Connect anchors to neighboring macro cells so routes continue across chunk boundaries.
   - Rasterize route segments into chunk tile coordinates.
   - Roads get wider/smoother tiles; dirt paths are narrower and may break or bend more.
   - When a route crosses water, generate a bridge/shallows marker instead of deleting the route.

Do not generate roads by isolated per-chunk noise. That will create seams, dead roads, and a less intentional Route Network.

## Spawn rules

Use deterministic spawn markers, not ad hoc live spawns:

- Marker id should include run seed, chunk coord, local tile, and kind.
- Roads and bridges attract more blockers/enemies because they are faster and tempting.
- Offroad has fewer enemies but worse handling and lower pickup density.
- Fuel/scrap should spawn near risk: roadblocks, wreck clusters, bridge approaches, and abandoned structures.
- No enemies/obstacles inside an origin safe radius.
- Distance from origin increases danger, enemy counts, and obstacle density.
- `SpawnDirector` enforces live caps so old chunks cannot leave behind unbounded entities.

## Cleanup strategy

- Attach at most the active radius as scene nodes.
- Pool common entities: zombies, hostile blockers, fuel, scrap, light obstacles, impact effects.
- Remove or sleep entities when their chunk unloads.
- Keep mutations by deterministic marker id so collected fuel or destroyed obstacles stay gone if the player backtracks in the same run.
- Avoid forcing TileMap internals after every change; batch chunk painting and let the frame update handle it unless a proof script specifically needs sync.

## Save implications

Save:

- profile/upgrades
- active run seed
- player position, vehicle state, fuel, damage
- current run stats
- mutation map keyed by deterministic marker id

Do not save:

- full terrain arrays for every generated chunk
- all inactive enemy nodes
- regenerated roads/water/base terrain

New run means new `RunSeed` and empty run mutations. Permanent upgrades persist separately.

## Proof hooks

Add headless proof scripts during implementation:

- Same seed + same chunk coord produces identical `proof_hash`.
- Different run seed changes origin-area chunks.
- Adjacent chunks share route exits and water/bridge continuity at borders.
- The origin has at least one reachable route and no spawn inside the safe radius.
- A simulated drive across chunk boundaries keeps active chunk count within budget.
- Collected/destroyed marker mutations persist after chunk unload/reload.
- Spawn caps are enforced under high-speed travel.

## Rejected approaches

- One huge `TileMapLayer`: simple at first, but not endless and will accumulate memory/work.
- Per-chunk-only roads: fast to generate, but likely seams and dead-end noise rather than a believable Route Network.
- NavigationServer2D as the world generator: useful later for agents, but too heavy/experimental for primary generation. Use custom route graph plus optional `AStarGrid2D`/navigation for enemy movement later.
- Saving full chunks: wastes disk and fights the Run Seed model.
