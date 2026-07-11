# Keep Driving 1.0 Wayfinder Map

## Destination

Reach and execute an agent-ready route from the current Godot prototype to a polished, production-ready **Keep Driving 1.0.0** (working title) for the Apple App Store, with every gameplay system proven in a playable desktop build before mobile adaptation.

The map is complete only after the required decisions and roadmap gates are durable, sequential execution has produced a validated release candidate, the exact 1.0.0 build has launched publicly, and immediate post-launch stabilization has closed all P0/P1 issues.

## Notes

- The attached 1.0 mission is the governing contract. Do not ask the user questions; record explicit assumptions, risks, and validation gates instead.
- `Keep Driving` is a working title pending formal name/trademark/competitive clearance; do not lock the public brand, bundle ID, store record, or marketing assets before that gate.
- Preserve the current playable Godot 4.7 proof baseline where it remains sound, but treat the prototype as a starting point rather than a design or architecture boundary.
- The completed v0 map and open Real Vertical Slice map are evidence and subordinate milestones, not the canonical 1.0 route.
- Work desktop-first. A system cannot cross the mobile gate until its playable desktop acceptance criteria, edge cases, profiling, and documentation pass.
- Prefer the smallest coherent architecture that supports a handcrafted-plus-procedural world, data-driven content, versioned saves, abstracted input, responsive UI, and repeatable release builds.
- Keep scope in three explicit buckets: Required for 1.0.0, Valuable if Capacity Allows, and Post-1.0 Expansion.
- Stop and report at real phase boundaries; keep the project playable and commit bounded verified slices frequently.
- The required documentation completes Roadmap Phase 1. Tickets 02-07 remain open only as Wayfinder's one-ticket-per-session audit/index queue; they can correct/reopen decisions and still block production scale-up/ticket 08, but they do not roll the roadmap back or forbid bounded Phase-2 decision prototypes.
- The isolated `prototypes/handling_truth_slice/` work is evidence for the open UX/game-feel and technical-risk decisions; it does not resolve ticket 04 or ticket 08. Automated smoke passes, but rendered performance/capture, audible mix, physical controller, collision-weight, frame-rate replay, and five-player evidence remain open.
- After that desktop handling/hero slice is accepted, Phase 2 includes one signed export-only feasibility check. It requires the clearance-or-rename/release-identity gate first and proves only Godot/Xcode/signing/physical launch; formal mobile adaptation remains after the content-complete stabilized desktop gate.

## Decisions so far

- [Audit Current Project And 1.0 Gap](issues/01-audit-current-project-and-1-0-gap.md) — Keep the deterministic/streaming/progression/proof nucleus, but treat the build as playable v0/pre-alpha and replace or deeply refactor the production vehicle, world, content, presentation, save, platform, and release layers.

## Not yet specified

- Prototype evidence may expose narrower migration, tuning, asset-throughput, or scope decisions that cannot be phrased responsibly until the desktop truth slice runs.
- Beta and physical-device evidence may expose support-floor or capacity tradeoffs that cannot be finalized from the current prototype.

## Out of scope

- Multiplayer for 1.0.0; it would multiply architecture, QA, moderation, and App Review risk without strengthening the core solo fantasy.
- Manipulative retention systems, consumable energy, pay-to-win upgrades, loot boxes, forced ads, or deceptive interfaces.
- Shipping unproven gameplay directly to mobile before desktop gates pass.
- Building a live-service backend unless a later decision proves a launch-critical need.
