# Apple App Store and Godot iOS Requirements

Research snapshot: **2026-07-11**. This is a release-planning reference, not legal advice. It uses first-party Apple and Godot 4.7 documentation only.

## Current submission floor

- Since April 28, 2026, iOS uploads to App Store Connect must be built with **Xcode 26 or later** and an **iOS 26 SDK**. This is a build-SDK requirement, not a requirement to set iOS 26 as the deployment target. Apple changes this floor regularly. [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- The release binary must be complete, stable, tested on current physical devices, free of placeholder content, and accompanied by working support/privacy links. Apple identifies crashes, placeholder content, and incomplete information as common App Completeness failures. [Apple App Review preparation](https://developer.apple.com/app-store/review/) and [App Review Guideline 2.1](https://developer.apple.com/app-store/review/guidelines/#performance)
- App metadata, privacy declarations, screenshots, and previews must accurately represent the shipped experience. Screenshots must show the app in use; a title or splash screen alone is insufficient. [App Review Guidelines 2.3](https://developer.apple.com/app-store/review/guidelines/#accurate-metadata)

## Godot 4.7 iOS build requirements

- Export on **macOS with Xcode installed**, install the matching Godot export templates, add an iOS export preset, then export an Xcode project. Godot requires an App Store Team ID and unique reverse-DNS bundle identifier. The generated `.xcodeproj` is then built, run, archived, and distributed through Xcode. [Godot 4.7: Exporting for iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html)
- Keep `xcode-select` pointed at the active Xcode developer directory and ensure the Xcode license, command-line tools, iOS platform support, signing certificate, and provisioning are installed. Godot documents provisioning-profile environment overrides for automated builds. [Godot 4.7: Exporting for iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html#environment-variables)
- Configure the iOS preset deliberately: Team ID, bundle ID, signing identity/provisioning, minimum iOS version, target device family, ARM64, user-visible version, incrementing build value, export method, entitlements, icons, launch storyboard, and privacy declarations. Godot can export only the Xcode project for a downstream Fastlane/CI pipeline or build an archive/IPA itself. [Godot 4.7 iOS exporter properties](https://docs.godotengine.org/en/4.7/classes/class_editorexportplatformios.html)
- Godot 4.7's iOS simulator supports only the **Compatibility renderer**. Physical-device tests remain mandatory because simulator success does not prove touch, haptics, memory, thermal, battery, graphics-driver, background/resume, or signing behavior. [Godot 4.7: Exporting for iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html#export-a-godot-project-to-xcode)
- Godot 4.7 exposes iOS export fields for a 1024x1024 base/App Store icon, dark/tinted icon variants, launch-storyboard images/colors, Game Center and push entitlements, required-reason API declarations, collected-data declarations, tracking domains, and permission-purpose strings. Configure only capabilities the final app actually uses, then inspect the generated Xcode target and archive. [Godot 4.7 iOS exporter properties](https://docs.godotengine.org/en/4.7/classes/class_editorexportplatformios.html)

## App identity, signing, and build record

- Enroll in the Apple Developer Program, accept current agreements, create a unique App ID/bundle ID, and create the App Store Connect record before upload. The bundle ID in App Store Connect must match the generated Xcode target and cannot be changed after the first build upload. [App information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
- Set a stable SKU and primary language when creating the record. A build is associated by bundle ID and version; its build string uniquely identifies that upload. Every upload intended to coexist must therefore use a new build value. [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds)
- Archive a **Release** configuration, validate it in Xcode/App Store Connect, resolve all processing errors and relevant warnings, then select the processed build for TestFlight or App Review. [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds) and [Choose a build](https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit/)

## Product-page metadata and assets

Required launch material includes:

- Localized app name (2-30 characters), subtitle (up to 30 characters), required age rating, primary category plus game subcategories, content-rights declaration, copyright, availability/price, and privacy-policy URL. [App information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
- Required localized description (up to 4,000 characters), keywords (up to 100 bytes), support URL with real contact information, version number, and screenshots. Promotional text is optional and limited to 170 characters; a marketing URL is optional. [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)
- One to ten JPEG/JPG/PNG screenshots. As of this snapshot, accepted landscape screenshots for the required 6.9-inch iPhone class include 2736x1260, 2796x1290, and 2868x1320 pixels. Additional device sets may be required when supporting iPad or when the primary set is absent. Recheck the live table before capture. [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- Up to three optional app-preview videos per localization and device size. Previews must use captured app footage, though narration and explanatory overlays are allowed. [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) and [App Review Guideline 2.3.4](https://developer.apple.com/app-store/review/guidelines/#accurate-metadata)
- The final app icon must be embedded in the Xcode asset catalog/exported app. Changing it after release requires a new app version and review. [Add an app icon](https://developer.apple.com/help/app-store-connect/manage-app-information/add-an-app-icon/)
- Localize the product page only for languages actually supported in-game, and run screenshots/metadata through the same linguistic QA as the build. Apple allows localized screenshots, descriptions, keywords, support URLs, and other version metadata. [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)

## Age rating and accessibility declarations

- The age rating questionnaire is mandatory; an Unrated app cannot be published. Apple now generates 4+, 9+, 13+, 16+, or 18+ ratings, with region-specific variants. The questionnaire covers violence, fear/horror themes, weapons, profanity, substances, gambling/loot boxes, web access, social features, advertising, user-generated content, and other capabilities. Keep answers aligned with actual zombie violence and presentation. [Age rating values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions) and [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/)
- Apple introduced the updated age-rating system for iOS 26-era product pages and required updated questionnaire responses by January 31, 2026. Treat the live questionnaire as authoritative near submission. [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)
- App Store Accessibility Nutrition Labels can declare VoiceOver, Voice Control, Larger Text, Dark Interface, Differentiate Without Color Alone, Sufficient Contrast, Reduced Motion, Captions, and Audio Descriptions. Claim a feature only when users can complete all common tasks with it; labels are product-page metadata and must remain accurate. [Accessibility Nutrition Labels overview](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels) and [Manage Accessibility Nutrition Labels](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/manage-accessibility-nutrition-labels/)
- If claiming Larger Text, Apple's current criterion requires text enlargement to at least 200% or the platform maximum without unusable overlap/truncation across common tasks. [Larger Text evaluation criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/larger-text-evaluation-criteria)

## Privacy, SDKs, analytics, and crash reporting

- Every iOS app needs a public privacy-policy URL in App Store Connect, and App Review Guidelines also require the policy to be easily accessible inside the app. It must describe collection, use, sharing/SDK partners, retention/deletion, consent withdrawal, and user deletion requests as applicable. [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy) and [App Review Guideline 5.1.1](https://developer.apple.com/app-store/review/guidelines/#privacy)
- Complete App Store privacy answers for the final binary, including data collected by every analytics, crash, attribution, or other third-party SDK. If the final app and its partners collect nothing, App Store Connect permits the explicit "No, we do not collect data" response; reassess after every SDK change. [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)
- Include a valid `PrivacyInfo.xcprivacy` describing collected data, tracking domains, and required-reason API use by the app and SDKs. Invalid manifests can cause submission rejection, and listed commonly used third-party SDKs must carry valid manifests/signatures. Generate and inspect Xcode's privacy report for the archived release. [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files) and [Adding a privacy manifest](https://developer.apple.com/documentation/bundleresources/adding-a-privacy-manifest-to-your-app-or-third-party-sdk)
- If any code tracks a person across other companies' apps/sites or accesses the advertising identifier, obtain permission with AppTrackingTransparency and include a clear purpose string. Do not fingerprint devices or gate gameplay on tracking consent. A privacy-minimal game with no advertising/tracking avoids this prompt, but the declaration must match the shipped SDK behavior. [User Privacy and Data Use](https://developer.apple.com/app-store/user-privacy-and-data-use/) and [AppTrackingTransparency](https://developer.apple.com/documentation/apptrackingtransparency)
- Crash reporting and product analytics are optional product choices, not automatic exemptions. Before integration, document exact events/fields, retention, upload timing, offline queueing, deletion/opt-out behavior, symbolication, SDK manifest/signature status, and corresponding privacy-label answers. Prefer no advertising identifier and no cross-app tracking.

## Encryption and export compliance

- Any app that uses, accesses, contains, or incorporates encryption—including standard algorithms or operating-system cryptography—must complete App Store Connect's export-compliance determination. Apple places responsibility for an accurate exemption/classification on the developer. [Export compliance overview](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance/)
- Answer the encryption questions for the actual release archive. If documentation is required, upload and clear it before App Review or TestFlight App Review. If documentation is not required or the app qualifies for an exemption, set the corresponding Info.plist declaration so repeated submissions do not remain in Missing Compliance. [Determine and upload encryption documentation](https://developer.apple.com/help/app-store-connect/manage-app-information/determine-and-upload-app-encryption-documentation/) and [Choose a build](https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit/)
- Re-evaluate this decision whenever networking, cloud saves, telemetry/crash reporting, authentication, StoreKit receipt logic, or another SDK changes the binary. Obtain specialist advice if the exemption is unclear.

## TestFlight and playtest gate

- Upload a signed build containing valid application identifiers. TestFlight builds are testable for up to 90 days. Apple currently supports up to 100 internal App Store Connect testers and 10,000 external testers. [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)
- External distribution may require TestFlight App Review; the first build added to an external group is reviewed, and later builds may also require review when changes are significant. Supply a beta description, feedback email, "What to Test," and any review instructions. [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)
- Use App Store Connect sessions/crash metrics and screenshot feedback, but retain an independent test matrix for cold launch, installation/update, offline play, controller and touch, interruption/background/resume, memory warnings, thermal soak, low battery, low storage, save migration/corruption recovery, localization, accessibility, and supported device/aspect classes.

## App Review and launch

- Before submission, attach the processed build and all required metadata, then add it to a draft submission and submit for review. Provide a reachable review contact and specific Notes for Review explaining controls, offline behavior, save reset/debug access, permissions, any hard-to-find content, and the quickest path through the core loop. If login is ever added, provide a non-expiring demo account or an Apple-approved full-feature demo mode. [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) and [Submit an app](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app)
- Finalize every URL, image, string, purchase, entitlement, and server dependency before review. The app must not be a beta, crash, expose debug/placeholder content, or require unavailable services. [App Review Guidelines 2.1](https://developer.apple.com/app-store/review/guidelines/#performance)
- Choose manual, automatic, or no-earlier-than release. For later updates, Apple also supports a seven-day phased release. Keep a known-good archive, symbols, store metadata snapshot, save-migration fixtures, and emergency-patch path. [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)
- Declare EU Digital Services Act trader status even if not distributing in the EU; if distributing there as a trader, Apple verifies and publishes required contact information. [DSA trader requirements](https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements/)
- Enable Game Center only if the game ships Game Center features; in that case the entitlement must be present and the features configured in App Store Connect before submission. [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/)

## Keep Driving repository gap on 2026-07-11

The repository currently has `project.godot` with a Godot 4.7 Compatibility-renderer desktop configuration, but no `export_presets.cfg`, app version, icon/launch assets, iOS minimum/device-family decision, Team ID/bundle ID, signing setup, privacy manifest, permission strings, localization resources, App Store metadata/assets, or TestFlight/release automation. Its mobile proof is a desktop 896x414 simulation and explicitly defers real exports and device tests. Therefore the project is **not yet iOS-build-ready or App-Store-submission-ready**.

Recommended first release-infrastructure spike after the desktop vertical slice is stable:

1. Install/verify Xcode 26+, iOS 26 SDK, Godot 4.7 export templates, signing, and `xcode-select`.
2. Add a reproducible iOS export preset with placeholder-free identity/versioning and a chosen deployment target/device family.
3. Export the smallest current desktop-proven slice, inspect the Xcode target/privacy manifest, archive, validate, and install on at least one physical iPhone.
4. Prove touch, safe areas, lifecycle resume, local-save durability, audio/haptics, frame pacing, memory, and thermal behavior before migrating more systems.
5. Upload an internal TestFlight build, then record every remaining App Store Connect and compliance field as an owned release checklist item.

## Volatile gates to recheck

Recheck the linked first-party pages at the **first iOS export spike**, **first external TestFlight build**, and **release-candidate submission**. At minimum revalidate:

- Xcode and SDK upload floor.
- Godot 4.7 compatibility with the required Xcode/iOS SDK and any exporter fixes.
- Minimum deployment target and supported device families.
- Screenshot/device-size table and icon rules.
- Age-rating questionnaire and regional ratings.
- Accessibility-label evaluation criteria.
- Required-reason APIs, privacy-manifest schema, and required SDK manifest/signature list.
- Privacy answers for the exact archived SDK set.
- Export-compliance determination for the exact archived binary.
- App Review Guidelines, agreements, DSA/trader status, tax/banking, pricing, and territory-specific permits.
