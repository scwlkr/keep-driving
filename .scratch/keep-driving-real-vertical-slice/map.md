# Keep Driving Real Vertical Slice Wayfinder Map

Status: historical subordinate milestone. The canonical 1.0 route is [`.scratch/keep-driving-1-0/map.md`](../keep-driving-1-0/map.md); its accepted decisions supersede this map's preservation and out-of-scope constraints wherever they conflict. Do not route new 1.0 work from this tracker.

## Destination

Reach an agent-ready plan for a Real Vertical Slice of **Keep Driving**: the current playable Godot build should look, sound, and present like a real game in the first 60 seconds and remain coherent through the full run/results/garage/restart loop.

The map is complete when nothing important remains undecided before launching a manager prompt that can coordinate the polish/build work and verify a shareable local desktop slice.

## Notes

- Baseline is the already-playable Godot 4.7 build from `.scratch/keep-driving-v0/`.
- Historical slice assumption: preserve the existing Free-Roaming World, Arcade-Real Handling, car-only combat, run progression, Garage, and proof harness unless an audit proves a hard blocker. The canonical 1.0 audit has since authorized replacement/refactor where required.
- Focus on first impression, presentation, readability, pacing, feedback, and a shareable local build.
- Use `/grilling` and `/domain-modeling` for HITL product decisions.
- Use `/prototype` for cheap Godot artifacts that make UI, world dressing, pacing, or feedback decisions concrete.
- Prefer AFK audit/research tickets where Codex can proceed without scwlkr.
- The final output should be a compact Real Vertical Slice build-run prompt plus implementation issue plan suitable for parallel agents.

## Decisions so far

## Not yet specified

- The actual implementation tickets for UI, world dressing, feedback, pacing, and build packaging depend on the baseline audit and prototype decisions.
- Whether this milestone should move from local markdown tracking to GitHub issues depends on the shareable-build decision.
- Exact asset production method is not specified yet: procedural polish, committed custom sprites/audio, generated assets, or a small bundled-safe asset set.

## Historical out of scope

These exclusions bounded this older slice only; they do not override the canonical 1.0 map.

- App Store / Play Store release.
- Physical iOS/Android device proof or TestFlight/Play Store tracks.
- Multiplayer.
- Monetization.
- Towns, NPC economy, quests, authored story, or large narrative systems.
- Replacing the core world generation, vehicle handling, or run progression architecture unless a ticket proves the current foundation blocks the destination.
