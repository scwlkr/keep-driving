# Hybrid Proof Region

Status: authored-macrograph bake contract and disposable static desktop projection implemented; bounded streaming, route completion, event/crossing behavior, sustained rendered performance, and human route-quality evidence remain pending.

## Question

Can one seed-independent authored county macrograph produce deterministic expedition-specific event/condition overlays without rerolling routes, landmarks, crossings, or stable IDs?

## Current slice

- `hybrid_region_source.json` authors two complete Garage-to-relay routes, one complete shortcut, three landmarks, one crossing, seven event templates, and four event sockets.
- `hybrid_region_bake.gd` validates every stable reference and route chain, canonicalizes authored topology, then emits a disposable expedition overlay bound to the topology hash, overlay ID, and seed.
- `hybrid_region_contract_test.gd` proves repeatability, seed/topology separation, overlay-scoped runtime IDs, source-order independence, 100-seed overlay variation, and rejection without partial output.
- `hybrid_region_world.gd` projects only a validated bake report into seven visible surface edges, six nodes, three landmark markers, one midpoint crossing marker, and the active overlay event markers.
- `hybrid_region_scene.tscn` reuses the tracked fixed-step handling vehicle and camera behind `configure_from_bake()`, `step_with_intent()`, `surface_at()`, `reset_to_start()`, and `playable_contract()`; the existing handling/world roots remain unchanged.
- `hybrid_region_scene_contract_test.gd` proves exact hash/Stable-ID projection, resolved active-event bindings, road/dirt/mud/rough sampling, literal W/S/A/D/Space/E input, real `InputMap` gas plus scene-local Space events, exact reset, deterministic reconfiguration, single stepping, and rejection of hash mismatches or unresolved projected references before assembly.
- `hybrid_region_scene_smoke.gd` runs 3,600 public scene steps against the provisional 4 ms world-work budget and rejects node growth. It is a headless CPU floor, not sustained rendered-performance evidence.

Run:

```sh
/opt/homebrew/bin/godot --headless --path . --script res://prototypes/hybrid_region/hybrid_region_contract_test.gd
/opt/homebrew/bin/godot --headless --path . --script res://prototypes/hybrid_region/hybrid_region_scene_contract_test.gd
/opt/homebrew/bin/godot --headless --path . --script res://prototypes/hybrid_region/hybrid_region_scene_smoke.gd
```

Expected:

```text
HYBRID_REGION_BAKE_CONTRACT seeds=100 pass=true
HYBRID_REGION_SCENE_CONTRACT pass=true
HYBRID_REGION_SCENE_SMOKE steps=3600 ... node_growth=0 ... pass=true
```

Launch the disposable desktop scene:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path . res://prototypes/hybrid_region/hybrid_region_scene.tscn
```

Keyboard: W/S drive, A/D steer, Space handbrake, E recover, R reset, Escape quit. Controller testing remains deferred.

## Evidence boundary

The bake contract proves its schema, Stable IDs, route/reference integrity, and deterministic topology/overlay variation. The scene contract proves exact-hash static projection, local graph/socket reference rejection, literal keyboard input, fixed-step vehicle motion, and a bounded headless CPU floor; it is not a second full bake validator. The overlay is a disposable prototype projection, not the canonical `ExpeditionManifest` defined by the project glossary. Crossing and edge-target markers use an explicit midpoint convention and active events are markers only; neither proves gameplay behavior. The static scene does not prove complete route traversal, 10-15-minute duration, 30-45-second decision cadence, route readability/memory/meaning/enjoyment, inhabited feel, bounded streaming, blank-terrain prevention, Streaming Drag, or sustained rendered performance. It also does not prove the D023 loadout/extraction matrix, serialization/reload, or mutable-progress checkpoint. Controller testing remains deferred and unverified; this prototype makes no controller-support claim.
