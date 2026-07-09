# Infinite World Performance Budget Research

## Primary-source constraints

- Godot's profiler treats frame time as total work for a rendered image; `16.66ms` corresponds to the default `60 FPS` target. Source: https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html
- Godot optimization guidance says performance should be measured with profiling/timing and, especially for mobile targets, measured on more than one device when possible. Source: https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
- `Performance.get_monitor()` exposes runtime counters such as memory usage, draw calls, and FPS, matching the editor debugger monitor values. Source: https://docs.godotengine.org/en/stable/classes/class_performance.html
- `TileMapLayer` is the Godot 4.7 tilemap node; multiple `TileMapLayer` nodes replace deprecated multi-layer `TileMap` usage. TileMap updates are batched at the end of a frame, so chunk painting should be amortized rather than forced repeatedly. Source: https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
- Godot's TileMap guide says tilemaps are faster than placing individual `Sprite2D` nodes and support larger levels. Source: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
- The active scene tree is not thread-safe. Godot allows scene chunks to be built outside the active tree and then added on the main thread, but active-tree mutation should use deferred calls or stay on the main thread. Source: https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
- Background resource loading can be queued with `ResourceLoader.load_threaded_request()`, but retrieving before completion can block, so status checks should happen over frames. Source: https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html

## Budget recommendation

Desktop-local proof is the hard v0 performance gate. It must hold `60 FPS`, meaning `p95 frame time <= 16.7ms`, during high-speed travel through chunk boundaries. Mobile is an expectation for v0, not the hard gate yet: design for `30 FPS` minimum and `60 FPS` target on landscape mobile, with real-device export proof left to the later mobile-export decision.

Keep the already-decided world scale fixed:

- `64 px` tiles.
- `32 x 32` tiles per World Chunk.
- `2048 x 2048 px` per World Chunk.
- `25` active scene chunks (`active radius = 2`).
- `49` max preloaded data chunks (`preload radius = 3`).
- `25,600` active cells per TileMapLayer at worst case.

Live entity caps:

- `120` Zombies.
- `180` Obstacles/Roadblock pieces.
- `60` pickups.
- `40` active effects/debris.
- `400` total live/pooled world entities.
- `32` generated Spawn Markers per World Chunk, with normal target density around `12-20`.

Frame-work limits:

- World streaming and spawn work should stay under `4ms p95` inside the `16.7ms` frame.
- Attach/paint at most `1` new `ChunkNode` per frame.
- Generate pure `ChunkData` ahead of time and queue attach work across frames.

Fallback behavior:

- Preserve active terrain before optional preload or spawns.
- If the player reaches missing active terrain at extreme speed, apply Streaming Drag: briefly cap speed/acceleration, skip optional spawns/effects, and prioritize required terrain/route generation.
- Never show blank terrain, teleport the car, or use invisible walls as a streaming fallback.

## Required proof metrics

Add a `WorldPerfProof` overlay/log that reports:

- FPS.
- p95 frame time.
- p95 world-stream time.
- Active chunk count.
- Preloaded `ChunkData` count.
- Chunk attach queue length.
- Chunks attached this frame.
- Live entity counts by type.
- Marker count scanned.
- Skipped spawn count.
- Active object pool usage.
- Streaming Drag activations.

The proof passes only if a high-speed scripted drive stays inside budget for at least `3 minutes`.
