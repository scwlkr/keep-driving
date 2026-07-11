# Keep Driving Product Vision

Status: target vision for 1.0.0
Vision date: 2026-07-11

## Product summary

**Keep Driving** is a premium, offline-first, top-down survival road-trip roguelite. The player takes a battered car from a refuge Garage into a hostile open county, reads the road ahead, chooses safer or faster routes, completes risky expeditions, recovers parts, and decides when to return before Fuel, Vehicle Integrity, weather, or threats turn a good haul into a loss.

The 1.0 world is a connected, freely explorable road atlas built from authored regions, road hierarchy, shortcuts, landmarks, and safehouses. Deterministic systems remix hazards, route closures, weather, pickups, and encounters so the player learns a real place without receiving the same run twice. The car is both movement and weapon; there is no on-foot mode and no unrelated combat layer.

The prototype's endless survival run survives as post-progression **Expedition Mode**. The primary game gains destinations, voluntary extraction, authored progression, recognizable places, build specialization, and a real completion arc.

## Core fantasy

> I turn a wreck into *my* machine, read a dangerous open road, take one more calculated risk, and somehow bring both the car and the haul home.

The fantasy combines freedom, mechanical expression, survival pressure, and mastery of a changing but learnable world. The desired emotional rhythm is:

1. Anticipation while selecting a route and loadout.
2. Flow while the car feels responsive and the road opens up.
3. Tension when Fuel, cargo, damage, weather, or Pursuit Pressure narrows the options.
4. Improvisation when a shortcut, roadblock, or encounter changes the plan.
5. Relief and pride on a successful return.
6. Curiosity about the next route, part, landmark, or build.

## Player role

The player is a route runner based at the last working Garage in a broken county. They reconnect safehouses, restore a usable road network, recover vehicles and parts, and keep essential movement alive. The role is expressed through driving and mechanical choices rather than dialogue-heavy heroics.

## Target player

Primary audience:

- Players who enjoy readable arcade driving, route planning, roguelite decisions, buildcraft, and exploration.
- Players who want 15-25 minute sessions that can chain into a longer evening.
- Players who prefer a premium, offline-capable game without ads, energy, loot boxes, or mandatory accounts.
- Mobile players who expect console-like clarity and feel, plus keyboard/controller players on desktop builds used during development.

The game is not aimed at simulation purists, twitch-only racing players, idle progression players, or players looking for an on-foot open-world RPG.

## Unique selling proposition

> A survival road trip across an illustrated, freely explorable county where the road network is handcrafted, each expedition is systemically remixed, and every installed part changes which routes the car can survive.

Keep Driving should be recognizable within seconds through:

- A bold animated-road-atlas view with inked top-down cars and terrain.
- A battered yellow hero car against charcoal roads, sun-faded land, cyan route/water accents, and crimson threats.
- Roads that are advantages, not rails: the player can leave them anywhere.
- A compact cockpit-like HUD built around Fuel, Integrity, cargo, and route pressure.
- Weighty but accessible Arcade-Real Handling, visible drift, surface response, and satisfying ram impacts.
- The recurring decision: continue toward a better reward, divert through risk, or return with what is already secured.

## Design pillars

### 1. Road choice is the game

Every useful stretch should present information and consequence. Fast pavement attracts threats and closures. Offroad cuts save distance but cost Fuel, grip, cargo stability, or damage. Shortcuts depend on the build. The map is not scenery around combat; navigation is the central verb.

Feature test: if a feature does not create, reveal, or reward a driving/route decision, it needs a strong reason to exist.

### 2. The car is the character

The player expresses intent through chassis and parts. An armored rammer, quiet scout, cargo hauler, offroad explorer, and agile drifter should prefer different roads and solve encounters differently. Upgrades are not a longer stat bar; each part changes capability and carries a cost.

Feature test: a meaningful part must alter how the player drives, routes, risks, or recovers—not merely add an invisible percentage.

### 3. The return makes the risk meaningful

Recovered cargo and uninstalled parts become safe when extracted at a Garage or safehouse. Completion, voluntary return, and failure produce distinct outcomes. The player should frequently know that going farther may be worth it and may also be a mistake.

Feature test: rewards must create a real continue/return decision without erasing all progress on failure.

### 4. Readable at speed

Terrain, hazards, objectives, threats, pickups, damage, and feedback must be understood in peripheral vision on a phone. The game communicates through silhouette, value, motion, sound, haptics, and concise language; color is never the only signal.

Feature test: a new player at the target mobile viewport can identify the next action and danger without reading debug text.

### 5. Crafted places, systemic replay

The player learns authored regions, landmarks, road hierarchy, and shortcuts. Deterministic encounters, weather, closures, contracts, and rewards recombine around those places. Pure random infinity is not a substitute for memorable exploration; one-time authored content is not enough for replayability.

Feature test: repeated travel should strengthen world knowledge while still asking a different tactical question.

## Ethical product principles

- Premium one-time purchase is the 1.0 recommendation. Final regional price is validated near launch.
- No ads, energy timers, loot boxes, pay-to-win parts, consumable real-money currency, streak punishment, or forced account.
- No gameplay-critical daily obligation. A seeded challenge may be added only if it remains playable offline and does not punish absence.
- Clear costs, effects, tradeoffs, failure consequences, and save behavior.
- Respect pause, interruption, accessibility, and short-session exits.
- No telemetry or third-party SDK without a documented player benefit, disclosure, privacy review, and opt choice where appropriate.

## Target 1.0 experience

### Launch content target

- One seamless county with **three connected regions**, each with a distinct route, terrain, threat, weather, and visual identity.
- At least **15 major landmarks** and **six safehouses/return points**, with authored road loops and discoverable shortcuts.
- At least **24 authored contract objectives** distributed across four activity families, plus **15 or more dynamic encounter templates**.
- **Three vehicle chassis** with visibly different mass, cargo, handling, durability, and slot profiles.
- **Six functional part slots** and at least **36 launch parts**, all catalog-driven and sidegrade-oriented; at least five viable build archetypes.
- One compact currency, Scrap; recovered parts and blueprints are equipment/unlocks rather than extra spendable currencies.
- A primary restoration arc targeting **8-12 hours** for a first completion, with **20+ hours** of world completion, builds, mastery trials, and Expedition Mode.
- Day/night presentation and limited region-aware weather that change visibility, grip, route pressure, and ambience without becoming survival-meter clutter.
- Full start/pause/results/map/Garage/loadout/settings/accessibility/save/error flows.
- Production art, animation, audio, VFX, haptics, readable touch controls, controller support, reliable saves, and a tested iOS release.

Content numbers are production floors, not permission to ship filler. A smaller set that fails density or variety gates is incomplete; a larger set that is repetitive is not inherently better.

### Three-region shape

1. **The Lowlands** — readable roads, farms, flooded crossings, tutorial-safe sightlines, salvage yards, and the first safehouse network.
2. **The Badlands** — rough ground, quarry roads, dust, steep risk/reward shortcuts, heavier obstacles, and long Fuel decisions.
3. **The Blackwood** — narrow forest roads, rain/night pressure, hidden service tracks, dense threat pockets, and late-game route mastery.

Names are working names until art/narrative validation. The functional contrast is required.

## Core gameplay loops

### First 30 seconds

- Resume or start at the Garage without an account wall.
- A selected control layout is visible through concise, dismissible prompts.
- The immediate destination and return condition are clear.
- The player begins moving within ten seconds.
- A route fork, landmark silhouette, or tempting salvage signal is visible before the first minute.

### First five minutes

- Learn acceleration, steering, braking/reverse, and handbrake through use.
- Read road versus offroad value.
- Encounter one low-risk obstacle/threat and one optional reward.
- Reach the first destination or safehouse.
- Understand Fuel, Integrity, carried haul, and the option to continue or return.

### Typical 15-minute session

1. Choose a contract and loadout in under two minutes.
2. Drive through at least two meaningful route decisions.
3. Resolve one dynamic encounter or optional detour.
4. Complete, extract, or fail with a clear consequence.
5. Install, compare, sell, or save toward one part decision.

### Typical one-hour session

- Complete two or three expeditions.
- Discover a landmark, shortcut, blueprint, chassis clue, or safehouse improvement.
- Change or refine a build.
- Make visible progress toward a region restoration milestone.
- Finish at a clean autosave boundary.

### First day

- Complete onboarding and the Lowlands introduction.
- Install the first choice-bearing part during the first play session.
- Unlock the first safehouse and second activity family.
- Understand why a scout and rammer choose different routes.

### First week

- Open all three regions or approach the final region milestone.
- Own at least two chassis and maintain multiple saved loadouts.
- Complete the primary restoration arc or see its endpoint clearly.
- Begin mastery trials, region completion, and Expedition Mode.

### Long-term and endgame

- World completion: landmarks, shortcuts, safehouses, blueprints, and mastery goals.
- Build mastery: improve times, damage efficiency, cargo recovery, and difficult route completion with different archetypes.
- Seeded Expedition Mode: the prototype's outward survival fantasy with production systems and fair deterministic seeds.
- Optional rotating challenge seeds only if offline fallback, no-loss participation, and privacy principles remain intact.
- Post-launch expansions may add regions, chassis, parts, encounter modules, and story arcs without invalidating launch saves or builds.

## Player journey

1. **First launch** — language, display, audio, control preset, and high-value accessibility choices; then immediate Garage arrival.
2. **Garage lot tutorial** — move, brake, reverse, drift, and hit a harmless breakable prop in a playable space.
3. **First expedition** — visible Lowlands safehouse objective; one fork and one optional salvage detour.
4. **First return** — carried salvage is secured; player compares two mutually useful part choices.
5. **First meaningful destination** — restoring a safehouse changes navigation, return safety, and available contracts.
6. **First discovery** — a landmark or shortcut is marked through exploration, not an exhaustive icon dump.
7. **First specialization** — enough parts exist to commit toward scout, rammer, drifter, offroad, or hauler behavior.
8. **Midgame** — region transitions introduce new terrain and route constraints; a second chassis broadens builds.
9. **Late game** — Blackwood pressure demands route knowledge, prepared loadouts, and selective risk.
10. **Primary completion** — the county route network is restored and a final expedition demonstrates all core skills.
11. **Ongoing play** — unfinished discoveries, mastery trials, alternate chassis/builds, and Expedition Mode remain valuable without resetting the profile.

## Scope categories

### Required for 1.0.0

- The complete launch content and experience floors above.
- Desktop-proven handling, hybrid world, activities, progression, content, UI, art, audio, save, settings, accessibility, and reliability.
- Responsive mobile layouts and input built only after the corresponding desktop systems pass.
- Supported-device performance, lifecycle, interruption, offline, save, and TestFlight proof.
- App Store metadata, privacy, legal, accessibility, review, release, rollback, and support readiness.
- Premium one-time purchase with no launch IAP or advertising SDK.

### Valuable if capacity allows

- Fourth chassis and 8-12 additional parts.
- Photo mode and shareable run card.
- Apple Game Center achievements and optional cloud-save synchronization.
- Alternate touch scheme such as tilt steering.
- Additional launch localization beyond the required localization-ready English build.
- More mastery trials, encounter variants, and cosmetic sets after content floors and quality gates pass.

### Post-1.0 expansion

- New county region, route restoration arc, safehouses, and landmark set.
- Additional chassis families and part mechanics.
- Authored narrative expansion.
- Larger procedural Expedition rule sets.
- Asynchronous ghosts/leaderboards after privacy, cheating, and service-cost review.
- Multiplayer or co-op only as a separately funded architecture effort.
- Mod support only if platform and content-pipeline constraints justify it.

## Explicit non-goals

- No lane runner, corridor runner, or forced road-following.
- No realistic driving simulator, licensed cars, deep mechanical repair simulation, or manual transmission requirement.
- No on-foot mode, shooter controls, weapon inventory, base building, crafting-resource soup, or dialogue-heavy RPG.
- No pure infinite procedural world as the primary campaign.
- No MMO, real-time multiplayer, mandatory backend, account, or always-online dependency.
- No launch ads, loot boxes, energy, battle pass, subscriptions, or pay-to-win purchases.
- No feature is accepted because code exists; it must be integrated, playable, evidenced, documented, and inside performance/reliability budgets.

## Product success measures

- At least four of five new players drive within ten seconds and identify the immediate goal plus Fuel/Integrity within 30 seconds.
- Median handling satisfaction is at least 4/5 in structured desktop tests.
- At least three benchmarked builds remain viable across road, offroad, impact, cargo, and endurance tests; no one build wins every axis.
- Repeated 15-minute sessions contain a meaningful route, encounter, or build decision at least every 30-45 seconds while driving.
- Primary progression has no required grind wall longer than two normal sessions without a new capability, location, or meaningful part choice.
- Release beta reaches at least 99.8% crash-free sessions, zero open P0/P1 defects, and complete save-recovery gates.
- Supported iOS devices meet the declared frame, memory, thermal, battery, launch, resume, and input budgets.
