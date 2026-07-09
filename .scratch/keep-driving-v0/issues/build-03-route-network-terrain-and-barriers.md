# Build 03 Route Network Terrain And Barriers

Type: build
Owner: unclaimed
Status: todo
Blocked by: build-02

## Scope

- Implement macro Route Network generation with roads, dirt paths, offroad traces, bridges/shallows, grass, rough offroad, water, and Traversal Barriers.
- Roads and paths must give Road Advantage without acting as rails, corridors, or lanes.
- Keep route and water/barrier continuity across World Chunk borders.

## Acceptance

- Adjacent route exits match at chunk borders.
- Terrain has no border gaps.
- Water and barriers continue or terminate intentionally.
- Player can drive anywhere and reroute around barriers.

## Proof

- Automated checks in `res://tests/run_all.gd`.
- Manual smoke notes for rerouting and free-roaming movement.

## Agent Report

- Changed files:
- Proof commands:
- Proof outputs:
- Known gaps:
- Commit hash:
