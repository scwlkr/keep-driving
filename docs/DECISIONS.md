# Keep Driving Product and Architecture Decision Log

Status: active; append or supersede, do not silently rewrite settled decisions
Log opened: 2026-07-11

## How to use this log

Each consequential product or architecture choice records context, alternatives, selection, reason, tradeoffs, affected systems, phase, and validation. A later change adds a new entry that supersedes the old one and explains migration impact.

Existing v0 decisions remain historical evidence in `.scratch/keep-driving-v0/` and `docs/adr/0001-use-godot-4-7.md`. These 1.0 decisions deliberately expand or replace v0 scope where the stronger product requires it.

## D001 — Target a premium survival road-trip roguelite

Status: Destination/extraction choice retained; category wording superseded by D019; Expedition survival is provisional under D020, and D029 supersedes its endless-outward topology wording.

- Date/phase: 2026-07-11, product vision.
- Context: The prototype proves free-roaming survival driving, but has no destinations, extraction, authored progression, or completion arc.
- Options considered:
  - Preserve endless score survival as the entire game.
  - Become a conventional mission/racing game.
  - Build a destination-based survival road-trip roguelite and retain endless survival as endgame.
- Historical selection, topology wording superseded by D029: destination-based survival road-trip roguelite with post-completion Expedition Mode if D020 retains it. The accepted endgame uses open-ended chained survival on the same authored county rather than endless outward topology.
- Reason: Adds goals, world meaning, risk/return decisions, progression, and completion without moving away from driving and route choice.
- Tradeoffs: Requires authored world/content and more state; risks generic errands if activities are not route/build-centered.
- Systems affected: Product, world, activities, progression, Results, save, UI, content.
- Validation: First-hour and full-campaign playtests; players can explain depart -> risk -> return -> upgrade and still identify driving/routes as the core.

## D002 — Use an authored macro world with deterministic systemic population

Status: Hybrid authored/systemic architecture retained and state ownership sharpened by D023; three-region quantity and Expedition Mode are provisional under D020.

- Date/phase: 2026-07-11, world design.
- Context: Current `WorldGenerator` determinism/streaming is strong, but every chunk is a repetitive four-spoke hub and cannot create recognizable places.
- Options considered:
  - Continue fully procedural infinite generation.
  - Build a fully handcrafted static map.
  - Hybrid authored roads/landmarks/regions plus seeded events/weather/threats/rewards.
- Selected option: Hybrid authored/systemic county; the current target uses three connected regions and Expedition Mode for more procedural remix, subject to D020.
- Reason: Supports route memory, sightline design, landmarks, content pacing, and replay variation together.
- Tradeoffs: Higher authoring/bake cost than pure noise; finite content can feel exhausted; systemic sockets need careful repetition controls.
- Systems affected: World tools, streaming, content bake, encounters, navigation, save IDs, performance.
- Validation: 10-15 minute proof region with two routes, shortcut, three landmarks, crossing, dynamic event, 30-45 second decision density, repeat-player route-memory test.

## D003 — Make extraction and safe return distinct from failure

Status: Risk/return principle retained; reward security, failure, abandon, and safehouse transaction details superseded by D024.

- Date/phase: 2026-07-11, progression/economy.
- Context: Current death banks all Scrap and every run ends by failure, eliminating meaningful return risk.
- Options considered:
  - Bank everything on failure.
  - Lose all run progress on failure.
  - Secure knowledge/milestones, risk material haul, permit voluntary safehouse/Garage extraction, and grant partial failure recovery.
- Historical selection, superseded by D024: installed/owned gear and permanent knowledge never drop; extracted haul banks fully; failure kept milestones/blueprints, 25% loose Scrap, and one secured cargo item, subject to prototype tuning.
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

Status: Named sidegrade catalog retained and composition/ownership rules sharpened by D025; three-chassis, six-slot, 36-part, and five-archetype quantities are provisional under D020.

- Date/phase: 2026-07-11, vehicle ecosystem.
- Context: Current three upgrades x three levels provide no long-term build choice; mission requires deep combinatorial expansion without meaningless inflation.
- Options considered:
  - Large linear stat tree.
  - Random loot rarity/affixes.
  - Named part catalog with six slots, capacity costs, explicit capabilities/tradeoffs, synergies, inventory, and presets.
- Selected option: Stable-ID named sidegrades with no primary rarity ladder; the current target is three launch chassis, six functional slots, at least 36 named parts, and five archetypes, subject to D020.
- Reason: Learnable, balanceable, expandable, player-expressive, and honest in UI.
- Tradeoffs: Requires strong compare UI/catalog validation and more deliberate content design; fewer dopamine spikes from random rarity.
- Systems affected: Catalog, vehicle config, inventory, Garage, economy, save, UI, balance tests.
- Validation: 12-part prototype; at least three viable builds, every part has visible consequence/tradeoff, no build dominates all benchmarks, swap under 60 seconds.

## D006 — Keep Scrap as the only spendable currency

Status: One-currency choice retained; restoration, servicing, progression, and anti-farm rules sharpened by D027.

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

Status: Route-centered activity principle retained; D026 supersedes the four-family classification with three core state machines plus a Mastery overlay.

- Date/phase: 2026-07-11, content strategy.
- Context: Broad activity wishlists can dilute the driving identity and exceed content/AI capacity.
- Options considered:
  - Many generic open-world mission types.
  - Survival drive only.
  - Salvage/recovery, risky delivery, route restoration, and route mastery, plus modular dynamic encounters.
- Historical selection, superseded in classification by D026: use the route-centered set described above and exclude AI racing, escort, on-foot puzzles/combat, and daily chores for 1.0.
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

Status: Incremental strangler/no-flag-day rule retained; D035-D036 supersede the earlier public-module list and data-flow shape.

- Date/phase: 2026-07-11, architecture.
- Context: `GameRoot` currently owns nearly every concern; broad production work would multiply coupling and public mutable state.
- Options considered:
  - Continue expanding `GameRoot`.
  - Rewrite the project in one replacement branch.
  - Incremental strangler migration behind explicit gameplay Interfaces and platform Seams.
- Selected option: Incremental modular migration; each replacement passes characterization/integration/playable proof before old path removal.
- Reason: Keeps a playable build, limits regression surface, and creates ownership needed for parallel content/system work.
- Tradeoffs: Temporary adapters/duplication and migration sequencing; requires discipline to delete superseded paths.
- Systems affected: Entire codebase, tests, build pipeline, docs.
- Validation: Architecture tests/review, no player-facing dependency on `GameRoot` internals/public dictionaries, clean full-stack desktop proof after each migration.

## D010 — Retain Godot 4.7 conditionally

Status: Retained and sharpened by D040, which owns the GDScript/Compatibility and stable Apple toolchain policy.

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
- Validation: One bounded signed-export feasibility check after the accepted desktop handling/hero slice, then reproduction against the content-complete stabilized build in Phase 15, plus repeated Godot/Apple requirement checks. The early check may not begin gameplay/UI adaptation.

## D011 — Share game logic across desktop/iOS; adapt behind platform/input/UI layers

Status: Shared-gameplay/desktop-first/iPhone-landscape rule retained; D035 and D038 supersede `PlatformService` with the five deep Modules and narrow per-consumer Adapters.

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

Status: Superseded by D022, which completes the monetization alternatives and diagnostics/privacy scope.

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

Status: Versioned envelope, migration, separate settings, and active resume retained; D039 supersedes primary/rotating backups and atomic-rename reliance with alternating verified slots and durability-gated transactions.

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

Status: Raw quantity and duration locks superseded by D020; the counts/ranges remain provisional production targets, and D026 supersedes the fungible objective count with separate content-category ledgers.

- Date/phase: 2026-07-11, scope control.
- Context: Mission asks for extensive playtime and expandable systems without turning 1.0 into an unbounded wishlist.
- Options considered:
  - Ship the smallest vertical slice.
  - Attempt many regions/vehicles/activities before quality.
  - Three regions, 15 landmarks, six safehouses, 24 objectives, 15+ encounter templates, three chassis, six slots, 36 parts, 8-12 hour main arc, 20+ hour completion/mastery target.
- Selected option: The bounded target above; quality/density gates remain more important than raw count. Additional chassis/parts beyond the D020-locked Required target, photo mode, Game Center/cloud, and native iPad are Valuable if Capacity Allows.
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
- Validation: Phase-2 export-only feasibility on one physical iPhone, then Phase-15 full-content signed export, supported-device matrix, and market/OS adoption recheck before external TestFlight.

## D017 — Treat Keep Driving as a working title pending formal clearance

Status: Sharpened by D021; public execution now assumes a rename rather than treating it only as fallback.

- Date/phase: 2026-07-11, product/release risk review.
- Context: YCJY Games released a commercially established road-trip/car-customization game named `Keep Driving` in 2025, and its Steam product-page footer states that the name/logo are trademarks and/or registered trademarks. This creates material legal, store-confusion, discoverability, and positioning risk; it is not by itself a legal conclusion about this project.
- Options considered:
  - Lock the same title without clearance.
  - Rename immediately from a rushed internal brainstorm.
  - Keep the repository working title while performing qualified legal/name/competitive clearance and preparing distinctive candidates.
- Selected option: Working title only. Neutral internal and ad-hoc prototype identifiers may continue. Do not register a production/release App ID or store identity or lock public brand assets until formal clearance; rename before those irreversible/expensive steps if clearance is not affirmative.
- Reason: Preserves development continuity while treating a confirmed market/name collision as a release blocker rather than an aesthetic preference.
- Tradeoffs: Delays final logo/icon/store naming and may require terminology/asset updates; early technical prototype labels may remain temporary.
- Systems affected: Product name, bundle ID, store record, logo/icon/launch, URLs, legal, SEO/ASO, marketing, support, localization, credits.
- Validation: Primary-source competitive record, broader trademark/store/domain search, qualified counsel decision in intended territories/classes, approved distinctiveness/confusion review, and documented rename fallback. Archive the clearance-or-rename decision by the end of Phase 2 before any signed iOS feasibility build; recheck and freeze it before Phase 9 public brand lock.

## D018 — Standardize the player-facing vehicle resource as Vehicle Integrity

- Date/phase: 2026-07-11, terminology/runtime migration.
- Context: The v0 runtime/UI call the resource `Vehicle Damage`, but `vehicle_damage_remaining` already starts at its maximum, damage subtracts from it, repair adds to it, and zero ends the run. Its numeric semantics are remaining condition—already Integrity—while its label and symbol names are misleading. The current profile save does not persist run health.
- Options considered:
  - Keep accumulated Vehicle Damage everywhere.
  - Use Damage and Integrity interchangeably.
  - Standardize on remaining Vehicle Integrity; reserve “damage” for an event or amount subtracted from it.
- Selected option: Public and target-domain vocabulary is **Vehicle Integrity**, where full condition is 100% and destruction is 0%. **Damage** is an impact/threat event or nonnegative amount subtracted from Integrity. Existing `vehicle_damage_remaining` runtime values map directly to Integrity with **no inversion**; only labels and target-domain symbol names change.
- Reason: Remaining condition reads consistently beside Fuel, produces direct warnings, and avoids an inverted resource in UI and domain rules.
- Tradeoffs: Runtime adapters/tests must preserve the existing remaining-value semantics while symbols and copy migrate; internal prototype symbols may temporarily retain legacy names behind that adapter. No v0 profile-health migration exists because v0 does not persist this run value.
- Systems affected: Save migration, expedition state, vehicle rules, UI/HUD/Results, telemetry, tests, copy, accessibility narration, docs.
- Validation: Characterization proves full legacy `vehicle_damage_remaining` maps to full Integrity, zero maps to destruction, damage subtracts, and repair adds. Any future checkpoint schema migrates this field by identity, never inversion. Target-domain APIs/public copy contain no ambiguous `Vehicle Damage` resource label; damage-event tests remain explicit.

## D019 — Position the product around route-shaped buildcraft and county restoration

- Date/phase: 2026-07-11, Wayfinder product-identity review.
- Context: The generic “survival road trip” description overlaps YCJY's released *Keep Driving*, while “car + Garage + hostile excursions + upgrades” overlaps *Pacific Drive* and stylized top-down handling alone overlaps rally games. The current target has a stronger differentiator that was not leading the promise.
- Options considered:
  - Lead with road-trip survival and zombie ramming.
  - Become a top-down rally or *Pacific Drive*-like game.
  - Lead with a learnable open county where installed parts change route options, restoration changes the network, direct driving resolves danger, and return secures risk.
- Selected option: Premium, offline-first, single-player top-down survival-driving roguelite where **every road is a build decision**. Title-independent promise: **Build the car. Read the county. Take the risk. Bring it home.** Zombies remain one supporting encounter set, not the headline identity.
- Reason: Makes route knowledge, build choice, direct handling, restoration, and extraction one coherent promise while drawing explicit boundaries from adjacent products.
- Tradeoffs: Requires authored route topology, visible world-state change, build-conditional shortcuts, and strong handling; generic errands, decorative upgrades, or random disposable maps will visibly fail the promise.
- Systems affected: Product, world, vehicle/parts, progression, onboarding, art, audio, store positioning, playtest language.
- Validation: In blind first-minute/store-page tests, at least four of five target players describe route/build/restoration/return without reducing it to the existing *Keep Driving*, “top-down *Pacific Drive*,” rally, or generic zombie driving.

## D020 — Make D015 content counts and duration ranges provisional until measured throughput

- Date/phase: 2026-07-11, Wayfinder launch-scope review; supersedes D015's treatment of raw counts as already locked floors while preserving them as the target.
- Context: The repository has no production asset/content pipeline, so no primary source or current build proves that three regions, 15 landmarks, six safehouses, 24 objectives, 15 encounters, three chassis, and 36 parts can reach quality without filler. Quietly shrinking to today's prototype would also violate the intended extensive, expandable 1.0.
- Options considered:
  - Lock all counts now despite unknown throughput.
  - Preemptively cut to one car, two regions, and 18-24 parts.
  - Keep the ambitious bounded target, measure one production tranche, then lock or explicitly rebaseline counts through a ranked cut ladder.
- Selected option: Replace D015's fungible 24-objective presentation with independent provisional floors: six Restoration Objectives; four Contract Definitions (at least two Delivery/two Recovery); six Delivery Contract Instances; six Recovery Contract Instances; six Mastery Overlays; and 15 Encounter Templates. Keep the 8-12-hour primary and 20-30-hour completion/mastery ranges provisional. Phase 3 must publish `docs/production/SCOPE_LOCK.md` with a dated ship window; separate content-axis ledgers where surplus cannot substitute for a failed floor; original-definition versus marginal-variant person-hours by discipline; contractor/cash/device/tester budgets; repeatable Lowlands evidence; samples/three-point estimates for unique work; separately costed integration/QA/accessibility/localization/legal/release baseline; and a 30% unallocated risk reserve. Every axis, discipline, budget, and critical-path date must pass. If the target fails, apply the Required cut ladder and coherent fallback in `PRODUCT_VISION.md`; if the fallback fails, production scale-up stops until capacity, window, or product changes.
- Reason: Preserves ambition and the product promise while replacing invented capacity confidence with a falsifiable production gate.
- Tradeoffs: Final launch counts and duration ranges remain open longer; the slice must use final-pipeline assets/content; unique work needs explicit costing; rebaselining can affect store value and playtime targets.
- Systems affected: Scope, roadmap, staffing, content tools, world, objectives, encounters, parts, art/audio, localization, QA, pricing.
- Validation: For each discipline, `(repeatable + unique/fixed + integration + QA + accessibility + localization + platform/release) * 1.30 <= confirmed remaining capacity`; total cash/contractor/device/tester budgets and dated critical path also pass; density/repetition/build-diversity tests pass; no unresolved high-cost low-confidence item is assigned zero work.

## D021 — Assume a distinct public name rather than treating rename as fallback

- Date/phase: 2026-07-11, Wayfinder product-position review; sharpens D017.
- Context: The exact-title collision also overlaps road travel, route choice, car customization, procedural variation, and a young-car fantasy. Legal clearance alone would not erase store confusion or discoverability cost.
- Options considered:
  - Keep the title unless counsel forbids it.
  - Rename immediately to an unresearched candidate.
  - Continue internal work under the repository title while public execution assumes a separately cleared distinctive name.
- Selected option: Public planning assumes a rename. Retain `Keep Driving` only if qualified written legal clearance and a documented positioning/search-confusion review both affirm it. Neutral internal/ad-hoc identifiers may continue.
- Reason: Avoids making release identity depend on an unlikely exception while preventing a rushed name from contaminating implementation.
- Tradeoffs: Public brand work remains gated; a later name must carry the route/build/restoration promise without forcing gameplay terminology changes.
- Systems affected: App ID, App Store record, icon/logo, URLs, marketing, support/privacy pages, localization, credits, branded art/audio.
- Validation: Counsel plus store/domain/trademark screening, pronunciation/recall/search tests, and a documented decision before signed iOS feasibility or any production release identity.

## D022 — Ship a complete paid base app and define the privacy boundary

- Date/phase: 2026-07-11, Wayfinder business-model review; supersedes and completes D012.
- Context: Apple defines paid as one upfront payment for all functionality and says it must justify a premium expectation. Ads, F2P progression, cosmetic IAP, subscriptions, and full-game unlock each add incentives or infrastructure that conflict with an unproven offline launch.
- Options considered:
  - Free with ads.
  - F2P progression or cosmetic IAP.
  - Subscription/live service.
  - Free trial with full-game unlock.
  - Paid complete base app; evaluate only substantial post-1.0 expansion later.
- Selected option: One paid 1.0 app with no launch IAP, ads, account, mandatory network, third-party analytics, or cross-app tracking. A substantial non-consumable expansion may be reconsidered only after the promised base game is complete and stable; it may not withhold an ending, launch chassis, or required system.
- Reason: Aligns commercial incentives with a complete campaign, minimizes privacy/App Review surface, and makes progression trustworthy.
- Tradeoffs: Higher download barrier, no launch recurring revenue, and a premium bar for product quality, screenshots, reviews, and value communication.
- Systems affected: Economy, progression, privacy, SDK policy, App Store, pricing, marketing, support, future content.
- Validation: Target-player store-page/value tests, current regional pricing research near launch, exact privacy manifest/data audit, and no gameplay difference when optional privacy-minimal diagnostics are declined.

## D023 — Separate persistent county truth from deterministic expedition variation

- Date/phase: 2026-07-11, Wayfinder gameplay-system review.
- Context: The target depends on learning and restoring one authored county, but the v0 clears run mutations on restart and embeds `run_seed` in marker IDs. If topology, landmarks, or restoration inherit the expedition seed, saves cannot preserve a coherent place.
- Options considered:
  - Regenerate the world and content identity every departure.
  - Persist a complete copy of every generated expedition as county truth.
  - Give authored topology/content seed-independent stable IDs and freeze only conditions/events/rewards into a versioned expedition manifest.
- Selected option: Profile and county state persist independently. Campaign commits one immutable `ExpeditionOfferSet` per epoch. `PrepareDeparture` uses no RNG: it requires the full preferred assist policy plus `SettingsAssistVersion(settings revision, full-policy digest)`, rejects either mismatch, copies the selected plan unchanged, and freezes starting loadout/resources/`AppliedExpeditionAssistPolicy` into manifest/progress/config/domain digest. Back/cancel/reselect/loadout/assist/relaunch cannot reroll the set. A trusted recovered active remains reserved and resumes/settles. Only when no trusted matching active survives and higher-active risk is `POSSIBLE` does Campaign consume the recovered current set. Every lower recovery persists `PendingRecoveryNotice`; bootstrap blocks until durable acknowledgement. `ExpeditionProgress` owns resources, applied policy, retained-delta outbox, activity state, escrow, and mutations.
- Reason: Preserves route memory/restoration while making variation, resume, test reproduction, and content migration deterministic.
- Tradeoffs: Requires explicit state layers, versioned manifests, stable-ID migration, graph validation, and more save fixtures; macro topology cannot be cheaply randomized for variety.
- Systems affected: World, encounters, activities, rewards, save, profile/county state, streaming, debug tools.
- Validation: Same county IDs/restoration survive different seeds; declared overlays differ; 10,000 manifest/graph combinations across locked loadouts have outbound/extraction paths; reload reproduces the same immutable manifest and mutable progress checkpoint.

## D024 — Resolve expedition escrow exactly once at explicit boundaries

- Date/phase: 2026-07-11, Wayfinder risk/reward review; supersedes D003's 25%-plus-free-item failure detail.
- Context: Automatically preserving blueprints, 25% Scrap, and a chosen item while pause-abort rolls back to safety makes failure/abort a plausible fast-return strategy and leaves reward duplication ambiguous.
- Options considered:
  - Bank all rewards on any terminal result.
  - Keep the prior automatic partial recovery and safe-boundary rollback.
  - Escrow material/capability rewards until extraction, distinguish immediate observation from pending mutations, and make all terminal settlement idempotent.
- Selected option: Route/landmark observations and valid activity/trial cosmetics immediately critical-checkpoint as typed retained deltas in active progress; every terminal outcome transfers their IDs idempotently into Campaign before active removal. They never interleave a Campaign write with Expedition's PROFILE journal. Scrap, parts, blueprints, chassis, cargo, payouts, and restoration mutations are forbidden retained-delta kinds and remain escrowed/pending until extraction. A completed safehouse may establish and close its own extraction boundary. Failure/stranding recovers only `[PLACEHOLDER: 15-20%]` loose Scrap capped at `[PLACEHOLDER: 0.25]` starter-part cost; no free item survives unless installed secure-storage hardware consumed a slot/Build Capacity and the player assigned one eligible intact part/blueprint/cargo item before failure. Chassis, payouts, and mutations are ineligible. Abandon settles like failure; quit/background resumes the immutable manifest plus authoritative verified-slot progress checkpoint. Safehouse banking ends the expedition and Continuing creates a newly serviced manifest.
- Reason: Makes return meaningful, avoids suicide scouting for power, prevents rollback/duplication, and bounds failure pain to the current leg rather than owned progress.
- Tradeoffs: More transaction/save states and UI explanation; pending world mutation can temporarily revert after failure; recovery tuning may still prove too harsh or exploitable.
- Systems affected: ExpeditionSession, rewards, inventory/ownership, objectives, county mutations, Results, save/resume, UI.
- Validation: Fault injection at every transition, including observe/award -> kill/failure/abandon and settlement retry; every retained delta and `resolution_id` commits at most once; at least 80% predict permanent/retained/escrow facts; no fail-fast, abandon, reload, or safehouse-bounce strategy competes with objective extraction per active minute.

## D025 — Compose named sidegrades through visible Build Capacity and route scenarios

- Date/phase: 2026-07-11, Wayfinder vehicle/build review; sharpens D005.
- Context: Slots and part effects were listed without cardinality, capacity semantics, stacking order, ownership, or a strong dominance gate. Physical duplicate copies add inventory cost without value when only one car is active.
- Options considered:
  - Random affixes/copies and inventory limits.
  - One unrestricted best part per slot.
  - Unique named-part ownership, one part per compatible slot, one chassis Build Capacity budget, deterministic stat composition, and scenario-based sidegrade proof.
- Selected option: Stock components keep every chassis roadworthy. Named parts occupy one compatible slot and declared Build Capacity; composition is chassis base -> additive deltas -> bounded multipliers -> clamps -> capability tags/forecast. Own each named part once; presets may reference it; extracted duplicates auto-convert at a disclosed value. There are no hidden sets or arbitrary incompatibilities. Four route-changing roles—quiet/range, offroad/recovery, ram/protection, and cargo/endurance—are the fallback floor; agile drift counts as the provisional fifth only if it changes route choice.
- Reason: Creates combinatorial expression with legible costs while removing copy clutter and preventing linear rarity inflation.
- Tradeoffs: Build Capacity is another concept to teach; deterministic compatibility/stat order needs tooling; a smaller ownership model gives up collection-by-copy behavior.
- Systems affected: Chassis, part catalog, loadout, ownership, presets, Garage, route forecast, rewards, save, balance tools.
- Validation: Early 12-part proof yields three distinct hypotheses; launch proves every D020-locked build. At the same chassis and Build Capacity budget, no obtainable loadout is Pareto-dominant; unlock timing and one-time Scrap price do not excuse dominance. Every required role clears representative primary scenarios, has a material strength/weakness, and players explain capability/cost without hidden math.

## D026 — Build three activity state machines, mastery overlays, and counted content cells

- Date/phase: 2026-07-11, Wayfinder activity/content review; sharpens D007.
- Context: Delivery, recovery, restoration, and mastery were called four families, but mastery is a rule overlay and parameter variants can inflate content counts without creating new decisions. Bespoke mechanics threaten production throughput.
- Options considered:
  - Broad open-world mission catalog.
  - Four independent activity implementations plus unconstrained procedural permutations.
  - Three reusable core state machines with mastery overlays, explicit definition schemas, and a measured landmark-centered production cell.
- Selected option: Delivery plans around a known outbound burden; Recovery acquires a burden and changes the return problem; Restoration creates a one-time pending county/service/topology change. Mastery wraps validated routes/activities with fixed disclosed conditions and may be presented as the provisional fourth category. Dynamic encounters are separate interruptions/detours. Contract Definitions and final-pipeline decision-distinct Contract Instances are counted separately; variants never increase definition/template or instance floors by themselves. `ContractDefinition`, `ContractInstance`, `RestorationObjectiveDefinition`, `EncounterDefinition`, `PartDefinition`, and `LandmarkPackage` declare supported combinations, terminal/resume behavior, budgets, and proof IDs.
- Reason: Keeps activities mechanically distinct while reusing route/cargo/manifest systems and makes D020 throughput/count claims falsifiable.
- Tradeoffs: Less genre breadth; recovery/delivery need strong cargo physics to feel different; restrained combination support sacrifices apparent procedural infinity.
- Systems affected: Activities, content catalog, world sockets, cargo, encounters, rewards, localization, authoring/QA tools, D020 scope ledger.
- Validation: Eight of ten players distinguish the three core decisions; a second author creates a validated data-only variant without runtime code inside budget and `[PLACEHOLDER: <20%]` rework; content counts exclude skins/parameter swaps; repetition/density tests pass.

## D027 — Make restoration objective-driven and Scrap a choice currency, not a tax

- Date/phase: 2026-07-11, Wayfinder progression/economy review; sharpens D006.
- Context: Using the only spendable currency for both parts and required restoration can turn the campaign into a farm or bankruptcy soft-lock. Recurring Fuel/repair charges would make failure compound into inability to play.
- Options considered:
  - Player levels plus multiple crafting currencies.
  - Gate required restoration and servicing with Scrap.
  - Progress through authored restoration/capability milestones; use Scrap for one-time named-part and optional visible service/expression choices.
- Selected option: Required restoration is completed by objectives, never a Scrap toll. Every Garage/restored-safehouse departure provides free baseline Fuel/Integrity. The first successful return grants ownership of the player's choice between two useful starter parts. Milestones provide multiple non-random paths to critical capabilities; first-clear and fixed disclosed repeat payouts replace opaque diminishing returns. Each manifest has a finite reward budget and inherits the namespaced `RewardLedger` plus repetition ledger; kills, reload, failure, offer cancellation, loadout changes, and safehouse Continue/bounce never refresh or reroll value. Scrap saturation after desired ownership is acceptable.
- Reason: Preserves one simple currency and meaningful choices without allowing economy failure to block the core driving loop.
- Tradeoffs: Fewer recurring sinks and less long-tail currency pressure; fixed repeats require careful authored tables; late players may accumulate surplus.
- Systems affected: Milestone graph, economy, rewards, parts, safehouses, activities, Results, simulation, save.
- Validation: Monte Carlo and human runs cover cautious/risky/failure/farm profiles; no random or zero-Scrap soft-lock; first choice in session one; no solved low-risk repeat is required for campaign access; exploit loops stay below the declared risk-adjusted payout threshold.

## D028 — Drive difficulty through forecastable constraints and action-driven Pressure

- Date/phase: 2026-07-11, Wayfinder difficulty/fairness review.
- Context: The v0 derives pressure from distance to the world origin and elapsed time, which fails from remote safehouses and punishes slow/accessibility-assisted players. Unvalidated closures can make objectives impossible.
- Options considered:
  - Scale threats to owned power/player success or wall-clock time.
  - Use static region difficulty only.
  - Forecast route/cargo/condition risk and vary a visible per-expedition Pressure band through explicit noisy/objective actions.
- Selected option: Region, manifest conditions, cargo, optional rules, route, and explicit action-driven Pressure form difficulty. Ship descriptive presets plus Custom with independent assists; exact names/count remain a UX/playtest decision, and players may change them without progress/reward/ending loss. Pressure never scales from player success, owned power, or mere time. A declared assist may visibly reduce an action-triggered Pressure delta but never increase it or alter rewards/ending; timers exist only when disclosed by cargo/mastery. Manifests pre-roll compatible Pressure branches, then checkpoint the chosen runtime branch without new RNG. Selected loadout affects only graph/Fuel legality and forecast, never offer, threat, or reward selection. Manifests graph-validate closures, outbound/extraction path, telegraphs, and capped simultaneous threat budget before departure.
- Reason: Lets players own their risk and build decisions while supporting accessibility and reproducible fairness tests.
- Tradeoffs: Strong forecasting may reduce surprise if over-specific; graph/loadout validation increases generator cost; action-based Pressure needs clear feedback.
- Systems affected: Difficulty, EncounterDirector, manifest generator, route forecast, assists, HUD/audio, testing.
- Validation: At least 80% correctly order compared risks; seed fuzz finds no inaccessible objective/unavoidable lethal event; assists do not reduce campaign rewards; no hidden rubber-banding or passive-idle Pressure exploit.

## D029 — Keep the completed county playable and make Expedition remix conditions, not topology

- Date/phase: 2026-07-11, Wayfinder replay/endgame review.
- Context: D020 may cut separate Expedition Mode, yet campaign replay was undefined for a county whose restoration persists. Remixed route segments would contradict the learnable-place promise.
- Options considered:
  - Reset restoration or add escalating New Game+ power.
  - Generate disposable route topology for endgame.
  - Leave the completed county open for unfinished discoveries, alternate builds, route/activity mastery, records, and fresh manifests; add Expedition only if D020 funds it.
- Selected option: The ending leaves the restored profile playable. Campaign replay means completed-county free roam/contracts/mastery; a full story reset requires an explicit new profile. If retained, Expedition uses the same authored graph and remixes conditions, closures, objectives, encounters, rewards, and Pressure. It grants no exclusive chassis, part, blueprint, or ending.
- Reason: Preserves route knowledge, makes Expedition safely cuttable, and gives post-completion goals without fake infinite power or mandatory reset.
- Tradeoffs: Finite authored mastery can exhaust; same topology raises repetition risk; no exclusive power may reduce compulsion.
- Systems affected: Completion state, contracts, mastery, records, manifests, Expedition, profile selection, content/save migrations.
- Validation: Four of five post-completion players identify and voluntarily begin a non-Scrap goal; alternate-build/condition runs create different route decisions; Expedition, if retained, adds value without being required for completion or ownership.

## D030 — Combine world-first atlas identity, Field Manual structure, and semantic kinetics

- Date/phase: 2026-07-11, Wayfinder experience-direction review.
- Context: D008 selected an illustrated road atlas but did not resolve whether the interface should be spatial/diegetic, card-driven, or spectacle/tactility-driven. The current code-built dashboard is not a production precedent.
- Options considered:
  - Make the county itself the interface with minimal explicit UI.
  - Build the experience entirely from modular roadbook cards.
  - Make physicalized kinetic feedback the dominant language.
  - Combine the strengths behind a strict information and component contract.
- Selected option: Use **Animated Road Atlas + County Field Manual + Semantic Kinetics**. World/car silhouettes, surface, landmarks, cargo, damage, and motion communicate first. A bounded component grammar carries every exact, responsive, and accessible fact. Kinetic visual/audio/camera/haptic feedback appears only at meaningful input, transition, decision, consequence, and settlement moments. Service, Plan, Drive, and Settle are explicit application postures; the world metaphor never removes list/card equivalents, error/recovery facts, or deterministic navigation.
- Reason: Preserves the strongest identity while giving comparison, localization, focus, accessibility, and production reuse a reliable structure and keeping sensory/asset scope bounded.
- Tradeoffs: The hybrid needs discipline to avoid both card clutter and over-diegetic ambiguity; too little motion feels flat while too much causes fatigue; the component ceiling may need evidence-backed revision.
- Systems affected: AppFlow, Presentation, world cues, HUD, Plan, Service, Settle, localization, responsive UI, accessibility, art, marketing.
- Validation: UI gallery stays initially within eight primitives/seven card families/20 components; common flows pass focus/aspect/text/input matrices; four of five hero-minute targets pass; at least 80% explain route/build/settlement facts; world-only failures receive the smallest explicit equivalent rather than a new dashboard.

## D031 — Use one Preflight Card and progressive, playable onboarding

- Date/phase: 2026-07-11, Wayfinder onboarding review.
- Context: Four setup pages plus a 60-90 second lot and first expedition could delay play or duplicate instruction, while no setup would hide high-value accessibility and audio/readability choices.
- Options considered:
  - Multi-page first-run wizard.
  - No first-run setup; defer everything to Settings.
  - One skippable live Preflight Card followed by spatial teaching and progressive HUD disclosure.
- Selected option: Show detected language/input, direct accessibility shortcuts, and a live production brightness/engine/warning check on one skippable card with `Drive now` focused. Teach acceleration, steering, braking/reverse, optional handbrake, surface, harmless impact, landmark, fork, optional signal, and return through uninterrupted play. Reveal Fuel/Integrity/haul only when meaningful. First return settles exact facts and applies one of two useful starter parts across car, compare, forecast, audio, and test-lot behavior.
- Reason: Gets the player moving quickly without concealing the settings most likely to remove first-session barriers.
- Tradeoffs: Progressive disclosure may hide a system too long; the lot/fork must be final-quality enough to teach through world language; one card can become dense if shortcuts multiply.
- Systems affected: First launch, Garage lot, HUD, input detection/glyphs, accessibility/settings, starter reward, Settle, hero-minute content.
- Validation: Four of five move within ten seconds, identify objective/Fuel/Integrity within 30 seconds, and understand the fork/return choice within 60 seconds; 90% drive without help within two minutes; no lethal spawn, required page traversal, or modal interruption.

## D032 — Coordinate presentation from one semantic feedback event

- Date/phase: 2026-07-11, Wayfinder game-feel/audio review.
- Context: Separate ad hoc UI, VFX, camera, audio, and haptic triggers can contradict, double-fire, mask critical cues, and turn counters or generated tones into false production proof.
- Options considered:
  - Let each gameplay/presentation system trigger its own effects.
  - Centralize all presentation around raw per-frame telemetry.
  - Emit bounded semantic events and let directors map them to available channels.
- Selected option: Gameplay emits deduplicated semantic events with phase, priority, magnitude, direction, cause, and cooldown identity. Feedback/Audio directors map each event to visual, camera, audio, and optional haptic output using settings, capability, visibility, and budgets. Continuous simulation drives continuous vehicle/audio state without event spam. Critical channels reserve capacity and may briefly duck masking buses. Haptics are discrete, optional, rate-limited, paired with another cue, and never run in background.
- Reason: One source of truth makes cues causal, testable, accessible, rate-limited, and adaptable to desktop/mobile without platform APIs leaking into gameplay.
- Tradeoffs: Event taxonomy and arbitration require ownership; excessive coalescing can hide separate causes; feedback may feel restrained until representative tuning.
- Systems affected: Vehicle, ExpeditionSession, activities, Pressure, resources, Presentation, AudioDirector, FeedbackDirector, PlatformService, accessibility, tests.
- Validation: Four of five identify cause/severity of critical cues without a single required sensory channel; automated resource/routing/dedupe/concurrency/pause tests pass; captured 15-minute mix, 30-minute fatigue/masking session, and physical haptic test pass; generated tones/counters never satisfy production acceptance.

## D033 — Gate asset multiplication behind one final-pipeline representative tranche

- Date/phase: 2026-07-11, Wayfinder art/audio production review.
- Context: The repository has no production visual/font/audio assets, and broad custom production before style, provenance, throughput, import, memory, and recognition proof could create expensive rework or an incoherent asset-pack collage.
- Options considered:
  - Produce the full region/vehicle/UI/audio catalog from the written direction.
  - Buy or generate broad packs, then normalize them late.
  - Build one small final-pipeline tranche with complete metadata and lock budgets from evidence before multiplication.
- Selected option: Use three staged gates. Phase 2 proves the Drive hero vehicle/world/HUD plus real engine/surface/impact/warning/pickup audio. Phase 3 proves representative Service compare/part-install, extraction/safehouse mutation, Settle Receipt, exact secured/lost state, ambience, sparse music, and a 15-minute loop. Phases 8/10 prove remaining common component states, full mix/event map, 30-minute desktop visual/audio fatigue, and separate physical haptics. A family multiplies only after its own gate. Universal asset metadata covers stable ID/package, best-available source/runtime artifact, provenance/license/attribution, import version, memory/package class, and status; kind-specific fields apply only where meaningful. Hero proof/cost/rework is individual, routine variants are batch/tranche-level. The deterministic review/import/gallery/platform pipeline precedes packaging. Phase 2 measures presentation cost; Phase 3 records family caps/headroom in D020's `SCOPE_LOCK.md` while preserving its separate 30% reserve and whole-process budgets.
- Reason: Proves identity and the actual marginal production cost while changes are still cheap; makes mobile/package implications visible before counts multiply.
- Tradeoffs: Up-front pipeline and tranche work delays broad visible breadth; one region/sample may underrepresent later extremes; strict metadata adds authoring overhead.
- Systems affected: Art/audio production, ContentCatalog, import/bake tooling, license manifest, UI gallery, performance/build reports, scope lock, outsourcing, localization, marketing.
- Validation: Each staged family passes randomized per-category phone-scale recognition where visual, source/license audit, deterministic import, representative desktop/minimum-device measurement, clean export, D020 throughput/rework/cap formula, and the relevant hero/integrated/fatigue human proof before that family multiplies.

## D034 — Separate the accessibility design baseline from App Store claims

- Date/phase: 2026-07-11, Wayfinder accessibility/mobile-readiness review.
- Context: Responsive layout, 200% text, color-independent cues, and settings can improve access without proving native assistive-technology support or every common task on each shipped device.
- Options considered:
  - Claim features when corresponding controls/settings exist.
  - Defer accessibility until mobile adaptation.
  - Design and test a broad multimodal baseline now, but make store claims only from exact-build end-to-end evidence.
- Selected option: Build every common flow for 100-200% text, +40% pseudolocalization, 48-point targets, safe areas, focus/Back, keyboard/controller/touch intent parity, color/audio/haptic/motion-independent critical meaning, route-list equivalents, Reduced Motion/Effects, remapping/assists, independent audio categories, captions/visual audio where relevant, and recoverable error states. Treat Apple's Accessibility Nutrition Labels as per-device release assertions: claim only features whose current criterion passes every common task in the exact release candidate. Investigate native/screen-reader feasibility explicitly; never infer it from visual compliance.
- Reason: Accessibility shapes architecture/content early while keeping public metadata accurate and auditable.
- Tradeoffs: Common-task matrices and recruited testing add cost; some native assistive features may remain unclaimed at 1.0; stricter layouts constrain styling.
- Systems affected: UI, input, settings, difficulty, map/navigation, audio/haptics, localization, playtest, App Store metadata, support docs.
- Validation: Aspect/text/pseudoloc/contrast/focus/no-audio/mono/motion/input/error matrices pass; recruited users complete relevant common tasks; each proposed store label has a dated device/build evidence record and unsupported labels remain unclaimed.

## D035 — Compose five deep Modules under a thin ApplicationShell

- Date/phase: 2026-07-11, Wayfinder technical-architecture review; sharpens D009 and supersedes the shallow service names in the prior target diagram.
- Context: `GameRoot` already mixes flow, mirrored run facts, input, UI, contacts, persistence, audio, and proofs. Splitting each concern into a public service would add coordination without establishing authority; hiding everything in one universal kernel would recreate the same god object.
- Options considered:
  - One live `GameKernel` with `open/dispatch/read`.
  - A broad mesh of AppFlow, progression, economy, ownership, loadout, activity, encounter, world, save, presentation, and platform services.
  - A thin `ApplicationShell` composing deep Campaign, Expedition, Drive Runtime, Content, and Save Modules.
- Selected option: Use the five deep Modules. Campaign owns permanent county/profile/economy/ownership truth. Expedition owns the immutable manifest and mutable active rules/progress. Drive Runtime owns live physical/world state. Content owns stable-ID packages and loading. Save owns durable sequences/migration/recovery. `ApplicationShell` owns posture, lifetime, ordering, and immutable read-model composition only. Presentation/Feedback are shell Implementations.
- Reason: Every public Interface follows a real authority and lifecycle, giving high Depth and Locality without a universal kernel or shallow service mesh.
- Tradeoffs: The shell has explicit departure, fixed-tick, checkpoint, and settlement orchestration; Module records must remain disciplined; internal files may look less independently swappable.
- Systems affected: Application flow, campaign/Garage, expedition, vehicle/world, content, save, Presentation, feedback, tests, debug tools, migration.
- Validation: Phase 3 has exactly one live owner per fact; `GameRoot` contains no mirrored gameplay state; the five Interfaces have public tests; changing economy, activity rules, physics, package loading, or durability stays local to its owner except for typed Interface records.

## D036 — Use typed commands, transitions, read models, and explicit ordering

- Date/phase: 2026-07-11, Wayfinder data-flow review.
- Context: Public Dictionaries and arbitrary signal fan-out let callers mutate implementation details, hide stale UI actions, and obscure save/settlement ordering.
- Options considered:
  - Continue direct references plus Dictionaries/signals.
  - Introduce a global command/event bus.
  - Route closed typed commands through the owning Module and return typed transitions/read models.
- Selected option: Commands carry a unique `command_id`, expected revision, closed kind, and stable-ID payload. Module transitions return an immutable read model plus bounded runtime commands, semantic feedback events, and optional durability/terminal requests. `DurabilityRequest` names one owner plus commit/parent/candidate revisions and its commit ID is passed only to that owner. Campaign/Settings serialize mutations; Expedition's oldest unacknowledged candidate is the commit head and newest live state is the speculative tail. Ticks continue from the tail while Save commits from the head. Only the matching head acknowledgement promotes/releases output. Failure stops Save, retains the failed head/descendant tickets and gated output, then safe-pauses; exact-head retry resumes. Explicit verified-image reopen first obtains `CANCEL_OWNER_CHAIN` success guaranteeing held descendants cannot write, then discards the speculative chain. Capacity backpressure pauses rather than drops a transition. Runtime/model/feedback output is `IMMEDIATE` pending projection or `AFTER_DURABILITY`; candidate value is never called secured before acknowledgement. On restore, committed `ExpeditionProgress` overrides every derivable runtime projection through idempotent reconciliation before Drive ticks, including termination after save acknowledgement but before runtime output. Snapshot capture freezes incrementally maintained immutable roots in bounded O(1)/copy-on-write work; serialization/I/O stays outside the physics tick. Movement checkpoints coalesce only before request/revision/ticket allocation. `ApplicationShell` sequences calls directly; there is no global bus. Errors are typed results with recovery and localization facts.
- Reason: Makes stale/duplicate handling, authority, causal feedback, durability, and testing explicit without centralizing every policy.
- Tradeoffs: More record definitions and projection code; command unions require ownership; durable results can remain visibly pending.
- Systems affected: All Module Interfaces, Presentation, feedback, save, debug tooling, tests.
- Validation: Stale or duplicate commands never mutate state; read models cannot mutate owners; every cross-Module transition has an ordering test; no player-facing system reaches a mutable public Dictionary or Node path.

## D037 — Give one ContentModule every threaded load and package lease

- Date/phase: 2026-07-11, Wayfinder world/content-loading review.
- Context: Godot 4.7 does not make the active SceneTree thread-safe, warns about shared Resources across loader threads, and can block if `load_threaded_get()` is called before completion. Independent feature loaders would make priority, cache, memory, and attachment unbounded.
- Options considered:
  - Let each world/encounter/presentation feature load its own Resources.
  - Preload all content at boot.
  - Use one `ContentModule` scheduler over versioned stable-ID packages; let owning Implementations attach completed leases.
- Selected option: Boot the small metadata index plus one bounded always-resident shell/Title/Settle/loading/recovery package. One scheduler initially runs one threaded Resource request at a time with subthreads disabled, polls across frames, takes only completed Resources, and hands leases to owning main-thread Implementations. `ContentModule` never attaches Nodes. Drive returns request/withdraw/release IDs through frame/close results; private Presentation/Feedback return consumer-tagged deltas for their lazy packages. The shell merges all into Content and delivers leases to the tagged consumer. Fresh departure and cold resume remain paused until exact essentials attach. Optional work starts during Drive only when the essential horizon is full and declared bytes plus measured p99 fit with margin; active optional loads cannot cancel and obsolete results discard after completion. Runtime paths never enter saves.
- Reason: Centralizes the genuinely cross-cutting load queue/residency invariant while keeping gameplay and authored package schemas local.
- Tradeoffs: A single queue can head-of-line block, so optional admission is conservative; package timing/dependency/residency metrics add tooling; concurrency stays conservative until measured.
- Systems affected: Content bake, ContentModule, Drive Runtime, world streaming, Presentation/audio packages, memory/performance, saves/build manifests.
- Validation: Deterministic package/hash/bootstrap-budget tests; composite `entry_ready` and non-Drive `posture_ready`/visible blocked failure for required world/HUD/warning/accessibility/latency-audio packages; tagged consumer demand/ticket/lease/attach/detach/withdraw/release; pre-consumer abort; queued-cancel/late-discard; every close-drain; essential demand during largest optional; no blocking take/off-thread live mutation; zero blank/invisible/input-freeze.

## D038 — Replace PlatformService with narrow proven Adapters

- Date/phase: 2026-07-11, Wayfinder desktop-to-iOS architecture review; sharpens D011 and supersedes `PlatformService` references in earlier diagrams/records.
- Context: Input, lifecycle, safe area, haptics, storage, diagnostics, accessibility, and optional online features do not share one cohesive caller. A capability grab bag would leak OS concerns and weaken Locality.
- Options considered:
  - One desktop/iOS `PlatformService` or Host Adapter.
  - OS checks inside gameplay Modules.
  - Narrow `InputSource`, `LifecycleSource`, `DisplayFactsSource`, `HapticOutput`, and build-time `ExportTarget` Adapters; private storage/loader Seams inside their Modules.
- Selected option: Use the narrow Adapters. Gameplay sees no OS name or general capability Dictionary. Cloud, Game Center, third-party telemetry, audio-session plugins, and native accessibility receive no public Seam until approved scope and two real Implementations justify one. Godot Control metadata is required, but VoiceOver remains an explicit physical-iPhone/native-plugin feasibility gate because Godot 4.7's documented screen-reader feature excludes iOS.
- Reason: Platform variation stays at the actual caller while shared Campaign/Expedition/Drive behavior remains identical.
- Tradeoffs: More composition-root wiring; capability facts are intentionally distributed; native accessibility may be unshippable or expensive at 1.0.
- Systems affected: Input, lifecycle, Presentation, haptics, save/content internals, build/export, accessibility claims, iOS.
- Validation: Adapter conformance tests; no domain OS branches; lifecycle ordering clears input and resumes once; safe-area/orientation matrix; physical haptic proof; common-task VoiceOver spike before any claim.

## D039 — Use alternating verified save slots and durability-gated transactions

- Date/phase: 2026-07-11, Wayfinder save/reliability review; sharpens D013.
- Context: Temp-plus-rename is useful but Godot's cross-platform APIs do not by themselves prove atomic durability. Overwriting the only good slot or presenting rewards before the write completes risks loss or duplication under termination/low storage.
- Options considered:
  - One primary file plus rotating backups.
  - A database.
  - A versioned envelope in two alternating verified slots, ranked by checksum-valid sequence before compatibility.
- Selected option: `SaveModule` has closed PROFILE/SETTINGS image kinds with independent schemas, sequence namespaces, open/recovery results, and two-slot journals behind one internal file writer. For each kind it writes the next sequence to a temporary for the inactive slot, flushes/parses/checksums/validates it, replaces only that inactive slot, re-reads it, then advances that kind's committed sequence. Open ranks checksum-valid candidates by sequence without trusting a pointer. The highest checksum-valid sequence is authoritative: future schema/content/migration failure blocks visibly; only incomplete/unparsable/checksum-invalid higher data permits disclosed lower-slot recovery. Save copies corrupt higher evidence to diagnostic quarantine without removing its source slot before the replacement PROFILE notice commit succeeds. Recovery preserves trusted terminal/nonterminal active and burns the recovered offer set only when no trusted matching active survives and discarded higher-active risk is `POSSIBLE`; every lower recovery durability-persists `PendingRecoveryNotice` before routing and clears it only through idempotent acknowledgement. A SETTINGS failure/reset never selects, blocks, or rewrites PROFILE; active progress persists its effective assist policy and retained-delta outbox. Critical commits never coalesce/reorder; terminal and campaign results remain pending until acknowledgement. Offer sets commit before display. Settlement commits retained-delta transfer, set consumption, its exact pending receipt, permanent deltas, and active-snapshot removal, then clears that receipt only after a durable player acknowledgement.
- Reason: A failed candidate replacement cannot overwrite the current valid sequence, while the format stays inspectable and much simpler than a database.
- Tradeoffs: Roughly doubles save storage; sequencing/pending UI and fault harness are more complex; platform durability still needs physical proof.
- Systems affected: SaveModule, settings image, expedition checkpoint, campaign transactions, lifecycle, Settle Receipt, recovery/support.
- Validation: independent PROFILE/SETTINGS corruption/recovery/reset cross-product; v0/N-2 fixtures; low-storage/permission cases; 1,000 interruption points across slots, including valid replacement/verification before `DurabilityResult`, migration, offer creation, assist-policy change, retained-delta transfer, socket/reward/objective/terminal/purchase/settlement/receipt acknowledgement. The recovery matrix proves trusted nonterminal/terminal no-burn; no trusted matching active plus `POSSIBLE` burn/discard once; notice-write failure/retry and kill before notice commit replay the same recovery; kill after notice commit before display/acknowledgement restores it; duplicate acknowledgement is idempotent; and kill after acknowledgement does not restore it. Require zero profile loss, duplicate reward, rerolled shown offer, active-policy drift, retained-delta loss/duplication, skipped/duplicated recovery disclosure, or lost Settle Receipt; corrupt active progress never improves settlement.

## D040 — Pin the simple Godot stack and a stable release toolchain

- Date/phase: 2026-07-11, Wayfinder language/build review; sharpens D010.
- Context: The current project and accepted handling proof use Godot 4.7, GDScript, and GL Compatibility. The local selected Xcode 27 beta, iOS 27 SDK, and beta macOS host can expose feasibility, but beta tooling or host OS is not release proof.
- Options considered:
  - Move early to C#, GDExtension, custom engine, or native iOS gameplay.
  - Upgrade tools opportunistically.
  - Pin the current simple stack and change only at measured phase gates.
- Selected option: Retain Godot 4.7, GDScript, and GL Compatibility unless a measured production blocker identifies an exact Module and a recorded decision requalifies desktop, export, save, and device gates. Pin the exact Godot executable/export-template hash. Phase-2 feasibility may use available beta Xcode/macOS, but TestFlight/App Store archives require a pinned Apple-accepted stable Xcode/SDK pair on an Xcode-supported stable macOS release/build and a live upload-floor recheck.
- Reason: Minimizes language/runtime/export variation while the project still has large gameplay/content risks and makes build provenance reproducible.
- Tradeoffs: A later measured bottleneck can require a controlled migration; conservative engine/tool upgrades defer improvements; maintaining a stable Apple toolchain adds release-host work.
- Systems affected: Project settings, scripts, native/plugin policy, CI/build manifests, iOS export, TestFlight/App Store release.
- Validation: One clean-clone command records tools, imports, validates, tests, bakes, exports, and emits manifest-linked artifacts; signed feasibility and frozen-source Phase-15 archives install on physical devices; every release archive records stable macOS release/build, Xcode/SDK, Godot/templates, commit, content, and save schema.

## D041 — Gate release through an exact-candidate evidence ledger and staffed manual launch

- Date/phase: 2026-07-11, Wayfinder playtest/release/App Store review.
- Context: The existing playtest, mobile, App Store, and roadmap documents contain strong checks, but a checklist can still drift across builds, pass with provisional thresholds, double-count cohorts, accept an unmeasurable crash denominator, or leave final go/no-go authority implicit. App Store distribution also provides no dependable rollback after customers install a binary.
- Options considered:
  - Treat milestone notes and the final App Store checklist as sufficient.
  - Run one giant release-candidate qualification after feature/content completion.
  - Use cumulative `KD-G0` through `KD-G11` gates bound to one `ReleaseEvidenceLedger`, exact candidates, fixed cohorts/denominators, explicit authority/reopen rules, manual 1.0 release, and forward-compatible emergency patching.
- Selected option: Use the cumulative gates. `KD-G0` freezes scripts, thresholds, owners, cohorts/device quotas, UTC windows, consent/retention, required suites, artifacts, monitoring coverage, and change-to-retest rules before results. Every gate records PASS/FAIL/REOPENED against exact candidate identity; required gates/P0/P1 cannot be waived and placeholders cannot pass their owning gates. Desktop risk truth does not satisfy physical-mobile evidence. `KD-G6` requires every matrix row, 1,000/1,000 faults, a distinct ten-person first-time-iPhone cohort, and >=200 internal sessions in one seven-day UTC window with every tier >=20 and health >=99.5%. The unchanged processed build then enters `KD-G7`: two non-overlapping seven-day UTC windows, >=50 active external participants, >=1,000 sessions, every tier >=5 participants/100 attributable sessions, health >=99.8%, and a separate ten-person first-time touch cohort reaching 9/10 unaided driving and 8/10 full pause/background/resume common-flow completion. Daily rolling views are never summed. Any prelaunch binary/content/config change resets `KD-G7`; after launch, only the urgent smallest-scope `KD-E1` patch path may use its dedicated exact-delta/device/update/blocker/internal-TestFlight proof floor, and any public patch restarts `KD-G11`. Accessibility baselines use five desktop and five physical-iPhone participants with two relevant access-needs participants in each; optional VoiceOver/Voice Control claims require two regular users. Accepted P2s are capped at five through `KD-G8` and two through `KD-G11`, with protected critical scopes ineligible. `KD-G10` requires eight staffed hours, hourly checks, three-device public smoke, and propagation ownership; `KD-G11` requires seven complete evidenced UTC days, >=99.8% aggregate health, tier/triage/P2/update/save/compliance thresholds, and extends rather than passes on missing evidence. Required suites pass 100%; blocker coverage cannot be silently flaky/quarantined. Product, Evidence, Build, Privacy/Compliance, and Release authority are explicit. 1.0 uses Public distribution and staffed manual release; archive, store claims, and declarations agree. There is no binary rollback: preserve diagnostics/saves, contain availability, communicate, and ship only a requalified forward patch.
- Cohort clarification: the separate `KD-G6` and `KD-G7` ten-person cohorts each require 9/10 unaided driving within two minutes and 8/10 touch completion of first launch -> expedition -> pause/background/resume -> Settle -> Service; one person cannot supply first-time evidence twice.
- Patch clarification: every `KD-E1` starts from the latest public tag with the next monotonically increasing patch version/build and validates updates/saves from every supported public predecessor; a second emergency patch never branches from the original 1.0.0 tag and drops an earlier public fix.
- Reason: Makes production readiness auditable, keeps weak or stale evidence from crossing phase boundaries, gives player-facing and compliance claims the same exact-build discipline as code, and prevents panic release/rollback assumptions.
- Tradeoffs: More record keeping, harder recruitment/device requirements, and a late binary fix can reset a 14-day beta. Small-team roles may be held by one person, but each attestation remains separate and naive/assistive-technology evidence still requires other humans.
- Systems affected: Playtesting, evidence storage, QA/regression, device matrix, accessibility claims, tester privacy, TestFlight, App Store metadata/assets/distribution, RC change control, support, incident response, saves/updates, launch/stabilization.
- Validation: `docs/release/<version>/RELEASE_EVIDENCE.md` contains no missing owner/denominator/current-evidence row; every gate-relevant placeholder is locked before entry; alpha median >=4/5 after retest; beta clean/mastery/longitudinal cohorts pass; exact mobile matrix and 1,000 faults pass; external exact-build score/cohort/tier/day floor passes; blind store-page/reviewer path passes; archive/claims agree; App Review approves; manual public smoke passes; no live P0/P1 remains through the post-launch stabilization window.
