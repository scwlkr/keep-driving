# PROTOTYPE — Handling Truth Slice

Question: can fixed-step production-candidate handling, real collision, an authored first-road choice, honest HUD facts, and final-pipeline feedback support Keep Driving's first minute?

This is isolated Phase-2 learning code. It does not replace the current game, saves, or default scene. Ticket 08 remains open until the clean release, performance, physical-controller, audible, and frozen human gates pass.

## Drive the slice

```sh
/opt/homebrew/bin/godot --path /Users/shanewalker/Desktop/dev/keep-driving res://prototypes/handling_truth_slice/prototype.tscn
```

- `W` gas; `S` brake/reverse; `A` / `D` steer
- `Space` handbrake; hold `E` to recover; `R` reset
- `M` Reduced Motion; `Esc` quit
- Controller: left stick, triggers, south face button handbrake, north face button recovery
- Debug builds only: `G` auto-drive, `T` telemetry, `1` / `2` / `3` tune probes
- Frozen handling lab: launch the release app with `-- --prototype-lab-mode --prototype-tune=balanced` (or `scout` / `hauler`); tune keys are then facilitator-only

## Automated contracts

```sh
/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://prototypes/handling_truth_slice/prototype_smoke.gd
/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://prototypes/handling_truth_slice/recognition/recognition_contract_test.gd
./scripts/verify_handling_truth_slice_render_cadence.sh
```

The smoke covers normalized input/source reset, device-family glyphs, fixed-step surface/tune response, brake-to-reverse, reverse steering, handbrake slip, held recovery, the marked slalom/braking/stuck lab fixtures, high-speed thin collision, contact cooldown/recontact, breakable light barrier/full reset, honest HUD/camera diagnostics, countable audio pools/routing/pause-resume, authored presentation, and bounded effects. The cadence verifier renders the actual SceneTree at 30/60/120 Hz and compares the exact 60 Hz final trace.

The command above is explicitly unbound editor/debug cadence. After the clean export, retain candidate-bound cadence with `HANDLING_TRUTH_SLICE_BIN='/tmp/HandlingTruthSlice.app/Contents/MacOS/Handling Truth Slice' HANDLING_TRUTH_SLICE_SHA="$(git rev-parse HEAD)" ./scripts/verify_handling_truth_slice_render_cadence.sh ABSOLUTE_OUTPUT_DIR`.

The human-operated 896×414 recognition harness, frozen-candidate contract, rendered preview bundle, and immutable-output rules are documented in `recognition/README.md`. Automated or agent runs never count as participants.

## Candidate export and evidence

The normal release export refuses a dirty worktree:

```sh
./scripts/export_handling_truth_slice.sh /tmp/HandlingTruthSlice.app
./scripts/freeze_handling_truth_slice_candidate.sh /tmp/HandlingTruthSlice.app "$PWD/proofs/handling_truth_slice/ticket-08/candidate.json"
```

For non-acceptance debugging only, set `ALLOW_DIRTY_HANDLING_EXPORT=1`; provenance will still record `dirty=true`. A clean app embeds its commit/dirty identity, export engine/time/package facts, font licenses, and `ASSET_MANIFEST.md`. The immutable candidate contract adds the signed app/executable/PCK hashes and sizes plus exact macOS, hardware, display, audio-output, power, renderer/view, scene/seed/profile, and source-contract facts.

Rendered benchmark example:

```sh
sha="$(git rev-parse HEAD)"
repo="$PWD"
'/tmp/HandlingTruthSlice.app/Contents/MacOS/Handling Truth Slice' --resolution 1920x1080 -- --prototype-benchmark --prototype-benchmark-mode=feel --prototype-build-id="$sha" --prototype-benchmark-seconds=1800 --prototype-benchmark-warmup=5 --prototype-benchmark-require-acceptance --prototype-benchmark-report="$repo/proofs/handling_truth_slice/ticket-08/performance/feel-report.json" --prototype-benchmark-rss="$repo/proofs/handling_truth_slice/ticket-08/performance/feel-rss.json"
```

Repeat with `--prototype-benchmark-mode=capacity`. Each run records rendered frame percentiles, raw RSS/plateau, world work, collision queries, nodes/draws, effects/particles, audio voices, final trace, and artifact paths. An individual benchmark can attest only that run; `milestone_acceptance_pass` stays false because paired-run, controller, audio, and human evidence remain external.

Measurement is bounded and self-auditing: feel mode uses VSync plus an explicit 60 FPS cap, capacity mode is uncapped with VSync off, and cadence targets override both. Frame/world percentiles use fixed-memory 0.01 ms histograms with exact counts/sums/worst values. Full runs collect RSS on a worker thread every 10 seconds; any missed interval, probe failure, or start more than 250 ms late invalidates the run. Slow frames retain a bounded timestamp/physics/cycle trace. Failed candidate evidence is never overwritten and lives under `proofs/handling_truth_slice/ticket-08/history/<source-commit>/`.

Acceptance contract: `docs/ROADMAP_TO_1.0.md` → **Desktop Truth Slice A — Production Handling and the First Road**. Candidate provenance and human rules: `ASSET_MANIFEST.md` and `PLAYTEST_EVIDENCE.md`.
