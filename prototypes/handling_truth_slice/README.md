# PROTOTYPE — Handling Truth Slice

Question: can fixed-step production-candidate handling, real collision, one authored route choice, honest HUD facts, and audible feedback support Keep Driving's first minute?

This is disposable Phase-2 learning code. It does not replace the current game, save data, or main scene.

Run it in one command:

```sh
/opt/homebrew/bin/godot --path /Users/shanewalker/Desktop/dev/keep-driving res://prototypes/handling_truth_slice/prototype.tscn
```

Controls:

- `W` gas
- `S` brake/reverse
- `A` / `D` steer
- `Space` handbrake
- `G` prototype auto-gas toggle
- `R` reset
- `T` full prototype telemetry
- `1` balanced tune / `2` scout tune / `3` hauler tune
- `Esc` quit
- Controller: left stick, triggers, and south face button when connected

The relevant acceptance criteria live in `docs/ROADMAP_TO_1.0.md` under **Desktop Truth Slice A — Production Handling and the First Road**.

Quick non-human smoke:

```sh
/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://prototypes/handling_truth_slice/prototype_smoke.gd
```

Create the isolated clean macOS release export with embedded commit/dirty provenance (requires the official Godot 4.7 `macos.zip` template):

```sh
./scripts/export_handling_truth_slice.sh /tmp/HandlingTruthSlice.app
```

Rendered benchmark harness (60 measured seconds after five-second warm-up):

```sh
'/tmp/HandlingTruthSlice.app/Contents/MacOS/Handling Truth Slice' --resolution 1920x1080 -- --prototype-benchmark-mode=feel --prototype-build-id=GIT_COMMIT_SHA --prototype-benchmark-seconds=60 --prototype-benchmark-warmup=5
```

Repeat with `--prototype-benchmark-mode=capacity` for the VSync-off capacity capture. The harness rejects a supplied SHA that does not match the clean commit embedded by the export script. The final milestone gate requires both 1,800-second runs from a clean release export plus an external peak/plateau-memory capture; `acceptance_pass` remains false for debug or shorter runs.
