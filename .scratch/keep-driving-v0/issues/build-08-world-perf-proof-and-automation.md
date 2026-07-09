# Build 08 World Perf Proof And Automation

Type: build
Owner: parallel worker
Status: done
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

- Changed files: `proofs/world_perf_proof.gd`, `scripts/world_runtime.gd`, `scripts/world_generator.gd`
- Proof commands:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`
  - `/opt/homebrew/bin/godot --path /Users/shanewalker/Desktop/dev/keep-driving --script res://proofs/world_perf_proof.gd`
- Proof outputs:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
  - Headless render-enabled: `WORLD_PERF_PROOF frames=10800 fps=140.4 p95_frame_ms=7.748 p95_stream_ms=1.373 active_chunks=25 preloaded_chunks=49 attach_queue_max=24 chunks_attached_frame_max=1 blank_terrain_risk_frames=0 pass=true`
  - Desktop rendered: `WORLD_PERF_PROOF frames=10800 fps=116.6 p95_frame_ms=14.598 p95_stream_ms=0.964 active_chunks=25 preloaded_chunks=49 attach_queue_max=24 chunks_attached_frame_max=1 blank_terrain_risk_frames=0 pass=true`
- Known gaps: none for build-08 scope.
- Commit hash: 3139719 plus final manager integration
