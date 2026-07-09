# Build 02 Deterministic World And Streaming

Type: build
Owner: parallel worker
Status: done
Blocked by: build-01

## Scope

- Implement `RunSeed`, `WorldChunk`, `ChunkData`, deterministic generation from `RunSeed + ChunkCoord`, marker ids, mutation tracking, and bounded chunk streaming.
- Use `64 px` tiles, `32 x 32` tiles per World Chunk, active radius `2`, and optional preload radius `3`.
- Keep terrain rendering ready for `TileMapLayer` chunk nodes, not one node per terrain cell.

## Acceptance

- Same seed and chunk coordinate produce stable chunk hashes.
- Different seeds change the origin chunk.
- Active and preloaded chunk budgets hold while simulating movement.
- Marker mutations persist after unload and reload.

## Proof

- Automated checks in `res://tests/run_all.gd`.

## Agent Report

- Changed files: `scripts/world_generator.gd`, `scripts/world_runtime.gd`, `proofs/world_perf_proof.gd`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`
- Proof outputs:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
  - `WORLD_PERF_PROOF frames=10800 fps=1730.7 p95_frame_ms=1.153 p95_stream_ms=0.932 active_chunks=25 preloaded_chunks=49 attach_queue_max=24 chunks_attached_frame_max=1 zombies=120 obstacles=150 pickups=40 effects=0 markers_scanned=673 skipped_spawns=485 pool_total=310 pool_usage=310/400 streaming_drag_activations=1 streaming_drag_frames=12 blank_terrain_risk_frames=0 pass=true`
- Known gaps: none for build-02 scope.
- Commit hash:
