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
- Prototype smoke: `PROTOTYPE_HANDLING_SMOKE road=620.6 dirt=462.8 mud=272.0 scout=681.6 hauler=537.0 tunes=true fixed_step_batch_30_60_120=true impacts=light_medium_heavy full_reset=true pcm=true pass=true`.
- Prototype-only clean macOS release export succeeds with neutral internal bundle ID and ad-hoc signing; the default shipping scene remains unchanged.
- Short clean-export feel harness validation, not final acceptance: 15 measured seconds after five-second warm-up, 1920 x 1080 output/1280 x 720 logical, GL Compatibility, VSync on; 119.5 average FPS; p50 8.333 ms; p95 9.016 ms; p99 9.091 ms; worst 14.188 ms; 180.719 MB peak RSS; 25 nodes; 28 draw calls; `pass=true`, `acceptance_pass=false`.
- Short clean-export capacity harness validation, not final acceptance: same output/logical/renderer, VSync off; 695.2 average FPS; p50 1.389 ms; p95 1.667 ms; p99 1.852 ms; worst 13.527 ms; 178.797 MB peak RSS; 25 nodes; 28 draw calls; `pass=true`, `acceptance_pass=false`.
- Existing main regression: `ALL_KEEP_DRIVING_PROOFS_PASSED` and landscape proof `pass=true`.
- Visible desktop inspection: Garage lot/HUD/route fork render; auto-gas reaches and brakes at the relay; light impact reduced Integrity; telemetry is hidden by default. Retained capture: `proofs/handling_truth_slice_relay.jpeg`.
- Clean exported 1,800-second feel/VSync-on and capacity/VSync-off rendered performance runs plus retained first-60-second capture: pending. The short debug run above validates the harness only; headless/short/debug runs cannot set `acceptance_pass=true`.
- Human audible check: pending.
- Physical controller pass: pending.
- Five-player handling/hero-minute session: pending.
