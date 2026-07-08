# Decide Resources Upgrades And Run Progression

Type: grilling
Status: resolved
Assignee: Codex
Blocked by: 01

## Question

What resources, upgrades, rewards, and run-end progression should Playable v0 include?

The answer should decide whether v0 uses fuel, scrap, repairs, weapons, engine/tires/armor upgrades, between-run persistence, and what progression proof is required.

## Grilling log

- v0 should include tiny between-run car progression: Scrap earned during runs is spent between runs on three simple Permanent Upgrades: Fuel Tank, Armor, and Engine. Runs otherwise reset; no crafting tree, parts inventory, or shop complexity.
- Fuel is a hard but forgiving run-ending resource. It drains continuously, pickups refill it, and hitting zero ends the run after a short sputter grace period. Terrain or boosting can affect fuel drain later, but v0 only needs the core pressure loop.
- v0 should include rare Repair Pickups during a run. No repair crafting or repair-at-stop UI; Vehicle Damage stays scary, but the player can recover from one bad crash by risking a detour for a repair pickup.
- v0 should keep Car-Only Combat strict. Upgrades improve driving survival only: Fuel Tank, Armor, and Engine. No guns, spikes, flamethrowers, turrets, weapon upgrades, or weapon shop.
- Scrap is earned from two sources only: Scrap pickups in the world and a run-end Scrap bonus from Miles Driven. Zombie kills should not directly award Scrap in v0, because that would encourage farming instead of driving outward.
- Permanent Upgrades should be bought through one simple Garage screen. After a run, the results screen links to Upgrade Car; from the start screen, Garage is available before launching the next fresh Run Seed.
- Upgrade tuning should use fixed tiny tiers, not a formula system. Each Permanent Upgrade has three levels with visible costs and obvious effects: Fuel Tank increases max fuel, Armor increases max Vehicle Damage, and Engine raises road/top speed slightly.
- v0 should not include consumables, temporary powerups, nitro, shields, temporary damage boosts, or inventory. Fuel pickups and Repair Pickups apply immediately.
- The build run must prove fuel drains and can end a run, fuel pickups refill it, Repair Pickups restore Vehicle Damage, Scrap pickups and Miles Driven award Scrap, Garage purchases persist, each of the three Permanent Upgrades has a visible gameplay effect, and restart uses a fresh Run Seed while preserving Scrap and upgrades.

## Answer

Playable v0 should include a small survival-progression model built around Fuel, Vehicle Damage, Scrap, and three Permanent Upgrades.

Fuel is a hard but forgiving run-ending resource. It drains continuously, fuel pickups refill it immediately, and hitting zero ends the run after a short sputter grace period. v0 does not need advanced drain tuning beyond the core pressure loop.

Vehicle Damage remains the combat failure track, with rare Repair Pickups as the only in-run recovery. Repair Pickups apply immediately. There is no repair crafting, repair-at-stop UI, repair economy, consumable inventory, or temporary powerup system.

Scrap is the persistent between-run currency. The player earns Scrap from Scrap pickups in the world and a run-end Scrap bonus based on Miles Driven. Zombie kills should not directly award Scrap in v0, because the progression loop should reward route choice and driving outward rather than combat farming.

Between-run progression happens in one simple Garage screen. After a run, the results screen links to Upgrade Car; from the start screen, Garage is available before launching the next fresh Run Seed. Runs otherwise reset, but Scrap and Permanent Upgrades persist.

Playable v0 should keep Car-Only Combat strict. The only Permanent Upgrades are Fuel Tank, Armor, and Engine. Each has three fixed visible-cost levels with obvious effects: Fuel Tank increases max fuel, Armor increases max Vehicle Damage, and Engine raises road/top speed slightly. No weapons, weapon upgrades, spikes, flamethrowers, turrets, crafting tree, parts inventory, shop complexity, nitro, shields, or temporary damage boosts belong in v0.

Proof requirements for the build run:

- Fuel drains and can end a run after the sputter grace period.
- Fuel pickups refill fuel immediately.
- Repair Pickups restore Vehicle Damage immediately.
- Scrap pickups and Miles Driven award Scrap.
- Garage purchases persist across runs.
- Fuel Tank, Armor, and Engine each have a visible gameplay effect.
- Restart uses a fresh Run Seed while preserving Scrap and Permanent Upgrades.
