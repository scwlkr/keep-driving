# Keep Driving Game Design

Status: resolved gameplay/content/progression baseline; D020 owns numeric scope lock and all bracketed tuning values remain prototype hypotheses
Design date: 2026-07-11

## Design summary

Keep Driving 1.0 is a single-player, destination-based survival-driving roguelite inside one connected, learnable county. The player departs from a Garage or restored safehouse, crosses an open road network, completes an objective or explores, recovers unsecured cargo, and chooses whether to press onward or extract. Driving, navigation, vehicle builds, and risk management are the game. Combat remains car-only. Each departure freezes a deterministic expedition manifest; the authored county and committed profile/county state remain stable across departures. Unsecured capability and material rewards stay in escrow until extraction.

The game combines authored place with deterministic variation:

- Authored macro roads, regions, landmarks, shortcuts, crossings, and safehouses make the world memorable.
- Seeded weather, route incidents, threats, salvage, contracts, and encounter composition make repeated travel tactically different.
- If retained by D020, Expedition Mode reuses the production systems for open-ended chained survival over the completed authored county after the main restoration arc.

## Moment-to-moment model

At speed, the player repeatedly performs a compact decision loop:

1. **Read** — road surface, fork, objective cue, threat, weather, cargo state, and available escape line.
2. **Choose** — fast road, safer detour, offroad shortcut, optional reward, confrontation, or return.
3. **Commit** — accelerate, brake, drift, ram, recover, or reroute using the current build.
4. **Feel** — surface, weight, collision, damage, sound, haptics, and clear outcome feedback.
5. **Reassess** — updated Fuel, Integrity, cargo, pressure, route, and time.

Content-density hypotheses: while driving, a consequential route/resource/build/risk tradeoff should occur every `[PLACEHOLDER: 30-45 seconds]`. Passive scenery, routine steering, navigation confirmation, and cosmetic pickups do not count. A major landmark, objective beat, or safe decision boundary should occur every `[PLACEHOLDER: two to three minutes]`. Empty travel longer than `[PLACEHOLDER: 60 seconds]` is a pacing-review trigger unless deliberately used as brief contrast.

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

- Completing an objective may activate a second destination, bonus route, rare signal, or safer return only when that branch was frozen into the manifest at departure.
- The player may bank at a restored safehouse, return to the Garage, follow another manifest-declared objective branch, or keep exploring.
- The UI communicates exactly what is secured and what remains at risk.

### Resolution

- **Successful extraction:** close the expedition transaction exactly once, bank all eligible escrowed Scrap/parts/blueprints/chassis/payouts, commit pending objective mutations, and present concise run highlights.
- **Voluntary restored-safehouse stop:** closes the current expedition exactly like a Garage return. Continuing starts a new expedition from that safehouse after Results/loadout, with a new manifest, serviced baseline Fuel/Integrity, reset Pressure, no unresolved escrow, and the same namespaced `RewardLedger` plus repetition ledger. This does not imply teleporting to any other safehouse or refreshing value.
- **Vehicle failure:** pre-departure owned chassis/parts/profile facts remain, and durability-acknowledged retained observation/cosmetic deltas in the active outbox transfer exactly once into Campaign. Pending Scrap, intact parts, blueprints, chassis, cargo, payouts, and restoration mutations are lost except for the disclosed bounded Scrap recovery hypothesis below and one eligible intact part/blueprint/cargo item explicitly assigned to installed secure-storage hardware. Chassis, payouts, and world mutations are never secure-compartment items; there is no free “best item” retention.
- **Stranded:** Fuel reaching zero after the visible grace state settles material rewards like vehicle failure; it remains a distinct result for tuning and support evidence.
- **Abandon expedition:** an explicit confirmed action that settles like failure. It never rolls back damage or teleports rewards to the last safe boundary.
- **Quit, background, or interruption:** save and resume the exact active expedition manifest/checkpoint. Reopening the app is not abandon and never rerolls offers, rewards, conditions, or encounters.

Failure must sting without deleting hours. It must not be optimal to intentionally fail instead of returning.

### State ownership and expedition manifest

| Layer | Owns | Persistence rule |
|---|---|---|
| Profile | Owned chassis/parts, banked Scrap/blueprints, completion/records, one namespaced `RewardLedger` for profile/county-socket eligibility/claims/cooldowns, repetition ledger | Permanent and versioned; sole reward-claim authority, never lost on expedition failure or reset by a new manifest |
| Settings | Preferred input, gameplay-assist, Presentation, audio, and feedback values | Independent versioned image owned by the ApplicationShell Settings Implementation; active gameplay copies effective gameplay/physics values into `ExpeditionProgress` rather than reading mutable preferences |
| County | Authored topology/content IDs, committed observed roads/landmarks, committed safehouse/restoration mutations | Stable across expedition seeds and saved independently from the active run; never duplicates reward-claim authority |
| Expedition offer set / plan | Monotonic offer epoch, committed-source digest, and immutable keyed plans containing content/world version, expedition ID/seed, repetition-history snapshot, contract definition, conditions/closures, pre-rolled Pressure branches, encounter/reward rolls, valid extraction nodes, finite reward budget | Whole set is frozen and committed before display; Back/cancel/reselect/loadout/assist/relaunch cannot replace it, and the selected plan is copied unchanged into departure |
| Expedition manifest | One immutable offer plan plus selected starting loadout/resources and starting `AppliedExpeditionAssistPolicy` | Bound without RNG at departure; never regenerated from later profile/county/loadout/settings state |
| Expedition progress | Position, Fuel/Integrity, Pressure, current applied assist policy, `RetainedCampaignDeltaOutbox`, active encounter/branch and objective substate, consumed sockets, escrow, pending mutations, terminal `resolution_id` | Mutable durability-gated checkpoint stored beside the manifest; resumes the authoritative verified-slot checkpoint and transfers retained IDs/settles exactly once |
| Ephemeral runtime | Presentation, transient AI/effects, reconstructable caches | May be rebuilt only from the saved county plus immutable manifest and authoritative verified-slot progress checkpoint; owns no reward or progression truth |

Expedition and objective state are orthogonal:

```text
expedition: offered -> active -> extracted | wrecked | stranded | abandoned
objective:  not_started -> active -> field_complete | objective_failed
```

Return is a reversible player intention, not a required lifecycle gate: the player may extract, push, or follow only objective branches already frozen into the manifest while active. `objective_failed` does not automatically destroy the expedition; the player may still return with other escrowed salvage. Generation must graph-validate an outbound path and an extraction path for the selected loadout, cargo, closures, and permanent topology before departure. Invalid manifests never begin. Current v0 marker IDs include `run_seed` and current run mutations clear on restart; those are prototype constraints to replace, not production save contracts.

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
- Contract variants and bonus conditions; post-progression Expedition layouts/rules only if retained by D020.

The expedition overlay may change conditions, closures, objectives, encounters, and rewards. It never regenerates the authored macrograph, landmark identity, or committed restoration state. Every authored county object uses a seed-independent stable ID; expedition-spawned objects use manifest-scoped IDs and cannot become permanent county truth by accident.

### Living-world selection

Do **not** build generalized civilian traffic, friendly vehicle pathfinding, or a persistent population simulation for 1.0. In a hostile post-collapse county, ordinary traffic weakens the fantasy while adding collision, navigation, AI, audio, content, and mobile-performance cost that does not improve the core driving decisions.

Make the county feel inhabited and reactive through a bounded stack instead:

- Migrating zombie pressure, road-crossing swarms, and route-aware threat patrols use the same deterministic event sockets as other encounters. Zombies are a supporting encounter fiction, not the product headline; the route/build/return loop must survive replacement of that fiction.
- Safehouses show small stateful work loops—lights, gates, tools, smoke, radios, parked vehicles, and changing restoration activity—without adding on-foot NPC interaction.
- Noninteractive ambient life uses cheap pooled silhouettes and audio: birds lifting from fields, insects, distant wildlife, wind-driven debris, water, dust, weather fronts, and changing distant smoke/light signals.
- Rare authored survivor signals may appear as radio calls, distant headlights, an already-departing vehicle silhouette, or changed roadside evidence. They communicate other people without creating a traffic simulator or collision promise.
- Ambient motion never masks a hazard, imitates an objective cue, consumes collision budget, or exceeds the readability/effect cap. Encounter and ambience density are reported separately.

The acceptance question is not “is something always moving?” Five-player region tests must describe the county as reactive and inhabited while still reading routes, hazards, and objectives at speed; the representative max-density scene must remain inside the phase performance budget. If that fails, improve state change and authored evidence before adding autonomous traffic.

This replaces pure procedural infinity in the campaign because exploration needs recognizable place, deliberate sightlines, and route memory. It retains deterministic generation because repeated travel needs variation, reproducibility, testability, and compact saves.

### World scale and provisional content target

The counts below remain planning targets until the production tranche and cut ladder in `PRODUCT_VISION.md` pass. Do not multiply content or call these minimums from competitor research alone.

- Three connected regions: Lowlands, Badlands, Blackwood working identities.
- At least 15 major landmarks and six safehouses/return points. Independent provisional content floors are six Restoration Objectives; four Contract Definitions (at least two Delivery and two Recovery); six decision-distinct Delivery Contract Instances; six decision-distinct Recovery Contract Instances; six Mastery Overlays; and 15 Encounter Templates. D020 may rebaseline them, but surplus in one axis never substitutes for another.
- At least two credible routes between adjacent major destinations; at least one build-conditional shortcut in each region.
- Road density should support 10-15 minute direct crossings and 15-25 minute objective expeditions without making the map feel like a city grid.
- The full primary road graph must be traversable without a specialized build; specialized routes provide efficiency, safety, rewards, or mastery advantages rather than mandatory progression locks.

### Content counting and production cells

D020 counts decision-bearing production content, not parameter permutations:

- **Restoration objective:** a one-time authored state machine that commits a visible county/service/topology change.
- **Contract definition:** a reusable Delivery or Recovery decision grammar/state schema. A new origin, reward number, or fiction skin is never a new definition.
- **Contract instance:** a final-pipeline authored origin/target/return/cargo configuration using a definition. It counts only toward its independent Delivery or Recovery Contract Instance floor when it changes the route/build/return decision; parameter or fiction swaps remain variants and are reported separately.
- **Mastery overlay:** a fixed disclosed rule/medal condition applied to a validated route or activity; it does not require another activity state machine.
- **Encounter template:** a distinct telegraphed route decision with materially different response grammar. Different counts, skins, or stat tuning alone do not create another template.
- **Part:** one mechanically distinct named catalog item with its own capability, burden, presentation, localization, source, and test expectations. A numerical tune or cosmetic variant does not increment the part count.
- **Viable build:** a validated route-changing loadout pattern, not a label or chassis name.

The repeatable authoring unit is a **landmark-centered content cell**: a navigation anchor; at least two approach/exit choices; one build-sensitive shortcut or response; one supported permanent/pending state change; declared activity and encounter sockets; discovery/story evidence; stable IDs; and final-pipeline art/audio/localization/performance metadata. A cell or objective counts as production-ready only after all outcomes/resume boundaries pass, at least two route/build strategies are validated, and authoring/rework/QA hours plus defects and package cost are recorded. A bespoke mechanic must support `[PLACEHOLDER: three]` authored objectives or be costed as unique work in D020 rather than hidden as reusable production.

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

### Dynamic routes, encounters, and Pursuit Pressure

At offer creation, the builder commits one immutable `ExpeditionOfferSet` for the current epoch. `PrepareDeparture` never invokes RNG: it validates the full preferred expedition policy plus `SettingsAssistVersion(settings revision, full-policy digest)` and loadout legality, copies the selected plan unchanged, and freezes starting loadout/resources/`AppliedExpeditionAssistPolicy` into manifest/progress/config/domain digest. Settings/loadout never change offers, rewards, conditions, rolls, or threat composition; they change only legality, declared starting fields, effective assists, and forecast.

Once departure commits, its plan is reserved; settlement consumes it. Eligible lower-PROFILE recovery preserves/resumes a trusted matching terminal/nonterminal active. Only no trusted matching active plus `POSSIBLE` higher-active risk burns the recovered current set and discards unverifiable value. Every lower recovery persists a notice before gameplay; backing out without discarded higher state never consumes/rerolls.

Pursuit Pressure is a visible per-expedition alert model, not hidden level scaling. Its provisional four internal bands are `Quiet`, `Noticed`, `Hunted`, and `Critical`; player-facing names/visuals lock in the UX ticket. Pressure rises through explicit noisy parts/actions, objective escalation, and telegraphed encounter outcomes. It never rises merely because a player is slow, uses accessibility assists, owns stronger parts, or has played longer. It may fall only through a declared player action or authored calm state—not passive idling—and resets only when the expedition transaction closes.

The current v0 formula based on radial distance from the world origin plus elapsed time must not graduate. Every coefficient/threshold is `[PLACEHOLDER]` until manifest fuzzing and human risk-forecast tests pass. Runtime Pressure may select or escalate only within the offer plan's pre-rolled, prevalidated branch table copied into the manifest; the chosen branch is checkpointed in `ExpeditionProgress`, and no runtime RNG or loadout counter-pick can alter it. Its capped budget and graph validator must always preserve at least one legible response.

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
- At most `[PLACEHOLDER: one]` high-attention encounter is active at once, followed by `[PLACEHOLDER: 20-30 seconds]` of recoverable driving before another is forced.
- No enemy/obstacle kill grants Scrap or progression; rewards attach to objectives, discoveries, optional detours, and finite manifest salvage budgets so circling spawns cannot become an economy.

### Time and weather

The full transition/night/weather stack below is the current provisional target. D020 may reduce multiplicity, but the retained route-condition set must remain readable, consequential, and accessibility-safe.

- If time-of-day remains, time advances during expeditions and pauses at menus; the tutorial starts in clear daylight.
- If a light transition remains, a normal 15-25 minute expedition may cross one meaningful transition but should not cycle through a full day unrealistically.
- If night remains, it changes sightline, threat, route, light, and audio behavior, not just screen tint.
- Retained weather affects grip, visibility, surface, route/event eligibility, ambience, and some part value.
- No hunger, temperature, thirst, or extra survival bars.
- Reduced-intensity and high-visibility modes preserve essential information.

### Navigation and provisional fast travel

- HUD shows a minimal direction/distance cue plus next turn or landmark signal; no debug minimap.
- The full map pauses this offline game, supports zoom/pan, objective filtering, discovered roads, region condition, safehouses, and one player pin.
- If retained by D020, restored safehouses enable fast travel after their routes have been physically discovered.
- Fast travel exists only from a Garage/restored-safehouse planning state after the current expedition transaction is closed. It never operates with an active manifest, escrow, or pending mutation, costs no currency, and cannot complete contracts. It exists to respect completed travel, not bypass extraction or exploration.

### Expansion strategy

Regions are stable-ID content packages with authored graph data, baked chunks, event sockets, localization keys, catalog dependencies, and migration rules. A post-launch region can attach at declared boundary nodes without reseeding or invalidating existing world discoveries. New conditions/templates declare compatible cells and manifest versions; unsupported Cartesian combinations are rejected rather than assumed safe.

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

### Route-capability contract

The production handling model remains one shared control language across chassis and builds. Parts may alter acceleration, range, traction, noise, impact behavior, cargo, recovery, or route forecast; they never replace driving with a separate minigame or make the stock vehicle unable to finish the primary graph.

Required progression always offers a stock-capable route. Specialization earns a shorter, safer, richer, or mastery-eligible route and should provide `[PLACEHOLDER: 15-25%]` time/resource advantage in its favored scenario—not a binary campaign key. Winch/utility capability is self-recovery or an authored site interaction only; simulated towing, trailers, and companion-vehicle pathfinding require their own prototype and D020 unique-work budget.

## Vehicle and part ecosystem

### Chassis — provisional D020 target

The current target is three launch chassis. Phase 3 locks or rebaselines the count through D020; the coherent fallback retains at least two chassis and four route-changing builds.

| Chassis | Strength | Tradeoff | Natural archetypes |
|---|---|---|---|
| Scout hatch | Acceleration, agility, low noise, efficient travel | Low cargo and Integrity; light impacts | Scout, drifter, efficiency |
| Utility wagon | Balanced handling and flexible slot access | Cannot reach any specialist's peak range, cargo, impact, stealth, or offroad efficiency | Explorer, mixed expedition, support |
| Hauler pickup | Cargo, mass, ram force, durability | Fuel use, turning radius, offroad recovery | Rammer, cargo hauler, endurance |

The Utility wagon is the default. Under the current provisional target, Scout and Hauler are unlocked through authored restoration milestones, not random drops; D020 may rebaseline the final launch set.

### Functional slots — current provisional target

D020 locks or rebaselines the launch slot set; the coherent fallback retains five functional slots.

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

### Loadout composition

- Each chassis begins roadworthy with one stock component in every D020-locked functional slot.
- A loadout installs at most one named part per compatible slot and must remain within the chassis's visible **Build Capacity** budget. Stock components consume no Build Capacity; specialized parts consume declared capacity according to capability.
- Composition order is deterministic: chassis base facts -> additive part deltas -> explicitly bounded multipliers -> declared clamps -> derived capability tags and route forecast. The compare screen exposes every contributor.
- Incompatibilities require a physical/semantic reason recorded in catalog data. There are no hidden set bonuses, random rolls, or hand-authored pair exceptions outside the validator.
- Chassis capacity is a tradeoff, not a linear upgrade track. No permanent purchase raises every chassis's capacity and erases loadout choice.
- A secure-storage part may protect exactly one explicitly assigned intact part, blueprint, or cargo item on failure, but it consumes a real functional slot and Build Capacity. Chassis, payouts, and pending world mutations are ineligible. Selection is explicit when the item is loaded; the game never auto-saves the most valuable item.

### Build archetypes — current provisional target

D020 locks or rebaselines the final archetype set; the coherent fallback must still prove four viable route-changing builds.

- **Endurance scout:** quiet, efficient, signal-aware; avoids threats; low collision tolerance.
- **Offroad explorer:** traction, clearance, recovery; slower pavement and lower cargo.
- **Agile drifter candidate:** turn response and handbrake control; fragile and less efficient. It counts toward the provisional fifth build only if route-choice evidence shows more than handling-style preference.
- **Armored rammer:** mass, protection, ram; high Fuel/noise and weak narrow-route control.
- **Cargo hauler:** capacity and securing; slower acceleration and increased route risk.

Hybrids remain possible. Tags expose synergies, but the game avoids hidden set bonuses. A synergy is described in the part card and visible in the resulting stat/route forecast.

### Acquisition, ownership, and presets

- An extracted intact part grants permanent ownership; an extracted blueprint permits one-time Scrap fabrication of that named part.
- Milestones guarantee multiple paths to key capabilities so primary progression cannot be blocked by random drops or Scrap shortage.
- The single-player launch game owns each named part once. Later duplicate intact parts/blueprints auto-convert at a disclosed fixed Scrap value after extraction; they never create inventory clutter.
- Owned parts cannot be sold, destroyed, or lost. There is no inventory cap, overflow queue, or respec fee.
- Because only one vehicle is active, saved presets may reference the same owned part. Applying a preset simply moves owned parts into the active loadout and explains any missing/incompatible content; it never requires duplicate copies.
- Parts can be swapped freely at a Garage or a restored safehouse with workshop access.

### Comparison and preview

- Before/after vehicle card shows acceleration, top speed, braking, road grip, offroad grip, drift, Integrity, Fuel range, cargo, noise/threat, and ram force.
- Route forecast translates stats into likely benefits for the selected contract without declaring one correct build.
- Garage test lot permits immediate drive preview and undo before leaving.
- Purchases/fabrication show source, exact cost, effect, drawback, compatibility, and duplicate state.

### Tuning

Fine tuning is Valuable if Capacity Allows, not required for 1.0. If promoted, it stays small and reversible: steering response, final-drive bias, tire pressure/grip bias, and suspension firmness may shift existing tradeoffs inside safe bounds. It cannot create a second hidden upgrade tree. A reset is always free at a workshop.

### Cosmetics

- A small earned paint palette is a provisional Required target until D020 lock; decals, wheel styles, Garage trophies, expanded vanity, and photo-mode support are Valuable if Capacity Allows.
- Any shipped cosmetics are earned through exploration, mastery, and milestones; none are launch IAP.
- Cosmetic systems cannot change hitboxes, readability, or stats.

### Balance controls

- Catalog data exports to a benchmark table.
- Standard road, offroad, impact, Fuel, cargo, and threat scenes score each build.
- At the same chassis and Build Capacity budget, no obtainable loadout may be Pareto-dominant across the route-scenario matrix: weakly equal or better on every relevant scenario and strictly better on at least one while using no more slots/capacity. Later unlock timing or one-time Scrap price never excuses permanent dominance.
- Every D020-locked required build must clear representative primary scenarios, be materially favored in at least one, and expose a weakness that changes a route, cargo, or risk decision. `[PLACEHOLDER]` prototype hypothesis: each required build is top-two in at least two scenarios and bottom-half in at least one; no build is top-two across more than half the matrix.
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

- Banked Scrap and named-part ownership.
- Blueprint/catalog completion.
- Vehicle and loadout mastery goals.
- Region discoveries and safehouse completion.
- Contract medals and route mastery.
- If retained by D020, best Expedition Mode distance/score by chassis or rule set.

### Currency and resources

- **Scrap** is the only spendable currency.
- **Fuel** and **Vehicle Integrity** are expedition resources, not currencies.
- **Parts**, **blueprints**, **discoveries**, and **restoration milestones** are owned content/unlocks, not fungible token types.
- Contract cargo is temporary expedition state.

### Sources

- Successful objective/extraction payout.
- Loose salvage brought home.
- Automatic disclosed conversion of duplicate intact parts/blueprints after extraction.
- Region and mastery milestones.

### Sinks

- Fabricating an unowned known part once.
- Optional safehouse service improvements with visible world effects, only after required restoration remains objective-driven and no-grind.
- Optional cosmetic fabrication.

Required restoration is never a Scrap toll. Every departure from a Garage/restored safehouse starts with the declared serviced baseline Fuel/Integrity at no cost; bankruptcy cannot block driving. There are no repair timers, paid Fuel/repair top-ups, consumable preparation clutter, loot-box keys, premium currency, durability tax on owned parts, or inventory expansion purchase. Scrap surplus after the player owns everything they want is an acceptable completion state, not a reason to invent an infinite tax.

### Pacing targets

- First meaningful part choice during the first session.
- New capability, destination, chassis clue, blueprint, or substantial build choice at least every `[PLACEHOLDER: 30-45 minutes]` during primary progression.
- No required repetition of the same contract template to reach a milestone.
- All primary-route capability checks have at least two viable acquisition paths.
- Completing the primary arc does not require owning every part or mastering every contract.

### Anti-grind and catch-up

- The first successful return guarantees a choice between two useful starter parts and grants ownership of the selected one; it never depends on random loot or affordability.
- Explicit reward previews and guaranteed milestone capability paths.
- First-clear payouts and fixed disclosed repeat payouts replace opaque diminishing-return formulas.
- Each offer plan has a finite salvage/reward budget copied unchanged into its manifest, and every new offer plan inherits the namespaced `RewardLedger` plus repetition ledger. Reload, failure, fast travel, safehouse Continue/bounce, backing out of an offer, changing loadout, and re-entering a socket never refresh or reroll claimed/rolled value.
- Failed expeditions transfer only durability-acknowledged retained observation/cosmetic deltas plus preserve previously committed profile/county facts; capability/material rewards follow the escrow contract.
- New chassis unlocks include a viable starter loadout.
- Balance changes never confiscate owned items; deprecated parts migrate to an equivalent or refund.

### Economy tuning hypotheses

All values below are paper-prototype anchors, not content locks:

| Variable | `[PLACEHOLDER]` starting hypothesis | Broken if |
|---|---:|---|
| Standard prepared extraction | 0.4-0.6 starter-part-cost units per expedition | Ordinary progress regularly requires repetitive farming |
| Declared high-risk extraction | 0.7-1.0 starter-part-cost units | Risk has no legible upside or dominates every safer choice |
| Failure recovery | 15-20% of loose Scrap, capped at 0.25 starter-part cost; no free part/blueprint/cargo | Fail-fast competes with extraction or feels equivalent to full wipe |
| Exploit ceiling | Fail/idle/circle/bounce/reload strategy below 70% of cautious objective play per active minute | Any non-objective loop becomes the rational progression path |

The economy simulator covers cautious, average, risk-taking, failure-heavy, fail-fast, circling, safehouse-bounce, reload, and alternating-low-risk profiles. It must prove every required milestone/capability has a non-random path, no profile can soft-lock at zero Scrap, and no strategy generates duplicate or unbounded rewards.

### Difficulty

- Ship descriptive presets plus a Custom configuration with independent assists; exact preset names/count defer to UX and user testing. Players may change them during the campaign without losing progress, rewards, or the ending; only an explicitly declared mastery overlay may fix rules for that attempt.
- Region baseline, manifest conditions, cargo burden, optional objective, chosen route, and explicit Pressure actions create transparent difficulty. The departure forecast shows contributors and uncertainty rather than one false-precision score.
- Difficulty grows through topology, mixed constraints, tighter resource decisions, and more demanding but telegraphed encounter composition—not enemy-health inflation or scaling to player success/owned power.
- Timers exist only on explicitly timed cargo or mastery overlays. Ordinary Pressure never rises from wall-clock time, so slower and accessibility-assisted driving is not punished.
- Hazard telegraph starts at `[PLACEHOLDER: >=1.5 seconds]` time-to-collision at current speed; untelegraphed event damage never exceeds `[PLACEHOLDER: 25%]` Integrity. Manifest validation rejects unavoidable lethal combinations or objectives with no loadout-valid extraction path.
- Assistance settings may reduce Fuel drain, damage, threat density, or the disclosed delta from an action-triggered Pressure change without blocking campaign progression, changing rewards, or changing the ending. They never increase Pressure; mastery overlays may publish fixed assist rules only before acceptance, never retroactively.
- In human tests, at least 80% correctly order the relative risk of compared route/contract options from the forecast. Hidden rubber-banding, inaccessible objectives, or a route that becomes impossible solely because the player used an assist are design defects.

## Activities and content

Launch uses three core activity state machines. The current provisional fourth player-facing category, Route Mastery, is a reusable rules overlay rather than another implementation family; D020 can remove its standalone presentation without discarding campaign replay tests. Every retained activity must remain route/build/return-centered.

### 1. Recovery

Reach an authored site with the outward vehicle unburdened, then load a part crate, machinery component, or abstracted vehicle asset and adapt the return route to its mass, capacity, fragility, or noise. Vehicle recovery resolves as a site interaction/cargo state; launch scope does not simulate towing.

Replay levers: target socket, region condition, cargo property, optional bonus cache, encounter set, return point.

### 2. Risky delivery

Move medical, mechanical, fuel, or signal cargo between declared nodes. The burden is known before departure, so the core decision is choosing the build and outbound route. Cargo may be fragile, heavy, noisy, or explicitly timed; ordinary deliveries are not timed by default.

Replay levers: cargo modifier, source/destination, weather, road condition, bonus condition.

### 3. Route restoration

One-time or evolving campaign objectives: clear/stabilize a major crossing, reactivate a relay or fixed generator, survey a blocked route, or reconnect a safehouse. During the expedition the mutation is pending; extraction commits it exactly once, except that completing a safehouse may itself establish the valid extraction boundary. Completion changes travel, encounter eligibility, map knowledge, or return safety.

These are the authored spine and should not be procedurally repeated without a different world consequence.

### Route Mastery overlay — provisional fourth category

Time, Fuel, damage, cargo, drift, or chassis-specific conditions wrap validated routes/activities. These are optional tests with fixed rules and clear medals, never mandatory grind gates or exclusive power sources. Agile drift expression belongs here unless it proves route-changing build value.

### Data contracts and sustainable production

Every production definition carries player-facing purpose, inputs, outputs, terminal/failure states, resume rules, supported combinations, tuning levers, dependencies, and proof IDs:

- `ContractDefinition`: core family/decision grammar, cargo phase, state machine, supported condition axes, terminal/resume/escrow rules, and compatibility schema.
- `ContractInstance`: definition ID, campaign role, origin/target/return nodes, concrete cargo/conditions, first-clear/repeat rewards, proof IDs, and measured marginal cost. Manifest-level valid extraction nodes remain a separate expedition field.
- `RestorationObjectiveDefinition`: one-time authored site/nodes, pending county/service/topology mutation, extraction boundary, all outcomes/resume rules, proof IDs, and unique-work cost.
- `EncounterDefinition`: the player decision, socket eligibility, telegraph, threat budget, baseline responses, build-specific response, graph fallback, persistence, repetition group, and no-kill reward rule.
- `PartDefinition`: slot, Build Capacity cost, capability, benefit, material burden, stacking group/clamp, source/ownership rule, route-scenario expectations, and migration version.
- `LandmarkPackage`: navigation role/silhouette, route relationships, supported sockets, state changes, discovery evidence, and art/audio/localization/performance budget.

Authors declare supported route x cargo x condition x encounter combinations; the validator does not generate a Cartesian product and hope it works. A second author must be able to produce a validated data-only variant without runtime code, inside the measured D020 budget and with less than `[PLACEHOLDER: 20%]` rework.

A normal 15-minute composition hypothesis is `[PLACEHOLDER: 2-4]` meaningful route choices, `[PLACEHOLDER: 1-3]` dynamic encounters, one optional detour, one objective beat, and one return decision. These are pacing anchors, not quotas; surface/resource/build interactions may satisfy the `[PLACEHOLDER: 30-45-second]` decision cadence without spawning content every interval.

### Dynamic encounters

Rescue signals, moving swarms, salvage lures, weather incidents, disabled vehicles, and roadblock variants provide moment-to-moment variation. They are modular encounter events, not separate menu activities. Each must telegraph at least two baseline responses and one build-sensitive advantage; a fiction/skin swap with the same decision grammar remains the same template.

### Excluded activity types

- AI circuit racing: expensive opponent AI and track logic dilute the survival-road identity.
- Escort convoys: fragile companion navigation creates high cost and frustration.
- On-foot puzzles/combat: violates car-as-character.
- Daily chores or streaks: conflicts with ethical offline product.
- Generic collection checklists without a route/build discovery payoff.

## Reward structure

| Reward | Purpose | Security rule |
|---|---|---|
| Scrap | Flexible named-part/optional-service choice | Escrow until extraction; only the disclosed capped failure fraction can recover |
| Intact part | Immediate exciting ownership choice | Escrow until extraction; protected only by explicitly installed secure-storage hardware |
| Blueprint package | Expands future fabrication | Escrow until extraction or a declared safehouse-restoration extraction boundary |
| Recovered chassis | Opens another build foundation with a viable starter loadout | Escrow until extraction; previously owned chassis never enter risk |
| Landmark/route observation | World knowledge and navigation | Immediately durability-checkpointed as a retained observation delta; grants no material/capability reward and transfers idempotently to permanent Campaign state at every terminal outcome |
| Safehouse/restoration mutation | Primary progression and return network | Pending during field work; commits at extraction, except a completed safehouse may establish and close that boundary itself |
| Cosmetic/trophy | Mastery/exploration expression | At a valid activity/trial result boundary, immediately durability-checkpointed as a retained award delta and transferred idempotently to permanent Campaign state at every terminal outcome |
| Expedition score, if retained by D020 | Endgame mastery | Recorded only from an idempotently resolved terminal expedition |

Rewards should alter capability, place, or expression. Avoid rewards whose only function is filling another meter.

## Replayability and endgame

Replayability layers:

1. Learn authored roads, shortcuts, landmarks, and region rules.
2. Encounter different seeded weather, closures, hazards, and rewards.
3. Choose different objectives and risk conditions.
4. Build different chassis/loadouts that prefer different routes.
5. Complete mastery medals and region discovery.
6. Continue in the completed persistent county through alternate builds, unfinished discoveries, fixed mastery overlays, route/chassis records, and new manifest condition combinations.
7. If retained by D020, run Expedition Mode with fresh deterministic manifests over the same authored county graph.

The main game has a clear ending. After it, the completed profile remains playable; “campaign replay” means continued completed-county free roam/contracts/mastery, not silently resetting restoration. Starting the authored campaign from zero requires an explicit new profile. Endgame is optional mastery, not an infinitely rising stat requirement, and Scrap saturation is allowed.

### Provisional Expedition Mode

- Included only if retained by D020, and then unlocked in full only after primary completion.
- Use the same stable authored county topology; manifests remix conditions, closures, objectives, encounters, rewards, and explicit action-driven Pressure—not route identity or committed restoration.
- Score considers distance, secured salvage, route risk, damage efficiency, encounter resolution, and build rule—not only radial distance.
- Seed can be shared as text without an account.
- No exclusive chassis, part, blueprint, ending, or daily reward. Optional featured seed is additive and remains locally replayable.

## Game-design acceptance gates

- Five-player first-minute test meets comprehension and movement targets.
- Handling lab passes collision, surface, frame-rate, controller, and recovery criteria.
- Hybrid proof region tests the `[PLACEHOLDER: 30-45-second]` consequential route/resource/build/risk cadence with no obvious repeated route grammar or filler counted as a choice; it does not inflate cadence through encounter spam.
- Same authored county IDs and committed restoration persist across different expedition seeds while the declared condition overlay changes; 10,000 manifest/graph combinations across locked content/loadouts have valid outbound/extraction paths and deterministic reload.
- Every expedition/objective transition is fault-injected; reload reconstructs the same immutable manifest plus authoritative verified-slot position, Fuel, Integrity, Pressure branch, objective/encounter state, consumed sockets, escrow, and pending mutations from `ExpeditionProgress`. A `resolution_id` can commit rewards/mutations at most once.
- Twelve-part prototype supports at least three distinct viable builds as an early hypothesis; launch requires every D020-locked build (minimum four) to clear its representative scenarios with no Pareto-dominant loadout and an explained strength/weakness.
- Three-run human proof plus multi-profile economy simulation makes extraction, continuation, and failure meaningfully different. At least 80% predict exactly what is kept/lost before committing, and fail-fast/circling/bounce/reload never competes with cautious objective play.
- One-hour progression test offers at least two credible build paths and a meaningful upgrade choice in the first session.
- At least eight of ten players distinguish Delivery, Recovery, and Restoration by the decision they create rather than their fiction; mastery is understood as an overlay.
- At least 80% correctly order relative route/contract risk from departure forecasts; no manifest produces an inaccessible objective or unavoidable lethal event.
- A second author produces a validated data-only content variant without runtime code, inside the D020 time budget and `[PLACEHOLDER: <20%]` rework.
- The D020-locked campaign content target passes repetition review, density review, and complete-start-to-finish human playtest.
- Four of five post-completion players identify and voluntarily start a non-Scrap next goal. If retained by D020, Expedition Mode adds replay value without being required for the ending, owned power, or campaign replay.
