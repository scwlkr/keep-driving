# Keep Driving Current-State Audit

Status: completed baseline audit
Audit date: 2026-07-11
Repository baseline: `8b772aa` plus the documentation work in progress
Product stage: playable v0 / pre-alpha, not a production alpha

## Executive finding

Keep Driving already has a coherent end-to-end survival-driving loop and unusually useful proof seams for a prototype. It is possible to launch, begin a deterministic run, drive freely, cross streamed chunk boundaries, collect resources, take damage, reach Results, spend Scrap in the Garage, persist three upgrades, and restart with a fresh seed. Fresh Godot-native checks pass.

That is a strong prototype nucleus, not a near-release game. The repository has one six-line shipping scene, nine shipping runtime scripts, no production assets, no real shipping audio, no verified controller support, an unversioned single-file save, no production export/CI configuration, no iOS project, no activities or destinations, one enemy behavior, one vehicle, and nine monotonic upgrade purchases. A separate Phase-2 handling scene and prototype-only ad-hoc macOS export now exist without changing the shipping scene. The visible shipping build still uses default Godot controls, block-color tiles, debug telemetry, and procedural placeholder drawings.

The shortest responsible route to 1.0 is not to stack content onto this runtime. Preserve the verified contracts, prove the target vehicle/world/first-minute experience in a desktop truth slice, then migrate the prototype behind modular, data-driven systems before producing the full world and content set.

## Repository assessment

| Area | Current evidence | Audit call |
|---|---|---|
| Engine | Godot `4.7.stable.official.5b4e0cb0f`; GDScript; GL Compatibility renderer in `project.godot` | Retain, subject to export/device validation |
| Entry point | `scenes/main.tscn` contains only `GameRoot`; runtime graph is constructed in code | Refactor into reusable scenes and services |
| Runtime | Nine scripts; `scripts/game_root.gd` is 621 lines and owns flow, UI, input, contacts, camera, save calls, audio, and feedback | Split before broad production work |
| World | Pure deterministic `RunSeed + ChunkCoord` generation and bounded 25-active/49-preloaded streaming | Retain contracts; replace generation/content grammar |
| Vehicle | Manual `Node2D` kinematics with tunable terrain grip/speed, reverse steering, drift, and camera response | Retain feel vocabulary; replace collision/motion substrate |
| Progression | `RunProgression` owns run state, payout, affordability, and three upgrade rules | Retain boundary; replace hardcoded data model |
| Persistence | One unversioned JSON profile written directly to `user://keep_driving_profile_v0.json` | Replace implementation |
| Interface | Programmatic default-theme HUD, menus, Garage, and five touch buttons | Replace presentation; retain Garage information standard |
| Art/audio | Procedural draw calls and flat generated tiles; no committed image, font, shader, or audio asset | Replace for production |
| Tests | One core script plus smoke, mobile simulation, and streaming perf scripts | Retain fast floor; add real integration, rendered, device, and human evidence |
| Build/release | Prototype-only macOS preset, neutral internal bundle ID, ad-hoc signing, and clean local export exist for the handling evidence build; no production desktop preset/version/icon/CI/release signing or iOS project exists | Keep prototype lane isolated; build production pipeline from scratch |

## Current runtime flow

```text
GameRoot._ready
  -> ProfileStore.load_profile
  -> RunProgression
  -> construct WorldRuntime, PlayerVehicle, Camera2D, UI, audio placeholders

GameRoot._process
  -> read keyboard/touch state
  -> sample terrain
  -> move PlayerVehicle
  -> stream chunks and update entities
  -> scan contacts
  -> advance RunProgression
  -> update camera, feedback, and HUD

Run end / Garage purchase
  -> RunProgression updates Driver Profile
  -> ProfileStore overwrites profile JSON
```

The flow is readable at prototype scale, but authority leaks across it. `GameRoot` mirrors progression state into eight mutable fields and tests often reach public dictionaries or call private methods. Production work needs explicit event and adapter boundaries.

## Fresh proof evidence

Commands were run against the audited working tree:

| Proof | Result |
|---|---|
| `/opt/homebrew/bin/godot --headless --path . --script res://tests/run_all.gd` | `ALL_KEEP_DRIVING_PROOFS_PASSED` |
| `proofs/manual_smoke_proof.gd` | Scripted 600-second simulation reports all declared cases `true` |
| `proofs/landscape_mobile_proof.gd` | 896 x 414 simulated layout/input loop reports `pass=true` |
| `proofs/world_perf_proof.gd` | 10,800 frames; 140.6 FPS; 8.734 ms p95 frame; 1.349 ms p95 stream; 25 active; 49 preloaded; 310 entities; 0 blank-risk frames |
| Visible desktop inspection | Build launches and runs; presentation remains visibly prototype-grade |

Baseline host facts: MacBookPro18,2; Apple M1 Max (10-core CPU, 32-core GPU); 64 GB RAM; macOS 27.0 build 26A5378j; Godot `4.7.stable.official.5b4e0cb0f`; GL Compatibility project configuration. These scripts ran headless from the working tree. The old proof output did **not** retain exact commit, build flavor, power state, viewport, VSync, warm-up, raw frame series, peak memory, or artifact path, so its performance numbers are an audit baseline rather than a reproducible release comparison. The production harness must emit every field in `TECHNICAL_ARCHITECTURE.md` and the roadmap measurement contract.

### What these proofs establish

- Current scripts parse and the current loop remains integrated.
- Chunk hashes, basic route-edge matching, resource rules, Garage rules, and seed restart rules have automated coverage.
- The current cheap world representation stays inside its declared desktop streaming budgets.
- The simulated landscape layout keeps five touch buttons inside an 896 x 414 viewport.

### What these proofs do not establish

- `manual_smoke_proof.gd` performs 36,000 direct `_process()` calls; it is not a ten-minute human play session.
- `world_perf_proof.gd` benchmarks `WorldRuntime`, not a full release build with production art, physics, UI, AI, VFX, and audible audio.
- The mobile proof injects touch state; it does not test real multitouch, safe areas, interruption, thermal load, battery, memory, signing, or device installation.
- Audio checks count requested cues. `GameRoot` creates empty `AudioStreamGenerator` objects but never pushes playback frames, so the build is effectively silent.
- Green scripts do not prove first-time comprehension, visual recognition, fun, progression pacing, content variety, or App Store readiness.

## Existing gameplay systems

### Core loop and flow

`scripts/game_root.gd` implements Start -> Run -> Results -> Garage -> Restart. A run ends only through Fuel depletion or the legacy-labeled `Vehicle Damage` resource. Its `vehicle_damage_remaining` value already behaves as remaining **Vehicle Integrity** (maximum healthy -> 0 destroyed): damage subtracts and Repair adds. Production work should rename the player/domain vocabulary without inverting values; the v0 profile does not persist run health. Scrap pickups and a straight-line distance bonus are banked automatically at death.

Strengths:

- The loop is actually playable end to end.
- Fuel and damage create immediate survival pressure.
- Fresh seeds plus persistent upgrades make restart understandable.
- Garage rows expose level, price, effect, affordability, and max state.

Gaps and defects:

- There is no destination, objective, success state, extraction choice, voluntary return, campaign, or completion state.
- Death banks all Scrap, so carrying rewards has no extraction risk.
- `Miles Driven` is maximum radial distance from the origin, not odometer distance or route achievement.
- `best_miles` and `runs` are saved but never presented.
- The first minute has no controls lesson, goal marker, landmark, guaranteed reward, or designed route-choice beat.

### Vehicle handling and contacts

`scripts/player_vehicle.gd` supplies a useful Arcade-Real tuning sketch: gas, brake/reverse, momentum, steering inversion in reverse, terrain multipliers, handbrake drift, speed look-ahead, zoom, shove, rotation, and shake.

Production blockers:

- Motion directly changes a `Node2D.global_position` in variable-delta `_process`.
- There are no collision bodies, swept queries, contact normals, or fixed-step handling tests.
- Contacts scan every active entity by radius; high-speed tunneling is untested.
- Obstacles can apply their full damage on every overlapping frame.
- There is no rolling resistance, and minimum steering can rotate the car while nearly stationary.
- Entering slower terrain clamps speed immediately instead of applying believable drag.
- Water and barriers are slow damaging tiles, not physical traversal features.
- Input is digital WASD/Space. There is no controller mapping, analog intent, rebinding, or platform-aware prompt set.
- Touch is default `Button` state, not proven simultaneous multitouch.

### Free-roaming world

`scripts/world_generator.gd` and `scripts/world_runtime.gd` provide the strongest technical seam:

- Pure deterministic chunk data.
- Stable chunk hashes and marker IDs.
- Matched route exits at adjacent borders.
- Bounded scene attachment and data preload.
- Run mutation IDs survive unload/reload during one process.
- One chunk attachment per frame and explicit streaming metrics.

The content grammar is scaffolding:

- Every chunk is a four-spoke center hub connected to all edges plus a diagonal rough trace.
- `_base_terrain()` has a no-op detail branch: both paths return grass.
- There is no authored macro road graph, road hierarchy, meaningful loops/dead ends, landmarks, destinations, regions, biomes, towns, shortcuts, or discoverable locations.
- Water is a sine field; crossings are carved shallow strips without bridge identity.
- Roadblocks are independent markers rather than authored or systemic clusters.
- Zombies directly home toward the car and ignore terrain and barriers.
- Pressure mostly raises count-at-generation and zombie speed; there is no encounter director.
- Marker tile selection can overlap.
- There is no world map, navigation, fast travel, time of day, weather, traffic, ambience, or dynamic route event.
- Generation is synchronous; AI and contact scans are O(N); there is no actual object pool or spatial index.
- `EFFECT_CAP` is declared but not enforced. The perf log's pool count is current entity count, not a pool.

### Vehicle and upgrade ecosystem

There is one vehicle and three permanent upgrade tracks: Fuel Tank, Armor, and Engine. Each has three levels. All nine purchases are monotonic power gains.

Missing for 1.0:

- Chassis acquisition and distinct vehicle roles.
- Parts, slots, mass/power/capacity budgets, tuning, sidegrades, drawbacks, synergies, cosmetics, inventory, presets, comparison, discovery, and respec.
- Data-driven catalog, validation, balance simulations, and future-content versioning.
- Any economy sink or build choice after nine purchases.

### Activities and content

Current activity set is only drive outward, collect, collide, and survive. There are no contracts, deliveries, recoveries, time trials, rescues, events, puzzles, authored missions, rotating challenges, environmental stories, or post-progression goals.

### Interface, art, audio, and feel

- `scenes/main.tscn` is a six-line root; all surfaces are constructed in `GameRoot`.
- Start, Results, and Garage use default Godot panels/buttons/font.
- The HUD duplicates resource bars plus a debug dashboard containing terrain, speed, tier, and entity counts.
- Touch controls appear during desktop play.
- There is no pause menu, settings, world map, mission board, inventory, loadout screen, onboarding, credits, licenses, privacy surface, save management, localization, focus navigation, or accessibility suite.
- World, car, entities, and effects are flat-color procedural draw calls. There are no reusable production asset or animation pipelines.
- Audio is silent despite passing counter-based proof.
- There is no music, engine layer, surface loop, impact variation, mix bus, subtitle/cue support, haptics, or intensity control.

## Persistence and reliability

`scripts/profile_store.gd` stores Scrap, three levels, best radial distance, and run count. It fills missing keys but has no schema semantics.

Production gaps:

- No schema version or migration fixtures.
- Direct non-atomic overwrite; failed opens are silent.
- No temporary file, rotating backup, checksum, corruption recovery, or write interruption test.
- No active expedition, mutation, settings, accessibility, unlock, inventory, discovery, or content-version state.
- No validation or clamping of malformed values.
- No background/resume handling, cloud readiness, reset/restore UI, or debug save tooling.

## Desktop and mobile support

Desktop support currently means the Godot debug project can run on macOS with WASD/Space. An isolated handling truth slice now has a prototype-only ad-hoc macOS export, but the production game still has no desktop export, controller tests, key rebinding, window/fullscreen settings, release configuration, or distribution artifact.

Mobile support currently means GL Compatibility is selected and an 896 x 414 viewport fits five default buttons. The prototype-only macOS preset does not provide an iOS preset/Xcode output, signing, safe-area handling, orientation lifecycle, device matrix, background/resume path, real haptics, touch interruption recovery, asset compression plan, thermal/battery/memory profile, TestFlight, or App Store configuration.

## Production infrastructure missing

- Clean-clone bootstrap and one-command verification/export.
- CI on every change and stored test artifacts.
- Debug/release feature flags and logging levels.
- Content import validation, catalog checks, and localization extraction.
- Rendered screenshot/visual regression harness.
- Seed fuzzing and long traversal soak.
- Save migration/corruption/interruption fixtures.
- Controller, safe-area, lifecycle, and physical-device tests.
- Crash symbolication, release logs, build provenance, version/build-number automation.
- Licenses/attributions, privacy policy, support site, store metadata, icons/screenshots, signing, TestFlight, and rollback procedure.

## Retain, refactor, replace

### Retain

- Godot 4.7 and GDScript while the early export proof remains healthy.
- Road Warrior Survival Expedition identity and car-only conflict focus.
- Top-down, non-rotating, look-ahead camera principles.
- Arcade-Real Handling vocabulary and terrain-dependent driving.
- Fuel, Vehicle Integrity, and Scrap as the compact economic foundation.
- Pure deterministic `RunSeed + ChunkCoord` generation contract.
- Stable marker IDs, bounded streaming windows, one-attach-per-frame budget, and proof metrics.
- `RunProgression` as the owner of run/profile rules.
- `ProfileStore` as an adapter boundary, not its current implementation.
- Garage cost/effect/tradeoff clarity standard.
- Fast Godot-native deterministic regression floor.

### Refactor deeply

- `GameRoot` into flow/session orchestration, world, vehicle, input, presentation, audio/feedback, and save modules.
- Vehicle into fixed-step arcade simulation with robust collision shapes/queries and shared analog `DriveIntent`.
- Camera into a dedicated component.
- World runtime into streaming, spatial query, entity lifecycle/pooling, and encounter services.
- World generation into a hybrid authored macrograph plus deterministic runtime dressing/events.
- Run/profile dictionaries into typed, versioned domain records and event-driven updates.
- Hardcoded constants into validated Godot Resource catalogs.
- Proof harness into unit, integration, rendered capture, performance, release-export, device, and human playtest evidence.

### Replace

- Four-spoke-per-chunk world grammar.
- Radius-only contact and repeated-overlap damage.
- Flat terrain/procedural placeholder presentation.
- Empty generated-audio implementation and counter-only audible proof.
- Default Godot player-facing UI and debug dashboard.
- Three-track linear upgrade content model.
- Direct unversioned JSON overwrite.
- Scripted smoke simulation as a substitute for human play.

## Major unknowns and required prototypes

| Unknown | Working assumption | Risk | Validation |
|---|---|---|---|
| Production driving substrate | A fixed-step custom arcade controller on `CharacterBody2D` will preserve accessibility while supporting robust collisions | Rebuilding feel late would invalidate content | Desktop handling lab across 30/60/120 Hz and five naive players |
| Memorable free roam | Authored macro roads/landmarks plus deterministic dressing/events will outperform pure infinite generation | Content could feel finite or procedural layers could fight authored intent | One 10-15 minute proof region with two routes, shortcut, three landmarks, crossing, and dynamic event |
| Deep builds | Slot, mass, power, cargo, and threat tradeoffs can support at least five viable archetypes | One dominant stat stack could collapse the system | Twelve-part sandbox, four slots, benchmark matrix, three player-built loadouts |
| First-minute clarity | Diegetic prompts and a visible destination can teach without a modal tutorial | Mobile HUD could overload the screen | Five-player first-60-seconds test with comprehension targets |
| Performance scaling | Current streaming contracts can survive production-like assets and systems | Current benchmark is artificially cheap | Rendered full-stack 30-minute soak with representative art/audio/AI/collisions |
| Save evolution | A versioned atomic envelope can migrate the existing v0 profile | Bad migration could destroy progress | N-2 fixtures, real v0 fixture, 1,000 interrupted writes, corrupt-primary recovery |
| iOS feasibility | Godot GL Compatibility and the chosen architecture can ship on the selected device floor | Exporter, Xcode, signing, or renderer failure could arrive late | Export-only signed feasibility check after the first accepted desktop truth slice; repeat with the frozen full game at Phase 15 before mobile adaptation |

## Risk register

| Risk | Likelihood | Impact | Reduction step | Blocking gate |
|---|---|---|---|---|
| Vehicle feel/collision replacement fails | High | Critical | Handling lab before world/content production | Truth slice |
| Procedural infinity remains forgettable | High | Critical | Hybrid-world proof and authored content pipeline | World foundation |
| Upgrade system has a dominant build | High | High | Sidegrade rules, benchmark scenes, catalog validator | Upgrade foundation |
| Content burden exceeds capacity | High | High | Three-region launch scope, modular landmark/event templates, density budgets | Content alpha |
| Green proofs create false confidence | High | High | Evidence taxonomy and human/rendered/device gates | Every phase |
| Save migration or interruption loses progress | Medium | Critical | Atomic service, backups, fixtures, fault injection | Desktop alpha |
| iOS performance/lifecycle discovered late | Medium | Critical | Architecture constraints from day one; device proof after desktop gates | Mobile entry gate |
| UI cannot scale from desktop to phone | Medium | High | Responsive component system, safe-area matrix, controller/focus tests | UX gate |
| Art/audio pipeline becomes inconsistent | Medium | High | Production target board, budgets, import validation, vertical-slice signoff | Content production |
| App Store compliance changes | Medium | High | Recheck official requirements at TestFlight, RC, and submission | Release gate |
| Working title conflicts with an existing released game/claimed mark | High | Critical | Formal legal/name/competitive clearance and rename fallback; neutral internal/ad-hoc prototype identifiers may continue | Written clearance or cleared replacement before the Phase-2 signed iOS feasibility build, then recheck before Phase-9 public brand lock |

## Audit definition of done

- Repository, code, tracker history, and visible build inspected.
- Core, smoke simulation, mobile simulation, and current streaming performance proofs rerun.
- Current strengths, defects, technical debt, placeholders, and missing infrastructure recorded.
- Retain/refactor/replace decisions recorded.
- Major unknowns converted into explicit prototypes and gates.
- The canonical 1.0 roadmap may use this document as its baseline without assuming the current prototype is production-ready.
