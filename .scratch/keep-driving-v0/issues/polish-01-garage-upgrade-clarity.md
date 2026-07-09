# Polish 01 Garage Upgrade Clarity

Type: polish
Owner: Codex
Status: done
Baseline: 655b230

## Problem

The Garage lets the player spend Scrap, but it hides the information needed to make a clean upgrade decision.

Current baseline:

- Garage shows total Scrap and current Fuel Tank, Armor, and Engine levels.
- Buy buttons are generic.
- Next price, next effect, max level, and unaffordable state are not visible.
- Failed purchases give no player-facing reason.

## Focused Target

Make the Garage a clear upgrade decision screen.

The player should immediately know what each Permanent Upgrade does, what the next level costs, whether they can afford it, and when an upgrade is maxed.

## Scope

- Show each upgrade as one readable row or block: name, current level out of 3, next cost, next effect, and state.
- Use the existing locked Balance Defaults:
  - Fuel Tank: `20/50/100` Scrap, `+20/+40/+60` max Fuel.
  - Armor: `20/50/100` Scrap, `+20/+40/+60` max Vehicle Damage.
  - Engine: `25/60/120` Scrap, `+5%/+10%/+15%` speed.
- Make unaffordable and maxed upgrades obvious before pressing.
- Keep buying, persistence, Results, restart, and Start/Garage navigation behavior unchanged.

## Out of Scope

- No economy rebalance.
- No new upgrade types.
- No shop inventory, repair economy, consumables, or crafting.
- No full visual redesign beyond clarity needed for this screen.

## Acceptance

- With `0` Scrap, the Garage shows all next costs/effects and clearly marks each upgrade unaffordable.
- With enough Scrap, at least one upgrade is visibly purchasable before pressing.
- Buying an upgrade updates Scrap, level, next cost/effect, and persistence exactly as before.
- At level `3`, the upgrade reads as maxed and cannot be bought again.
- The screen remains readable at landscape phone simulation size.

## Proof

- Extend Godot-native tests or proof coverage for Garage text/state:
  - next costs and effects are exposed,
  - unaffordable state is exposed,
  - maxed state is exposed,
  - purchase and persistence still pass.
- Run:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`

## Done Bar

Garage clarity is done when a first-time player can choose whether to save or spend Scrap without guessing upgrade prices or effects.

## Agent Report

- Changed files:
  - `scripts/game_root.gd`
  - `tests/run_all.gd`
  - `.scratch/keep-driving-v0/issues/polish-01-garage-upgrade-clarity.md`
- Proof command:
  - `/opt/homebrew/bin/godot --headless --path /Users/shanewalker/Desktop/dev/keep-driving --script res://tests/run_all.gd`
- Proof output:
  - `ALL_KEEP_DRIVING_PROOFS_PASSED`
- Notes:
  - Garage upgrade buttons now show level, next cost, next effect, and Ready/Need/Maxed state.
  - Unaffordable rows explain the missing Scrap while preserving the existing failed-buy behavior.
  - Maxed upgrade buttons are disabled.
