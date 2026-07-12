# Technical and Mobile Architecture Decision

Status: selected target for ticket 05
Research date: 2026-07-11

## Decision

Use a thin Godot `ApplicationShell` that composes five deep runtime Modules:

1. `CampaignModule` — permanent profile/county truth, Service/Plan rules, buildcraft, economy, departure, and settlement.
2. `ExpeditionModule` — the immutable `ExpeditionManifest` plus mutable `ExpeditionProgress`, activities, Pressure, escrow, failure, extraction, and exact resume rules.
3. `DriveRuntimeModule` — fixed-step Arcade-Real Handling, physical world, streaming, spatial queries, contacts, entities, and reconstructable runtime state.
4. `ContentModule` — stable-ID metadata, package leases, and the only threaded resource-load scheduler.
5. `SaveModule` — schema migration, independent PROFILE/SETTINGS alternating verified-slot journals, per-kind recovery, commit ordering, and durability results.

`ApplicationShell` is the composition root and ordering owner, not a sixth business authority. Its Presentation Implementation owns Service, Plan, Drive, Settle, and SystemSheet scenes. It combines immutable read models, dispatches typed intents, sequences fixed ticks and durability, and handles lifecycle events. It never calculates economy, activity, physics, or settlement truth.

Do not build:

- a universal game kernel;
- a global command/event bus;
- public mutable dictionaries;
- public Interfaces for economy, ownership, loadouts, activities, encounters, world streaming, or feedback merely because they have separate files;
- a broad `PlatformService` or `PlatformAdapter`;
- separate desktop and iOS gameplay trees.

Those concerns remain private Implementations until they have an independent caller/lifecycle and a useful abstraction cost.

## Evidence audited

### Repository truth

- `scenes/main.tscn` contains only `GameRoot`.
- `scripts/game_root.gd` is 621 lines and owns flow, input, UI construction, camera, collision/contact response, mirrored Fuel/Vehicle Damage/run facts, save calls, audio/effects, and proof helpers.
- `RunProgression` is useful characterized private rule evidence, not a target authority; `GameRoot` currently mirrors its state.
- `WorldRuntime` exposes mutable dictionaries, synchronously generates chunks, and linearly scans/counts live entities.
- The shipping-path `PlayerVehicle` is a variable-delta `Node2D`. The isolated handling proof has the better `CharacterBody2D` and fixed-step direction.
- `ProfileStore` directly overwrites one unversioned JSON file and silently defaults on several failures.
- `project.godot` pins Godot 4.7, a 1280 x 720 expanding canvas, GL Compatibility, and ETC2/ASTC import support.
- `export_presets.cfg` has only a prototype macOS ad-hoc export. There is no iOS production preset.

The architecture must remove mirrored authority before it multiplies filenames.

### Current local toolchain

- Godot: `4.7.stable.official.5b4e0cb0f`.
- Matching Godot 4.7 export templates are installed.
- Selected Xcode: 27.0 beta; selected iPhoneOS SDK: 27.0.
- Host: Apple Silicon macOS beta.

This is useful export-feasibility evidence, not a release toolchain. Apple currently requires App Store uploads to use Xcode 26 or later and an iOS 26 SDK, while Apple's support matrix separately identifies stable and beta Xcode releases. The project policy is stricter: feasibility may use beta Xcode or beta macOS, but TestFlight/App Store release gates require a pinned Apple-accepted stable Xcode/SDK pair, an Xcode-supported stable macOS release/build, and matching Godot templates. Recheck at every signed gate.

### First-party constraints

- Godot says the active SceneTree is not thread-safe. Node attachment and live-tree mutation stay on the main thread. It recommends one resource-loading thread where shared Resources are involved. [Godot 4.7 thread-safe APIs](https://docs.godotengine.org/en/4.7/tutorials/performance/thread_safe_apis.html)
- Godot's threaded loader must be polled across frames. Calling `load_threaded_get()` before the load completes can block the caller. [Godot 4.7 ResourceLoader](https://docs.godotengine.org/en/4.7/classes/class_resourceloader.html)
- `DisplayServer.get_display_safe_area()` is implemented on iOS. [Godot 4.7 DisplayServer](https://docs.godotengine.org/en/4.7/classes/class_displayserver.html)
- Godot exposes iOS pause/resume and memory-warning notifications. Its pause notification gives only about five seconds to finish work before iOS may terminate the app. [Godot 4.7 MainLoop](https://docs.godotengine.org/en/4.7/classes/class_mainloop.html)
- Godot exports an Xcode project that is then built/deployed like another iOS project; Godot changes normally require re-export. The simulator supports only the Compatibility renderer. [Godot 4.7 iOS export](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html)
- Godot `Control` exposes accessibility metadata, but Godot's documented screen-reader feature is desktop-only, not iOS. Therefore that metadata does not prove VoiceOver support. A native iOS plugin is possible, but it is a feasibility decision, not an assumed capability. [Godot 4.7 Control](https://docs.godotengine.org/en/4.7/classes/class_control.html), [Godot 4.7 DisplayServer](https://docs.godotengine.org/en/4.7/classes/class_displayserver.html), [Godot 4.7 iOS plugins](https://docs.godotengine.org/en/4.7/tutorials/platform/ios/ios_plugin.html)
- Since 2026-04-28, App Store Connect uploads require Xcode 26 or later with an iOS 26 SDK. [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- Apple publishes the supported macOS versions and SDKs for stable and beta Xcode releases; release evidence must use a supported stable pairing. [Apple Xcode support](https://developer.apple.com/support/xcode/)

## Problem frame

The target must simultaneously provide:

- exactly one owner for each authoritative fact;
- fixed 60 Hz driving independent of render rate;
- one learnable `PersistentCountyState` plus deterministic expedition variation;
- exact resume of `ExpeditionManifest`, `ExpeditionProgress`, and physical state;
- exactly-once terminal settlement through `resolution_id`;
- main-thread SceneTree behavior and bounded asynchronous loading;
- one shared desktop/iOS gameplay path;
- immutable read models and typed intents for responsive Presentation;
- stable IDs and no Node, Resource, RID, or resource path in saves;
- incremental migration from `GameRoot` without a flag-day rewrite;
- public-Interface tests, fault injection, performance evidence, and reproducible builds.

Dependency categories:

- **In-process:** build math, economy, manifest creation, activities, Pressure, rewards, settlement, and read-model projection. Keep these inside their owning Module; no Adapter.
- **Local-substitutable:** resource loading and durable storage. Their owning Modules use internal production and deterministic/fault-injecting Implementations.
- **True platform/external:** input devices, lifecycle notifications, display facts, haptic output, and export/archive tooling. These receive narrow Adapters because real Implementations differ.
- **Hypothetical:** cloud, Game Center, third-party telemetry, and native iOS accessibility. Do not create runtime Seams until scope approves a second real Implementation.

## Design it twice

Three independent designs were compared sequentially.

### A — universal `GameKernel`

One live-tree Module would own profile, expedition, vehicle, world, economy, and Presentation behind `open`, `dispatch`, and `read`.

- **Depth:** highest public Depth.
- **Leverage:** very high for whole-game callers.
- **Locality:** poor when permanent campaign rules, 60 Hz physics, package loading, and UI change independently.
- **Seam placement:** too few; pure rules become coupled to a live SceneTree and the kernel can become `GameRoot` under a better name.
- **Decision:** reject as the target. Retain its useful lesson that internal policy objects do not all deserve public Interfaces.

### B — feature-oriented Modules

Permanent campaign, active expedition, physical runtime, content packages, durable saves, and Presentation receive explicit command/result/read-model Interfaces.

- **Depth:** high when economy, ownership, activities, encounters, and streaming stay private.
- **Leverage:** high at departure, fixed-tick, checkpoint, and settlement workflows.
- **Locality:** strongest; each Module follows a real authority and lifecycle.
- **Seam placement:** useful between permanent/active, rules/physics, stable-ID/package, snapshot/durability, and model/Presentation responsibilities.
- **Decision:** select, with a thin `ApplicationShell` and narrow platform Adapters.

### C — common-caller `GameApplication`

A single shell-facing Interface would expose boot, lifecycle, dispatch, fixed tick, render snapshot, and checkpoint.

- **Depth:** high and ergonomic for Godot callbacks.
- **Leverage:** excellent for the composition root.
- **Locality:** better than the universal kernel if internal Modules remain strict, but the application Interface can still become the policy owner.
- **Seam placement:** its narrow platform Seams and lifecycle ordering are strong; its universal gameplay Interface is not necessary.
- **Decision:** adopt its platform/lifecycle rules, not its universal kernel.

## Selected architecture

~~~mermaid
flowchart LR
    Host["Input / Lifecycle / Display Adapters"] --> Shell["ApplicationShell\ncomposition and ordering"]
    UI["Presentation Implementation\nService Plan Drive Settle"] <--> Shell
    Shell --> Campaign["CampaignModule\npermanent authority"]
    Shell --> Expedition["ExpeditionModule\nactive authority"]
    Shell --> Drive["DriveRuntimeModule\nphysical authority"]
    Shell --> Save["SaveModule\ndurable authority"]
    Shell --> Content["ContentModule\nstable IDs and packages"]
    Campaign --> Expedition
    Drive --> Shell
    Content --> Campaign
    Content --> Expedition
    Content --> Drive
    Content --> UI
    Shell --> Feedback["Audio / Feedback Implementations"]
    Content --> Feedback
    Feedback --> Haptics["HapticOutput Adapter"]
~~~

Arrows show calls/data flow, not ownership transfer. No module can reach through another Module's Interface into its Implementation.

### Authority table

| Fact | Sole live owner | Persisted representation |
|---|---|---|
| App posture, current screen/session lifetime, save/loading/error presentation | `ApplicationShell` | onboarding subset only |
| `PersistentCountyState`, `RewardLedger`, Scrap, owned parts/chassis, blueprints, presets, offer epoch/current `ExpeditionOfferSet`, pending settlement/recovery notices, Build Capacity validation, records | `CampaignModule` | `PermanentSnapshot` |
| Immutable `ExpeditionManifest`; Fuel, Vehicle Integrity, Pressure, applied gameplay/physics assist policy, retained Campaign-delta outbox, objectives, encounters, escrow, consumed sockets, pending mutations, terminal state | `ExpeditionModule` | `ActiveExpeditionSnapshot.ExpeditionProgress` |
| Vehicle kinematics, collision/recovery filters, active world nodes, spatial index, pools, streaming window | `DriveRuntimeModule` while live | `DriveRuntimeCheckpoint` captured into `ExpeditionProgress` |
| Stable-ID index, content/package versions, load queue, leases, residency | `ContentModule` | build/content manifest; leases are never saved |
| Per-kind committed sequences, independent PROFILE/SETTINGS verified-slot journals, migrations, recovery state | `SaveModule` | typed save envelopes and alternating slots |
| Preferred `SettingsState` values | private Settings Implementation owned by `ApplicationShell` | independent versioned `SETTINGS` image through `SaveModule` |
| Focus, animation, layout, and ephemeral component state | Presentation Implementation | not persisted unless promoted to `SettingsState` |
| Safe area, orientation, lifecycle, device/input capability | narrow Adapter | never gameplay truth |

There is one authority per fact, not one giant object for every fact. `DriveRuntimeModule` is the live authority for physical state; the most recently committed `DriveRuntimeCheckpoint` becomes resume authority only after relaunch. It is never mirrored in `ApplicationShell`.

`DriveRuntimeCheckpoint` contains only stable-ID/value data:

- physics tick;
- vehicle position/rotation, linear/angular motion, steering/slip/filter state;
- last-safe pose and recovery/contact cooldown state;
- non-progression manifest-scoped entity physics required for exact reconstruction;
- deterministic runtime cursors;
- required content hashes.

It explicitly excludes Nodes, Resources, RIDs, paths, package leases, pool/cache membership, Presentation state, reward eligibility, socket availability, and objective truth. Committed `ExpeditionProgress` is authoritative over all derivable runtime projections. Restoring a checkpoint, attaching its exact essential content, applying Expedition's ordered idempotent reconciliation commands, and then applying the next identical `DriveIntent` must produce the same next-tick physical facts within declared numeric tolerance.

## Shared records

Production records are typed `RefCounted` values or typed Resources used as immutable definitions. Public Interfaces do not exchange arbitrary Dictionaries.

~~~text
StableId
  namespaced StringName; immutable after release; never a path

CommandMeta
  command_id
  expected_revision

PermanentSnapshot
  profile_id, revision
  PersistentCountyState
  RewardLedger
  Scrap
  owned_chassis_ids, owned_part_ids, blueprint_ids
  loadouts, records, discoveries
  applied_resolution_ids
  applied_retained_delta_ids
  monotonic offer_epoch
  current ExpeditionOfferSet or none
  pending PendingSettlementReceipt or none
  pending PendingRecoveryNotice or none

ExpeditionOfferSet
  offer_epoch and committed source_digest
  immutable plans_by_offer_id
  reserved implicitly by matching active manifest

ExpeditionOfferPlan
  offer_id and offer_epoch
  content/world version, expedition_id, seed
  repetition snapshot and contract
  conditions, closures, Pressure branch table
  encounter/reward rolls
  valid extraction nodes and finite budgets
  no selected loadout or starting resources

PreparedDeparture
  immutable ExpeditionManifest
  frozen AppliedExpeditionAssistPolicy
  initial ExpeditionProgress and DriveRuntimeCheckpoint
  DriveRuntimeConfig
  stable domain/world WorldEntryRequirements
  deterministic domain digest

DriveRestorePlan
  exact DriveRuntimeConfig and DriveRuntimeCheckpoint
  saved-hash WorldEntryRequirements
  ordered idempotent reconciliation commands

PendingSettlementReceipt
  resolution_id, terminal outcome and revision
  exact secured/lost/permanent deltas and highlights
  settlement digest; retained until acknowledged

PendingRecoveryNotice
  recovery_id, quarantine_id, recovered_sequence
  loss/action summary and digest
  optional burned_offer_epoch; retained until acknowledged

DurabilityRequest
  owner, unique commit_id
  parent_revision, candidate_revision
  image_kind, reason, criticality
  ActiveSnapshotDisposition

ActiveSnapshotDisposition
  PRESERVE_CURRENT | INCLUDE_OWNER_CANDIDATE
  REMOVE_COMMITTED_TERMINAL | NOT_APPLICABLE for SETTINGS only

DurabilityResult
  owner, commit_id, candidate_revision
  save_sequence, outcome

ActiveExpeditionSnapshot
  ExpeditionManifest
  ExpeditionProgress

ExpeditionProgress
  revision, physics_tick
  Fuel, Vehicle Integrity, Pressure
  current AppliedExpeditionAssistPolicy
  RetainedCampaignDeltaOutbox
  objective/activity/encounter state
  consumed_socket_ids
  escrow and pending county mutations
  terminal state and resolution_id
  DriveRuntimeCheckpoint

ModuleError
  code, stable context IDs, retryability, recovery action
  localization key and arguments
  diagnostic correlation ID

SettingsState
  preferred values owned by ApplicationShell
  projected by type to Input, Campaign, Presentation, Feedback

AppliedExpeditionAssistPolicy
  policy_revision and source settings_revision
  Fuel, Integrity, Pressure and timer/cognitive modifiers
  steering, brake, traction physics parameters for DriveRuntimeConfig
  persisted in active progress; never recovered from mutable settings

SettingsAssistVersion
  settings_revision
  full PreferredExpeditionAssistPolicy digest

RetainedCampaignDeltaOutbox
  ordered RetainedCampaignDelta values
  delta_id, OBSERVATION or COSMETIC_AWARD
  stable payload, source revision, proof digest
  excludes every material/escrow/restoration reward
~~~

Unknown IDs, stale revisions, invalid postures, content mismatch, durability failure, and invariant failure are typed results. Modules never invent final English error copy and never silently default corrupt authoritative state.

## Public Interfaces

These signatures are the target contract. Exact GDScript filenames may change; widening behavior requires a recorded architecture decision.

### `CampaignModule`

~~~gdscript
restore(
    snapshot: PermanentSnapshot,
    catalog: CampaignCatalogView
) -> CampaignRestoreResult

validate_assists(
    policy: CampaignAssistPolicy,
    version: SettingsAssistVersion
) -> ValidationResult

configure_assists(
    policy: CampaignAssistPolicy,
    version: SettingsAssistVersion
) -> ConfigureResult

handle(command: CampaignCommand) -> CampaignTransition

read(query: CampaignReadQuery) -> CampaignReadModel

snapshot(commit_id: StringName = &"") -> PermanentSnapshot
~~~

Closed `CampaignCommand` family:

- equip/apply/save preset;
- fabricate or purchase a named part;
- create or read the current offer set;
- select a contract;
- prepare departure;
- apply terminal settlement;
- resolve eligible lower-PROFILE recovery, preserving trusted terminal/nonterminal active state and consuming the recovered current offer set only when no trusted matching active survives and discarded higher-active risk is `POSSIBLE`;
- acknowledge pending settlement receipt;
- acknowledge pending recovery notice;
- report durability result.

Invariants:

- Sole authority for permanent county/profile/economy/ownership facts.
- Loadout must satisfy ownership, slots, compatibility, and Build Capacity before departure.
- Offer creation runs Campaign's private `ExpeditionManifestBuilder` over lightweight planning metadata and durability-commits one immutable `ExpeditionOfferSet(offer_epoch, source_digest, plans_by_offer_id)` before display. Back/cancel/reselect/loadout/assist/relaunch or a new command ID returns the same set while that epoch is current.
- Plan ordering is `create_or_read_offer_set` -> durability acknowledgement if newly created -> display. Presentation cannot show a new set from a pending candidate.
- `PrepareDeparture` carries offer/loadout, full preferred expedition policy, and `SettingsAssistVersion`. Campaign matches both revision and full-policy digest against the version stored beside its forecast projection, uses no RNG, freezes applied policy, and rejects stale/mismatched settings.
- A matching active manifest implicitly reserves the plan. Terminal settlement/failure/abandon consumes the set and advances the epoch in the same Campaign commit as resolution/receipt/active removal. Lower-slot recovery preserves a trusted terminal/nonterminal active; only no trusted matching active plus `POSSIBLE` higher-active risk burns the recovered current set without banking unverifiable escrow/outbox. A failed departure leaves the set selectable.
- Every command carries a unique `command_id` and expected revision. Duplicate commands return their prior result.
- Settlement validates expedition ID, terminal revision, `resolution_id`, digest, and `RewardLedger`.
- Settlement validates/transfers each retained delta ID once; permanent applied IDs make failure/abandon/retry idempotent.
- Eligible lower-PROFILE resolution validates any recovered active/offer binding first. Every recovery persists `PendingRecoveryNotice`; trusted active remains reserved. Only no trusted matching active plus `POSSIBLE` risk consumes the recovered current set and discards unverifiable active/outbox/escrow. Notice acknowledgement gates later receipt/resume/Plan.
- Settlement persists a `PendingSettlementReceipt` in the same permanent commit that removes the active snapshot; acknowledgement clears it through a later durable Campaign command.
- `CampaignTransition` may carry domain `PreparedDeparture`: manifest, initial progress/checkpoint, config, stable `WorldEntryRequirements`, and domain digest. Campaign never selects locale/quality/Presentation/Feedback payloads. The shell privately composes current consumer plans into `EntryLoadPlan` with a separate payload digest. Campaign never becomes active-state owner.
- A durable command stages one candidate snapshot and pending result; it does not replace the committed read model until a `DurabilityResult` returns through `handle`.
- Save failure retains the candidate for explicit retry; explicit revert reloads the last verified image. A result is not rendered as durably committed until `SaveModule` confirms it.

Private Implementation:

- progression and restoration rules;
- ownership, fabrication, duplicate conversion, presets;
- economy and Scrap transactions;
- deterministic stat composition and route forecasts;
- `ExpeditionManifestBuilder`, offer/graph/branch validation, and settlement application.

Do not expose separate Progression, Economy, Ownership, or Loadout Interfaces.

Representative errors:

`REVISION_CONFLICT`, `SETTINGS_REVISION_CONFLICT`, `WRONG_POSTURE`, `UNKNOWN_STABLE_ID`, `INVALID_LOADOUT`, `BUILD_CAPACITY_EXCEEDED`, `NOT_OWNED`, `INSUFFICIENT_SCRAP`, `OFFER_STALE`, `MANIFEST_INVALID`, `SETTLEMENT_MISMATCH`, `DURABILITY_UNAVAILABLE`.

Performance:

- no file I/O or resource loading;
- ordinary command evaluation and read-model projection are allocation-bounded;
- Phase 2 records actual p50/p95/worst cost and Phase 3 locks sub-budgets within the global frame target rather than accepting invented micro-budgets.

### `ExpeditionModule`

~~~gdscript
open(
    request: ExpeditionOpenRequest,
    rules: ExpeditionRulesView
) -> ExpeditionOpenResult

advance(command: ExpeditionCommand) -> ExpeditionTransition

checkpoint(
    runtime: DriveRuntimeCheckpoint,
    commit_id: StringName = &""
) -> ActiveExpeditionSnapshot
~~~

`ExpeditionOpenRequest` is either Campaign's complete `PreparedDeparture` or a previously verified active snapshot. `open(new)` validates the manifest/progress/digest, stages the first active snapshot, and returns an Expedition-owned `DurabilityRequest`. `open(resume)` is a typed branch: nonterminal progress returns `DriveRestorePlan` with exact config/checkpoint/hashes/content/reconciliation; terminal progress returns `TerminalResumePlan` with deterministic `SettlementPlan` and never opens Drive.

Closed `ExpeditionCommand` family:

- observe one sequential `DriveFacts` tick;
- interact with a stable socket/entity candidate;
- select the secure-storage item;
- set return/push intent;
- request extraction;
- abandon;
- apply a revisioned gameplay/physics assist policy;
- report durability result.

`ExpeditionTransition` contains:

- an immutable `ExpeditionReadModel` carrying committed/pending/error durability state;
- typed `DriveRuntimeCommand` values marked `IMMEDIATE` or `AFTER_DURABILITY`;
- deduplicated semantic `FeedbackEvent` values marked `IMMEDIATE` or `AFTER_DURABILITY`;
- zero or one `DurabilityRequest`;
- zero or one terminal `SettlementPlan`.

Invariants:

- The manifest never mutates or regenerates.
- Progress advances exactly once for each sequential 60 Hz physics tick.
- Fuel, Vehicle Integrity, action-driven Pressure, activity/encounter state, escrow, consumed sockets, pending mutations, and terminal state live here.
- The current `AppliedExpeditionAssistPolicy` lives here. Mid-expedition changes stage a PROFILE candidate; only acknowledgement releases the policy-derived Drive reconfiguration at a safe tick.
- Physical contacts only become facts until this Module applies rules.
- Each retained observation/cosmetic delta, assist-policy change, socket/reward/objective/Pressure/terminal transition appends an immutable candidate with parent/candidate revisions to a bounded ordered journal and requests a critical checkpoint. The commit head is the oldest unacknowledged candidate; the speculative tail is the newest live state. Fixed ticks continue from the tail while Save commits from the head in order. Only the matching head acknowledgement promotes/releases that candidate; descendants cannot overtake it. On failure Save holds descendant PROFILE CommitTickets for that owner; the failed head, descendants, and gated output remain and the shell safe-pauses before the next tick, while the independent SETTINGS chain may continue. Exact-head retry resumes the same chain. Explicit verified-image reopen first requires typed success from `CANCEL_OWNER_CHAIN`, then discards the matching held tickets/output and restores committed state. Capacity produces visible `DURABILITY_BACKPRESSURE` before a tick rather than dropping/merging a critical transition, and ordinary acceptance must show zero backpressure/save hitch. Periodic movement checkpoints may coalesce only in an owner-local unnumbered slot before `DurabilityRequest`, revision, or `CommitTicket` allocation and never across a critical candidate.
- Terminal progress commits before `SettlementPlan` becomes actionable.
- Duplicate terminal `resolution_id` cannot duplicate Scrap, parts, chassis, blueprints, cargo, payouts, `RewardLedger` claims, or county mutations.
- Acknowledged retained deltas appear through the combined read model but remain in active progress until every terminal outcome transfers them to Campaign; they cannot contain material escrow/restoration value.
- Runtime nodes own no progression truth.

Private Implementation:

- Delivery, Recovery, and Restoration state machines;
- Mastery overlays;
- encounter/Pressure arbitration;
- Fuel, Vehicle Integrity, escrow, secure storage, pending mutation, failure, abandon, extraction, and settlement proposal rules.

Do not expose separate Activity, Encounter, Reward, Pressure, or Settlement Interfaces.

Representative errors:

`TICK_DUPLICATE`, `TICK_GAP`, `WRONG_POSTURE`, `COMMAND_STALE`, `INTERACTION_UNAVAILABLE`, `SOCKET_CONSUMED`, `MANIFEST_CONTENT_MISMATCH`, `INVALID_TERMINAL_TRANSITION`, `CHECKPOINT_FAILED`, `DURABILITY_UNAVAILABLE`, `DURABILITY_BACKPRESSURE` (retryable after the commit head drains; visible safe pause).

### `DriveRuntimeModule`

~~~gdscript
open(
    config: DriveRuntimeConfig,
    checkpoint: DriveRuntimeCheckpoint
) -> DriveOpenResult

step(
    tick: int,
    fixed_delta: float,
    intent: DriveIntent
) -> DriveStepResult

apply(commands: Array[DriveRuntimeCommand]) -> ApplyResult

advance_frame(
    frame: RuntimeFrame,
    ready_leases: Array[ContentLease]
) -> RuntimeFrameResult

checkpoint() -> DriveRuntimeCheckpoint

close() -> RuntimeCloseResult
~~~

`DriveStepResult` contains physical facts only:

- pose, velocity, surface, Road Advantage, Route Network proximity;
- impacts, contacts, interaction candidates;
- manifest-scoped entity facts;
- Streaming Drag and essential-content state;
- semantic feedback facts and runtime metrics.

`RuntimeFrameResult` contains attachment status/metrics plus `ContentDemandDelta(request_plans, withdraw_demand_ids, release_lease_ids)`. Each request plan carries stable demand ID, package/hash, dependencies, priority, and prediction deadline. The private `WorldStreamer` creates this delta; withdrawal identifies no-longer-needed work before a lease exists, while detach emits a lease ID for release. `RuntimeCloseResult` returns every remaining withdrawal/release so departure failure, settlement, reset, and shutdown cannot leak residency. Drive never calls Content directly.

Invariants:

- `fixed_delta == 1.0 / 60.0` and ticks are sequential.
- Every Interface call and all live SceneTree/physics operations occur on the main thread.
- `CharacterBody2D`, vehicle/world nodes, spatial index, pools, and streaming state are private.
- `DriveRuntimeModule` is the only owner of world-lease instantiation and the live-world-node attach/detach queue; tagged Presentation/Feedback consumers attach only their private payloads.
- No contact directly mutates Fuel, Vehicle Integrity, rewards, escrow, activities, or county state.
- The authored Route Network is not regenerated per expedition.
- The Free-Roaming World permits leaving roads; Road Advantage changes speed/grip/risk rather than constraining motion.
- Streaming Drag activates only when essential collision/terrain is genuinely late and remains measured/bounded.
- No blocking load, global scene search, or unbounded entity scan occurs in `step`.
- `advance_frame` accepts completed leases, never paths/tickets, and initially attaches at most one world chunk per rendered frame.

Private Implementation:

- accepted `CharacterBody2D` Arcade-Real Handling and collision;
- surface sampling, recovery, camera/presentation facts;
- `WorldStreamer`, `SpatialWorld`, entity lifecycle/pools;
- authored world package projections;
- encounter entity movement and runtime-only effects;
- performance counters.

Representative errors:

`WRONG_THREAD`, `INVALID_FIXED_DELTA`, `TICK_OUT_OF_ORDER`, `CHECKPOINT_CONTENT_MISMATCH`, `MISSING_ESSENTIAL_COLLISION`, `INVALID_ENTITY_ID`, `SCENE_ATTACH_FAILED`.

### `ContentModule`

~~~gdscript
open_index(identity: BuildContentIdentity) -> ContentOpenResult

request(plan: ContentLoadPlan) -> LoadTicket

withdraw(demand_id: StringName) -> void

advance(poll_budget_us: int) -> ContentTransition

lease(ticket: LoadTicket) -> ContentLeaseResult

release(lease_id: StringName) -> void
~~~

Package families:

- campaign metadata: chassis, parts, Build Capacity, milestones, balance;
- expedition rules: contracts, restoration, encounters, rewards;
- county world: Route Network, chunks, collision, landmarks, sockets;
- Presentation/Feedback: scenes, fonts, icons, audio/VFX handles.

One build-validated always-resident `ShellBootstrapPackage` contains minimal Theme/font plus Title/Continue, Pause/Resume/SystemSheet recovery controls, Settle, `RecoveryApplying`, `PendingRecoveryNotice`, ResumeLoading, SettlementRecovering, and blocking error Presentation. Heavy panels and all other Presentation/audio/VFX payloads remain lazy.

Invariants:

- One scheduler owns every `ResourceLoader.load_threaded_*` request.
- Initial policy starts one resource request at a time with `use_sub_threads = false`. Increase concurrency only after representative desktop and iOS stability/performance proof.
- Status is polled across frames; `load_threaded_get()` is called only after loaded status.
- Resource paths exist only inside the package index and build manifest.
- Background work loads bytes/Resources or pure data. Content promotes leases on main thread and never attaches Nodes. Drive alone attaches live world; each tagged private consumer attaches only its payload.
- Priority is current entry/posture-required world, HUD/warnings/accessibility equivalents, and latency-critical audio; then objective/safehouse and essential horizon; then encounters, decoration, ambience/music, and extra VFX.
- An optional load may start during Drive only when the full essential prediction horizon is already leased and its declared bytes plus measured device-tier p99 load time fit inside that horizon with safety margin. Because Godot exposes no active-load cancellation, queued optional work may cancel but an obsolete active result is taken only after completion and discarded/released. Fault proof injects new essential demand during the largest allowed optional load; failure blocks optional admission or requires a separately approved measured essential-bypass policy.
- `advance` only polls/promotes completed results within `poll_budget_us` and never waits; budget exhaustion returns pending work, not an error.
- Leases are ref-counted, budgeted, never persisted, and never evicted while held; only unleased residency can evict.

Private Implementation:

- metadata index and stable-ID resolution;
- load queue, dedupe, priority, queued-request cancellation, active late-result discard, and hash/version checks;
- package leases, unleased-residency eviction, and memory accounting; held leases cannot be evicted;

Representative errors:

`UNKNOWN_STABLE_ID`, `PACKAGE_MISSING`, `HASH_MISMATCH`, `SCHEMA_UNSUPPORTED`, `DEPENDENCY_MISSING`, `LOAD_QUEUE_FULL`, `THREAD_LOAD_FAILED`, `LEASE_PROMOTION_FAILED`.

### `SaveModule`

~~~gdscript
open(request: SaveOpenRequest) -> SaveOpenResult

submit(request: CommitRequest) -> CommitTicket

advance(io_budget_us: int) -> SaveTransition

recover(request: RecoveryRequest) -> RecoveryResult
~~~

`CommitRequest` contains closed `SaveImageKind` (`PROFILE` or `SETTINGS`), an immutable matching image, expected prior sequence for that kind, reason, and `CRITICAL` or `COALESCIBLE` durability.

Invariants:

- One internal file writer with two independent ordered journals. PROFILE and SETTINGS each have their own schema, sequence namespace, two alternating verified slots, open/recovery result, and expected-prior chain. Critical commits never coalesce or reorder. PROFILE movement checkpoints coalesce only in an owner-local unnumbered slot before request/revision/ticket allocation; writer admission freezes the latest complete snapshot and allocates one ordinary candidate, so no allocated revision/ticket is replaced or skipped.
- Main-thread code captures an immutable snapshot; serialization and file operations never touch live Nodes or Resources.
- Save envelopes carry image kind, schema, build/content versions where relevant, profile ID, monotonic per-kind sequence, checksum, and typed payload.
- Each kind uses two alternating verified slots. Write and validate a temporary for that kind's inactive slot, replace only it, re-read/verify it, then treat its sequence as current. The previous valid slot of that kind is never overwritten by the same commit.
- Open parses both envelopes and ranks checksum-valid candidates by sequence before schema/content compatibility. The highest checksum-valid sequence is authoritative: future schema, unavailable required content, or migration failure blocks with a typed error and never silently falls back. The lower sequence is recovery-only when the higher candidate is incomplete, unparsable, or checksum-invalid. Recovery is disclosed; Save returns a stable recovery/quarantine ID, copies the corrupt higher evidence to diagnostic quarantine without removing its source slot, and leaves that source untouched until the replacement PROFILE notice commit succeeds, so termination before that commit replays the same recovery.
- `DurabilityResult` is a runtime notification, not an on-disk marker. Kill after fully valid replacement/verification but before result/output still selects the higher sequence on boot and reconstructs missed effects; incomplete/unparsable/checksum-invalid candidate selects the prior slot under the recovery rule.
- Migration is explicit, idempotent, preserves the pre-migration verified slot before commit, and is fixture-tested.
- A durability-gated gameplay result remains pending until final `SaveTransition` acknowledgement.
- Low-storage, permission, verification, and deadline failure preserve the last known-good slot.
- A failed SETTINGS chain never blocks, selects, replaces, rolls back, or recovers a PROFILE slot. Corrupt settings are quarantined and may be explicitly reset to declared defaults with a visible notice; active PROFILE state retains its applied policy.
- No filesystem API's rename behavior is assumed sufficient without desktop and physical-iOS fault proof.

Private Implementation:

- schema registry/migration chain;
- serializer/checksum/slot journal;
- per-kind ordered journal scheduling and background file writer if profiling requires it;
- recovery/quarantine and fault diagnostics;
- internal storage Seam.

Representative errors:

`NEW_PROFILE`, `RECOVERED_SLOT`, `FUTURE_SCHEMA`, `CONTENT_VERSION_MISSING`, `NO_VALID_RECOVERY`, `MIGRATION_FAILED`, `SEQUENCE_CONFLICT`, `LOW_STORAGE`, `WRITE_FAILED`, `CHECKSUM_FAILED`, `DEADLINE_EXCEEDED`, `CHAIN_NOT_QUIESCENT`.

`RecoveryRequest` is closed. `CANCEL_OWNER_CHAIN(image_kind, owner, failed_commit_id)` is the explicit-reopen barrier: after the failed head completes, it atomically cancels all held unstarted descendant tickets/output and returns their IDs plus unchanged authoritative sequence. `CHAIN_NOT_QUIESCENT` keeps the shell paused. The owner discards its speculative chain and reopens only after typed success guarantees no canceled ticket can later write. Other branches cover eligible lower-slot recovery and explicit SETTINGS reset without crossing kinds.

Eligible lower-PROFILE `RecoveryResult` returns stable recovery/quarantine IDs, recovered sequence, and conservative higher-active risk. The shell validates recovered active first; Campaign persists `PendingRecoveryNotice`, preserves trusted terminal/nonterminal active, and burns/discards only under no-trusted-matching-active plus `POSSIBLE`. Notice-write failure remains exact-retryable in `RecoveryApplying`; durable notice acknowledgement is idempotent and gates gameplay routing.

## `ApplicationShell` ordering

### Boot

1. Read build identity, Adapter capabilities, and Display Facts.
2. `ContentModule.open_index` validates lightweight metadata only.
3. `SaveModule.open` independently ranks PROFILE/SETTINGS. A blocking PROFILE compatibility error stops; eligible lower-PROFILE recovery returns typed recovery evidence. Corrupt SETTINGS preserves PROFILE and offers reset.
4. Restore Campaign and preferred Settings projections.
5. If `PendingRecoveryNotice` already exists, publish it from bootstrap and require durable acknowledgement. For a new lower recovery, publish `RecoveryApplying`, validate any recovered active/offer binding, and commit notice: preserve trusted terminal/nonterminal active; only no trusted matching active plus `POSSIBLE` burns the recovered current set/discards unverifiable active/outbox/escrow. The corrupt source remains replayable until this commit succeeds. Commit failure or termination stays visible retry/block; success shows the durable notice even after a kill before display. No receipt/resume/Plan routing occurs before the idempotent acknowledgement commits; a kill after acknowledgement boots from the cleared notice.
6. After notice acknowledgement—or with no recovery—inspect pending receipt/active. Publish Settle for receipt, `SettlementRecovering` for terminal active, `ResumeLoading` for nonterminal active, or Title/Continue otherwise.
7. Terminal plan skips Drive and resumes settlement. For nonterminal plan, the shell composes current consumer `EntryLoadPlan` from saved `WorldEntryRequirements`, then loads/attaches until composite `entry_ready` while updating progress.
8. Apply reconciliation, require neutral input, and tick only after `entry_ready`; missing required consumer content is visibly blocked.
9. Publish every transition as immutable model; never hold blank launch.

### Typed intent

~~~gdscript
func dispatch(intent: AppIntent) -> void:
    var transition := route_to_owner(intent)
    submit_durability_request(transition.durability_request)
    apply_runtime_commands(transition.runtime_commands.with_delivery(IMMEDIATE))
    publish(
        transition.pending_read_model,
        transition.feedback_events.with_delivery(IMMEDIATE)
    )
    buffer_after_durability(transition)
~~~

`AppIntent` contains a command ID, expected model revision, a closed intent kind, and stable-ID payload. Stale intents are rejected; Presentation cannot mutate a Module directly.

### Fixed 60 Hz Drive tick

~~~gdscript
func _physics_process(_delta: float) -> void:
    var tick := next_physics_tick()
    var intent := input_source.sample_drive(tick)
    var physical := drive_runtime.step(tick, 1.0 / 60.0, intent)
    var transition := expedition.advance(
        ExpeditionCommand.observe_drive(tick, physical.facts)
    )
    if transition.durability_request:
        var active := expedition.checkpoint(
            drive_runtime.checkpoint(),
            transition.durability_request.commit_id
        )
        save.submit(make_active_commit(
            transition.durability_request,
            campaign.snapshot(),
            active
        ))
    drive_runtime.apply(transition.runtime_commands.with_delivery(IMMEDIATE))
    publish(
        transition.pending_read_model,
        transition.feedback_events.with_delivery(IMMEDIATE)
    )
    buffer_after_durability(transition)
~~~

Ordering is explicit. There is no global bus, arbitrary signal fan-out, or direct feedback mutation of gameplay.

### Durability transaction

1. The owning Module stages a candidate and returns `DurabilityRequest(owner, commit_id, parent_revision, candidate_revision, image_kind, reason, criticality, active_snapshot_disposition)`.
2. `ApplicationShell` passes the nonempty commit ID only to the owning Module. PROFILE Campaign ownership with `PRESERVE_CURRENT` uses `CampaignModule.snapshot(commit_id)` plus current Expedition state; PROFILE Expedition ownership with `INCLUDE_OWNER_CANDIDATE` uses `CampaignModule.snapshot()` plus `ExpeditionModule.checkpoint(DriveRuntimeModule.checkpoint(), commit_id)`; settled active removal requires `REMOVE_COMMITTED_TERMINAL`. SETTINGS ownership uses only the private Settings candidate and requires `NOT_APPLICABLE`.
3. `SaveModule` commits the complete next sequence for the named image kind.
4. The shell returns `DurabilityResult(owner, commit_id, candidate_revision, save_sequence, outcome)` only to the owner. The owner accepts only its commit head. Success promotes that candidate/read model and releases its `AFTER_DURABILITY` output. Failure retains that output with the failed head/descendants, stops that image-kind/owner chain before descendant work, safe-pauses affected gameplay, and exposes exact-head retry or explicit reopen; retry success releases it, while reopen cancels the speculative chain and output.

`SaveModule` expected-prior-sequence checks plus owner parent/candidate revisions form one acknowledgement chain. Wrong-owner, skipped, reordered, or conflicting duplicate results are typed invariant failures. Campaign and Settings serialize user transactions; Expedition may retain a bounded speculative tail behind the commit head so normal driving never waits on disk. Explicit reopen first obtains successful `CANCEL_OWNER_CHAIN`, then discards the matching speculative chain and reconstructs the authoritative image. Queue depth/age are measured and release acceptance requires zero durability backpressure or save-related >50 ms hitch in representative play.

Checkpointable records are maintained incrementally. End-of-tick snapshot calls freeze immutable typed roots through bounded O(1)/copy-on-write capture; they do not serialize, perform I/O, or traverse every live entity inside `_physics_process`. Phase 2 records max-entity capture p50/p95/worst plus allocations, and Phase 3 locks its budget inside the global frame/world gates.

`IMMEDIATE` runtime commands are reconstructable speculative projections tagged with the pending commit ID; they may prevent repeated contact but cannot convey secured value. An explicit reload closes/reopens Expedition and Drive Runtime from the last verified snapshot. Pending/error read models never label candidate value committed.

`ExpeditionProgress` overrides every derivable runtime pickup/socket/objective/encounter projection. If termination occurs after save acknowledgement but before runtime output, restore uses the committed progress to emit ordered idempotent reconciliation commands and applies them to paused Drive before the first tick. A stale runtime checkpoint can therefore never resurrect or duplicate committed value.

### Departure

1. Presentation emits `PrepareDeparture` with expected campaign revision, offer/loadout, full preferred expedition policy, and `SettingsAssistVersion`.
2. Campaign validates offer/loadout plus the full-policy digest/revision and returns domain `PreparedDeparture` with frozen applied policy, world requirements, and domain digest; the shell cannot patch it.
3. The shell composes current locale/quality/settings consumer plans into `EntryLoadPlan`; its payload digest stays separate. The transient ledger routes it and drains on abort.
4. Tagged consumers attach until `entry_ready`: required world collision/terrain/objective, HUD/warnings/accessibility equivalents, and latency-critical engine/warning/interaction audio. Only ambience/music/extra VFX may lag.
5. `ExpeditionModule.open(new PreparedDeparture)` validates/stages the active snapshot and returns an Expedition-owned durability request.
6. Drive activates only after `entry_ready` plus durability acknowledgement. Save failure keeps staged consumers paused/ready for exact-head retry; explicit cancel/reopen drains. If deliberate memory teardown occurs, retry success waits for rebuilt EntryLoadPlan and re-proven entry_ready. Missing required content blocks visibly.

### Settlement

1. `ExpeditionModule` reaches extracted/wrecked/stranded/abandoned and creates a deterministic `SettlementPlan`/`resolution_id`.
2. `SaveModule` commits terminal `ExpeditionProgress` before settlement is actionable.
3. The shell calls `DriveRuntimeModule.close` and routes every withdrawal/release in `RuntimeCloseResult` to Content.
4. `CampaignModule` applies the plan and each retained delta ID exactly once to permanent state, consumes the matching offer set/advances its epoch, and creates deterministic `PendingSettlementReceipt`.
5. `SaveModule` commits retained-delta transfer, permanent changes, offer-set consumption, the pending receipt, and active-snapshot removal together in one verified next sequence.
6. `ApplicationShell` publishes the Settle Receipt only from that durability result. If killed before publication, boot restores the pending receipt and routes to Settle.
7. Leaving Settle sends a durability-gated Campaign acknowledgement; only its successful commit clears the pending receipt.

If step 5 fails, the terminal active snapshot remains recoverable and reapplication is idempotent.

On boot, an already committed terminal active snapshot returns `TerminalResumePlan`; the shell repeats steps 4-7 and never reconstructs or enables Drive. A pending receipt with no active snapshot takes the earlier direct-Settle branch.

### Settings

The private Settings Implementation owned by `ApplicationShell` is the sole owner of preferred `SettingsState`. `SaveModule` persists it in the independent SETTINGS journal. It derives typed `InputAssistConfig`, `CampaignAssistPolicy`, `PreferredExpeditionAssistPolicy`, `PresentationSettings`, and `FeedbackSettings`.

SystemSheet derives `SettingsAssistVersion` from settings revision plus full preferred-policy digest, preflights it with all typed projections, then commits SETTINGS. Post-ack configure is total/idempotent and `SettingsApplying` stays until all match. Campaign stores the shared version beside only its forecast projection. Departure carries full policy/version and Campaign freezes applied policy; active changes use Expedition PROFILE durability.

Private Presentation and Feedback Implementations emit consumer-tagged `ContentDemandDelta` records for lazy scene/font/icon/audio/VFX packages. The shell merges those request/withdraw/release IDs into the sole Content scheduler, delivers ready leases only to the tagged consumer, and requires detach/close-drain before release. The always-resident bootstrap is not part of this lazy ledger.

For Service, Plan, Settle detail, or heavy SystemSheet panels, the shell composes private `PostureLoadPlan` and publishes the target only after required tagged consumers return `posture_ready`. Bootstrap loading/error remains responsive until then; missing required posture content blocks visibly. Minimal Pause/Resume/SystemSheet recovery controls stay resident.

## Narrow Seams and Adapters

A convenient wiring record may group Adapters, but it is not itself an Interface.

| Interface | Operations | Real Implementations | Ownership |
|---|---|---|---|
| `InputSource` | nonmutating preference preflight; total revision-idempotent configure; sample DriveIntent; drain UI intents; clear transient input; report glyph/capability facts | keyboard, controller, touch, scripted replay | Input composition |
| `LifecycleSource` | translate/drain lifecycle notifications | desktop focus/quit, iOS pause/resume/memory/interruption, deterministic test | `ApplicationShell` |
| `DisplayFactsSource` | read safe area, orientation, viewport, scale, quality facts | desktop window facts, iOS safe-area/orientation facts, deterministic fixture | Presentation |
| `HapticOutput` | capabilities, submit semantic cue, stop all | iOS plugin, controller/no-op, recording test | Feedback Implementation |
| `StorageBackend` | candidate reads, inactive-slot commit, quarantine, capacity | Godot `FileAccess`, fault-injecting memory/filesystem | private to `SaveModule` |
| `ResourceLoadBackend` | request, status, take | Godot `ResourceLoader`, deterministic immediate/failure fixture | private to `ContentModule` |
| `ExportTarget` | export/archive/validate | macOS QA export, iOS Xcode archive | build-time only |

Rules:

- One production Implementation plus a test double does not justify a public platform abstraction. `StorageBackend` and `ResourceLoadBackend` are private seams of deep Modules.
- Two genuinely different production Implementations justify `InputSource`, `LifecycleSource`, `DisplayFactsSource`, `HapticOutput`, and build-time `ExportTarget`.
- No gameplay Module sees an OS name or general capability dictionary.
- Do not create cloud, Game Center, telemetry, audio-session, or native accessibility Adapters until scope and feasibility create a second real Implementation.

### Native accessibility gate

Godot 4.7's Control metadata should be populated because it benefits supported platforms and creates semantic discipline. It does not establish iOS VoiceOver.

Run a physical-iPhone feasibility spike over every common posture and representative controls:

- Service comparison/equip;
- Plan AtlasCanvas and RouteLedger equivalents;
- Drive warnings/objective/Fuel/Integrity and touch exploration;
- Settle Receipt;
- focus order, values, actions, live announcements, modal restoration.

If Godot cannot publish a usable iOS accessibility tree, estimate a native plugin. With only one real production path, keep a concrete `IOSVoiceOverBridge` private inside the Presentation Implementation; a recording fixture does not justify a public Seam. Promote it to an `AccessibilityOutput` Interface only after a second real shipping-platform Implementation exists. Otherwise retain the broad non-native baseline and make no VoiceOver claim.

## World loading and content pipeline

### Authoring and bake

~~~text
Typed authored Resources/scenes + source/license metadata
  -> schema/reference/localization/license validation
  -> Route Network and county graph validation
  -> deterministic chunk/collision/socket/package bake
  -> atlas/audio/import and memory/package reports
  -> stable-ID index + dependency hashes + content hash
  -> build manifest + versioned feature packages
~~~

The build-time `ContentCompiler` has one deep operation:

~~~gdscript
compile(request: CompileRequest) -> CompileReport
~~~

It hides validators, incremental bake, hashes, package manifests, license/localization reports, and deterministic output comparison. It is absent from release.

Persistent facts use seed-independent authored IDs. Manifest-scoped runtime IDs combine expedition ID with a stable socket/entity identity. Saves never contain resource paths.

### Runtime

- Boot loads only small metadata/index records plus the bounded always-resident `ShellBootstrapPackage`; Garage and other heavy posture content use consumer-tagged `PostureLoadPlan` lazily.
- Region/world/landmark/encounter/Presentation/audio payloads are lazy packages.
- The bounded shell bootstrap package is always resident; Presentation/Feedback lazy consumers emit tagged demand/withdraw/release deltas merged into the same scheduler.
- `WorldStreamer` privately produces stable package demand; `ContentModule` owns scheduling and leases.
- Loaded package data crosses to the main thread and is delivered only to its tagged Drive, Presentation, or Feedback consumer. Drive alone owns world attachment; each private consumer owns its own payload attachment budget.
- Each rendered frame runs `Content.advance/lease` -> tagged consumer attach/detach -> merge all returned deltas -> route requests to `Content.request`, withdrawals to `Content.withdraw`, and detached lease IDs to `Content.release`. Queued withdrawal removes work; active withdrawal marks a late result obsolete for take-and-discard. The shell tracks consumer/demand ID to ticket but owns no load/spatial policy.
- Before a tagged consumer accepts departure/cold-reopen content, the shell transient ledger tracks demand IDs/tickets/acquired leases. Content/hash/load or consumer-open abort drains all. Accepted leases transfer to that Drive/Presentation/Feedback consumer; each consumer's close-drain then owns cleanup.
- Essential terrain/collision must be ready before entry. While driving, prediction uses position, heading, speed, Route Network adjacency, and dependency metadata.
- If essential data is late, optional work drops first. Tested Streaming Drag is last; blank terrain, invisible walls, teleport, and input freeze are forbidden.

## Save, lifecycle, and resume

### Snapshot triggers

- Permanent campaign: offer-set create before display; epoch consumption/advance with terminal settlement or the guarded no-trusted-active-plus-`POSSIBLE` recovery burn; purchase/fabrication; recovery/settlement acknowledgement.
- Critical active progress: retained observation/cosmetic delta, applied-assist policy, socket consumption, reward/escrow, objective/Pressure branch, pending mutation, terminal transition.
- Coalescible progress: movement/streaming checkpoint at a bounded interval outside spikes.

No authoritative value waits only for a periodic timer.

### Background

1. `InputSource.clear` removes touch/controller state.
2. `ApplicationShell` stops fixed ticks and marks Drive suspended.
3. Audio and haptics stop once.
4. Main thread captures immutable `ExpeditionManifest` + `ExpeditionProgress` + `DriveRuntimeCheckpoint`.
5. `SaveModule` attempts a deadline-bound critical commit.
6. If termination wins the race, cold boot ranks slots normally: a fully checksum-valid higher sequence is authoritative even without prior-process acknowledgement; otherwise the prior verified sequence wins.

Background time never changes Fuel, Vehicle Integrity, Pressure, objectives, rewards, encounter state, or county state.

### Warm foreground versus cold reopen

Warm foreground preserves the suspended live runtime:

1. Validate the in-memory session and process any completed durability result; do not call Save/Expedition/Drive `open` again.
2. Requery safe area, orientation, controller, audio route, and quality facts.
3. Check retained essential leases. Content never evicts a held lease; if deliberate safe-point memory handling explicitly detached an essential, show `ResumeLoading`, request/reattach only that missing lease through the normal frame loop, and remain paused.
4. Require neutral input, restart loops once, and resume the same runtime once.

Cold relaunch after OS termination, or explicit reopen after successful Save cancellation barrier, reconstructs:

1. Run the Boot PROFILE/SETTINGS selection and typed terminal/nonterminal branch.
2. For nonterminal state, derive `DriveRestorePlan` with saved world requirements and persisted applied policy; the shell adds current locale/quality/settings Presentation/Feedback needs to a consumer-tagged `EntryLoadPlan`, then loads/leases it, opens Drive paused, and attaches each package through the normal frame loop.
3. Apply ordered idempotent reconciliation so committed progress overrides derivable runtime projections.
4. Require neutral input; restart loops once and tick only after composite `entry_ready`: required world collision/terrain/objective, Drive HUD/warning/accessibility equivalents, latency-critical engine/warning/interaction audio, and input acknowledgement. Only ambience/music/extra VFX may lag; missing/hash-invalid required consumer content remains a typed blocked state.

On iOS memory warning, ask Drive/Presentation/Feedback to detach optional/horizon content and caches; only after each consumer returns release IDs may Content release/evict them. Current collision/terrain essentials stay pinned, authoritative state is never discarded, and any deliberate safe-point essential detach is recorded for warm reattachment.

## Input and responsive Presentation

- `DriveIntent` is one typed normalized record for keyboard, controller, touch, and replay.
- UI navigation/action input is separate from driving intent.
- Touch supports true simultaneous contacts and clears on lifecycle interruption.
- Presentation consumes one combined immutable `AppReadModel` and emits typed intents only.
- Desktop and iPhone share posture/component scenes and read models. Containers/reflow priorities differ; business rules and screen-specific truth do not fork.
- `DisplayFactsSource` refreshes at launch, orientation/display change, and resume.
- Both landscape orientations are required; iPad remains excluded unless its independent scope gate passes.
- UI and feedback preserve the ticket-04 Animated Road Atlas, County Field Manual, and Semantic Kinetics contract.

## Testing architecture

Test at each deep Module Interface:

| Interface | Required proof |
|---|---|
| Campaign | command/revision/idempotency tables; offer-set epoch/persistence/reservation/guarded recovery-burn/consumption invariance; assist forecast cannot mutate offers; loadout/Build Capacity properties; economy/settlement/pending-receipt/recovery-notice fixtures |
| Expedition | 10,000 manifest/Route Network combinations; retained-delta kill/failure/abandon transfer; applied-policy exact resume/change/failure; activity/Pressure/escrow/terminal state tables; duplicate resolution proof |
| Drive Runtime | live-tree fixed-step integration; 30/60/120 render replay equivalence; collision/surface/recovery; horizon demand/release and essential-attachment ordering; no unbounded scans |
| Content | deterministic bake/hash; demand/ticket/ready-lease routing; request/priority/queued-cancel/late-result-discard/release; hash/version/load failure; no early blocking take |
| Save | independent PROFILE/SETTINGS journals and cross-failure isolation; v0/N-2 migration; alternating-slot recovery; corruption/low-storage; 1,000 interruption/write/settlement/recovery-notice fault points, including kill after save acknowledgement before runtime/receipt release |
| ApplicationShell | posture `posture_ready`/blocked loading; warm foreground without reopen/double loops; stale intent; first visible frame/max-active cold launch; trusted terminal/nonterminal recovery no-burn, no-trusted-active plus `POSSIBLE` burn/discard, recovery write/retry, notice restore/acknowledgement; terminal-active/pending-receipt boot routing; composite `entry_ready`; progress reconciliation; save/loading/error Presentation |
| Adapters | desktop/iOS/test conformance for input/lifecycle/display/haptics |

Rules:

- Godot node tests run in a real live SceneTree on the main thread. Never manually invoke `_ready()` or `_physics_process()`.
- Pure Module tests use typed fixtures and public Interfaces.
- Debug tooling emits typed development-only commands and consumes immutable metrics. It never mutates internal dictionaries.
- Every proof returns nonzero on failure and emits structured JSON/JUnit-compatible evidence.
- A simulation proof is never called a human/manual proof.

## Debug tooling

Development/QA builds provide:

- runtime frame/world/load/save/memory/node/draw/entity/pool/effect/audio metrics;
- seed/manifest/contract/profile fixture selection;
- stable authored teleport anchors;
- encounter/weather/Pressure forcing through typed debug commands;
- handling telemetry and benchmark track;
- catalog/loadout/content-package browser;
- save inspector, migration runner, slot/corruption/lifecycle fault injector;
- keyboard/controller/touch input visualizer;
- aspect/safe-area/text/pseudolocalization gallery and captures.

The build feature gate makes these absent or inert in release.

## Performance ownership

Global acceptance remains authoritative:

- desktop/A15-class: 60 FPS, p95 frame <=16.7 ms, p99 <=25 ms;
- minimum iPhone fallback only if approved: 30 FPS, p95 <=33.3 ms;
- world work p95 <=4 ms;
- no driving hitch >50 ms;
- zero blank terrain, invisible wall, or input freeze;
- Streaming Drag below 1% of high-speed soak frames;
- minimum-iPhone provisional working set <=350 MB and peak <=500 MB;
- stable +/-5% memory plateau after warm-up;
- cold iOS launch <=5 seconds, warm resume <=2 seconds.

Phase 2 records real cost by `CampaignModule`, `ExpeditionModule`, `DriveRuntimeModule`, `ContentModule`, `SaveModule`, Presentation, audio/feedback, and engine remainder. Phase 3 locks explicit sub-budgets/headroom from representative content. Invented microsecond targets are not acceptance evidence.

Each Module publishes immutable metrics:

- command/read projection time;
- fixed-tick rules and physical time;
- spatial queries/entities/pools;
- load queue, active ticket, bytes, residency, attach time;
- save queue age, capture/serialize/write/verify time;
- stale intents, lifecycle sequence, display revision;
- feedback/haptic rejections;
- frame percentiles, memory, nodes, draws, voices.

## Build and language policy

- Retain Godot 4.7, GDScript, and GL Compatibility for the target unless measured production evidence forces a recorded change.
- Do not add C#, GDExtension, a custom engine build, or native iOS gameplay code speculatively. A measured blocker must identify the exact hot Module and requalify desktop, export, save, and physical-device gates.
- Pin the exact Godot executable, export-template hash, project feature version, renderer, and content/save schema in the build manifest.
- Pin a stable Apple-accepted Xcode/SDK and Xcode-supported stable macOS release/build for TestFlight/App Store builds. Beta Xcode or beta macOS can inform forward-compatibility only.
- Commit export presets without secrets. Signing lives in protected keychain/CI state.
- One documented verification command validates tools, imports, catalogs, content hashes, localization/licenses, Module tests, fuzz/fault suites, rendered/full-stack proofs, and the requested export.
- Every archive maps to one tag/commit and retains the exact macOS/Xcode/SDK/Godot/template versions, build/content/save versions, hashes, symbols, tests, licenses, privacy SDK inventory, and device/performance evidence.

## Incremental strangler

1. Characterize the current loop and rename simulation evidence honestly.
2. Add typed IDs, commands, results, read models, and `InputSource` around the existing root without changing behavior.
3. Introduce `SaveModule` and v0 migration; remove direct `ProfileStore` calls.
4. Introduce `CampaignModule` around current profile/Garage/departure rules; remove mirrored permanent state from `GameRoot`.
5. Graduate the accepted fixed-step `CharacterBody2D` proof into `DriveRuntimeModule`.
6. Introduce `ExpeditionModule` as sole Fuel/Vehicle Integrity/Pressure/escrow/terminal authority; remove mirrored run scalars and old `RunProgression` ownership.
7. Add active checkpoint/restore and idempotent settlement before expanding rewards/content.
8. Bake one authored county package; install `ContentModule` and its sole scheduler; replace seed-bearing persistent IDs.
9. Move UI/audio/VFX into snapshot-driven Presentation/Feedback Implementations.
10. Reduce `GameRoot` to `ApplicationShell`, delete every superseded path after its Interface gate, and produce a clean desktop export.
11. Run the bounded signed iOS feasibility check. Formal touch/lifecycle/device adaptation remains after the frozen desktop gate.

Each slice stays launchable. Temporary legacy bridges have an owner and deletion gate; they are migration scaffolding, not target architecture.

## Failure policy

- Stale or duplicate commands do not mutate state.
- Invariant failures assert in development and produce a safe typed failure/recovery posture in release.
- A missing optional package degrades optional Presentation; missing essential collision/objective content blocks departure or pauses at a safe point.
- Save failure never reports secured value. The failed candidate/gated output remain retryable, while the authoritative verified slot remains explicit reopen/recovery authority.
- Corrupt active progress can never bank escrow or improve failure settlement.
- A content version required by an active snapshot cannot be deleted from a compatible update without an explicit migration/recovery decision.
- A platform Adapter failure cannot alter gameplay rules or create unique inaccessible meaning.

## Acceptance

The architecture graduates when:

- `GameRoot` owns no mirrored gameplay fact;
- the five Module Interfaces have public tests and stable typed records;
- all Node/Resource loading and attachment follows the main-thread/single-scheduler contract;
- offer-set creation/consumption, candidate-journal ordering, independent PROFILE/SETTINGS recovery, applied-policy change, departure, nonterminal/terminal resume, settlement receipt, and the exact recovery-notice matrix pass durability faults: trusted terminal/nonterminal no-burn; no-trusted-active plus `POSSIBLE` burn/discard; notice-write failure/retry and kill before notice commit replay the same recovery; kill after notice commit before display/acknowledgement restores it; duplicate acknowledgement is idempotent; and kill after acknowledgement does not restore it;
- the desktop production slice meets full-stack budgets;
- a clean build produces manifest-linked desktop evidence;
- the bounded signed iOS feasibility archive installs/launches without a gameplay fork;
- physical-device capability tests decide safe area, lifecycle, touch, haptics, storage durability, and native accessibility claims.

## Strong recommendation

Use the five deep Modules and thin `ApplicationShell` exactly as the production migration target. It has more Interface surface than a universal kernel, but every Seam follows a real authority/lifecycle and pays for itself in Locality, exact resume, fault testing, and desktop-to-iOS isolation. It has much less surface than the rejected shallow service mesh because economy, ownership, activities, encounters, streaming, feedback, and platform capability checks stay hidden where they change.
