# Define v0 Balance Defaults

Type: grilling
Status: resolved
Assignee: Codex
Blocked by: 07

## Question

What starting balance constants should Playable v0 use so the One-Shot Build Run can implement a playable baseline without inventing tuning during the build?

The answer should decide initial values or ranges for Fuel capacity/drain/pickups, Vehicle Damage and Repair Pickups, Zombie and Obstacle damage, Scrap pickup/run rewards, Permanent Upgrade costs/effects, Pursuit Pressure pacing, and what balance roughness is acceptable for v0.

## Grilling log

- v0 balance should lock a forgiving 5-minute baseline: Fuel lasts about 5 minutes on-road, Vehicle Damage starts at 100, Sputter Grace Period lasts 3 seconds, pickups should force risky detours, damage should let 2-3 bad crashes end a run, Permanent Upgrades use three tiers, and Pursuit Pressure ramps from calm origin to dangerous after roughly 4 minutes or equivalent distance.
- The build run should implement balance as simple numeric constants rather than formulas: start with values like `MAX_FUEL = 100`, `FUEL_DRAIN_PER_SECOND = 0.33`, `FUEL_PICKUP_AMOUNT = 35`, `MAX_VEHICLE_DAMAGE = 100`, and `REPAIR_PICKUP_AMOUNT = 35`, with Permanent Upgrades applying fixed tier bonuses.
- Fuel should use one global v0 drain rate: `MAX_FUEL = 100`, `FUEL_DRAIN_PER_SECOND = 0.33`, `SPUTTER_GRACE_SECONDS = 3`, and `FUEL_PICKUP_AMOUNT = 35`. Terrain-specific fuel drain is out of scope for v0 because terrain speed and handling already create enough route pressure.
- Damage should make crashes scary, Zombies annoying, and heavy Traversal Barriers brutal: `MAX_VEHICLE_DAMAGE = 100`, `ZOMBIE_CONTACT_DAMAGE = 5/sec`, `LIGHT_OBSTACLE_DAMAGE = 5`, `MEDIUM_OBSTACLE_DAMAGE = 15`, `HEAVY_OBSTACLE_DAMAGE = 40`, `WATER_OR_CLIFF_DAMAGE = 100`, and `REPAIR_PICKUP_AMOUNT = 35`. Bad driving can end a run quickly, but one mistake remains recoverable.
- Pickups should be visible temptations, not route noise. Target each active World Chunk to contain `1` Fuel Pickup, `0-1` Scrap Pickups, and a `15%` Repair Pickup chance, with no pickups in the immediate safe origin radius. Scrap pickups give `5` Scrap; the run-end bonus gives `1` Scrap per `0.25` Miles Driven, rounded down.
- Permanent Upgrades should use cheap early tiers to prove progression quickly. Fuel Tank costs `20/50/100` Scrap and adds `+20/+40/+60` max Fuel. Armor costs `20/50/100` Scrap and adds `+20/+40/+60` max Vehicle Damage. Engine costs `25/60/120` Scrap and adds `+5%/+10%/+15%` road/top speed.
- Pursuit Pressure should use four simple tiers. Tier 0 is the safe origin, Tier 1 is early pressure, Tier 2 is dangerous, and Tier 3 is panic. Advance by distance or time, whichever is higher: `0-0.5` miles or `0-60s`, `0.5-1.5` miles or `60-180s`, `1.5-3` miles or `180-300s`, and `3+` miles or `300s+`. Each tier raises Zombie caps, Roadblock chance, and pickup risk, but never spawns threats directly on the player.
- v0 should accept rough but playable tuning. Pass if a 10-minute smoke run proves Fuel matters, Vehicle Damage matters, at least one Permanent Upgrade is reachable, and Pursuit Pressure escalates clearly. Do not require perfect economy, long-term progression balance, or polished difficulty curves in the One-Shot Build Run.

## Answer

Playable v0 should use rough but playable **Balance Defaults** built from simple numeric constants, not tuning formulas. The build run should be free to tweak values only when the 10-minute smoke run fails the basic survival/progression feel.

Baseline resource defaults:

- `MAX_FUEL = 100`
- `FUEL_DRAIN_PER_SECOND = 0.33`
- `SPUTTER_GRACE_SECONDS = 3`
- `FUEL_PICKUP_AMOUNT = 35`
- `MAX_VEHICLE_DAMAGE = 100`
- `REPAIR_PICKUP_AMOUNT = 35`

Fuel uses one global v0 drain rate. Terrain-specific fuel drain is out of scope for v0 because terrain speed and handling already create enough route pressure.

Damage defaults:

- `ZOMBIE_CONTACT_DAMAGE = 5/sec`
- `LIGHT_OBSTACLE_DAMAGE = 5`
- `MEDIUM_OBSTACLE_DAMAGE = 15`
- `HEAVY_OBSTACLE_DAMAGE = 40`
- `WATER_OR_CLIFF_DAMAGE = 100`

These defaults should make crashes scary, Zombies annoying, and heavy Traversal Barriers brutal. Bad driving can end a run quickly, but one mistake remains recoverable.

Pickup and Scrap defaults:

- Each active World Chunk targets `1` Fuel Pickup.
- Each active World Chunk targets `0-1` Scrap Pickups.
- Each active World Chunk has a `15%` Repair Pickup chance.
- No pickups spawn in the immediate Safe Origin Radius.
- Scrap pickups give `5` Scrap.
- Run-end bonus gives `1` Scrap per `0.25` Miles Driven, rounded down.

Permanent Upgrade defaults use three cheap early tiers so progression can be proven quickly:

- Fuel Tank costs `20/50/100` Scrap and adds `+20/+40/+60` max Fuel.
- Armor costs `20/50/100` Scrap and adds `+20/+40/+60` max Vehicle Damage.
- Engine costs `25/60/120` Scrap and adds `+5%/+10%/+15%` road/top speed.

Pursuit Pressure defaults use four tiers, advancing by distance or time, whichever is higher:

- Tier 0, safe origin: `0-0.5` miles or `0-60s`
- Tier 1, early pressure: `0.5-1.5` miles or `60-180s`
- Tier 2, dangerous: `1.5-3` miles or `180-300s`
- Tier 3, panic: `3+` miles or `300s+`

Each tier raises Zombie caps, Roadblock chance, and pickup risk, but threats should never spawn directly on the player.

Playable v0 passes balance only if a 10-minute smoke run proves Fuel matters, Vehicle Damage matters, at least one Permanent Upgrade is reachable, and Pursuit Pressure escalates clearly. Perfect economy, long-term progression balance, and polished difficulty curves are not required for the One-Shot Build Run.
