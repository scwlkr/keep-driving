# Handling Truth Slice Human Evidence Contract

Status: `NOT_STARTED`. Contract frozen 2026-07-12; every candidate field and result below is honestly `PENDING`.

Scope: ticket-08 handling-lab and first-60-seconds/hero-minute evidence only. This cannot pass the rest of Roadmap Phase 2, substitute for rendered/performance evidence, or authorize asset-family multiplication. Implementers, agents, automated drivers, and prior viewers cannot count as players.

## Candidate freeze

No session is valid until every field is populated in `proofs/handling_truth_slice/ticket-08/candidate.json` before the player sees the build.

| Frozen field | Required value | Current result |
|---|---|---|
| Source commit | Full 40-character Git SHA | `PENDING` |
| Worktree state | Clean; `dirty=false` | `PENDING` |
| Embedded build identity | `/tmp/HandlingTruthSlice.app/Contents/Resources/handling-truth-slice-provenance.json`; commit equals source commit and `dirty=false` | `PENDING` |
| Export | `./scripts/export_handling_truth_slice.sh /tmp/HandlingTruthSlice.app`; preset `Handling Truth Slice macOS`; release build | `PENDING` |
| Executable | `/tmp/HandlingTruthSlice.app/Contents/MacOS/Handling Truth Slice`; SHA-256 recorded | `PENDING` |
| Engine/importer | Godot `4.7.stable.official.5b4e0cb0f`; matching official release templates | `PENDING` |
| Renderer/view | GL Compatibility; 1280 x 720 logical viewport; session display/output/scale/VSync recorded | `PENDING` |
| Scene/seed/profile | `res://prototypes/handling_truth_slice/prototype.tscn`; clean reset; frozen candidate scenario and seed recorded | `PENDING` |
| Evidence contract | SHA-256 of this file at the source commit | `PENDING` |
| Asset contract | SHA-256 of `ASSET_MANIFEST.md` at the source commit | `PENDING` |
| Host/build facts | macOS version, hardware, display, audio output, power state, build flavor, and UTC export time | `PENDING` |

Any code, asset, scene, configuration, input, cue, or candidate-build change creates a new candidate identity and invalidates every affected session. A failed result stays in evidence; it is never overwritten by a retest.

## Cohorts and quotas

### Handling lab: exactly five valid players

| Slot | Primary input | Familiarity quota |
|---|---|---|
| `KD08-HL-01` | Physical controller | Driving-game familiar |
| `KD08-HL-02` | Physical controller | Driving-game unfamiliar |
| `KD08-HL-03` | Keyboard | Driving-game familiar |
| `KD08-HL-04` | Keyboard | Driving-game unfamiliar |
| `KD08-HL-05` | Keyboard | Driving-game familiar |

“Familiar” means at least five hours of driving-game play in the previous 12 months; “unfamiliar” means less than five. Controller slots require a real connected controller recognized by the exported build; simulation/replay does not count. Record model, connection, Godot device ID, mapping, and firmware if available. A player may repeat one task on the other input for comparison, but only the preassigned primary input counts toward quota and the player counts once.

### Hero/onboarding: exactly ten valid naive players

Slots are `KD08-HM-01` through `KD08-HM-10`; the first five are the deep-observation and sensory cohort. They are ten distinct people who have never seen this build, its documentation, a prior capture, its controls, or its debrief. A hero participant may join the handling cohort only later; the hero session occurs first and the person never counts as naive again. Input has no additional acceptance quota, but exact keyboard/controller device is recorded and cannot be changed within a session except for unrelated hardware failure.

Recruitment, contact, incentive, and identifiable consent records stay outside Git. Repository records use only the anonymous slot ID and `consent_recorded=true/false`. Screen/audio/video capture requires explicit consent. Identifiable raw capture is deleted by the earlier of 90 days after `KD-G11` passes or 180 days after capture; cancellation or indefinite archive triggers review within 30 days.

## Validity, clocks, and counting

- A valid session uses the frozen build, assigned eligible player/input, clean reset, neutral script, uninterrupted evidence logging, and no prior exposure.
- Only facilitator or technical failures unrelated to player behavior may be excluded. Retain the excluded record and reason, then replace the same slot/quota. Confusion, help, failure, abandonment, discomfort, or inability to complete is a valid outcome, not an exclusion.
- Clocks use monotonic build time and never pause for hesitation. `T0` is the first fully rendered interactive frame after reset with input neutral and the player told only “Begin when you are ready.” An unrelated technical interruption invalidates the session rather than editing elapsed time.
- “Help” means any control, objective, route, icon, cue, or desired-action explanation; debug vocabulary; moderator takeover; pointing; or non-neutral restart. Neutral timed questions and “please continue” are not help. Help makes the affected unaided criterion fail but does not invalidate the session.
- “Move” means participant input moves the vehicle center at least 64 world units from spawn. “Drive unaided” means at least 256 cumulative world units plus one deliberate heading change of at least 15 degrees before `T0+120 s`, without help or takeover.
- Thresholds use fixed valid denominators and no rounding: `4/5`, `9/10`, and `8/10` mean exactly those integer floors. No success may be borrowed between categories, inputs, or cohorts.

## Frozen handling script

Each player, on all three candidate tunes, performs start/steer/brake, controlled stop, reverse from the marked Garage bay, the five-marker slalom and broad road loop, dirt and mud route, marked wide-turn handbrake, controlled and high-speed contact with light/medium/heavy barriers, slide recovery, and recovery from the marked three-wall stuck fixture. Order is Latin-square counterbalanced and recorded before the first session. For each task, its task clock starts on the neutral “Begin” prompt and ends on success, failure, abandonment, or 120 seconds.

After tasks, record one integer handling-satisfaction rating from 1 to 5, identify road/dirt/mud without labels, state how all three tunes differ, and choose a preferred tune for road speed, off-road control, turning, and collision recovery.

Handling passes only when:

- all five valid players drive, reverse, drift/handbrake, and recover without takeover;
- median satisfaction is at least 4/5;
- at least four of five correctly identify every surface difference;
- all five perceive the three tunes as meaningfully different, and no tune is preferred for every task;
- no valid session exposes overlap damage spam, tunneling, stationary rotation, stuck throttle/input, or frame-rate-dependent control;
- the two physical-controller and three keyboard primary-input quotas are complete; and
- no P0/P1 remains open.

## Frozen hero-minute script

All ten start from the clean Garage departure with no controls explanation. The first five are observed continuously through `T0+120 s`; the facilitator records spontaneous interpretation and asks, without feedback, only:

- at `T0+20 s`: “What are you trying to do, and what do these two readings tell you?” The response must finish by `T0+30 s` to count.
- at `T0+50 s`: “What choice, if any, do you see, and what would guide it?” The response must finish by `T0+60 s` to count.
- at `T0+120 s`: “What, if anything, did you need help with?”

Hero/onboarding passes only when:

- at least four of the first five move by `T0+10 s`;
- at least four of the first five correctly identify the objective, Fuel, and Integrity by `T0+30 s`;
- at least four of the first five encounter and correctly explain the first route/reward choice by `T0+60 s`;
- at least nine of all ten drive unaided by `T0+120 s`;
- no player needs debug vocabulary; engine, surface, impact, reward/pickup, warning, and UI audio are audible and mix-controlled; and
- the recognition and sensory gates below pass with no open P0/P1.

## Frozen 896 x 414 recognition test

Every hero player completes the same recognition test after the unaided-drive clock. The harness renders at exactly 896 x 414 logical pixels in representative density. Each exposure lasts exactly 500 ms from first complete stimulus frame through hide; a frame-timestamp trace verifies duration. Trial order is deterministic from the candidate SHA plus anonymous slot ID and is saved before results.

The 15 categories are fixed to: `hero_car`, `primary_road`, `dirt_route`, `mud_route`, `landmark` (radio relay), `safehouse`, `objective`, `threat`, `fuel`, `repair`, `cargo`, `reward`, `light_obstacle`, `medium_obstacle`, and `heavy_obstacle`.

For every category, every player receives one positive representative-density trial, one near-neighbor trial where the target is absent, and one blank trial, for 45 randomized trials per player. Before each exposure the harness names the category to detect. After exposure the player has up to ten seconds to report present or absent and confidence; there is no replay or feedback. `present` on a positive trial is correct. `present` on either category-specific negative trial is a false positive.

Each category passes independently only with at least 8/10 correct positive identifications and at most 2/20 false positives across its near-neighbor plus blank trials (`<=10%`). Results are never pooled across categories. A failed category changes value/shape/motion and reruns the full affected category on a new frozen candidate; labels or extra effects cannot be added merely to manufacture a pass.

## Frozen audible and sensory checks

The first five hero players audit engine load/speed, road/dirt/mud surface, light/medium/heavy impact, low-Fuel/low-Integrity warning, reward/pickup, and UI confirmation in the full mix. Record audibility, cause, severity/state, masking, clipping, duplicate/late playback, and bus-control behavior.

They then identify the cause and severity/state of each critical impact, warning, reward, and objective/UI cue under five counterbalanced conditions: full mix, audio muted, mono output, Reduced Motion, and haptics disabled. The same committed event script is reset between conditions. A participant passes only when every critical cue's cause and severity/state is correct in every condition; at least four of five participants must pass. Desktop no-op haptics are recorded as disabled and cannot stand in for future physical-device haptic evidence.

## Exact artifact paths

All repository evidence is anonymous and retained at these exact paths:

| Artifact | Path |
|---|---|
| Candidate identity | `proofs/handling_truth_slice/ticket-08/candidate.json` |
| Export log | `proofs/handling_truth_slice/ticket-08/build/export.log` |
| Embedded provenance copy | `proofs/handling_truth_slice/ticket-08/build/handling-truth-slice-provenance.json` |
| Executable and source hashes | `proofs/handling_truth_slice/ticket-08/build/sha256.txt` |
| First-60-second candidate capture | `proofs/handling_truth_slice/ticket-08/capture/first-60-seconds.mp4` |
| Handling records | `proofs/handling_truth_slice/ticket-08/handling/KD08-HL-01.md`, `proofs/handling_truth_slice/ticket-08/handling/KD08-HL-02.md`, `proofs/handling_truth_slice/ticket-08/handling/KD08-HL-03.md`, `proofs/handling_truth_slice/ticket-08/handling/KD08-HL-04.md`, `proofs/handling_truth_slice/ticket-08/handling/KD08-HL-05.md` |
| Handling aggregate | `proofs/handling_truth_slice/ticket-08/handling/aggregate.json` |
| Hero records | `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-01.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-02.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-03.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-04.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-05.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-06.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-07.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-08.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-09.md`, `proofs/handling_truth_slice/ticket-08/hero/KD08-HM-10.md` |
| Hero aggregate | `proofs/handling_truth_slice/ticket-08/hero/aggregate.json` |
| Recognition order/stimulus manifest | `proofs/handling_truth_slice/ticket-08/recognition/randomization.json` |
| Recognition per-session frame/raw logs | `proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-01.jsonl` through `proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-10.jsonl` |
| Recognition rendered preview bundles | `proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-01-previews/` through `proofs/handling_truth_slice/ticket-08/recognition/KD08-HM-10-previews/`; each contains 45 PNGs plus `manifest.json` |
| Recognition raw trials | `proofs/handling_truth_slice/ticket-08/recognition/trials.csv` |
| Recognition per-category result | `proofs/handling_truth_slice/ticket-08/recognition/category-aggregate.csv` |
| Sensory raw trials | `proofs/handling_truth_slice/ticket-08/sensory/cue-trials.csv` |
| Audible/mix aggregate | `proofs/handling_truth_slice/ticket-08/sensory/aggregate.json` |
| Exclusions/replacements | `proofs/handling_truth_slice/ticket-08/exclusions.md` |
| Defect ledger | `proofs/handling_truth_slice/ticket-08/defects.md` |
| Evidence/Product signoff | `proofs/handling_truth_slice/ticket-08/signoff.md` |

Every session record contains UTC start/end, facilitator, candidate/build identity, player eligibility/familiarity, device/OS/display/input/audio/settings, task clocks, raw observations, help, ratings, defects, validity decision, consent flags, and follow-up. Identifiable raw capture and recruitment records are not committed.

## P0/P1 closure and change control

Classify defects using `docs/PLAYTEST_PLAN.md`. Any P0 or P1 stops this gate; neither can be waived. Preserve reproduced-before evidence, assign an owner, fix or supersede the affected decision, produce a new clean candidate, rerun focused regression and every affected human gate, and obtain Evidence/Product signoff. A P2 escalates under the repository's frequency/device rules; a scheduled fix without passing retest is not closure.

## Result ledger

`PENDING` is not a pass.

| Criterion | Required | Result |
|---|---:|---|
| Valid handling cohort | 5/5; controller 2, keyboard 3 | `PENDING` |
| Core handling tasks without takeover | 5/5 | `PENDING` |
| Handling satisfaction median | >=4/5 | `PENDING` |
| Surface identification | >=4/5 for road, dirt, and mud | `PENDING` |
| Three tunes distinct/no universal winner | 5/5 distinct; no universal winner | `PENDING` |
| First-five movement | >=4/5 by 10 s | `PENDING` |
| Objective + Fuel + Integrity | >=4/5 by 30 s | `PENDING` |
| Route/reward understanding | >=4/5 by 60 s | `PENDING` |
| Full-cohort unaided driving | >=9/10 by 120 s | `PENDING` |
| Recognition | Every category >=8/10; every category <=2/20 false positives | `PENDING` |
| Audio audible/mix-controlled; no debug vocabulary | All required families; 0 players need debug vocabulary | `PENDING` |
| Sensory independence | >=4/5 pass every critical cue/condition | `PENDING` |
| Physical-controller human evidence | 2 valid assigned handling players | `PENDING` |
| Open P0/P1 | 0 | `PENDING` |
| Evidence/Product signoff | Both exact-candidate attestations present | `PENDING` |

Current verdict: `NOT_STARTED`; ticket-08 cannot resolve from this document alone.
