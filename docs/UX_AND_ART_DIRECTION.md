# Keep Driving UX, Art, Audio, and Game-Feel Direction

Status: 1.0 experience specification
Direction date: 2026-07-11

## Experience goal

Keep Driving should feel like an animated survival road atlas wrapped around a responsive arcade car. It is rugged, direct, readable, and tactile—not a debug tool, generic Godot interface, grim unreadable horror game, or busy free-to-play dashboard.

The interface has three jobs:

1. Get the player driving and understanding the immediate risk quickly.
2. Make route, cargo, extraction, and build decisions exact without exposing implementation vocabulary.
3. Preserve clarity across desktop, controller, and landscape touch layouts, including interruption and accessibility needs.

## Interface architecture

```text
Boot
├── First-launch setup
│   ├── Language
│   ├── Accessibility shortcuts
│   ├── Input preset
│   └── Brightness / audio check
├── Title
│   ├── Continue
│   ├── New profile / reset
│   ├── Settings
│   ├── Accessibility
│   ├── Credits / licenses
│   └── Privacy / support
└── Game
    ├── Garage hub
    │   ├── Vehicle and loadouts
    │   ├── Parts inventory / fabrication
    │   ├── Mission board
    │   ├── World map
    │   ├── Records / discoveries
    │   └── Settings / save management
    ├── Expedition HUD
    │   ├── Navigation / objective
    │   ├── Fuel / Vehicle Integrity
    │   ├── Cargo / unsecured haul
    │   ├── Threat / warning state
    │   └── Context prompt
    ├── Pause
    │   ├── Resume
    │   ├── Map / objective
    │   ├── Controls / settings / accessibility
    │   ├── Return to last safe boundary
    │   └── Quit to title
    ├── Safehouse / extraction
    └── Results
        ├── Secured / lost / records
        ├── Objective and discovery progress
        ├── Garage / next contract
        └── Restart / continue
```

Screen routing is an explicit application-flow state machine. A screen never reaches into world dictionaries or writes saves directly. All player-facing strings use localization keys.

## First launch and onboarding

### First-launch setup

Keep the setup to four short, skippable surfaces with safe defaults:

1. **Language** — use system language when supported; always offer English.
2. **Accessibility shortcuts** — larger text, high-contrast cues, reduced motion, auto-accelerate, and simplified difficulty are visible immediately; the complete suite remains in Settings.
3. **Input preset** — keyboard/mouse, controller, or touch detected automatically; explain that it can be changed.
4. **Brightness and audio check** — show the hero car against road/terrain/hazard values and play a real engine plus warning cue with visual equivalents.

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
- Controller focus and touch gestures are first-class; map remains operable at 200% text.
- If retained by D020, fast travel is offered only between eligible restored safehouses and clearly explains why it is unavailable.

## Garage, parts, and loadouts

The Garage is vehicle-first. The car remains visible and responds immediately to part selection.

### Layout

- Chassis/loadout header with current role summary.
- The D020-locked functional-slot set around or beside the vehicle; current target six, coherent fallback five.
- Category/filterable inventory panel.
- Exact compare panel with benefits, drawbacks, compatibility, synergy, source, and value.
- Route forecast for the selected objective.
- Test-lot action, undo, save preset, fabricate/dismantle, and leave Garage.

### Comparison standard

Every part choice shows:

- Current vs candidate values.
- Capability gained.
- Tradeoff introduced.
- Mass/power/cargo/noise consequences.
- Any route, weather, collision, or cargo behavior affected.
- Affordability, inventory/duplicate state, and what happens on confirm.

Green/red color is supplemental; arrows, labels, position, and shape carry the meaning. Hidden math never decides a purchase.

### Inventory states

- **Empty:** explain where the selected slot's parts are found and offer relevant objective/map path.
- **Incompatible:** state the exact chassis/slot/capacity reason.
- **Overflow intake:** no item is lost; compare, store, or dismantle.
- **Missing preset item:** preserve preset, identify missing item, offer repair/swap, never silently substitute.
- **Max/owned blueprint:** clearly distinguish part ownership, blueprint knowledge, and available copies.

### Purchase/fabrication feedback

- Immediate vehicle animation and real mechanical/audio cue.
- Stat and route forecast update within 100 ms.
- Scrap change is localized near the action, then settles into the account total.
- Confirm only for destructive/irreversible actions; routine part swapping is instant and undoable.

## Mission board and Results

### Mission board

Each objective card shows destination, activity family, estimated session length, known surface/weather, required cargo capacity/capability, failure condition, guaranteed reward, and optional bonus. Risk is descriptive and inspectable, not a vague color rarity.

### Results

Present in this order:

1. Outcome and why the expedition ended.
2. Secured versus lost items/Scrap.
3. Objective, restoration, and discovery progress.
4. New record, part, blueprint, shortcut, or safehouse.
5. One clear next action: Garage, continue, retry, or choose another objective.

Do not bury failure causes, reward consequences, or save state in a scrolling log.

## Pause, settings, and save management

### Pause

- Immediate offline pause with Resume first.
- Map/objective, controls, audio/display/gameplay/accessibility settings.
- Return to last safe boundary states exactly what unsecured progress will be lost.
- Quit to title saves only at a valid committed boundary and explains active expedition resume behavior.

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
- Corrupt-primary recovery explains use of backup and preserves diagnostic copy.
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
- Text scale supports 100-200% across all common tasks without unusable clipping or overlap.
- High-contrast route/hazard mode; separate brightness and effects intensity.
- Icon plus text labels for unfamiliar symbols; consistent icon grammar.
- Pseudolocalization with at least 40% expansion and zero blocking truncation.

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
- Fuel drain, damage, threat density, and timing assists are independent.
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
- Asset imports record source, license, scale, pivot, collision, memory class, and mobile compression.

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
- Small transitions: roughly 120-180 ms; major non-blocking reveal: 250-400 ms.
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

## Audio direction

Replace the empty generator placeholders with licensed/owned real assets and explicit state-driven playback.

### Mix buses

- Master
- Music
- Vehicle
- World
- UI

Each has independent level; critical warning routing remains understandable at low music/world levels. Mix supports a reduced dynamic-range mode and mono compatibility.

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

- Sparse adaptive score that supports lonely travel, rising pressure, critical return, safehouse, and Results.
- Stem/intensity transitions respond to expedition state and avoid restarting on minor events.
- Music does not carry gameplay-critical information.

### Audio proof

- Tests verify real streams are assigned, buses/routes exist, state transitions trigger, and concurrency/rate limits hold.
- A rendered capture and human audible check verify engine continuity, surface change, impacts, warning, pickup, Results, and Garage feedback.
- Headless counters are diagnostic only and cannot satisfy audible acceptance.

## Haptics

- Low-frequency subtle road texture only if it remains comfortable and battery-safe.
- Distinct, rate-limited patterns for drift threshold, light/heavy impact, pickup, critical warning, and successful extraction.
- Haptics never substitute for visual/audio meaning and can be scaled or disabled.
- Physical-device proof checks simultaneous touch, audio, and haptic behavior.

## Experience definition of done

- All common flows exist, use production components, and pass touch/keyboard/controller navigation.
- First-launch and first-minute comprehension targets pass with new players.
- No player-facing debug or placeholder content remains.
- Responsive aspect/safe-area matrix, 200% text, pseudolocalization, contrast, color-independent, focus, motion, audio-cue, and touch targets pass.
- Representative art/audio/VFX/haptics meet the hero-minute target before broad content production.
- Full production content maintains visual/audio identity and performance budgets.
- Every claimed App Store accessibility feature passes its current end-to-end evaluation criterion.
