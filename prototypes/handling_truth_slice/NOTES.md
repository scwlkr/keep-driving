# Prototype verdict

Status: smoke-tested spike — human handling/hero-minute verdict still open. Do not treat this code as production.

## Keep

- One normalized keyboard/controller/simulated `DriveIntent` shape.
- Fixed 60 Hz stepping with no stationary steering rotation and progressive surface speed response.
- Rolling drag instead of infinite coasting.
- Real `CharacterBody2D` collision shape, one impact transition per contact, cooldown, weight telemetry, and Integrity damage.
- Camera look-ahead/zoom facts kept outside the route/HUD.
- Isolated authored first-road scene and real generated PCM audio path; neither touches saves or the current main scene.

## Change

- Balanced, Scout, and Hauler presets now create distinct speed/acceleration/turn/grip/impact-resistance tradeoffs, but their exact values remain demonstration tuning rather than balance defaults; five-player differentiation and preference evidence is pending.
- Dirt/mud fork bands are intentionally oversized and visually crude; the proof-region prototype needs actual authored road geometry and sightline validation.
- Auto-gas is a prototype inspection aid, not a settled default control decision.
- Visible inspection caught auto-gas coasting beyond the authored endpoint; the helper now applies brake after relay detection and the base road drawing extends beyond the test route.
- The route currently proves one relay/return instruction, not extraction/economy or full first-expedition comprehension.
- Audible quality, handling satisfaction, controller feel, full-duration rendered percentiles, and five-player comprehension remain unverified.

## Abandon

- Empty `AudioStreamGenerator` plus cue-counter evidence as a claim of audible feedback.
- Direct variable-delta movement, instantaneous terrain speed clamps, stationary steering, and radius-only repeated-overlap contacts as the production vehicle path.
- Treating a headless parse/simulation as human playtest evidence.

## Evidence

- Planning baseline commit: `6a3767c`.
- Audio helper commit: `9cacae7`.
- Integrated scene boot: Godot 4.7 headless, exit 0.
- Prototype smoke: `PROTOTYPE_HANDLING_SMOKE road=620.6 dirt=462.8 mud=272.0 scout=681.6 hauler=537.0 tunes=speed_turn_grip_impact fixed_step_batch_30_60_120=true impacts=light_medium_heavy full_reset=true pcm=true pass=true`.
- Prototype-only clean macOS release export from `a8c00766d18aee6b01ccdca689dfa4440a5049af`: embedded provenance matches the clean commit; neutral internal bundle ID; universal arm64/x86_64 binary; ad-hoc signature verifies; 165,636 KiB app bundle. The default shipping scene remains unchanged.
- Short clean-export feel harness validation, not final acceptance: 15 measured seconds after five-second warm-up on MacBookPro18,2/M1 Max/64 GB, macOS `27.0.0`, 1920 x 1080 output/1280 x 720 logical, GL Compatibility, VSync on; 119.0 average FPS; p50 8.333 ms; p95/p99 9.091 ms; worst 11.820 ms; 178.531 MB maximum 1 Hz sampled RSS, 20/20 samples with zero failures; 25 nodes; 28 draw calls; `harness_pass=true`, `acceptance_pass=false`.
- Short clean-export capacity harness validation, not final acceptance: same build/machine/output/logical/renderer, VSync off; 689.4 average FPS; p50 1.389 ms; p95 1.667 ms; p99 1.852 ms; worst 15.053 ms; 180.813 MB maximum 1 Hz sampled RSS, 20/20 samples with zero failures; 25 nodes; 28 draw calls; `harness_pass=true`, `acceptance_pass=false`.
- Raw structured evidence: `proofs/handling_truth_slice_benchmark_a8c0076.json`.
- Existing main regression: `ALL_KEEP_DRIVING_PROOFS_PASSED` and landscape proof `pass=true`.
- Visible desktop inspection: Garage lot/HUD/route fork render; auto-gas reaches and brakes at the relay; light impact reduced Integrity; telemetry is hidden by default. Retained capture: `proofs/handling_truth_slice_relay.jpeg`.
- Clean exported 1,800-second feel/VSync-on and capacity/VSync-off rendered performance runs, external peak/plateau-memory capture, and retained first-60-second video: pending. The short clean-release runs above validate the harness only; headless, dirty, mismatched-provenance, short, or debug runs cannot set `acceptance_pass=true`.
- Human audible check: pending.
- Physical controller pass: pending.
- Five-player handling/hero-minute session: pending.
