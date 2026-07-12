# Keep Driving UX, Art, Audio, and Game-Feel Direction

Status: resolved 1.0 experience specification; Wayfinder ticket 04
Direction date: 2026-07-11

## Experience goal

Keep Driving should feel like an animated survival road atlas wrapped around a responsive arcade car. It is rugged, direct, readable, and tactile—not a debug tool, generic Godot interface, grim unreadable horror game, or busy free-to-play dashboard.

The selected synthesis is **Animated Road Atlas + County Field Manual + Semantic Kinetics**. The world and vehicle communicate first; a bounded card/component grammar carries exact and accessible facts; animation, audio, VFX, camera, and optional haptics reinforce only meaningful input, state, decision, consequence, and settlement events. `docs/research/UX_ART_AUDIO_AND_GAME_FEEL_DIRECTION.md` records the three competing directions, tradeoffs, primary-source guidance, budgets, and proof gates.

The interface has three jobs:

1. Get the player driving and understanding the immediate risk quickly.
2. Make route, cargo, extraction, and build decisions exact without exposing implementation vocabulary.
3. Preserve clarity across desktop, controller, and landscape touch layouts, including interruption and accessibility needs.

## Interface architecture

```text
AppShell
├── TitleSurface
│   ├── Continue / Drive
│   ├── New profile / reset
│   └── SystemSheet
├── FirstRunPreflightCard
├── CountySurface
│   ├── Service — vehicle, loadout, fabrication, test lot
│   ├── Plan — atlas, route ledger, contracts, records
│   ├── Drive — world cues, instrument ribbon, context/warning, touch deck
│   └── Settle — outcome, secured/lost/changed receipt, next action
└── SystemSheet
    ├── Pause / objective / controls
    ├── Settings / accessibility / language
    ├── Save management / recovery
    └── Privacy / support / credits / licenses
```

Service, Plan, Drive, and Settle are application postures over a coherent county surface; they are not permission for an opaque camera-only interface. Large spatial transitions become immediate cuts or short fades under Reduced Motion. Screen routing is an explicit application-flow state machine.

Every posture has one default primary action plus explicit focus entry/order/restoration, Back/Cancel, destructive confirmation, loading, empty, ready, disabled, stale, error, and recovery behavior where relevant. Presenters consume immutable snapshots and emit typed intents. They never reach into world dictionaries, compose stats, determine affordability, settle escrow, mutate progression, or write saves. All player-facing strings use localization keys.

The initial production grammar is capped at eight primitives—Glyph, Label, Meter, FactRow, Tag, Divider, FocusRing, ActionChip—and seven card families—Instrument, Navigation, Choice, Compare, Warning, Prompt, Receipt. These consume 15 of the initial 20-component ceiling; up to five reusable extension widgets such as AtlasCanvas, VehicleBench, or TouchDeck remain. A counted component has its own public state contract and gallery entry; screen shells/posture layouts do not count unless they add reusable state/behavior. Additions require a gallery example proving the existing grammar cannot express a required state clearly.

## First launch and onboarding

### First-launch setup

Use one short, skippable **Preflight Card** with safe defaults rather than a mandatory sequence:

1. **Language and input** — use system language when supported; always offer English; detect keyboard/mouse, controller, or touch and explain that either can change.
2. **Accessibility shortcuts** — larger text, high-contrast cues, reduced motion, auto-accelerate, and simplified difficulty are visible immediately; the complete suite remains in Settings.
3. **Live brightness and audio check** — show the production hero car against road/terrain/hazard values and play a real engine plus warning cue with visual equivalents.

`Drive now` remains the default action. A player can inspect or change any shown value without traversing pages.

Do not require account, privacy nag, cinematic, lore crawl, or long legal page before play. Privacy/support remain reachable from the Title and Settings.

### Garage-lot tutorial

Teach through a playable 60-90 second space:

- Accelerate through a visible gate.
- Steer around one broad obstacle.
- Brake and reverse out of a marked bay.
- Use handbrake through an optional wide turn.
- Ram one harmless breakable prop.
- Follow a clearly framed exit road toward the first safehouse.

Prompts appear beside the relevant world action, use the active device glyph, disappear after demonstrated input, and can be recalled from Pause. The tutorial never freezes the car mid-action unless the player explicitly opens help.

### First expedition

- Starts in daylight with forgiving Fuel/Integrity and no lethal spawn.
- Shows one objective, one return point, and one optional salvage cue.
- Provides a visible fork within the first minute.
- Introduces only Fuel, Integrity, objective direction, and unsecured haul; deeper systems arrive when used.
- Guarantees a first choice-bearing part reward on successful return.

### Representative hero-minute cadence

- **0-10 seconds:** production car visible; one accelerate prompt; player moves.
- **10-22 seconds:** broad steer and brake/reverse gates teach through movement.
- **22-30 seconds:** Fuel and Integrity are legible by second 25; one real surface seam and harmless breakable introduce tactile consequence.
- **30-60 seconds:** landmark-framed road/dirt/mud fork plus one optional signal; distinct world and route-ledger facts preserve return direction.
- **First return:** one Receipt states secured/lost/changed/save truth; the chosen starter part immediately updates the visible car, exact comparison, route forecast, audio, and test-lot behavior.

The cadence is a representative-content contract, not permission to script over player control or to count generated tones/fallback art as hero evidence.

### Onboarding measures

- Four of five new players begin moving within ten seconds.
- Four of five identify the immediate goal and Fuel/Integrity within 30 seconds.
- At least 90% start and drive without moderator help within two minutes.
- At least 80% can explain depart -> risk -> return -> upgrade after one expedition.
- A failure is attributed to an understood choice or skill gap, not hidden rules or unreadable spawn.

## HUD

### Required information

- **Fuel** — gauge, numeric detail on demand, warning states with icon/shape/sound/haptic.
- **Vehicle Integrity** — remaining condition, recent hit direction/weight, critical state.
- **Navigation** — objective direction/distance, next meaningful turn or landmark, return marker.
- **Objective** — one-line current action; details in map/pause.
- **Cargo and unsecured haul** — capacity, fragile/secured state, what is currently at risk.
- **Threat state** — calm/rising/danger using motion, icon, audio, and value—not an unexplained debug tier.
- **Context** — short interaction/recovery prompt only when actionable.

Calm Drive shows at most four persistent glance facts: Fuel, Integrity, next meaningful navigation landmark/action, and exposed haul. Pressure appears when it changes, affects the current decision, or is inspected. At most one warning expands, two transient items coexist, and one Context card appears. Lower-priority items fold before cause, risk, security, destructive consequence, or the primary action.

### Excluded from production HUD

- Terrain enum names, entity counts, chunk metrics, seed, frame data, internal pressure tier, raw node state, or duplicated resource text.
- Persistent minimap clutter when the direction cue and world landmarks are sufficient.
- Multiple currencies, feed notifications, rotating offers, daily streaks, or promotional banners.

### Visual hierarchy

1. Immediate critical warning.
2. Road/hazard and objective view.
3. Fuel/Integrity trend.
4. Navigation and cargo.
5. Optional score/detail.

Warnings use three stages: forecast, urgent, critical. They are rate-limited, explain cause, and do not obscure the driving line.

## World map and navigation

- Zoomable/pannable map using the same road-atlas visual language as the world.
- Shows discovered primary/secondary/service roads, landmarks, safehouses, region/weather conditions, active objective, player position/heading, and one player pin.
- Undiscovered space is softly incomplete, not covered by an opaque gamey fog wall.
- Filters: objectives, safehouses, discoveries, mastery; never dozens of commodity icons.
- Route preview compares distance, known surface mix, closures, and build-relevant risks without drawing a single mandatory GPS line.
- AtlasCanvas and RouteLedger are equivalent views of the same route facts; every spatial fact has a list/card path.
- Route alternatives explicitly distinguish known, estimated, and unknown conditions. No universal score or “best route/build” label solves the choice.
- Controller focus and touch gestures are first-class; map remains operable at 200% text.
- If retained by D020, fast travel is offered only between eligible restored safehouses from a planning state after the current expedition is closed. It is unavailable with any active manifest, escrow, or pending mutation and clearly explains why.

## Garage, parts, and loadouts

The Garage is vehicle-first. The car remains visible and responds immediately to part selection.

### Layout

- Chassis/loadout header with current role summary.
- The D020-locked functional-slot set around or beside the vehicle; current target six, coherent fallback five.
- Category/filterable owned/catalog panel.
- Exact compare panel with benefits, drawbacks, compatibility, synergy, source, and value.
- Route forecast for the selected objective.
- Test-lot action, undo, save preset, fabricate a known blueprint, and leave Garage.

### Comparison standard

Every part choice shows:

- Current vs candidate values.
- Capability gained.
- Tradeoff introduced.
- Mass/power/cargo/noise consequences.
- Any route, weather, collision, or cargo behavior affected.
- Affordability, owned/blueprint/duplicate-conversion state, and what happens on confirm.

Green/red color is supplemental; arrows, labels, position, and shape carry the meaning. Hidden math never decides a purchase.

Compare cards separate **Gains**, **Costs**, and **Route consequences**. At most three actions are visible and exactly one is primary. Disabled/incompatible actions retain an exact reason instead of disappearing.

### Ownership/catalog states

- **Empty:** explain where the selected slot's parts are found and offer relevant objective/map path.
- **Incompatible:** state the exact chassis/slot/capacity reason.
- **Duplicate find:** preview the fixed Scrap conversion; no second physical copy or overflow queue is created.
- **Missing/deprecated preset item:** preserve the reference, identify the migration issue, offer an explicit equivalent/refund/swap, never silently substitute.
- **Owned blueprint:** clearly distinguish named-part ownership, blueprint knowledge, and whether one-time fabrication remains available.

### Purchase/fabrication feedback

- Immediate vehicle animation and real mechanical/audio cue.
- Stat and route forecast update within 100 ms.
- Scrap change is localized near the action, then settles into the account total.
- Confirm only for destructive/irreversible actions; routine part swapping is instant and undoable.

## Plan contract cards and Settle

### Plan contract cards

Each objective card shows destination, activity family, estimated session length, known surface/weather, required cargo capacity/capability, failure condition, guaranteed reward, and optional bonus. Risk is descriptive and inspectable, not a vague color rarity.

### Settle receipt

Present in this order:

1. Outcome and why the expedition ended.
2. Secured versus lost items/Scrap.
3. Objective, restoration, and discovery progress.
4. New record, part, blueprint, shortcut, or safehouse.
5. One clear next action: Garage, continue, retry, or choose another objective.

Do not bury failure causes, reward consequences, or save state in a scrolling log.

Settle remains visibly connected to the extraction/failure scene, but its Receipt is authoritative. In order it states cause, secured, lost, committed county change, retained observation, save result, and one next action. Animation never delays control or conceals these facts.

## Pause, settings, and save management

### Pause

- Immediate offline pause with Resume first.
- Map/objective, controls, audio/display/gameplay/accessibility settings.
- Abandon expedition requires confirmation and states the exact failure settlement; it never rolls back to a safe boundary.
- Quit to title requests a durability-gated active manifest/progress checkpoint; transition/confirmation follows acknowledgement, interruption falls back to authoritative verified-slot selection, and quitting is not abandon.

### Settings groups

- **Controls:** rebind, sensitivity, dead zone, assists, touch layout, left-handed layout, controller glyph.
- **Display:** window/fullscreen desktop, resolution/scale, brightness, frame cap, quality, safe-area preview.
- **Audio:** Master, Music, Vehicle, World, UI; mute behavior; dynamic range.
- **Gameplay:** difficulty assists, auto-accelerate, units, prompt frequency, pause behavior.
- **Accessibility:** text scale, contrast, color-independent cues, motion/flash/particle/haptic intensity, visual audio cues.
- **Language:** all supported languages and restart requirement if any.
- **Privacy/support:** exact collection state, policy, support, logs export if implemented.

### Save management

- Last successful save time and schema/build shown in diagnostics, not normal HUD.
- New profile/reset requires explicit hold/typed confirmation and lists what is removed.
- Eligible lower-slot recovery identifies the affected independent PROFILE or SETTINGS journal, explains that fallback requires an incomplete, unparsable, or checksum-invalid higher-sequence slot, and quarantines that evidence for diagnostics.
- Debug profiles and migration tools are compile-time development surfaces, absent from release.

## Loading, empty, error, and offline states

### Loading

- Cold load shows branded art plus a truthful progress/activity label.
- World streaming during play is invisible; no player-facing loading spinner while driving.
- Operations longer than 250 ms show progress or immediate acknowledgement.
- A loading failure provides Retry, safe return, and diagnostics path without destroying the save.

### Offline

Core game, saves, and progression work offline. If retained by D020, seeded Expedition Mode works offline too. If optional Game Center/cloud features are later enabled, offline copy states what is unavailable and queues only safe, conflict-aware operations.

### Errors

- Plain-language title, what happened, what was preserved, and the safest next action.
- Error codes live behind Details/diagnostics.
- Save errors never fail silently.
- Controller disconnect pauses or safely coasts according to setting and shows reconnect/alternate-input prompt.
- Background/interruption pauses, commits only safe state, and resumes through an explicit lifecycle flow.

## Responsive layouts

Design components, not separate desktop and mobile screens.

### Reference classes

- Desktop 16:9 and 16:10, 1280 x 720 logical minimum.
- Small landscape phone, 896 x 414 logical proof floor.
- Wide/notched landscape phone with safe-area insets.
- Landscape tablet at 4:3-ish and modern wide ratios.

### Rules

- Anchors/containers and content priorities determine reflow; no hardcoded pixel positions in production surfaces.
- Touch target minimum: 48 x 48 logical points with at least 12 points between conflicting targets.
- Primary touch-driving controls begin at `[PLACEHOLDER: 64 x 64]` and are locked only by physical-device reach, occlusion, and mis-input proof.
- Interactive content stays outside platform safe area plus a 16-point design inset.
- Player HUD never covers the projected immediate driving line.
- Text wraps/reflows at 200% for common tasks; no horizontal-scroll dependency for essential copy.
- Desktop hides touch controls unless touch mode is active. Mobile does not show keyboard glyphs.
- Focus order, back/cancel behavior, and default focus are explicit per screen.
- UI reaction to input is under 100 ms; driving input is sampled by the fixed-step adapter without UI latency.

### Touch layout

- Left zone: analog steering wheel/slider or broad left/right steering region.
- Right zone: gas, brake/reverse, and handbrake with simultaneous contacts.
- Adjustable scale, opacity, horizontal/vertical placement, sensitivity, and left-handed swap.
- Buttons remain visible enough to learn but fade when configured; warnings never occupy the same fingers' space.
- Multi-touch tests cover steering + gas + handbrake, steering + brake, slide off/on, system gesture, notification interruption, app background, and controller handoff.
- Optional auto-accelerate is an accessibility/convenience option, not the default until validated.

## Accessibility baseline

### Vision and readability

- Normal text contrast target at least 4.5:1; large text and essential non-text target at least 3:1.
- No state communicated by color alone.
- No gameplay-critical state depends on audio, haptic, motion, fine detail, or spatial-map position alone.
- Text scale supports 100-200% across all common tasks without unusable clipping or overlap.
- High-contrast route/hazard mode; separate brightness and effects intensity.
- Icon plus text labels for unfamiliar symbols; consistent icon grammar.
- Pseudolocalization with at least 40% expansion and zero blocking truncation.
- Atlas routes, spatial warnings, and direction cues have RouteLedger/fact-list equivalents.

### Motion and sensory intensity

- Independent camera shake, screen flash, particle density, weather intensity, motion blur if ever added, and haptic intensity.
- Reduced Motion disables shake and nonessential parallax/large transitions while preserving state feedback.
- Flash frequency and brightness are bounded; no repeated high-contrast flash dependency.

### Hearing

- Every gameplay-critical warning has a visual cue.
- Subtitles/captions for any spoken radio or semantic ambient event.
- Separate mix buses and mono-compatible critical cues.
- Directional cue indicators may be enabled without exposing every ambient sound.

### Motor and controls

- Complete keyboard/controller remapping and adjustable analog response/dead zones.
- Steering/brake assists, auto-accelerate, hold/toggle alternatives, and longer timing windows.
- Touch controls adjustable for size, position, opacity, handedness, and sensitivity.
- Every common menu flow works by touch, keyboard, and controller with visible focus.

### Cognitive and difficulty

- Concise objective language, prompt recall, consistent terminology, and map legend.
- Descriptive difficulty presets plus Custom expose the same independent assists; exact names/count require user testing, and changes never discard campaign progress or the ending.
- Fuel drain, damage, threat density, objective/reaction timing, and a disclosed action-Pressure-gain reduction are independent. No assist increases Pressure or changes rewards/the ending.
- Tutorial replay and safe test lot.
- No important information disappears permanently after a timed toast.

### Platform accessibility claims

Do not claim VoiceOver, Voice Control, Larger Text, Reduced Motion, captions, or another App Store Accessibility Nutrition Label until the shipped build completes every common task under Apple's current criterion. Screen-reader/native accessibility feasibility is investigated during the UI shell and iOS phases; an incomplete bridge is not marketed as support.

## Visual direction

### Style: Sun-Bleached Survival Road Atlas

Evolve Stylized Survival Readability into an illustrated, inked top-down world:

- Roads and land read like a printed atlas brought to life.
- Vehicles and props use bold ink silhouettes, clear heading, limited texture, and expressive damage/motion layers.
- Terrain uses broad authored shapes, subtle paper/grain texture, region decals, shadows, vegetation/wreck clusters, and landmark silhouettes.
- Weather, headlights, route paint, dust, and debris animate the map without obscuring it.
- Interface panels resemble rugged navigation cards and dashboard instruments, not literal skeuomorphic gauges everywhere.

Composition begins with three value bands—ink/deep road, terrain/paper midtones, and bone/highlights—then adds stable semantic accents. Field Manual cards may use clipped corners, ink rules, registration marks, stamps, route hatching, and sparse paper grain, but copy surfaces remain flat and high-contrast. Name-bearing type, logo, icon, launch, and marketing assets remain blocked until D021 passes.

### Shape language

- Player vehicle: forward-pointing wedge, warm high-value accent, stable dark outline.
- Friendly/safe: open circles, shelter arcs, teal/cyan light.
- Objective/navigation: diamonds/route chevrons with a hollow center.
- Threat: broken angular shapes, crimson, irregular motion.
- Fuel/repair/cargo: distinct silhouette and motion; never recolored copies.
- Primary road: broad continuous line; secondary/service routes become progressively narrower/rougher.

### Working palette

| Role | Working color | Use |
|---|---|---|
| Ink | `#171818` | Outlines, deepest UI/background |
| Asphalt | `#292A29` | Primary road |
| Dust paper | `#D6B978` | Lowlands/base warmth |
| Hero yellow | `#F0C547` | Player vehicle and selected action |
| Oxidized teal | `#2F7775` | Safehouse, repair, calm navigation |
| Route cyan | `#63B7C5` | Map route and water highlight |
| Warning vermilion | `#D6533F` | Threat/critical warning |
| Bone | `#F1E8CF` | Primary light text |

Final tokens require contrast and color-vision testing on representative devices. Region palettes shift hue/value but preserve role consistency.

### Region presentation

These palettes describe the current provisional three-region target. D020 locks the final region set; a compact finale must remain mechanically and visually distinct if it replaces a full third region.

- Lowlands: ochre/green fields, flooded cyan cuts, wide horizon cues, weathered farm geometry.
- Badlands: pale stone, rust, charcoal quarry cuts, dust trails, long angular shadows.
- Blackwood: blue-green canopy masses, wet dark road, amber vehicle lights, high-value hazard edging.

### Lighting, time, and weather presentation

- The current provisional target uses authored illustrated dawn, day, dusk, and night states rather than photoreal dynamic lighting; D020 may reduce that multiplicity to the smallest readable route-condition set. Every retained transition interpolates palette, shadow direction/length, emissive accents, ambience, and sky/ground value without changing semantic colors.
- Day keeps road hierarchy and terrain texture readable at full speed. If dusk/night remain, they lower environmental value while preserving road edges, objective silhouettes, hazards, and the hero car; headlights clarify near-field shape but are never the only way to identify a required route or threat.
- Baked contact/landmark shadows communicate grounding and time, never a collision boundary. Optional soft lights, long shadows, reflective wet-road accents, and extra weather layers degrade before silhouettes, route contrast, or warning readability on lower quality tiers.
- Retained rain, fog, dust, wind, and storm fronts use bounded overlays, particles, surface treatment, audio, and motion cues. Reduced Motion/weather-intensity/particle settings reduce movement and density while preserving the route-condition fact through value, icon, text, and audio alternatives.
- Every D020-retained time/weather state and representative transition receives phone-scale screenshot, contrast, color-independent, Reduced Motion, route/hazard-recognition, and performance captures before a region presentation family multiplies.

### Vehicle style

- Every D020-locked chassis shares a coherent inked construction but has an instantly different silhouette, wheelbase, mass, cargo shape, and animation; the current target is three and the coherent fallback two.
- Installed ram, armor, cargo, lights, and major utility parts appear on the car when readability permits.
- Damage presentation is staged: clean, worn, critical; no gore or visual noise that hides collision shape.
- Cosmetics preserve heading and hit readability.

### Terrain and world assets

- Use authored tiles/decals/splines and landmark scenes rather than runtime flat-color atlas generation.
- Atlas textures, material variants, baked collision/navigation metadata, and region LOD rules are cataloged.
- World props use small coherent kits with composition rules; random scatter alone is not world dressing.
- Road edges, crossings, barriers, and shortcuts receive unique readable treatment.
- Universal asset records include stable ID/package, best-available source/runtime artifact, creator/source, ownership/license/allowed use/attribution/review, import preset/version, memory/package class, and production status. Spatial visuals, UI/fonts/icons, audio, and VFX/animation/haptics add only their relevant scale/pivot/collision, palette/atlas, localization/alternatives, format/rate/loop/bus/concurrency, quality/LOD, accessibility, and pool/cadence fields. Hero assets track proof/hours/rework individually; routine variants do so by batch/tranche, with defect IDs only when defects exist.
- The deterministic pipeline is best-available source + provenance -> style/readability review -> export -> Godot import preset -> catalog/license/budget validation -> gallery/representative scene -> desktop/mobile-profile proof -> content package.
- Commit Godot import metadata, not the generated `.godot/` cache. The initial runtime atlas-page hypothesis is `[PLACEHOLDER: 2048 x 2048]`; larger pages require a recorded quality/memory comparison.
- **Phase-2 Drive hero:** vehicle rig, lot/fork, route/surface treatments, landmark, obstacles, threat/hazard, objective/safehouse and Fuel/repair/cargo/reward silhouettes, Drive HUD subset, plus real engine/surface/impact/warning/pickup/minimal-UI audio. It gates multiplication of vehicle/world/Drive-feedback families.
- **Phase-3 integrated loop:** representative Service compare/part-install, extraction/safehouse mutation, Settle Receipt and exact secured/lost state, part-install/extraction/Settle cues, region ambience, and minimum sparse music transition across a 15-minute loop. It gates those families.
- **Phase-8/10 complete shell and mix:** remaining component states, SystemSheet/settings/error/recovery, full semantic event map/mix, 30-minute desktop visual/audio fatigue/masking, and separate physical-device haptic proof. It gates the remaining UI/audio/haptic families.

Each family may multiply only after its corresponding tranche passes recognition, throughput, provenance, import, memory/package, mix, and performance evidence. Phase 2 measures presentation cost—texture residency/pages, audio buffers/voices, materials/draws, nodes, VFX emitters/particles, package bytes, frame/audio time, and haptic cadence. Phase 3 records explicit family caps/headroom in D020's `SCOPE_LOCK.md` before broad production while preserving the separate 30% reserve and whole-process budgets.

### Typography and iconography

- Bundle a properly licensed high-legibility sans for body/UI and a restrained condensed display face for headings/numbers.
- Body font remains legible at phone scale; condensed face is never used for paragraphs.
- Tabular numerals for Fuel, Integrity, and route distance.
- Icons use consistent stroke/fill, grid, optical size, active/disabled/critical states, and text alternative.
- All fonts/icons are tested at 1x/2x, high text scale, and screenshot capture sizes.

### Screenshot readability

At App Store screenshot scale, a frame should show the player car, road choice, region identity, one objective/reward/threat, and clean HUD without debug text. Marketing captures must be honest gameplay from the release build.

## Animation, VFX, and feedback

### Animation standards

- Input response begins in the next simulation frame.
- UI press/selection acknowledgement: under 100 ms.
- Small transitions: `[PLACEHOLDER: 120-180 ms]`; major non-blocking reveal: `[PLACEHOLDER: 250-400 ms]`. These are tuning hypotheses, not permission to delay repeated actions.
- Every transition is cancellable or safely resolves to its final state; repeated Plan, Service, or Settle actions cannot queue presentation debt.
- Reward animation never delays control or requires dismissal unless it presents a meaningful choice.
- Vehicle animation derives from physical state: body roll, pitch, wheel steer, suspension, slip, damage, cargo weight.

### VFX layers

- Surface: dust, spray, mud, skid, loose gravel.
- Collision: sparks, debris, deformation cue, hit flash at source, restrained camera impulse.
- Resource: pickup trail and settle, Fuel/repair/cargo-specific effect.
- Navigation: world marker, route pulse, newly discovered landmark reveal.
- Weather: region-aware rain/dust/fog with intensity and performance levels.
- Critical: Fuel/Integrity warning at the car/HUD without obscuring road.

Effects are pooled, capped, distance/importance prioritized, and measured in full-stack performance proof. Reduced-effects mode preserves essential silhouettes/cues.

### Semantic feedback events

Gameplay emits one semantic fact. `FeedbackDirector` maps it to visual, audio, camera, and optional haptic outputs according to priority, capability, settings, visibility, cooldown, and performance tier. Required event fields are event/source ID, forecast/commit/consequence/resolve phase, critical/decision/status/flavor priority, magnitude, optional direction, cause localization key, cooldown group, and dedupe key.

Initial families are input acknowledgement, surface transition, drift threshold, light/medium/heavy impact, Fuel/Integrity escalation, Pressure change with disclosed cause, exposed/secured/lost haul, objective/restoration resolution, part installation, and save/recovery state. Continuous simulation values drive continuous vehicle/audio state; they do not spam discrete events. Critical cues reserve capacity and may briefly duck masking buses. No output layer invents separate gameplay truth.

## Audio direction

Replace the empty generator placeholders with licensed/owned real assets and explicit state-driven playback.

### Mix buses

- Master
- Music
- Vehicle
- World
- UI

Each has independent level; critical warning routing remains understandable at low music/world levels. Mix supports a reduced dynamic-range mode and mono compatibility.

Short frequent effects default to WAV with measured import compression; longer music/ambience default to Ogg Vorbis or another profiled format. Source masters remain lossless. Mono, sample rate, loop, trim, and compression decisions are recorded per asset.

### Vehicle audio

- At least three loop layers or an equivalent continuous model for idle/load/high RPM.
- Pitch and blend follow engine load/speed, not speed alone.
- Surface loops for asphalt, dirt, grass/rough, mud/water.
- Skid, brake, reverse, damage rattle, and critical sputter states.
- Chassis/parts may alter weight, exhaust, and ram tone without requiring a separate recording set for every loadout.

### World and impact audio

- Light/medium/heavy collision families with material variation and rate limiting.
- Zombie ram/contact cues distinct from environmental impact.
- Weather, region ambience, safehouse, landmark, and event signatures.
- Pickup/reward sounds distinguish Fuel, repair, Scrap, part, blueprint, discovery, and restoration.
- Offscreen semantic threats have optional visual direction cues.

### Music

- Sparse adaptive score that supports lonely travel, rising pressure, critical return, safehouse, and Settle.
- Stem/intensity transitions respond to expedition state and avoid restarting on minor events.
- Music does not carry gameplay-critical information.

### Audio proof

- The initial minimum-device profiling floor is 24 simultaneous voices with four reserved for critical vehicle/warning/UI events, one player engine/surface set, three same-family impact voices before stealing, and two routine UI voices. Product and Evidence Owners freeze the measured cap before the first formal Phase-10 result and before audio families multiply.
- Tests verify real streams are assigned, buses/routes exist, state transitions trigger, voice stealing/rate limits hold, and pause/resume never duplicates loops.
- A rendered capture and human audible check verify engine continuity, surface change, impacts, warning, pickup, Settle, and Service feedback. One complete 15-minute mix passes before integrated-audio families multiply. A separate 30-minute desktop visual/audio fatigue/masking session samples 0-5 every five minutes, stops at participant request or >=4 discomfort, and requires median <=2 with no unresolved score >=3 before the complete shell/mix graduates.
- Headless counters are diagnostic only and cannot satisfy audible acceptance.

## Haptics

- Continuous road texture is disabled by default and cannot graduate without physical-device comfort, control-precision, battery, and 30-minute fatigue proof.
- Distinct, rate-limited patterns for drift threshold, light/heavy impact, pickup, critical warning, and successful extraction.
- Haptics never substitute for visual/audio meaning and can be scaled or disabled.
- Physical-device proof checks simultaneous touch, audio, and haptic behavior.

## Experience definition of done

- All common flows exist, use production components, and pass touch/keyboard/controller navigation.
- First-launch and first-minute comprehension targets pass with new players.
- No player-facing debug or placeholder content remains.
- Responsive aspect/safe-area matrix, 200% text, pseudolocalization, contrast, color-independent, focus, motion, audio-cue, and touch targets pass.
- Representative art/audio/VFX/haptics meet the hero-minute target before broad content production; the current fallback-font, drawn-geometry, generated-tone slice cannot satisfy this gate.
- At least 80% explain route risk, part capability/tradeoff, and secured/exposed/lost/committed state correctly.
- Phone-scale silhouette recognition, multimodal cue-cause recognition, a 15-minute full-state mix, 30-minute fatigue/masking session, asset throughput/provenance, and representative frame/memory/package proof pass.
- Recognition uses a ten-person randomized per-category test at 896 x 414 logical scale with blank/near-neighbor controls: at least eight of ten per critical category and <=10% false positives.
- Full production content maintains visual/audio identity and performance budgets.
- Every claimed App Store accessibility feature passes its current end-to-end evaluation criterion.
