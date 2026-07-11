# Keep Driving App Store Release Checklist

Status: not ready; launch checklist for 1.0.0
Checklist snapshot: 2026-07-11
First-party research: [Apple App Store and Godot iOS Requirements](research/APP_STORE_REQUIREMENTS.md)

## Release policy

- 1.0 is a premium, one-time-purchase, offline-first iPhone game.
- No advertising, cross-app tracking, ATT prompt, account, launch IAP, subscription, or mandatory network service.
- Native iPad, Game Center, and cloud save ship only if their full product, privacy, device, metadata, and review gates pass; otherwise they remain disabled and undisclosed.
- Use manual release after approval so support, monitoring, metadata, and emergency response are staffed.
- Recheck current Apple/Godot requirements at first signed export, first external TestFlight, release-candidate upload, and final submission.

## Current repository blockers

- [ ] Production game/content complete and desktop gates pass.
- [ ] `export_presets.cfg` with reproducible iOS export exists.
- [ ] Xcode 26+ and iOS 26 SDK upload floor revalidated against Apple's live requirements.
- [ ] Matching Godot 4.7 export templates and exporter compatibility proven.
- [ ] App version, build number, bundle ID, Team ID, signing, entitlements, device family, deployment target, icons, and launch storyboard configured.
- [ ] Physical-device install, lifecycle, performance, memory, thermal, battery, audio, haptic, input, and save proof passes.
- [ ] App Store Connect record, agreements, tax/banking, territory, pricing, privacy, age, accessibility, export, DSA/trader, metadata, and assets complete.
- [ ] Internal/external TestFlight and release-candidate gates pass.

## App identity and signing

### Decisions

- Product name: **Keep Driving**.
- Candidate bundle identifier: `com.scwlkr.keepdriving`; verify ownership/availability before creating the App ID. Do not upload a build until this immutable choice is approved.
- Marketing version: `1.0.0`.
- Build value: monotonically increasing CI/release number; never reuse an uploaded build value.
- Primary language: English.
- Device family: iPhone for required 1.0 scope; enable iPad only after native layout/device/store-asset gates.
- Deployment target: provisional iOS 17.0; revalidate before external TestFlight.

### Checklist

- [ ] Apple Developer Program membership active and correct legal entity selected.
- [ ] Current Apple Developer and App Store Connect agreements accepted.
- [ ] Bundle ID approved and registered as an explicit App ID.
- [ ] App Store Connect app record created with matching bundle ID, stable SKU, primary language, and name reservation.
- [ ] Team ID recorded in private release runbook and Godot export environment.
- [ ] Distribution certificate/signing identity valid through launch and emergency-patch window.
- [ ] App Store provisioning/profile or Xcode automatic-signing policy documented and reproducible.
- [ ] `xcode-select` targets the approved Xcode; license, command-line tools, iOS platform, and archive destination verified.
- [ ] No signing secrets, certificates, provisioning profiles, passwords, or Team credentials committed to git.
- [ ] Required capabilities/entitlements are a minimal exact list. Remove Game Center, push, iCloud, background modes, network, or other entitlements unless shipped and tested.
- [ ] Generated Xcode target bundle ID, display name, version, build, deployment target, device family, orientations, icons, launch storyboard, entitlements, privacy manifest, and release settings inspected.
- [ ] Release archive is ARM64, correctly signed, contains no debug entitlement/tool, and maps to one tagged commit/build manifest.

## Toolchain and build requirements

- [ ] Recheck [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) at the release gate.
- [ ] Approved Xcode and iOS SDK versions recorded in build manifest.
- [ ] Approved Godot exact version and export-template hash recorded.
- [ ] Godot iOS export preset committed without secrets.
- [ ] Clean clone can validate, test, bake content, export Xcode project, and produce a Release archive through documented commands.
- [ ] CI/release host has controlled toolchain, keychain access, provisioning, and enough disk.
- [ ] Semantic version, build value, commit SHA, content version, and save schema embedded and visible in diagnostics.
- [ ] Build manifest contains archive hash, symbols, catalogs/world hashes, licenses, privacy SDK list, tests, and performance/device evidence.
- [ ] Release build strips cheats, debug overlay, test profiles, placeholder content, verbose logs, and development telemetry.
- [ ] Archive validates in Xcode and App Store Connect with no unresolved processing error or relevant warning.
- [ ] Processed build is selected for the correct `1.0.0` App Store version.

## Product-completeness requirements

- [ ] Primary progression plays from first launch through final restoration and Results.
- [ ] All required regions, landmarks, safehouses, contracts, encounters, chassis, parts, loadouts, Expedition Mode, settings, accessibility, and credits are present and production-quality.
- [ ] No placeholder art/audio/text, empty state, debug copy, missing localization key, broken URL, unreachable content, or disabled unfinished button.
- [ ] Offline first launch after install works unless App Store receipt behavior requires a documented network case.
- [ ] Core game, saves, progression, and Expedition Mode work in airplane mode after installation.
- [ ] No login or account required.
- [ ] Premium pricing and territories approved; final regional price is consistent with product decision.
- [ ] If any IAP is later added, it receives separate StoreKit product, restore, parental, price, privacy, receipt, offline, review, and metadata scope; no launch IAP is assumed.
- [ ] If Game Center is added, entitlement/configuration, authentication/offline behavior, achievements/leaderboards, privacy, review notes, and UI all pass; otherwise entitlement is absent.
- [ ] Controller support disclosure matches actual optional/required behavior.

## Icons and launch experience

- [ ] Final 1024 x 1024 base/App Store icon approved and embedded through Godot/Xcode asset catalog.
- [ ] Dark/tinted icon variants included only if supported and visually approved.
- [ ] Icon has no transparency/forbidden treatment and remains legible at every rendered size.
- [ ] Launch storyboard/screen uses final brand, correct background, safe areas, both landscape orientations, and no misleading progress/control.
- [ ] Cold launch transitions from launch screen to interactive app without visual jump or long blank frame.
- [ ] App icon and launch assets tested on every supported appearance/device class.

## Product-page metadata

### Working metadata

- Name: `Keep Driving`.
- Subtitle candidate: `Survive the Open Road` (validate length and positioning).
- Primary category: Games.
- Game subcategories: choose from the current App Store taxonomy at record creation; likely Action/Adventure, subject to final positioning.
- Description: final 4,000-character maximum copy centered on open-road survival, vehicle builds, three-region exploration, offline premium play, and accessibility—no unshipped promise.
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
- [ ] Up to three previews per localization/device size only when quality justifies production cost; otherwise omit.
- [ ] Source captures, edit project, final exports, licenses, and exact build retained.

## Age rating and content

- [ ] Complete the live age-rating questionnaire for the exact release content.
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
- [ ] Claim only features that support **all common tasks**. Do not claim VoiceOver, Voice Control, Larger Text, Reduced Motion, captions, or another label based on partial screens.
- [ ] Accessibility claims match product page, review notes, support docs, and exact build.

## Privacy and legal

### Privacy-minimal baseline

- [ ] Final binary and every SDK inventoried by name, version, purpose, data, endpoint, retention, deletion/opt-out, required-reason API, and privacy manifest/signature status.
- [ ] Confirm no advertising identifier, cross-app/site tracking, fingerprinting, advertising SDK, account, user-generated content, or location/camera/microphone/contact permission.
- [ ] If the final app and partners collect no data, select App Store Connect's explicit no-data response and retain evidence. If anything is collected, disclose every qualifying data type/use/linkage accurately.
- [ ] No ATT prompt unless the exact binary performs Apple-defined tracking; gameplay is never gated on consent.
- [ ] Local structured diagnostics contain no unnecessary personal/sensitive data and are not uploaded without an explicit, documented flow.

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
- [ ] Credits/licenses screen and source/license manifest complete.
- [ ] Content rights declaration accurate.
- [ ] Copyright owner/year accurate.
- [ ] EU Digital Services Act trader status declared; verification/contact disclosure complete if distributing as a trader in the EU.
- [ ] Territory-specific permits, consumer requirements, tax, and banking reviewed.
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
- [ ] Test information includes beta description, feedback email, What to Test, privacy URL, contact, and exact review instructions.
- [ ] Save schema/build compatibility and known defects stated to testers.

### Internal testing

- [ ] Assigned minimum/small/mid/large/current device matrix complete.
- [ ] Clean install, update, offline, touch/controller, safe area, 200% text, lifecycle, save, memory, thermal, battery, low storage, audio route, and primary flow pass.
- [ ] Crash/hang/save/performance results reviewed per build.
- [ ] No internal P0/P1; bounded P2 list has owners.

### External testing

- [ ] First external group submitted through TestFlight App Review when required.
- [ ] 20-30 person first wave covers device/input/accessibility/player-experience gaps.
- [ ] Larger wave used only to close content/economy/reliability confidence, not substitute for structured tests.
- [ ] Feedback, screenshot reports, crashes, hangs, device metrics, support contacts, and questionnaire results triaged.
- [ ] At least 99.8% crash-free sessions and zero reproducible save loss over the release beta window.
- [ ] TestFlight 90-day build expiry and tester access monitored.

## Physical-device and performance release gate

- [ ] Minimum device sustains approved 30 FPS with p95 <=33.3 ms and no repeated >50 ms hitch.
- [ ] A15-class and newer target devices sustain 60 FPS with p95 <=16.7 ms and p99 <=25 ms.
- [ ] Gameplay working set <=350 MB target and process peak <=500 MB provisional hard ceiling, or a documented evidence-based revision is approved.
- [ ] Thirty-minute thermal/battery soak passes on minimum/mid/current devices.
- [ ] Two-hour memory/traversal soak plateaus within +/-5% after warm-up.
- [ ] Cold launch <=5 seconds; resume <=2 seconds, target <=1 second.
- [ ] Touch/haptic/audio/controller/lifecycle behavior remains correct under frame and thermal fallback.
- [ ] No blank terrain, invisible wall, stuck input, duplicated audio loop, reward duplication, or save inconsistency.

## Save-data validation

- [ ] Real v0 profile migrates and retains supported value.
- [ ] Every supported schema fixture migrates idempotently.
- [ ] 1,000 interrupted write/background/termination cycles produce no profile loss or duplicated reward.
- [ ] Corrupt primary recovers the newest valid backup and preserves diagnostics.
- [ ] Low-storage write failure preserves last known-good save and informs player.
- [ ] Clean install/new profile, update, active-expedition resume, results payout, purchase/fabrication, reset, and recovery pass on devices.
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
- [ ] Build selected in a draft submission with all required items, then submitted.

## Final release-candidate checks

- [ ] RC commit/tag frozen; only release-blocker changes accepted through reviewed cherry-picks/new RC build.
- [ ] Clean-clone build reproduces the selected archive hash/equivalent signed provenance.
- [ ] All automated suites, content validators, rendered captures, desktop and iOS performance, save faults, accessibility, localization, install/update, offline, lifecycle, and full campaign playthrough pass.
- [ ] Zero open P0/P1; every accepted P2 has explicit player impact and post-launch owner.
- [ ] Crash-free target met; no data loss, reward duplication, progression block, review blocker, or unsupported-device failure.
- [ ] Archive, dSYM/symbols, manifest, licenses, privacy report, test evidence, store metadata/assets, review notes, and known-issue log retained.
- [ ] Support page, privacy page, contact inbox, crash triage, status communication, and emergency build pipeline tested.
- [ ] Price, territories, availability date, and release method approved.

## Release strategy

- [ ] Submit early enough for review uncertainty without promising an unapproved public date.
- [ ] Select **manual release** for 1.0.
- [ ] After approval, run final server/URL/support/privacy checks even though core game is offline.
- [ ] Release during a staffed monitoring window, not before an unattended period.
- [ ] Confirm product page live, price/territories correct, install from store, receipt/first launch/offline/save path, and support links.
- [ ] Record exact release time/build/store state and begin monitoring/support cadence.

## Launch-day checks

- [ ] Fresh App Store install on minimum, mid, and current device.
- [ ] First launch, tutorial, expedition, extraction/failure, Results, Garage transaction, quit/resume, offline relaunch, and update path.
- [ ] Store screenshots/description/privacy/age/accessibility/controller claims visually correct.
- [ ] Crash/hang metrics, reviews/support inbox, save reports, and performance/device anomalies monitored.
- [ ] Known issues/support replies use approved facts; do not advise destructive reset before preserving diagnostics/backups.
- [ ] No live tuning/content/SDK change without versioned build and release process.

## Rollback and emergency patch

There is no dependable binary rollback after customers update. The safety plan is prevent, contain, communicate, and ship a forward-compatible patch.

- [ ] Retain selected 1.0.0 archive, symbols, tag, toolchain manifest, store snapshot, save fixtures, and known-good clean profile.
- [ ] Emergency branch/build path can produce `1.0.1` with a new build value from the release tag.
- [ ] Save migrations are forward-only and patch-compatible; a patch never writes a schema the prior approved emergency fallback cannot safely recognize unless unavoidable and reviewed.
- [ ] Feature/content kill switches are local/versioned and used only for non-core optional behavior; no mandatory remote dependency.
- [ ] Criteria defined for remove-from-sale, stop phased update for later versions, support notice, or expedited review request.
- [ ] P0 response: reproduce/preserve diagnostics, stop risky rollout where possible, publish support notice, patch smallest safe fix, run focused plus full blocker suite, upload new build, update Review Notes, and monitor.
- [ ] Never delete/mask a broken save automatically. Recover backup, preserve evidence, and communicate.

## Post-launch stabilization

- [ ] Daily first-week triage of crashes, hangs, saves, progression blockers, device performance, review/support themes, and privacy/security reports.
- [ ] `1.0.1` limited to verified defects, compatibility, and severe balance issues; no destabilizing feature bundle.
- [ ] Validate every patch against 1.0.0 install/update/save fixtures and exact App Store declarations.
- [ ] After stabilization, publish a retrospective: actual performance/device/support metrics, escaped defects, roadmap changes, and first deferred expansion decision.

## Checklist definition of done

Every applicable box is checked with an owner and evidence link in the release runbook; every inapplicable item has a recorded reason. The exact selected archive, declarations, metadata, assets, privacy report, review notes, and retained evidence agree. Any mismatch reopens the release gate.
