# UX, Art, Audio, and Game-Feel Direction Research

Status: resolved recommendation for Wayfinder ticket 04
Research date: 2026-07-11
Public name: unresolved; all name-bearing art remains blocked by D021

## Question

What interface architecture, onboarding, accessibility standard, visual language, asset pipeline, animation, audio, haptics, and feedback target make Keep Driving recognizable, readable, cohesive, and mobile-ready without exceeding production capacity?

## Evidence boundary

This document selects a production direction; it does not claim that the current prototype already delivers it.

Repository evidence establishes the opposite:

- `scripts/game_root.gd` constructs the shipping dashboard and buttons in code and creates empty `AudioStreamGenerator` streams.
- `prototypes/handling_truth_slice/prototype_root.gd` constructs temporary labels in code.
- `prototypes/handling_truth_slice/prototype_world.gd` draws test geometry and route names with Godot's fallback font.
- `prototypes/handling_truth_slice/prototype_audio.gd` generates PCM tones so event and playback paths can be exercised.
- `prototypes/handling_truth_slice/NOTES.md` records representative presentation, audible mix, physical-controller, full-duration, and human verdicts as open.

Those assets are valid mechanical and instrumentation evidence. They are not production UI, art, typography, audio, marketing, or hero-minute evidence, regardless of automated green checks.

The platform sources below establish current design guidance or engine capabilities, not a guarantee of accessibility, performance, review acceptance, or product success. Every recommendation still has to pass this project's human and device gates.

## Requirements extracted from the product contract

The selected direction must do all of the following at once:

1. Put the car, road, route choice, exposed haul, and safe return ahead of menus or lore.
2. Make route and part tradeoffs exact without showing implementation vocabulary or a universal best answer.
3. Reveal only the complexity relevant to the current decision while keeping cost, risk, security, and destructive consequences explicit.
4. Remain operable by keyboard, controller, and eventually landscape touch with deterministic focus, Back, interruption, and recovery behavior.
5. Preserve critical meaning when color, audio, haptics, motion, fine detail, or one input mode is unavailable.
6. Establish a recognizable visual and sonic identity through a small reusable grammar rather than bespoke assets for every state.
7. Fit the existing mobile memory, package, frame, and thermal contracts and expose measurable per-asset costs before content multiplication.
8. Use one semantic event as the source for coordinated UI, world VFX, camera, audio, and optional haptics so feedback cannot contradict itself.

## Direction explored: The County Is the Interface

This direction makes one persistent world surface the product's main interface. The county shifts among Service, Plan, Drive, and Settle postures. Contracts are atlas pins, the Garage is the parked car, Results is a settlement card over the extraction scene, and discoveries/restoration are atlas layers. A small instrument rail carries only Fuel, Integrity, next landmark, and non-default risk facts.

It has the strongest identity and the least dashboard clutter. It lets the car carry damage/cargo/build state and lets roads, landmarks, closures, light, smoke, and signs carry navigation. The title can open over the real Garage lot and the map can feel like the camera rising into the same living atlas.

It is rejected as the complete architecture. A spatial interface alone makes exact build comparison, uncertain route facts, escrow settlement, recovery errors, 200% text, focus order, and screen-reader feasibility harder. It also makes every comprehension defect an expensive world-art problem. The useful part is the rule that the world communicates first and explicit UI supplies the smallest reliable equivalent.

## Direction explored: County Field Manual

This direction makes the interface a reusable roadbook built from a small grammar: glyph, label, meter, fact row, tag, divider, focus ring, and action chip; then instrument, navigation, choice, compare, warning, prompt, and receipt cards. Drive, Plan, and Settle arrange the same components differently.

It is strongest at information precision, responsive reflow, accessibility, localization, production reuse, error states, and controller focus. A `Fact` can carry label, value, unit, trend, shape, reason, and spoken text. A `Choice` can show known, estimated, and unknown facts without inventing a score. The same Receipt can settle extraction, failure, restoration, purchase, and recovery while preserving exact wording.

Used alone, it risks becoming a beige dashboard laid over the game. Card ubiquity can weaken the car/world fantasy, progressive disclosure can hide consequences, and a growing component library can become abstraction work without player value. The useful part is its state contract and bounded component grammar.

## Direction explored: Kinetic Instrument Atlas

This direction treats interface feedback as physical behavior: routes ink onto the atlas, cargo straps tighten, parts bolt onto the car, gauges shudder locally, warnings invade the route edge, and Results replay as tire marks. It coordinates animation, sound, camera, VFX, and haptics from semantic events.

It has the strongest immediate tactility and can make surface, weight, impact, warning, reward, installation, and extraction memorable. It also gives the hero minute a strong cadence: ignition, surface seam, impact, fork, signal, reward, and return.

It is rejected as the dominant language. Kinetic transitions become slow under repetition, layered vehicle variants multiply asset work, continuous texture becomes sensory fatigue, and spectacle competes with phone-scale road reading. The useful part is causal multimodal feedback at decision and consequence moments, with cancellation, rate limits, and intensity controls.

## Comparison and selected synthesis

The County direction best answers “what makes this recognizable?” The Field Manual best answers “how can every fact, state, input, and aspect remain reliable?” The Kinetic direction best answers “how does a driving decision feel consequential?” None is sufficient alone.

Select **Animated Road Atlas + County Field Manual + Semantic Kinetics**:

- The world and vehicle communicate first through silhouette, surface, landmark, installed part, cargo, damage, weather, and motion.
- A bounded Field Manual component system carries every exact fact, comparison, action, failure, and accessible equivalent.
- Kinetic feedback is reserved for input acknowledgement, state transition, decision commitment, physical consequence, warning escalation, reward settlement, restoration, and extraction.
- There is no permanent dashboard, fully diegetic menu stack, or spectacle layer independent of meaning.

This synthesis sharpens the existing “Sun-Bleached Survival Road Atlas” direction rather than replacing it.

## Interface architecture

```text
AppShell
├── TitleSurface
│   ├── Continue / Drive
│   ├── New profile / reset
│   └── SystemSheet
├── FirstRunPreflightCard
├── CountySurface
│   ├── Service posture
│   │   ├── VehicleBench
│   │   ├── PartShelf + CompareCard
│   │   └── TestLot
│   ├── Plan posture
│   │   ├── AtlasCanvas
│   │   ├── RouteLedger
│   │   ├── ContractCards
│   │   └── Records / discoveries
│   ├── Drive posture
│   │   ├── WorldCueLayer
│   │   ├── InstrumentRibbon
│   │   ├── ContextCard
│   │   ├── CriticalCard
│   │   └── TouchDeck when active
│   └── Settle posture
│       ├── OutcomeStamp
│       ├── SettlementReceipt
│       └── ActionStrip
└── SystemSheet
    ├── Pause / objective / controls
    ├── Settings / accessibility / language
    ├── Save management / recovery
    └── Privacy / support / credits / licenses
```

`TitleSurface` may reveal the live Garage lot, and Plan may visually rise from the county, but these remain application states rather than camera tricks. Reduced Motion replaces large spatial transitions with immediate cuts or short fades.

Every posture has:

- exactly one default primary action;
- explicit focus entry, order, restoration, Back/Cancel, and destructive-confirm behavior;
- loading, empty, ready, disabled, stale, error, and recovery states where relevant;
- pointer, keyboard, controller, and eventual touch commands mapped to the same intents;
- no authority to calculate domain truth, transact, settle, or save.

## First launch and hero minute

Use one skippable **Preflight Card**, not a four-page mandatory wizard. It shows detected language and input, direct shortcuts for text scale/high contrast/reduced motion/auto-accelerate, brightness, and a live real-engine plus warning preview. Safe defaults are already selected and `Drive now` remains the primary action. Full settings remain available.

The representative hero minute is:

- **0-10 seconds:** the production car is visible in the Garage lot; one contextual accelerate prompt; movement target is under ten seconds.
- **10-22 seconds:** broad steer, brake/reverse, and optional handbrake teaching occurs through spatial gates without freezing the car.
- **22-30 seconds:** Fuel and Integrity are legible by second 25; the car crosses a real surface seam and contacts one harmless breakable.
- **30-60 seconds:** a landmark frames a road/dirt/mud fork with an optional signal; route pennants and surface treatment communicate distinct tradeoffs; the return direction remains visible.
- **First return:** a short Settlement Receipt explains secured/lost/changed state; the player chooses one of two useful starter parts; the car, compare facts, route forecast, sound, and test-lot behavior update together.

No first-minute cinematic, lore crawl, account gate, lethal spawn, modal reward parade, or debug telemetry is permitted.

## Information placement contract

Information belongs at its cheapest reliable layer:

1. **World and car:** road class/surface, landmark, physical hazard, closure, objective location, installed major part, cargo presence, damage stage, weather, and broad threat direction.
2. **Drive HUD:** Fuel, Integrity, next meaningful navigation fact, exposed haul, actionable prompt, and current warning escalation.
3. **Plan:** route alternatives, known/estimated/unknown conditions, build and cargo consequences, return points, objective terms, discoveries, and restoration state.
4. **Service:** exact current-versus-candidate values, capability, cost, compatibility, Build Capacity, ownership, source, and route consequences.
5. **Settle:** cause, secured value, lost value, committed county change, retained observation, save result, and one next action.
6. **System:** settings, assistance, recovery, diagnostics detail, privacy, support, credits, and licenses.

A critical fact may be repeated across world/HUD/audio/haptic channels for perception. A noncritical fact is not duplicated merely to fill space. When space contracts, optional detail folds before cause, risk, cost, security, destructive consequence, or the primary action.

## Component and presenter contract

The production UI starts with a ceiling of eight primitives and seven card families. A new component is permitted only when the gallery proves the existing grammar cannot express a required state without semantic confusion.

```text
Primitives
  Glyph, Label, Meter, FactRow, Tag, Divider, FocusRing, ActionChip

Cards
  Instrument, Navigation, Choice, Compare, Warning, Prompt, Receipt

CardModel
  stable_id
  fold: glance | open | inspect
  severity: quiet | forecast | urgent | critical | resolved
  headline_key
  glyph_id
  facts[]
  actions[]
  explanation_key
  certainty: known | estimated | unknown

Fact
  label_key, value, unit_key, trend, shape_id, reason_key, spoken_text_key

Action
  intent_id, label_key, role, enabled, disabled_reason_key, input_glyph
```

Presenters consume immutable snapshots and emit typed intents. They may select copy, order, fold, and responsive layout. They may not query world dictionaries, compose stats, determine affordability, mutate progression, settle escrow, roll content, or write saves.

## Posture rules

### Drive

- No more than four persistent glance facts: Fuel, Integrity, next navigation landmark/action, and exposed haul.
- Pressure appears when changed, forecast-relevant, or inspected; it is not a mysterious always-on meter.
- At most one warning expands. Lower-priority warnings compress without losing their cause.
- At most one contextual card is visible. It disappears when the action is unavailable or demonstrated.
- Touch controls own the lower corners; HUD and warnings cannot enter the finger zones or projected driving line.

### Plan

- AtlasCanvas and RouteLedger are equivalent views of the same route facts; spatial navigation never becomes the only path.
- Each option shows surface mix, closure confidence, cargo burden, relevant build capability, broad Pressure/weather, return points, and uncertainty.
- Known, estimated, and unknown are visually and textually distinct. No single route score, mandatory GPS line, or “recommended build” solves the decision.
- Phone layout shows one primary card/drawer; desktop may show the atlas plus two supporting rails.

### Service

- The car remains central and visibly updates for major installed parts, cargo shape, and damage stage.
- Compare separates Gains, Costs, and Route consequences. Green/red is supplemental.
- Build Capacity is visible; compatibility and disabled actions state the exact reason.
- Install/swap is immediate and undoable. Fabrication or destructive/reset actions receive explicit consequence confirmation.

### Settle

- One receipt answers, in order: why the expedition ended, what was secured, what was lost, what changed in the county, what observation persisted, whether save succeeded, and what action is next.
- Results never rely on a scrolling event log or animation completing before control returns.

## Semantic feedback contract

Gameplay emits semantic facts once. A FeedbackDirector maps them to outputs based on priority, capability, accessibility settings, visibility, cooldown, and performance tier.

```text
FeedbackEvent
  event_id
  source_id
  phase: forecast | commit | consequence | resolve
  priority: critical | decision | status | flavor
  magnitude: light | medium | heavy
  direction: optional world vector
  cause_key
  cooldown_group
  dedupe_key
```

Initial event families:

| Family | Required meaning | Visual | Audio | Haptic |
|---|---|---|---|---|
| Input acknowledgement | command received | control press/focus state | restrained UI tick where useful | selection only on supported devices |
| Surface transition | grip/noise state changed | wheel/surface effect and car response | crossfaded surface layer | off by default; prototype only |
| Drift threshold | controlled slip entered/exited | tire trail/body state | tire/surface change | short optional threshold pulse |
| Impact | collision weight and direction | source flash/debris/camera impulse | light/medium/heavy material family | short weight pattern |
| Resource warning | Fuel/Integrity forecast, urgent, critical | labeled gauge/car/world cue | priority warning family | optional rate-limited warning |
| Pressure change | disclosed cause changed threat state | labeled route-edge/world cue | transition motif; never sole meaning | optional only at escalation |
| Haul state | acquired, exposed, fragile, secured, lost | cargo/card state | distinct acquire/secure/loss cue | only commit/resolve moments |
| Objective/restoration | state advanced or county changed | world/atlas mutation plus receipt | authored resolve cue | success pattern if enabled |
| Part installation | build changed | visible hardware/stat/forecast update | mechanical install/state cue | short causal confirmation |
| Save/recovery | preservation succeeded or failed | exact persistent status/error | noncritical success or unmistakable error | never required |

Continuous simulation values drive continuous vehicle animation/audio. They do not spam discrete events. Critical cues reserve capacity and may duck masking Music/World output briefly. Haptics never carry unique meaning and never run in the background.

## Visual language

Retain **Sun-Bleached Survival Road Atlas** with three value bands—ink/deep road, terrain/paper midtones, and bone/highlights—plus stable semantic accents: hero yellow, safe teal, route cyan, warning vermilion.

- World readability comes from value, silhouette, heading, scale, spacing, and motion before texture or hue.
- Atlas styling uses ink lines, clipped card corners, registration marks, sparse paper grain, stamps, and route hatching; text surfaces remain flat and high-contrast.
- The player vehicle uses a forward wedge, stable dark outline, visible wheel/heading response, and major installed-part/cargo/damage silhouettes.
- Region identity changes terrain forms, composition, vegetation/wreck kits, weather, landmark silhouette, ambience, and motion—not the semantic UI colors.
- No baked text. No generated or sourced asset enters production without a coherent style pass and provenance.
- Name-bearing type, logo, icon, launch, and marketing assets remain blocked until D021 passes.

## Asset production contract

Every production asset carries universal metadata: stable ID and package; creator/source; ownership/license/allowed use/attribution/review; original or best-available source file plus deterministic runtime artifact; import preset/version; memory/package class; and hero/representative/production status.

Kind-specific extensions apply only where meaningful:

- spatial visuals: palette role, scale, pivot/origin, collision/navigation relationship, atlas/material group, compression, filter/mipmap, quality tier, and LOD;
- UI/icons/fonts: component/icon role, optical sizes, localization/text alternative, glyph coverage, and required contrast/high-text-scale variants;
- audio: master/runtime format, channel/rate/loop/trim/compression, bus/event family, residency/streaming, and concurrency group;
- VFX/animation/haptics: event family, priority, pool/cadence/intensity limits, Reduced Motion/Effects behavior, and platform availability.

Hero assets carry individual proof IDs and measured authoring/rework. Routine variants track proof, hours, rework, and defects at batch/tranche level; individual defect IDs are linked only when a defect exists. Licensed assets are not required to invent an unavailable editable master.

The pipeline is:

```text
Best-available source + provenance
  -> style/readability review
  -> deterministic export
  -> Godot import preset
  -> catalog + license + budget validation
  -> asset gallery / representative scene
  -> desktop and mobile-profile proof
  -> content package
```

Godot's import metadata is committed; `.godot/` generated cache is not. Source masters may exceed runtime resolution, but runtime size/compression is selected from measured use. The initial atlas-page hypothesis is `[PLACEHOLDER: 2048 x 2048]`; a 4096 page or uniquely loaded texture requires a recorded quality/memory comparison. Final thresholds are locked by representative scene and physical-device proof, not taste.

Use staged representative gates so the direction does not require later systems before their dependencies exist:

1. **Phase-2 Drive hero:** one vehicle rig, Garage lot and road fork, primary/secondary/offroad treatments, three surfaces, landmark, three obstacle weights, threat/hazard, objective marker, safehouse silhouette, Fuel/repair/cargo/reward silhouettes, Drive HUD subset, real idle/load/high engine, three surface states, three impact weights, warning escalation, pickup/reward, and minimal UI feedback. This gates multiplication of vehicle/world/Drive-feedback families.
2. **Phase-3 integrated loop:** representative Service compare/part-install, extraction/safehouse mutation, Settle Receipt, exact secured/lost state, part-install/extraction/Settle cues, one region ambience, and minimum sparse music transition across a 15-minute loop. This gates multiplication of Service/Settle, region ambience, and settlement families.
3. **Phase-8/10 complete shell and mix:** remaining common component states, SystemSheet/settings/error/recovery, full mix and semantic event map, 30-minute desktop visual/audio fatigue/masking, and separate physical-device haptic proof. This gates remaining UI/audio/haptic family multiplication.

Each family may multiply only after its own stage passes recognition, throughput, provenance, import, memory/package, mix, and performance evidence. Phase 3's D020 scope lock converts measured stage costs into explicit family caps before broad content production.

## Animation and VFX

- Simulation begins vehicle response on the next fixed step. Visual smoothing cannot delay control truth.
- UI acknowledgement remains under 100 ms.
- Existing transition values—`[PLACEHOLDER: 120-180 ms]` for small changes and `[PLACEHOLDER: 250-400 ms]` for major nonblocking reveals—are tuning hypotheses, not reasons to delay frequent actions.
- Every transition is cancellable or safely resolves to its final state. Repeated Garage, map, and Results actions cannot queue presentation debt.
- Vehicle motion derives from steer, load, slip, speed, suspension, impact, cargo, and damage state; avoid bespoke animation multiplication per loadout.
- VFX is pooled, importance-ranked, rate-limited, and capped. Essential road/hazard/warning silhouettes survive the lowest tier and Reduced Effects.
- Camera impulse is local, magnitude-bounded, and independently adjustable. Reduced Motion replaces large movement/parallax with cut, opacity, outline, or short fade.
- Reward and restoration motion never blocks control or conceals settlement truth.

## Audio direction and budget contract

Use the existing Master, Music, Vehicle, World, and UI buses. `AudioDirector` owns state, routing, concurrency, pause/background behavior, and mix hierarchy; game systems request semantic audio and never manipulate players directly.

- Vehicle: idle/load/high/strain layers or a measured equivalent, pitch/blend from load plus speed, surface crossfade, skid/brake/reverse, damage rattle, and critical sputter.
- World: light/medium/heavy material impacts, threat families, weather, region ambience, safehouse/landmark/event signatures.
- UI/reward: restrained focus/commit/error cues; Fuel, repair, Scrap, part, blueprint, discovery, restoration, extraction, and loss remain distinguishable where sound adds value.
- Music: sparse state/stem transitions for travel, rising Pressure, critical return, safehouse, and settlement; no gameplay fact exists only in music.

Short frequent effects default to WAV with measured import compression; longer music/ambience default to Ogg Vorbis or another profiled format. Source masters remain lossless. Mono, sample rate, loop, trim, and compression are chosen per asset and recorded. This follows Godot 4.7's own distinction between CPU-light WAV for short/repetitive effects and smaller compressed formats for long content, while still requiring profiling on target devices.

Initial concurrency hypotheses, to be replaced by measured caps:

- `[PLACEHOLDER: 24]` simultaneous voices on the minimum-device profile with `[PLACEHOLDER: 4]` reserved for critical vehicle/warning/UI events;
- one engine state set and one surface set per player vehicle;
- `[PLACEHOLDER: 3]` same-family impact voices before oldest/quietest stealing;
- `[PLACEHOLDER: 2]` simultaneous routine UI voices;
- ambience and music stem counts declared per region/state, never unconstrained.

Automated proof verifies nonempty real resources, bus names/routes, loop/state transitions, voice stealing, pause/resume, and no duplicate playback. Acceptance additionally requires captured output, a human audible check, a 15-minute complete-state mix, a 30-minute fatigue/masking session, mono/no-audio tests, and representative full-stack CPU/memory proof. Generated tones and counters cannot satisfy production acceptance.

## Haptics

Haptics are semantic punctuation, not continuous road texture. Initial allowed families are selection, drift threshold, light/heavy impact, critical warning, pickup/commit, restoration, and successful extraction. Every pattern is causal, short, optional, intensity-scalable, rate-limited, and paired with at least one non-haptic cue.

Continuous surface haptics remain disabled by default and cannot graduate without physical-device comfort, battery, control-precision, and 30-minute fatigue proof. Unsupported or disabled haptics remove no information. Platform APIs remain behind the platform adapter selected by ticket 05.

## Accessibility and mobile-readiness standard

The design baseline is broader than any launch claim:

- 48 x 48-point minimum interactive targets, 12-point separation for conflicting actions, safe area plus 16-point design inset, and `[PLACEHOLDER: 64-point]` primary touch-driving controls for physical-device validation;
- 100%, 150%, and 200% text; +40% pseudolocalization; no horizontal-scroll dependency for essential copy;
- no color-only, audio-only, haptic-only, motion-only, or fine-detail-only critical fact;
- visible focus, default focus, focus restoration, Back/Cancel, destructive confirmation, and complete keyboard/controller/touch paths;
- remapping, dead-zone/sensitivity adjustment, hold/toggle alternatives, steering/brake assists, auto-accelerate, longer timing windows, and left-handed touch layout;
- independent camera shake, flash, particle, weather, haptic, music, vehicle, world, and UI intensity/volume controls where applicable;
- Reduced Motion and Reduced Effects preserve immediate state recognition;
- visual equivalents for critical audio, mono-compatible cues, optional directional sound indicators, captions for spoken/semantic content;
- route-list and fact-list equivalents for spatial-only map communication;
- no timed toast is the only copy of important information.

Apple's game-control guidance says default platform input remains important, recommends reachable safe-area-aware controls, visible/tactile press states, and 44-point frequently used touch controls. The project deliberately uses a stricter 48-point floor. Apple and Microsoft's accessibility guidance both support multiple sensory channels; Microsoft also warns that haptics must not be the only channel because devices or players may not use them.

An App Store Accessibility Nutrition Label is a release assertion, not a design intention. A feature is claimed only after every common task passes Apple's current device-specific evaluation criterion in the exact release candidate. Unsupported native/screen-reader behavior is documented honestly rather than inferred from visual compliance.

## Production ceilings and proof gates

These ceilings keep the synthesis buildable:

- A counted UI component is a reusable primitive, card family, or extension widget with its own public state contract and gallery entry. The eight primitives plus seven card families consume 15 of the initial 20-component ceiling; up to five extension widgets such as AtlasCanvas, VehicleBench, or TouchDeck remain before an explicit review. Screen shells and Service/Plan/Drive/Settle layout compositions do not count separately unless they introduce reusable state/behavior.
- Drive HUD: at most four persistent glance facts, two transient items, one expanded critical warning, and one context card.
- Any card/screen: at most three simultaneous actions and exactly one primary action.
- Title Continue, Pause Resume, and Results Continue are one-input actions.
- No bespoke screen, vehicle feedback rig, region effect, or audio family multiplies before its corresponding staged representative gate passes.
- Every asset family reports unique source hours, marginal-variant hours, integration, QA, accessibility, localization, memory, package, runtime, and rework cost to D020.
- Mobile budgets remain the canonical `MOBILE_PORTING_PLAN.md` hypotheses: <=350 MB gameplay working set, <=500 MB process peak on the minimum device, and quality scaling that removes optional decoration/effects/voices before critical readability.
- Phase 2 is measurement-only for presentation sub-budgets: report resident texture bytes/pages, audio resident/stream buffers and peak voices, materials/canvas draws, nodes, live VFX emitters/particles, package bytes, main/GPU/audio time, and haptic event cadence for each staged proof. Before any family multiplies, Phase 3 records measured caps/headroom in `SCOPE_LOCK.md`; the complete representative maximum scene must still fit the whole-process/frame/package limits with D020's separate 30% unallocated risk reserve intact.
- Screenshot matrix covers four aspect classes x three text scales x normal/+40% pseudoloc x keyboard/controller/touch presentation.

The direction graduates only when:

1. Four of five new players move within ten seconds, identify objective plus Fuel/Integrity within 30 seconds, and understand the fork/return choice within 60 seconds.
2. At least 80% correctly order compared route risks, explain a chosen part's capability/tradeoff, and distinguish secured, exposed, lost, and committed state.
3. Every common flow completes by keyboard and controller on desktop, and later by touch/controller on physical iPhone, with no pointer/gesture-only dependency.
4. Common flows pass smallest viewport, 200% text, +40% pseudoloc, contrast, non-color cues, Reduced Motion, no-audio/mono, focus, and error/recovery checks.
5. In a ten-person recognition subcohort, each critical category—player car, safehouse, primary route classes, objective, hazard, threat, Fuel, repair, and cargo—is randomized and shown at exact 896 x 414 logical phone-proof scale for `[PLACEHOLDER: 500 ms]` inside representative density, with blank and near-neighbor controls. At least eight of ten identify each category and false positives remain `[PLACEHOLDER: <=10%]`; failures simplify art before labels multiply.
6. Four of five players identify the cause and severity of each critical feedback cue without relying on a single sensory channel.
7. A 15-minute full-state mix passes. Separately, a 30-minute desktop visual/audio session samples 0-5 masking/fatigue every five minutes, stops immediately at participant request or >=4 discomfort, and requires `[PLACEHOLDER: median <=2 and no unresolved score >=3]`. Physical-iPhone haptic comfort uses its own device session and the same stop rule; no desktop simulation stands in for it.
8. Representative source/license, import, memory, package, voice, VFX, frame, hitch, and clean-export evidence passes before content multiplication.
9. The exact release candidate passes every App Store accessibility feature criterion that will be claimed.

## Primary-source guidance used

- [Apple: Designing for games](https://developer.apple.com/design/human-interface-guidelines/designing-for-games) — support platform-default interaction and prioritize perceivability across sight, hearing, and touch.
- [Apple: Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls) — touch reach, safe areas, control size, press feedback, context-sensitive controls, and controller conventions.
- [Apple: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility/) — personalization, multimodal feedback, Reduce Motion, and accessibility testing.
- [Apple: Playing haptics](https://developer.apple.com/design/human-interface-guidelines/playing-haptics) — consistent causal meanings and supported-device behavior.
- [Apple: Accessibility Nutrition Labels overview](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels/) — common-task and per-device evaluation before a support claim.
- [Xbox Accessibility Guideline 103](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/103) — additional channels for visual/audio cues and the limits of haptics as a channel.
- [Xbox Accessibility Guideline 105](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/105) — independently adjustable categories for important audio.
- [Godot 4.7: Import process](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/import_process.html) — committed import metadata and generated-cache behavior.
- [Godot 4.7: Importing audio samples](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_audio_samples.html) — format, compression, channel, rate, loop, and CPU/file-size tradeoffs.
- [Godot 4.7: General optimization](https://docs.godotengine.org/en/4.7/tutorials/performance/general_optimization.html) — measure on multiple devices and design for performance before content scale.

## Decision summary

**Select:** world-first animated road atlas, bounded Field Manual components, semantic kinetic feedback, one Preflight Card, Service/Plan/Drive/Settle postures, a real asset/provenance/import pipeline, real state-driven audio, discrete optional haptics, and an end-to-end accessibility baseline.

**Carry forward as hypotheses:** exact motion durations, 64-point primary touch controls, atlas page size, audio voice caps, 500 ms recognition exposure, and fatigue threshold. They stay marked `[PLACEHOLDER]` until representative desktop and physical-device evidence locks them.

**Reject:** fully diegetic/spatial-only UI, dashboard-heavy card walls, animation for decoration, continuous haptics by default, generated-tone production acceptance, unbounded component or asset families, baked text, inaccessible map-only facts, and any App Store accessibility claim inferred from intent.
