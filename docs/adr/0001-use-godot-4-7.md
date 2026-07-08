# ADR 0001: Use Godot 4.7

## Status

Accepted

## Context

The goal is a One-Shot Build Run for a landscape mobile top-down endless driving survival game. The engine must support fast 2D iteration, local automated proof, and an eventual iOS/Android export path.

## Decision

Use Godot 4.7 as the game engine.

## Consequences

- The first implementation should be a native Godot project, not a web prototype.
- Verification can start with headless Godot checks and local desktop play proof.
- Mobile export work can be handled as follow-up proof once the playable v0 exists.
