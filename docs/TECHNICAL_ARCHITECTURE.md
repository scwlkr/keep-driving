# Keep Driving Technical Architecture

Status: target architecture for 1.0.0
Architecture date: 2026-07-11
Detailed alternatives, Interface/error contracts, first-party constraints, and failure analysis: [Technical and Mobile Architecture Decision](research/TECHNICAL_AND_MOBILE_ARCHITECTURE.md)

## Architecture goals

The 1.0 architecture must:

- Preserve the current prototype's deterministic and bounded proof strengths.
- Make driving, world, content, progression, presentation, save, and platform behavior independently testable.
- Support a hybrid authored/systemic county and catalog-driven vehicles/parts without hardcoded matches.
- Keep one gameplay code path across desktop and iOS; platform variation belongs behind adapters.
- Protect existing and future saves through stable IDs, schemas, migrations, independent PROFILE/SETTINGS alternating verified-slot journals, and durability acknowledgement.
- Keep content production and validation cheaper than code changes.
- Expose performance budgets and failure evidence early.
- Stay small enough for the project: explicit modules and typed records, not a framework for hypothetical games.

## Current architecture

The current project is a single generated runtime scene:

```text
main.tscn (GameRoot)
└── GameRoot constructs at runtime
    ├── WorldRuntime -> generated TileMapLayer chunks + WorldEntity nodes
    ├── PlayerVehicle
    ├── Camera2D
    ├── CanvasLayer -> HUD, menus, touch buttons
    └── AudioStreamPlayer placeholders
```

`GameRoot` owns application flow, input, UI construction/layout, camera, contact resolution, resource advancement, save calls, audio requests, effects, and automated proof helpers. `RunProgression` is useful characterized rule evidence, `WorldGenerator` is useful characterized pure-generation evidence, and `WorldRuntime` proves bounded streaming; none remains a target authority, and their public dictionaries/duplicated state couple tests to implementation.

Primary conflicts with the target:

- `scripts/game_root.gd` cannot safely absorb map, contracts, ownership/escrow, loadouts, settings, accessibility, lifecycle, localization, and release behavior.
- `scripts/player_vehicle.gd` directly mutates a `Node2D` in variable-delta `_process`; production collision and frame-rate behavior require a new substrate.
- `scripts/world_generator.gd` creates a repetitive four-spoke chunk grammar; the campaign needs an authored macrograph and baked world data.
- `scripts/world_runtime.gd` synchronously generates data and linearly scans/counts entities; production assets and AI need asynchronous loading, spatial queries, lifecycle policies, and real pooling.
- `scripts/run_progression.gd` and `scripts/game_constants.gd` hardcode three upgrades; the target needs stable catalog resources and typed ownership/loadout state.
- `scripts/profile_store.gd` directly overwrites unversioned JSON; release saves require an envelope, alternating verified slots, migration, recovery, and lifecycle rules.
- UI and audio are constructed in the root, preventing reusable scenes, theming, localization, focus navigation, and real asset validation.

## Selected architecture

Use a thin Godot `ApplicationShell` over five deep runtime Modules. The shell owns composition and call ordering, not gameplay truth.

~~~mermaid
flowchart LR
    Host["Input / Lifecycle / Display Adapters"] --> Shell["ApplicationShell\ncomposition and ordering"]
    UI["Presentation Implementation\nService Plan Drive Settle"] <--> Shell
    Shell --> Campaign["CampaignModule\npermanent authority"]
    Shell --> Expedition["ExpeditionModule\nactive authority"]
    Shell --> Drive["DriveRuntimeModule\nphysical authority"]
    Shell --> Save["SaveModule\ndurable authority"]
    Shell --> Content["ContentModule\nstable IDs and packages"]
    Content --> Campaign
    Content --> Expedition
    Content --> Drive
    Content --> UI
    Shell --> Feedback["Audio / Feedback Implementations"]
    Content --> Feedback
    Feedback --> Haptics["HapticOutput Adapter"]
~~~

Do not create a universal game kernel, global command/event bus, public mutable dictionaries, or broad `PlatformService`. Economy, ownership, loadouts, activities, encounters, streaming, and feedback can have private files and tests without becoming public Interfaces. Add a Seam only where it improves Depth and Locality for a real caller.

### Authority

| Fact | Sole live owner | Persisted form |
|---|---|---|
| Posture, screen/session lifetime, save/loading/error presentation | `ApplicationShell` | explicit settings/onboarding only |
| `PersistentCountyState`, `RewardLedger`, Scrap, ownership, presets, offer epoch/current `ExpeditionOfferSet`, pending settlement/recovery notices, Build Capacity validation, records | `CampaignModule` | `PermanentSnapshot` |
| `ExpeditionManifest`, Fuel, Vehicle Integrity, Pressure, applied gameplay/physics assist policy, retained Campaign-delta outbox, activities, encounters, escrow, consumed sockets, pending mutations, terminal state | `ExpeditionModule` | `ActiveExpeditionSnapshot` |
| Vehicle kinematics, collision/recovery filters, active world nodes, spatial index, pools, streaming window | `DriveRuntimeModule` | `DriveRuntimeCheckpoint` |
| Stable-ID index, content/package versions, queue, leases, residency | `ContentModule` | build/content manifest; leases are ephemeral |
| Per-kind committed sequences, independent PROFILE/SETTINGS verified-slot journals, migrations, recovery | `SaveModule` | typed versioned save envelopes |
| Preferred `SettingsState` values | private Settings Implementation owned by `ApplicationShell` | independent versioned `SETTINGS` image through `SaveModule` |
| Focus/layout/animation/component state | Presentation Implementation | not persisted unless promoted to `SettingsState` |
| Safe area, lifecycle, input/device capability | narrow Adapter | never gameplay truth |

One owner per fact does not mean one giant state object. During play, `DriveRuntimeModule` owns physical state. Its latest committed checkpoint becomes resume authority only after relaunch; `ApplicationShell` never mirrors it.

`DriveRuntimeCheckpoint` is a stable-ID-only value containing the physics tick; vehicle position/rotation, linear/angular motion, steering/slip/filter state; last-safe pose and recovery/contact cooldowns; non-progression manifest-scoped entity physics needed for exact reconstruction; deterministic runtime cursors; and required content hashes. It contains no Node, Resource, RID, path, package lease, pool/cache membership, Presentation state, reward eligibility, socket availability, or objective truth. On restore, committed `ExpeditionProgress` is authoritative over every derivable runtime projection: Expedition supplies idempotent reconciliation commands before Drive ticks. Restoring the checkpoint, attaching its essential content, reconciling from the same progress, and applying the next identical `DriveIntent` must produce the same next-tick physical facts within declared numeric tolerance.

## Public Interface contracts

Public records are typed immutable `RefCounted` values or typed definition Resources. A `StableId` is a namespaced immutable `StringName`, never a Node/resource path. Commands carry `command_id` and `expected_revision`. A `DurabilityRequest` carries owner, unique `commit_id`, `parent_revision`, `candidate_revision`, image kind, reason, criticality, and typed `ActiveSnapshotDisposition` (`PRESERVE_CURRENT`, `INCLUDE_OWNER_CANDIDATE`, `REMOVE_COMMITTED_TERMINAL`, or SETTINGS-only `NOT_APPLICABLE`); its result echoes owner/commit/revision plus the per-kind durable save sequence. Errors carry a typed code, stable context IDs, retryability/recovery, localization key/arguments, and a diagnostic ID; Modules do not silently default authoritative state or invent final English copy.

### `CampaignModule`

~~~gdscript
restore(snapshot: PermanentSnapshot, catalog: CampaignCatalogView) -> CampaignRestoreResult
validate_assists(policy: CampaignAssistPolicy, version: SettingsAssistVersion) -> ValidationResult
configure_assists(policy: CampaignAssistPolicy, version: SettingsAssistVersion) -> ConfigureResult
handle(command: CampaignCommand) -> CampaignTransition
read(query: CampaignReadQuery) -> CampaignReadModel
snapshot(commit_id: StringName = &"") -> PermanentSnapshot
~~~

Owns permanent county/profile/economy/ownership rules:

- loadout ownership, slot, compatibility, Build Capacity, stat composition, presets, fabrication, and Scrap transactions;
- restoration/discovery/chassis/blueprint milestones;
- offer-set epoch/selection, route forecast, and the private `ExpeditionManifestBuilder` over lightweight planning metadata;
- idempotent settlement application against `resolution_id` and `RewardLedger`, including retained-delta transfer and durable `PendingSettlementReceipt`.

At offer creation, Campaign commits one immutable set. `PrepareDeparture(offer_id, offer_epoch, loadout_id, preferred_policy, assist_version)` never calls RNG: Campaign requires `SettingsAssistVersion(settings_revision, full_policy_digest)` to match the version stored beside its preflighted forecast projection, freezes applied policy, then binds plan/loadout/resources/policy. Any revision or full-policy digest mismatch returns `SETTINGS_REVISION_CONFLICT`; the shell never patches manifest.

An active manifest reserves its plan; settlement consumes the set. Eligible lower-PROFILE recovery first validates recovered active/offer binding. Trusted terminal/nonterminal active remains reserved. Only no trusted matching active plus `POSSIBLE` higher-active risk burns the recovered current set. Every lower recovery persists `PendingRecoveryNotice`; bootstrap blocks gameplay until acknowledgement.

`CampaignTransition` may then return a `PreparedDeparture` containing the manifest, frozen applied policy, initial progress/checkpoint, policy-derived config, `WorldEntryRequirements`, and domain digest. Campaign never chooses Presentation/Feedback payloads. The shell privately composes `EntryLoadPlan`; Expedition validates/stages the domain value.

Repeated `command_id` returns its prior result. A durable Campaign command stages one ordered candidate snapshot and pending result; it does not replace the committed read model until the matching typed durability acknowledgement returns through `handle`. Campaign serializes user transactions while a candidate is pending. Save failure retains the candidate for explicit retry; explicit revert reloads the last verified image. Settlement becomes committed Presentation truth only after `SaveModule` acknowledgement. The settlement commit persists `PendingSettlementReceipt`; a separate durability-gated acknowledge command clears it only after the player leaves Settle.

Progression, Economy, Ownership, Loadout, and Garage-policy classes are private Implementations, not separate public Interfaces.

### `ExpeditionModule`

~~~gdscript
open(request: ExpeditionOpenRequest, rules: ExpeditionRulesView) -> ExpeditionOpenResult
advance(command: ExpeditionCommand) -> ExpeditionTransition
checkpoint(
    runtime: DriveRuntimeCheckpoint,
    commit_id: StringName = &""
) -> ActiveExpeditionSnapshot
~~~

Owns one immutable `ExpeditionManifest` and mutable `ExpeditionProgress`:

- Fuel, Vehicle Integrity, action-driven Pressure, activity/encounter state, escrow, consumed sockets, pending mutations, terminal state, and `RetainedCampaignDeltaOutbox`;
- Delivery, Recovery, Restoration, and Mastery-overlay rules;
- safehouse/extraction, failure/stranding/abandon, secure storage, and `SettlementPlan` creation;
- exact active resume and idempotent `resolution_id`.

For a new departure, `open(PreparedDeparture)` validates the manifest/initial progress/digest, including the starting `AppliedExpeditionAssistPolicy`, stages the first active snapshot, and returns an Expedition-owned `DurabilityRequest`; it does not enter Drive until acknowledgement. For resume, `open(ActiveExpeditionSnapshot)` is a typed branch: nonterminal progress returns `DriveRestorePlan` with exact policy-derived config/checkpoint/content/reconciliation; terminal progress returns `TerminalResumePlan` with the deterministic `SettlementPlan` and never opens Drive.

`ExpeditionTransition` returns one immutable read model plus typed runtime commands and semantic feedback events marked `IMMEDIATE` or `AFTER_DURABILITY`, an optional `DurabilityRequest`, and an optional terminal settlement plan. Physical contact is only a fact until this Module applies rules. Runtime nodes own no progression truth.

Route/landmark observations and valid activity/trial cosmetic awards do not issue interleaved Campaign writes. Expedition appends typed `RetainedCampaignDelta(delta_id, kind, stable_payload, source_revision, proof_digest)` values to its outbox and critical-checkpoints them. The combined read model overlays acknowledged outbox facts as retained. Material escrow, payouts, parts, blueprints, chassis, and restoration mutations are forbidden outbox kinds. Every terminal settlement, including failure/abandon, transfers each delta exactly once into Campaign using `applied_retained_delta_ids` before active removal.

The manifest never mutates or regenerates. Progress advances once per sequential 60 Hz tick. Each retained observation/cosmetic delta, assist-policy change, socket/reward/objective/Pressure/terminal transition appends a candidate with parent/candidate revisions to Expedition's bounded ordered candidate journal. The **commit head** is the oldest unacknowledged candidate; the **speculative tail** is the newest live state. Fixed ticks continue from the speculative tail while `SaveModule` commits immutable candidates from the commit head in order; acknowledgements promote only that matching head, and `AFTER_DURABILITY` output releases in the same order. A descendant may depend on an earlier candidate but can never overtake it. If the journal reaches its measured capacity, the shell enters a visible safe-point `DURABILITY_BACKPRESSURE` pause before another tick rather than dropping or merging a critical transition; ordinary acceptance proof must show this never occurs. On failure, Save stops that PROFILE owner chain and holds descendant CommitTickets; the failed head, descendants, and their gated output remain while Expedition freezes at the next safe frame. Exact-head retry resumes the same chain; explicit reopen first obtains the Save cancellation barrier, then atomically cancels held tickets/speculative output and restores the last verified snapshot. The independent SETTINGS chain may continue. Periodic movement checkpoints may coalesce only before request/revision/ticket allocation and never across a critical candidate. Terminal progress commits before settlement is actionable.

Activity, Encounter, Reward, Pressure, and Settlement policy classes are private Implementations, not separate public Interfaces.

### `DriveRuntimeModule`

~~~gdscript
open(config: DriveRuntimeConfig, checkpoint: DriveRuntimeCheckpoint) -> DriveOpenResult
step(tick: int, fixed_delta: float, intent: DriveIntent) -> DriveStepResult
apply(commands: Array[DriveRuntimeCommand]) -> ApplyResult
advance_frame(
    frame: RuntimeFrame,
    ready_leases: Array[ContentLease]
) -> RuntimeFrameResult
checkpoint() -> DriveRuntimeCheckpoint
close() -> RuntimeCloseResult
~~~

Owns the live physical Implementation:

- `CharacterBody2D` Arcade-Real Handling at exactly 60 Hz;
- surface/Road Advantage sampling, collision/recovery, and vehicle telemetry;
- authored Route Network projection, `WorldStreamer`, `SpatialWorld`, pools/entity lifetime, and runtime-only effects;
- the only live-world-node instantiate/attach/detach queue and its per-rendered-frame budget;
- reconstructable vehicle/world checkpoint and immutable performance metrics.

`DriveStepResult` returns pose/motion/surface, contacts, interaction candidates, manifest-scoped entity facts, Streaming Drag state, feedback facts, and metrics. It never directly mutates Fuel, Vehicle Integrity, rewards, escrow, activities, or county state.

`RuntimeFrameResult` includes typed `ContentDemandDelta(request_plans, withdraw_demand_ids, release_lease_ids)`, attachment status, and metrics. The private `WorldStreamer` creates demand plans with stable demand ID, package/hash, priority, dependencies, and prediction deadline. A withdrawn demand is identified before a lease exists; after Drive detaches a package, it emits its lease ID for release. `RuntimeCloseResult` returns every remaining withdrawn demand and detached lease ID so departure failure, settlement, reset, and shutdown cannot leak residency. Drive never calls Content directly.

All Interface calls and live SceneTree/physics work occur on the main thread. `step` performs no blocking load, global scene search, or unbounded entity scan. `advance_frame` accepts completed leases, never paths/tickets, and initially attaches at most one world chunk per rendered frame. The Free-Roaming World permits leaving roads; Road Advantage changes speed/grip/risk rather than constraining motion.

### `ContentModule`

~~~gdscript
open_index(identity: BuildContentIdentity) -> ContentOpenResult
request(plan: ContentLoadPlan) -> LoadTicket
withdraw(demand_id: StringName) -> void
advance(poll_budget_us: int) -> ContentTransition
lease(ticket: LoadTicket) -> ContentLeaseResult
release(lease_id: StringName) -> void
~~~

Boot loads metadata and one bounded always-resident `ShellBootstrapPackage`. It contains minimal Theme/font plus Title/Continue, Pause/Resume/SystemSheet recovery controls, Settle, `RecoveryApplying`, `PendingRecoveryNotice`, `ResumeLoading`, `SettlementRecovering`, and blocking error Presentation; heavy panels/payloads remain lazy. Its size/import budget is build-validated.

Package families:

- campaign metadata: chassis, parts, Build Capacity, milestones, balance;
- expedition rules: contracts, restoration, encounters, rewards;
- county world: Route Network, chunks, collision, landmarks, sockets;
- Presentation/Feedback: scenes, fonts, icons, audio/VFX handles.

One scheduler owns every `ResourceLoader.load_threaded_*` call. Initial policy starts one resource request at a time with subthreads disabled; concurrency rises only after representative stability/performance proof. Status is polled across frames and `load_threaded_get()` is called only after loaded status. `ContentModule` never instantiates or attaches live Nodes; it promotes completed Resources into leases on the main thread. `DriveRuntimeModule` alone consumes world leases and owns live attachment.

Priority is current entry/posture-required world, HUD/warnings/accessibility equivalents, and latency-critical audio; then objective/safehouse and essential prediction horizon; then encounters, decoration, ambience/music, and extra VFX. Optional work uses the horizon/p99 margin rule. Active loads cannot cancel; obsolete results finish then discard. `advance` never waits. Held leases never evict; only unleased residency can.

### `SaveModule`

~~~gdscript
open(request: SaveOpenRequest) -> SaveOpenResult
submit(request: CommitRequest) -> CommitTicket
advance(io_budget_us: int) -> SaveTransition
recover(request: RecoveryRequest) -> RecoveryResult
~~~

Owns schema migration, serialization/checksum, one internal file writer over independent PROFILE/SETTINGS ordered journals and alternating verified slots, recovery/quarantine, and fault diagnostics.

- Main-thread code captures immutable typed snapshots; file work never touches live Nodes/Resources or runs inside a physics tick.
- Critical commits never coalesce or reorder. Movement checkpoints coalesce only in an owner-local unnumbered slot before `DurabilityRequest`, revision, or `CommitTicket` allocation; when the writer admits that slot, it freezes the latest complete snapshot and allocates one ordinary candidate. No allocated revision/ticket is replaced or skipped.
- A gameplay result gated on durability remains pending until final acknowledgement.
- Low-storage, permission, verification, and deadline failures preserve the last known-good slot.
- No filesystem rename/flush behavior is assumed sufficient without desktop and physical-iOS fault proof.

The storage backend is a private Seam inside this deep Module.

`RecoveryRequest` is a closed family. Its `CANCEL_OWNER_CHAIN(image_kind, owner, failed_commit_id)` branch is the explicit reopen barrier: it is valid only after the failed head has completed, atomically cancels every held unstarted descendant ticket/output for that owner chain, and returns their IDs plus the unchanged authoritative sequence. A `CHAIN_NOT_QUIESCENT` result keeps the shell paused; no Module discards speculative state or reopens until typed success guarantees that no canceled ticket can later write. Other branches cover eligible lower-slot recovery and explicit SETTINGS reset without crossing image kinds.

Eligible lower-PROFILE `RecoveryResult` carries stable recovery/quarantine IDs, recovered sequence, and conservative higher-active risk. Save copies the corrupt higher evidence to diagnostic quarantine without removing its source slot before a replacement PROFILE commit succeeds; termination before that commit therefore returns the same recovery on next boot. The shell validates any recovered active first. Campaign then commits `PendingRecoveryNotice(recovery_id, quarantine_id, recovered_sequence, loss_action_digest, burned_offer_epoch?)`; trusted terminal/nonterminal active is preserved, while only no trusted matching active plus `POSSIBLE` burns the recovered current set and discards unverifiable active/escrow/outbox. Notice-write failure stays in `RecoveryApplying` with exact retry. Success shows the durable notice, including after a kill before display. Notice acknowledgement is a separate idempotent Campaign durability command; only its acknowledgement may route to receipt, terminal/nonterminal active, or Title/Plan, and a kill after that acknowledgement boots from the cleared notice.

## `ApplicationShell` and Presentation

`ApplicationShell` owns boot, TitleSurface, Preflight, Service/Plan/Drive/Settle posture transitions, SystemSheet/pause, session lifetime, and lifecycle ordering. It routes typed `AppIntent` values to the owning Module, sequences runtime commands/save requests, combines immutable read models, and publishes feedback. It owns no Fuel, Vehicle Integrity, Scrap, kinematics, activity, or settlement copy.

Fixed-step ordering is explicit:

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

There is no arbitrary signal fan-out or global bus.

Rendered-frame content ordering is explicit:

1. `ContentModule.advance(poll_budget_us)` polls/promotes completed loads; the shell takes ready leases for tracked consumer-tagged demand IDs and delivers each only to Drive, Presentation, or Feedback as tagged.
2. `DriveRuntimeModule.advance_frame` owns bounded world instantiate/attach/detach; private Presentation/Feedback content-frame operations own their scene/font/icon/audio/VFX attachment. Each returns a `ContentDemandDelta` for the next frame.
3. The shell merges deltas, forwards request plans to `ContentModule.request`, records consumer/demand-to-ticket, calls `ContentModule.withdraw` for withdrawn demand IDs, and calls `ContentModule.release` only after the owning consumer detached the lease. Queued withdrawal removes work; active withdrawal marks the result obsolete for take-and-discard after completion.

This one-frame feedback loop is covered by the prediction horizon. Content owns scheduling/residency; Drive alone owns spatial demand and live world nodes; Presentation/Feedback own only their private payloads; the shell owns routing only.

Before a tagged consumer accepts departure/cold-reopen content, the shell owns a typed transient demand ledger only: demand IDs, tickets, and acquired lease IDs. Any content/hash/load or consumer-open failure withdraws every outstanding demand and releases every acquired lease. On acceptance, ownership transfers to that tagged Drive/Presentation/Feedback consumer and its close-drain result. No abort path can strand a ticket or lease.

### Durability transaction protocol

`ApplicationShell` composes complete candidate `SaveImage` values from the owning Module snapshot plus the current permanent/active state:

1. The owner stages a candidate and returns `DurabilityRequest(owner, commit_id, parent_revision, candidate_revision, image_kind, reason, criticality, active_snapshot_disposition)`.
2. The shell passes the nonempty commit ID only to the owning Module. A PROFILE Campaign request with `PRESERVE_CURRENT` uses `CampaignModule.snapshot(commit_id)` plus current Expedition state; a PROFILE Expedition request with `INCLUDE_OWNER_CANDIDATE` uses `CampaignModule.snapshot()` plus `ExpeditionModule.checkpoint(DriveRuntimeModule.checkpoint(), commit_id)`; settled active removal requires `REMOVE_COMMITTED_TERMINAL`. A SETTINGS request uses only the private Settings candidate and requires `NOT_APPLICABLE`.
3. `SaveModule` commits the complete next sequence for the named image kind.
4. The shell returns `DurabilityResult(owner, commit_id, candidate_revision, save_sequence, outcome)` only to the owner. The owner accepts only its commit head. Success promotes that candidate/read model and releases only its `AFTER_DURABILITY` runtime/feedback output. Failure retains that output with the failed head and descendants, stops that image-kind/owner chain before descendant work, freezes affected gameplay at the next safe frame, and exposes exact-head retry or explicit reload of the last verified image; retry success releases it, while reload discards it with the speculative chain.

`SaveModule`'s expected-prior-sequence check and each owner's parent/candidate revisions form one ordered acknowledgement chain. Out-of-order, duplicate-with-different-result, skipped-revision, or wrong-owner results are typed invariant failures. Campaign and Settings serialize interactive mutations; Expedition may journal a speculative tail behind the commit head so normal driving never waits on disk. Explicit reopen first obtains successful `CANCEL_OWNER_CHAIN`, then atomically discards the matching speculative chain and reconstructs the authoritative image. Queue depth/age are measured, and release acceptance requires zero durability backpressure or save-related >50 ms hitch in representative play.

Checkpointable records are maintained incrementally during ordinary state changes. The end-of-tick calls shown above freeze immutable typed roots through bounded O(1)/copy-on-write capture; they never serialize, perform file I/O, or walk every live entity in `_physics_process`. Serialization and storage begin afterward. Phase 2 records max-entity capture p50/p95/worst and allocations; Phase 3 locks the capture budget inside the world/frame gates.

`IMMEDIATE` runtime commands are reconstructable speculative projections tagged with the pending commit ID; they may prevent repeated contact but can never convey secured value. If the player explicitly reloads after failure, the shell closes/reopens Expedition and Drive Runtime from the last verified active snapshot. The read model exposes pending/error state and never labels candidate value committed.

`ExpeditionProgress` is authoritative over derivable runtime availability. A committed socket/reward/objective transition may therefore be durable even if termination occurs after save acknowledgement but before its runtime output is applied. Every restore derives ordered idempotent reconciliation commands from committed progress and applies them to the paused Drive Runtime before the first tick; stale pickup, socket, objective, and encounter projections cannot reappear or duplicate value.

Departure is executable through the Interfaces:

1. `CampaignModule.handle(PrepareDeparture)` validates offer ID/epoch, loadout, full preferred expedition policy, and `SettingsAssistVersion` revision/digest against the committed set/forecast projection; it copies the plan unchanged, freezes applied policy, binds only declared starting fields without RNG/reroll, and returns deterministic domain `PreparedDeparture`.
2. The shell composes `WorldEntryRequirements` with current locale/quality/settings Presentation/Feedback plans into consumer-tagged `EntryLoadPlan`; its payload digest is separate from the domain digest.
3. The transient ledger routes that plan; abort withdraws/releases all.
4. Drive opens paused; tagged consumers attach until `entry_ready`: required world collision/terrain/objective, Drive HUD/warnings/accessibility equivalents, and latency-critical engine/warning/interaction audio. Only ambience/music/extra VFX may lag.
5. `ExpeditionModule.open(new PreparedDeparture)` stages the active snapshot and returns an Expedition durability request.
6. Drive activates only after `entry_ready` plus durability acknowledgement. On Save failure, staged consumers remain paused/ready for exact-head retry. Explicit cancel/reopen drains them. If deliberate memory teardown occurs while failed, retry success still waits for rebuilt `EntryLoadPlan` and re-proven `entry_ready`. Missing required content blocks visibly.

Cold relaunch and explicit verified-image reopen use the same essential-content safety gate:

1. `SaveModule.open` selects and verifies the authoritative slot; `ExpeditionModule.open(resume)` returns domain `DriveRestorePlan` with saved world requirements.
2. The shell immediately publishes a visible `ResumeLoading` read model; no heavy package work delays the first launch frame.
3. The shell composes current consumer plans into `EntryLoadPlan`; the transient ledger loads it while bootstrap Presentation updates progress.
4. Drive reconstructs paused state and tagged consumers attach until `entry_ready`, including latency-critical Drive audio; only ambience/music/extra VFX may lag.
5. The shell applies reconciliation, shows the neutral-input overlay, and enables ticks only after `entry_ready` plus input acknowledgement. Missing/hash-invalid required consumer packages remain a typed visible blocked state.

If `ExpeditionModule.open(resume)` instead returns `TerminalResumePlan`, the shell immediately publishes `SettlementRecovering`, never loads/opens Drive, idempotently resumes Campaign settlement from the already committed terminal snapshot, commits permanent deltas plus `PendingSettlementReceipt` plus active removal, and routes to Settle. This covers termination between the two settlement durability steps.

Warm foreground is a different lifecycle path. Background leaves the live Drive Runtime suspended; foreground never calls `SaveModule.open`, `ExpeditionModule.open`, or `DriveRuntimeModule.open` over it. The shell revalidates the in-memory session, re-queries display/input/audio facts, applies completed durability results, and checks retained essential leases. Content never evicts a held lease: memory warnings ask Drive/Presentation/Feedback to detach optional/horizon content first, then route release IDs. Current collision/terrain essentials remain pinned; if deliberate safe-point handling explicitly detached another essential, foreground shows `ResumeLoading` and reattaches only that lease. It then requires neutral input, restores loops once, and resumes the same runtime once. OS termination selects the cold path on next launch; explicit reopen first drains/closes the old runtime after its Save cancellation barrier.

Terminal settlement is two durability steps: commit terminal active progress; drain `DriveRuntimeModule.close()` withdrawals/releases to Content; then stage Campaign's idempotent settlement and commit retained-delta transfer, permanent changes, matching offer-set consumption/epoch advance, `PendingSettlementReceipt`, and active-snapshot removal in one next sequence. If the second durability step fails, the terminal active snapshot remains recoverable and can safely retry the same `resolution_id`/delta IDs. If termination occurs after that commit but before Presentation output, boot finds the pending receipt and routes to Settle; it cannot disappear. Leaving Settle durability-acknowledges and clears the receipt.

Presentation is a private shell Implementation:

- player-facing screens are `.tscn` scenes with Theme resources, localization keys, deterministic focus maps, and responsive rules;
- presenters consume revisioned immutable read models and emit typed intents with expected revision;
- they may choose copy/order/fold/layout, but cannot compose domain stats, decide affordability, roll content, settle escrow, mutate progression, or save;
- AtlasCanvas and RouteLedger consume the same route display model;
- loading/empty/disabled/error/recovery/input-mode states are explicit;
- the ticket-04 component ceiling and gallery contract remain authoritative.

Presentation and Feedback return private `ContentDemandDelta` values for their lazy scene/font/icon/audio/VFX packages. The shell tags each demand with its consumer, merges request/withdraw/release operations into the same Content scheduler, and delivers leases only to that consumer. They detach before release and return close-drain IDs exactly like Drive; the always-resident bootstrap never enters the lazy ledger.

Non-Drive posture transitions have the same readiness rule. The shell composes private `PostureLoadPlan` for Service, Plan, Settle detail, or heavy SystemSheet panels and publishes that target posture only after all required tagged leases report `posture_ready`. Until then the bootstrap renders a responsive loading/error state; missing required content blocks visibly. Minimal Pause/Resume/SystemSheet recovery controls are always available from the bootstrap.

Audio and Feedback Implementations consume deduplicated semantic events plus continuous vehicle state. They own buses, voices, VFX/camera/UI output, cooldown/dedupe, accessibility intensity, and a narrow `HapticOutput` Adapter. They cannot mutate gameplay.

The private Settings Implementation owned by `ApplicationShell` is the sole owner of preferred `SettingsState`. It persists through `SaveModule` as an independent `SETTINGS` image so corrupt/recovered preferences cannot destroy or rewrite a profile. It derives typed `InputAssistConfig`, `CampaignAssistPolicy`, `PreferredExpeditionAssistPolicy`, `PresentationSettings`, and `FeedbackSettings`.

Settings application is ordered. Settings derives `SettingsAssistVersion` from revision plus full expedition-policy digest and preflights it with every projection. Post-ack configure is total/idempotent; `SettingsApplying` remains until all match. Campaign stores that version beside only its forecast projection. Departure carries full preferred policy plus version; Campaign compares both and freezes applied policy. Active changes use Expedition PROFILE durability; boot active progress wins.

## Narrow platform Seams

A composition-root wiring record may group Adapters, but it is not a broad Interface.

| Interface | Real Implementations | Owner |
|---|---|---|
| `InputSource` | keyboard, controller, touch, replay | input composition |
| `LifecycleSource` | desktop focus/quit, iOS pause/resume/memory/interruption, deterministic test | `ApplicationShell` |
| `DisplayFactsSource` | desktop window facts, iOS safe-area/orientation facts, deterministic fixture | Presentation |
| `HapticOutput` | iOS plugin, controller/no-op, recording test | Feedback |
| `StorageBackend` | Godot `FileAccess`, fault-injecting storage | private to `SaveModule` |
| `ResourceLoadBackend` | Godot `ResourceLoader`, deterministic fixture | private to `ContentModule` |
| `ExportTarget` | macOS QA export, iOS Xcode archive | build-time only |

No gameplay Module reads an OS name or general capability dictionary. Do not create cloud, Game Center, telemetry, audio-session, or native accessibility Adapters until scope and feasibility create a second real Implementation.

Godot's iOS screen-reader support is not documented even though Control accessibility metadata exists. Populate semantic metadata, but treat VoiceOver as an explicit physical-device/native-plugin feasibility gate. If it fails, retain the non-native accessibility baseline and make no VoiceOver claim.

Local privacy-minimal structured logs and Apple-provided crash diagnostics are the launch default. A third-party SDK requires a data inventory, retention/deletion/opt-out policy, manifest/signature validation, App Store label update, offline behavior, symbolication proof, and a new decision.

## Save architecture

### Save envelope

```json
{
  "image_kind": "PROFILE",
  "schema_version": 1,
  "build_version": "1.0.0",
  "content_version": 1,
  "profile_id": "local-default",
  "sequence": 123,
  "written_at_utc": "...",
  "checksum": "...",
  "payload": {}
}
```

The payload contains typed/validated sections:

- Profile/chassis/blueprints/discoveries/records plus one namespaced `RewardLedger` as the sole authority for profile/county-socket eligibility/claims/cooldowns, and a persistent repetition ledger.
- Seed-independent `PersistentCountyState` for committed restoration, safehouses, roads, landmarks, and mutations; it holds no duplicate reward-claim state.
- Scrap, unique owned-part IDs, and blueprint/fabrication state with stable catalog IDs.
- Loadout presets.
- Monotonic offer epoch plus the current immutable `ExpeditionOfferSet`, if shown and not consumed.
- `ActiveExpeditionSnapshot` containing the immutable `ExpeditionManifest` plus mutable `ExpeditionProgress` when eligible.
- Active snapshots persist the starting/current `AppliedExpeditionAssistPolicy`; physics-affecting steering/brake/traction values reconstruct `DriveRuntimeConfig` exactly.
- Active progress persists `RetainedCampaignDeltaOutbox`; permanent snapshots persist applied delta IDs so settlement retries cannot duplicate observations/cosmetics.
- Applied terminal `resolution_id` records sufficient to make settlement idempotent.
- Zero or one `PendingSettlementReceipt` with exact outcome, deltas, highlights, and digest until player acknowledgement.
- Zero or one `PendingRecoveryNotice` with recovery/quarantine IDs, recovered sequence, loss/action digest, and optional burned offer epoch until acknowledgement.
- Tutorial/onboarding state.

`SaveImageKind` is closed: `PROFILE` or `SETTINGS`. Each kind has its own schema, monotonic sequence namespace, two alternating verified slots, open/recovery result, and expected-prior-sequence chain. `CommitRequest` names the kind. One internal writer may serialize file work, but a failed SETTINGS chain never blocks, replaces, rolls back, or selects a PROFILE slot. A corrupt SETTINGS image is quarantined and may be explicitly reset to declared defaults with a visible notice; the PROFILE result and any persisted active applied policy remain authoritative.

### Write protocol

1. Build an immutable snapshot on the main thread.
2. Choose the inactive alternating slot; never overwrite the highest checksum-valid sequence in the same commit.
3. Serialize the next sequence to a temporary beside that inactive slot.
4. Flush/close, parse, checksum, and schema/content-validate the temporary.
5. Replace only the inactive slot, then re-read and validate it.
6. Mark the new sequence current in memory. On load, parse both envelopes and rank checksum-valid candidates by sequence before schema/content compatibility; never trust a separate pointer.
7. Surface any failure and preserve the prior valid slot. Quarantine corrupt material for diagnostics.

The highest checksum-valid sequence is authoritative. If it has a future schema, unavailable required content, or a failed migration, surface the typed blocking error and preserve both slots; never silently fall back to an older compatible sequence. Recover the lower sequence only when the higher candidate is incomplete, unparsable, or checksum-invalid, then disclose recovery and quarantine evidence. The alternating-slot journal makes recovery independent of one rename being perfectly atomic: a failed replacement may corrupt the inactive candidate, but it cannot overwrite the current valid slot. Desktop and physical-iOS fault tests must still prove the actual `FileAccess`/`DirAccess` behavior. Never silently replace a corrupt profile with defaults.

Durability acknowledgement is a runtime notification, not an on-disk commit marker. If termination occurs after a higher slot became fully checksum-valid but before re-read/`DurabilityResult`/output, next boot still ranks normally and that higher sequence is authoritative; restore/reconciliation/receipt routing supplies the missed output. If the candidate is incomplete, unparsable, or checksum-invalid, the prior slot wins under the disclosed recovery rule. Fault injection includes the window after replacement and after verification but before owner acknowledgement.

### Migration

- Migration chain is explicit and fixture-tested: `v0 -> v1 -> ...`.
- Ship fixtures for the current `keep_driving_profile_v0.json`, at least N-2 release schemas, corrupt/truncated/unknown-field cases, max/min values, and removed catalog entries.
- Unknown future fields are retained when safe or ignored without erasing the save.
- Removed catalog content maps to a documented equivalent/refund.
- Migration preserves the pre-migration verified slot before commit and is idempotent.

### Autosave and resume

- Permanently commit offer-set creation before display, epoch consumption/advance with terminal settlement or the guarded no-trusted-active-plus-`POSSIBLE` recovery burn, profile/county truth on safehouse/Garage extraction, recovery/settlement acknowledgement, and purchase/fabrication transactions. Field objective/restoration milestones only checkpoint pending `ExpeditionProgress` until extraction.
- Durability-gate `ExpeditionProgress` before or with every retained observation/cosmetic delta, socket consumption, reward/escrow change, objective/Pressure-branch transition, applied gameplay/physics assist change, and pending mutation. Presentation may batch; authoritative value cannot wait for a periodic timer.
- A periodic expedition checkpoint may save at a bounded interval outside collision/streaming spikes.
- Background/interruption requests an immediate bounded snapshot. On termination, cold boot ranks slots normally: a fully checksum-valid higher sequence is authoritative even if owner acknowledgement never ran; otherwise the prior verified slot wins. Background-time shortage never relies on an in-memory pointer.
- Resume restores trusted active state exactly. Eligible lower-slot recovery validates recovered active first, then durability-persists `PendingRecoveryNotice`: trusted terminal/nonterminal active remains reserved; only no trusted matching active plus `POSSIBLE` risk discards unverifiable active/outbox/escrow and burns the recovered current set. Bootstrap shows/acknowledges the notice before Settle/resume/Plan. Future schema/content/migration failure on highest checksum-valid remains blocked.
- Manual save slots are not required for 1.0. Reset, eligible lower-slot recovery, and debug import/export are required.

### Cloud readiness

Save identity, monotonic sequence, timestamps, content/schema version, and conflict semantics are defined without implementing cloud synchronization. Optional iCloud support is Valuable if Capacity Allows and requires real conflict-resolution/device testing. Local play never depends on cloud availability.

## World-loading strategy

### Runtime priority

1. Collision and base terrain for the player's current/predicted path.
2. Objective/landmark and safehouse state.
3. Essential encounter entities.
4. Decoration and ambient entities.
5. Optional VFX/detail.

### Provisional budgets

- One main-thread chunk attach per frame maximum until profiling proves a safer budget.
- World work p95 at or below 4 ms on desktop truth/full-stack proofs.
- Zero blank terrain, invisible-wall, or teleport fallback frames.
- Streaming Drag below 1% of frames in a 30-minute high-speed soak.
- Active/preload window and memory are based on device profiling; current 25/49 contract is a starting comparison, not a permanent content mandate.
- Active nodes, pooled entities, effects, draw calls, texture memory, and audio voices have explicit debug counters and caps.

## Content pipeline

### Source-to-runtime flow

```text
Authored Godot scenes/resources + source/license metadata
  -> style/readability review + deterministic export/import presets
  -> catalog/world/license/budget validators
  -> bake atlases, chunk packages, collision, route graph, localization references
  -> deterministic content hash + build manifest
  -> runtime ContentModule index and versioned package leases
  -> save references by stable ID
```

### Validation requirements

- Stable IDs unique and immutable after release.
- All references resolve.
- Every player-facing string has a localization key.
- Parts meet capability/tradeoff and benchmark metadata rules.
- Contracts have start, success, failure, resume, reward, and extraction definitions.
- Event sockets meet reaction-distance/navigability rules.
- Assets record license/ownership, import settings, atlas group, memory class, and platform compression.
- Presentation assets have universal best-available source/runtime artifact, creator/provenance/license/attribution/review, import version, package/memory class, and status metadata. Kind-specific extensions cover spatial/palette/atlas/collision/quality, UI/localization/alternative, audio format/bus/concurrency, or VFX/pool/accessibility facts only where meaningful. Hero proof/cost/rework is per asset; routine variants report by batch/tranche; defects link issue IDs only when present.
- Content budgets generate a report per region/build.
- The release build contains no debug-only, placeholder, unlicensed, or missing asset.

## Localization

- All strings use Godot translation resources/keys from the first production UI shell.
- No player-facing text assembled from English fragments.
- Number, percentage, unit, time, and plural formatting are localized.
- UI proof runs English, pseudolocalization (+40% expansion), and right-to-left stress layout even if RTL language is not a launch promise.
- Fonts define fallback coverage for supported languages.
- Store metadata languages must match in-game support.

## Testing architecture

### Evidence layers

| Layer | Purpose | Gate |
|---|---|---|
| Unit/domain | Campaign, expedition, content/schema, migration, deterministic generation | Every change |
| Scene integration | Drive Runtime, Presentation, Content/Save, and real Adapter interactions | Every affected slice |
| Seed/property fuzz | 100+ seeds, 1,000+ world transitions, event eligibility, save ranges | World/content changes |
| Rendered capture | Real scenes, assets, layout/aspect, visual state, audio resource/state | Presentation changes |
| Full-stack performance | Release-like world, vehicle, collision, AI, UI, audio, VFX | Each milestone and content lock |
| Human desktop playtest | Comprehension, handling, enjoyment, pacing, economy | Every player-facing phase |
| Release desktop export | Clean export, install/launch/update, no debug paths | Alpha onward |
| iOS simulator | Layout/basic compatibility only | Mobile phases |
| Physical iOS device | Touch, haptics, audio, frame/memory/thermal/battery/lifecycle/save | Every mobile milestone |
| TestFlight | Install/update, metrics, external devices, review readiness | Beta/RC |

Rename the current automated `manual_smoke_proof` to `loop_simulation_proof`; simulation cannot satisfy a human manual gate.

### Test rules

- Tests use deep Module Interfaces or the exact real Adapter contract, never production public dictionaries.
- Avoid manually invoking `_ready()` after adding a node to a live tree.
- Every bug fix gets the smallest regression at the correct layer.
- Performance comparisons store device, build flavor, commit, scene, duration, warm-up, p50/p95/p99, peak memory, and worst-frame evidence.
- Proof scripts return non-zero on failure and emit structured JSON/JUnit-compatible artifacts for CI.
- Save/lifecycle faults include ordered multi-candidate acknowledgement/failure/backpressure, offer creation, observe/award then kill/failure/abandon retained-delta transfer, termination between terminal-progress and Campaign-settlement commits, and termination after durability acknowledgement but before runtime/feedback/receipt release. The lower-PROFILE matrix separately proves trusted nonterminal and terminal active preserve/reserve without burn; no trusted matching active plus `POSSIBLE` burns/discards once; notice-write failure/retry and kill before notice commit repeat the same recovery; kill after notice commit before display/acknowledgement restores the notice; duplicate acknowledgement is idempotent; and kill after acknowledgement does not restore it. Prove exactly-once permanent retained deltas, the same offer, terminal/pending-receipt Settle routing, and composite essential-content restore plus progress-driven reconciliation before the first nonterminal tick.

## Debug tooling

Development-only tools:

- Runtime overlay: FPS/frame percentiles, stream work, memory, nodes, draw calls, collision queries, entities/pools, effects, audio voices, seed/chunk/event.
- Seed/region/contract selector and deterministic restart.
- Teleport to safe authored debug anchors.
- Encounter/weather/time forcing.
- Vehicle handling telemetry and standard benchmark track.
- Catalog/part/loadout browser and benchmark matrix.
- Save inspector, migration runner, corruption/interruption fault injector, and profile presets.
- Input visualizer for keyboard/controller/touch multi-contact.
- UI safe-area/aspect/text-scale/pseudolocalization preview.
- Automated screenshot/capture points.
- QA-only iOS thermal/battery sampler implemented as a private concrete plugin and cross-checked with Xcode Instruments; it is not a gameplay Seam.

All tools are guarded by build feature flags and absent/inert in release archives.

## Desktop/mobile separation

### Shared

- `CampaignModule`, `ExpeditionModule`, `DriveRuntimeModule`, `ContentModule` package schemas, and `SaveModule` schemas.
- `DriveIntent`, typed UI intents, immutable read models, and component scenes.
- Responsive layout rules and content.
- Performance instrumentation and test semantics.

### Narrow platform Adapters

- `InputSource`: keyboard, controller, touch, replay.
- `LifecycleSource`: desktop focus/quit and iOS pause/resume/memory/interruption.
- `DisplayFactsSource`: safe area, orientation, viewport, scale, and quality facts.
- `HapticOutput`: iOS plugin, controller/no-op, recording proof.
- Build-time `ExportTarget`: desktop export versus iOS Xcode archive/signing.
- Platform package compression, quality tier, and frame cap are data/build choices, not gameplay forks.

Storage and resource loading remain private Seams inside `SaveModule` and `ContentModule`. Do not fork gameplay into `desktop_game.gd` and `mobile_game.gd`. The mobile phase adapts sources, Presentation priority, quality, and lifecycle behind stable shared contracts.

## Build pipeline

### Local contract

One documented command should:

1. Verify Godot/Xcode/tool versions where relevant.
2. Import/parse the project cleanly.
3. Validate catalogs, localization, source/licenses, and baked world hashes.
4. Run unit/integration/fuzz suites appropriate to the build.
5. Run or schedule rendered/full-stack proof.
6. Export desktop debug/release or iOS Xcode project using committed presets.
7. Embed semantic version, monotonically increasing build number, commit SHA, content/schema version, and release/debug flags.
8. Produce a build manifest, hashes, symbols, logs, and test evidence.

The manifest pins the exact Godot executable and export-template hash. TestFlight/App Store archives also pin an Apple-accepted stable Xcode/SDK pair and its Xcode-supported stable macOS release/build; beta Xcode or beta macOS evidence is forward-looking or bounded feasibility evidence only.

### CI

- Fast tests and validators on every change.
- Nightly seed fuzz, save faults, full-stack performance, and soak.
- Tagged release pipeline on a controlled Xcode-supported stable macOS runner; its exact OS build is recorded with every archive.
- iOS export/archive/signing secrets remain in protected keychain/CI storage, never repository files.
- Every TestFlight/App Store build maps back to one tag/commit and evidence bundle.

### Release flavors

- Development: debug tools, assertions, local telemetry export, no production signing.
- QA: release-like optimization plus approved diagnostics/test hooks.
- Release: no cheats/debug UI/placeholders; privacy-reviewed SDK set; production identity/signing.

## Performance strategy

### Desktop targets

- Release build: 60 FPS minimum, p95 frame at or below 16.7 ms, p99 at or below 25 ms.
- World work p95 at or below 4 ms.
- No driving hitch above 50 ms in a representative 30-minute run.
- Zero blank terrain or unintentional input stall.
- Memory reaches a plateau within plus/minus 5% after warm-up during a two-hour traversal soak.

### iOS provisional targets

- 60 FPS target on supported A15-class and newer devices.
- Explicitly approved sustained 30 FPS fallback on the minimum device; p95 at or below 33.3 ms.
- Gameplay working set target at or below 350 MB and process peak at or below 500 MB until physical-device evidence tightens the budget.
- Cold launch at or below five seconds; background resume at or below two seconds, target one second.
- Thirty-minute thermal soak without serious sustained throttling or forced quality collapse.
- Battery, storage, and asset/package budgets set from physical baselines before content lock.

### Optimization order

1. Measure release-like content and worst frames.
2. Remove algorithmic/scaling cost and synchronous work.
3. Reduce node/draw/material/physics/audio-voice cost through batching, spatial queries, pooling, and priority.
4. Tune texture/audio compression and quality tiers.
5. Reduce optional density/effects before core readability, collision, objective, or save correctness.

Phase 2 records cost by deep Module, Presentation, audio/feedback, and engine remainder. Phase 3 locks explicit sub-budgets and headroom from representative content; invented micro-budgets are not acceptance evidence.

## Migration sequence from the prototype

1. **Characterize:** freeze current loop behavior with public-contract tests and rename simulation evidence honestly.
2. **Type the Interface:** add stable IDs, typed commands/results/read models, and `InputSource` around the existing root without changing behavior.
3. **Make durability real:** introduce `SaveModule` and v0 migration; remove direct `ProfileStore` calls.
4. **Extract permanent truth:** introduce `CampaignModule` around profile/Garage/departure rules; remove mirrored permanent facts from `GameRoot`.
5. **Graduate driving:** move the accepted fixed-step `CharacterBody2D` path into `DriveRuntimeModule`.
6. **Extract active truth:** introduce `ExpeditionModule` as sole Fuel/Vehicle Integrity/Pressure/escrow/terminal authority; remove mirrored run scalars and old `RunProgression` ownership.
7. **Prove resume/settlement:** add active checkpoint restore and idempotent terminal settlement before expanding rewards/content.
8. **Bake the county:** install `ContentModule` and its sole scheduler, then migrate to stable authored IDs, packages, spatial queries, and pools.
9. **Move Presentation:** replace runtime UI/audio/VFX construction with immutable read models, typed intents, and semantic feedback.
10. **Delete the root:** reduce `GameRoot` to `ApplicationShell`, delete each superseded path after its Interface proof, and produce the clean desktop export.
11. **Prepare mobile:** reproduce the bounded signed feasibility result; formal touch/lifecycle/device adaptation begins only after the frozen desktop gate.

Avoid a flag-day rewrite or dual writes. Each step keeps a launchable desktop build and removes the superseded Implementation when its Interface passes.

## Technical definition of done

- Module ownership and authority match this document or a recorded replacement decision.
- The five deep Module Interfaces, private Presentation/Feedback contracts, Settings projections, and real platform Adapters have public-contract tests.
- Every authoritative fact has exactly one live owner and no mirrored `GameRoot` copy.
- No player-facing system depends on mutable public dictionaries or `GameRoot` internals.
- SceneTree/resource loading obeys the main-thread and single-scheduler contract.
- Clean-clone local and CI verification/export are reproducible.
- Full-stack desktop evidence uses representative production content and meets budgets.
- Save migration, alternating-slot recovery, durability, exact resume, idempotent settlement, and fault gates pass.
- Mobile entry occurs only after corresponding desktop gates; supported physical devices meet declared budgets.
- Tagged 1.0.0 archive, symbols, manifest, exact App Store build, and evidence are retained.
