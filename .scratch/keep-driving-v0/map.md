# Keep Driving v0 Wayfinder Map

## Destination

Reach an agent-ready plan for a One-Shot Build Run that creates a real, impressive Playable v0 of **Keep Driving**: a landscape mobile, top-down, Free-Roaming World survival driving game built in Godot 4.7.

The map is complete when nothing important remains undecided before launching a manager prompt that can coordinate parallel sessions/agents to build and verify the full v0.

## Notes

- Engine is Godot 4.7. See `docs/adr/0001-use-godot-4-7.md`.
- Do not shrink the game into a lane runner or corridor runner. It must be a full 360-degree Free-Roaming World.
- Terrain includes roads, paths, grass, dirt, and offroad. Roads and paths provide a Road Advantage, but the player can travel anywhere.
- v0 must feel real and fun, not like a disposable toy demo.
- Use `/grilling` and `/domain-modeling` for HITL decisions.
- Use `/prototype` for cheap Godot artifacts that make feel/behavior decisions concrete.
- Prefer AFK research/prototype tickets where Codex can proceed without asking scwlkr.
- The final output should be a compact One-Shot Build Run prompt plus a build issue plan suitable for parallel agents.

## Decisions so far

## Not yet specified

- Exact visual style, asset sourcing, and audio direction after the core feel target is decided.
- Mobile export proof depth after desktop-local v0 proof is defined.
- Performance budgets for infinite world chunks after the generation architecture is chosen.
- Full balance tuning after the loop, combat, resources, and upgrades are decided.
- Whether the first build run should also initialize a GitHub repo/issues or stay local until v0 exists.

## Out of scope

- Multiplayer for v0.
- App Store / Play Store release polish for v0.
- Towns, NPC economy, questlines, or authored story for v0.
- Monetization for v0.
