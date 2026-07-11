# Keep Driving Product and Architecture Decision Log

Status: active; append or supersede, do not silently rewrite settled decisions
Log opened: 2026-07-11

## How to use this log

Each consequential product or architecture choice records context, alternatives, selection, reason, tradeoffs, affected systems, phase, and validation. A later change adds a new entry that supersedes the old one and explains migration impact.

Existing v0 decisions remain historical evidence in `.scratch/keep-driving-v0/` and `docs/adr/0001-use-godot-4-7.md`. These 1.0 decisions deliberately expand or replace v0 scope where the stronger product requires it.

## D001 — Target a premium survival road-trip roguelite

- Date/phase: 2026-07-11, product vision.
- Context: The prototype proves free-roaming survival driving, but has no destinations, extraction, authored progression, or completion arc.
- Options considered:
  - Preserve endless score survival as the entire game.
  - Become a conventional mission/racing game.
  - Build a destination-based survival road-trip roguelite and retain endless survival as endgame.
- Selected option: Destination-based survival road-trip roguelite; Expedition Mode preserves endless outward survival after/alongside late progression.
- Reason: Adds goals, world meaning, risk/return decisions, progression, and completion without moving away from driving and route choice.
- Tradeoffs: Requires authored world/content and more state; risks generic errands if activities are not route/build-centered.
- Systems affected: Product, world, activities, progression, Results, save, UI, content.
- Validation: First-hour and full-campaign playtests; players can explain depart -> risk -> return -> upgrade and still identify driving/routes as the core.

## D002 — Use an authored macro world with deterministic systemic population

- Date/phase: 2026-07-11, world design.
- Context: Current `WorldGenerator` determinism/streaming is strong, but every chunk is a repetitive four-spoke hub and cannot create recognizable places.
- Options considered:
  - Continue fully procedural infinite generation.
  - Build a fully handcrafted static map.
  - Hybrid authored roads/landmarks/regions plus seeded events/weather/threats/rewards.
- Selected option: Hybrid authored/systemic county with three connected regions and Expedition Mode for more procedural remix.
- Reason: Supports route memory, sightline design, landmarks, content pacing, and replay variation together.
- Tradeoffs: Higher authoring/bake cost than pure noise; finite content can feel exhausted; systemic sockets need careful repetition controls.
- Systems affected: World tools, streaming, content bake, encounters, navigation, save IDs, performance.
- Validation: 10-15 minute proof region with two routes, shortcut, three landmarks, crossing, dynamic event, 30-45 second decision density, repeat-player route-memory test.

## D003 — Make extraction and safe return distinct from failure

- Date/phase: 2026-07-11, progression/economy.
- Context: Current death banks all Scrap and every run ends by failure, eliminating meaningful return risk.
- Options considered:
  - Bank everything on failure.
  - Lose all run progress on failure.
  - Secure knowledge/milestones, risk material haul, permit voluntary safehouse/Garage extraction, and grant partial failure recovery.
- Selected option: Installed/owned gear and permanent knowledge never drop; extracted haul banks fully; failure keeps milestones/blueprints, 25% loose Scrap, and one secured cargo item, subject to prototype tuning.
- Reason: Creates a clear push/return decision without deleting hours or encouraging intentional failure.
- Tradeoffs: More UI/save/economy state; exact recovery can feel too harsh or too generous.
- Systems affected: ExpeditionSession, cargo, economy, Results, save/resume, UI.
- Validation: Three-run economy test; return and push are both rational, intentional failure/farming is suboptimal, consequence is correctly predicted by at least 80% of players.

## D004 — Preserve Arcade-Real feel, replace movement/collision substrate

- Date/phase: 2026-07-11, technical-risk prototypes.
- Context: Current `Node2D` manual motion demonstrates useful tuning but has variable-delta behavior, radius-only contacts, overlap damage, tunneling risk, no analog controller, and no rolling drag.
- Options considered:
  - Keep current motion and patch contacts.
  - Use full rigid-body vehicle simulation.
  - Fixed-step custom arcade controller on robust 2D collision body.
- Selected option: Fixed-step 60 Hz custom Arcade-Real controller using normalized analog intent and real/swept collision queries.
- Reason: Keeps accessible authored feel and deterministic benchmarks while solving production collision/control risks without simulation complexity.
- Tradeoffs: Requires early rewrite and retuning; CharacterBody/custom physics can still need careful high-speed handling.
- Systems affected: Vehicle, collision, camera, input, damage, AI/spatial queries, replays/proofs.
- Validation: Handling lab at 30/60/120 render rates, swept impacts, surfaces, controller, five-player control/recovery criteria.

## D005 — Use catalog-driven named sidegrade parts, not rarity inflation

- Date/phase: 2026-07-11, vehicle ecosystem.
- Context: Current three upgrades x three levels provide no long-term build choice; mission requires deep combinatorial expansion without meaningless inflation.
- Options considered:
  - Large linear stat tree.
  - Random loot rarity/affixes.
  - Named part catalog with six slots, capacity costs, explicit capabilities/tradeoffs, synergies, inventory, and presets.
- Selected option: Three launch chassis, six functional slots, at least 36 named parts, five target archetypes, stable IDs, no primary rarity ladder.
- Reason: Learnable, balanceable, expandable, player-expressive, and honest in UI.
- Tradeoffs: Requires strong compare UI/catalog validation and more deliberate content design; fewer dopamine spikes from random rarity.
- Systems affected: Catalog, vehicle config, inventory, Garage, economy, save, UI, balance tests.
- Validation: 12-part prototype; at least three viable builds, every part has visible consequence/tradeoff, no build dominates all benchmarks, swap under 60 seconds.

## D006 — Keep Scrap as the only spendable currency

- Date/phase: 2026-07-11, economy.
- Context: The target needs parts, blueprints, restoration, and progression but should avoid resource/currency clutter.
- Options considered:
  - Multiple regional/crafting currencies.
  - Scrap only with parts/blueprints/discoveries as owned content/unlocks.
  - No currency, only direct drops.
- Selected option: Scrap is the only spendable currency. Fuel/Integrity are run resources; parts, blueprints, discoveries, and milestones are not currencies.
- Reason: Maintains understandable sources/sinks and lets rewards expand capability/place without extra bars.
- Tradeoffs: Scrap sinks and pacing must remain varied; a single currency is more exposed to farming exploits.
- Systems affected: Economy, rewards, contracts, inventory, restoration, UI, balance.
- Validation: One-hour and full-progression economy simulations/playtests; no dominant farm, grind wall, overflow, or dead sink.

## D007 — Limit launch activities to four route-centered families

- Date/phase: 2026-07-11, content strategy.
- Context: Broad activity wishlists can dilute the driving identity and exceed content/AI capacity.
- Options considered:
  - Many generic open-world mission types.
  - Survival drive only.
  - Salvage/recovery, risky delivery, route restoration, and route mastery, plus modular dynamic encounters.
- Selected option: Four families above; exclude AI racing, escort, on-foot puzzles/combat, and daily chores for 1.0.
- Reason: Each family changes route, cargo, build, or risk while sharing core systems.
- Tradeoffs: Less genre breadth; repetition risk must be solved through route/cargo/weather/encounter variation.
- Systems affected: ActivityService, world sockets, contracts, rewards, content pipeline, UI.
- Validation: Content-complete beta repetition review; players identify meaningful differences and no family feels like a detached minigame.

## D008 — Evolve the visual identity into Sun-Bleached Survival Road Atlas

- Date/phase: 2026-07-11, UX/art direction.
- Context: High-contrast readability is worth retaining, but flat generated colors/default UI/procedural shapes are not launch-quality or distinctive.
- Options considered:
  - Pixel art.
  - Photoreal/asset-pack realism.
  - Inked illustrated road-atlas world with restrained texture and rugged navigation-card UI.
- Selected option: Sun-Bleached Survival Road Atlas.
- Reason: Fits top-down navigation, supports mobile silhouette/readability, differentiates the game, and is feasible with 2D atlases/authoring.
- Tradeoffs: Requires custom cohesive asset pipeline; atlas metaphor can become flat or overly UI-like without animation/lighting/audio.
- Systems affected: Art, world bake, UI Theme, iconography, VFX, marketing, performance.
- Validation: Hero-minute art/audio slice, phone-scale recognition, screenshot test, mobile representative asset/memory spike.

## D009 — Refactor into explicit deep modules without a flag-day rewrite

- Date/phase: 2026-07-11, architecture.
- Context: `GameRoot` currently owns nearly every concern; broad production work would multiply coupling and public mutable state.
- Options considered:
  - Continue expanding `GameRoot`.
  - Rewrite the project in one replacement branch.
  - Incremental strangler migration behind AppFlow, session, input, save, catalog, vehicle, world, activity, presentation, and platform boundaries.
- Selected option: Incremental modular migration; each replacement passes characterization/integration/playable proof before old path removal.
- Reason: Keeps a playable build, limits regression surface, and creates ownership needed for parallel content/system work.
- Tradeoffs: Temporary adapters/duplication and migration sequencing; requires discipline to delete superseded paths.
- Systems affected: Entire codebase, tests, build pipeline, docs.
- Validation: Architecture tests/review, no player-facing dependency on `GameRoot` internals/public dictionaries, clean full-stack desktop proof after each migration.

## D010 — Retain Godot 4.7 conditionally

- Date/phase: 2026-07-11, engine/release architecture.
- Context: Current v0 and proofs run on Godot 4.7, which supports the target 2D workflow and iOS export, but no signed iOS archive exists.
- Options considered:
  - Retain 4.7.
  - Upgrade engine immediately.
  - Change engine/framework.
- Selected option: Retain exact Godot 4.7 baseline during truth-slice work; only upgrade on an isolated, evidence-backed migration if required for Xcode/iOS, security, correctness, or material production benefit.
- Reason: Avoids unnecessary engine churn while preserving current proof value.
- Tradeoffs: Xcode/iOS SDK compatibility could force an upgrade later; plugin/export fixes may differ across versions.
- Systems affected: Project, export templates, CI, platform, rendering, save/resource compatibility.
- Validation: First signed iPhone export of the desktop-proven slice and repeated recheck of Godot/Apple requirements.

## D011 — Share game logic across desktop/iOS; adapt behind platform/input/UI layers

- Date/phase: 2026-07-11, mobile strategy.
- Context: Current “mobile” support is one simulated viewport and direct touch-state mutation. A separate mobile game would drift, while direct porting unfinished systems would discover problems late.
- Options considered:
  - Desktop and mobile forks.
  - Mobile-first rewrite now.
  - Desktop-first systems with shared domain and platform adapters; port after desktop gates.
- Selected option: Shared logic plus `DriveIntent`, responsive components, PlatformService, asset quality tiers, and lifecycle/save adapters; iPhone landscape required, native iPad optional.
- Reason: Preserves one design and proof path while treating touch, safe area, lifecycle, performance, and store work seriously.
- Tradeoffs: Shared components need stronger constraints from day one; mobile phase still requires substantial adaptation and device work.
- Systems affected: Input, UI, save, platform, audio/haptics, build, performance, QA.
- Validation: Desktop entry gate, physical multi-touch slice, supported-device/TestFlight matrix, no logic fork.

## D012 — Launch premium, offline-first, and privacy-minimal

- Date/phase: 2026-07-11, business/release.
- Context: Mission prohibits harmful progression/dark patterns and does not require mobile monetization conventions.
- Options considered:
  - Free with ads.
  - Free-to-play/IAP progression.
  - Subscription/live service.
  - One-time premium purchase, with optional paid expansion later.
- Selected option: Premium one-time purchase for 1.0; no ads, launch IAP, tracking, account, or mandatory backend. Final price validated near launch.
- Reason: Aligns incentives with a cohesive offline game, reduces privacy/review/SDK risk, and respects progression design.
- Tradeoffs: Higher purchase barrier and less recurring revenue; requires strong screenshots/reviews/value proposition.
- Systems affected: Product, economy, privacy, App Store, marketing, support, platform services.
- Validation: Market/pricing research near launch, store-page tests, external beta value feedback, privacy archive audit.

## D013 — Replace profile JSON with versioned atomic save and recovery

- Date/phase: 2026-07-11, reliability.
- Context: Current save directly overwrites one unversioned file and silently defaults on many failures.
- Options considered:
  - Add keys to current JSON indefinitely.
  - Use a database.
  - Versioned JSON/binary envelope with immutable snapshot, temp validation, rotating backups, migrations, and stable catalog IDs.
- Selected option: Versioned atomic envelope; settings separate; active expedition checkpoint; v0 migration; two verified backups; cloud-ready identity/conflict metadata without required cloud.
- Reason: Sufficient for this data size, inspectable/debuggable, migration-safe, and far simpler than a database.
- Tradeoffs: Atomic rename/flush behavior must be tested per platform; more fixture/fault code than current adapter.
- Systems affected: SaveService, profile/session, catalog, lifecycle, UI, QA, release.
- Validation: Real v0 fixture, N-2 migrations, 1,000 interrupted writes/lifecycle cycles, corruption recovery, low-storage/device proof.

## D014 — Use evidence layers; code existence is never completion

- Date/phase: 2026-07-11, quality process.
- Context: Current scripts pass, but “manual smoke” is simulation and “audio” proof counts calls to silent generators.
- Options considered:
  - Continue one broad proof script.
  - Manual-only testing.
  - Layered unit/integration/simulation/render/performance/human/device/TestFlight evidence.
- Selected option: Layered evidence with honest names and phase-specific gates.
- Reason: Prevents false confidence and makes design, presentation, performance, save, and platform claims falsifiable.
- Tradeoffs: More test infrastructure and scheduled human/device work; not every proof runs on every edit.
- Systems affected: Tests, CI, docs, roadmap, release.
- Validation: Every phase lists evidence; release has no system accepted solely by counter/internal-state assertion.

## D015 — Set a bounded but extensible launch content floor

- Date/phase: 2026-07-11, scope control.
- Context: Mission asks for extensive playtime and expandable systems without turning 1.0 into an unbounded wishlist.
- Options considered:
  - Ship the smallest vertical slice.
  - Attempt many regions/vehicles/activities before quality.
  - Three regions, 15 landmarks, six safehouses, 24 objectives, 15+ encounter templates, three chassis, six slots, 36 parts, 8-12 hour main arc, 20+ hour completion/mastery target.
- Selected option: The bounded floor above; quality/density gates remain more important than raw count. Fourth chassis, extra parts, photo mode, Game Center/cloud, and native iPad are Valuable if Capacity Allows.
- Reason: Large enough for a real premium 1.0, small enough to organize around reusable content modules.
- Tradeoffs: Still a large increase from the prototype; content quality may force count adjustment through an explicit decision, never silent shrinkage.
- Systems affected: Roadmap, production staffing, content tools, world, activities, art/audio, QA, store value.
- Validation: Content-complete beta, repetition/density review, full first-playthrough and mastery sample, production throughput metrics.

## D016 — Provisional iOS target is iPhone landscape, iOS 17.0

- Date/phase: 2026-07-11, mobile planning.
- Context: A concrete device/deployment plan is needed before UI/content lock, but no physical export has been profiled.
- Options considered:
  - Require latest iOS only.
  - Support a much older OS/device range.
  - Provisional iOS 17.0, A12-class/3 GB performance floor, iPhone landscape; revalidate/raise before external TestFlight if needed.
- Selected option: Provisional iOS 17.0 iPhone-only native target; 30 FPS minimum-device floor, 60 FPS A15+ target; iPad optional only with full native scope.
- Reason: Defines a real test floor while preserving the right to raise it based on full-game evidence and current market/tool requirements.
- Tradeoffs: Older device support increases optimization/QA; raising later reduces addressable users and must happen before public promise.
- Systems affected: Export, UI, performance, assets, device QA, App Store metadata/screenshots.
- Validation: Signed feasibility spike, full content device matrix, market/OS adoption recheck before external TestFlight.
