# Keep Driving App Store Release Checklist

Status: not ready; launch checklist for 1.0.0
Checklist snapshot: 2026-07-11
Gate/authority decision: [Playtest, Release, and App Store Gates](research/PLAYTEST_RELEASE_AND_APP_STORE_GATES.md)
First-party research: [Apple App Store and Godot iOS Requirements](research/APP_STORE_REQUIREMENTS.md)

## Release policy

- 1.0 is a premium, one-time-purchase, offline-first iPhone game.
- `Keep Driving` is internal only. Public release assumes a distinctive cleared replacement; retaining the exact title requires D021's qualified written legal clearance plus positioning/search-confusion exception before signed feasibility or public identity lock.
- No advertising, cross-app tracking, ATT prompt, account, launch IAP, subscription, or mandatory network service.
- Native iPad, Game Center, and cloud save ship only if their full product, privacy, device, metadata, and review gates pass; otherwise they remain disabled and undisclosed.
- Use manual release after approval so support, monitoring, metadata, and emergency response are staffed.
- Every applicable item has an owner/evidence link in `docs/release/<version>/RELEASE_EVIDENCE.md`; Evidence, Build, Product, Privacy/Compliance, and Release Owners attest only their scope.
- Required `KD-G0` through `KD-G9` gates must pass for the exact archive. Required gates/P0/P1 are never waived, and invalidating changes mark affected gates `REOPENED`.
- Recheck current Apple/Godot requirements at first signed export, first external TestFlight, release-candidate upload, and final submission.

## Current repository blockers

- [ ] Production game/content complete and desktop gates pass.
- [ ] A distinctive replacement—or D021's fully passed exact-title exception—is legally cleared and passes documented positioning/search-confusion review before signed feasibility or irreversible identity/brand work.
- [ ] `export_presets.cfg` with reproducible iOS export exists.
- [ ] Xcode 26+ and iOS 26 SDK upload floor revalidated against Apple's live requirements; the selected release pair and Xcode-supported macOS host release/build are stable, not beta-only evidence.
- [ ] Matching Godot 4.7 export templates and exporter compatibility proven.
- [ ] App version, build number, bundle ID, Team ID, signing, entitlements, device family, deployment target, icons, and launch storyboard configured.
- [ ] Physical-device install, lifecycle, performance, memory, thermal, battery, audio, haptic, input, and save proof passes.
- [ ] App Store Connect record, agreements, tax/banking, territory, pricing, privacy, age, accessibility, export, DSA/trader, metadata, and assets complete.
- [ ] Internal/external TestFlight and release-candidate gates pass.

## App identity and signing

### Decisions

- Working product name: **Keep Driving**; blocked from public/store lock pending D021's legal-plus-positioning gate.
- Bundle identifier: unresolved until the cleared public name/publisher identity is approved. `com.scwlkr.keepdriving` is only a discarded planning example, not authorization to register it.
- Marketing version: `1.0.0`.
- Build value: monotonically increasing CI/release number; never reuse an uploaded build value.
- Primary language: English.
- Device family: iPhone for required 1.0 scope; enable iPad only after native layout/device/store-asset gates.
- Deployment target: provisional iOS 17.0; revalidate before external TestFlight.

### Checklist

- [ ] Apple Developer Program membership active and correct legal entity selected.
- [ ] Qualified name/trademark clearance covers the intended app/game title, logo, publisher use, territories/classes, store confusion, domains, and likely marketing/search context.
- [ ] Existing released games/apps and claimed marks—including YCJY Games' `Keep Driving`—are recorded in the clearance file; no legal conclusion is inferred from a web search alone.
- [ ] Replacement candidates receive the same qualified clearance plus documented positioning/search-confusion review before selection; repository strings/assets migrate before public brand lock.
- [ ] Current Apple Developer and App Store Connect agreements accepted.
- [ ] Bundle ID approved and registered as an explicit App ID.
- [ ] App Store Connect app record created with matching bundle ID, stable SKU, primary language, and name reservation.
- [ ] Distribution method is explicitly **Public** for 1.0; the approval-time immutability/unlisted exception is understood and recorded.
- [ ] Default iPhone-app availability on Apple-silicon Mac and Apple Vision Pro is explicitly tested and supported or opted out before submission; neither is silently claimed as a supported game platform.
- [ ] Team ID recorded in private release runbook and Godot export environment.
- [ ] Distribution certificate/signing identity valid through launch and emergency-patch window.
- [ ] App Store provisioning/profile or Xcode automatic-signing policy documented and reproducible.
- [ ] `xcode-select` targets the approved stable release Xcode on its approved stable macOS release/build; license, command-line tools, iOS platform, and archive destination verified. Beta Xcode/macOS remains forward-compatibility/feasibility evidence only.
- [ ] No signing secrets, certificates, provisioning profiles, passwords, or Team credentials committed to git.
- [ ] Required capabilities/entitlements are a minimal exact list. Remove Game Center, push, iCloud, background modes, network, or other entitlements unless shipped and tested.
- [ ] Generated Xcode target bundle ID, display name, version, build, deployment target, device family, orientations, icons, launch storyboard, entitlements, privacy manifest, and release settings inspected.
- [ ] Release archive is ARM64, correctly signed, contains no debug entitlement/tool, and maps to one tagged commit/build manifest.

## Toolchain and build requirements

- [ ] Recheck [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) at the release gate.
- [ ] Approved stable macOS release/build, Xcode, and iOS SDK versions recorded in build manifest.
- [ ] Approved Godot exact version and export-template hash recorded.
- [ ] Godot iOS export preset committed without secrets.
- [ ] Clean clone can validate, test, bake content, export Xcode project, and produce a Release archive through documented commands.
- [ ] CI/release host runs the recorded Xcode-supported stable macOS build with controlled toolchain, keychain access, provisioning, and enough disk.
- [ ] Semantic version, build value, commit SHA, content version, and save schema embedded and visible in diagnostics.
- [ ] Build manifest contains archive hash, symbols, catalogs/world hashes, licenses, privacy SDK list, tests, and performance/device evidence.
- [ ] Release build strips cheats, debug overlay, test profiles, placeholder content, verbose logs, and development telemetry.
- [ ] Archive validates in Xcode and App Store Connect with no unresolved processing error or relevant warning.
- [ ] Processed build is selected for the correct `1.0.0` App Store version.

## Product-completeness requirements

- [ ] Primary progression plays from first launch through final restoration and Results.
- [ ] All D020-locked regions, landmarks, safehouses, contracts, encounters, chassis, parts, loadouts, postgame features, settings, accessibility, and credits are present and production-quality.
- [ ] No placeholder art/audio/text, empty state, debug copy, missing localization key, broken URL, unreachable content, or disabled unfinished button.
- [ ] Offline first launch after install works unless App Store receipt behavior requires a documented network case.
- [ ] Core game, saves, and progression work in airplane mode after installation; if retained by D020, Expedition Mode does too.
- [ ] No login or account required.
- [ ] Premium pricing and territories approved; final regional price is consistent with product decision.
- [ ] If any IAP is later added, it receives separate StoreKit product, restore, parental, price, privacy, receipt, offline, review, and metadata scope; no launch IAP is assumed.
- [ ] If Game Center is added, entitlement/configuration, authentication/offline behavior, achievements/leaderboards, privacy, review notes, and UI all pass; otherwise entitlement is absent.
- [ ] Controller support disclosure matches actual optional/required behavior.
- [ ] Archived Game Controllers capability/Info.plist matches reality: supported profiles and `GCSupportsControllerUserInteraction` are inspected; `GCRequiresControllerUserInteraction` is absent because controller is optional.

## Icons and launch experience

- [ ] Final 1024 x 1024 base/App Store icon approved and embedded through Godot/Xcode asset catalog.
- [ ] Dark/tinted icon variants included only if supported and visually approved.
- [ ] Icon uses the current Xcode layered workflow: background is full-bleed/opaque, no manual mask/rounded corners are baked, and default/dark/clear/tinted rendered appearances remain legible.
- [ ] Launch storyboard/screen uses final brand, correct background, safe areas, both landscape orientations, and no misleading progress/control.
- [ ] Cold launch transitions from launch screen to interactive app without visual jump or long blank frame.
- [ ] App icon and launch assets tested on every supported appearance/device class.

## Product-page metadata

### Working metadata

- Working name: `Keep Driving`; replace with the cleared public name before App Store record/metadata approval.
- Subtitle candidate: `Survive the Open Road` (validate length and positioning).
- Primary category: Games.
- Game subcategories: choose from the current App Store taxonomy at record creation; likely Action/Adventure, subject to final positioning.
- Description: final 4,000-character maximum copy centered on open-road survival, vehicle builds, the exact D020-locked connected-county exploration scope, offline premium play, and accessibility—no unshipped promise.
- Keywords: final set within the current 100-byte limit; no competitor trademarks or irrelevant terms.
- Promotional text: optional, maximum current limit, used only for accurate launch context.
- Support URL: must be a live HTTPS page with real contact and troubleshooting; owner/domain unresolved.
- Privacy-policy URL: must be a live HTTPS policy matching the exact archive; owner/domain unresolved.
- Marketing URL: optional; omit unless a maintained product page exists.

### Checklist

- [ ] App name, subtitle, description, keywords, promotional text, categories, copyright, content rights, availability, price, territories, and version copy approved.
- [ ] Support URL works without login, provides real contact, known issues, minimum OS/devices, controls, save/support steps, and privacy link.
- [ ] Privacy URL works without login and is also reachable inside the app.
- [ ] Marketing claims and feature bullets match the exact selected build.
- [ ] No mention of unshipped iPad, cloud, Game Center, controller requirement, localization, activity, part, or region.
- [ ] Metadata proofread, legal/brand reviewed, and localized only for languages actually supported in-game.
- [ ] Store metadata snapshot retained with the release manifest.

## Screenshots and app previews

- [ ] Recheck the live [screenshot specification table](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/) before capture.
- [ ] Capture one to ten required screenshots per supported device/language set from the final release build.
- [ ] Required iPhone landscape size set is complete; add iPad sets only if native iPad support ships.
- [ ] Screenshots show actual gameplay in use: hero driving frame, world/route choice, Garage/build comparison, region/weather contrast, objective/extraction, and accessibility/settings where useful.
- [ ] No screenshot is only a title/splash screen; no mock feature, debug UI, device frame error, private data, misleading reward, or illegible tiny copy.
- [ ] Overlay copy, if used, is accurate, localized, inside safe zones, and not obscuring release UI.
- [ ] Screenshot order tells a coherent product story and remains readable at product-page thumbnail size.
- [ ] Optional app preview uses captured release footage, current length/codec/size rules, accurate controls, licensed audio/music, and no unshipped content.
- [ ] If used, each preview is 15-30 seconds, <=500 MB, <=30 fps, supported H.264 or ProRes 422 HQ, and uses captured in-app footage; narration/overlays may explain but never simulate interaction.
- [ ] Up to three previews per localization/device size only when quality justifies production cost; otherwise omit.
- [ ] Icon, screenshots, and previews are suitable for a 4+ audience even if the final game age rating is higher; zombie threat/impact framing is reviewed specifically.
- [ ] Source captures, edit project, final exports, licenses, and exact build retained.

## Age rating and content

- [ ] Complete the live age-rating questionnaire for the exact release content.
- [ ] Re-answer the 2026-07-09 social-media-capability questions and every changed live-questionnaire field; never reuse an older screenshot/answer export blindly.
- [ ] Declare stylized Zombie violence, impact effects, fear/horror themes, any blood/gore, weapons, profanity, substances, gambling/loot boxes, web access, UGC, chat, ads, and social features accurately.
- [ ] Candidate expectation is an age rating driven by stylized fantasy violence; do not publish a rating guess in marketing before App Store Connect calculates it.
- [ ] Region-specific rating differences reviewed.
- [ ] An Unrated status is never allowed into submission.
- [ ] Store screenshots/preview and in-game presentation are consistent with questionnaire answers.

## Accessibility review and declarations

- [ ] 100-200% text common-task matrix passes without unusable clipping/overlap.
- [ ] Contrast and color-independent cues pass documented review.
- [ ] Touch, keyboard, and controller common flows pass with visible focus where applicable.
- [ ] Reduced Motion disables shake/nonessential large motion; flash/particle/haptic intensity controls work.
- [ ] Gameplay-critical audio has visual equivalent; spoken/semantic content has captions where applicable.
- [ ] Touch controls support size/position/opacity/handedness/sensitivity and simultaneous input.
- [ ] Difficulty assists and tutorial replay work without blocking primary completion.
- [ ] Evaluate each current App Store Accessibility Nutrition Label using Apple's live criterion.
- [ ] Record that labels are voluntary as of the 2026-07-11 snapshot but complete the 1.0 declarations as an internal honesty gate; recheck whether Apple has made them mandatory.
- [ ] Because Godot 4.7 does not document iOS screen-reader support, any VoiceOver claim has physical-iPhone common-task evidence from the exact native/plugin Implementation; Control metadata alone never passes.
- [ ] Claim only features that support **all common tasks**. Do not claim VoiceOver, Voice Control, Larger Text, Reduced Motion, captions, or another label based on partial screens.
- [ ] Claim register maps feature -> every common task -> device/OS -> exact build/settings -> evidence/owner; VoiceOver or Voice Control additionally has at least two participants who regularly use that technology.
- [ ] Accessibility claims match product page, review notes, support docs, and exact build.

## Privacy and legal

### Privacy-minimal baseline

- [ ] Final binary and every SDK inventoried by name, version, purpose, data, endpoint, retention, deletion/opt-out, required-reason API, and privacy manifest/signature status.
- [ ] Confirm no advertising identifier, cross-app/site tracking, fingerprinting, advertising SDK, account, user-generated content, or location/camera/microphone/contact permission.
- [ ] If the final app and partners collect no data, select App Store Connect's explicit no-data response and retain evidence. If anything is collected, disclose every qualifying data type/use/linkage accurately.
- [ ] No ATT prompt unless the exact binary performs Apple-defined tracking; gameplay is never gated on consent.
- [ ] Local structured diagnostics contain no unnecessary personal/sensitive data and are not uploaded without an explicit, documented flow.
- [ ] Identifiable tester capture is deleted by the earlier of 90 days after `KD-G11` or 180 days after capture; cancellation/indefinite archive receives a deletion review within 30 days, and any consent/legal/security extension names its next review/deletion date.

### Privacy policy

- [ ] Public policy identifies publisher/contact, data collection or no-collection statement, SDK/partner behavior, purpose, sharing, retention, security, deletion/request process, consent/withdrawal where applicable, children/age posture, and change date.
- [ ] Policy is available in-app and at the App Store URL.
- [ ] Policy and App Store privacy answers reviewed after every SDK/capability/network change.

### Privacy manifest and permissions

- [ ] Valid `PrivacyInfo.xcprivacy` exists in the final archive.
- [ ] Required-reason APIs used by app/SDKs are declared with valid reasons.
- [ ] Collected-data types, tracking domains, and tracking flag match actual behavior.
- [ ] Xcode privacy report generated and reviewed for the final archive.
- [ ] Every required permission purpose string is specific and accurate; unused permissions/capabilities are removed.
- [ ] Listed third-party SDKs have current required manifest/signature status.

### Other legal/compliance

- [ ] All code, fonts, art, audio, music, icons, marketing assets, and tools have documented ownership/license and required attribution.
- [ ] Product name, logo, subtitle, domains, screenshots, keywords, and marketing copy have documented name/trademark/competitive clearance; legal review record retained privately.
- [ ] Credits/licenses screen and source/license manifest complete.
- [ ] Content rights declaration accurate.
- [ ] Copyright owner/year accurate.
- [ ] EU Digital Services Act trader status declared; verification/contact disclosure complete if distributing as a trader in the EU.
- [ ] Territory-specific permits, consumer requirements, tax, and banking reviewed.
- [ ] If selected, Vietnam game licensing, mainland-China NPPA approval plus ICP requirements, and conditional Korea GRAC requirements have specialist evidence; otherwise those storefronts remain disabled.
- [ ] App Review Guidelines reviewed at RC, especially completeness, accurate metadata, privacy, payments, and minimum functionality.

## Export compliance

- [ ] Complete export-compliance determination for the exact release binary, including OS cryptography, networking, cloud, telemetry, crash reporting, receipt logic, and SDKs.
- [ ] Upload documentation/classification if required and clear it before TestFlight/App Review.
- [ ] If exempt/no documentation required, set the correct Info.plist/App Store declaration to avoid repeated Missing Compliance.
- [ ] Re-evaluate after any networking, Game Center/cloud, SDK, StoreKit, or cryptography change.
- [ ] Obtain specialist advice if classification is uncertain; this checklist is not legal advice.

## TestFlight requirements

### Build preparation

- [ ] Processed signed build has correct identifier/version/build and no Missing Compliance.
- [ ] App-level privacy URL is current. External test information includes beta description, feedback email, contact/review notes, and credentials if ever needed; each build has exact `What to Test` text.
- [ ] Save schema/build compatibility and known defects stated to testers.
- [ ] Internal TestFlight group exists before the external group; release candidates are not uploaded as **TestFlight Internal Only**, because that build type can never graduate externally or to customers.

### Internal testing

- [ ] Assigned minimum/small/mid/large/current device matrix complete.
- [ ] Clean install, update, offline, touch/controller, safe area, 200% text, lifecycle, save, memory, thermal, battery, low storage, audio route, and primary flow pass.
- [ ] Every assigned matrix row passes every locked budget; 1,000/1,000 lifecycle/save faults preserve committed state.
- [ ] Distinct ten-person first-time-iPhone cohort reaches 9/10 unaided driving and 8/10 touch completion of first launch -> expedition -> pause/background/resume -> Settle -> Service; it is not reused for `KD-G7`.
- [ ] Open internal use at frozen `T0=00:00 UTC`; exact build records >=200 sessions in `[T0,T0+7d)`, every tier >=20 attributable sessions, and conservative health >=99.5%. Use the `T0+7d` last-seven-day boundary export/snapshot plus device/Xcode evidence; never sum daily rolling views; unknown terminations fail until classified.
- [ ] No internal P0/P1; accepted P2 list remains within the fixed release risk budget and has owners.

### External testing

- [ ] First external group submitted through TestFlight App Review when required.
- [ ] First external build receives full TestFlight review; later same-version builds are resubmitted when changes are significant even if App Store Connect does not automatically demand a full review.
- [ ] 20-30 person first wave covers device/input/accessibility/player-experience gaps; total release gate reaches at least 50 active external participants, each a unique external-group person with >=1 exact-build session in `W1` or `W2`; a person counts toward the preassigned tier floor only after >=1 attributable session on it, otherwise only toward the global 50.
- [ ] Larger wave is used only to close content/economy/reliability confidence, not substitute for structured tests.
- [ ] Feedback, screenshot reports, TestFlight sessions/crashes, Xcode Organizer/device hang/watchdog reports, device metrics, support contacts, and questionnaire results triaged; App Store Connect is not described as providing a combined hang metric.
- [ ] Stop internal use and open external access at frozen `T0=00:00 UTC`; archive disjoint last-seven-day boundary exports/snapshots for `W1=[T0,T0+7d)` and `W2=[T0+7d,T0+14d)`. Daily rolling views are never summed; missed/contaminated/unattributable windows restart cleanly.
- [ ] `W1+W2` contains at least 1,000 exact-build TestFlight-reported sessions and 50 active external participants; conservative crash-free score >=99.8%; zero reproducible save loss. Every session/failed equivalent belongs to one timestamped window, and one incident is not double-counted across categories/windows.
- [ ] Per-tester/device evidence maps sessions to one tier; ambiguous sessions remain in the global denominator but count toward no tier. Every tier contributes at least five participants and 100 attributable sessions.
- [ ] Ten first-time iPhone players distinct from `KD-G6`: 9/10 drive unaided within two minutes and 8/10 complete first launch -> expedition -> pause/background/resume -> Settle -> Service using touch.
- [ ] TestFlight 90-day build expiry and tester access monitored.

## Physical-device and performance release gate

- [ ] `DeviceMatrixLock` names at least one distinct minimum/small/mid/large/current physical device plus a second minimum/current device, exact model/chip/memory/OS/input/frame/quality/battery/free-storage owner, and frozen protocol/budgets before results.
- [ ] Minimum device sustains approved 30 FPS with p95 <=33.3 ms and no repeated >50 ms hitch.
- [ ] A15-class and newer target devices sustain 60 FPS with p95 <=16.7 ms and p99 <=25 ms.
- [ ] Gameplay working set <=350 MB target and process peak <=500 MB provisional hard ceiling, or a documented evidence-based revision is approved.
- [ ] App Store processed download size <=400 MB for every supported iPhone variant; clean post-first-launch installed footprint <=800 MB on minimum and current devices; exact build/measurement screens retained.
- [ ] Thirty-minute thermal/battery soak passes on minimum/mid/current devices after five-minute ambient idle; thermal state sampled at least once/second; zero `critical`; `serious` lasts <=60 consecutive seconds and <=10% of the measured window.
- [ ] Controlled battery use is <=15% over the same 30-minute run at 50% brightness, with device, battery health, network, audio, frame mode, and temperature recorded.
- [ ] Two-hour memory/traversal soak plateaus within +/-5% after warm-up.
- [ ] Cold launch <=5 seconds and shows the correct nonblank first model before heavy restore: `RecoveryApplying` or durable `PendingRecoveryNotice` when recovery gates boot; otherwise Settle for pending receipt, `SettlementRecovering` for terminal active, `ResumeLoading` for nonterminal active, or Title/Continue; maximum active snapshot resume <=2 seconds, target <=1 second.
- [ ] Touch/haptic/audio/controller/lifecycle behavior remains correct under frame and thermal fallback.
- [ ] No blank terrain, invisible wall, stuck input, duplicated audio loop, reward duplication, or save inconsistency.

## Save-data validation

- [ ] Real v0 profile migrates and retains supported value.
- [ ] Every supported schema fixture migrates idempotently.
- [ ] 1,000 interrupted write/background/termination cycles produce no profile loss, duplicated reward, retained-delta loss/duplication, rerolled shown offer, active-policy drift, or skipped/duplicated recovery disclosure.
- [ ] Open ranks checksum-valid slots by sequence before compatibility; future schema/content/migration failure on the highest sequence blocks visibly, while only incomplete/unparsable/checksum-invalid higher data permits disclosed lower-slot recovery/quarantine.
- [ ] PROFILE and SETTINGS use independent schemas/sequences/two-slot journals; corrupt/reset SETTINGS never selects, blocks, rewrites, or rolls back PROFILE, and an active run resumes its persisted `AppliedExpeditionAssistPolicy`.
- [ ] Low-storage write failure preserves last known-good save and informs player.
- [ ] Observe/award -> kill/failure/abandon and terminal-settlement retries transfer every `RetainedCampaignDeltaOutbox` ID exactly once; escrow/prohibited kinds never enter that outbox.
- [ ] Eligible lower-PROFILE recovery passes the exact device matrix: trusted nonterminal/terminal active preserves the offer without burn; no trusted matching active plus `POSSIBLE` burns/discards once; notice-write failure/retry and kill before notice commit repeat the same recovery; kill after notice commit before display/acknowledgement restores the notice; duplicate acknowledgement is idempotent; kill after acknowledgement does not restore it.
- [ ] Clean install/new profile, shown-offer relaunch, update, active-expedition resume with persisted `AppliedExpeditionAssistPolicy`, results payout, kill after settlement acknowledgement but before receipt presentation, Settle recovery, receipt acknowledgement, purchase/fabrication, reset, and eligible recovery pass on devices.
- [ ] Unknown/missing/deprecated content IDs use documented migration/refund rules.
- [ ] Release archive never exposes destructive debug save controls.

## App Review package

### Review contact and notes

- [ ] Reachable name, phone, and email staffed during review.
- [ ] Notes explain: premium/offline/no login, landscape orientations, touch controls, optional controller, first-launch path, fastest route through tutorial/expedition/Results/Garage, save/reset behavior, no tracking, permissions/capabilities, and any hard-to-find review content.
- [ ] If a review/debug shortcut is needed, it is safe, documented, production-approved, and not a hidden cheat affecting customers. Prefer a naturally short review path.
- [ ] No demo account needed because no login; if this changes, supply a non-expiring full-feature account or approved demo mode.

### Completeness

- [ ] Every URL, service, entitlement, permission, and optional feature available during review.
- [ ] No beta label, crash, placeholder, debug menu, broken purchase, unavailable server, misleading metadata, or unfinished content.
- [ ] Review build tested on current physical devices and current public iOS.
- [ ] Age/privacy/accessibility/export answers match the archive.
- [ ] The same processed build that passed `KD-G7` is selected in the draft submission with all required items, then submitted; selecting a new processed build resets `KD-G7`.

## Final release-candidate checks

- [ ] RC commit/tag frozen; only release-blocker changes accepted through reviewed cherry-picks/new RC build.
- [ ] `KD-G0` through `KD-G9` ledger rows name this exact archive/build and remain PASS; no evidence was inherited across an invalidating change.
- [ ] Clean-clone build reproduces the selected archive hash/equivalent signed provenance.
- [ ] All automated suites, content validators, rendered captures, desktop and iOS performance, save faults, accessibility, localization, install/update, offline, lifecycle, and full campaign playthrough pass.
- [ ] Required suites pass 100%; no blocker test is silently flaky/quarantined, and rerun-until-green output is not substituted for a fixed test.
- [ ] Zero open P0/P1; no more than two accepted P2s remain, no more than one affects the same common flow or tier, protected critical scopes consume none of the budget, and every accepted P2 has explicit player impact and post-launch owner.
- [ ] Crash-free target met; no data loss, reward duplication, progression block, review blocker, or unsupported-device failure.
- [ ] Archive, dSYM/symbols, manifest, licenses, privacy report, test evidence, store metadata/assets, review notes, and known-issue log retained.
- [ ] Support page, privacy page, contact inbox, crash triage, status communication, and emergency build pipeline tested.
- [ ] Price, territories, availability date, and release method approved.
- [ ] No acceptance criterion in RC scope still contains `[PLACEHOLDER]` or lacks a fixed owner/denominator/evidence link.

## Release strategy

- [ ] Submit early enough for review uncertainty without promising an unapproved public date.
- [ ] Select **manual release** for 1.0.
- [ ] Confirm phased release does not apply to first-version 1.0; it is a seven-day update-only tool, may be paused for up to 30 cumulative days, and is not rollback because anyone may manually download the update.
- [ ] After approval, run final server/URL/support/privacy checks even though core game is offline.
- [ ] Freeze UTC release time, enabled storefronts, minimum/mid/current smoke devices, monitoring sources/expected latency, owners, hourly polling cadence, and staffed/on-call coverage before release.
- [ ] Staff continuously through at least eight hours after first public availability; if propagation remains incomplete, named on-call ownership continues hourly checks through the recorded 24-hour state.
- [ ] Confirm product page live, price/territories correct, install from store, receipt/first launch/offline/save path, and support links.
- [ ] Record exact release time/build/store state; timestamp support/store/available diagnostic checks at least hourly, checking slower sources at every refresh and recording their latency.
- [ ] Allow possible storefront propagation of up to 24 hours; do not promise an exact public instant before live verification.

## Launch-day checks

- [ ] Fresh App Store install on minimum, mid, and current device.
- [ ] First launch, tutorial, expedition, extraction/failure, Results, Garage transaction, quit/resume, offline relaunch, and update path.
- [ ] Store screenshots/description/privacy/age/accessibility/controller claims visually correct.
- [ ] Crash/hang metrics, reviews/support inbox, save reports, and performance/device anomalies monitored.
- [ ] Known issues/support replies use approved facts; do not advise destructive reset before preserving diagnostics and both verified-slot candidates.
- [ ] No live tuning/content/SDK change without versioned build and release process.
- [ ] `KD-G10` remains RUNNING for a failed public smoke, unavailable monitoring source without replacement evidence, unknown live failure, open P0/P1, or unowned propagation state.

## Rollback and emergency patch

There is no dependable binary rollback after customers update. The safety plan is prevent, contain, communicate, and ship a forward-compatible patch.

- [ ] Retain every public archive, symbols, tag, toolchain manifest, store snapshot, save fixtures, and known-good clean profile; identify the latest public tag before branching.
- [ ] Prelaunch binary/content/config changes after `KD-G7` restart it. Only a post-launch urgent smallest-scope fix can enter `KD-E1`; broader/non-urgent updates return to normal `KD-G7`.
- [ ] Emergency branch/build path produces the next monotonically increasing patch version/build from the latest public tag with no unrelated change.
- [ ] Save migrations are forward-only and patch-compatible; a patch never writes a schema the prior approved emergency fallback cannot safely recognize unless unavoidable and reviewed.
- [ ] Feature/content kill switches are local/versioned and used only for non-core optional behavior; no mandatory remote dependency.
- [ ] Criteria defined for remove-from-sale, stop phased update for later versions, support notice, or expedited review request.
- [ ] Response authority is recorded: Release Owner controls hold/remove-from-sale/phased-update-pause/expedite/emergency submission; Privacy/Compliance Owner concurs for security/privacy/legal incidents.
- [ ] P0 internal target: triage starts within 15 staffed minutes, hold/remove/communication decision within 60 minutes, and customer-facing support advisory within two hours when affected; App Review timing is never promised.
- [ ] P1 internal target: triage starts within four staffed hours with owner/containment/patch decision the same staffed day.
- [ ] `KD-E1` retains reproduced-before/fixed-after evidence on every affected tier plus minimum/mid/current; passes clean update/save smokes from every supported public predecessor, 100% full P0/P1 blocker suite and every affected earlier gate, and 1,000/1,000 faults when persistence/progression/lifecycle changes.
- [ ] Exact patch records >=25 internal-TestFlight sessions over >=4 staffed hours, >=5 per minimum/mid/current and each additional affected tier, 100% conservative session health, and no unknown termination; Evidence, Build, Privacy/Compliance, and Release Owners sign the delta before emergency submission.
- [ ] Expedited review is requested only for qualifying critical circumstances with current-version reproduction/impact; the plan assumes Apple may decline or take longer.
- [ ] Never delete/mask a broken save automatically. Recover an eligible lower verified slot only under the declared corruption rule, preserve evidence, and communicate; future schema/content/migration failure remains blocked.

## Post-launch stabilization

- [ ] Record seven complete UTC days after launch or latest public patch, with daily reported sessions/failed equivalents by tier, support/root-cause counts, backlog age, device evidence, update/save state, and compliance state; a patch restarts all seven days.
- [ ] Aggregate observed reported-session health >=99.8%; every tier with >=100 attributable sessions >=99.5%; every lower-volume failed equivalent classified; missing/delayed evidence extends the window.
- [ ] Zero reproducible save loss/P0/P1; no unknown termination or support item untriaged beyond one staffed day; <=2 accepted P2s with no escalation and no same-root P2 report count rising three consecutive UTC days.
- [ ] Every emergency patch is limited to verified urgent defects, compatibility, and severe blocking balance issues; no destabilizing feature bundle.
- [ ] Validate every patch against all supported public-predecessor install/update/save fixtures and exact App Store declarations.
- [ ] After stabilization, publish a retrospective: actual performance/device/support metrics, escaped defects, roadmap changes, and first deferred expansion decision.

## Checklist definition of done

Every applicable box is checked with an owner and evidence link in the release runbook; every inapplicable item has a recorded reason. The exact selected archive, declarations, metadata, assets, privacy report, review notes, and retained evidence agree. Any mismatch reopens the release gate.
