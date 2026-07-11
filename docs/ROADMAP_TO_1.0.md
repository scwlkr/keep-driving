# Keep Driving Roadmap to 1.0.0

Status: canonical execution roadmap
Roadmap date: 2026-07-11
Current phase: Phase 2 — Technical-Risk Prototypes; handling truth slice in progress
Canonical Wayfinder map: `.scratch/keep-driving-1-0/map.md`

## 1. Executive summary

### Current project status

Keep Driving is a playable Godot 4.7 v0/pre-alpha. Its start -> run -> Results -> Garage -> restart loop works; deterministic chunks, bounded streaming, terrain-sensitive arcade motion, Fuel/Vehicle Damage, car-only combat, three pickups, three upgrades, and a small JSON profile exist. Fresh core, loop-simulation, landscape-simulation, and headless streaming-performance proofs pass.

It is not a desktop alpha, mobile port, or App Store candidate. The visible shipping build has a six-line root scene, a 621-line `GameRoot`, default Godot UI, giant flat-color tiles, procedural placeholders, debug telemetry, effectively silent audio, one homing enemy, no objectives/destinations, no production part ecosystem, no versioned save, no verified controller, and no production export/CI/iOS/release infrastructure. Phase 2 now has a separate handling scene and prototype-only ad-hoc macOS export; that evidence lane is not shipping infrastructure. Current green proofs validate prototype hooks, not production experience.

### Proposed finished-game direction

Under a formally cleared public title, build a premium, offline-first, top-down survival road-trip roguelite. The player configures a battered car, enters one seamless three-region county, chooses among authored roads and systemic conditions, completes route-centered expeditions, risks unsecured haul, restores safehouses/routes, and decides when to return. Three chassis, six functional part slots, at least 36 named sidegrade parts, four activity families, 15 landmarks, six safehouses, 24 objectives, 15+ encounter templates, an 8-12 hour primary arc, and postgame Expedition Mode form the launch floor. `Keep Driving` remains an internal working title until the clearance-or-rename gate passes.

The world becomes a hybrid: authored macro roads/landmarks/shortcuts plus deterministic events, weather, threats, and rewards. The visual identity evolves into a sun-bleached illustrated survival road atlas. Vehicle feel remains Arcade-Real but moves to fixed-step analog control and robust collision. One shared game architecture reaches iPhone only after every corresponding desktop system passes.

### Largest recommended changes

1. Replace manual `Node2D` motion/radius contacts with a fixed-step arcade vehicle and real collision substrate.
2. Replace repetitive procedural chunk grammar with an authored/baked county macrograph plus deterministic runtime population.
3. Replace three linear upgrades with a stable-ID catalog, three chassis, six slots, capacity/tradeoff rules, inventory, comparison, and presets.
4. Add destinations, extraction, safehouses, authored restoration progression, four route-centered activity families, and real endgame.
5. Split `GameRoot` into AppFlow, ExpeditionSession, input, vehicle, world, activities, catalog, progression/economy, save, presentation, audio/feedback, settings, and platform adapters.
6. Replace unversioned overwrite save with atomic versioned persistence, v0 migration, backups, recovery, resume, and fault proof.
7. Replace default UI/placeholders/silent audio with production scenes, art, animation, VFX, real buses/assets, haptics, and accessibility.
8. Build clean export/CI/device/TestFlight/App Store infrastructure from scratch.

### Primary technical risks

- Production handling/collision may fail to preserve the prototype's accessible feel.
- Current streaming performance may not survive production assets, spatial queries, audio, VFX, activities, and AI.
- Hybrid world authoring/bake tools may cost more than anticipated or produce repetitive systemic content.
- Save migration/lifecycle failures could destroy progress or duplicate rewards.
- Godot 4.7 plus the current Apple/Xcode SDK floor needs a signed-device proof.
- Touch, safe-area, frame pacing, memory, thermal, and battery behavior cannot be inferred from viewport simulation.

### Primary design risks

- Destinations/contracts could turn the game into generic errands instead of route survival.
- A part ecosystem could collapse into one optimal power stack.
- Three regions and extensive playtime could exceed content-production capacity or become filler.
- Extraction could feel punitive or irrelevant depending on recovery tuning.
- Pure difficulty escalation could overwhelm route choice and mobile readability.
- The exact working title collides with an existing released road-trip game and cannot become the public brand without qualified clearance or a cleared replacement.

### Recommended path to 1.0.0

1. Lock the audited vision and target architecture.
2. Prototype the expensive truths first: handling/collision, hybrid proof region, buildcraft, first minute with real audio/UI, save reliability, and full-stack performance.
3. Integrate those truths into one production desktop vertical slice.
4. Build world, vehicle/parts, progression/economy, activities/content, interface/onboarding, art, audio, and reliability in dependency order.
5. Reach desktop alpha, content-complete beta, and optimized/stable desktop candidate.
6. Only then export/adapt for touch, responsive mobile UI, lifecycle, and physical iOS performance.
7. Complete TestFlight, App Store compliance/assets/review, release-candidate evidence, manual launch, and immediate stabilization.

## 2. Current-state findings

Detailed evidence lives in `docs/CURRENT_STATE_AUDIT.md`.

### What exists and works

- Godot `4.7.stable.official.5b4e0cb0f`, GDScript, GL Compatibility renderer: `project.godot`.
- End-to-end flow and procedural UI: `scripts/game_root.gd`.
- Deterministic chunk data, hashes, marker IDs, matched edge exits: `scripts/world_generator.gd`.
- Bounded 25-active/49-preloaded streaming and one attach/frame: `scripts/world_runtime.gd`.
- Terrain-dependent manual Arcade-Real prototype: `scripts/player_vehicle.gd`.
- Run/profile rule seam and Garage facts: `scripts/run_progression.gd`.
- Simple profile adapter: `scripts/profile_store.gd`.
- Fast Godot-native test/proof scripts: `tests/run_all.gd`, `proofs/*.gd`.
- Existing v0 and Real Vertical Slice decision history: `.scratch/keep-driving-v0/`, `.scratch/keep-driving-real-vertical-slice/`.

### What is incomplete or fragile

- No success/extraction/destination/campaign/completion; all runs fail and bank all Scrap.
- `Miles Driven` is maximum radial distance, not meaningful travel mastery.
- World is repeated four-spoke chunks, flat terrain, one direct-homing enemy, marker scatter, no landmarks/regions/events/navigation/time/weather.
- Vehicle is variable-delta `Node2D`; contact is O(N) radius overlap; damage can repeat every frame; no controller/analog intent.
- Nine hardcoded monotonic upgrade purchases; one vehicle; no parts/builds/inventory.
- UI/audio/art are placeholders; audio proof is a false positive because no samples are pushed.
- Save is unversioned, non-atomic, silent on failure, with no backup/migration/resume/settings/world state.
- No CI, exported desktop release, iOS preset/project, physical-device proof, App Store record/assets/compliance, crash diagnostics, or support/privacy infrastructure.

### Retain

Deterministic pure generation contract; stable marker IDs; bounded streaming metrics; run-progression ownership; ProfileStore adapter concept; Garage clarity standard; Arcade-Real feel/camera vocabulary; Road Warrior identity; desktop-first Godot proof floor.

### Refactor

Application/runtime ownership; fixed-step vehicle/collision; hybrid world/runtime/spatial lifecycle; typed/catalog-driven progression; responsive scene UI; real audio/feedback; layered proof harness.

### Replace

Four-spoke world grammar; flat placeholder presentation; silent generator audio; default player UI/debug dashboard; radius-only collision; three-track linear upgrade content; direct profile overwrite; automated simulation labeled manual proof.

## 3. Proposed 1.0.0 vision

The shipped game is understandable to a developer, designer, artist, and playtester through these invariants:

- **Fantasy:** turn a wreck into a personal machine, read an open hostile road, take one more calculated risk, and bring the car/haul home.
- **World:** one learnable three-region county with authored road hierarchy, 15 landmarks, six safehouses, shortcuts, crossings, time/weather, and deterministic encounter remix.
- **Driving:** fixed-step analog Arcade-Real feel; roads are advantages, never rails; collision weight and surface matter; car-only conflict.
- **Buildcraft:** three chassis, six slots, 36+ named sidegrade parts, five archetypes, explicit capacity/cost/tradeoff, no rarity inflation.
- **Progression:** restore routes/safehouses, discover places/blueprints/chassis, bank material haul by extraction, complete a final cross-county expedition.
- **Activities:** salvage/recovery, risky delivery, route restoration, route mastery, plus dynamic road encounters.
- **Presentation:** sun-bleached animated road atlas, rugged navigation-card UI, real engine/surface/impact/ambience/music, restrained haptics and accessible intensity.
- **Sessions:** first movement in ten seconds; meaningful decision every 30-45 seconds; 15-25 minute expeditions; 8-12 hour first completion; 20+ hour completion/mastery/endgame target.
- **Business:** premium one-time purchase, offline-first, no ads/tracking/account/launch IAP/dark patterns.
- **Platform:** desktop-proven systems adapted through shared contracts to iPhone landscape; physical-device/TestFlight/App Store evidence required.

## 4. Major design decisions

Full records live in `docs/DECISIONS.md`.

| Decision | Recommendation | Reason | Alternatives | Tradeoff | Validation |
|---|---|---|---|---|---|
| World | Authored macrograph + deterministic population | Memorable place and replay variation | Pure procedural; fully static | Authoring/bake cost | Proof region repeat test and perf |
| Driving | Fixed-step custom Arcade-Real controller with robust collision | Preserve feel while fixing production physics/input | Patch Node2D; rigid-body sim | Early rewrite/retune | Handling lab, 30/60/120 Hz, five players |
| Upgrades | Three chassis, six slots, 36+ named sidegrade parts | Deep learnable builds without inflation | Linear tree; random rarity | Catalog/UI/balance work | 12-part sandbox and benchmark matrix |
| Progression | Destination/restoration arc with extraction; Expedition Mode endgame | Adds meaning, risk, completion; preserves endless loop | Failure-only survival; generic missions | More state/content | Three-run economy and full campaign |
| Content | Four route-centered activity families + dynamic encounters | Reuses core systems and protects identity | Broad open-world checklist; survival only | Less genre breadth | Repetition/identity review |
| Visual | Sun-Bleached Survival Road Atlas | Distinctive, top-down/mobile readable, feasible 2D | Pixel art; realism/asset packs | Needs cohesive custom pipeline | Hero minute and screenshot/device test |
| Technical | Incremental deep-module migration, no flag-day rewrite | Keeps playable build and clear ownership | Grow GameRoot; total rewrite | Temporary adapters | Architecture/public-contract review |
| Mobile | Shared logic/adapters; desktop gates first; iPhone landscape | Prevents drift and late platform surprises | Fork; mobile-first now | Strong shared constraints | Physical touch/device/TestFlight matrix |
| Monetization | Premium one-time purchase; no launch IAP/ads/tracking | Aligns with product and privacy | Ads/F2P/subscription | Higher purchase barrier | Pricing/store-page research near launch |
| Save | Versioned atomic envelope, backups, migration, resume | Protects long progression and updates | Extend raw JSON; database | More reliability infrastructure | v0/N-2 fixtures and 1,000 faults |

## Roadmap prioritization method

Order work by:

1. Player impact on the game's identity.
2. Technical/design risk and cost of learning late.
3. Hard dependency order.
4. Cost of changing the decision after content scale-up.
5. Ability to validate with a small playable desktop artifact.
6. Content-production burden and throughput.
7. Desktop-to-mobile portability and performance risk.
8. App Store necessity.

High-risk, high-change-cost assumptions come first. Raw content count and mobile polish wait until vehicle/world/build/save truths pass. Parallel work is permitted only where interfaces and acceptance evidence are stable.

## Milestones

| Milestone | Phases | Exit meaning |
|---|---|---|
| M0 Evidence baseline | 0-1 | Current truth and target product are durable |
| M1 Desktop truth slice | 2-3 | Handling, hybrid place, first minute, build choice, real presentation work together |
| M2 Production foundations | 4-7 | World, vehicle/parts, progression, activities/content pipeline are scalable |
| M3 Complete experience | 8-11 | UI/onboarding, visual, audio, save/settings/accessibility/reliability integrated |
| M4 Desktop alpha | 12 | All systems represented and playable end to end |
| M5 Desktop beta | 13-14 | Launch content complete, optimized, stable |
| M6 Mobile candidate | 15-17 | Shared game adapted and proven on supported iPhones |
| M7 Store release candidate | 18-19 | Compliance, assets, TestFlight, exact archive and evidence pass |
| M8 Launch/stabilize | 20-21 | 1.0 public and urgent defects stabilized |

## 5. Full roadmap

### Phase 0 — Current-State Audit

- **Status:** Complete on 2026-07-11.
- **Objective:** Establish repository/runtime/proof/release truth without assuming prototype claims equal production quality.
- **Player-facing outcome:** None shipped; a trustworthy baseline prevents building on false confidence.
- **Technical outcome:** Concrete inventory, fresh proof metrics, retain/refactor/replace calls, risk register, and canonical 1.0 Wayfinder map.
- **Included:** All code/scenes/config, tracker history, visible build, tests/proofs, save/input/world/UI/art/audio/mobile/release gaps.
- **Excluded:** Gameplay refactor, content production, mobile migration.
- **Dependencies:** Repository and Godot 4.7 executable.
- **Major tasks:** Inspect all tracked runtime files; inspect decision maps; launch visible build; rerun four proof classes; inventory assets/export/CI; record risks.
- **Recommended order:** Objective/Wayfinder -> repo/history -> static code -> fresh tests -> visible play -> synthesis.
- **Risks:** Historical logs mistaken for current evidence; automated simulation mistaken for human play; scope anchored to v0.
- **Risk reduction:** Fresh commands, visible inspection, explicit evidence caveats, target unconstrained by current implementation.
- **Required prototypes:** None.
- **Tools/infrastructure:** Godot CLI, git, local Wayfinder tracker, desktop computer-use inspection.
- **Desktop test plan:** Core suite, loop simulation, landscape simulation, 10,800-frame world perf proof, visible start/run inspection.
- **Performance targets:** Record current baseline; final fresh result 140.6 FPS, 8.734 ms p95 frame, 1.349 ms p95 stream, 25/49 chunks, zero blank-risk frames.
- **Acceptance criteria:** Concrete files/symbols cited; false-positive audio/manual/mobile/perf limits identified; all required audit topics covered.
- **Definition of done:** `docs/CURRENT_STATE_AUDIT.md` and map ticket answer/evidence complete; no critical unknown hidden as fact.
- **Mobile implications:** Establish simulation-only status and all missing device/lifecycle/export work.
- **Documentation:** `CURRENT_STATE_AUDIT.md`, 1.0 Wayfinder map/ticket.
- **Complexity:** Medium.
- **Blocks later work:** Yes; complete.

### Phase 1 — Product Vision and Design Foundation

- **Status:** Complete as Roadmap Phase 1: all ten required documents and the executable phase route exist. Wayfinder tickets 02-07 remain open only as the protocol's one-ticket-per-session audit/index queue; they may correct/reopen decisions and still block Phase 3, but they do not make the roadmap phase or bounded Phase 2 prototypes incomplete.
- **Objective:** Define the strongest bounded 1.0 identity, systems, experience, architecture, platform, business model, and scope.
- **Player-facing outcome:** A coherent promise: premium open-road survival, expressive car builds, meaningful return risk, memorable systemic world.
- **Technical outcome:** Target module/data/save/content/mobile/test contracts and measurable launch floors.
- **Included:** Vision/pillars/loops/journey; world/handling/build/economy/activity design; UX/art/audio; architecture; mobile/release/playtest; decisions and scope buckets.
- **Excluded:** Production implementation and asset creation.
- **Dependencies:** Phase 0.
- **Major tasks:** Choose identity; define launch scope; resolve world/vehicle/progression/content/visual/technical/mobile/monetization decisions; document tradeoffs/validation.
- **Recommended order:** Identity/pillars -> core loops/journey -> system design -> experience -> architecture -> mobile/release -> scope/decisions.
- **Risks:** Wishlist scope; vague “polish”; preservation bias; invented certainty about staffing/market/platform; exact-title legal/confusion risk.
- **Risk reduction:** Numeric content floors, explicit non-goals, Required/Valuable/Post buckets, assumptions with validation timing, and a mandatory qualified clearance-or-rename gate before release identity or brand assets lock.
- **Required prototypes:** Defined for Phase 2, not performed here.
- **Tools/infrastructure:** Repository evidence, local research skill, first-party Apple/Godot sources.
- **Desktop test plan:** Review designs against current playable flow; every player-facing decision maps to a later desktop proof.
- **Performance targets:** Provisional desktop/iOS budgets defined for prototype validation.
- **Acceptance criteria:** Another capable team can identify what is built, why, what is excluded, and how each risky decision will be tested.
- **Definition of done:** All ten required planning documents exist, cross-reference decisions or explicit assumptions, and make the first bounded milestone executable. The separate Wayfinder audit/index queue remains visible until processed one ticket per session.
- **Mobile implications:** Shared input/UI/save/platform constraints captured; migration remains gated.
- **Documentation:** All files listed in Section 8.
- **Complexity:** Large.
- **Blocks later work:** Bounded Phase 2 truth prototypes may run against this baseline. Phase 3, production multiplication, release identity, and ticket 08 remain blocked until the relevant open decision tickets and name-clearance gate resolve.

### Phase 2 — Technical-Risk Prototypes

- **Status:** In progress. The isolated handling prototype and automated smoke cover normalized intent, three distinct demonstration tunes, surface ordering, rolling drag, stationary steering, identical direct 60 Hz step batching under synthetic 30/60/120 render cadences, ordered light/medium/heavy collision response, full reset, one transition per contact, Integrity damage, and nonempty PCM resources. A prototype-only clean macOS export and short rendered harness validations pass, but they are not acceptance evidence. End-to-end rendered 30/60/120 cadence proof, representative art/audio, 1,800-second clean-export runs/capture, human audible mix, physical controller, and five-player evidence remain open.
- **Objective:** Falsify the costliest vehicle, world, buildcraft, first-minute, save, and full-stack performance assumptions before production scale-up.
- **Player-facing outcome:** A rough but real 10-15 minute desktop truth environment that feels controllable, readable, purposeful, audible, and build-dependent.
- **Technical outcome:** Evidence-backed choices for vehicle/collision substrate, hybrid world/bake seam, part catalog/stat model, UI/audio event path, save envelope, and representative performance budget.
- **Included:** Handling track; hybrid proof region; 12-part/four-slot sandbox; first-60-second slice with real assets/audio; v0 save migration/fault spike; representative art/entity/audio/VFX perf scene; one bounded signed-export feasibility gate after the desktop handling/hero slice passes.
- **Excluded:** Full regions/catalog/campaign, production mobile UI/export, broad refactor, final asset quantity.
- **Dependencies:** Phase 0 and the Phase 1 working baseline; exact interfaces in `TECHNICAL_ARCHITECTURE.md`. Open Wayfinder decisions may be indexed in parallel, but Phase 3 remains blocked until the relevant tickets resolve.
- **Major tasks:** Build normalized `DriveIntent`; compare collision approaches; accept the desktop handling/hero slice; clear or replace the public title and lock a development identity; run one export-only Godot/Xcode/sign/install feasibility check with no touch/UI/gameplay adaptation; author/bake one route network; create catalog schema/validator; build compare/test-lot UI; route real audio buses/assets; implement save temp/backup/migration proof; run full-stack metrics/human sessions.
- **Recommended order:** Characterization/evidence naming -> handling/collision/hero minute/audio -> bounded signed export-only check -> hybrid region -> part sandbox -> save fault -> integrated perf/review.
- **Risks:** Prototypes accidentally become unmaintainable production code; polish hides bad feel; multiple unknowns coupled too early.
- **Risk reduction:** Explicit question/acceptance per prototype, disposable locations where appropriate, decision report after each, only selected contracts graduate.
- **Required prototypes:** The six desktop prototypes listed above plus a narrow signed-export feasibility check after the first desktop truth slice is accepted. The signed check proves exporter/Xcode/signing/install only; mobile gameplay/UI adaptation remains deferred to Phase 15.
- **Tools/infrastructure:** Dedicated prototype scenes, input visualizer, benchmark track, minimal prototype-only macOS export preset/build, world bake validator, catalog report, save fault harness, rendered capture, profiler.
- **Desktop test plan:** Five-player handling test; five-player hero minute; repeat proof-region navigation; build benchmark; three-run economy preview; save fixtures/faults; 30-minute representative performance run.
- **Performance targets:** 60 FPS/p95 <=16.7 ms; world work <=4 ms; p99 <=25 ms; no >50 ms driving hitch; no blank terrain/tunneling/overlap spam; provisional memory counters active.
- **Acceptance criteria:** Handling median >=4/5; four/five first-minute comprehension; proof-region decision density; >=3 viable builds/no universal winner; v0 migration/recovery works; representative full-stack budget passes; a minimal signed archive installs and launches on one physical iPhone without requiring a game-system fork.
- **Definition of done:** Each prototype has evidence and keep/change/abandon decision; selected contracts recorded; the bounded signed-export risk is retired; unresolved blocker is fixed or changes the roadmap before Phase 3.
- **Mobile implications:** Intent, responsive component, asset, memory, and lifecycle-safe save contracts are mobile-shaped; no unfinished gameplay is ported.
- **Documentation:** Prototype reports, updated decisions/architecture/game design/playtest findings.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; blocks all production foundation/content work.

### Phase 3 — Core Driving Production Truth Slice

- **Status:** Not started; blocked by Phase 2 acceptance and the relevant open Wayfinder decisions.

- **Objective:** Integrate selected prototype truths into one maintainable desktop vertical slice representing the first 15 minutes and full depart/drive/objective/extract/Garage/restart loop.
- **Player-facing outcome:** A shareable slice that looks/sounds like the game, teaches itself, contains a memorable route choice, meaningful haul/return decision, and one visible build change.
- **Technical outcome:** Production AppFlow/ExpeditionSession/Input/Vehicle/World/ContentCatalog/Presentation/Audio/Save skeleton with old paths removed where replaced.
- **Included:** Utility wagon; fixed-step driving/collision/camera; one proof region route; one objective; extraction/failure; 12 representative parts or the accepted minimum; production HUD/Results/Garage subset; real audio/VFX; versioned save; clean desktop export.
- **Excluded:** All three full regions, final catalog/content count, complete settings/accessibility, mobile export, App Store work.
- **Dependencies:** Phase 2 passes.
- **Major tasks:** Implement module shell; migrate main loop; integrate selected handling/world/catalog/save; build hero UI/audio/art; add export/CI seed; remove superseded prototype root paths; capture evidence.
- **Recommended order:** App/session/content/save interfaces -> input/vehicle -> world -> activity/extraction/economy -> UI/audio/feedback -> export/perf/playtest -> delete old path.
- **Risks:** Half-migrated duplicate authority; scope expands into content production; slice only works on one scripted seed.
- **Risk reduction:** One authoritative state per fact; public integration tests; multiple seeds/failure states; explicit exclusions; architecture review before merge.
- **Required prototypes:** Phase 2 outputs graduate; no new speculative system unless a blocker appears.
- **Tools/infrastructure:** CI fast gate, development build flags, rendered capture, debug overlay, build manifest, clean export preset.
- **Desktop test plan:** Clean profile; tutorial; objective/extraction/failure; Garage compare/install; restart/resume; keyboard/controller; five-seed world; human 15-minute test; release-like performance.
- **Performance targets:** 60 FPS/p95 <=16.7 ms, p99 <=25 ms, world <=4 ms, no >50 ms hitch, stable 30-minute memory, UI acknowledgement <100 ms.
- **Acceptance criteria:** Four/five hero-minute targets; full loop without debug help; real audible state feedback; save/restart correct; no duplicate authority; exported build passes.
- **Definition of done:** Integrated, playable, tested, documented production slice; current Real Vertical Slice map is resolved/superseded with evidence; no open P0/P1.
- **Mobile implications:** Shared contracts and responsive proof floor accepted; desktop touch simulation remains non-release evidence.
- **Documentation:** Slice spec/report, architecture/decision updates, control/asset/content contracts.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; world, parts, progression, content, and presentation scale-up depend on it.

### Phase 4 — World and Free-Roaming Foundation

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Build the production authored/baked county framework and scale the proof region into all three region graphs with streaming-safe content sockets.
- **Player-facing outcome:** A coherent open county with road hierarchy, landmarks, safehouses, shortcuts, crossings, region identity, time/weather rules, and stable backtracking.
- **Technical outcome:** Validated County/Region/RoadGraph sources, world bake, BakedWorld packages, deterministic population, predictive streamer, spatial lifecycle, map/navigation graph, and mutation IDs.
- **Included:** Three region topology; 15 landmark slots; six safehouses; primary/secondary/service/offroad graph; crossings/barriers; event/spawn/weather/audio sockets; map discovery; fast-travel eligibility; debug tools.
- **Excluded:** Final art dressing for every asset, complete encounters/contracts, all world audio, native mobile optimization.
- **Dependencies:** Phase 3; art/content budget contracts from Phase 2.
- **Major tasks:** Author graph; build validators/bake; implement streaming/dependencies; spatial hash/pools; population generator; time/weather state; navigation/discovery; content/hash/mutation save; seed/transition fuzz.
- **Recommended order:** World data/bake -> one region runtime -> spatial/pool -> discovery/map -> time/weather -> remaining topology -> fuzz/perf/content-author workflow.
- **Risks:** Tooling consumes schedule; authored and procedural layers conflict; repetitive sockets; streaming/memory grows with real assets.
- **Risk reduction:** Build one region end to end before multiplying; authoring-time previews/reports; repetition history; representative assets; stable-ID lint.
- **Required prototypes:** Proof-region outputs; one production landmark, crossing, closure, and weather transition per region before full topology lock.
- **Tools/infrastructure:** World graph editor helpers, bake command, content validator, seed/event viewer, teleport anchors, streaming/spatial/pool overlay, map debug.
- **Desktop test plan:** Traverse every graph edge; backtrack/mutations; 100 seeds/1,000 transitions; landmark/navigation comprehension; time/weather; 30-minute high-speed and two-hour soak.
- **Performance targets:** World work p95 <=4 ms; zero blank terrain; <=1 attach/frame until revised; Streaming Drag <1%; memory plateau +/-5%; caps enforced and reported.
- **Acceptance criteria:** Every destination has >=2 credible routes where specified; landmarks orient players; no broken edge/ID/socket; region distinction/readability passes; save mutation/discovery persists.
- **Definition of done:** All launch topology and systems integrated/playable/documented with production workflow and passing desktop evidence; final content/dressing may remain.
- **Mobile implications:** Chunk/memory/asset tiers measured; no mobile port. Avoid architecture that requires all regions resident.
- **Documentation:** World authoring guide, region specs, stable-ID rules, bake/stream budget report, map/navigation rules.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; activity/content scale and full visual production depend on stable world sockets/topology.

### Phase 5 — Vehicle and Upgrade Foundation

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Deliver all launch chassis/slot rules and a scalable catalog-driven part/loadout ecosystem with provable sidegrades.
- **Player-facing outcome:** Three distinct vehicles and at least five route-changing build archetypes that are fast to understand, compare, test, save, and rebuild.
- **Technical outcome:** Vehicle/Part Resources, ContentCatalog validation, stat composition, compatibility/capacity rules, inventory/intake, fabrication/dismantling, presets, test lot, and benchmark tooling.
- **Included:** Three chassis; six slots; at least 36 functional part definitions by content-complete beta; 12+ production-quality foundation parts here; cosmetics framework; exact compare/route forecast; duplicate/overflow/respec rules.
- **Excluded:** Random rarity/affixes, weapons/on-foot systems, final cosmetic quantity, monetized parts.
- **Dependencies:** Phase 3 vehicle/catalog; Phase 4 route/surface capability facts for forecast/benchmarks.
- **Major tasks:** Finalize schemas; implement stat composer/loadout validation; migrate profile; inventory transactions; Garage components; chassis unlock hooks; benchmark scenes/report; content author/validation docs; produce first balanced catalog tranche.
- **Recommended order:** Schemas/benchmarks -> stat/loadout runtime -> inventory/transactions/save -> compare/test lot/presets -> chassis -> part tranche -> balance review.
- **Risks:** Hidden/dominant math, UI overload, combinatorial testing cost, chassis becomes linear tier, content authors bypass tradeoff rules.
- **Risk reduction:** Every part capability+tradeoff contract; standard benchmark matrix; catalog CI; visible route forecast; free swap/undo; playtest adoption/reasoning.
- **Required prototypes:** Accepted 12-part sandbox; add one duplicate/overflow/missing-preset and one deprecated-content migration proof.
- **Tools/infrastructure:** Catalog browser, stat diff, loadout validator, benchmark runner, Garage test lot, inventory/save fixtures.
- **Desktop test plan:** Build five archetypes; road/offroad/impact/Fuel/cargo/threat benchmarks; compare comprehension; preset swap; duplicate/overflow; migration; one-hour multi-build playtest.
- **Performance targets:** Loadout apply/UI compare <100 ms; no per-frame catalog traversal; vehicle remains Phase 3 frame budget; catalog boot/validation measured.
- **Acceptance criteria:** >=3 viable builds now and path to five; no build wins all benchmarks; all parts show consequence/tradeoff; players build <2 minutes and swap <60 seconds; stable save IDs.
- **Definition of done:** Three chassis and foundation catalog fully integrated/playable/tested/documented; content pipeline can add remaining parts without code matches.
- **Mobile implications:** Compare/slot UI has responsive design contract; touch implementation deferred; active vehicle asset/memory variants budgeted.
- **Documentation:** Part/chassis authoring guide, stat semantics, benchmark rules, inventory/duplicate/preset behavior, catalog changelog.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; progression/economy/content rewards require stable part/chassis contracts.

### Phase 6 — Progression and Economy

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Implement the complete restoration arc, extraction/failure reward rules, Scrap economy, unlock pacing, records, and anti-grind protections.
- **Player-facing outcome:** Every expedition changes a place, capability, build, or goal; returning and pushing farther are meaningful; the game has a clear completion arc.
- **Technical outcome:** Typed/versioned profile and expedition models, Progression/Economy/Inventory transactions, reward escrow/security, milestone graph, records, tuning/simulation tools.
- **Included:** Safehouse/region/final milestones; chassis/blueprint unlocks; Scrap sources/sinks; secured/unsecured cargo; failure recovery; first-session choice; records; catch-up/migration; completion and Expedition unlock.
- **Excluded:** Live-service progression, multiple currencies, battle pass, daily obligation, final contract content balance.
- **Dependencies:** Phases 4-5; SaveService foundation from Phase 3.
- **Major tasks:** Define milestone graph/reward tables; transaction APIs; expedition resolution; Results facts; economy simulation; anti-farm/diminishing repeat rules; unlock/catch-up; records; save fixtures; player tests.
- **Recommended order:** Domain invariants -> resolution/security -> milestones/unlocks -> sources/sinks -> Results/records -> simulation -> three-run/hour/midgame tests -> tune.
- **Risks:** Grind, intentional failure/farming, rewards too punitive/generous, progression dead ends, content IDs/migrations break profiles.
- **Risk reduction:** Guaranteed unlocks; one-currency audit; deterministic simulation; clean/failure-heavy/success-heavy fixtures; exact UI consequences; no hidden rubber-banding.
- **Required prototypes:** Three-run economy proof and one-hour build-path test; full arc simulation before content lock.
- **Tools/infrastructure:** Economy simulator/report, milestone graph validator, transaction log, profile fixtures, reward fault/duplication tests.
- **Desktop test plan:** Clean first hour; three-run push/return/fail; four-hour midgame; alternate chassis; farming attempts; completion fixture; migration/duplicate transaction/restart.
- **Performance targets:** Transactions/Results <100 ms excluding deliberate animation; no economy work in physics frame; save commit within lifecycle budget.
- **Acceptance criteria:** First meaningful choice in first session; >=2 credible paths in hour; no 30-45 minute required dead zone; no optimal idle/fail farm; players predict secured/lost state; completion reachable without all content.
- **Definition of done:** Full progression/economy integrated, balanced to alpha confidence, migration-safe, human-tested, documented, and no exploit/progression blocker.
- **Mobile implications:** Short-session safe boundaries and background-safe transactions; mobile adaptation deferred.
- **Documentation:** Economy tables/rules, milestone graph, reward security, records, balancing procedure, migration map.
- **Complexity:** Large.
- **Blocks later work:** Yes; activity rewards and campaign content need stable progression/economy.

### Phase 7 — Core Activity and Content Systems

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Build reusable activity/encounter authoring systems and produce a representative cross-region content set before full quantity scale.
- **Player-facing outcome:** Salvage/recovery, risky delivery, restoration, mastery, and dynamic road events feel different while keeping route/build decisions central.
- **Technical outcome:** ActivityService, contract/state/resume/reward schemas, encounter director/templates, authored sockets, validation, debug forcing, repetition metrics, content pipeline.
- **Included:** Four activity families; dynamic encounters; objective markers/interactions; cargo properties; success/failure/resume; region eligibility; first production content tranche; authoring/QA tools.
- **Excluded:** AI racing, escort, on-foot systems, daily chores, final 24/15+ quantity (completed in beta production).
- **Dependencies:** Phases 4-6.
- **Major tasks:** Implement base activity contract; each family vertical example; encounter selection/history/safety; cargo behavior; reward integration; author validator/debug; content review; repeat across regions.
- **Recommended order:** Base state/reward/resume -> salvage -> delivery -> restoration -> mastery -> dynamic encounters -> tooling/repetition report -> representative tranche.
- **Risks:** Generic errands, repetitive templates, encounter unfairness, authored scripting debt, reward exploits, AI scope creep.
- **Risk reduction:** Route/build relevance criterion; socket/state templates; reaction/navigability validation; repetition history; excluded activity list; content peer/playtest review.
- **Required prototypes:** One end-to-end example per family and one event chain under changed weather/route before content multiplication.
- **Tools/infrastructure:** Contract editor/schema, socket validator, encounter/event forcing, recent-template report, cargo debug, objective/resume fixtures, content checklist.
- **Desktop test plan:** Each activity on >=2 routes/builds; every outcome/resume/failure; event reaction distance/reroute; one-hour mixed session; repetition review; performance with max representative event.
- **Performance targets:** Activity/encounter decisions outside hot frame; spatial/AI budgets preserved; no >50 ms activation hitch; entity/effect caps enforced.
- **Acceptance criteria:** Players explain family differences; every family changes route/cargo/build/risk; no unavoidable lethal event; no duplicate reward/resume exploit; author can create validated content without runtime code edits.
- **Definition of done:** Systems and representative content integrated/playable/tested/documented; pipeline is ready for launch content production.
- **Mobile implications:** Objective density and HUD facts stay phone-readable; no mobile implementation yet; AI/entity budgets anticipate device tiers.
- **Documentation:** Activity/encounter authoring guide, template catalog, safety/repetition rules, cargo semantics, QA matrix.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; content-complete beta depends on stable production pipeline.

### Phase 8 — Interface and Onboarding

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Implement every required player flow as reusable responsive production UI and make first launch/first expedition self-explanatory.
- **Player-facing outcome:** Title, setup, Garage, mission board, map, HUD, pause, Results, settings/accessibility/save/error flows are fast, clear, device-aware, and consistent.
- **Technical outcome:** AppFlow screen routing, `.tscn` component library, Theme/tokens, presenters, localization, focus maps, responsive/aspect/text harness, input glyph system.
- **Included:** All information architecture in UX spec; Garage lot tutorial; first expedition; loading/empty/error/offline; 100-200% text; pseudoloc; keyboard/controller; simulated touch layout.
- **Excluded:** Final mobile touch polish/device proof, every localization language, final App Store assets.
- **Dependencies:** Phases 3-7 stable facts; art direction tokens.
- **Major tasks:** Build theme/components; route screens; presenters; onboarding; map/Garage/mission/results; settings/save/recovery; localization extraction; focus/glyph; aspect/text/capture tests; human usability.
- **Recommended order:** Tokens/components -> AppFlow/title/pause -> HUD/onboarding -> map -> Garage -> mission/results -> settings/accessibility/save/errors -> localization/focus/matrix.
- **Risks:** Information overload, hardcoded desktop layouts, controller focus traps, localization late, UI couples domain rules.
- **Risk reduction:** Presenter boundaries; component state matrix; mobile floor from day one; pseudoloc; new-player tests; no text-shrinking to fit.
- **Required prototypes:** Accepted hero-minute/compare UI; UI shell proof at phone/desktop, controller, 200% text, +40% pseudoloc.
- **Tools/infrastructure:** UI gallery, design tokens/Theme, screenshot matrix, safe-area/text/pseudoloc preview, focus inspector, input glyph switcher.
- **Desktop test plan:** Every common flow by keyboard/controller; clean/current/corrupt/empty saves; 100/150/200% text; supported aspect matrix; five-player onboarding; response timing.
- **Performance targets:** Input acknowledgement <100 ms; screen open/transition no >50 ms hitch after preload; no blocking content scan on UI thread.
- **Acceptance criteria:** First-minute targets; 80% loop comprehension; all common flows complete without pointer; no blocking clipping/focus/color-only/debug state; errors state preservation.
- **Definition of done:** All required flows integrated, localized-ready, accessible baseline, tested, documented, and accepted on desktop/responsive simulation.
- **Mobile implications:** Shared responsive components and facts accepted; physical touch/safe-area/lifecycle adaptation deferred to Phases 16-17.
- **Documentation:** UI architecture/component guide, onboarding script, focus/back rules, localization workflow, error copy/state table.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; visual/audio finalization, alpha usability, and mobile adaptation depend on it.

### Phase 9 — Visual-Quality Production

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Replace all placeholder visuals with a cohesive Sun-Bleached Survival Road Atlas asset/animation/VFX package across required content.
- **Player-facing outcome:** World, vehicles, landmarks, threats, pickups, weather, UI, rewards, and marketing frames look like one distinctive finished game and remain readable at speed.
- **Technical outcome:** Validated asset pipeline, atlases/materials, animation state, VFX pools/caps, region kits, source/license/import metadata, quality tiers, screenshot capture points.
- **Included:** Three region kits; three chassis/visible parts; entities/props/landmarks; UI icons/theme; weather/day-night; damage/movement/reward VFX; final fonts; cosmetics floor.
- **Excluded:** Post-1.0 region/vehicle sets, photorealism, unbounded decorative variants.
- **Dependencies:** Phases 4-8; representative art perf from Phase 2; formal clearance of the exact public title before type/logo/icon, name-bearing art, or marketing frames lock. Non-branded world/vehicle production may proceed while that gate is pending.
- **Major tasks:** Pass the clearance-or-rename gate; lock art bible/palette/type/icon; build asset/import pipeline; hero assets; region kits; vehicle/part layers; world props/landmarks; UI/icons; VFX/animation/weather; license audit; optimize/review.
- **Recommended order:** Art bible/technical specs -> hero minute -> one complete region -> vehicle/entity kits -> remaining regions -> UI/icons -> VFX/weather/cosmetics -> consistency/perf/license pass.
- **Risks:** Inconsistent outsource/generated assets, screenshot-first detail hurts play, texture/material/memory explosion, art throughput below content plan.
- **Risk reduction:** Source templates/review gates; atlas/material budgets; production throughput measured after one region; silhouette/value tests; no broad asset generation before art lock.
- **Required prototypes:** Hero minute and representative region/asset-streaming spike; one final landmark/chassis/weather stack before scale.
- **Tools/infrastructure:** Art bible, source/license manifest, import presets, atlas report, asset gallery, screenshot/capture tests, VFX/pool overlay, color/contrast checks.
- **Desktop test plan:** Phone-scale recognition; region/landmark recall; screenshot readability; weather/night/accessibility modes; max-density full-stack perf; asset/license validator.
- **Performance targets:** Preserve 60 FPS/p95 <=16.7/p99 <=25; no >50 ms hitch; texture/material/draw/node/effect budgets reported; memory plateau maintained.
- **Acceptance criteria:** No placeholder/debug visual; all critical objects recognized without labels/color-only; regions distinct; screenshots honest/readable; source/license/import complete; representative max scene passes.
- **Definition of done:** Required launch visual content integrated, consistent, optimized, licensed, tested, and documented.
- **Mobile implications:** Quality tiers and compressed atlas plan ready; physical device tuning later; essential silhouettes survive reduced effects/detail.
- **Documentation:** Art bible, palette/type/icon specs, asset/import/license guide, region kits, VFX/animation/perf budgets.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; content-complete beta and mobile memory/performance need final-like assets.

### Phase 10 — Audio and Game-Feel Production

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Deliver real state-driven vehicle/world/UI/music audio, haptics semantics, and polished multimodal feedback.
- **Player-facing outcome:** Engine/load/surface, drift, impacts, threats, weather, rewards, warnings, Garage, Results, and music make driving tactile and information clear without overload.
- **Technical outcome:** Audio buses/director, layered engine/surface states, voice limits, ambience/music state, real asset validation, capture/audible proof, FeedbackDirector, platform haptic events.
- **Included:** Master/Music/Vehicle/World/UI buses; three chassis-compatible vehicle layer; surface/impact/event/UI/ambience/music; warnings; visual equivalents; mix and dynamic-range settings; semantic haptic map.
- **Excluded:** Voice-heavy narrative, separate full recording set per loadout, mobile physical haptic tuning until device phase.
- **Dependencies:** Phases 3, 7-9; stable event semantics and asset identity.
- **Major tasks:** Source/license audio; buses/director; engine/surface; impact/threat; UI/reward; ambience/music; rate limits/concurrency; accessibility/mix; capture/human mix; haptic adapter events.
- **Recommended order:** Event/bus contract -> engine/surface -> impacts/warnings -> UI/reward -> ambience/music -> mix/accessibility -> full-stack perf/audible review.
- **Risks:** Repeating/fatiguing loops, voice overload, silent regression, music fights warnings, asset licensing, audio thread/memory cost.
- **Risk reduction:** Real audible proofs; state machine/rate limits; mix hierarchy; long-session review; source manifest; no headless counter as acceptance.
- **Required prototypes:** Accepted hero-minute real-audio slice; one full 15-minute mix across calm/pressure/critical/Results/Garage.
- **Tools/infrastructure:** Audio event monitor, bus/voice overlay, loudness/capture workflow, asset/license catalog, automated resource/routing/concurrency tests.
- **Desktop test plan:** Human audible/mix session; engine continuity and all surfaces; impact classes; warning masking; pause/resume; settings/mono/visual cues; 30-minute fatigue/perf.
- **Performance targets:** No audio-induced >50 ms hitch; bounded voices/memory; instant pause/resume without duplicate loops; UI feedback <100 ms.
- **Acceptance criteria:** All required states audible/distinct/mix-controlled; no silent placeholder; visual equivalents; long session not fatiguing; real resources/buses/capture and human check pass.
- **Definition of done:** Production audio/game feel integrated, licensed, performant, accessible, tested, and documented on desktop.
- **Mobile implications:** Compressed/streamed/preloaded strategy and semantic haptics ready; audio-session/device behavior deferred.
- **Documentation:** Audio bible/event map, bus/mix policy, asset/license list, haptic semantics, proof procedure.
- **Complexity:** Large.
- **Blocks later work:** Yes; desktop alpha quality and mobile audio/haptic adaptation require it.

### Phase 11 — Save, Settings, Accessibility, and Reliability

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Make profile/expedition/settings state durable across failure/update/lifecycle and complete the required accessibility/recovery suite.
- **Player-facing outcome:** Progress is safe, interruption is unsurprising, settings persist, errors explain preservation/recovery, and common play adapts to control/sensory needs.
- **Technical outcome:** Final versioned atomic SaveService; v0/N-2 migrations; backups/recovery; active resume; SettingsService; fault harness; accessibility settings; structured release logs.
- **Included:** Profile/session/settings schemas; migration; temp/backup/checksum; autosave boundaries; corrupt/low-storage recovery; reset/debug fixtures; controls/display/audio/gameplay/accessibility/language/privacy settings; release diagnostics.
- **Excluded:** Mandatory cloud/account; incomplete App Store accessibility claims; third-party telemetry by default.
- **Dependencies:** Phases 3-10 final persistent facts and UI.
- **Major tasks:** Final schemas; implement atomic protocol/backups; migrate v0; active session checkpoint; lifecycle-neutral snapshot; settings persistence/application; recovery UI; fault/low-storage/corruption tests; accessibility end-to-end; logs/privacy review.
- **Recommended order:** Schema/fixtures -> atomic adapter -> migration/recovery -> checkpoint/resume -> settings -> recovery/reset UI -> faults -> accessibility matrix -> privacy/log audit.
- **Risks:** Data loss/duplication, migration edge cases, background latency, setting interactions break gameplay/UI, false accessibility claims.
- **Risk reduction:** Immutable snapshots; sequence/checksum/backups; fault injection; stable IDs; settings matrix; criteria-specific accessibility tests; no silent default replacement.
- **Required prototypes:** Phase 2 save spike graduates; complete 1,000 write/lifecycle faults and corrupt/low-storage cases.
- **Tools/infrastructure:** Save inspector/migrator/fault injector, schema fixtures, input/settings matrix, screenshot/text/contrast/motion/audio-cue harness, release-log export.
- **Desktop test plan:** Real v0/N-2/unknown/deprecated/corrupt/truncated/max values; 1,000 interruptions; active resume/outcome transactions; every settings group; 200% text/reduced motion/visual audio/controller remap.
- **Performance targets:** Save snapshot/commit outside hot frame and within lifecycle budget; resume <=2 seconds desktop reference; no save-related >50 ms driving hitch.
- **Acceptance criteria:** Zero data loss/duplication; latest valid backup recovery; idempotent migrations; settings persist/apply; common accessibility flows pass; error states exact.
- **Definition of done:** Reliability/accessibility suite integrated, documented, fault-tested, privacy-reviewed, and no open P0/P1.
- **Mobile implications:** Persistence snapshots/lifecycle API and responsive settings ready; physical background/low-storage/safe-area proof later.
- **Documentation:** Save schema/migrations/recovery runbook, settings defaults, accessibility matrix/claims record, diagnostic/privacy inventory.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; alpha/beta and mobile lifecycle cannot proceed without durable state.

### Phase 12 — Desktop Alpha

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Integrate every major 1.0 system in one exported desktop build and prove the full product shape before launch-content completion.
- **Player-facing outcome:** A new player can complete representative early/mid/late expeditions, use all chassis/build/activity families, restore progression, and finish a provisional campaign path.
- **Technical outcome:** One authoritative architecture, clean export/CI, representative content, release-like instrumentation, and a prioritized defect/design backlog.
- **Included:** All systems; representative content in every region; complete flow; keyboard/controller; save/update; accessibility baseline; full-stack perf; internal alpha cohort.
- **Excluded:** Final content quantity/balance, mobile adaptation, store assets, perfect polish.
- **Dependencies:** Phases 3-11.
- **Major tasks:** Integration audit; remove superseded paths; clean export/install; full campaign skeleton; alpha test plan/cohort; perf/save/accessibility passes; triage/fix blockers; update scope.
- **Recommended order:** Architecture/content audit -> clean build -> internal full playthrough -> structured alpha -> blocker fixes -> repeat evidence -> alpha signoff.
- **Risks:** Systems work separately but not coherently; integration defects; content gaps misdiagnosed as polish; architectural leftovers.
- **Risk reduction:** Frozen alpha candidate; end-to-end new/mid/late fixtures; human cohort; evidence taxonomy; delete dead authority; no content count rush.
- **Required prototypes:** None; discovered unknowns become bounded spikes only if they block acceptance.
- **Tools/infrastructure:** Desktop export/install script, CI artifacts, alpha build manifest, crash/log collection, session templates, defect tracker.
- **Desktop test plan:** 10-15 players; clean first hour; representative full arc; every chassis/activity/region; keyboard/controller; install/update/offline; save fault; two-hour soak.
- **Performance targets:** 60 FPS/p95 <=16.7/p99 <=25; world <=4 ms; no >50 ms hitch; memory plateau; cold launch <=5 seconds; resume <=2.
- **Acceptance criteria:** >=80% loop comprehension; median session >=4/5 or owned changes; all systems integrated; no P0/P1; major P2 trends owned; clean export reproducible.
- **Definition of done:** Alpha evidence signed off, architectural/product blockers resolved, content production plan reforecast with measured throughput.
- **Mobile implications:** Desktop systems freeze enough for later adaptation; any mobile-hard architecture defect is fixed before content completion.
- **Documentation:** Alpha report, defect/design backlog, architecture drift review, content throughput/scope update, proof manifest.
- **Complexity:** Large.
- **Blocks later work:** Yes; content-complete beta begins only after system-level alpha confidence.

### Phase 13 — Desktop Content-Complete Beta

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Produce, integrate, balance, and validate every Required-for-1.0 content item and the complete primary/endgame experience.
- **Player-facing outcome:** Full three-region campaign, 15 landmarks, six safehouses, 24 objectives, 15+ encounters, three chassis, 36+ parts, five builds, mastery, and Expedition Mode are playable start to finish.
- **Technical outcome:** Content/catalog/world hashes locked, migration path stable, no missing IDs/assets/strings/licenses, and beta-quality performance/reliability.
- **Included:** All required launch content; final progression/economy; region/weather/event variety; cosmetics floor; English content; optional Valuable items only after required gates.
- **Excluded:** New systems, post-1.0 region/chassis, native mobile adaptation, speculative Valuable features that threaten quality.
- **Dependencies:** Phase 12 and stable production pipelines.
- **Major tasks:** Produce content by region/family/catalog; continuous validation/playtest; full clean-profile completion; repetition/density/balance review; final content IDs; localization-ready copy; bug burn-down.
- **Recommended order:** Complete Lowlands/reference throughput -> Badlands -> Blackwood -> cross-region/final arc -> parts/builds -> Expedition/mastery -> full balance/repetition pass -> content lock.
- **Risks:** Filler/repetition, throughput miss, late content breaks perf/save, balance drift, scope creep from Valuable bucket.
- **Risk reduction:** Weekly density/repetition/throughput reports; modular templates with authored difference; content freeze; Required first; performance/save/catalog gates per tranche.
- **Required prototypes:** None; every new template must use accepted authoring contracts and get one representative validation before multiplication.
- **Tools/infrastructure:** Content dashboards, region/checklist validators, repetition report, economy/build benchmarks, full-playthrough fixtures, localization/license coverage.
- **Desktop test plan:** 20-30 player beta; clean full campaign; returning/mid/late profiles; failure/success-heavy; all chassis/builds; Expedition/mastery; two-hour soak; install/update/save migrations.
- **Performance targets:** Meet Phase 12 with worst launch content; no content activation hitch >50 ms; package/memory projections within mobile targets.
- **Acceptance criteria:** All numeric floors met without filler; no progression/random grind blocker; every build/activity/region viable/distinct; zero P0/P1; bounded P2; complete content/license/string IDs; clean-profile active-play cohort meets the 8-12 hour primary-arc and 20+ hour completion/mastery contracts in Section 6.
- **Definition of done:** Content complete and frozen except bug/balance corrections; full campaign/endgame evidence and beta report approved.
- **Mobile implications:** Final content defines real asset/package/memory/UI/device workload; no new required content added after mobile entry without requalification.
- **Documentation:** Content catalog/release inventory, region completion reports, balance/economy snapshot, known issues, localization/license manifest.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; mobile adaptation must target final workload.

### Phase 14 — Desktop Optimization and Stabilization

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Convert content-complete beta into a stable, optimized, release-like desktop reference that becomes the mobile source baseline.
- **Player-facing outcome:** Smooth, reliable, coherent full game with no blocker, hitch, leak, corrupted save, input failure, or major usability defect.
- **Technical outcome:** Profiled/fixed worst frames, bounded memory/pools/caches, reproducible release export, hardened save/update, stable interfaces/content freeze, regression suite.
- **Included:** CPU/GPU/frame/memory/audio/physics/world/UI profiling; soak; seed/content fuzz; crash/hang/save bug fixes; controller; install/update; accessibility/localization regression.
- **Excluded:** New required feature/content, iOS-specific tuning, store marketing.
- **Dependencies:** Phase 13.
- **Major tasks:** Capture baselines/worst frames; fix algorithms/sync work; pool/batch/compress; leak/soak; regression/fuzz; save/install/update; human stability pass; freeze baseline/tag.
- **Recommended order:** Measure -> correctness/leaks -> algorithm/sync -> batching/pooling/assets -> worst content -> soak/regression -> release export/tag.
- **Risks:** Optimization changes feel/readability; late regressions; chasing averages instead of worst frames; hidden seed/content spikes.
- **Risk reduction:** Before/after evidence; p95/p99/worst capture; human handling/readability regression; 100+ seeds; content matrix; no premature low-value micro-optimization.
- **Required prototypes:** None; targeted performance spike only for measured hotspot.
- **Tools/infrastructure:** Full profiler, frame capture, memory/node/draw/audio/physics metrics, soak runner, seed/content matrix, release artifact provenance.
- **Desktop test plan:** Full campaign regression; 100 seeds/1,000 transitions; 30-minute max-load; two-hour traversal; save/update; all input/accessibility; external desktop smoke.
- **Performance targets:** 60 FPS/p95 <=16.7/p99 <=25; world <=4 ms; no >50 ms hitch; Streaming Drag <1%; memory +/-5% plateau; launch <=5; resume <=2.
- **Acceptance criteria:** Zero P0/P1; stable full game and content; no leak/hitch/seed spike above targets; release artifact reproducible; interfaces/content frozen for mobile.
- **Definition of done:** Tagged desktop reference with manifest/evidence becomes the sole source baseline for mobile adaptation.
- **Mobile implications:** Establishes final behavior/content/perf comparison; mobile cannot mask a desktop correctness defect.
- **Documentation:** Optimization report, budgets/baselines, frozen interface/content versions, release build/runbook, accepted P2 list.
- **Complexity:** Large.
- **Blocks later work:** Yes; mobile entry gate.

### Phase 15 — Mobile Architecture Preparation and Signed Export

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Prove the frozen shared game can export, sign, install, archive, and survive basic iOS lifecycle without yet redesigning unfinished gameplay.
- **Player-facing outcome:** Internal signed iPhone build reaches the same core game, though touch/UI/performance adaptation is not yet final.
- **Technical outcome:** Xcode/Godot toolchain, iOS preset, bundle/version/signing, PlatformService iOS adapter, lifecycle/safe-area/audio/haptic stubs, build manifest, internal TestFlight pipeline.
- **Included:** Recheck current Apple/Godot requirements; Xcode 26+/iOS 26 SDK current floor; provisional iOS 17 target; iPhone family; signed archive/install; privacy manifest baseline; lifecycle/save smoke; internal upload.
- **Excluded:** Final touch controls/layout, full device optimization, store metadata/assets/review submission, iPad unless promoted.
- **Dependencies:** Phase 14; the Phase 2 signed-export feasibility pass; formally cleared public title; approved immutable release identity; Apple membership/signing/tool access.
- **Major tasks:** Reverify tools/templates; commit production export preset; verify the already approved immutable identity; generate/inspect Xcode target; implement adapters; archive/validate/install; internal TestFlight; record gaps.
- **Recommended order:** Requirement/tool audit -> identity/preset -> local export -> adapter basics -> physical install -> lifecycle/save/audio/haptic smoke -> archive/validate -> internal TestFlight.
- **Risks:** Godot exporter/Xcode incompatibility, signing delay, privacy manifest/API issue, platform adapter leaks into domain, unsupported deployment/device floor.
- **Risk reduction:** Small first archive from frozen source; inspect generated project/archive; minimal entitlements/SDKs; protected secrets; requirement recheck; explicit raise-floor decision before external promise.
- **Required prototypes:** Reproduce the Phase 2 signed-export feasibility result against the frozen production source; no new gameplay prototype.
- **Tools/infrastructure:** Xcode/Godot templates, export preset, signing/keychain, build/version automation, privacy report, archive/symbol/manifest retention, internal TestFlight.
- **Desktop test plan:** Full desktop regression remains green after platform adapter work.
- **Performance targets:** Basic launch/resume/save correctness; detailed device budgets measured and baselined, not yet final.
- **Acceptance criteria:** Reproducible signed archive installs/launches; correct ID/version/orientation/safe area; background/resume does not corrupt/duplicate; internal TestFlight processes; no domain fork.
- **Definition of done:** Mobile toolchain/adapter risks retired and exact adaptation backlog/device matrix approved.
- **Mobile implications:** This is the formal mobile entry; all subsequent work uses physical evidence.
- **Documentation:** Toolchain/export/signing runbook, adapter contract, requirement snapshot, device matrix/baseline, privacy SDK/API inventory.
- **Complexity:** Large.
- **Blocks later work:** Yes; touch/UI and device optimization need a real signed build.

### Phase 16 — Mobile Controls and Interface Adaptation

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Make every common game/menu flow comfortable, readable, safe-area correct, and interruption-safe on physical iPhones.
- **Player-facing outcome:** Precise simultaneous touch driving, customizable/left-handed controls, responsive HUD/map/Garage/settings, optional controller, and accessible mobile interaction.
- **Technical outcome:** Touch `DriveIntent` adapter, multi-contact state machine, platform glyph/focus handoff, responsive phone layouts, safe-area/orientation tests, touch settings persistence.
- **Included:** Primary steering/pedals/handbrake; size/opacity/position/sensitivity; left-handed; optional auto-accelerate assist; landscape both sides; controller handoff; every common UI flow.
- **Excluded:** Tilt/second scheme unless capacity and test proof; native iPad; final performance/thermal optimization.
- **Dependencies:** Phase 15 and shared UI/input contracts from desktop.
- **Major tasks:** Physical touch prototype; simultaneous/interruption cases; layout reflow; safe areas/orientation; phone Garage/map/results/settings; glyph/controller handoff; accessibility settings; human mobile tests.
- **Recommended order:** Touch driving -> stuck/interruption -> HUD -> map/Garage -> remaining flows -> customization/accessibility -> controller handoff -> matrix regression.
- **Risks:** Imprecise steering, finger occlusion, stuck intent, small-screen compare overload, safe-area/text conflict.
- **Risk reduction:** Minimum/small/large physical tests; adjustable layout; clear intent on lifecycle; prioritization/reflow rather than shrink; recruited touch players.
- **Required prototypes:** Physical multi-touch truth slice; largest-controls/200%-text/small-screen UI shell.
- **Tools/infrastructure:** Input visualizer, safe-area/aspect capture matrix, touch replay/diagnostics, controller/glyph switcher, TestFlight feedback.
- **Desktop test plan:** Shared keyboard/controller/full-loop regression; simulated phone matrix remains fast gate.
- **Performance targets:** Input sampled next physics tick; UI acknowledgement <100 ms; no stuck contact; layout transition no >50 ms hitch.
- **Acceptance criteria:** Simultaneous touch cases pass; all common flows reachable; target/spacing/safe-area/text/focus rules pass; five-player touch handling/comprehension; controller disconnect safe.
- **Definition of done:** Mobile control/UI system integrated, customizable, accessible, physically tested, documented, no P0/P1.
- **Mobile implications:** Core adaptation complete; proceeds to workload optimization/lifecycle matrix.
- **Documentation:** Touch control spec/defaults, safe-area/layout matrix, controller handoff, accessibility results, known device issues.
- **Complexity:** Large.
- **Blocks later work:** Yes; device beta requires usable controls/UI.

### Phase 17 — iOS Device Testing and Optimization

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Meet frame, memory, thermal, battery, launch, lifecycle, audio/haptic, save, offline, and supported-device budgets with final content.
- **Player-facing outcome:** Stable full game on minimum through current iPhones, with correct 30/60 modes and no degraded core readability/feel.
- **Technical outcome:** Quality tiers, asset/audio compression, bounded caches/pools/voices, lifecycle hardening, device evidence, external-TestFlight-ready build.
- **Included:** Minimum/small/mid/large/current devices; iOS min/latest; clean install/update; offline; touch/controller; lifecycle; low storage/battery; thermal/memory; full campaign; save faults.
- **Excluded:** New gameplay/content; App Store screenshots/marketing except test captures; optional iPad unless approved.
- **Dependencies:** Phase 16, final desktop content/baseline.
- **Major tasks:** Device baseline; profile worst scenes; fix sync/scaling; tune atlases/audio/materials/effects/quality; lifecycle/audio/haptics; 1,000 faults; 30-min thermal/battery; two-hour memory; internal stability gate; freeze the external-TestFlight-ready candidate for Phase 18.
- **Recommended order:** Minimum device correctness -> frame/memory -> assets/effects/audio -> lifecycle/save -> thermal/battery -> full matrix -> internal stability -> external TestFlight candidate.
- **Risks:** Minimum device cannot meet core quality; thermal drift; memory warnings; device-specific renderer/input/audio/save defects.
- **Risk reduction:** Raise floor before public promise if necessary; optional quality first; fixed-step invariants; representative current/old hardware; exact evidence per build.
- **Required prototypes:** None; all work is release-like device validation/optimization.
- **Tools/infrastructure:** Xcode Instruments/Organizer, Godot profiler/metrics, device logs/symbols, automated lifecycle/save faults, TestFlight, battery/thermal protocol.
- **Desktop test plan:** Frozen desktop reference regression on every shared-code change.
- **Performance targets:** Minimum 30 FPS/p95 <=33.3; A15+ 60/p95 <=16.7/p99 <=25; <=350 MB working/<=500 MB peak provisional; launch <=5; resume <=2; thermal/battery target; no leaks.
- **Acceptance criteria:** All supported tiers/OS pass; no blank/hitch/stuck/audio duplicate/save loss; 1,000 faults; internal crash/hang evidence is stable enough to expose externally; no P0/P1; exact candidate and matrix are ready for the defined Phase 18 external beta.
- **Definition of done:** Supported matrix and final minimum OS/device floor locked; external-TestFlight-ready candidate approved for Phase 18. The 50-participant/1,000-session/14-day external gate has not yet run.
- **Mobile implications:** Mobile gameplay candidate complete; only compliance/RC fixes remain.
- **Documentation:** Device/perf reports, quality-tier rules, lifecycle/audio/haptic/save matrix, final support floor, beta notes.
- **Complexity:** Extra Large.
- **Blocks later work:** Yes; App Store/RC cannot proceed without physical evidence.

### Phase 18 — App Store Compliance and Launch Preparation

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Prepare every product-page, identity, legal/privacy, accessibility, export, TestFlight, review, support, and launch operation for the exact candidate.
- **Player-facing outcome:** Honest polished store page, working support/privacy, accurate age/accessibility/privacy/controller claims, and review-ready complete game.
- **Technical outcome:** Final identity/signing/entitlements/privacy manifest, processed builds, metadata/assets, compliance records, review notes, support/monitoring/emergency pipeline.
- **Included:** The preparation and external-beta portions of `APP_STORE_RELEASE_CHECKLIST.md`; screenshots/previews; icons/launch; price/territories; age/privacy/accessibility/export/DSA; support/privacy URLs; review notes and package assembly. Phase 19 owns final RC selection/submission/review, Phase 20 owns launch-day items, and Phase 21 owns post-launch items.
- **Excluded:** New feature/content, unproven optional service, speculative marketing claim, App Review submission, and review-resolution changes.
- **Dependencies:** Phase 17 candidate; formally cleared public title; approved publisher/bundle identity; legal/business assets/accounts/URLs.
- **Major tasks:** Recheck requirements; final SDK/privacy inventory; create/finish record; capture assets; complete metadata/declarations; external TestFlight; support/emergency drill; assemble and internally approve the review package.
- **Recommended order:** Identity/business prerequisites -> privacy/legal/SDK -> icons/launch -> metadata/screenshots -> accessibility/age/export -> TestFlight -> review notes/support -> checklist audit.
- **Risks:** Volatile Apple rules, immutable ID mistake, declaration/archive mismatch, misleading assets, missing URL/legal/account, review delay.
- **Risk reduction:** First-party recheck at gates; exact archive audit; no optional capability; retained store snapshot; schedule margin before the promised date; staffed contact.
- **Required prototypes:** None; honest marketing captures from RC-like build.
- **Tools/infrastructure:** App Store Connect, Xcode archive/privacy report, screenshot/video pipeline, release checklist/runbook, support/privacy site, TestFlight.
- **Desktop test plan:** Desktop reference regression for shared fixes; store assets reviewed against exact release experience.
- **Performance targets:** Candidate retains Phase 17 budgets and >=99.8% crash-free beta; no compliance-driven SDK regression.
- **Acceptance criteria:** Every applicable checklist item has owner/evidence; exact build/declarations/assets agree; external beta passes; review package is internally accepted; no P0/P1/review blocker.
- **Definition of done:** The exact candidate is review-ready, the package is frozen and internally approved, launch operations are tested, and no unresolved mismatch remains. Submission is reserved for Phase 19.
- **Mobile implications:** Final exact iOS archive and claims freeze.
- **Documentation:** Completed release checklist/runbook, store metadata/assets index, privacy/legal/export/accessibility records, review notes, support/emergency plan.
- **Complexity:** Large.
- **Blocks later work:** Yes; release candidate/launch.

### Phase 19 — Release Candidate

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Freeze, reproduce, validate, submit, and obtain approval for the exact 1.0.0 archive through the complete release-blocker and App Review loop.
- **Player-facing outcome:** Final build contains the complete stable game with no known critical/major release blocker.
- **Technical outcome:** Tagged source, reproducible archive/provenance, retained symbols/manifest, full automation/human/device/save/store evidence, bounded accepted P2 list.
- **Included:** Clean build; full campaign/Expedition; install/update/offline; performance/soak; 1,000 faults; accessibility/localization; metadata/archive agreement; emergency patch drill.
- **Excluded:** New systems/content/polish bundle; only reviewed blocker fixes create a new RC.
- **Dependencies:** Phase 18; internally approved review-ready checklist, package, and candidate.
- **Major tasks:** Freeze RC1; run entire suite; triage; smallest blocker fixes; RC2+ as needed; select exact archive; submit; resolve App Review feedback with a new fully tested RC when required; obtain approval; run launch-readiness review.
- **Recommended order:** Freeze -> automation/content -> desktop human -> device/TestFlight -> save/lifecycle -> store/compliance audit -> fix/repeat -> signoff.
- **Risks:** Late fix destabilizes; archive differs from tested build; save update defect; accepted P2 hides systemic issue.
- **Risk reduction:** New RC for every code/content change; tag/manifest/hash; full focused+blocker regression; frequency-based severity; no direct archive edit.
- **Required prototypes:** None.
- **Tools/infrastructure:** Frozen branch/tag, CI/release host, artifact repository, device matrix, App Store Connect, launch checklist/war room.
- **Desktop test plan:** Full blocker suite and campaign on exported reference build; compare to iOS behavior.
- **Performance targets:** All desktop/iOS targets; >=99.8% crash-free; zero data loss; package/launch/resume budgets.
- **Acceptance criteria:** Zero P0/P1; all required evidence; exact selected archive/metadata/declarations agree; support/emergency staffed; approval available.
- **Definition of done:** Release authority signs off the exact approved `1.0.0` archive and manual-release plan. Public launch and immediate stabilization remain required in Phases 20-21.
- **Mobile implications:** This is the final mobile build; any change reopens relevant device/compliance gates.
- **Documentation:** RC report, manifest/hash/symbols, accepted issues, signoff, launch schedule, emergency baseline.
- **Complexity:** Large.
- **Blocks later work:** Yes; final launch gate.

### Phase 20 — 1.0.0 Launch

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Release manually during a staffed window, verify public install/product page/core loop, and begin active monitoring/support.
- **Player-facing outcome:** Keep Driving 1.0.0 is purchasable, installable, offline-playable, supported, and accurately represented.
- **Technical outcome:** Public build/store state recorded; live install and core loop verified; crash/save/support monitoring active; emergency path ready.
- **Included:** Manual release; minimum/mid/current fresh install; product page/price/territory/links; first launch/offline/save; support; metrics/triage.
- **Excluded:** New features, live tuning without a build, celebratory changes to production systems.
- **Dependencies:** Phase 19 approval/signoff.
- **Major tasks:** Final preflight; release; store/install verification; core smoke; monitor; triage; communicate known issues; decide patch need.
- **Recommended order:** Staff/support ready -> preflight -> release -> store propagation -> install/smoke -> monitor/respond -> status report.
- **Risks:** Store configuration/propagation, unobserved device/save crash, support overload, rushed patch.
- **Risk reduction:** Manual staffed window; three-device live smoke; retained RC; severity policy; evidence before patch; support scripts.
- **Required prototypes:** None.
- **Tools/infrastructure:** App Store Connect, physical devices, support inbox/site, crash/hang diagnostics, release log, emergency branch/pipeline.
- **Desktop test plan:** Desktop reference remains available to reproduce shared defects.
- **Performance targets:** Public crash-free remains >=99.8%; zero confirmed data-loss cluster; no regression from RC.
- **Acceptance criteria:** Store page/install/core flow/offline/save/support verified; monitoring healthy; no uncontrolled P0/P1.
- **Definition of done:** Public launch recorded and stabilization phase owns all live issues.
- **Mobile implications:** Live supported matrix and declarations become binding promises.
- **Documentation:** Launch log, live verification, support/issue dashboard, first-day report.
- **Complexity:** Medium.
- **Blocks later work:** Yes; stabilization follows, not feature expansion.

### Phase 21 — Immediate Post-Launch Stabilization

- **Status:** Not started; blocked by dependencies below.

- **Objective:** Stabilize real-world crashes, saves, progression, performance, device, review/support, and compliance issues before expansion.
- **Player-facing outcome:** Fast transparent fixes for severe defects without destabilizing saves or adding unrelated scope.
- **Technical outcome:** Verified 1.0.1 path if needed, updated fixtures/metrics/support knowledge, retrospective and rebaselined roadmap.
- **Included:** Daily first-week triage; P0/P1 fixes; severe balance/accessibility/device corrections; update/save compatibility; App Store declaration changes; retrospective.
- **Excluded:** New region/chassis/activity/system; broad refactor; post-1.0 feature bundle.
- **Dependencies:** Phase 20.
- **Major tasks:** Monitor/cluster; reproduce; protect diagnostics/saves; patch smallest safe fix; full blocker regression; submit/release; measure; close stabilization; retrospective.
- **Recommended order:** Save/crash/progression/security -> device/perf -> accessibility/support -> severe balance -> cosmetic; evidence before change.
- **Risks:** Panic patch, save schema incompatibility, metrics/privacy mismatch, scope creep.
- **Risk reduction:** Severity policy; release-tag branch; no destructive reset; exact update fixtures; new privacy/review audit for SDK/capability changes.
- **Required prototypes:** None.
- **Tools/infrastructure:** Crash/support triage, emergency pipeline, retained 1.0.0 archive/symbols, update/migration matrix, App Store Connect.
- **Desktop test plan:** Shared regression plus reproduction; full blocker suite for patch.
- **Performance targets:** >=99.8% crash-free or improving to target; zero unresolved data-loss/P0/P1; patch retains device budgets.
- **Acceptance criteria:** Live P0/P1 closed; saves/update safe; support volume/metrics stable; accepted issues owned; no compliance mismatch.
- **Definition of done:** Stabilization review approves move to planned post-1.0 work and publishes lessons/roadmap changes.
- **Mobile implications:** Actual device data refines budgets/support floor; no silent support drop.
- **Documentation:** 1.0.1 notes/evidence if used, incident records, support FAQ, stabilization report, retrospective, updated decisions/roadmap.
- **Complexity:** Medium.
- **Blocks later work:** Yes; expansion waits for stabilization signoff.

## 6. Critical path

### Release-blocking sequence

```text
Audit -> Vision -> Desktop Handling/Hero Truth Slice
  -> Cleared Public Title + Release Identity -> Signed Export Feasibility
  -> Remaining Risk Prototypes -> Production Truth Slice
  -> World + Vehicle/Parts Foundations
  -> Progression -> Activities/Content Pipeline
  -> Complete UI/Art/Audio/Save/Accessibility
  -> Desktop Alpha -> Content Beta -> Desktop Stabilization
  -> Signed iOS Base -> Touch/UI -> Device Optimization
  -> App Store Preparation + External Release Beta
  -> Release Candidate + Review Approval -> Launch -> Stabilize
```

The formal blocking chain is Phases 0 through 21. A phase may overlap preparation with the prior phase, but it cannot claim acceptance or allow downstream content multiplication until its listed gate passes.

Name clearance or a cleared replacement is an independent release-identity gate. Research and neutral internal/ad-hoc prototype identifiers can proceed early, but no registered production/release App ID, App Store record, logo/icon, public URL, marketing asset, or final public name locks before the written clearance record is archived in `docs/DECISIONS.md`. The decision is due by the end of Phase 2 before the signed iOS feasibility build and is rechecked/frozen at Phase 9.

### Reproducible measurement contracts

- **Desktop regression reference:** MacBookPro18,2, Apple M1 Max (10-core CPU, 32-core GPU), 64 GB RAM, built-in 3456 x 2234 display. Release-like performance runs use a 1920 x 1080 output window with the project's 1280 x 720 logical viewport, GL Compatibility, current exact Godot build, and a clean exported build. Capacity captures run with VSync off; play-feel captures rerun with VSync on. Every artifact records macOS version, engine build, renderer, display/output/logical viewport, VSync, power state, build flavor, commit, scene/seed, asset set, warm-up, duration, p50/p95/p99/worst frame, peak/plateau memory, and raw evidence location. This machine is a comparison reference, not evidence of minimum-device support.
- **Crash-free release beta:** At least 1,000 counted launch-to-background-or-quit sessions over at least 14 consecutive days from at least 50 external participants, spanning every supported device tier. A session is crash-free only when it has no uncaught crash, OS watchdog termination, or unrecovered hang attributable to the build. The gate is `crash-free sessions / counted sessions >= 99.8%`, with zero reproducible save loss and zero P0/P1; unknown/un-symbolicated terminations do not get silently excluded.
- **Primary-arc length:** At desktop content beta, at least 10 new players use clean profiles with no developer shortcuts. Record active play only, excluding pause/background time. Median first primary-arc completion must be 8-12 hours, at least 8/10 must finish within 6-14 hours, and no participant may be blocked by mandatory random grind.
- **Completion/mastery length:** At least five clean-profile players who continue after the primary arc must each reach 90% of tracked authored objectives/landmarks/restorations plus three distinct Expedition mastery goals within 20-30 hours of non-idle active play. Median mastery enjoyment must be >=4/5, and no player may require repeated identical filler to extend or complete that range.

### Greatest-risk systems

1. Fixed-step vehicle feel and collision.
2. Hybrid authored world/bake/streaming under production content.
3. Part/build tradeoff balance and Garage comprehension.
4. Extraction/economy/progression pacing.
5. Content throughput/repetition across three regions.
6. Versioned save, migration, lifecycle, and reward transaction safety.
7. Full-stack desktop-to-iOS performance/memory/thermal/touch behavior.
8. Exact App Store privacy/accessibility/export/archive agreement.
9. Public-name clearance, differentiation, and release-identity lock.

### Prototypes that must happen first

- Production handling/collision lab.
- First road/hero minute with representative art, HUD, real audio, and a route choice.
- 10-15 minute hybrid proof region.
- Twelve-part/four-slot buildcraft sandbox and benchmark matrix.
- Versioned save/v0 migration/interruption recovery spike.
- Representative full-stack performance scene.

One bounded signed-export feasibility check happens in Phase 2 after the accepted desktop handling/hero slice and the release-identity gate. It proves only Godot -> Xcode -> signing -> physical install/launch; it does not add touch UI, adapt gameplay, tune devices, upload a store record, or begin mobile content work. Formal mobile adaptation still begins in Phase 15 after the content-complete desktop stability gate.

### Work that can safely occur in parallel

- After handling/world/catalog interfaces stabilize, UI component/theming and real audio asset/event work may proceed in parallel with deeper runtime implementation.
- Once one region/content family is complete and its authoring pipeline passes, separate region/content batches may proceed in parallel with independent stable-ID claims and central validation.
- Art and audio production can parallelize by approved asset lists after style/technical budgets and source/license workflow lock.
- App Store metadata/privacy/support drafting and first-party requirement refresh can proceed before RC, but final declarations/assets must wait for the exact archive.
- Device testing can parallelize across assigned hardware after each shared build is frozen.

Unsafe parallel work:

- Multiple agents changing authoritative vehicle physics, save schema, catalog ID rules, world bake format, or economy transactions concurrently without a single owner/integration gate.
- Mass part/contract/world content before its schema/tools/reference example pass.
- Mobile layout/gameplay forks while desktop facts are changing.
- Store declarations before final SDK/capability inventory.

### Work intentionally deferred

#### Valuable if capacity allows

- Fourth chassis and 8-12 extra parts.
- Photo mode/shareable run card.
- Native iPad experience.
- Game Center achievements and optional iCloud saves.
- Alternate touch/tilt scheme.
- Extra launch localization and mastery/cosmetic content.

These may enter only after all Required content/quality gates and must not endanger RC.

#### Post-1.0 expansion

- New region/restoration arc/landmarks.
- New chassis/part mechanics.
- Larger authored narrative expansion.
- Expanded Expedition rules.
- Asynchronous ghosts/leaderboards after privacy/service/cheating review.
- Multiplayer/co-op as a separately funded architecture effort.
- Mod support after platform/content-pipeline review.

## 7. First executable milestone

### Desktop Truth Slice A — Production Handling and the First Road

#### Exact objective

Produce a desktop-only, 90-second-to-three-minute playable slice that proves the replacement vehicle/collision path and the first-minute product promise together: start in the Garage lot, learn controls through motion, enter one authored road fork, feel road/dirt/mud differences, collide with readable light/medium barriers, see one landmark/reward signal, hear real engine/surface/impact/UI audio, and return or stop at a clear endpoint.

This is the first bounded implementation milestone inside Phase 2. It answers whether Keep Driving's production car and presentation direction deserve further world/content investment.

#### Included work

- Characterize current public vehicle/camera behavior and preserve the still-useful feel vocabulary.
- Normalized `DriveIntent` with keyboard and controller sources plus automated source.
- Fixed-step 60 Hz production-candidate vehicle on a robust 2D collision body.
- Rolling drag, braking/reverse, speed-sensitive steering, lateral slip, handbrake, road/dirt/mud forces.
- Swept/high-speed impact handling, contact hysteresis/rate-limited damage, light/medium/heavy response.
- Dedicated camera rig with look-ahead/zoom/reduced shake.
- One authored Garage lot and one short forked road with landmark, shortcut/surface contrast, reward cue, and safe endpoint.
- Minimal production HUD facts: Fuel, Integrity, objective direction; no debug dashboard.
- Real audio buses/assets for engine, at least three surfaces, light/heavy impact, reward, warning, and UI confirm.
- Representative hero car/road/terrain/hazard treatment sufficient to judge direction.
- Prototype-only macOS export preset and repeatable clean release build; this does not establish general desktop distribution or production CI.
- Benchmark telemetry, automated regression, rendered capture, and human test script.

#### Explicitly excluded

- Full hybrid region/streamer replacement.
- Final world generation, threats/AI, activity system, campaign, extraction economy, Garage inventory, 36-part catalog.
- Final art quantity, music score, settings suite, save migration, mobile/touch/iOS export.
- Refactoring unrelated prototype systems.

#### Task sequence

1. Record baseline proof output and current handling constants/behavior.
2. Add a dedicated prototype ticket/report, isolated test scene(s), and minimal prototype-only macOS release export preset/build; keep current main loop launchable.
3. Define `DriveIntent`, keyboard/controller/automated adapters, and contract tests.
4. Implement fixed-step vehicle with road surface and rolling/brake/reverse behavior.
5. Add steering/slip/handbrake and 30/60/120 render-rate benchmark replay.
6. Add collision shapes, swept contact, weight response, damage transition/cooldown, and stuck recovery.
7. Add camera rig and reduced-motion controls needed for the slice.
8. Author Garage lot plus first fork/landmark/surface route; add deterministic reset/teleport debug anchors.
9. Add real audio buses/resources/state routing and audible capture proof.
10. Add minimal hero HUD/onboarding and representative visual treatment.
11. Export a clean macOS release build; run automated regression, 1,800-second feel/VSync-on and capacity/VSync-off rendered performance captures, and five-player handling/hero-minute sessions.
12. Record keep/change/abandon decisions; either graduate the selected path into Phase 3 or revise before proceeding.

#### Expected playable result

A player launches a separate desktop slice, starts moving within ten seconds, learns drive/brake/steer/handbrake through use, feels clear surface and collision differences, understands Fuel/Integrity/immediate destination, makes one route/reward choice, and reaches the endpoint without seeing debug vocabulary or silent placeholder feedback.

#### Desktop test procedure

1. Run existing core and simulation proofs before/after to ensure the current main loop remains playable.
2. Run new `DriveIntent`, vehicle, surface, collision, damage, camera, and real-audio resource/state tests.
3. Replay the same intent trace at 30/60/120 render rates against 60 Hz physics and compare outcome tolerances.
4. Run high-speed light/medium/heavy and repeated-contact cases; assert no tunneling/overlap spam.
5. Run a 30-minute release-like automated/rendered loop; record p50/p95/p99, worst hitch, world work, nodes/collision queries, effects/audio voices, and memory.
6. Capture the first 60 seconds with player HUD only.
7. Conduct five new-player sessions using the handling and hero-minute scripts in `PLAYTEST_PLAN.md`.
8. Rerun after fixes; do not average a failed critical behavior into a pass.

#### Acceptance criteria

- Fixed-step motion remains behaviorally stable across 30/60/120 render rates.
- No collision tunneling, repeated full-damage overlap, stationary steering rotation, stuck intent, or instant surface speed clamp.
- Road/dirt/mud and obstacle weights are correctly identified by at least four of five players.
- All five players drive, reverse, use handbrake, and recover without moderator takeover.
- Median handling satisfaction >=4/5.
- Four of five move within ten seconds and identify objective plus Fuel/Integrity within 30 seconds.
- Four of five understand the first route/reward choice within 60 seconds.
- Real engine/surface/impact/reward/warning/UI audio is audible, routed, mix-controlled, and has visual equivalents.
- Release-like slice holds 60 FPS, p95 <=16.7 ms, p99 <=25 ms, and no hitch >50 ms on the desktop reference.
- Existing main project remains launchable and its retained proof floor passes.

#### Definition of done

- Code/art/audio is clearly marked prototype or graduated production candidate.
- Automated, rendered, performance, and human evidence is retained with build/commit.
- `docs/DECISIONS.md`, architecture, game design, UX direction, and roadmap reflect what was learned.
- One collision/vehicle approach and one first-minute presentation direction are selected or explicitly rejected.
- No open P0/P1 in the slice; any P2 has owner and does not invalidate the question.
- Work is committed as a bounded slice. Only then begin the broader proof region/buildcraft/save prototypes.

## 8. Documentation changes

| Document | Purpose |
|---|---|
| `docs/PRODUCT_VISION.md` | Identity, fantasy, audience, pillars, loops, journey, launch scope, non-goals |
| `docs/CURRENT_STATE_AUDIT.md` | Repository/runtime proof, gaps, retain/refactor/replace, unknowns and risks |
| `docs/GAME_DESIGN.md` | World, handling, chassis/parts, progression/economy, activities, rewards, replay/endgame |
| `docs/UX_AND_ART_DIRECTION.md` | Information architecture, onboarding, HUD/map/Garage, responsive/accessibility, art/audio/VFX/haptics |
| `docs/TECHNICAL_ARCHITECTURE.md` | Target modules/data flow, input/save/world/content/test/debug/build/performance architecture |
| `docs/ROADMAP_TO_1.0.md` | Executive synthesis, 22 phases, critical path, first milestone, assumptions/status |
| `docs/MOBILE_PORTING_PLAN.md` | Desktop entry gate, shared/adapted architecture, touch/UI/lifecycle/device/TestFlight plan |
| `docs/APP_STORE_RELEASE_CHECKLIST.md` | Identity, build, metadata/assets, privacy/legal/export/accessibility/TestFlight/review/launch/patch gates |
| `docs/PLAYTEST_PLAN.md` | Evidence classes, structured cohorts/tasks/questions/metrics, device/regression/severity/release blockers |
| `docs/DECISIONS.md` | Durable major product/architecture decisions, alternatives, tradeoffs, validation |
| `docs/research/APP_STORE_REQUIREMENTS.md` | 2026-07-11 first-party Apple/Godot requirement snapshot and volatile recheck list |
| `docs/research/NAME_CLEARANCE_RISK.md` | Exact-title collision evidence and mandatory qualified clearance-or-rename gate |
| `.scratch/keep-driving-1-0/` | Canonical Wayfinder map and decision/execution frontier |

All documents are living contracts. A changed decision updates the owning document and appends/supersedes a decision log entry; downstream acceptance gates are re-evaluated.

## 9. Open questions and assumptions

The user directed the roadmap to proceed without questions. These assumptions permit execution but carry explicit validation.

| Uncertainty | Assumption in use | Risk | Validation timing |
|---|---|---|---|
| Team/capacity | Small independent team/agent-driven production; scope optimized for reusable content tools | Content/art/audio throughput may be lower than target | Measure one full region and reference content tranche before multiplying; reforecast at alpha |
| Final asset sourcing | Cohesive owned/licensed custom 2D/audio mix; no unreviewed asset-pack collage | Cost, license, or style mismatch | Hero minute then one-region production throughput/license audit |
| Product price | Premium one-time purchase; exact regional price unresolved | Store conversion/value mismatch | Current market/pricing research and store-page test before App Store record finalization |
| Public product name | `Keep Driving` is an internal working title only; use it publicly only if qualified written clearance passes, otherwise select and clear a distinctive replacement | Legal/confusion/discoverability and expensive rebrand risk | Resolve before bundle ID, App Store record, logo/icon, public URLs, marketing, or broad final-art naming lock |
| Publisher/bundle/support domain | Bundle ID, Team ID, publisher entity, and support/privacy URLs unresolved pending cleared public title and publisher identity | Immutable ID/legal/launch blocker | Resolve before App ID/App Store record/upload |
| Apple membership/signing | Access will exist for the Phase 2 export-only feasibility gate and remain valid at Phase 15 | Signed export/TestFlight could block | Audit account/certificates after desktop truth-slice acceptance and recheck at Phase 15 entry |
| Physical devices | One physical iPhone can be obtained for Phase 2 signing/launch; minimum/small/mid/large/current tiers can be obtained for mobile adaptation | Device gaps hide exporter, perf, layout, or lifecycle defects | Obtain one before the Phase 2 signed gate and the full matrix before Phase 15; do not substitute simulator |
| Playtest recruitment | A coordinator can recruit five genuinely new handling/hero-minute players before Slice A acceptance, 20-30 desktop beta players, and at least 50 external iOS testers; consent, privacy-minimal records, scheduling, and any incentive budget are owned | Missing people can block feel/comprehension/reliability gates; agents or implementers cannot substitute for naïve players | Confirm coordinator, cohort criteria, dates, consent, devices, and incentive budget before each candidate freezes; recruit Slice A cohort before presentation lock |
| Minimum iOS | Provisional iOS 17.0, A12/3 GB floor | Optimization burden or OS adoption may make floor wrong | Signed slice and market/OS recheck; lock before external TestFlight |
| Native iPad | Not Required; iPhone-only native 1.0 | Missed market; compatibility expectations | Promote only if native layout/device/store-asset capacity exists before beta |
| Game Center/cloud | Valuable, not Required; disabled by default | Feature value versus entitlement/privacy/sync risk | Separate decision after local save/device stability; omit if any gate is incomplete |
| Analytics/crash SDK | No ads/tracking; default privacy-minimal/no third-party SDK | Less product telemetry/support insight | Adapter bake-off after alpha; add only with exact benefit/privacy/manifest/symbolication proof |
| Localization | English required; architecture/pseudoloc ready; extra launch languages capacity-dependent | Store reach/QA cost | Copy lock and localization production forecast before beta |
| Age rating | Final rating determined by live questionnaire for exact stylized Zombie violence | Rating/marketing mismatch | Complete questionnaire with final content before external TestFlight/RC |
| Content counts | Numeric floors are achievable without filler | Quality or schedule pressure may require scope change | Throughput/density/repetition evidence; change only through recorded decision |
| Recovery tuning | Failure keeps 25% loose Scrap and one secured item | Too punitive/generous or exploitable | Three-run and hour economy prototype before progression lock |
| Godot 4.7 | Retain exact version until evidence requires upgrade | Xcode/iOS exporter incompatibility/security/fix need | Signed Phase 15 export and each Apple SDK requirement recheck |
| Story/narrative | Environmental/light objective framing; no dialogue-heavy RPG | World may feel emotionally thin | Proof-region/player recall and alpha feedback; add authored fragments without new system if needed |

Noncritical uncertainty must not stop Phase 2. A failed validation changes the relevant decision/roadmap before content multiplication.

## 10. Final status report — planning cycle

### Work completed

- Read the attached 920-line goal objective and required Wayfinder skill.
- Created/claimed the canonical Keep Driving 1.0 Wayfinder audit frontier.
- Inspected all tracked runtime/test/proof files, prior v0/Real Vertical Slice maps, current history, and visible desktop build.
- Reran the current proof floor.
- Researched current Apple/Godot release requirements through first-party sources.
- Defined the finished product, systems, experience, architecture, mobile, release, playtest, scope, decisions, and 22-phase execution route.
- Built an isolated fixed-step handling truth-slice prototype with normalized keyboard/controller/simulated intent, road/dirt/mud behavior, collision damage/recovery, authored fork, minimal HUD, and generated audible feedback resources.
- Recorded the exact-title collision as a formal clearance-or-rename release gate.

### Files created

- The ten required documentation files listed in Section 8.
- `docs/research/APP_STORE_REQUIREMENTS.md`.
- `docs/research/NAME_CLEARANCE_RISK.md`.
- `prototypes/handling_truth_slice/` with its isolated scene, smoke harness, notes, and run instructions.
- `export_presets.cfg` with a prototype-only ad-hoc macOS export; it does not export the shipping scene.
- `proofs/handling_truth_slice_relay.jpeg`, retained from visible inspection.
- `.scratch/keep-driving-1-0/map.md` and eight child tickets.

### Files modified

- No existing main gameplay/runtime scripts. `project.godot` adds only the prototype feature override and export texture compatibility; prototype work remains isolated from the shipping scene.
- `prototypes/handling_truth_slice/prototype_audio.gd` extends the previously committed audio helper for the integrated truth slice.
- Existing v0 and Real Vertical Slice trackers remain preserved as history/subordinate milestones.

### Playable build status

- Current v0 debug build launches and the end-to-end prototype loop remains playable.
- It is effectively silent and visibly prototype-grade; it is not desktop alpha or mobile/App Store ready.
- The separate handling truth slice launches and is mechanically testable; it is not accepted until the remaining rendered, audible, controller, performance, and human evidence passes.

### Tests performed and results

- Godot version: `4.7.stable.official.5b4e0cb0f`.
- Core suite: `ALL_KEEP_DRIVING_PROOFS_PASSED`.
- Automated 600-second loop simulation: all declared cases true, `pass=true`.
- Landscape 896 x 414 simulation: `pass=true`.
- World perf: 10,800 frames, 140.6 FPS, p95 frame 8.734 ms, p95 stream 1.349 ms, 25 active/49 preloaded, 310 entities, zero blank-risk frames, `pass=true`.
- Visible desktop inspection: Start and Run render, but default UI/debug text/block tiles/procedural placeholders confirm presentation gap.
- Handling truth-slice smoke: normalized input, progressive road/dirt/mud speeds, three tunes differentiated across speed/turn/grip/impact resistance, rolling drag, stationary steering, single collision transition, full reset, and Integrity damage pass.
- Handling truth-slice scene: separate headless boot passes and the original main scene/proofs remain launchable.
- Prototype-only clean macOS export from `a8c00766d18aee6b01ccdca689dfa4440a5049af`: embedded clean-commit provenance, universal release app, neutral internal bundle identifier, verified ad-hoc signature, exported-scene launch pass. Short 15-second feel/capacity harness validations pass with `acceptance_pass=false`; exact metrics are recorded in `prototypes/handling_truth_slice/NOTES.md` and `proofs/handling_truth_slice_benchmark_a8c0076.json`. These are not the required clean exported 1,800-second acceptance runs.

### Known defects

- Shipping v0 empty AudioStreamGenerator paths mean no real audio despite counter proof; the isolated truth slice has generated PCM but no human mix verdict.
- Shipping v0 variable-delta manual vehicle/radius contacts and repeated-overlap damage risk.
- Repetitive four-spoke world/flat terrain/no authored place.
- No success/extraction/activity/campaign; all failure banks all Scrap.
- One chassis, nine linear purchases, no real build ecosystem.
- Unversioned non-atomic save and no resume/recovery.
- Default code-built UI; touch displayed in desktop runs; no controller/settings/accessibility/map.
- Only a prototype-specific ad-hoc macOS export exists; no production desktop/CI/iOS/App Store infrastructure.

### Outstanding risks

Vehicle feel human acceptance, hybrid world, build balance, content throughput, extraction economy, save/lifecycle reliability, production full-stack performance, physical iOS/toolchain evidence, and formal public-name clearance.

### Current roadmap phase

Phase 2 — Technical-Risk Prototypes. Phases 0-1 are complete as roadmap phases. Wayfinder decision tickets 02-07 remain open as a one-ticket-per-session audit/index queue; they can correct decisions and block Phase 3/production scale-up, but they do not roll execution back from bounded Phase 2 work.

### Next recommended task

Finish **Desktop Truth Slice A — Production Handling and the First Road**, not evidence alone: replace the demonstrator presentation with representative hero car/road/terrain/hazard assets and a reviewable engine/surface/impact/UI audio direction; prove actual rendered 30/60/120 cadence behavior; then run clean exported 1,800-second feel/capacity benchmarks, retain the first-60-second capture, verify the audible mix and physical controller, and complete five-player handling plus five-naive-player hero-minute sessions. Record keep/change/abandon before the signed export-only gate or hybrid-region prototype; do not begin broad content or mobile migration.
