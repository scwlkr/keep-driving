# Keep Driving Mobile Porting Plan

Status: desktop-to-iOS plan for 1.0.0
Plan date: 2026-07-11

## Principle

Mobile is a dedicated adaptation and release program, not an export checkbox. Keep Driving remains desktop-first: a gameplay, content, UI, save, or accessibility system cannot enter mobile adaptation until its desktop implementation is playable, integrated, profiled, documented, and accepted.

Mobile constraints still shape shared architecture from the start: normalized input, responsive components, safe stable IDs, bounded streaming, scalable assets, lifecycle-safe persistence, and platform adapters. This is preparation, not premature migration.

## Mobile entry gate

The mobile phase may begin only when the desktop content-complete beta has:

- Production vehicle handling/collision accepted in human desktop playtests.
- Complete three-region world, activities, progression, vehicle/part catalog, onboarding, UI, art, audio, save, settings, and accessibility scope.
- All primary progression playable start to finish.
- Full-stack desktop release build at 60 FPS with p95 at or below 16.7 ms, p99 at or below 25 ms, world work p95 at or below 4 ms, and no driving hitch above 50 ms.
- Stable memory plateau during a two-hour soak.
- Versioned/atomic save plus v0 migration, corruption recovery, active-expedition resume, and 1,000 interruption/fault cycles passing.
- Keyboard and controller adapters using the same `DriveIntent` contract.
- Responsive UI aspect/text/focus matrix passing at the simulated phone floor.
- No open desktop P0/P1 defect and a bounded P2 list.

An earlier signed iOS **feasibility spike** may export only the already-accepted desktop truth slice to validate toolchain/renderer/input/lifecycle risk. It cannot be used to port unfinished systems or declare mobile readiness.

## Platform recommendation

### 1.0 target family

- Native iPhone landscape app.
- Both landscape-left and landscape-right; portrait is unsupported and never used for gameplay/menus.
- Native iPad layout is Valuable if Capacity Allows and must not be enabled merely because the iPhone build scales. If iPad is enabled, it receives its own layout, device matrix, screenshots, and QA.
- iOS controller support remains enabled and fully navigable when a compatible controller is connected.

### Provisional deployment floor

- Minimum deployment target: **iOS 17.0**, pending revalidation at the first signed export and external TestFlight.
- Performance floor: A12-class / 3 GB device capable of running the selected deployment target.
- Product target: sustained 30 FPS on the minimum supported device; 60 FPS on A15-class and newer devices.
- Raise the deployment/device floor before external TestFlight if the complete game cannot sustain readability, save reliability, memory, thermal, and frame budgets without materially reducing the core experience.

The App Store upload SDK floor is separate. As of the 2026-07-11 research snapshot, uploads require Xcode 26+ and the iOS 26 SDK; recheck Apple's live requirement at every release gate.

## Shared desktop-to-mobile architecture

### Shared without forks

- Domain/progression/economy/activity rules.
- World definitions, streaming, encounter logic, and save schema.
- Vehicle fixed-step simulation and collision.
- Content catalogs and stable IDs.
- UI component scenes, information architecture, localization keys, and view models.
- Audio/feedback event semantics.
- Debug/performance metric semantics.

### Platform-specific adapters

- Keyboard/controller/touch input sources and glyphs.
- Safe-area, aspect, resolution/quality tier, and orientation.
- Application lifecycle, interruptions, memory warnings, and storage diagnostics.
- Haptics and audio-session behavior.
- Export, signing, entitlements, icons, launch storyboard, privacy manifest, and store packaging.
- Optional Game Center/cloud support only if explicitly included.

No `if OS == iOS` branches inside economy, world, activity, or progression rules. Platform facts enter through narrow interfaces.

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
- Interactive content stays within the OS safe area plus a 16-point design inset.

### Reflow priorities

1. Road/hazard visibility and driving controls.
2. Critical Fuel/Integrity warning.
3. Navigation/objective.
4. Cargo/unsecured haul.
5. Secondary details.

Desktop side panels become focused tabs/sheets on phone. Garage and map preserve exact compare/navigation facts while reducing simultaneous columns. No text becomes smaller to fit; it wraps, pages, or moves behind a deliberate detail action.

### Safe areas and orientation

- Query platform safe-area facts on launch, orientation change, display change, and resume.
- Support both landscape orientations and transition without input loss, duplicate UI, or unsafe save.
- The car/camera composition avoids notches/home indicator and control fingers.
- Screenshots and automated layout reports capture every reference class at 100%, 150%, and 200% text.

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
- Respond to memory warning by dropping optional caches/detail safely; never discard authoritative state.

### Thermal and battery

- Thirty-minute representative expedition soak on minimum and mid-tier devices.
- No sustained serious/critical thermal state, forced shutdown, runaway quality oscillation, or input degradation.
- Provisional battery target: no more than 15% of a healthy device charge during a controlled 30-minute session at 50% brightness; record exact device, battery health, network, audio, frame mode, and temperature.
- Offer 30/60 frame mode only if both are stable and clearly labeled; never default to an unstable 60 mode.

### Launch and resume

- Cold launch <= 5 seconds on minimum device to interactive Title/Continue.
- Warm resume target <= 1 second; hard gate <= 2 seconds.
- No main-thread content bake, catalog scan, or save migration during active driving.

## Asset strategy

### Textures and world

- Atlas compatible terrain/props/UI; eliminate unused alpha/oversized source in export.
- Platform-appropriate VRAM compression validated for quality, transparency, and memory.
- Region packages support deterministic preload/unload and do not retain all source textures at once.
- Limit unique materials/canvas state changes and dynamic 2D lights based on device evidence.
- Landmark silhouettes and road/hazard readability survive reduced detail.

### Audio

- Stream music/long ambience; keep short latency-critical effects appropriately compressed/preloaded.
- Explicit voice/concurrency limits by category.
- Background/interruption stops or ducks buses correctly; resume does not double loops.
- Audio route changes and silent mode behavior follow the approved product policy and are device-tested.

### Package

- Provisional download target <= 400 MB and installed footprint <= 800 MB.
- Strip source/debug assets, development tools, unused locales, and unlicensed placeholders from release.
- Track per-region texture/audio/baked-world contribution in the build manifest.

## Loading behavior

- Load Title/Garage and current profile first; region content loads on expedition entry.
- Predictive world streaming uses direction/speed and authored dependency metadata.
- Essential collision/terrain/objective outrank decoration, optional encounter, and VFX.
- No blocking spinner while driving. If essential data cannot arrive, transition at a safe boundary or use tested limited Streaming Drag—never blank terrain.
- iOS file paths, case sensitivity, packaged resources, and low-storage write behavior receive explicit tests.

## Application lifecycle

### Backgrounding/interruption

On loss of active state:

1. Clear active touch/controller intent immediately.
2. Pause simulation and audio/haptics.
3. Capture a bounded immutable expedition snapshot.
4. Commit if the OS time budget permits; otherwise retain the last known-good committed save.
5. Record lifecycle reason/timestamp locally for diagnostics.

On resume:

1. Revalidate content/save/session identity.
2. Requery safe area, orientation, controller, audio route, and quality state.
3. Show a resume overlay; never resume into moving danger under a stuck input.
4. Restore loops/ambience once and resume only after input release/acknowledgement.

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

- Same versioned atomic envelope and stable IDs as desktop.
- Background snapshot work is bounded and never serializes live Godot nodes.
- Fault tests kill the app before/during/after temp write, backup rotation, rename, migration, objective resolution, extraction payout, purchase, and resume.
- 1,000 lifecycle/write fault cycles with no profile loss or duplicated reward.
- Corrupt primary recovers latest verified sequence and preserves diagnostics.
- Low-storage error is player-visible and never overwrites a good backup.
- Local play remains authoritative at launch. Optional cloud sync cannot enter 1.0 without conflict, offline, deletion, privacy, and multi-device proof.

## Haptics

- Use the platform adapter; gameplay emits semantic intensity/pattern events.
- Rate-limit road texture and repeated contact.
- Validate light/heavy impact, drift threshold, pickup, critical warning, and extraction patterns on physical devices.
- Respect Reduce/Off setting instantly.
- Haptics never replace audio/visual meaning and do not run in background.

## Controller support on iOS

- Controller can start, play, pause, navigate map/Garage/settings, recover, and resolve every common flow.
- Correct glyph family and reconnect prompt.
- Touch controls may fade when controller is active but remain recoverable.
- Disconnect during motion pauses or safely clears intent according to policy.
- App Store controller disclosure matches actual required/optional support.

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
- Full primary flow, failure/extraction, Garage transaction, save recovery, Expedition Mode.

## TestFlight plan

### Internal

- Signed archive from tagged commit and evidence manifest.
- Internal group on every mobile milestone that clears device gates.
- What to Test names exact changes, known defects, save compatibility, and instrumentation/privacy state.
- Minimum/mid/current device owners assigned explicitly.

### External

- Begin only after internal crash/save/performance/accessibility gates pass.
- First wave: 20-30 targeted testers across device/input/accessibility classes.
- Second wave: 50-100 if content/economy or device coverage requires it.
- Collect structured session questionnaire, App Store Connect crash/hang data, optional consented diagnostics, and screenshot feedback.
- External TestFlight review metadata, contact, beta description, privacy, and review instructions remain production-quality.

## Mobile-specific risks

| Risk | Reduction | Gate |
|---|---|---|
| Touch steering feels imprecise | Physical multi-touch prototype and handling playtest before full UI port | Touch truth slice |
| UI passes simulation but fails safe areas/text scale | Physical aspect/safe-area matrix and screenshot automation | Mobile UI alpha |
| Fixed-step physics diverges under render throttling | 30/60/120 render and frame-drop test using same intent stream | Handling mobile gate |
| Production art/audio exceeds memory | Representative asset spike and per-region manifests | Before content lock |
| Thermal/battery degrades long runs | Minimum/mid 30-minute soaks every milestone | Device beta |
| Background creates stuck input/duplicate reward/save loss | Lifecycle adapter plus 1,000 fault cycles | Internal TestFlight |
| Godot/Xcode/SDK exporter incompatibility | Signed feasibility spike and volatile-requirement recheck | Before mobile scale-up |
| Optional SDK changes privacy/review scope | Default no tracking; formal SDK decision/privacy manifest audit | Before integration |

## Mobile definition of done

- Mobile entry gate was met and recorded.
- One shared gameplay code path; platform differences are adapters/resources/layout priorities.
- Touch, controller, safe area, orientation, accessibility, audio, haptics, lifecycle, save, and interruption matrices pass.
- Minimum device sustains approved 30 FPS/memory/thermal/battery/launch/resume budgets; target devices sustain 60 FPS.
- Signed archive installs and updates on all required device tiers.
- Internal and external TestFlight gates pass with at least 99.8% crash-free sessions and no save loss.
- Privacy manifest, App Store declarations, export compliance, metadata, accessibility claims, and review notes match the exact archive.
