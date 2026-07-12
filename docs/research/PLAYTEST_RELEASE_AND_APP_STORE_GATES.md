# Playtest, Release, and App Store Gate Decision

Status: selected target for ticket 06
Research date: 2026-07-11

## Decision

Production readiness is a cumulative chain of evidence-bound gates, not a final checklist sweep or a calendar date. Use one `ReleaseEvidenceLedger` for each candidate version, with stable gate IDs `KD-G0` through `KD-G11`. A gate can be `NOT_STARTED`, `RUNNING`, `PASS`, `FAIL`, or `REOPENED`; required gates are never waived. Every pass names the exact candidate, owner, dated evidence, accepted P2 risks, and triggers that would reopen it.

The chain is:

0. evidence/measurement contract;
1. risky-system desktop human truth;
2. desktop alpha;
3. desktop content-complete beta;
4. frozen desktop reference;
5. signed iOS integration;
6. physical mobile acceptance;
7. exact-build external release beta;
8. App Store package and compliance;
9. release candidate, App Review, and go/no-go;
10. manual staffed launch;
11. immediate stabilization.

No binary, content, configuration, SDK, entitlement, declaration, or store claim is allowed to inherit evidence it invalidates. A failed metric changes the product or candidate and reruns the gate; it does not move the threshold after results are known.

## Evidence audited

The repository already contains a strong release package:

- `docs/PLAYTEST_PLAN.md` defines evidence classes, structured cohorts, progression tests, device evidence, regression, severity, and release blockers.
- `docs/APP_STORE_RELEASE_CHECKLIST.md` covers identity, signing, build, metadata, assets, accessibility, privacy, export compliance, TestFlight, RC, launch, and emergency patching.
- `docs/MOBILE_PORTING_PLAN.md` defines the physical-device matrix and desktop-to-mobile entry boundary.
- `docs/ROADMAP_TO_1.0.md` sequences desktop alpha through stabilization and already requires a 50-participant, 1,000-session, 14-day external beta.
- `docs/research/APP_STORE_REQUIREMENTS.md` records current first-party Apple and Godot constraints.

The missing contract was not another list. It was one stable gate identity/ledger, exact authority, cross-build evidence rules, cohort overlap rules, a reproducible TestFlight denominator, placeholder-lock policy, and timed incident decisions.

## Current first-party constraints

These facts are volatile and must be rechecked at the Phase-2 signed feasibility build, first external TestFlight build, and release-candidate submission.

- App Store Connect currently accepts up to 100 internal and 10,000 external TestFlight testers. External testing requires beta test information; the first external build requires TestFlight App Review, later builds may not require a full review, and builds expire after 90 days. [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/)
- An internal group must exist before creating an external group. A build uploaded as TestFlight Internal Only cannot later go to external testers or customers. “What to Test” is per build; beta description, feedback email, contact/review notes, and any credentials belong to external test information. [Invite external testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers), [provide test information](https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-test-information/)
- TestFlight exposes installs, sessions, crashes, and feedback for a build; its build table shows sessions from the last seven days. This project retains daily views for audit but derives the 14-day denominator only from two disjoint seven-day boundary exports/snapshots. TestFlight does not supply a combined hang/watchdog gate; those incidents come from device reports and Xcode Organizer. [View build status and metrics](https://developer.apple.com/help/app-store-connect/test-a-beta-version/view-build-status-and-metrics/), [improving responsiveness](https://developer.apple.com/documentation/xcode/improving-app-responsiveness)
- Accessibility Nutrition Labels are voluntary at this snapshot but are expected to become mandatory over time. A feature may be claimed only when every common task works with it on the declared device type. [Accessibility Nutrition Labels](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels)
- Privacy answers include third-party partners. The archive must carry valid privacy manifests where required, and required-reason APIs/covered SDK manifests and signatures must be correct. [App privacy details](https://developer.apple.com/app-store/app-privacy-details/), [privacy manifests](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files)
- The age-rating questionnaire is authoritative, an Unrated app cannot publish, and App Store Connect added social-media-capability questions on 2026-07-09. [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/), [App Store Connect release notes](https://developer.apple.com/help/app-store-connect/release-notes/)
- Product pages require one to ten screenshots. App previews are optional, allow up to three per localization/device, run 15-30 seconds, are at most 500 MB and 30 fps, use supported H.264/ProRes formats, and show captured app footage; narration/overlays may explain it. Recheck the live tables before capture. [Upload previews and screenshots](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots), [screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/), [app preview specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications/)
- Marketing icon/screenshots/previews must be suitable for a 4+ audience even when the app's calculated age rating is higher. Final icon assets use the current layered appearance workflow with a full-bleed opaque background and are inspected in default/dark/clear/tinted appearances rather than enforcing the obsolete blanket “no transparency” rule. [App Review Guideline 2.3.8](https://developer.apple.com/app-store/review/guidelines/#accurate-metadata), [App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons/)
- Optional controller support must match the archived Game Controllers capability/Info.plist declarations, including supported profiles, `GCSupportsControllerUserInteraction`, and `GCRequiresControllerUserInteraction` only if a controller is genuinely required. [Configuring game controllers](https://developer.apple.com/documentation/xcode/configuring-game-controllers)
- Distribution is Public for 1.0 unless a later recorded decision changes it before approval. The distribution method cannot normally change after approval. Explicitly test or opt out of default iPhone-app availability on Apple-silicon Macs and Apple Vision Pro. [Distribution methods](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/set-distribution-methods), [Apple-silicon Mac availability](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/manage-availability-of-iphone-and-ipad-apps-on-macs-with-apple-silicon/), [Vision Pro availability](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/manage-availability-of-iphone-and-ipad-apps-on-apple-vision-pro)
- Storefront selection has jurisdiction-specific game requirements. Vietnam, mainland China, and conditionally Korea require explicit license/approval review before those territories are enabled. [App information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
- A version can release manually, automatically, or automatically no earlier than a date. Keep Driving 1.0 uses manual release. Apple says storefront propagation can take up to 24 hours. [Release option](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/select-an-app-store-version-release-option/), [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Seven-day phased release applies to version updates, not the first 1.0 release, and users can still manually download the update. It is containment, not rollback. [Phased release](https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-update-in-phases/)
- Apple accepts expedited-review requests for extenuating circumstances such as a critical bug, but approval/timing is not guaranteed. [App Review](https://developer.apple.com/app-store/review/)

## Alternatives considered

### Informal playtest notes plus a final checklist

Cheapest, but evidence drifts across builds, failures are easy to rationalize, and no one can prove which archive a result qualified. Rejected.

### One giant release-candidate gate

Simple to describe, but discovers feel, content, save, device, and compliance failures after their cost of change is highest. Rejected.

### Cumulative exact-candidate gates

Selected. It costs more record keeping and can reset a beta window after a late binary fix, but it gives every downstream phase a trustworthy input and makes release authority explicit.

## Release evidence ledger

The future release runbook creates `docs/release/<version>/RELEASE_EVIDENCE.md` from a small template. The file contains no credentials, certificates, private tester contact data, or legal advice.

Each gate row records:

- gate ID/name and status;
- candidate version/build, commit/tag, content version, save schemas, and archive hash where applicable;
- entry prerequisites;
- exact pass criteria and raw/aggregate evidence links;
- evidence owner and decision owner;
- start/pass/reopen timestamps;
- tested devices/OS/input/settings/cohorts;
- open P2 entries with impact, frequency, workaround, owner, and target;
- volatility/revalidation checks;
- change-impact reason if reopened.

The ledger also links one immutable candidate manifest containing toolchain, Godot/export-template hashes, bundle/version/build, catalogs/world hashes, symbols, licenses, SDK/privacy inventory, store metadata snapshot, and support/emergency artifacts.

### Roles

| Role | Authority |
|---|---|
| Evidence Owner | Verifies required evidence exists, uses the declared denominator, and marks FAIL/REOPENED when it does not. |
| Build Owner | Attests source/tag/toolchain/archive provenance and retains symbols/manifests. |
| Product Owner | Accepts product scope, human-experience results, and any P2 risk within the fixed budget. |
| Privacy/Compliance Owner | Attests exact-archive privacy, accessibility, age, export, rights, and store declarations; escalates legal uncertainty. |
| Release Owner | Sole go/no-go authority for submission/manual release/containment. Must have the necessary App Store Connect role or delegate the button press to one who does. |

One person may hold multiple roles on a small team, but each attestation remains separate and evidence cannot be self-created human-naive evidence. At least one person outside the implementing loop executes the store/reviewer path and support discovery smoke.

## Gate ladder

| Gate | Candidate and minimum evidence | Pass result | Reopens on |
|---|---|---|---|
| `KD-G0 Evidence Contract` | Frozen script, thresholds, cohort/device quotas, clock anchors, owners, consent/retention, artifact paths, required-suite map, and change-to-retest matrix | Every downstream criterion has a denominator and owner; no placeholder remains in the gate being entered | Measurement, threshold, cohort, device, privacy, or required-suite contract change |
| `KD-G1 Risk Truth` | Frozen representative desktop slices; handling, hero minute, hybrid region, buildcraft, economy, and desktop UX/audio/accessibility cohorts from the Playtest Plan | Each desktop risky claim meets its human, rendered, automated, and performance criterion; no unresolved P0/P1. Touch, haptic, safe-area, mobile-input, physical-device, and mobile-accessibility claims remain for `KD-G6` | Material behavior/presentation/input/content-rule change in the tested claim |
| `KD-G2 Desktop Alpha` | Exported integrated desktop alpha; 10-15 invited players; clean/mid/late fixtures; keyboard/controller; save/perf/accessibility | Major systems form one comprehensible loop; >=80% loop comprehension; median >=4/5 after corrective work and retest; zero P0/P1 | System authority, common flow, major UX, save, or representative workload change |
| `KD-G3 Desktop Content Beta` | Content-complete desktop candidate; 20-30 players; at least 10 new clean primary-arc completions, five mastery completions, and 10 people completing three unmoderated sessions across >=7 days | D020 scope/count/duration/diversity/longitudinal gates pass without grind/filler; full content/license/string IDs; zero P0/P1; no more than five accepted P2s under the fixed risk budget | Required content, balance, progression, catalog IDs, ending, or workload change |
| `KD-G4 Desktop Reference` | Tagged content-complete optimized desktop build; full campaign, seeds/faults/soaks/input/accessibility | Reproducible frozen desktop reference meets all frame/memory/save/install/update gates and becomes the sole mobile baseline | Shared gameplay/content/save/interface change or accepted budget revision |
| `KD-G5 Signed iOS Integration` | Stable supported macOS/Xcode/SDK, exact Godot/templates, production identity, signed physical install and internal TestFlight | Reproducible archive; correct identity/orientation/safe area; basic lifecycle/save/audio/haptic path; no gameplay fork | Toolchain/exporter/signing/entitlement/adapter/shared-code change |
| `KD-G6 Mobile Acceptance` | Locked model/OS/input/frame/quality matrix: >=1 physical device per minimum/small/mid/large/current tier plus a second minimum and current device; deployment-min latest patch and latest public iOS; final-content internal build; 10 first-time-iPhone participants not reused at `KD-G7`; 1,000 faults; >=200 internal-TestFlight sessions in one frozen seven-day UTC window with every tier >=20 attributable sessions | Every assigned matrix row meets every locked functional/performance/accessibility budget; 1,000/1,000 faults pass; cohort reaches 9/10 unaided driving and 8/10 first launch -> expedition -> pause/background/resume -> Settle -> Service using touch; internal conservative health >=99.5%; zero P0/P1; external candidate frozen | Binary/content/config/device-floor/quality-tier/common mobile-flow change |
| `KD-G7 External Release Beta` | Same processed build graduated from `KD-G6`; >=50 active external participants, >=1,000 TestFlight-reported sessions in two disjoint seven-day UTC windows; every tier >=5 participants/100 attributable sessions; 10 first-time-iPhone participants distinct from `KD-G6` | Conservative crash-free score >=99.8%; 9/10 first-time players drive without help and 8/10 complete first launch -> expedition -> pause/background/resume -> Settle -> Service using touch; zero reproducible save loss, P0, or P1; device/content/accessibility/support coverage complete | Any prelaunch binary/content/config change; a new build resets participant/session/window evidence for this gate |
| `KD-G8 Store Package` | The same processed build that passed `KD-G7`, selected for App Review; final metadata/assets/URLs/declarations/privacy report/review notes; five-player blind product-page test | Every applicable checklist item has owner/evidence; 4/5 target players identify route-shaped buildcraft/county restoration from unbranded store assets without inferring an unshipped feature; archive and claims agree; review package approved internally | Any new processed build resets `KD-G7`; SDK/entitlement/privacy/age/accessibility/export/right/metadata/URL/price/territory/distribution changes reopen affected scope |
| `KD-G9 RC and Review` | Frozen RC tag/archive plus all previous ledgers; full blocker regression and emergency drill | Zero P0/P1; no more than two accepted P2s under the fixed risk budget; App Review approval; Release Owner signs exact archive and manual-release plan | Any binary change; review-required product change; App Review finding that contradicts evidence/claims |
| `KD-G10 Manual Launch` | Approved version in Pending Developer Release; frozen UTC/storefront/device/monitoring contract; >=8 consecutive staffed hours after first availability plus named on-call propagation owner | Hourly timestamped support/store/available diagnostic checks; minimum/mid/current page/purchase/install/first launch/core offline/save/support smokes pass; 24-hour propagation state recorded; zero open P0/P1 or unknown live failure | Store/configuration mismatch, failed smoke/source, live P0/P1, unknown failure, or incomplete propagation ownership |
| `KD-G11 Stabilization` | Seven complete UTC days after launch or latest emergency patch; daily session/failed-equivalent/tier/support/device/compliance ledger | Aggregate observed health >=99.8%; each tier with >=100 sessions >=99.5% and every lower-volume incident classified; zero reproducible save loss/P0/P1; no item untriaged >1 staffed day; <=2 P2 with no escalation or three-day same-root rise; update/save/declarations safe | Emergency patch, new P0/P1, data-loss cluster, compliance mismatch, missing evidence, or failed health/tier/support rule |

## Cohort and measurement rules

- A person counts as naive for only one first-exposure gate. They may return in later cohorts if the session is labeled returning; their later session cannot be used as new-player evidence.
- Implementers and agents never substitute for naive human players. Facilitators do not explain intended behavior before observation.
- Before outcomes are viewed, each script fixes `N`, eligible cohort, tasks, clock start/stop, numerator/denominator, rounding, and invalid-session rules. Only facilitator/technical failures unrelated to player behavior may be excluded; exclusion reason is retained and the participant is replaced.
- Desktop alpha and content beta may share returning players, but the explicit clean-profile/new-player minimums remain independent.
- An active external participant is one unique person assigned to the external group with at least one TestFlight-reported session inside `W1` or `W2`. Before `T0`, assign each person one coverage tier; they count toward that tier's participant floor only after at least one attributable session on it, otherwise only toward the global 50. Earlier-build testers may participate, but only exact-build window sessions count; the ten first-time-iPhone participants are distinct from `KD-G6`.
- Each supported device tier must have at least five external participants and 100 reported sessions inside the overall 50-participant/1,000-session floor. A device may satisfy only its declared tier for coverage accounting.
- VoiceOver or Voice Control product-page claims require the exact-build common-task matrix plus at least two participants who regularly use that assistive technology. If recruitment or native feasibility fails, leave the label unclaimed; do not weaken the non-native accessibility baseline.
- Remaining `[PLACEHOLDER]` values may guide a prototype, but no gate can pass while a placeholder is part of its acceptance scope. The responsible earlier phase locks or supersedes it before candidate freeze.
- Tablet simulation is nonblocking reference evidence unless iPad is explicitly promoted into 1.0 scope; default Mac/Vision compatibility is handled as an App Store distribution decision, not silently inherited support.

## Exact-build reliability contract

`KD-G6` and `KD-G7` use App Store Connect TestFlight metrics for the exact candidate. Because the build table's aggregate session view is seven days, freeze access at a UTC boundary: internal `KD-G6` opens at `T0=00:00 UTC` for one seven-day window; `KD-G7` stops internal launches and opens external access at its own `T0=00:00 UTC` for disjoint `W1=[T0,T0+7d)` and `W2=[T0+7d,T0+14d)`. Archive the last-seven-day export/snapshot at each boundary and sum only the disjoint windows—daily rolling snapshots are audit evidence and are never summed. If a boundary is missed, internal use contaminates a window, or the source cannot support attribution, the gate remains running and starts a clean window/pair. Do not add a third-party analytics SDK merely to satisfy either gate.

For each daily audit view and boundary snapshot/export retain:

- exact version/build, tester groups, UTC window, and boundary timestamp;
- installs and TestFlight-reported sessions;
- TestFlight crash occurrences and symbolicated reports;
- distinct reported watchdog/unrecovered-hang incidents not already represented by a crash;
- per-tester/device/OS/tier attribution and unknown incidents;
- raw feedback/defect links without copying private tester identity into git.

Use a conservative score:

```text
failed_session_equivalents = crash_occurrences
                           + distinct_noncrash_watchdog_or_hang_sessions
                           + unresolved_unknown_termination_sessions

crash_free_score =
  (reported_sessions - failed_session_equivalents) / reported_sessions
```

Assign every session and failed equivalent by timestamp to exactly one window; do not double-count an incident across categories or windows. Repeated crashes may conservatively count as repeated failed equivalents even if one tester caused them. Per-tester/device records map a session to one declared tier; ambiguous sessions stay in the global denominator and count toward no tier. A lower score caused by conservative evidence still fails; it is not normalized away. `KD-G6` requires >=200 sessions, every tier >=20, and >=99.5% in its window. `KD-G7` requires `W1+W2` >=1,000 sessions, 50 active participants, every tier >=5 participants/100 attributable sessions, and >=99.8% on the same build.

After launch, App Store usage analytics may reflect only users who share analytics. Public `>=99.8%` is therefore an observed reported-session health target, interpreted with opt-in coverage, support reports, reviews, and device incidents; it is never described as complete population telemetry. `KD-G11` cannot pass on “improving”: delayed/missing metrics extend the window until seven complete evidenced UTC days meet the fixed rules.

## Severity, acceptance, and reopening

- P0/P1, reproducible save loss, privacy/security/legal mismatch, supported-device common-flow failure, or App Review blocker cannot be waived.
- A P2 becomes P1 when it appears in three independent sessions on a common path, affects at least 5% of applicable task opportunities, or affects every tested device in one supported tier. Lower-frequency P2 acceptance still requires impact, workaround, owner, fix target, and Product/Release Owner signoff.
- The aggregate P2 risk budget is at most five accepted open P2s through `KD-G8` and at most two through `KD-G9`-`KD-G11`, with no more than one affecting the same common flow or supported tier. Save/progression integrity, security/privacy/legal, common accessibility, install/purchase/launch/support, or App Review defects are P1 and cannot consume the budget. The cap is a ceiling; the Product or Release Owner may require zero.
- Every required automated suite must pass 100%. A flaky/quarantined test that covers a blocker criterion is itself a gate failure until fixed or replaced with equal coverage; rerunning until green does not erase the failing artifact.
- P3 work does not enter a frozen RC unless the change is demonstrably trivial and receives ordinary regression.
- A prelaunch binary/content/config change after `KD-G7` begins creates a new build and restarts that gate. After public launch, only an urgent smallest-scope fix may use `KD-E1`; a broader/non-urgent update returns to normal `KD-G7`. Metadata-only changes reopen `KD-G8/G9` but do not reset binary reliability unless they reveal a product mismatch.
- A change to save schema, catalog/world identity, SDK/privacy behavior, entitlement, toolchain, device floor, accessibility implementation, or core performance reopens every affected earlier gate listed in the ledger.
- A threshold may change only through a dated decision using evidence gathered before the candidate result being judged, then the affected gate reruns. No retroactive pass.

## Tester privacy and accessibility

- Recruitment/contact/incentive records stay in a private system; git stores anonymous session IDs and aggregate results only.
- Screen/audio/video or diagnostic upload requires explicit scoped consent. Participation and access needs do not affect compensation or issue severity.
- Delete identifiable raw capture by the earlier of 90 days after `KD-G11` or 180 days after capture. Cancellation or indefinite archive triggers a deletion review within 30 days. Separate consent or a documented legal/security need must name a new review/deletion date. Retain deidentified aggregates and release evidence.
- Test accessibility common tasks from first launch through settings, Service, Plan, Drive, pause/recovery, Settle, support/privacy, and reset. Claims are per device type and exact build. Baseline evidence requires at least five desktop and five physical-iPhone participants, each cohort including at least two people with relevant self-identified access needs; no diagnosis is collected.
- Accessibility Nutrition Labels are completed honestly for 1.0 even while voluntary at this snapshot. Unsupported or partially supported features remain unclaimed and limitations are documented at the accessibility URL.

## App Store package and review rules

- The release archive uses a pinned Apple-accepted stable Xcode/SDK on a supported stable macOS build. Beta toolchains are feasibility or TestFlight evidence only unless they become the live accepted release floor and are separately approved.
- The archive, build manifest, privacy report, privacy answers, required-reason API declarations, SDK signatures/manifests, entitlements, export determination, age rating, accessibility labels, controller claim, metadata, screenshots, previews, support/privacy URLs, and Review Notes must agree.
- Re-answer the live age-rating questionnaire after any final social, web, UGC, chat, advertising, violence, horror, gambling, substance, or capability change.
- Review Notes provide a reachable contact and fastest natural path through first launch, expedition, failure/extraction, Settle, Garage, offline/save/reset, touch, optional controller, and any hard-to-find content. There is no login/demo account unless scope changes.
- The first version uses manual release. Store propagation may take up to 24 hours, so no public promise assumes an exact instant and launch staffing continues until selected storefront/device checks pass.

## Launch and emergency contract

There is no dependable binary rollback after installation. Removing an app from sale prevents new availability but does not repair installed copies. A later phased update can be paused, but users can still download it manually. The response is hold, contain, communicate, forward-fix, requalify, and monitor.

- Before release, freeze UTC launch time, enabled storefronts, minimum/mid/current smoke devices, monitoring sources/latencies, owners, polling cadence, and staffed/on-call coverage. Staff at least eight consecutive hours after first public availability; check support/store/available diagnostic sources hourly; if propagation is incomplete, named on-call ownership continues hourly through the recorded 24-hour state.
- During that staffed launch window, a P0 begins triage within 15 minutes, receives a hold/remove-from-sale/communication decision within 60 minutes, and a user-facing support advisory within two hours when the issue affects customers. These are internal response targets, not a promise of App Review timing.
- A P1 begins triage within four staffed hours and receives an owner/containment/patch decision the same staffed day.
- Release Owner alone decides release hold, remove-from-sale, phased-update pause for later versions, expedited-review request, or emergency submission, with Privacy/Compliance Owner concurrence for security/privacy/legal incidents.
- Preserve both verified save slots and diagnostics before suggesting reset. Never silently delete/mask a broken profile or write an incompatible schema as a containment shortcut.
- `KD-E1 Emergency Patch` applies only after public launch. Build the smallest urgent fix from the latest public tag with the next monotonically increasing patch version/build and no unrelated change. Retain reproduced-before/fixed-after evidence on every affected tier plus minimum/mid/current; pass update/save smokes from every supported public predecessor, 100% of the full P0/P1 blocker suite and every affected earlier gate, and 1,000/1,000 faults when persistence/progression/lifecycle changes. The exact patch records >=25 internal-TestFlight sessions over >=4 staffed hours, >=5 per minimum/mid/current and each additional affected tier, 100% conservative session health, and no unknown termination. Evidence, Build, Privacy/Compliance, and Release Owners sign the delta.
- An expedited-review request includes current-version reproduction steps and impact, but release/support plans assume Apple may decline or take longer than requested.
- Stabilization restarts after a public patch and then requires seven complete evidenced UTC days: aggregate observed health >=99.8%; every tier with >=100 sessions >=99.5%; lower-volume failures all classified; zero reproducible save loss/P0/P1; no unknown/support item untriaged beyond one staffed day; no more than two P2s, no escalation, and no same-root P2 count rising three consecutive days; update/save/declarations safe. Missing evidence keeps `KD-G11` running, and feature expansion remains blocked.

## Tradeoffs

- Exact-build beta reset makes late prelaunch binary fixes expensive; that cost is intentional pressure against unstable RCs. The narrower post-launch `KD-E1` path exists only to reduce ongoing customer harm and carries its own non-waivable proof floor.
- Fifty testers and 1,000 sessions do not statistically prove absence of rare defects. They are a minimum operational gate layered over deterministic faults, long playthroughs, device matrices, support, and conservative incident counting.
- Manual release improves staffing/control but cannot guarantee simultaneous storefront propagation.
- Evidence/role separation adds ceremony for a small team, but it prevents one optimistic judgement from silently substituting for human, build, privacy, and release proof.
- Leaving unsupported accessibility labels unclaimed may reduce product-page discoverability; inaccurate claims would be worse for players and review integrity.

## Canonical integration

- Program/cohorts/severity/reliability: `docs/PLAYTEST_PLAN.md`.
- Exact App Store tasks and launch operations: `docs/APP_STORE_RELEASE_CHECKLIST.md`.
- Mobile matrix/TestFlight boundary: `docs/MOBILE_PORTING_PLAN.md`.
- Phase sequencing and critical path: `docs/ROADMAP_TO_1.0.md`.
- Durable decision: D041 in `docs/DECISIONS.md`.
