# Keep Driving Game Design

Status: 1.0 system design baseline
Design date: 2026-07-11

## Design summary

Keep Driving 1.0 is a destination-based survival-driving roguelite inside one seamless, learnable county. The player departs from a Garage or restored safehouse, crosses an open road network, completes an objective or explores, recovers unsecured cargo, and chooses whether to press onward or extract. Driving, navigation, vehicle builds, and risk management are the game. Combat remains car-only.

The game combines authored place with deterministic variation:

- Authored macro roads, regions, landmarks, shortcuts, crossings, and safehouses make the world memorable.
- Seeded weather, route incidents, threats, salvage, contracts, and encounter composition make repeated travel tactically different.
- Expedition Mode reuses the production systems for endless outward survival after the main restoration arc.

## Moment-to-moment model

At speed, the player repeatedly performs a compact decision loop:

1. **Read** — road surface, fork, objective cue, threat, weather, cargo state, and available escape line.
2. **Choose** — fast road, safer detour, offroad shortcut, optional reward, confrontation, or return.
3. **Commit** — accelerate, brake, drift, ram, recover, or reroute using the current build.
4. **Feel** — surface, weight, collision, damage, sound, haptics, and clear outcome feedback.
5. **Reassess** — updated Fuel, Integrity, cargo, pressure, route, and time.

Content-density target: while driving, a route, encounter, reward, navigation, or build-relevant decision should occur every 30-45 seconds. A major landmark, objective beat, or safe decision boundary should occur every two to three minutes. Empty travel longer than 60 seconds is a content or pacing defect unless deliberately used as brief contrast.

## Expedition structure

### Departure

- Select an available objective or free-roam intention.
- Select chassis and saved loadout; show route forecast, expected surfaces, cargo need, and major risks without revealing every event.
- Choose a destination/pin and depart in under two minutes.

### Outbound drive

- Navigate authored road hierarchy and optional offroad connections.
- Resolve dynamic route conditions and optional discoveries.
- Gather loose Scrap, intact parts, blueprints, or contract cargo.
- Monitor Fuel, Vehicle Integrity, cargo capacity, and region pressure.

### Objective and push/return decision

- Completing an objective may reveal a second destination, bonus route, rare signal, or safer return.
- The player may bank at a restored safehouse, return to the Garage, chain another objective, or keep exploring.
- The UI communicates exactly what is secured and what remains at risk.

### Resolution

- **Successful extraction:** bank all carried Scrap/cargo, complete eligible contract payout, update discoveries/milestones, and present concise run highlights.
- **Voluntary safehouse stop:** bank the haul and end or continue from a clean autosave boundary.
- **Vehicle failure:** installed parts and owned chassis are never lost; knowledge, discovered landmarks, blueprints, and completed restoration milestones persist; retain 25% of loose Scrap and one explicitly secured cargo item, while other unsecured haul is lost. Exact recovery percentage is validated in the economy prototype before content lock.
- **Abort from pause:** return to the last committed safe boundary; never duplicate rewards or corrupt saves.

Failure must sting without deleting hours. It must not be optimal to intentionally fail instead of returning.

## World design

### Recommendation: hybrid authored and procedural

Use an authored macrograph with deterministic runtime population.

**Authored:**

- Region borders and silhouettes.
- Primary, secondary, service, and offroad route graph.
- Road curves, junctions, bridges, fords, tunnels/underpasses if used, and major traversal barriers.
- Landmarks, safehouses, contract spaces, sightline compositions, tutorial spaces, and curated shortcuts.
- Spawn zones, event sockets, weather zones, audio zones, and streaming metadata.

**Deterministic/systemic:**

- Which eligible event sockets activate for an expedition seed.
- Road closures, salvage clusters, threat composition, patrol/swarm pressure, weather transitions, ambient props, and optional resource placement.
- Contract variants, bonus conditions, and post-progression Expedition layouts/rules.

This replaces pure procedural infinity in the campaign because exploration needs recognizable place, deliberate sightlines, and route memory. It retains deterministic generation because repeated travel needs variation, reproducibility, testability, and compact saves.

### World scale and content floor

- Three connected regions: Lowlands, Badlands, Blackwood working identities.
- At least 15 major landmarks, six safehouses/return points, and 24 authored contract objectives.
- At least two credible routes between adjacent major destinations; at least one build-conditional shortcut in each region.
- Road density should support 10-15 minute direct crossings and 15-25 minute objective expeditions without making the map feel like a city grid.
- The full primary road graph must be traversable without a specialized build; specialized routes provide efficiency, safety, rewards, or mastery advantages rather than mandatory progression locks.

### Road hierarchy

| Route | Identity | Advantage | Cost/risk |
|---|---|---|---|
| Primary asphalt | Fast, legible, landmark-connected | Best speed and Fuel efficiency | Visible, threat/closure pressure, limited escape at barriers |
| Secondary road | Curvier and less maintained | Balanced speed, more alternate connections | Mixed surfaces, debris, ambush/event sockets |
| Service/dirt track | Narrow, loose, partially hidden | Safer or shorter alternate access | Lower grip/speed, cargo instability, weather sensitivity |
| Offroad trace | Player-created or subtle path | Escape line and build-specific shortcut | Fuel, damage, navigation, and recovery risk |
| Traversal crossing | Bridge, ford, culvert, quarry pass | Connects otherwise divided routes | Telegraphs high consequence and weather/event variability |

Roads remain advantages, never rails. The car can leave a route wherever terrain allows.

### Regions

#### Lowlands

- Open sightlines, farms, flooded fields, service roads, salvage yards.
- Teaches road hierarchy, optional detours, extraction, and basic threat reading.
- Weather: clear, light rain, localized flood closure.
- Threat: sparse swarms and light/medium roadblocks.

#### Badlands

- Quarry roads, scrub, dust, rough gradients, heavy debris, long Fuel decisions.
- Rewards offroad durability, cargo planning, and momentum control.
- Weather: wind and dust that reduce distant readability without hiding immediate hazards.
- Threat: heavy obstacles, route traps, faster escalation.

#### Blackwood

- Narrow forest roads, wet service tracks, hidden turnoffs, low-light routes.
- Rewards quiet/scout builds, route memory, grip, and prepared lighting.
- Weather/time: rain, fog pockets, night pressure; visual accessibility modes preserve hazard readability.
- Threat: dense pockets, constrained roadblocks, misleading safe-looking routes.

### Landmarks and discoverables

Landmarks are navigation anchors and systemic spaces, not collectible icons. Examples include a collapsed radio tower, flooded truck stop, quarry crane, forest fire lookout, rail crossing, abandoned service station, scrapyard, and storm drain network.

Each major landmark must do at least two things:

- Anchor navigation or silhouette.
- Host an objective or encounter family.
- Reveal a shortcut/safehouse/resource rule.
- Supply environmental story.
- Unlock a blueprint, chassis clue, or mastery challenge.
- Change the world state when restored/cleared.

Discoveries are recorded permanently. The map begins selectively incomplete and reveals roads/landmarks through travel, signals, and safehouse restoration rather than dumping every icon at launch.

### Shortcuts and hidden areas

- Shortcuts are visible as environmental possibilities before they are fully mapped.
- Some require build capabilities such as offroad grip, high clearance, ram strength, quiet running, or cargo capacity.
- Required primary progression never depends on a random event or a single hidden route.
- Hidden spaces reward curiosity with blueprints, cosmetics, lore fragments, or route advantage—not mandatory grind currency.

### Dynamic routes and encounters

An `EncounterDirector` activates authored sockets using region, expedition seed, elapsed pressure, contract, weather, and recent repetition history.

Required event families:

- Light/medium/heavy roadblock compositions with multiple responses.
- Moving or migrating Zombie pressure.
- Disabled vehicle or survivor signal.
- Salvage spill, fuel cache, repair opportunity, or false lure.
- Weather closure or changed crossing.
- Fragile bridge/ford condition.
- Pursuit surge with a telegraphed escape route.

Rules:

- Never spawn a lethal hazard inside the player's immediate reaction distance.
- Avoid the same template twice in one short expedition unless its state meaningfully escalates.
- Maintain at least one navigable response; a blocked primary route must expose a reroute or player-solvable gap.
- Event state must be deterministic for the active expedition and mutation-safe across streaming.

### Time and weather

- Time advances during expeditions and pauses at menus; tutorial starts in clear daylight.
- A normal 15-25 minute expedition can cross a meaningful light transition but should not cycle through a full day unrealistically.
- Night changes sightline, threat, route, light, and audio behavior, not just screen tint.
- Weather affects grip, visibility, surface, route/event eligibility, ambience, and some part value.
- No hunger, temperature, thirst, or extra survival bars.
- Reduced-intensity and high-visibility modes preserve essential information.

### Navigation and fast travel

- HUD shows a minimal direction/distance cue plus next turn or landmark signal; no debug minimap.
- The full map pauses this offline game, supports zoom/pan, objective filtering, discovered roads, region condition, safehouses, and one player pin.
- Restored safehouses enable fast travel after their routes have been physically discovered.
- Fast travel costs no currency, cannot complete contracts, and is disabled while carrying active mission cargo or in danger. It exists to respect completed travel, not bypass exploration.

### Expansion strategy

Regions are stable-ID content packages with authored graph data, baked chunks, event sockets, localization keys, catalog dependencies, and migration rules. A post-launch region can attach at declared boundary nodes without reseeding or invalidating existing world discoveries.

## Vehicle handling

### Driving model

Target **Arcade-Real Handling**: immediate and forgiving inputs with credible mass, momentum, traction, surface response, and recovery. It is not a simulation, twin-stick mover, or drift-only racer.

Production implementation requirements:

- Fixed-step 60 Hz vehicle simulation, verified at render rates 30/60/120 Hz.
- One normalized `DriveIntent` contract for keyboard, gamepad, touch, replay/proof, and accessibility assists.
- Analog throttle, brake/reverse, steering, and handbrake values; digital inputs are shaped through the same contract.
- Rolling drag, engine force curve, braking, reverse, speed-sensitive steering, lateral slip, surface grip, surface drag, and controlled handbrake rotation.
- Robust collision shapes plus swept/high-speed checks; damage on impact transition/energy, not every overlap frame.
- Deterministic-enough tuning for repeatable benchmark scenes even if exact floating-point replays are not guaranteed cross-platform.

### Surface behavior

| Surface | Speed | Grip | Other behavior |
|---|---:|---:|---|
| Asphalt | Highest | High | Predictable braking; road build baseline |
| Dirt | High-medium | Medium | Progressive slide; dust; rain penalty |
| Grass | Medium | Medium-low | Rolling drag; hidden debris risk |
| Rough/rock | Low-medium | Low | Body shake; cargo/integrity risk |
| Mud/shallow | Low | Very low | Momentum trap; part/build check; visible wake |
| Deep water/hard barrier | Blocked | N/A | Physical response and clear reroute cue |

Surface changes apply forces over time rather than instantaneous speed clamps.

### Steering and drift

- Steering authority grows from zero, peaks at controllable speed, then tapers to prevent high-speed twitch.
- No visible rotation while stationary without an explicit accessibility assist.
- Reverse steering behaves consistently and is taught in the Garage lot.
- Handbrake breaks rear grip, raises rotation, and trades speed/control; it is useful for roadblocks and recovery, not mandatory for ordinary turns.
- Chassis and parts modify the same underlying parameters; they do not replace controls with unrelated minigames.

### Collision, damage, and recovery

- Relative speed, mass, angle, obstacle class, armor/ram parts, and surface determine impulse and Vehicle Integrity damage.
- Per-contact cooldown/hysteresis prevents overlap damage spam.
- Light props break/shove; medium props deform path and heavily slow; heavy barriers stop or force reroute.
- Zombies are rammed, glanced, or avoided; direct low-speed contact damages over a rate-limited interval.
- Equipped parts are never permanently destroyed. Critical Integrity may add readable temporary performance pressure but not hidden cascading failures.
- Stuck recovery offers a short hold-to-reset to the nearest safe local position with a transparent Integrity/Fuel or time cost; it cannot teleport through route barriers.

### Suspension and animation

Use visual body roll, pitch, wheel steer, terrain bounce, skid, dust, sparks, and suspension travel to communicate weight. These are presentation layers driven by vehicle state; 1.0 does not require physical wheel-by-wheel suspension simulation.

### Camera

- Non-rotating top-down composition with velocity look-ahead and restrained speed zoom.
- Landmark/objective framing may bias look-ahead without stealing control.
- Collision shake, drift impulse, and zoom response are intensity-limited and independently reducible/disableable.
- Camera never hides immediate hazards under UI or safe-area edges.

### Input support

- Keyboard: rebindable gas, brake/reverse, left/right, handbrake, map, interact/confirm, pause.
- Controller: analog steering/triggers, full menu navigation, correct glyph prompts, disconnect/reconnect handling.
- Touch: simultaneous steering/pedals/handbrake; adjustable size/opacity/position; left-handed layout; sensitivity/dead zone; optional auto-accelerate after playtest validation.
- Haptics: surface texture is subtle; impacts, warnings, rewards, and critical state are rate-limited patterns.

### Driving accessibility

- Steering sensitivity and response curve.
- Steering assist and optional recenter strength.
- Brake/traction assist presets.
- Optional auto-accelerate.
- Damage, Fuel drain, and threat-density assists that do not block completion.
- Camera shake, flash, particle, blur, and haptic intensity controls.
- Gameplay-critical audio always has a visual equivalent.

## Vehicle and part ecosystem

### Chassis

Launch with three chassis:

| Chassis | Strength | Tradeoff | Natural archetypes |
|---|---|---|---|
| Scout hatch | Acceleration, agility, low noise, efficient travel | Low cargo and Integrity; light impacts | Scout, drifter, efficiency |
| Utility wagon | Balanced capacity, stable handling, flexible slots | No extreme strength | Explorer, mixed expedition, support |
| Hauler pickup | Cargo, mass, ram force, durability | Fuel use, turning radius, offroad recovery | Rammer, cargo hauler, endurance |

The Utility wagon is the default. Scout and Hauler are unlocked through authored restoration milestones, not random drops.

### Functional slots

1. **Powertrain** — torque, speed, Fuel, heat/noise tradeoffs.
2. **Traction** — tires/suspension, grip, surface specialization, drift tradeoffs.
3. **Protection** — Integrity, mass, collision resistance, repair tradeoffs.
4. **Ram** — impact behavior, threat handling, steering/mass cost.
5. **Utility** — lights, winch/recovery, scanner, repair, weather tools.
6. **Cargo/support** — capacity, securing, fragile cargo, Fuel reserve, noise.

Each chassis defines compatible capacity, baseline mass/power/cargo, and limited slot modifiers. No chassis is strictly superior.

### Part design contract

Every functional part declares:

- Stable catalog ID and localization keys.
- Slot and compatibility tags.
- At least one player-visible capability.
- At least one cost, condition, or tradeoff.
- Mass, power/fuel, cargo, noise/threat, durability, and handling effects where relevant.
- Exact compare deltas and any synergy tags.
- Source/unlock, fabrication value, duplicate rule, and content version.
- Benchmark expectations and proof scene.

Avoid random affix soup and color-coded rarity as the primary progression. Launch parts are named, learnable designs. Quality is expressed by fit and capability, not an endless number ladder.

### Build archetypes

- **Endurance scout:** quiet, efficient, signal-aware; avoids threats; low collision tolerance.
- **Offroad explorer:** traction, clearance, recovery; slower pavement and lower cargo.
- **Agile drifter:** turn response and handbrake control; fragile and less efficient.
- **Armored rammer:** mass, protection, ram; high Fuel/noise and weak narrow-route control.
- **Cargo hauler:** capacity and securing; slower acceleration and increased route risk.

Hybrids remain possible. Tags expose synergies, but the game avoids hidden set bonuses. A synergy is described in the part card and visible in the resulting stat/route forecast.

### Acquisition and inventory

- Discover intact parts in risky landmarks/contracts.
- Discover blueprints that permit Scrap fabrication of replacement copies.
- Milestones guarantee key capability parts so progression cannot be blocked by random drops.
- Duplicates occupy inventory only when the player chooses to keep them for separate presets; otherwise they may be dismantled for a disclosed fraction of fabrication value.
- Inventory cap is generous and never destroys overflow. Overflow waits in a Garage intake queue until the player compares, stores, or dismantles it.
- Parts can be swapped freely at a Garage or safehouse with workshop access. There is no respec fee.
- Presets store chassis, parts, tuning, cosmetics, and control/camera preference; invalid/missing parts are explained, never silently substituted.

### Comparison and preview

- Before/after vehicle card shows acceleration, top speed, braking, road grip, offroad grip, drift, Integrity, Fuel range, cargo, noise/threat, and ram force.
- Route forecast translates stats into likely benefits for the selected contract without declaring one correct build.
- Garage test lot permits immediate drive preview and undo before leaving.
- Purchases/fabrication show source, exact cost, effect, drawback, compatibility, and duplicate state.

### Tuning

Tuning is small and reversible: steering response, final-drive bias, tire pressure/grip bias, and suspension firmness may shift existing tradeoffs inside safe bounds. It cannot create a second hidden upgrade tree. A reset is always free at a workshop.

### Cosmetics

- Paint, decals, wheel style, Garage trophies, and non-gameplay vanity.
- Cosmetics are earned through exploration, mastery, and milestones at launch.
- Cosmetic systems cannot change hitboxes, readability, or stats.

### Balance controls

- Catalog data exports to a benchmark table.
- Standard road, offroad, impact, Fuel, cargo, and threat scenes score each build.
- No build may dominate every benchmark.
- Part adoption, completion, and failure data may be collected in opt-in playtests; balance never depends on opaque live tuning.
- Catalog versioning supports post-launch additions without changing owned part identity or invalidating saves.

## Progression and economy

### Primary progression

Restore the county road network:

- Reopen safehouses.
- Complete region restoration objectives.
- Discover route knowledge, landmarks, and shortcuts.
- Recover chassis and key blueprints.
- Complete one final cross-county expedition demonstrating routing, build, and survival mastery.

Progression is capability- and place-based, not a generic player level.

### Secondary progression

- Scrap and part inventory.
- Blueprint/catalog completion.
- Vehicle and loadout mastery goals.
- Region discoveries and safehouse completion.
- Contract medals and route mastery.
- Best Expedition Mode distance/score by chassis or rule set.

### Currency and resources

- **Scrap** is the only spendable currency.
- **Fuel** and **Vehicle Integrity** are expedition resources, not currencies.
- **Parts**, **blueprints**, **discoveries**, and **restoration milestones** are owned content/unlocks, not fungible token types.
- Contract cargo is temporary expedition state.

### Sources

- Successful objective/extraction payout.
- Loose salvage brought home.
- Dismantled duplicate parts.
- Region and mastery milestones.

### Sinks

- Fabricating known parts.
- Safehouse workshop/restoration upgrades with visible world effects.
- Optional cosmetic fabrication.
- Limited expedition preparation such as repair/fuel top-up only if playtesting proves it adds a decision; never a recurring tax that blocks play.

No repair timers, loot-box keys, premium currency, durability tax on owned parts, or arbitrary inventory expansion purchase.

### Pacing targets

- First meaningful part choice during the first session.
- New capability, destination, chassis clue, blueprint, or substantial build choice at least every 30-45 minutes during primary progression.
- No required repetition of the same contract template to reach a milestone.
- All primary-route capability checks have at least two viable acquisition paths.
- Completing the primary arc does not require owning every part or mastering every contract.

### Anti-grind and catch-up

- Explicit reward previews and guaranteed milestone blueprints.
- Region first-completion bonus and diminishing payout for immediately repeated low-risk contracts.
- Failed expeditions preserve knowledge/milestones and a fair fraction of loose value.
- New chassis unlocks include a viable starter loadout.
- Balance changes never confiscate owned items; deprecated parts migrate to an equivalent or refund.

### Difficulty

- Region, contract risk, weather, optional objectives, and chosen route create transparent difficulty.
- No hidden rubber-banding based on player success.
- Assistance settings may reduce Fuel drain, damage, threat density, or timing pressure without blocking progression or achievements unless a specific mastery trial says otherwise.
- Mastery trials publish their fixed rules.

## Activities and content

### 1. Salvage and recovery

Find a target vehicle, part crate, machinery component, or route asset and bring it to a workshop. Cargo may add mass, occupy capacity, change balance, or require a secured slot. The route out differs from the route in because the haul changes the car.

Replay levers: target socket, region condition, cargo property, optional bonus cache, encounter set, return point.

### 2. Risky delivery

Move medical, mechanical, fuel, or signal cargo between safehouses. Some cargo is fragile, heavy, noisy, or time-sensitive; not every delivery is timed. The challenge is selecting a build and route, not following an arrow through generic checkpoints.

Replay levers: cargo modifier, source/destination, weather, road condition, bonus condition.

### 3. Route restoration

One-time or evolving campaign objectives: clear a major crossing, reactivate a relay, tow/start a stranded generator, survey a blocked route, or reconnect a safehouse. Completion changes travel, encounter eligibility, map knowledge, or return safety.

These are the authored spine and should not be procedurally repeated without a different world consequence.

### 4. Route mastery

Time, Fuel, damage, cargo, drift, or chassis-specific trials on known roads. These are optional mastery tests with fixed rules and clear medals, never mandatory grind gates.

### Dynamic encounters

Rescue signals, moving swarms, salvage lures, weather incidents, disabled vehicles, and roadblock variants provide moment-to-moment variation. They are modular encounter events, not separate menu activities.

### Excluded activity types

- AI circuit racing: expensive opponent AI and track logic dilute the survival-road identity.
- Escort convoys: fragile companion navigation creates high cost and frustration.
- On-foot puzzles/combat: violates car-as-character.
- Daily chores or streaks: conflicts with ethical offline product.
- Generic collection checklists without a route/build discovery payoff.

## Reward structure

| Reward | Purpose | Security rule |
|---|---|---|
| Scrap | Flexible fabrication/restoration | Unsecured until extraction; partial failure recovery |
| Intact part | Immediate exciting build choice | Cargo until extraction; one secured slot |
| Blueprint | Expands future fabrication | Permanent on discovery/validation |
| Landmark/shortcut | World knowledge and route power | Permanent immediately |
| Safehouse/restoration | Primary progression and return network | Permanent on objective completion |
| Cosmetic/trophy | Mastery/exploration expression | Permanent on award |
| Expedition score | Endgame mastery | Recorded only from valid completed/failure resolution |

Rewards should alter capability, place, or expression. Avoid rewards whose only function is filling another meter.

## Replayability and endgame

Replayability layers:

1. Learn authored roads, shortcuts, landmarks, and region rules.
2. Encounter different seeded weather, closures, hazards, and rewards.
3. Choose different objectives and risk conditions.
4. Build different chassis/loadouts that prefer different routes.
5. Complete mastery medals and region discovery.
6. Run Expedition Mode with fresh deterministic seeds and production systems.

The main game has a clear ending. Endgame is optional mastery, not an infinitely rising stat requirement.

### Expedition Mode

- Unlocked during late primary progression; full rules open after completion.
- Drive outward through remixed route segments and escalating pressure.
- Score considers distance, secured salvage, route risk, damage efficiency, encounter resolution, and build rule—not only radial distance.
- Seed can be shared as text without an account.
- No exclusive daily reward. Optional featured seed is additive and remains locally replayable.

## Game-design acceptance gates

- Five-player first-minute test meets comprehension and movement targets.
- Handling lab passes collision, surface, frame-rate, controller, and recovery criteria.
- Hybrid proof region provides one meaningful decision every 30-45 seconds with no obvious repeated route grammar.
- Twelve-part prototype supports at least three distinct viable builds; none dominates all benchmarks.
- Three-run economy test makes extraction, continuation, and failure meaningfully different without encouraging intentional failure or farming.
- One-hour progression test offers at least two credible build paths and a meaningful upgrade choice in the first session.
- Campaign content floors pass repetition review, density review, and complete-start-to-finish human playtest.
- Expedition Mode adds replay value without being required to finish the primary arc.
