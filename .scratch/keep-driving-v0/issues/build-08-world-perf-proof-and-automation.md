# Build 08 World Perf Proof And Automation

Type: build
Owner: unclaimed
Status: todo
Blocked by: build-02, build-03, build-05

## Scope

- Implement `WorldPerfProof`: a 3-minute high-speed scripted drive.
- Gate desktop proof at `60 FPS` and `p95 frame time <= 16.7ms`.
- Target streaming/spawn work p95 at `<= 4ms`.
- Attach/paint at most `1` new `ChunkNode` per frame.
- Use Streaming Drag if high-speed travel approaches missing active terrain.

## Acceptance

- Perf proof logs FPS, p95 frame time, p95 world-stream time, active chunk count, preloaded `ChunkData` count, attach queue length, chunks attached this frame, entity counts by type, marker count scanned, skipped spawn count, pool usage, and Streaming Drag activations.
- No blank terrain, teleporting, or invisible-wall fallback appears in proof.

## Proof

- `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`

## Agent Report

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
