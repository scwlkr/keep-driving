# Hybrid Proof Region

Status: authored-macrograph bake contract implemented; scene, streaming, performance, and human route-quality evidence remain pending.

## Question

Can one seed-independent authored county macrograph produce deterministic expedition-specific event/condition overlays without rerolling routes, landmarks, crossings, or stable IDs?

## Current slice

- `hybrid_region_source.json` authors two complete Garage-to-relay routes, one complete shortcut, three landmarks, one crossing, seven event templates, and four event sockets.
- `hybrid_region_bake.gd` validates every stable reference and route chain, canonicalizes authored topology, then emits a disposable expedition overlay bound to the topology hash, overlay ID, and seed.
- `hybrid_region_contract_test.gd` proves repeatability, seed/topology separation, overlay-scoped runtime IDs, source-order independence, 100-seed overlay variation, and rejection without partial output.

Run:

```sh
/opt/homebrew/bin/godot --headless --path . --script res://prototypes/hybrid_region/hybrid_region_contract_test.gd
```

Expected:

```text
HYBRID_REGION_BAKE_CONTRACT seeds=100 pass=true
```

## Evidence boundary

This AFK contract can prove schema, stable IDs, route/reference integrity, deterministic topology, and overlay variation. The overlay is a disposable prototype projection, not the canonical `ExpeditionManifest` defined by the project glossary. It does not prove that routes are readable, memorable, consequential, inhabited, enjoyable, or paced at the provisional 30-45-second decision cadence. It also does not prove the D023 loadout/extraction matrix, serialization/reload, or mutable-progress checkpoint. Those claims still require later automated slices plus a visible keyboard-playable region and valid human sessions. Controller testing remains deferred and unverified; this prototype makes no controller-support claim.
