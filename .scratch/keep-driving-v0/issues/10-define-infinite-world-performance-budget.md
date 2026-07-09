# Define Infinite World Performance Budget

Type: research
Status: resolved
Blocked by: 02

## Question

What concrete performance and memory budget should Playable v0 enforce for the deterministic chunk world?

The answer should define active/preloaded chunk limits, tile/entity caps, acceptable frame-time targets for desktop proof and landscape mobile expectations, profiler/proof metrics, and what implementation should do if generation or spawning falls behind at high speed.

## Grilling Notes

- Desktop proof is the hard v0 performance gate: high-speed chunk travel must hold `60 FPS` with `p95 frame time <= 16.7ms`. Mobile stays an expectation for v0: `30 FPS` minimum, `60 FPS` target, with real-device export proof left to the later mobile-export decision.
- v0 locks the chunk window to `25` active scene chunks (`active radius = 2`) plus at most `49` data-preloaded chunks (`preload radius = 3`). If generation falls behind, preserve active terrain first and degrade optional preload/spawns.
- v0 keeps the existing fixed world scale: `64 px` tiles, `32 x 32` tiles per World Chunk, `2048 x 2048 px` per chunk, and no variable chunk sizes. Worst-case active terrain is `25,600` cells per TileMapLayer across active chunks.
- v0 caps live world entities at `400` total: `120` Zombies, `180` Obstacles/Roadblock pieces, `60` pickups, and `40` active effects/debris. When Pursuit Pressure wants more, skip low-priority spawns far from the player before sacrificing frame rate.
- v0 caps generated Spawn Markers at `32` per World Chunk, with normal target density around `12-20`. Marker records may exist across active/preloaded data, but only the live entity caps may instantiate.
- Desktop proof includes explicit world-work limits: streaming/spawn work should stay under `4ms p95` inside the `16.7ms` frame, no more than `1` newly attached `ChunkNode` should be painted per frame, and extra work should queue instead of spiking.
- If the player reaches an unloaded edge at extreme speed, v0 uses Streaming Drag: briefly cap top speed/acceleration, skip optional spawns/effects, and prioritize terrain/route generation. Never show blank terrain, teleport, or use an invisible wall.
- v0 proof should expose a `WorldPerfProof` overlay/log with FPS, p95 frame time, p95 world-stream time, active chunk count, preloaded `ChunkData` count, attach queue length, chunks attached this frame, live entity counts by type, marker count scanned, skipped spawn count, object pool usage, and Streaming Drag activations. Passing requires at least a `3 minute` high-speed scripted drive inside budget.

## Answer

Use the performance budget captured in [Infinite World Performance Budget Research](../research/10-infinite-world-performance-budget.md).

Desktop-local proof is the hard v0 gate: high-speed chunk travel must sustain `60 FPS`, measured as `p95 frame time <= 16.7ms`. Landscape mobile remains an expectation for this map stage, not the hard proof gate: design for `30 FPS` minimum and `60 FPS` target, with real-device export proof handled by the later mobile-export decision.

Keep the existing world scale fixed for v0: `64 px` tiles, `32 x 32` tiles per World Chunk, `2048 x 2048 px` per chunk, `25` active scene chunks, and at most `49` data-preloaded chunks. Do not support variable chunk sizes in v0. Worst-case active terrain is `25,600` cells per `TileMapLayer` across active chunks.

Cap live world entities at `400` total: `120` Zombies, `180` Obstacles/Roadblock pieces, `60` pickups, and `40` active effects/debris. Cap generated Spawn Markers at `32` per World Chunk, with normal density closer to `12-20`. Markers can exist as deterministic data, but only capped live entities may instantiate.

World streaming and spawn work should stay under `4ms p95` inside the `16.7ms` frame. Generate pure `ChunkData` ahead of the player, then amortize scene attachment so no more than `1` newly attached `ChunkNode` is painted per frame. If pressure or speed outruns the budget, preserve required active terrain first, then drop optional preload, optional spawns, and effects.

If the car reaches missing active terrain at extreme speed, use Streaming Drag: briefly cap top speed/acceleration while prioritizing route/terrain generation. Never show blank terrain, teleport the car, or block with an invisible wall.

The build run should include a `WorldPerfProof` overlay/log with FPS, p95 frame time, p95 world-stream time, active chunk count, preloaded `ChunkData` count, attach queue length, chunks attached this frame, live entity counts by type, marker count scanned, skipped spawn count, object pool usage, and Streaming Drag activations. The proof passes only if a high-speed scripted drive stays inside budget for at least `3 minutes`.

This resolution makes the mobile-export fog specific enough to ticket. It graduated into [Decide Mobile Export Proof Depth](11-decide-mobile-export-proof-depth.md), which should resolve before [Define v0 Done Bar And Proof Plan](07-define-v0-done-bar-and-proof-plan.md).
