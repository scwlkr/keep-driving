# Decide Target Technical And Mobile Architecture

Type: research
Status: resolved
Blocked by: 01, 03, 04

## Question

What target Godot architecture, module boundaries, data flow, world loading, content pipeline, save/versioning, input, responsive UI, test/debug tooling, performance budgets, build pipeline, and desktop-to-iOS separation can carry the selected 1.0 design safely?

## Answer

Select a thin Godot **ApplicationShell over five deep Modules**:

1. **CampaignModule** owns `PersistentCountyState`, `RewardLedger`, Scrap, ownership, Build Capacity/loadout rules, departure, and settlement application.
2. **ExpeditionModule** owns the immutable `ExpeditionManifest` and mutable `ExpeditionProgress`: Fuel, Vehicle Integrity, Pressure, activities/encounters, escrow, pending mutations, failure/extraction, and idempotent `resolution_id`.
3. **DriveRuntimeModule** owns the fixed-60-Hz `CharacterBody2D` vehicle, physical Free-Roaming World, Road Advantage/Route Network sampling, streaming, spatial queries, entities/pools, and reconstructable `DriveRuntimeCheckpoint`.
4. **ContentModule** owns stable-ID metadata/package leases and the only runtime threaded-load scheduler.
5. **SaveModule** owns schema migration, ordered durability, independent PROFILE/SETTINGS two-slot journals with per-kind sequences, recovery/quarantine, and exact-resume images.

`ApplicationShell` owns Service/Plan/Drive/Settle posture, Module lifetime, call ordering, lifecycle sequencing, and immutable read-model publication only. Presentation/Audio/Feedback are shell Implementations. It must not own or mirror Fuel, Vehicle Integrity, Scrap, kinematics, activity, or settlement truth.

Reject both extremes:

- no universal `GameKernel` that recreates `GameRoot` behind three calls;
- no mesh of public Progression/Economy/Ownership/Loadout/Activity/Encounter/World services.

Those policies stay private inside their deep owning Module. There is no global command/event bus or public mutable Dictionary.

### Data flow and authority

- Typed commands carry `command_id`, expected revision, closed kind, and stable-ID payload.
- Module transitions return an immutable read model, bounded runtime commands, deduplicated semantic feedback events, and optional durability/terminal requests. `DurabilityRequest` names owner, commit ID, parent revision, and candidate revision; the nonempty ID is passed only to that Module. Campaign/Settings serialize user mutations. Expedition's commit head is the oldest unacknowledged candidate and its speculative tail is current live state; Save commits from the head in order while ticks continue from the tail. Failure holds descendant tickets/output and safe-pauses. Exact-head retry resumes; explicit reopen first requires successful `CANCEL_OWNER_CHAIN`, proving held tickets cannot write, then discards the speculative chain. Capacity backpressure pauses visibly rather than dropping a critical transition.
- Runtime/read-model/feedback output is explicitly `IMMEDIATE` or `AFTER_DURABILITY`. Immediate output is a reconstructable pending projection and never claims secured value; commit-gated output releases only on success. Failure retains the candidate, blocks dependent transitions, and offers retry or explicit reopen from the last verified image.
- The shell executes one explicit fixed-tick order: sample `DriveIntent` -> step Drive Runtime -> reduce physical facts in Expedition -> capture/submit any requested durability candidate -> apply only `IMMEDIATE` reconstructable runtime commands -> publish pending model/feedback -> release `AFTER_DURABILITY` output only on acknowledgement.
- Physical contact never directly changes Fuel, Vehicle Integrity, rewards, escrow, activities, or county state.
- Settings shares `SettingsAssistVersion(revision, full-policy digest)` across projections. PrepareDeparture carries full preferred policy/version; Campaign rejects mismatch and freezes applied policy into manifest/progress/config/domain digest without reroll. Shell separately composes EntryLoadPlan; composite entry_ready plus durability gates activation.
- Observations and valid activity/trial cosmetics critical-checkpoint into Expedition's typed retained-delta outbox instead of interleaving Campaign writes; the combined model shows acknowledged deltas as retained. Every terminal outcome transfers their IDs once into Campaign. Terminal progress commits before settlement; `TerminalResumePlan` never opens Drive and idempotently resumes retained transfer, `resolution_id`, permanent deltas, active removal, offer-set consumption, and `PendingSettlementReceipt` together.

### World loading and content

- Author typed county/region/Route Network/landmark/socket/content Resources with seed-independent stable IDs.
- A build-time `ContentCompiler.compile` validates references/localization/licenses/budgets and deterministically bakes versioned county/collision/package data plus hashes/manifests.
- Boot loads metadata plus one bounded always-resident shell package containing Title/Continue, Pause/Resume/SystemSheet recovery controls, Settle, `RecoveryApplying`, `PendingRecoveryNotice`, `ResumeLoading`, `SettlementRecovering`, and blocking error Presentation. Heavy world and Presentation/audio payloads are lazy; private Presentation/Feedback emit consumer-tagged demand/withdraw/release deltas merged into the same Content scheduler.
- One ContentModule scheduler initially starts one `ResourceLoader` request at a time with subthreads disabled, polls across frames, calls `load_threaded_get()` only after completion, and hands leases to main-thread Implementations.
- Content never attaches Nodes. Drive owns live-world attachment; tagged Presentation/Feedback consumers own only their payloads. Before consumer acceptance, shell transient ledger drains aborts; afterward each consumer close-drains. Render frames route ready leases by consumer and merge all request/withdraw/release deltas into Content.
- Because an active Godot load cannot cancel, optional work starts during Drive only when the essential prediction horizon is full and declared bytes/measured p99 load time fit with margin. Queued work may cancel; obsolete active results are discarded after completion.
- Entry-required collision/terrain/objective, Drive HUD/warning/accessibility equivalents, and latency-critical engine/warning/interaction audio outrank encounters, decoration, ambience, music, and extra effects. Tested Streaming Drag is the last fallback; blank terrain, invisible walls, teleport, or input freeze are forbidden.

### Save/versioning and lifecycle

- Each save envelope carries image kind, schema/build/content versions, identity, its kind's monotonic sequence, checksum, and typed payload: permanent plus optional active state for PROFILE, preferred settings for SETTINGS.
- Write the next sequence to a temporary for the inactive slot; flush/parse/checksum/validate; replace/re-read only that slot. Open ranks checksum-valid candidates by sequence before compatibility. Future schema/content/migration failure on the highest sequence blocks visibly; only incomplete/unparsable/checksum-invalid higher data permits disclosed lower-slot recovery. Never overwrite the current valid slot in the same commit.
- Eligible lower-PROFILE recovery copies corrupt higher evidence to diagnostic quarantine without removing the source slot before a replacement commit. It preserves trusted terminal/nonterminal active state; only no trusted matching active plus `POSSIBLE` higher-active risk burns/discards once. Campaign durability-persists `PendingRecoveryNotice` before any later route; failure/kill replays recovery, kill after commit restores the notice, and only idempotent acknowledgement clears the gate.
- Critical socket/reward/objective/Pressure/terminal/purchase/settlement commits never coalesce or reorder. Movement checkpoints coalesce only in an unnumbered owner slot before request/revision/ticket allocation; no allocated candidate is replaced or skipped.
- Background clears input, stops ticks/audio/haptics, captures immutable state, and attempts a bounded critical commit. If termination races acknowledgement, cold boot ranks slots normally: a fully checksum-valid higher sequence wins even if prior output never ran; otherwise the prior verified slot wins and recovery is disclosed.
- Warm foreground reuses the suspended runtime, reattaches only an essential explicitly detached at a deliberate safe point, and resumes loops/ticks once after neutral input—never reopens Modules. Cold relaunch runs Save selection, recovery-evidence/notice gating, terminal or nonterminal `ExpeditionModule.open`, composite consumer attachment, progress reconciliation, and neutral acknowledgement. Explicit verified-image reopen first requires successful `CANCEL_OWNER_CHAIN`, then follows the same selection path. A kill after save acknowledgement but before runtime output cannot restore consumed value.

### Desktop-to-iOS separation

Use narrow per-consumer Adapters:

- `InputSource` — keyboard, controller, touch, replay;
- `LifecycleSource` — desktop focus/quit versus iOS pause/resume/memory/interruption;
- `DisplayFactsSource` — safe area/orientation/viewport/quality facts;
- `HapticOutput` — iOS plugin, controller/no-op, recording proof;
- build-time `ExportTarget` — desktop QA export versus iOS Xcode archive.

Storage/resource-load backends remain private Seams inside Save/Content. No gameplay Module sees an OS name or broad capability Dictionary. Cloud, Game Center, telemetry, audio-session plugins, and native accessibility get no public Adapter until approved scope plus real Implementations justify one.

Godot 4.7 exposes Control accessibility metadata but does not document iOS screen-reader support. Populate metadata, preserve the ticket-04 non-native baseline, and run a physical-iPhone common-task VoiceOver/native-plugin spike before promising or architecting a native claim.

### Input, responsive UI, testing, and debug

- One typed normalized `DriveIntent` serves keyboard/controller/touch/replay; UI navigation remains separate.
- The same posture/component scenes and immutable read models reflow across desktop/iPhone. No `desktop_game.gd`/`mobile_game.gd` fork.
- A private Settings Implementation owns preferred `SettingsState` in an independent `SETTINGS` journal. SystemSheet pauses, preflights every typed projection, commits, then runs total revision-idempotent configure calls and stays `SettingsApplying` until all consumers match—never mixed. Departure copies gameplay/physics values into `AppliedExpeditionAssistPolicy`; mid-expedition changes are Expedition PROFILE candidates whose ack reconfigures Drive. Active progress, never recovered settings, controls exact resume.
- Test at the five deep Module Interfaces; run Godot Node tests in a live main-thread SceneTree, never by manually invoking lifecycle callbacks.
- Required proof includes 30/60/120 render equivalence at fixed 60 Hz, 10,000 manifest/Route Network combinations, offer-set invariance, retained-delta exactly-once transfer, independent PROFILE/SETTINGS recovery plus active-policy resume, v0/N-2 migrations, and 1,000 save/lifecycle faults. Recovery faults cover trusted terminal/nonterminal no-burn, no-trusted-active plus `POSSIBLE` burn/discard, notice-write failure/retry, kill before notice commit, kill after notice commit before display/acknowledgement, duplicate acknowledgement, and kill after acknowledgement; other proof covers both settlement steps, ack-before-output kills, candidate-journal ordering/backpressure, content demand/withdraw/close/hash/load failures, and Adapter conformance.
- Debug tools issue typed development-only commands and consume immutable metrics; they never edit production dictionaries and are absent/inert in release.

### Performance and build

- Preserve canonical global gates: desktop/A15 60 FPS, p95 <=16.7 ms/p99 <=25 ms; approved minimum-iPhone 30 FPS p95 <=33.3 ms; world p95 <=4 ms; no >50 ms driving hitch; Streaming Drag <1%; provisional iPhone working set <=350 MB/peak <=500 MB; cold launch <=5 seconds; resume <=2 seconds.
- Phase 2 measures actual cost by Module/Presentation/audio/engine; Phase 3 locks sub-budgets and headroom from representative content instead of invented micro-budgets.
- Retain Godot 4.7, GDScript, and GL Compatibility until a measured blocker and recorded decision requalify desktop/export/save/device gates.
- Pin the exact Godot executable and export-template hash. The current Xcode 27 beta and beta macOS host are feasibility/forward-looking evidence only; TestFlight/App Store builds require a pinned Apple-accepted stable Xcode/SDK pair on an Xcode-supported stable macOS release/build plus a live upload-floor check.
- One clean-clone verification command imports, validates, bakes, tests/fuzzes/faults, exports, and emits manifest-linked hashes/symbols/licenses/privacy/toolchain/evidence.

### Incremental migration

Type the existing Interface -> introduce Save/v0 migration -> extract Campaign -> graduate fixed-step Drive Runtime -> extract Expedition/remove mirrored run scalars -> prove resume/settlement -> install Content scheduler/authored packages -> move Presentation/Feedback -> reduce `GameRoot` to `ApplicationShell` -> delete each replaced path. Never dual-write legacy/new authority or perform a flag-day rewrite.

Detailed first-party evidence, three Interface alternatives, exact contracts/errors, sequencing, and failure policy: [`docs/research/TECHNICAL_AND_MOBILE_ARCHITECTURE.md`](../../../docs/research/TECHNICAL_AND_MOBILE_ARCHITECTURE.md). Canonical contracts: [`docs/TECHNICAL_ARCHITECTURE.md`](../../../docs/TECHNICAL_ARCHITECTURE.md), [`docs/MOBILE_PORTING_PLAN.md`](../../../docs/MOBILE_PORTING_PLAN.md), decisions D035-D040 in [`docs/DECISIONS.md`](../../../docs/DECISIONS.md), and phase ordering in [`docs/ROADMAP_TO_1.0.md`](../../../docs/ROADMAP_TO_1.0.md).
