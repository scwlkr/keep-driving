# Keep Driving Mobile Porting Plan

Status: desktop-to-iOS plan for 1.0.0
Plan date: 2026-07-11
Architecture decision and first-party constraints: [Technical and Mobile Architecture Decision](research/TECHNICAL_AND_MOBILE_ARCHITECTURE.md)
Release/device gate decision: [Playtest, Release, and App Store Gates](research/PLAYTEST_RELEASE_AND_APP_STORE_GATES.md)

## Principle

Mobile is a dedicated adaptation and release program, not an export checkbox. Keep Driving remains desktop-first: a gameplay, content, UI, save, or accessibility system cannot enter mobile adaptation until its desktop implementation is playable, integrated, profiled, documented, and accepted.

Mobile constraints still shape shared architecture from the start: normalized input, responsive components, safe stable IDs, bounded streaming, scalable assets, lifecycle-safe persistence, and platform adapters. This is preparation, not premature migration.

## Mobile entry gate

The mobile phase may begin only when the desktop content-complete beta has:

- Production vehicle handling/collision accepted in human desktop playtests.
- Complete D020-locked world/region, activity, progression, vehicle/part catalog, onboarding, UI, art, audio, save, settings, and accessibility scope.
- All primary progression playable start to finish.
- Full-stack desktop release build at 60 FPS with p95 at or below 16.7 ms, p99 at or below 25 ms, world work p95 at or below 4 ms, and no driving hitch above 50 ms.
- Stable memory plateau during a two-hour soak.
- Versioned alternating-slot save plus v0 migration; highest checksum-valid sequence authoritative, with disclosed lower-slot recovery only when the higher candidate is incomplete, unparsable, or checksum-invalid; active-expedition resume and 1,000 interruption/fault cycles passing.
- Keyboard and controller adapters using the same `DriveIntent` contract.
- Responsive UI aspect/text/focus matrix passing at the simulated phone floor.
- No open desktop P0/P1 defect and no more than five accepted P2s under the release risk budget.

After the accepted desktop handling/hero truth slice, Phase 2 performs one bounded signed-export feasibility check: Godot export -> generated Xcode target inspection -> signing -> archive -> physical install/launch. It requires a D021-passed public title and approved development identity, and it may not add touch UI, adapt gameplay, tune content, or begin store setup. Formal mobile adaptation and the first signed build of the complete frozen game still begin at the Phase 15 desktop entry gate above.

## Platform recommendation

### 1.0 target family

- Native iPhone landscape app.
- Both landscape-left and landscape-right; portrait is unsupported and never used for gameplay/menus.
- Native iPad layout is Valuable if Capacity Allows and must not be enabled merely because the iPhone build scales. If iPad is enabled, it receives its own layout, device matrix, screenshots, and QA.
- Tablet simulation remains nonblocking reference evidence unless native iPad is explicitly promoted through that full gate.
- iOS controller support remains enabled and fully navigable when a compatible controller is connected.

### Provisional deployment floor

- Minimum deployment target: **iOS 17.0**, pending revalidation at the first signed export and external TestFlight.
- Performance floor: A12-class / 3 GB device capable of running the selected deployment target.
- Product target: sustained 30 FPS on the minimum supported device; 60 FPS on A15-class and newer devices.
- Raise the deployment/device floor before external TestFlight if the complete game cannot sustain readability, save reliability, memory, thermal, and frame budgets without materially reducing the core experience.

The App Store upload SDK floor is separate. As of the 2026-07-11 research snapshot, uploads require Xcode 26+ and the iOS 26 SDK; recheck Apple's live requirement at every release gate. The current selected local Xcode 27 beta and beta macOS host are feasibility/forward-compatibility evidence only. TestFlight and App Store release gates require a pinned Apple-accepted stable Xcode/SDK pair on an Xcode-supported stable macOS release/build, plus matching Godot templates.

## Shared desktop-to-mobile architecture

### Shared without forks

- `CampaignModule` permanent rules, `ExpeditionModule` active rules, and `DriveRuntimeModule` fixed-step world/vehicle behavior.
- `ContentModule` package schemas/stable IDs and `SaveModule` schema/migration semantics.
- UI component scenes, typed intents, immutable read models, information architecture, and localization keys.
- Audio/feedback event semantics.
- Debug/performance metric semantics.

### Narrow platform Adapters

- `InputSource`: keyboard, controller, touch, replay, and glyph facts.
- `DisplayFactsSource`: safe area, aspect, resolution/quality tier, and orientation.
- `LifecycleSource`: desktop focus/quit versus iOS pause/resume/interruption/memory warning.
- `HapticOutput`: iOS plugin, controller/no-op, and recording proof.
- Build-time `ExportTarget`: desktop export versus Xcode signing/archive, entitlements, icons, launch storyboard, privacy manifest, and store packaging.

Storage and resource loading remain private Seams inside `SaveModule` and `ContentModule`. Do not create a broad platform capability Interface or optional Game Center/cloud/telemetry/native-accessibility Adapter before scope and a second real Implementation justify it. No `if OS == iOS` branches exist inside Campaign, Expedition, Drive Runtime, or content rules.

## Touch controls

### Primary scheme

- Left thumb: broad analog steering wheel/slider or steering zone producing `-1..1` intent.
- Right thumb: analog/digital gas, brake/reverse, and handbrake.
- True simultaneous multi-contact: steer + gas + handbrake, steer + brake, and contact transitions are mandatory.
- Input feeds the same `DriveIntent` used by keyboard, controller, proof, and replay.

### Customization

- Size, opacity, horizontal/vertical placement, sensitivity, response curve, and dead zone.
- Left-handed mirror.
- Hold/toggle alternatives where meaningful.
- Optional auto-accelerate as an assist after validation.
- Reset to safe default and live preview in the Garage test lot.

### Touch behavior tests

- Touch down/up, slide off/on, crossing control bounds, three simultaneous contacts.
- System edge gesture and Home/Control Center interaction.
- Phone call/notification/audio interruption.
- Background/foreground while contacts are active; no stuck throttle/steer/handbrake.
- Controller connect/disconnect and touch handoff.
- Left-handed and largest-control layouts at every safe-area class.
- Wet/rapid contact patterns and frame-rate fallback.

## Interface adaptation

### Reference mobile floor

- 896 x 414 logical landscape simulation remains a fast regression, not the release gate.
- Physical small/notched/wide devices define the real safe-area and readability floor.
- Touch target minimum 48 x 48 logical points, at least 12 points between conflicting actions.
- Primary touch-driving controls begin at `[PLACEHOLDER: 64 x 64]` and are locked only by reach, occlusion, simultaneous-input, and mis-input evidence.
- Interactive content stays within the OS safe area plus a 16-point design inset.

### Reflow priorities

1. Road/hazard visibility and driving controls.
2. Critical Fuel/Integrity warning.
3. Navigation/objective.
4. Cargo/unsecured haul.
5. Secondary details.

Desktop side panels become focused Field Manual cards/sheets on phone. Phone Plan shows one primary card; desktop may show the atlas plus two support rails. AtlasCanvas and RouteLedger remain equivalent paths to route facts, and Service's Garage content preserves exact Gains/Costs/Route-consequence comparison while reducing simultaneous columns. No text becomes smaller to fit; it wraps, pages, or moves behind a deliberate detail action.

### Safe areas and orientation

- Query platform safe-area facts on launch, orientation change, display change, and resume.
- Support both landscape orientations and transition without input loss, duplicate UI, or unsafe save.
- The car/camera composition avoids notches/home indicator and control fingers.
- Screenshots and automated layout reports capture every reference class at 100%, 150%, and 200% text.

### Native accessibility feasibility

Godot 4.7 Control accessibility metadata is required, but Godot's documented screen-reader feature does not include iOS. Do not infer VoiceOver from metadata or visual accessibility. A physical-iPhone spike must prove focus, values, actions, live warnings, modal restoration, and touch exploration across Service, Plan, Drive, Settle, and SystemSheet. If required and approved, keep the sole concrete `IOSVoiceOverBridge` plugin private inside Presentation; do not promote a public Adapter/Seam until a second real shipping-platform Implementation exists. Otherwise retain the non-native baseline and make no VoiceOver claim.

## Performance budgets

### Frame pacing

| Device tier | Target | Gate |
|---|---:|---|
| Minimum supported | Sustained 30 FPS | p95 <= 33.3 ms; no repeated hitch > 50 ms |
| A15-class and newer | 60 FPS | p95 <= 16.7 ms; p99 <= 25 ms |
| All supported | Correct input/physics | Fixed-step behavior remains equivalent when rendering drops |

- World work remains below 4 ms p95 on target 60 FPS devices and receives a measured budget on the minimum device.
- Streaming never exposes blank terrain, invisible walls, or input freeze.
- Quality scaling lowers optional decoration, shadows/lights, weather particles, trail density, and audio voices before road, collision, objective, hazard, or feedback readability.

### Memory

- Provisional gameplay working-set target <= 350 MB.
- Provisional process peak <= 500 MB on the minimum device.
- No unbounded cache; texture, audio, baked-chunk, pool, node, and mutation budgets are visible.
- Memory reaches a stable plateau within +/-5% after warm-up during a two-hour traversal soak.
- On memory warning, ask each consumer to detach optional/horizon content, then release returned lease IDs; Content never evicts a held lease, current collision/terrain essentials stay pinned, and authoritative state is never discarded.

### Thermal and battery

- Thirty-minute representative expedition soak on minimum and mid-tier devices, sampling `ProcessInfo.thermalState` at least once per second after a five-minute ambient-temperature idle baseline.
- A private QA-only `IOSDeviceMetricsProbe` plugin samples `ProcessInfo.processInfo.thermalState`, timestamp, battery/low-power facts needed by this protocol and writes the evidence stream. It is a concrete instrumentation Implementation inside QA builds, not a gameplay Interface/Adapter, and is absent from Release. Xcode Instruments/Organizer and the controlled battery protocol cross-check it.
- Zero `critical` sample; `serious` may not persist for more than 60 consecutive seconds or exceed 10% of the measured 30-minute window. Any forced shutdown, runaway quality oscillation, or input degradation fails the gate.
- Provisional battery target: no more than 15% of a healthy device charge during a controlled 30-minute session at 50% brightness; record exact device, battery health, network, audio, frame mode, and temperature.
- Offer 30/60 frame mode only if both are stable and clearly labeled; never default to an unstable 60 mode.

### Launch and resume

- Cold launch <= 5 seconds on minimum device to the correct first model: `RecoveryApplying` or durable `PendingRecoveryNotice` when recovery gates boot; otherwise Settle for pending receipt, `SettlementRecovering` for terminal active, `ResumeLoading` for nonterminal active, or interactive Title/Continue.
- Warm resume target <= 1 second; hard gate <= 2 seconds.
- No main-thread content bake, catalog scan, or save migration during active driving.

## Asset strategy

### Textures and world

- Atlas compatible terrain/props/UI; eliminate unused alpha/oversized source in export.
- The initial atlas-page hypothesis is `[PLACEHOLDER: 2048 x 2048]`; larger pages require a recorded quality/memory comparison on the representative tranche.
- Platform-appropriate VRAM compression validated for quality, transparency, and memory.
- Region packages support deterministic preload/unload and do not retain all source textures at once.
- Limit unique materials/canvas state changes and dynamic 2D lights based on device evidence.
- Landmark silhouettes and road/hazard readability survive reduced detail.
- The staged final-pipeline vehicle/Garage/route/surface/landmark/obstacle/threat/hazard/objective/safehouse/extraction/Fuel/repair/cargo/reward/core-card tranches and matching real engine/surface/impact/warning/reward/UI/Settle/ambience/music proof sets pass their family-specific phone-scale recognition, source/license/import, mix, memory, package, and throughput gates before those families multiply.

### Audio

- Stream music/long ambience; keep short latency-critical effects appropriately compressed/preloaded.
- Explicit voice/concurrency limits by category.
- Background/interruption stops or ducks buses correctly; resume does not double loops.
- Audio route changes and silent mode behavior follow the approved product policy and are device-tested.

### Package

- Provisional App Store processed download size <=400 MB for every supported iPhone variant, verified from App Store Connect/TestFlight build metadata; clean installed footprint <=800 MB in iPhone Storage on minimum and current devices after first launch with no optional cache.
- Strip source/debug assets, development tools, unused locales, and unlicensed placeholders from release.
- Track per-region texture/audio/baked-world contribution in the build manifest.

## Loading behavior

- Load metadata plus the bounded Title/Continue/recovery/settlement bootstrap first. Garage and other heavy posture payloads load lazily through consumer-tagged `PostureLoadPlan`; region content loads through `EntryLoadPlan` on expedition entry/resume.
- Predictive world streaming uses direction/speed and authored dependency metadata.
- Current entry/posture-required collision/terrain/objective, HUD/warning/accessibility equivalents, and latency-critical engine/warning/interaction audio outrank encounters, decoration, ambience/music, and extra VFX.
- No blocking spinner while driving. If essential data cannot arrive, transition at a safe boundary or use tested limited Streaming Drag—never blank terrain.
- iOS file paths, case sensitivity, packaged resources, and low-storage write behavior receive explicit tests.

## Application lifecycle

### Backgrounding/interruption

On loss of active state:

1. Clear active touch/controller intent immediately.
2. Pause simulation and audio/haptics.
3. Capture a bounded immutable expedition snapshot.
4. Attempt the bounded commit. If termination races it, next launch ranks slots normally: a fully checksum-valid higher sequence is authoritative even if `DurabilityResult` never ran; otherwise the prior verified slot wins.
5. Record lifecycle reason/timestamp locally for diagnostics.

On warm foreground, reuse the suspended runtime: process completed durability, requery safe area/orientation/controller/audio/quality, reattach only an essential explicitly detached during deliberate safe-point memory handling, require neutral input, restore loops once, and resume once. Never call Save/Expedition/Drive `open` over the live runtime.

On cold relaunch after OS termination, or after explicit verified-image reopen has first received successful `CANCEL_OWNER_CHAIN` and drained/closed the old runtime:

1. Run independent PROFILE/SETTINGS selection and revalidate content/build identity. If PROFILE selects an eligible lower slot, immediately show `RecoveryApplying`; copy corrupt higher evidence to diagnostic quarantine without removing its source before the replacement commit, validate recovered active state, preserve trusted terminal/nonterminal active, and burn/discard only when no trusted matching active survives and higher-active risk is `POSSIBLE`.
2. Commit `PendingRecoveryNotice`; failure or termination before commit repeats the same recovery. Show the durable notice until an idempotent acknowledgement commits. No receipt/resume/Plan route runs first; kill after notice commit restores it, while kill after acknowledgement does not.
3. If no recovery notice remains, show Settle for a pending receipt. If active progress is terminal, show `SettlementRecovering`, skip Drive, and idempotently resume retained-delta transfer, Campaign settlement, guarded offer-set consumption, and receipt commit.
4. For nonterminal active progress, show `ResumeLoading`; derive `DriveRestorePlan` from saved world requirements and persisted `AppliedExpeditionAssistPolicy`, then let the shell add current locale/quality/settings Presentation/Feedback needs to a consumer-tagged `EntryLoadPlan`.
5. Load and attach through the normal frame loop, apply ordered idempotent runtime reconciliation from committed `ExpeditionProgress`, and require neutral input. Tick only after composite `entry_ready`: required collision/terrain/objective/entity content, Drive HUD/warning/accessibility equivalents, latency-critical engine/warning/interaction audio, and input acknowledgement. Only ambience/music/extra VFX may lag; missing/hash-invalid required consumer content remains visibly blocked.

Elapsed background time does not drain Fuel, advance threats, complete objectives, or generate rewards.

### Interruption matrix

- Incoming call/FaceTime and notification center.
- Siri/system modal, permission prompt if any, Control Center, lock/unlock.
- Headphone/Bluetooth route change and other-app audio.
- Controller connect/disconnect.
- Orientation change.
- Memory warning and low storage.
- OS termination after background save request.
- App update with active expedition and schema migration.

## Save reliability on mobile

- Same independent PROFILE/SETTINGS envelopes, per-kind alternating verified slots/sequences, and stable IDs as desktop; settings corruption/reset never rewrites an active PROFILE policy.
- Background snapshot work is bounded and never serializes live Godot nodes.
- Fault tests kill the app before/during/after inactive-slot temporary write, flush, replacement, re-read verification, after valid replacement/verification but before `DurabilityResult`, migration, offer creation, SETTINGS commit versus active PROFILE assist-policy commit, observe/award retained-delta checkpoint and every terminal transfer, objective resolution, extraction payout, both settlement steps, receipt presentation/acknowledgement, purchase, and resume—including after save acknowledgement but before runtime/feedback/receipt release.
- The lower-PROFILE fault matrix proves trusted nonterminal/terminal active no-burn; no trusted matching active plus `POSSIBLE` burns/discards once; notice-write failure/retry and kill before notice commit repeat the same recovery; kill after notice commit before display/acknowledgement restores it; acknowledgement is idempotent; and kill after acknowledgement does not restore it.
- 1,000 lifecycle/write fault cycles produce no profile loss, duplicated reward, retained-delta loss/duplication, rerolled offer, active-policy drift, or skipped/duplicated recovery disclosure.
- Open ranks checksum-valid slots by sequence before compatibility. Future schema/content/migration failure on the highest sequence blocks visibly; only an incomplete/unparsable/checksum-invalid higher candidate permits disclosed lower-slot recovery. Corrupt higher evidence is copied to diagnostic quarantine without removing its source before the replacement notice commit succeeds.
- Low-storage error is player-visible and never overwrites the current valid slot.
- Local play remains authoritative at launch. Optional cloud sync cannot enter 1.0 without conflict, offline, deletion, privacy, and multi-device proof.

## Haptics

- Use the narrow `HapticOutput` Adapter; gameplay emits semantic intensity/pattern events.
- Continuous road texture is off by default and cannot graduate without comfort, control-precision, battery, and 30-minute fatigue proof; all discrete patterns are rate-limited.
- Validate light/heavy impact, drift threshold, pickup, critical warning, and extraction patterns on physical devices.
- Respect Reduce/Off setting instantly.
- Haptics never replace audio/visual meaning and do not run in background.

## Controller support on iOS

- Controller can start, play, pause, navigate map/Garage/settings, recover, and resolve every common flow.
- Correct glyph family and reconnect prompt.
- Touch controls may fade when controller is active but remain recoverable.
- Disconnect during motion pauses or safely clears intent according to policy.
- App Store controller disclosure matches actual required/optional support.
- Inspect the archived Game Controllers capability/Info.plist; supported profiles and `GCSupportsControllerUserInteraction` must match tests, while `GCRequiresControllerUserInteraction` stays absent because touch is a complete path.

## Device test matrix

### Required hardware tiers

| Tier | Representative requirement | Purpose |
|---|---|---|
| Minimum | Oldest supported iPhone / A12-class / 3 GB | 30 FPS, memory, launch, safe-area floor |
| Small screen | Smallest supported landscape viewport | UI, touch spacing, text scale |
| Mid | A15-class device | 60 FPS target and mainstream thermal/battery |
| Large/notched | Current large iPhone class | Safe area, reach, wide layout |
| Current flagship | Current shipping iPhone at RC | SDK/OS/renderer forward compatibility |
| Optional iPad | Oldest and current enabled iPad classes | Only if native iPad is included |

Before `KD-G6`, freeze an exact `DeviceMatrixLock`: at least one distinct physical device per required tier plus a second minimum and current device; exact model/chip/memory, OS, input, frame/quality mode, battery health, free storage, owner, and protocol. Minimum runs approved 30 FPS mode; A15-class and newer runs the required 60 FPS mode. Memory/thermal/battery/launch/resume ceilings must be locked or superseded by a pre-result decision before measurement.

`KD-G6` passes only when every assigned matrix row meets every applicable locked budget without cross-device averaging; 1,000/1,000 lifecycle/save faults preserve committed state; a distinct ten-person first-time-iPhone cohort reaches 9/10 unaided driving and 8/10 first launch -> expedition -> pause/background/resume -> Settle -> Service completion using touch; and one exact internal-TestFlight build records >=200 sessions in a frozen seven-day UTC window, every required tier >=20 attributable sessions, and a conservative crash-free score >=99.5% with unknown terminations failing until classified. Daily rolling views are not summed. That first-time cohort cannot be reused as the separate `KD-G7` first-time cohort.

### OS coverage

- Minimum supported iOS latest patch.
- Latest public iOS release.
- Current release candidate/beta only as forward-looking non-blocking evidence unless it becomes the submission SDK/OS requirement.

### Test dimensions

- Clean install, update from every supported previous beta/release schema, reinstall/reset.
- Offline/airplane mode, intermittent network if optional services exist.
- Touch/controller, left-handed, largest controls, 200% text, reduced motion, high contrast.
- Cold/warm launch, repeated background/resume, 30-minute thermal, two-hour memory soak.
- Low storage, low battery, audio route, call/notification, device lock.
- Full primary flow, failure/extraction, Garage transaction, save recovery, and any D020-locked postgame mode.

## TestFlight plan

### Internal

- Signed archive from tagged commit and evidence manifest.
- Internal group on every mobile milestone that clears device gates.
- Create the internal group before any external group. Do not upload a release candidate as **TestFlight Internal Only**, because that build cannot later go external or to customers.
- What to Test names exact changes, known defects, save compatibility, and instrumentation/privacy state.
- Minimum/mid/current device owners assigned explicitly.

### External

- Begin only after internal crash/save/performance/accessibility gates pass.
- The first external build receives TestFlight App Review; significant later changes are resubmitted even when a full review is not automatically required.
- First wave: 20-30 targeted testers across device/input/accessibility classes.
- Second wave: 50-100 if content/economy or device coverage requires it.
- Collect structured questionnaires, TestFlight installs/sessions/crashes/feedback, Xcode Organizer/device hang/watchdog evidence, optional consented diagnostics, and screenshot feedback. App Store Connect is not treated as a combined hang metric.
- Stop internal launches and open external access at frozen `T0=00:00 UTC`. Archive disjoint last-seven-day boundary exports/snapshots for `W1=[T0,T0+7d)` and `W2=[T0+7d,T0+14d)`; never sum daily rolling views. Per-tester/device evidence attributes sessions to one tier, ambiguous sessions remain only in the global denominator, and each failed equivalent belongs to one timestamped window.
- Require >=50 active external participants, each a unique external-group person with >=1 `W1`/`W2` session. A participant counts toward their preassigned tier only after >=1 attributable session on it, otherwise only toward the global 50. `W1+W2 >=1,000`; every tier >=5 qualified participants/100 attributable sessions; combined conservative health >=99.8%; and the distinct ten-person `KD-G7` first-time touch cohort. Missed/contaminated/unattributable windows restart cleanly.
- External TestFlight beta description, feedback email, contact/review notes, credentials if ever required, and per-build `What to Test` remain production-quality; privacy URL remains current app-level metadata.

## Mobile-specific risks

| Risk | Reduction | Gate |
|---|---|---|
| Touch steering feels imprecise | Physical multi-touch prototype and handling playtest before full UI port | Touch truth slice |
| UI passes simulation but fails safe areas/text scale | Physical aspect/safe-area matrix and screenshot automation | Mobile UI alpha |
| Fixed-step physics diverges under render throttling | 30/60/120 render and frame-drop test using same intent stream | Handling mobile gate |
| Production art/audio exceeds memory | Representative asset spike and per-region manifests | Before content lock |
| Thermal/battery degrades long runs | Minimum/mid 30-minute soaks every milestone | Device beta |
| Background creates stuck input/duplicate reward/save loss | Lifecycle adapter plus 1,000 fault cycles | Internal TestFlight |
| Godot/Xcode/SDK exporter incompatibility | Phase-2 export-only feasibility check after desktop truth slice; reproduce against frozen game with pinned stable Xcode/SDK in Phase 15 | Before production scale-up, then before mobile scale-up |
| Godot metadata does not produce usable iOS VoiceOver | Physical common-task feasibility spike; native plugin estimate only after proof | Before any VoiceOver claim or accessibility architecture lock |
| Optional SDK changes privacy/review scope | Default no tracking; formal SDK decision/privacy manifest audit | Before integration |

## Mobile definition of done

- Mobile entry gate was met and recorded.
- One shared gameplay code path; platform differences are adapters/resources/layout priorities.
- Touch, controller, safe area, orientation, accessibility, audio, haptics, lifecycle, save, and interruption matrices pass.
- Minimum device sustains approved 30 FPS/memory/thermal/battery/launch/resume budgets; target devices sustain 60 FPS.
- Signed archive installs and updates on all required device tiers.
- Internal gates pass; the unchanged processed build records disjoint external `W1+W2 >=1,000` sessions from at least 50 active participants, with every tier contributing at least five participants/100 attributable sessions, a conservative score of at least 99.8% after crash/watchdog/hang/unknown failed equivalents, and no reproducible save loss.
- Ten first-time iPhone players distinct from `KD-G6` reach 9/10 unaided driving and 8/10 first launch -> expedition -> pause/background/resume -> Settle -> Service completion using touch on that candidate.
- Privacy manifest, App Store declarations, export compliance, metadata, accessibility claims, and review notes match the exact archive.
