# Prototype verdict

Status: implementation candidate with green automated/rendered contract checks; clean full-duration and human verdicts remain open. This is not production admission.

## Keep candidates

- Normalized keyboard/controller/replay intent with explicit neutral/source reset.
- Fixed 60 Hz Arcade-Real movement: rolling drag, brake-to-reverse, reverse steering, handbrake slip, progressive surface response, no stationary steering.
- Swept `CharacterBody2D` contact with light/medium/heavy response, one transition per contact, cooldown-aware recontact, breakable light barrier, Integrity damage, and held last-safe recovery.
- Dedicated look-ahead/impact camera with Reduced Motion.
- Authored SVG first road, connected surface routes, marked handling-lab fixtures, hero wagon, landmark/safehouse/threat/objective/resource/obstacle silhouettes, honest Fuel/Integrity/direction HUD, licensed fonts, and bounded dust/skid feedback.
- Licensed external three-layer engine, four surface families, three countable voices per impact family, two routine UI voices, reward/warning cues, named buses, pause/reset/dedupe behavior, and exact voice/resource diagnostics.
- Actual SceneTree 30/60/120 cadence comparison, rendered/performance artifact paths, raw RSS plateau evidence, and a frozen 15-category 896×414 human recognition harness that counts completed draws.

## Change or validate before graduation

- Balanced/Scout/Hauler values are deliberate differentiation probes, not final balance; five-player differentiation and preference evidence is pending.
- Visual readability, category recognition, color/contrast, route-choice comprehension, audible mix, and sensory equivalence require the frozen human cohorts.
- Controller mappings and feel require two assigned players on physical controllers; simulated input is insufficient.
- Audio sources are candidate material. Human audible/masking review decides keep/change/replace.
- Effects, route composition, camera impulse, Fuel reserve drain, and onboarding copy remain candidate-specific until the first-minute gate passes.

## Abandon

- Generated tones or cue counters as proof of audible quality.
- Runtime fallback geometry as the hero presentation direction.
- Variable-delta movement, instant terrain clamps, stationary steering, radius-only overlap damage, or synthetic render batching as production evidence.
- Debug vocabulary, fake resource facts, automated drivers, agents, or headless output as human playtest evidence.

## Evidence state

- Prototype smoke: green, including input, handling, collision, recovery, presentation, audio, HUD, camera, and effect contracts.
- Recognition contract: green at 896×414, 500 ms, 15 categories, 15 positive + 15 near-neighbor + 15 blank trials, deterministic candidate/participant seed.
- Render cadence: local debug proof green at 30/60/120 with exact matching final trace; clean candidate-retained rerun still required.
- Existing core tests and legacy proof floor: must remain green for the candidate commit.
- Dirty release export: refused by default.
- Clean macOS release export, two 1,800-second runs, retained first-60-second capture, physical controller, audible review, five handling players, ten naive hero/recognition players, P0/P1 closure, and Evidence/Product signoff: `PENDING`.

See `ASSET_MANIFEST.md` and `PLAYTEST_EVIDENCE.md`. `PENDING` is not a pass; ticket 08 remains claimed.
