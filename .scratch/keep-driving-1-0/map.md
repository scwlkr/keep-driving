# Keep Driving 1.0 Wayfinder Map

## Destination

Reach and execute an agent-ready route from the current Godot prototype to a polished, production-ready **Keep Driving 1.0.0** (working title) for the Apple App Store, with every gameplay system proven in a playable desktop build before mobile adaptation.

The map is complete only after the required decisions and roadmap gates are durable, sequential execution has produced a validated release candidate, the exact 1.0.0 build has launched publicly, and immediate post-launch stabilization has closed all P0/P1 issues.

## Notes

- The attached 1.0 mission is the governing contract. Do not ask the user questions; record explicit assumptions, risks, and validation gates instead.
- `Keep Driving` is internal only. Public execution assumes a distinctive cleared replacement unless written legal and positioning review affirmatively clears the exact title; do not lock production release identity or brand assets before that gate.
- Preserve the current playable Godot 4.7 proof baseline where it remains sound, but treat the prototype as a starting point rather than a design or architecture boundary.
- The completed v0 map and open Real Vertical Slice map are evidence and subordinate milestones, not the canonical 1.0 route.
- Work desktop-first. A system cannot cross the mobile gate until its playable desktop acceptance criteria, edge cases, profiling, and documentation pass.
- Prefer the smallest coherent architecture that supports a handcrafted-plus-procedural world, data-driven content, versioned saves, abstracted input, responsive UI, and repeatable release builds.
- Keep scope in three explicit buckets: Required for 1.0.0, Valuable if Capacity Allows, and Post-1.0 Expansion.
- Stop and report at real phase boundaries; keep the project playable and commit bounded verified slices frequently.
- The required documentation package exists, but Roadmap Phase-1 decision acceptance remains in review until tickets 02-07 resolve one per session. Corrections block production scale-up/ticket 08 without invalidating bounded Phase-2 decision prototypes.
- The isolated `prototypes/handling_truth_slice/` work is mechanical evidence against the resolved ticket-04 contract and remains evidence for technical-risk decisions; it does not satisfy a staged production-presentation gate or resolve ticket 08. Automated smoke and short clean-export rendered harness runs pass; representative final-pipeline presentation, full-duration/cadence/capture, audible mix, physical controller, and human evidence remain open.
- After that desktop handling/hero slice is accepted, Phase 2 includes one signed export-only feasibility check. It requires the clearance-or-rename/release-identity gate first and proves only Godot/Xcode/signing/physical launch; formal mobile adaptation remains after the content-complete stabilized desktop gate.

## Decisions so far

- [Audit Current Project And 1.0 Gap](issues/01-audit-current-project-and-1-0-gap.md) — Keep the deterministic/streaming/progression/proof nucleus, but treat the build as playable v0/pre-alpha and replace or deeply refactor the production vehicle, world, content, presentation, save, platform, and release layers.
- [Decide Product Identity And Launch Scope](issues/02-decide-product-identity-and-launch-scope.md) — Lead with route-shaped buildcraft and county restoration in a paid offline single-player game; assume a distinct public name, keep raw content counts and duration ranges provisional until measured throughput, and never trade quality/reliability for filler.
- [Design Gameplay Content And Progression Systems](issues/03-design-gameplay-content-and-progression-systems.md) — Keep a stable authored county under persisted expedition manifests; build unique named sidegrades through visible capacity; drive objective restoration/extraction through three reusable activity state machines, action-driven Pressure, and completed-county replay.
- [Decide UX Art Audio And Game Feel Direction](issues/04-decide-ux-art-audio-and-game-feel-direction.md) — Use an Animated Road Atlas world with bounded Field Manual components and semantic kinetic feedback; prove presentation through staged Drive, integrated-loop, and complete-shell gates before each asset family multiplies.
- [Decide Target Technical And Mobile Architecture](issues/05-decide-target-technical-and-mobile-architecture.md) — Reduce `GameRoot` to a thin `ApplicationShell` over deep Campaign, Expedition, Drive Runtime, Content, and Save Modules; use typed transitions, one authority per fact, one load scheduler, independent PROFILE/SETTINGS verified-slot journals, and narrow proven desktop/iOS Adapters.

## Not yet specified

- Prototype evidence may expose narrower migration, tuning, asset-throughput, or scope decisions that cannot be phrased responsibly until the desktop truth slice runs.
- Beta and physical-device evidence may expose support-floor or capacity tradeoffs that cannot be finalized from the current prototype.

## Out of scope

- Multiplayer for 1.0.0; it would multiply architecture, QA, moderation, and App Review risk without strengthening the core solo fantasy.
- Manipulative retention systems, consumable energy, pay-to-win upgrades, loot boxes, forced ads, or deceptive interfaces.
- Shipping unproven gameplay directly to mobile before desktop gates pass.
- Building a live-service backend for 1.0; reconsideration requires a newly charted effort after this destination is redrawn or completed.
