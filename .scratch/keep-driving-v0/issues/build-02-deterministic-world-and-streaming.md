# Build 02 Deterministic World And Streaming

Type: build
Owner: unclaimed
Status: todo
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

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
