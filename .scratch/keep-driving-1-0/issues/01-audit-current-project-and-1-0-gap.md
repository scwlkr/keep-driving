# Audit Current Project And 1.0 Gap

Type: research
Status: resolved
Blocked by:

## Question

What exactly exists in the current repository and playable desktop build, what evidence proves it, what should be retained/refactored/replaced, and what product, design, content, technical, presentation, mobile, production, and release gaps separate it from a credible Keep Driving 1.0.0?

Resolve with concrete repository references, fresh proof output, a playable-build inspection, a risk register, unknowns with validation methods, and a durable `docs/CURRENT_STATE_AUDIT.md`.

## Answer

The repository is a coherent Godot 4.7 playable v0/pre-alpha, not a production alpha or App Store candidate. Its end-to-end Start/Run/Results/Garage/Restart loop, deterministic `RunSeed + ChunkCoord` contract, bounded 25-active/49-preloaded streaming, basic Arcade-Real handling vocabulary, RunProgression boundary, and fast proof floor are worth retaining.

The production gaps are foundational: `GameRoot` owns nearly every concern; vehicle movement is variable-delta `Node2D` motion with radius-only contacts; the world is repetitive four-spoke procedural scaffolding; the Garage has only nine monotonic purchases; the profile is one unversioned non-atomic JSON file; UI/art are default/procedural placeholders; audio is effectively silent because empty generators receive no frames; mobile evidence is one viewport simulation; and no export/CI/iOS/App Store infrastructure exists.

Fresh evidence on 2026-07-11:

- Core suite: `ALL_KEEP_DRIVING_PROOFS_PASSED`.
- Automated 600-second loop simulation: `pass=true`.
- 896 x 414 landscape simulation: `pass=true`.
- World performance: 10,800 frames, 142.1 FPS, 7.852 ms p95 frame, 1.102 ms p95 stream, 25 active/49 preloaded chunks, 310 entities, zero blank-risk frames, `pass=true`.
- Visible desktop build: launches and runs, but default Godot UI, debug text, block tiles, procedural silhouettes, and absent production audio confirm the presentation gap.

Retain the deterministic/streaming/progression/proof seams; deeply refactor application, vehicle, world, catalog, UI/audio, save, and test ownership; replace the prototype content/presentation/collision/upgrade/save implementations. The largest unknowns now have explicit handling, hybrid-world, buildcraft, hero-minute, save-fault, full-stack-performance, and later signed-iOS validation gates.

Durable detail: [`docs/CURRENT_STATE_AUDIT.md`](../../../docs/CURRENT_STATE_AUDIT.md). The complete route and target decisions are indexed from [`docs/ROADMAP_TO_1.0.md`](../../../docs/ROADMAP_TO_1.0.md).
