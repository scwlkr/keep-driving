# Decide UX Art Audio And Game Feel Direction

Type: prototype
Status: resolved
Blocked by: 01, 02, 03

## Question

What interface architecture, onboarding, accessibility standard, visual language, asset pipeline, animation, audio, haptics, and feedback target make Keep Driving recognizable, readable, cohesive, and mobile-ready without exceeding production capacity?

## Answer

Select **Animated Road Atlas + County Field Manual + Semantic Kinetics**.

The county and car communicate first through road hierarchy, surface, landmark, closure, cargo, installed parts, damage, weather, silhouette, and motion. A bounded Field Manual component grammar carries every exact comparison, action, failure, recovery, localization, and accessible equivalent. Kinetic visual/audio/camera/haptic feedback appears only for meaningful input, transition, decision, consequence, and settlement events.

Pure diegetic/spatial UI is rejected because it hides exact build, route uncertainty, escrow, recovery, focus, and high-text-scale facts. A card-only dashboard is rejected because it weakens the car/world identity. Spectacle-first feedback is rejected because it multiplies assets, delays repeated actions, masks the road, and causes fatigue.

### Interface contract

- **TitleSurface:** Continue/Drive, new/reset, and SystemSheet access; it may reveal the live Garage lot.
- **Service:** vehicle-first loadout/fabrication/test-lot posture with Gains, Costs, and Route consequences; immediate undoable swap and exact disabled reasons.
- **Plan:** AtlasCanvas plus equivalent RouteLedger, contract cards, known/estimated/unknown conditions, records, and restoration state; no universal route score or “best build.”
- **Drive:** world cues plus at most four calm glance facts—Fuel, Integrity, next landmark/action, exposed haul—one expanded warning, two transients, and one context card. Pressure appears when changed/relevant/inspected.
- **Settle:** one authoritative Receipt stating cause, secured, lost, county change, retained observation, save result, and one next action.
- **SystemSheet:** pause, settings/accessibility/language, save/recovery, privacy/support/credits/licenses.

Presenters consume immutable snapshots, choose copy/order/fold/layout, and emit typed intents. They do not calculate domain truth, transact, settle, mutate, roll, or save. Every posture has one default primary action plus explicit focus, Back/Cancel, confirmation, loading/empty/disabled/error/recovery, and input-mode behavior.

A counted component is a reusable primitive, card family, or extension widget with a public state contract and gallery entry. Eight primitives plus seven card families consume 15 of the initial 20-component ceiling; five extension widgets remain before review. Screen/posture compositions do not count unless they add reusable behavior.

### First launch and hero minute

- One skippable **Preflight Card** shows detected language/input, direct larger-text/high-contrast/reduced-motion/auto-accelerate shortcuts, and a live production brightness/engine/warning check; `Drive now` remains focused.
- 0-10 seconds: production car visible and moving.
- 10-22: broad steering and brake/reverse teaching through play.
- 22-30: Fuel/Integrity legible by second 25; real surface seam and harmless breakable.
- 30-60: landmark-framed road/dirt/mud fork, optional signal, distinct tradeoffs, return direction.
- First return: Receipt plus choice between two useful parts; car, comparison, route forecast, sound, and test-lot behavior update together.

No account wall, lore crawl, lethal first spawn, modal reward parade, or debug telemetry.

### Visual and asset contract

- Retain the Sun-Bleached Survival Road Atlas: ink/deep road, terrain/paper midtones, bone/highlights, then hero yellow, safe teal, route cyan, and warning vermilion.
- Use value, silhouette, heading, spacing, and motion before texture/hue. Field Manual styling may use clipped corners, rules, stamps, hatching, and sparse grain; copy surfaces stay flat/high-contrast.
- Name-bearing type/logo/icon/launch/marketing remains blocked by D021.
- Universal asset metadata is only stable ID/package, best-available source/runtime artifact, provenance/license/attribution/review, import version, memory/package class, and status. Spatial, UI/font/icon, audio, VFX/animation, and haptic extensions apply only where meaningful. Hero cost/rework/proof is per asset; routine variants report by tranche.
- Deterministic source/provenance -> style review -> export/import -> catalog/license/budget validation -> gallery/representative scene -> platform proof -> package.

Use staged gates rather than one circular mega-tranche:

1. **Phase 2 Drive hero:** vehicle/world/Drive HUD plus real engine/surface/impact/warning/pickup/minimal-UI audio; gates those families.
2. **Phase 3 integrated loop:** Service compare/install, safehouse/extraction mutation, Settle Receipt, exact secured/lost state, settlement cues, ambience/music, and 15-minute loop; gates those families.
3. **Phases 8/10 complete shell/mix:** remaining common states, SystemSheet/error/recovery, full mix/event map, desktop fatigue/masking, and separate physical haptics; gates remaining families.

Phase 2 measures texture residency/pages, audio buffers/voices, materials/draws, nodes, VFX emitters/particles, package bytes, frame/audio time, and haptic cadence. Phase 3 converts measurements into explicit family caps/headroom in D020's `SCOPE_LOCK.md`, preserving the whole-process budgets and separate 30% risk reserve before broad production.

### Animation, feedback, audio, and haptics

- Simulation response begins next fixed step; UI acknowledges under 100 ms.
- `[PLACEHOLDER: 120-180 ms]` small and `[PLACEHOLDER: 250-400 ms]` major nonblocking transitions are cancellable tuning hypotheses, never control delays.
- Gameplay emits one deduplicated semantic event carrying source, forecast/commit/consequence/resolve phase, critical/decision/status/flavor priority, magnitude, optional direction, localized cause, cooldown, and dedupe identity.
- Feedback/Audio directors map that truth to world/UI/VFX/camera/audio/optional haptic outputs. Continuous simulation drives continuous vehicle/audio state without per-frame event spam. Critical channels reserve capacity and may briefly duck masking buses.
- Real Master/Music/Vehicle/World/UI buses; short frequent effects use profiled WAV imports, long music/ambience use profiled Ogg or measured alternatives. Initial `[PLACEHOLDER: 24]` minimum-device voices/four critical reserves are hypotheses until representative profiling.
- Generated tones/counters never satisfy production audio. Require real resource/routing/dedupe/stealing tests, captured/human proof, a 15-minute mix, and a separate 30-minute desktop visual/audio fatigue session.
- Haptics are discrete, causal, optional, adjustable, rate-limited, paired with another cue, and background-suppressed. Continuous road texture is off by default pending physical comfort, precision, battery, and fatigue proof.

### Accessibility and mobile readiness

- 48 x 48-point minimum targets, 12-point conflicting-action separation, safe area +16, and `[PLACEHOLDER: 64]` primary touch controls pending device proof.
- 100/150/200% text, +40% pseudolocalization, no essential horizontal scroll, explicit focus/Back/restoration, and keyboard/controller/touch intent parity.
- No critical fact depends on color, audio, haptic, motion, fine detail, or spatial-map position alone; RouteLedger/fact-list equivalents cover spatial cues.
- Reduced Motion/Effects, visual critical audio, mono-compatible cues, independent buses/intensities, remapping/dead zones, hold/toggle, assists, auto-accelerate, longer windows, and left-handed touch layout.
- App Store accessibility labels are exact-release, per-device, every-common-task claims—not inferred from settings or visual compliance. Unsupported native/screen-reader features remain unclaimed.

### Proof before multiplication

- Four of five move in ten seconds, identify objective/Fuel/Integrity in 30, and understand the fork/return choice in 60.
- At least 80% explain compared route risk, selected part capability/tradeoff, and secured/exposed/lost/committed state.
- Ten-person randomized per-category silhouette trials at 896 x 414, `[PLACEHOLDER: 500 ms]`, representative density, blank/near-neighbor controls: at least eight of ten per critical category and `[PLACEHOLDER: <=10%]` false positives.
- Four of five identify critical cue cause/severity without one required channel.
- Desktop 30-minute fatigue/masking samples 0-5 every five minutes, stops at request or >=4, and targets `[PLACEHOLDER: median <=2 and no unresolved >=3]`; physical-iPhone haptics use a separate device session and the same stop rule.
- Every corresponding staged proof passes provenance/import, throughput/rework, clean export, frame/memory/package, and human evidence before its family multiplies.

Detailed alternatives, first-party source research, component/event schemas, and failure analysis: [`docs/research/UX_ART_AUDIO_AND_GAME_FEEL_DIRECTION.md`](../../../docs/research/UX_ART_AUDIO_AND_GAME_FEEL_DIRECTION.md). Canonical contracts: [`docs/UX_AND_ART_DIRECTION.md`](../../../docs/UX_AND_ART_DIRECTION.md), decisions D030-D034 in [`docs/DECISIONS.md`](../../../docs/DECISIONS.md), [`docs/TECHNICAL_ARCHITECTURE.md`](../../../docs/TECHNICAL_ARCHITECTURE.md), [`docs/PLAYTEST_PLAN.md`](../../../docs/PLAYTEST_PLAN.md), and phase gates in [`docs/ROADMAP_TO_1.0.md`](../../../docs/ROADMAP_TO_1.0.md).
