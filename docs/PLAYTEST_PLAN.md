# Keep Driving Playtest Plan

Status: 1.0 validation program
Plan date: 2026-07-11
Gate decision and current first-party basis: [Playtest, Release, and App Store Gates](research/PLAYTEST_RELEASE_AND_APP_STORE_GATES.md)

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
- Keep recruitment/contact/incentive records outside git; repository evidence uses anonymous session IDs and aggregates. Delete identifiable raw capture by the earlier of 90 days after `KD-G11` passes or 180 days after capture. Cancellation or indefinite archive triggers a deletion review within 30 days; separate consent or a documented legal/security need names a new review/deletion date.
- A single enthusiastic session cannot close a systemic risk; a single reproducible data-loss or progression blocker can reopen a phase.
- A provisional `[PLACEHOLDER]` may guide a prototype, but no gate may pass while a placeholder remains inside that gate's acceptance scope.

## Gate governance

Production readiness uses `KD-G0` through `KD-G11` from the gate decision. Before a candidate enters a gate, `KD-G0 Evidence Contract` freezes its script, thresholds, owners, cohort/device quotas, clocks, numerator/denominator, consent/retention, required suites, artifact paths, and change-to-retest rules.

The future `docs/release/<version>/RELEASE_EVIDENCE.md` ledger records each gate's `NOT_STARTED`, `RUNNING`, `PASS`, `FAIL`, or `REOPENED` status against one exact build/commit/content/save/toolchain identity. Required gates and P0/P1 defects are never waived. Every pass has an Evidence Owner; Build, Product, Privacy/Compliance, and Release Owners attest only their scope. One person may hold multiple roles, but implementers/agents never substitute for naive-player evidence.

Before outcomes are seen, every human script fixes valid `N`, cohort eligibility, tasks, clock anchors, numerator/denominator, rounding, and invalid-session rules. Only facilitator/technical failures unrelated to player behavior may be excluded; retain the reason and replace that session. A player counts as naive once, though they may return in a later explicitly labeled cohort.

Any code/content/configuration change reruns affected human and automated gates. Any prelaunch binary/content/configuration change after `KD-G7` begins creates a new external build and restarts its participant/session/day window. After public launch, an urgent smallest-scope patch uses `KD-E1 Emergency Patch`; a non-emergency update returns to normal `KD-G7` qualification. Metadata-only changes reopen the affected store/RC gate. Targets change only through a dated decision followed by a rerun—never retroactively to pass observed results.

## Playtest environments

### Desktop truth environment

- Exported macOS release-like build, not editor-only play.
- Keyboard and supported controller.
- Standardized 1280 x 720 and representative native desktop resolution.
- Optional capture plus input/performance overlay recorded separately from player view.
- Known test save/seed and clean-profile reset path.

The current desktop comparison host is MacBookPro18,2 with an Apple M1 Max (10-core CPU, 32-core GPU), 64 GB RAM, and built-in 3456 x 2234 display. Release-like benchmark captures use a clean exported GL Compatibility build in a 1920 x 1080 output window with the project's 1280 x 720 logical viewport. Capacity runs disable VSync; play-feel/input runs repeat with VSync enabled. Record macOS/build, exact Godot build, renderer, display/output/logical viewport/scale, VSync, power state, build flavor, commit, scene/seed, asset set, warm-up, duration, p50/p95/p99/worst frame, peak/plateau memory, and raw artifact path. This is a stable comparison host, not minimum-device evidence.

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
- Script/version hash, valid/excluded decision, exclusion reason, and gate/evidence-ledger link.

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
- Named Evidence/Product owners mark PASS or FAIL; scheduled corrective work without passing retest never closes the gate.

## Structured test stages

### 1. Production handling lab

Cohort: five valid players; mix driving-game familiar and unfamiliar; at least two use a physical controller and at least two use keyboard, with one player allowed to exercise both.
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

- Every valid participant can drive, reverse, drift, and recover without moderator takeover.
- Median handling satisfaction at least 4/5.
- No overlap damage spam, tunneling, stationary rotation, stuck throttle, or frame-rate-dependent control defect.
- Surface differences are identified correctly by at least four of five.
- Three presets are perceived as meaningfully different; no preset is preferred for every task.

### 2. First 60 seconds / hero minute

Cohort: ten valid new players who have not seen the build/docs. The first five receive the deep observed hero-minute script; all ten attempt first movement/onboarding and the phone-scale silhouette-recognition script.
Build: representative final-quality Garage departure, road, route fork, landmark, reward/threat, HUD, real audio.

Observe without help:

- Time to move.
- Controls used and prompt dependence.
- Immediate objective interpretation.
- Fuel/Integrity interpretation.
- First route/reward decision and stated reason.
- Any unreadable spawn, UI, audio, or world cue.
- Which car, route classes, landmark/safehouse, objective, hazard/threat, Fuel, repair, and cargo silhouettes are recognized when each category is randomized at exact 896 x 414 logical phone-proof scale for `[PLACEHOLDER: 500 ms]` inside representative density, including blank and near-neighbor control trials.
- Whether the cause and severity of each critical cue remain identifiable with audio muted, mono output, Reduced Motion, and haptics disabled.

Acceptance:

- Four of five move within ten seconds.
- Four of five identify objective and Fuel/Integrity within 30 seconds.
- Four of five encounter and understand a meaningful route or reward decision within 60 seconds.
- Nine of ten drive without help within two minutes across the full onboarding cohort.
- No player needs debug vocabulary; engine/surface/impact/pickup/warning/UI audio is audible and mix-controlled.
- At least eight of ten identify each required critical category and false positives remain `[PLACEHOLDER: <=10%]`; failures simplify value/shape/motion before labels or effects multiply.
- Four of five identify critical cue cause/severity without relying on one sensory channel.

### 3. Hybrid proof region

Cohort: at least five valid players; at least two repeat the region after conditions change.
Build: 10-15 minute region with two primary routes, offroad shortcut, three landmarks, crossing/barrier, dynamic event, safe return.

Acceptance:

- At least 80% of valid first-time players reach the destination using world cues/map without facilitator route instruction.
- For a typical 15-minute proof, begin with the explicit `[PLACEHOLDER]` composition of two to four route choices, one to three encounters, one optional detour, one objective beat, and one return decision; reject filler inserted only to satisfy a timer.
- At least 80% describe at least two landmarks and one route tradeoff afterward.
- At least 80% correctly order the relative risk of paired route/contract forecasts before departure; compare different loadouts against the same committed offer to verify threats/rewards do not counter-pick.
- Repeat players use learned geography while responding to changed systemic conditions.
- At least 80% notice one route-relevant ambient/dynamic world change and correctly explain whether it altered navigation, risk, or only atmosphere; a reactive county cannot be faked by a cosmetic event with no readable consequence.
- No obvious route grammar repetition, seam, blank terrain, or unavoidable lethal event.
- Release-like desktop streaming remains <=4 ms p95.

### 4. Buildcraft and Garage

Cohort: six to ten players.
Build: the D020-locked chassis target or representative data (currently at least three), 12 parts across four-plus slots, test lot, route forecast, presets.

Tasks:

- Build for road endurance, offroad exploration, ram/cargo scenario.
- Explain selected benefits and costs.
- Compare/fabricate/swap/undo/save preset.
- Drive benchmark routes and revise.

Acceptance:

- Players make a valid build in under two minutes after introduction and swap presets in under 60 seconds.
- At least 80% correctly explain the chosen part's capability and tradeoff.
- The 12-part tranche yields at least three distinct build hypotheses; launch acceptance remains every D020-locked build, minimum four.
- At the same chassis and Build Capacity budget no obtainable loadout is Pareto-dominant; later unlock timing or one-time Scrap price never excuses dominance. Each required build has a representative strength and weakness, and no build wins road, offroad, impact, Fuel, cargo, and threat benchmarks.
- No hidden math, shared-ownership, duplicate-conversion, compatibility, affordability, capacity, or missing-preset confusion blocks the flow.

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
- At least 80% of players predict exactly which reward/world facts are permanently committed, durability-acknowledged retained deltas awaiting terminal transfer, or expedition escrow before choosing return/push.
- Returning safely and pushing farther are both selected for understandable reasons.
- Intentional failure, idling, circling, or farming does not outperform outward objective play.
- Safehouse banking visibly closes the expedition; Continue starts a new persisted manifest from that safehouse with serviced baseline Fuel/Integrity while preserving claimed/rolled socket value, reward cooldowns, and repetition history.
- If retained, fast travel is unavailable until the expedition is closed and never transports active escrow or pending mutations.
- Failure, abandon, app background, and reload never retain an ordinary escrowed part/cargo, reroll a manifest, or apply a settlement twice.
- Required restoration and baseline Fuel/Integrity never need Scrap; no player repeats a solved low-risk objective solely to unlock campaign progress.

### 6. UX shell and accessibility

Cohort: at least five valid desktop participants spanning keyboard and controller, including at least two people with self-identified permanent, temporary, or situational access needs relevant to the tested vision, hearing, motor, or cognitive settings. Before `KD-G6`, repeat the common-task matrix with at least five valid physical-iPhone participants spanning touch and controller, again including at least two people with relevant self-identified access needs. A participant may count in both cohorts only when both sessions are declared; do not collect diagnoses. Any VoiceOver or Voice Control product-page claim additionally requires at least two participants who regularly use that assistive technology.

`KD-G1` judges only the desktop-capable UX, audio, and accessibility evidence. Touch targets, safe areas, haptic comfort, mobile input switching, physical-device common tasks, and mobile accessibility evidence cannot pass by inheritance and belong to `KD-G6`.

Flows:

- First launch, Continue, Service/loadout, Plan contract cards and Atlas/RouteLedger, Drive HUD, SystemSheet/pause, Settle Receipt, settings, recovery, support/privacy.
- 100/150/200% text, pseudolocalization +40%, high contrast, reduced motion, visual audio cues, left-handed/largest touch layout, controller-only navigation.
- AtlasCanvas and RouteLedger/list equivalents, known/estimated/unknown route facts, one-primary-action behavior, focus restoration, Back/Cancel, and destructive confirmation.
- Fifteen-minute complete-state audio mix plus a separate 30-minute desktop visual/audio masking/fatigue session. Physical-iPhone haptic comfort is a separate device session; desktop or controller rumble is not a substitute.

Acceptance:

- Every common task completes without pointer-only or touch-only dependency.
- Visible focus/default focus/back behavior is consistent.
- No blocking clip/overlap/truncation at supported aspects/text sizes.
- Contrast and color-independent information pass audit.
- Reduced motion/flash/particle/haptic settings take effect immediately and preserve meaning.
- Descriptive presets and Custom expose independent assists, can change mid-campaign without progress/reward/ending loss, may only reduce a disclosed action-Pressure delta, and do not silently alter committed offers or punish assisted play.
- Touch target/safe-area rules pass on physical devices before mobile acceptance.
- App Store accessibility claims are made only after criterion-specific end-to-end tests.
- Every proposed App Store accessibility label has a dated exact-build/device/common-task evidence record; unsupported labels remain unclaimed.
- The claim register maps feature -> every common task -> device type/OS -> exact build/settings -> evaluator/participant evidence -> owner. Any failed claimed common task is P1 until the claim is removed everywhere or the implementation passes retest.
- The desktop 30-minute session samples 0-5 masking/fatigue every five minutes, stops immediately on request or at >=4 discomfort, meets `[PLACEHOLDER: median <=2 and no unresolved score >=3]`, and keeps critical warnings distinguishable under the busiest representative mix. The physical-iPhone haptic session uses the same stop rule and records comfort, control precision, and battery separately.

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
- Median overall session rating at least 4/5 after corrective work and a frozen-candidate retest.
- No P0/P1; high-frequency P2 trends owned.
- Full-stack performance and save gates pass on desktop reference hardware.

### 8. Desktop content-complete beta

Cohort: 20-30 players; include clean start-to-finish and returning profiles.
Build: all required launch content and progression present.

Tests:

- Full primary campaign and completion.
- Active-play timing from clean profile through primary completion and mastery; pause/background/developer-shortcut time is excluded.
- Region/content repetition and density.
- D020-locked chassis/build-diversity target; currently three chassis/five archetypes.
- Economy/progression pacing and dead ends.
- D020-locked mastery and postgame scope; currently Expedition Mode if retained.
- Accessibility/localization/save upgrade.
- Two-hour soak and worst-case content.
- At least ten participants complete three unmoderated sessions across at least seven calendar days to test return intent, retained knowledge, support discovery, and repeated-content fatigue.

Exit:

- No progression blocker or required random grind.
- The D020-locked content target reports Restoration Objectives, Contract Definitions, decision-distinct Contract Instances, Mastery Overlays, Encounter Templates, Parts, and Viable Builds separately; cosmetic/parameter variants inflate none of them.
- Eight of ten players distinguish delivery, recovery, and restoration by decisions rather than fiction; a second author produces a validated data-only variant with `[PLACEHOLDER: <20%]` rework after review.
- Every D020-locked build is viable, minimum four; each has a material strength/weakness and the exhaustive report finds no Pareto-dominant obtainable loadout at the same chassis and Build Capacity budget.
- Economy source/sink and failure/extraction behavior is stable across the Monte Carlo exploit profiles and exact-security human test.
- At least ten new clean-profile players: median first primary-arc completion lands inside the D020-locked range (current target 8-12 active hours; coherent fallback 5-8), at least 8/10 land inside the lock's declared tolerance, and no player hits a mandatory random-grind block.
- At least five clean-profile players continuing into mastery each reach the D020-locked authored completion/build/mastery goal inside its active-play range (current target 20-30 hours; coherent fallback 10-15); median mastery enjoyment is >=4/5 and identical repeated filler is neither required nor counted. Expedition-specific goals apply only if the mode survives D020.
- At least four of five post-completion players identify and voluntarily begin a non-Scrap next goal; Expedition Mode, if retained, remixes declared conditions on the same county topology and grants no exclusive campaign power.
- Zero P0/P1; no more than five accepted P2s remain under the risk budget below, each with scheduled burn-down.

### 9. iOS internal TestFlight

Cohort: the assigned device/input/accessibility matrix plus ten valid first-time-iPhone participants who have never used a mobile build of the game. This ten-person cohort is distinct from the ten first-time participants later required by `KD-G7`; each required tier is used by at least two cohort members, and the second minimum/current devices are each exercised by at least one. Nine of ten must drive without help within two minutes and eight of ten must complete first launch -> expedition -> pause/background/resume -> Settle -> Service using touch.
Focus: install/update, touch, safe areas, audio/haptics, controller, lifecycle, save, frame/memory/thermal/battery, offline.

Before the candidate, lock exact model/chip/OS/input/frame/quality assignments: at least one physical device in each minimum/small/mid/large/current tier plus a second minimum and current device; deployment-min latest patch and latest public iOS are both represented. Freeze memory, thermal, battery, launch/resume, frame-mode, and free-storage protocol values before measuring.

Exit:

- Every assigned model/OS/input/frame/quality row passes every applicable locked frame, memory, thermal, battery, launch, resume, free-storage, functional, and accessibility budget; results are not averaged across devices or tiers.
- 1,000/1,000 lifecycle/save fault cycles complete with zero committed-state loss, duplication, double settlement, or unclassified state mismatch.
- No stuck input, duplicate reward/audio, save loss, or safe-area blocker.
- One exact internal-TestFlight build records at least 200 reported sessions in one frozen seven-day UTC window, every required tier contributes at least 20 attributable sessions, and `(reported sessions - Failed Session Equivalents) / reported sessions >= 99.5%`. External access remains off. Open internal use at `T0=00:00 UTC` and use the `T0+7d` last-seven-day boundary export/snapshot; daily rolling views are audit evidence and are never summed. Device/Xcode watchdog/hang evidence uses the same conservative categories and no-double-count rule as `KD-G7`; unresolved unknown terminations fail the gate.

### 10. External TestFlight / release beta

Cohort: 20-30 first wave; the release gate requires at least 50 active external participants, so expand to 50-100 only to close defined device/content/reliability coverage. An active participant is one unique person assigned to the external group with at least one TestFlight-reported session inside the two frozen windows. Before `T0`, assign each person one coverage tier; they count toward that tier's participant floor only after at least one attributable session on it, otherwise only toward the global 50. The ten first-time-iPhone participants here are distinct from `KD-G6`.

Reliability window: stop all internal use, open external access at frozen `T0=00:00 UTC`, and measure two disjoint windows `W1=[T0,T0+7d)` and `W2=[T0+7d,T0+14d)` on one exact processed build. Archive the last-seven-day export/snapshot at each boundary and sum only `W1+W2`; daily rolling views are audit evidence and are never summed. If a boundary is missed, internal use contaminates the window, or the source cannot separate/attribute the window, the gate remains running and starts a clean pair. Per-tester/device records map each session to one declared tier; ambiguous sessions remain in the global denominator but count toward no tier. Use device/Xcode Organizer evidence for hangs/watchdogs. A crash occurrence, distinct non-crash watchdog/unrecovered-hang session, or unresolved unknown termination is a failed-session equivalent assigned by incident timestamp to exactly one window; do not double-count one incident.

Exit:

- `((W1_sessions + W2_sessions) - (W1_failed_equivalents + W2_failed_equivalents)) / (W1_sessions + W2_sessions) >= 99.8%` over the exact-build release-beta window.
- Zero reproducible save loss/P0/P1.
- Every supported tier has at least five assigned participants and 100 attributable sessions inside the overall floor.
- At least ten participants are first-time iPhone players: nine of ten drive without help within two minutes and eight of ten complete first launch -> expedition -> pause/background/resume -> Settle -> Service using touch.
- Store/review path and support material tested by someone outside the development loop.
- Device, accessibility, progression, and content confidence covers the supported matrix.
- No more than two accepted P2s remain under the risk budget; every one has explicit impact, owner, and post-launch plan.

### 11. Store-page truth and reviewer/support rehearsal

Cohort: five target players unfamiliar with the build plus one person outside the development loop for reviewer/support rehearsal.

Tasks:

- View final unbranded product-page screenshots/preview sequence for five seconds, then describe the game, its key decision, and expected play.
- Compare against three adjacent driving/progression product pages without title/logo cues.
- Follow Review Notes from first launch through expedition, failure/extraction, Settle, Service, offline/save/reset, and support/privacy.

Acceptance:

- Four of five identify route-shaped buildcraft and county restoration, and no participant infers a marketed feature absent from the archive.
- Marketing icon/screenshots/previews remain suitable for a 4+ audience even if the calculated game age rating is higher.
- The outside reviewer reaches every documented path without developer explanation and finds working support/privacy material.

### 12. Launch, stabilization, and emergency-patch evidence

Before manual release, the ledger freezes UTC launch time, enabled storefronts, minimum/mid/current public-smoke devices, monitoring sources and expected reporting latency, support/diagnostic owners, staffed/on-call coverage, polling cadence, and the exact stability rules below.

- `KD-G10`: staff continuously from preflight through at least eight hours after first public storefront availability. Check and timestamp store state, support inbox, and available crash/hang/device sources at least hourly; slower Apple sources are checked at every refresh with latency recorded. Minimum/mid/current pass public page/purchase/install/first launch/core offline/save/support smokes. If propagation remains incomplete, named on-call ownership continues hourly checks until the 24-hour state is recorded. Any open P0/P1, unknown live failure, broken source without replacement evidence, or failed smoke keeps the gate running.
- `KD-G11`: measure seven complete UTC days after launch or the latest patch. Aggregate observed reported-session health is >=99.8%; every supported tier with >=100 attributable sessions is >=99.5%; every lower-volume failed equivalent is classified. There is zero reproducible save loss/P0/P1, no unknown termination or support item remains untriaged beyond one staffed day, at most two accepted P2s remain with no escalation, and no same-root-cause P2 report count rises on three consecutive UTC days. Update/save compatibility and declarations remain correct. Delayed/missing evidence extends the window; a patch restarts all seven days.
- `KD-E1 Emergency Patch`: only a post-launch urgent defect qualifies. Build the smallest fix from the latest public tag with the next monotonically increasing patch version/build and no unrelated change; retain reproduced-before/fixed-after evidence on every affected tier plus minimum/mid/current; pass clean update/save smokes from every supported public predecessor, 100% of the full P0/P1 blocker suite and every affected earlier gate, and 1,000/1,000 faults when persistence/progression/lifecycle changes. The exact patch then records >=25 internal-TestFlight sessions over >=4 staffed hours, >=5 per minimum/mid/current and each additional affected tier, 100% conservative session health, and no unknown termination. Evidence, Build, Privacy/Compliance, and Release Owners sign the delta. A broader/non-urgent update uses normal `KD-G7`; a released patch restarts `KD-G11`.

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
- What caused it, how severe was it, and which channel made that clearest?
- Which screen took longest to understand?
- What information was missing, duplicated, or too persistent?
- Which setting helped, and did it preserve the intended feedback?
- After 30 minutes, which motion, sound, flash, particle, or haptic became tiring or masked another cue?

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
- Phone-scale silhouette recognition accuracy and exposure time.
- Critical-cue cause/severity accuracy under full mix, mute/mono, Reduced Motion, and haptics-off conditions.
- Fifteen-minute mix defects and 30-minute visual/audio/haptic fatigue/masking score.

## Progression and economy testing

### Automated

- Simulate reward/cost curves across representative success/failure/extraction rates.
- Catalog benchmark for part/build dominance.
- Detect impossible unlock dependencies, negative values, missing sources/sinks, strict loadout dominance, and duplicate reward application.
- Verify repeated low-risk, fail-fast, circling, safehouse-bounce, abandon, reload, offer-cancel, and loadout-preview strategies remain inferior to cautious objective play; the same committed offer remains identical across loadouts.
- Fuzz at least 10,000 manifests across graph closures, loadouts, Fuel, contracts, and extraction paths; fault-inject every expedition/objective transition and prove the same immutable manifest plus authoritative checksum-valid verified-slot position, Fuel, Integrity, Pressure branch, objective/encounter state, consumed sockets, escrow, pending mutations, current `AppliedExpeditionAssistPolicy`, and `RetainedCampaignDeltaOutbox` resume. Observe/award -> kill/failure/abandon and settlement retry must transfer each retained ID exactly once, with `resolution_id` idempotence.
- Test all delivery, recovery, restoration, mastery-overlay, escrow, outcome, and resume boundaries.

### Human

- First three runs / one hour.
- Four-hour midgame sample across multiple players.
- Complete primary progression with clean profile.
- New chassis starter loadout and catch-up.
- Failure-heavy and success-heavy profiles.
- Alternate build/chassis completion.
- Post-completion mastery return and, only if retained by D020, Expedition Mode.

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
- Full campaign and any D020-locked postgame-mode completion.
- Offline, lifecycle, low-storage, corruption recovery, and emergency-patch migration.
- Exact archive metadata/privacy/accessibility/review agreement.
- 100% of required suites pass. A flaky/quarantined test covering a blocker criterion fails the gate until fixed or replaced with equal coverage; rerunning until green never erases the failing artifact.

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

Response: stop the gate/release path, preserve evidence, assign an owner, fix or supersede the affected product decision, rerun focused regression plus every impacted gate, and require Evidence/Release Owner signoff before resuming.

### P2 — Major

- Important activity/build/region path degraded but workaround exists.
- Repeated confusing UI, pacing, balance, audio, or presentation issue with material player impact.
- Non-common device/layout defect inside supported matrix.
- Performance hitch or content repetition above target without blocking completion.

P2 may be accepted only with explicit impact, scope, workaround, owner, expiry/fix target, and Product/Release Owner signoff. `KD-G3` through `KD-G8` permit at most five accepted open P2s total; `KD-G9` through `KD-G11` permit at most two. No more than one may affect the same common flow or supported tier. Save/progression integrity, security/privacy/legal, common accessibility, install/purchase/launch/support, and App Review defects cannot consume this budget and are P1. A P2 also becomes P1 when it appears in three independent sessions on a common path, affects at least 5% of applicable task opportunities, or affects every tested device in one supported tier. The cap is a ceiling, not a quota; Product or Release Owner may require zero.

### P3 — Minor/polish

- Cosmetic, wording, low-frequency, or small consistency defect without material comprehension/control/progression/reliability impact.

P3 does not justify destabilizing a frozen RC unless the fix is proven trivial and receives normal regression.

## Release blockers

Any of the following blocks 1.0:

- Open P0 or P1.
- Any reproducible profile loss, corruption without recovery, reward duplication, or unsupported migration.
- Conservative exact-build health below 99.8% over disjoint `W1+W2`, fewer than 1,000 sessions/50 active participants, or any tier below five assigned participants/100 attributable sessions.
- Primary progression, extraction, Garage, save/resume, or any D020-locked postgame mode cannot complete.
- Minimum supported device misses approved sustained frame, memory, thermal, launch/resume, touch, or lifecycle budget.
- Required first-minute, handling, hybrid-world, buildcraft, economy, accessibility, and content gates lack passing human evidence.
- App Store declarations/assets/metadata/review notes do not match the selected archive.
- Placeholder/debug/unlicensed/missing content remains.
- Core offline play depends on an unavailable service.
- A release-scope acceptance criterion still contains an unresolved `[PLACEHOLDER]`, lacks a fixed denominator/owner, or has no current evidence-ledger row.
- A claimed accessibility feature fails any common task on its declared device/build.
- Any required blocker suite is failing, silently quarantined, or flaky without equal replacement coverage.

## Playtest definition of done

- Every major system has the correct automated, rendered, human desktop, and where applicable physical-device evidence.
- Raw session records and aggregate findings map to build/commit and acceptance criteria.
- Failures create owned defects/design actions and are retested; targets are not moved after seeing poor results without a recorded product decision.
- Release beta satisfies crash/save/device/content/accessibility gates with no P0/P1.
- `KD-G0` through the currently required gate are PASS in the exact candidate's evidence ledger, with no invalidated inherited evidence.
