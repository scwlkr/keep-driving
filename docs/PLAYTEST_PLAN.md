# Keep Driving Playtest Plan

Status: 1.0 validation program
Plan date: 2026-07-11

## Purpose

Keep Driving is complete only when its systems are understandable, enjoyable, balanced, reliable, and performant in real play. Automated simulations protect rules; they do not establish game feel, readability, comprehension, pacing, audio quality, or fun.

The existing `proofs/manual_smoke_proof.gd` is an automated loop simulation and should be renamed accordingly. Every roadmap phase with a player-facing outcome requires a rendered desktop build and a human test before it can pass to mobile.

## Evidence classes

| Evidence | Establishes | Does not establish |
|---|---|---|
| Unit/domain tests | Rule correctness, deterministic values, migration/catalog validation | Integration, presentation, fun |
| Scene integration | Module interaction and state transitions | Human understanding or final performance |
| Automated loop simulation | Broad repeatable path coverage | Human manual smoke, audible/visual quality |
| Rendered capture | Real presentation state and obvious regressions | Input feel or broad device behavior |
| Performance/soak | Frame/memory/streaming limits for one recorded build/device | Enjoyment or every content path |
| Structured human playtest | Comprehension, feel, decisions, pacing, preference | Exhaustive regression |
| Device/TestFlight test | Real touch, lifecycle, device performance, install/update | Full design truth without structured tasks |

Reports must name the evidence honestly.

## Operating principles

- Test the smallest risky claim early.
- Observe behavior before explaining the intended design.
- Use neutral prompts and ask one question at a time during debrief.
- Separate first-time players from expert/balancing cohorts.
- Record exact build, device, input, save fixture, settings, scenario/seed, duration, and facilitator.
- Preserve raw notes, then distinguish observation, player quote/paraphrase, interpretation, severity, and proposed action.
- Do not collect unnecessary personal data. Get explicit consent for screen/audio/video capture and diagnostic upload.
- A single enthusiastic session cannot close a systemic risk; a single reproducible data-loss or progression blocker can reopen a phase.

## Playtest environments

### Desktop truth environment

- Exported macOS release-like build, not editor-only play.
- Keyboard and supported controller.
- Standardized 1280 x 720 and representative native desktop resolution.
- Optional capture plus input/performance overlay recorded separately from player view.
- Known test save/seed and clean-profile reset path.

### Mobile environment

- Signed physical-device/TestFlight build.
- Minimum, small-screen, mid, large/notched, and current device tiers.
- Touch and controller.
- Network/offline, lifecycle, thermal, battery, memory, and safe-area conditions recorded.

### Facilitated versus unmoderated

- Facilitated sessions for first-minute, handling, UI, accessibility, and misunderstood rules.
- Unmoderated sessions for natural return behavior, longer progression, retention of knowledge, install/update, and support discovery.

## Session record template

Every session records:

- Session ID; date/time; facilitator.
- Build version/build/commit/content/save schema.
- Player cohort and prior genre/game familiarity.
- Device/OS/display/input/audio/haptics/settings.
- Profile fixture and expedition seed/objective.
- Tasks and success criteria.
- Start/end time; time-to-first-input; completion/failure/abandon state.
- Observed hesitations, errors, route/build choices, retries, and help requests.
- Frame/memory/crash/save evidence when relevant.
- Player responses and confidence ratings.
- Defects with reproduction/evidence.
- Design findings, severity, owner, validation follow-up.

## Internal playtesting cadence

### Every meaningful implementation slice

Developer smoke in an exported or representative rendered desktop build:

1. Start from clean and existing profile.
2. Exercise changed behavior and its nearest integrations.
3. Exercise one failure/edge path.
4. Verify save boundary and restart.
5. Capture output/screenshot/video if the acceptance criterion is visual or temporal.

This is necessary but not sufficient for milestone acceptance.

### Weekly during gameplay production

- One 30-60 minute team/internal session using the current integrated build.
- Rotate clean profile, midgame, late-game, alternative chassis/build, and known stress region.
- Triage immediately into defect, design risk, content repetition, or accepted observation.
- Maintain a short top-three playtest-risk list; do not fix every preference note opportunistically.

### Milestone gates

- Dedicated structured cohort using frozen candidate build and script.
- No facilitator who implemented the feature should lead every session.
- Aggregate results before changing the acceptance target.

## Structured test stages

### 1. Production handling lab

Cohort: at least five players; mix driving-game familiar and unfamiliar.
Build: desktop test track with road, dirt, mud, slalom, braking, reverse, breakable/medium/heavy collision, recovery.
Presets: three deliberately distinct vehicle tunes or chassis/loadouts.

Tasks:

- Start, steer, brake, reverse, and stop accurately.
- Complete broad road loop without instruction.
- Take dirt/mud alternate route.
- Use handbrake around one wide turn.
- Hit each obstacle class at controlled and high speed.
- Recover from a slide and a stuck position.
- Repeat with controller where applicable.

Acceptance:

- All five can drive, reverse, drift, and recover without moderator takeover.
- Median handling satisfaction at least 4/5.
- No overlap damage spam, tunneling, stationary rotation, stuck throttle, or frame-rate-dependent control defect.
- Surface differences are identified correctly by at least four of five.
- Three presets are perceived as meaningfully different; no preset is preferred for every task.

### 2. First 60 seconds / hero minute

Cohort: five new players who have not seen the build/docs.
Build: representative final-quality Garage departure, road, route fork, landmark, reward/threat, HUD, real audio.

Observe without help:

- Time to move.
- Controls used and prompt dependence.
- Immediate objective interpretation.
- Fuel/Integrity interpretation.
- First route/reward decision and stated reason.
- Any unreadable spawn, UI, audio, or world cue.

Acceptance:

- Four of five move within ten seconds.
- Four of five identify objective and Fuel/Integrity within 30 seconds.
- Four of five encounter and understand a meaningful route or reward decision within 60 seconds.
- At least 90% drive without help within two minutes across the larger onboarding cohort.
- No player needs debug vocabulary; engine/surface/impact/pickup/warning/UI audio is audible and mix-controlled.

### 3. Hybrid proof region

Cohort: five to eight players; at least two repeat the region.
Build: 10-15 minute region with two primary routes, offroad shortcut, three landmarks, crossing/barrier, dynamic event, safe return.

Acceptance:

- First-time players reach destination using world cues/map without facilitator route instruction.
- Meaningful route/encounter/reward decision every 30-45 seconds.
- Players can describe at least two landmarks and one route tradeoff afterward.
- Repeat players use learned geography while responding to changed systemic conditions.
- No obvious route grammar repetition, seam, blank terrain, or unavoidable lethal event.
- Release-like desktop streaming remains <=4 ms p95.

### 4. Buildcraft and Garage

Cohort: six to ten players.
Build: at least three chassis/representative data, 12 parts across four-plus slots, test lot, route forecast, presets.

Tasks:

- Build for road endurance, offroad exploration, ram/cargo scenario.
- Explain selected benefits and costs.
- Compare/fabricate/swap/undo/save preset.
- Drive benchmark routes and revise.

Acceptance:

- Players make a valid build in under two minutes after introduction and swap presets in under 60 seconds.
- At least 80% correctly explain the chosen part's capability and tradeoff.
- At least three distinct builds are selected and succeed in their intended benchmark.
- No build wins road, offroad, impact, Fuel, cargo, and threat benchmarks.
- No hidden math, duplicate, compatibility, affordability, or missing-preset confusion blocks the flow.

### 5. Three-run expedition/economy proof

Cohort: eight to twelve players; clean profiles.
Duration: roughly one hour.

Sequence:

1. Complete/extract first objective and choose a part.
2. Use the changed build on a second route.
3. Face a real continue/return/failure decision and make another progression choice.

Acceptance:

- First meaningful part choice occurs in the first session.
- At least two credible build paths appear across the cohort.
- Players distinguish secured/unsecured reward, extraction, objective completion, and failure consequences.
- Returning safely and pushing farther are both selected for understandable reasons.
- Intentional failure, idling, circling, or farming does not outperform outward objective play.
- No 30-45 minute span lacks a new capability, place, blueprint, chassis clue, or meaningful choice during primary progression.

### 6. UX shell and accessibility

Cohort: representative touch/controller/keyboard users plus recruited players who use relevant accessibility settings where possible.

Flows:

- First launch, Continue, Garage/loadout, mission board, map, expedition HUD, pause, Results, settings, recovery, support/privacy.
- 100/150/200% text, pseudolocalization +40%, high contrast, reduced motion, visual audio cues, left-handed/largest touch layout, controller-only navigation.

Acceptance:

- Every common task completes without pointer-only or touch-only dependency.
- Visible focus/default focus/back behavior is consistent.
- No blocking clip/overlap/truncation at supported aspects/text sizes.
- Contrast and color-independent information pass audit.
- Reduced motion/flash/particle/haptic settings take effect immediately and preserve meaning.
- Touch target/safe-area rules pass on physical devices before mobile acceptance.
- App Store accessibility claims are made only after criterion-specific end-to-end tests.

### 7. Desktop alpha

Cohort: 10-15 invited players across familiarity levels.
Build: all major systems integrated; content incomplete but representative.

Goals:

- End-to-end comprehension and enjoyment.
- Handling/world/build/activity integration.
- Save/resume/recovery, controller, performance, and defects.
- Identify missing systemic/content states before production scale.

Exit:

- Primary loop understandable to at least 80% after one expedition.
- Median overall session rating at least 4/5 or documented changes scheduled.
- No P0/P1; high-frequency P2 trends owned.
- Full-stack performance and save gates pass on desktop reference hardware.

### 8. Desktop content-complete beta

Cohort: 20-30 players; include clean start-to-finish and returning profiles.
Build: all required launch content and progression present.

Tests:

- Full primary campaign and completion.
- Region/content repetition and density.
- Three chassis/five archetypes.
- Economy/progression pacing and dead ends.
- Expedition Mode and mastery.
- Accessibility/localization/save upgrade.
- Two-hour soak and worst-case content.

Exit:

- No progression blocker or required random grind.
- Content floors met without obvious filler/repetition.
- All required build archetypes viable.
- Economy source/sink and failure/extraction behavior stable.
- Zero P0/P1; P2 burn-down is bounded and scheduled.

### 9. iOS internal TestFlight

Cohort: assigned device/input/accessibility matrix.
Focus: install/update, touch, safe areas, audio/haptics, controller, lifecycle, save, frame/memory/thermal/battery, offline.

Exit:

- Minimum and target device budgets pass.
- 1,000 lifecycle/save fault cycles pass.
- No stuck input, duplicate reward/audio, save loss, or safe-area blocker.
- Internal crash/hang evidence supports external test.

### 10. External TestFlight / release beta

Cohort: 20-30 first wave; expand to 50-100 only to close defined coverage gaps.

Exit:

- At least 99.8% crash-free sessions over the release beta window.
- Zero reproducible save loss/P0/P1.
- Store/review path and support material tested by someone outside the development loop.
- Device, accessibility, progression, and content confidence covers the supported matrix.
- Every accepted P2 has explicit impact, owner, and post-launch plan.

## Feedback questions

Ask after observation, not before.

### First impression

- What did you think the game wanted you to do first?
- What information did you look at while driving?
- What, if anything, felt confusing before you moved?
- Describe the game to someone who has not seen it.

### Driving and feel

- When did the car feel most under your control? Least?
- What did road, dirt, mud, drift, and impact feel like?
- Which mistake felt fair? Which felt surprising?
- If you changed one control response, what and why?

### World and navigation

- How did you choose your route?
- Which places do you remember without seeing the map?
- When did you feel lost, and what did you expect to help?
- On a repeat trip, what did you know and what changed?

### Risk and activities

- When did you consider returning? What affected the choice?
- What did you believe would be secured or lost?
- Which objective felt most/least like it belonged in this game?
- Did any encounter feel unavoidable, repetitive, or disconnected from driving?

### Garage and builds

- What changed when you installed that part?
- What cost or drawback did you accept?
- Which route would this build prefer and why?
- Was anything stopping you from trying another build?

### Progression and economy

- What are you working toward next?
- When did the game feel generous, grindy, or pointless?
- Did failure erase too much, too little, or the right amount?
- Did you ever repeat an action because it seemed mathematically optimal but boring?

### UI, audio, and accessibility

- What warning did you notice first and how?
- Which screen took longest to understand?
- What information was missing, duplicated, or too persistent?
- Which setting helped, and did it preserve the intended feedback?

### Return intent

- What would you do in the next session?
- What are you curious to unlock, find, or master?
- What would stop you from returning?

Avoid asking only “Was it fun?” Use ratings after specific observations and always ask why.

## Usability metrics

- Time to first movement.
- Time/help to identify objective, Fuel, Integrity, haul, and return point.
- Tutorial prompt completion and recall.
- Wrong-screen/backtracking count per common flow.
- Garage build/preset completion time and comparison accuracy.
- Map destination/route selection success.
- Touch mis-input, control reach, and stuck-input incidence.
- Controller focus loss and pointer dependency.
- Settings discovery and effect verification.
- Save/recovery/support comprehension.

## Progression and economy testing

### Automated

- Simulate reward/cost curves across representative success/failure/extraction rates.
- Catalog benchmark for part/build dominance.
- Detect impossible unlock dependencies, negative/overflow values, missing sources/sinks, and duplicate reward application.
- Verify repeated low-risk contract is not optimal beyond intended onboarding.
- Test all activity outcomes and resume boundaries.

### Human

- First three runs / one hour.
- Four-hour midgame sample across multiple players.
- Complete primary progression with clean profile.
- New chassis starter loadout and catch-up.
- Failure-heavy and success-heavy profiles.
- Alternate build/chassis completion.
- Post-completion Expedition/ mastery return.

Record time-to-choice/capability/location, Scrap earned/spent, part use, objective repetition, failure/extraction reason, abandoned goals, and player-stated next goal.

## Device testing

Use the matrix in `docs/MOBILE_PORTING_PLAN.md`.

For every physical run record:

- Model, chip/memory class, OS, battery health, temperature/thermal state, free storage.
- Build/version, frame mode, quality, brightness, audio route, haptics, network.
- p50/p95/p99 frame, worst hitch, peak/plateau memory, launch/resume, battery delta.
- Safe area/orientation/touch/controller behavior.
- Lifecycle interruptions and save sequence/recovery result.

Simulator evidence can close basic layout/compatibility only, never touch, haptics, memory, thermal, battery, signing, or full lifecycle.

## Regression plan

### Per change

- Correct-layer automated regression.
- Affected integration path.
- One adjacent failure/edge path.
- Save compatibility if persistent state changed.
- Rendered/interaction check if player-facing.

### Nightly

- Core suites and catalog/localization/license validators.
- 100-seed/1,000-transition world fuzz.
- Save migration/corruption/interruption fixtures.
- Full-stack performance scenario and worst-frame comparison.
- Aspect/text/pseudolocalization screenshot matrix.

### Milestone

- Fresh exported build.
- Full primary loop/manual human smoke.
- Representative progression/content path.
- Two-hour memory/traversal soak.
- Controller/input/accessibility matrix.
- All supported save updates/migrations.
- Physical-device matrix when mobile scope is active.

### Release candidate

- Clean install and update from last supported release/beta.
- Full campaign and Expedition Mode completion.
- Offline, lifecycle, low-storage, corruption recovery, and emergency-patch migration.
- Exact archive metadata/privacy/accessibility/review agreement.

## Bug severity

### P0 — Critical

- Data loss/corruption without verified recovery.
- Security/privacy breach or undisclosed data transmission.
- App cannot launch/install/update for a supported cohort.
- Purchase/entitlement failure affecting access if monetization changes.
- Widespread crash, infinite loop, or hard device failure.

Response: stop release/affected rollout; preserve evidence; smallest safe fix; full blocker regression.

### P1 — Release blocker

- Reproducible crash/hang in a common path.
- Primary progression cannot complete.
- Save/reward duplication, stuck input, unavoidable lethal spawn, or vehicle/world state makes normal play impossible.
- Minimum-device frame/memory/thermal budget failure.
- Broken touch/controller/common accessibility flow.
- App Review, privacy, metadata, signing, export, or legal blocker.
- Missing/unlicensed/placeholder production content.

### P2 — Major

- Important activity/build/region path degraded but workaround exists.
- Repeated confusing UI, pacing, balance, audio, or presentation issue with material player impact.
- Non-common device/layout defect inside supported matrix.
- Performance hitch or content repetition above target without blocking completion.

P2 may be accepted into RC only with explicit impact, scope, workaround, owner, and post-launch timing; high-frequency P2 becomes P1.

### P3 — Minor/polish

- Cosmetic, wording, low-frequency, or small consistency defect without material comprehension/control/progression/reliability impact.

P3 does not justify destabilizing a frozen RC unless the fix is proven trivial and receives normal regression.

## Release blockers

Any of the following blocks 1.0:

- Open P0 or P1.
- Any reproducible profile loss, corruption without recovery, reward duplication, or unsupported migration.
- Crash-free sessions below 99.8% release-beta target.
- Primary progression, extraction, Garage, save/resume, or Expedition Mode cannot complete.
- Minimum supported device misses approved sustained frame, memory, thermal, launch/resume, touch, or lifecycle budget.
- Required first-minute, handling, hybrid-world, buildcraft, economy, accessibility, and content gates lack passing human evidence.
- App Store declarations/assets/metadata/review notes do not match the selected archive.
- Placeholder/debug/unlicensed/missing content remains.
- Core offline play depends on an unavailable service.

## Playtest definition of done

- Every major system has the correct automated, rendered, human desktop, and where applicable physical-device evidence.
- Raw session records and aggregate findings map to build/commit and acceptance criteria.
- Failures create owned defects/design actions and are retested; targets are not moved after seeing poor results without a recorded product decision.
- Release beta satisfies crash/save/device/content/accessibility gates with no P0/P1.
