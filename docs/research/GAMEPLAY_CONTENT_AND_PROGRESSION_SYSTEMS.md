# Gameplay Content and Progression Systems Research

Status: research recommendation for Wayfinder ticket 03
Research date: 2026-07-11

## Question

What world, handling, build, extraction, economy, activity, difficulty, reward, replay, and endgame systems best deliver the selected promise—**every road is a build decision**—while keeping multiple builds viable and content production realistic?

## Evidence boundary

The sources below establish shipped design patterns, developer intent, platform guidance, or research methods. They do **not** establish that copying a feature will cause sales, retention, reviews, or commercial success. None establishes the right number of regions, chassis, parts, activities, encounters, hours, currencies, or difficulty modes for this project. Those remain production and playtest hypotheses governed by D020.

Recommendations in this document are product inferences from the selected identity, current prototype, and cited evidence. They must still pass the repo's own handling, route-memory, build-diversity, economy, repetition, accessibility, throughput, and full-campaign gates.

## Resolved recommendation

Use one coherent system stack:

1. A **stable authored county graph** supplies recognizable roads, landmarks, shortcuts, safehouses, and permanent restoration changes.
2. A **deterministic population layer** varies weather, closures, encounter composition, salvage, objective conditions, and pressure without discarding the learned place.
3. **Arcade-Real handling** makes surface, momentum, mass, collision, and recovery readable through direct controls; assists change barriers without replacing driving.
4. **Named sidegrade parts** change route fitness and carry visible costs. No rarity ladder or part may be strictly better at the same cost.
5. **Voluntary extraction** commits newly earned material/capability/world-state value. Failure stings but never erases value committed before departure; only route/lore observations persist immediately during an active expedition.
6. **Scrap is the only spendable currency**. Place, capability, knowledge, and expression are rewards, not extra token bars. Mandatory progress never requires repeating a solved low-risk activity.
7. Three **route-centered activity families**—delivery, recovery, and restoration—combine with authored sockets, cargo properties, region conditions, and encounters. Mastery is a reusable rules overlay, not a fourth family. A permutation counts only when it changes a player decision.
8. Difficulty uses **descriptive presets plus independent assists**, can change without lost progress, and preserves the same campaign and ending.
9. The campaign ends cleanly. Replay comes first from alternate routes, builds, mastery, and unfinished discoveries; seeded Expedition Mode ships only if D020 funds it after the complete campaign.

The system is deep because the same road is reconsidered under a different car, haul, condition, objective, or risk state—not because the game accumulates unrelated meters and mission types.

## What the primary sources establish

| Primary source | Confirmed source fact | Bounded product inference |
|---|---|---|
| [Nintendo's *Tears of the Kingdom* developer interview](https://www.nintendo.com/ph/interview/totk/index.html) | Nintendo's developers deliberately retained an already familiar Hyrule because knowledge of the setting enabled new play. They also describe adding new surprises without erasing the familiar world and note that doing this coherently was difficult. | Preserve county topology and landmarks, then layer changed routes and conditions over them. Familiarity is usable progression. Recombining a known world still carries substantial design and content cost. |
| [Ironwood's *Pacific Drive* loop breakdown](https://blog.playstation.com/2023/11/30/unravel-the-gameplay-loop-of-pacific-drive-launching-on-ps5-feb-22/) | Its route planner previews destination conditions; the player can adapt the car before leaving; biomes, surfaces, weather, resources, and exits affect the trip and return. | Forecast route-relevant facts before departure, but do not reveal the optimal answer. Route planning and loadout choice must be one decision, not separate menus. This is adjacent territory, not unique positioning. |
| [Saber's *SnowRunner* producer guide](https://blog.playstation.com/2020/04/23/8-tips-to-master-the-machines-of-snowrunner-out-april-28/) | The developer advises learning maps to plan routes. Terrain, cargo, Fuel, vehicle upgrades, all-wheel drive, differential lock, and winching create explicit capability and resource tradeoffs; all-wheel drive consumes more Fuel. | World knowledge, terrain, tools, cargo, and Fuel can create route decisions without binary key locks. Keep Driving should express them at arcade pace and phone-readable scale rather than imitate simulation. |
| [Criterion's vehicle-feel developer talk](https://www.gdcvault.com/play/1025295/Vehicle-Feel-Masterclass-Balancing-Arcade) | Criterion describes arcade vehicle feel as a physical simulation supplemented by camera behavior, handling assists, and other authored layers. | Preserve credible physical consequences while giving designers control over response, recovery, camera, and assists. “Arcade” need not mean frictionless or drift-only. |
| [Funselektor's official *art of rally* page](https://www.artofrally.com/) | The page presents beginner-oriented options together with expert techniques such as counter-steering, left-foot braking, and handbrake turns. | Set a low control floor and a genuine mastery ceiling. Ordinary navigation cannot require expert drifting, but skilled weight transfer and line choice should remain useful. |
| [*Wreckfest* developer/publisher store page](https://store.steampowered.com/app/228380/Wreckfest/) | Heavy armor protects the car while adding weight that changes handling; the page contrasts a robust tank with a fragile fast build. | Every protection or impact gain should expose a handling, Fuel, noise, cargo, or capacity cost. This is a concrete sidegrade pattern, not evidence for a particular part count. |
| [Supergiant's *Hades* FAQ](https://www.supergiantgames.com/blog/hades-faq/) | Supergiant describes varied attempts, permanent progression, continued story discovery, God Mode that increases resilience after deaths, a high-challenge mode, and a late-game modifier system. It also says the game's modular structure followed from its development model. | Run failure can coexist with durable forward motion; assistance and mastery can wrap the same core game. Modular structure is a precedent, not proof that this team's content will be cheap or sufficiently varied. |
| [Valve's *Left 4 Dead* AI systems presentation](https://cdn.fastly.steamstatic.com/apps/valve/2009/ai_systems_of_l4d_mike_booth.pdf) | Valve describes “structured unpredictability”: designer-bounded variation rather than pure randomness or uniform placement. Designers author valid cache/item locations, while the Director selects among them and varies enemy/loot population and pacing. | Author meaningful road and landmark sockets, then let deterministic rules choose compatible contents. The runtime layer should compose, pace, and suppress repetition—not invent unconstrained geometry or objectives. |
| [Subset's *Into the Breach* page](https://subsetgames.com/itb.html) and [Advanced Edition page](https://subsetgames.com/itb_ae.html) | Subset presents each attempt as a generated challenge and describes acquiring weapons and pilots. Its expansion adds variety along separate axes: squads, weapons, enemies, bosses, objectives, pilots, and skills. | Build reusable axes with clear contracts. More combinations are useful only when their interactions remain legible and tactically distinct; these pages do not disclose production cost or balance quality. |
| [Zagal, Björk, and Lewis, “Dark Patterns in the Design of Games”](https://ri.diva-portal.org/smash/get/diva2%3A1043332/FULLTEXT01.pdf) | The original paper defines grinding as repetitive, tedious work for progress and treats it as dark when it coerces needless time chiefly to extend duration. | Do not turn playtime targets into repeated currency work. Progression should require learning and varied decisions, while simulation and playtests detect mandatory repetition. The paper does not establish that one currency is always superior. |
| [Smith and Whitehead, “Analyzing the Expressive Range of a Level Generator”](https://www.pcgworkshop.com/archive/smith2010analyzing.pdf) | The original paper evaluates generated output by variety and parameter effects rather than output count or generation speed, and reports that analysis can expose bias and holes in a generator's range. | Measure encounter/activity output across gameplay-relevant dimensions and inspect weak clusters. “Thousands of seeds” is not proof of useful variety. |
| [Xbox Accessibility Guideline 108](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/108) | Microsoft recommends multiple descriptive difficulty presets, changing difficulty without losing progress, regular saves, independent adjustment of mechanics or assists, a very low difficulty, and pausing single-player play. It frames difficulty as the interaction between player ability and game barriers. | Use presets for discoverability and granular assists for actual needs. Do not tie the ending to one fixed barrier bundle or punish players for changing it. This is guidance, not a certification result. |
| [Apple's accessibility HIG](https://developer.apple.com/design/human-interface-guidelines/accessibility/) | Apple advises games not to rely on one sensory channel, to support personalization and system accessibility, to consider reaction-time/control assistance, to offer alternatives to gestures, and to respond to settings such as Reduce Motion. | Accessibility must be designed into handling, hazards, UI, audio, haptics, and testing. A settings checklist added after content completion is insufficient. |
| [Apple's App Store business-model guidance](https://developer.apple.com/app-store/business-models/) | Apple defines a paid app as one up-front purchase that provides all functionality without additional charges or in-app purchases. | Keep earned Scrap entirely separate from real money, timers, premium conversion, or paid acceleration. This supports the chosen complete-game contract but does not itself dictate the internal economy. |

## 1. Learnable county with systemic variation

### Stable knowledge layer

The campaign's macrograph remains authored and stable:

- Region boundaries and terrain identities.
- Primary, secondary, service, and offroad connections.
- Junction geometry, crossings, barriers, landmarks, safehouses, and curated shortcuts.
- Sightlines, tutorial spaces, objective spaces, return points, and restoration mutations.
- Stable IDs and save-safe attachment points for every persistent fact.

Player knowledge must have lasting value. A discovered ford remains a ford; a repaired bridge remains usable; a landmark remains an orientation anchor. Restoration changes the graph visibly and permanently rather than silently increasing a progression variable.

Nintendo's developers explicitly describe familiar geography as a foundation for new play, while also warning that coherent novelty in a retained world was harder than starting over ([developer interview](https://www.nintendo.com/ph/interview/totk/index.html)). For this project, that makes “learnable but not solved” a production obligation: stable place plus carefully bounded changed circumstances.

### Variable expedition layer

An expedition seed may change only declared runtime dimensions:

- Weather and surface condition.
- Eligible closure or crossing state.
- Threat family, composition, pressure, and pacing.
- Salvage/resource socket selection.
- Objective variant and bonus condition.
- Optional signal, lure, or repair opportunity.
- Recent-history suppression and escalation state.

Variation must not move major landmarks, redraw the campaign road graph, invalidate a learned route without warning, spawn a lethal hazard inside reaction distance, or create an expedition with no navigable response. A closed edge must expose a forecast, visible clue, reroute, or player-solvable opening.

This follows the bounded author/runtime split in Valve's first-party description: author valid places and rules; let a deterministic director select and pace compatible content ([AI systems presentation](https://cdn.fastly.steamstatic.com/apps/valve/2009/ai_systems_of_l4d_mike_booth.pdf)).

### Persisted expedition manifest

Determinism must mean **same active expedition after reload**, not merely “the same seed usually regenerates similar content.” At departure, persist an immutable `ExpeditionManifest` containing:

- Content and world-graph version.
- Seed plus the namespaced `RewardLedger` and repetition-history snapshots used during generation.
- Contract/objective branch graph, closures, weather, encounter placements, pre-rolled Pressure branches, and reward rolls.
- Chassis/loadout snapshot, starting Fuel/Integrity, and valid extraction nodes.
- Finite salvage/reward budget.

Persist a separate mutable `ExpeditionProgress` checkpoint against that manifest rather than reconstructing it from current profile/world state. It owns position, Fuel/Integrity, Pressure, active encounter/branch and objective substate, consumed sockets, escrow, pending mutations, and the terminal `resolution_id` when allocated. The saved `ActiveExpeditionSnapshot` contains both objects.

Expedition and objective state are orthogonal:

```text
expedition: offered -> active -> extracted | wrecked | stranded | abandoned
objective:  not_started -> active -> field_complete | objective_failed
```

The player may extract, push, or change return intent while the expedition is active; `returning` is a UI/navigation intention, not a required lifecycle gate. `objective_failed` still permits return with other exposed haul. Fuel depletion enters a visible grace/recovery state before `stranded`; Integrity depletion resolves as `wrecked`. Abandon settles exposed value like failure. App quit or backgrounding resumes the latest atomic active checkpoint rather than abandoning or rerolling it.

Every terminal settlement receives an idempotent `resolution_id`; applying it twice cannot duplicate reward or mutation. Reload, fast travel, safehouse bounce, failure, or rollback never refreshes salvage, offers, rewards, closures, or encounters. Banking at a safehouse ends the expedition transaction; choosing to continue starts a new manifest from that safehouse while inheriting the namespaced `RewardLedger` plus repetition ledger.

Before committing a manifest, graph validation must prove at least one outbound/objective path and one extraction path under permanent topology, chosen closures, cargo constraints, selected loadout, and forecast Fuel. A condition may make a route costly, not unknowably impossible.

### Route information contract

Before departure, show:

- Known surfaces and route classes.
- Expected cargo or capability need.
- Forecast weather/region condition.
- Known closures and restoration state.
- Broad threat/pressure band.
- Fuel/time range and safe return points.

Do not show exact encounter order, exact loot, or a single “best build.” Ironwood presents condition preview followed by route-specific car adaptation in its *Pacific Drive* loop breakdown ([developer post](https://blog.playstation.com/2023/11/30/unravel-the-gameplay-loop-of-pacific-drive-launching-on-ps5-feb-22/)); Keep Driving should use that pattern to make its top-down route topology central.

### Route-choice test

A route choice counts only when at least two plausible options differ in one or more of:

- Expected time or Fuel.
- Surface/handling demand.
- Cargo stability or capacity.
- Threat exposure or escape space.
- Integrity/impact risk.
- Reward/discovery opportunity.
- Return safety or future network value.

Routine steering, a cosmetic fork, an already-solved GPS instruction, or a branch with one obviously dominant edge does not count. The current `[PLACEHOLDER: 30-45-second]` decision cadence remains a hypothesis to test, not a reason to manufacture filler.

For a typical 15-minute expedition, start with this explicit `[PLACEHOLDER]` composition instead of spawning a new event every 30–45 seconds: two to four route choices, one to three encounters, one optional detour, one objective beat, and one return decision. Surface, Fuel, cargo, threat, and handling interactions can supply the finer cadence.

### Pressure and fairness

Use a visible alert state—initially `[PLACEHOLDER]` levels 0–3—changed by disclosed noise, objective actions, and encounter escalation. Do not raise pressure merely because wall-clock time passed, the player used an assist, or the player has recently succeeded. A timer exists only when a selected cargo or mastery rule declares it before departure.

Every generated encounter must have a telegraph, a finite threat/reward budget, at least two baseline responses, a graph-safe fallback, and a repetition group/cooldown. Ordinary enemy kills do not pay Scrap; survival, objective resolution, discovery, and extraction do. This removes circling/spawn farming from the economy contract.

The manifest pre-rolls every compatible Pressure branch at offer creation. Runtime action-driven Pressure may select/escalate only inside that table, and `ExpeditionProgress` checkpoints the chosen branch; no runtime RNG, loadout counter-pick, or reward reweighting occurs. The selected loadout is used only for route/Fuel legality and forecast, and the same committed offer must remain identical while previewing different loadouts.

### Evidence gate

The hybrid proof region should demonstrate:

- At least two credible destination routes and one build-favored shortcut.
- Repeat players can navigate from landmark memory without following a line.
- Three seeds change a rational route or loadout decision while preserving orientation.
- No seed is unsolvable, silently unfair, or dependent on one random capability drop.
- Reload reproduces the same immutable manifest plus consumed sockets and pending outcomes from `ExpeditionProgress`.
- Recent-history suppression prevents obvious immediate repeats.
- A seed matrix reports surface mix, closure count, threat pressure, reward distribution, decision count, invalid combinations, and route concentration.

Apply expressive-range analysis to gameplay dimensions rather than celebrating seed count; the cited PCG paper specifically warns that variety, biases, and holes require measurement ([Smith and Whitehead](https://www.pcgworkshop.com/archive/smith2010analyzing.pdf)).

## 2. Direct Arcade-Real handling and terrain tradeoffs

### Feel contract

The player should feel an immediate, controllable car with:

- Credible mass and momentum.
- Progressive traction loss and recovery.
- Speed-sensitive steering.
- Legible braking and reverse.
- Useful but nonmandatory handbrake rotation.
- Surface-specific grip and rolling resistance.
- Collision impulse and damage tied to speed, mass, angle, and protection.
- Consistent behavior through keyboard, controller, touch, replay, and assists.

Criterion's first-party talk treats physical simulation, camera, and handling assists as complementary layers of vehicle feel ([GDC session](https://www.gdcvault.com/play/1025295/Vehicle-Feel-Masterclass-Balancing-Arcade)). The inference here is to keep one small, designer-tunable model and add authored shaping rather than use either unrestricted rigid-body simulation or a frictionless twin-stick mover.

### Terrain contract

Terrain changes continuous costs, not arbitrary permission flags:

| Route condition | Default advantage | Default cost | Useful build response |
|---|---|---|---|
| Dry asphalt | Speed, braking, Fuel efficiency | Exposure and constrained barrier response | Efficiency, grip, agile line choice |
| Dirt/service road | Alternate connections and escape space | Progressive slide, dust, mixed debris | Traction, clearance, recovery |
| Grass/rough ground | Direct shortcut or evasion | Drag, hidden impact, cargo disturbance | Suspension, clearance, durability |
| Mud/shallow water | High-value or weather-dependent access | Momentum loss, Fuel, recovery risk | Offroad grip, torque, winch/recovery |
| Narrow/damaged crossing | Network leverage | Collision and route-commitment risk | Agility, protection, scouting |

Specialization should improve efficiency, safety, or reward access; the primary campaign graph remains completable without one hidden mandatory build. *SnowRunner* is useful only as evidence that map knowledge, terrain, tools, cargo, and Fuel can form coupled tradeoffs ([producer guide](https://blog.playstation.com/2020/04/23/8-tips-to-master-the-machines-of-snowrunner-out-april-28/)); Keep Driving's timings and handling must be independently validated.

### Control floor and mastery ceiling

- New players can follow ordinary roads, brake, reverse, recover, and complete the first expedition without drifting.
- Skilled players gain time, Fuel, Integrity, and escape advantages from weight transfer, line choice, counter-steer, handbrake timing, and controlled ramming.
- Assists shape steering, braking, traction, acceleration, recovery, Fuel, damage, and threat barriers without replacing route choice.
- Camera, audio, particles, haptics, and body animation communicate physics but never conceal a hazard.

The official *art of rally* page presents beginner options and advanced driving techniques together ([official page](https://www.artofrally.com/)). That is a precedent, not proof that this implementation will achieve both; test with new and skilled players.

### Handling evidence gate

Use one repeatable benchmark suite across every chassis/build:

1. Launch, stop, and reverse.
2. Low/high-speed slalom and turn-in.
3. Controlled slide and recovery.
4. Asphalt/dirt/mud traversal and transition.
5. Light/medium/heavy impact at defined speed and angle.
6. Cargo mass/stability route.
7. Stuck recovery and barrier rejection.

Run it at the required simulation/render cadences and all input paths. Automated numbers bound regressions; five-player tests decide whether the car is readable, recoverable, and satisfying.

## 3. Sidegrade parts and build diversity

### Part contract

Every functional part needs:

- Stable identity, slot, compatibility, and source.
- At least one visible capability.
- At least one visible cost, constraint, or condition.
- Exact effects on handling, mass, Fuel, cargo, noise/threat, protection, recovery, or route forecast.
- A declared benchmark expectation and proof scene.
- A disclosed ownership, duplicate-conversion, and migration rule.

No primary rarity ladder, random-affix soup, hidden set bonus, or repeated `Part +1/+2/+3` progression. A part is valuable because it changes a route or driving decision, not because its color implies a larger number.

Use at most one part per compatible functional slot plus a visible chassis `Build Capacity` budget. Resolve configuration in one documented order:

```text
chassis base -> additive part deltas -> bounded multipliers -> global clamps
             -> semantic capability tags -> route forecast
```

Parts in the same stacking group declare the shared clamp. Capability tags such as `high_clearance`, `deep_mud`, `secured_cargo`, or `quiet_running` are derived facts, never hidden set bonuses. Chassis specialization ceilings prevent a flexible default chassis from reaching every specialist peak; the default wagon needs an explicit weakness rather than “no extreme strength.”

The *Wreckfest* developer/publisher description gives a clean example—armor buys protection with weight and handling cost ([store page](https://store.steampowered.com/app/228380/Wreckfest/)). Keep Driving should apply that honesty to every functional part, including scanner, cargo, light, recovery, traction, power, protection, and ram choices.

### Dominance rule

At the same chassis and Build Capacity budget, loadout A strictly dominates loadout B if A uses no more slots/capacity, is no worse in every relevant benchmark, and is better in at least one. A dominated part/loadout must gain a real situational advantage, consume less Build Capacity, or be removed. Unlock timing and one-time Scrap price never justify permanent dominance. Cosmetic and tutorial parts are labeled separately rather than used to fake functional breadth.

Each accepted build should occupy a useful frontier across road speed, offroad access, Fuel range, cargo, threat avoidance, impact tolerance, and recovery. The current five-archetype target and four-build fallback are scope hypotheses; the invariant is that at least the D020-locked floor changes route preference in blind tests. A drifter counts toward that floor only if it changes viable route choice; otherwise it is handling expression or a mastery overlay.

### Acquisition rule

- Milestones guarantee every capability needed for primary progression.
- Risky exploration may yield intact parts early, alternate parts, or blueprints.
- Blueprints enable exact, disclosed Scrap fabrication; no random roll is required to reproduce a known build.
- Own each named part once; only one car is active, so presets reference catalog IDs rather than requiring duplicate inventory.
- After extraction, an intact first find grants ownership, a blueprint permits first fabrication when the part is not already owned, and a later duplicate auto-converts at a fixed disclosed rate. Nothing grants ownership while still in expedition escrow.
- Garage/workshop swaps and undo are free.
- A new chassis arrives with one viable loadout.
- Balance updates preserve owned identity or provide an explicit equivalent/refund.

This makes random discovery exciting without letting random drops block the campaign.

### Build-diversity evidence gate

- Export every part and build to the same benchmark matrix.
- Reject strict dominance unless the cost/availability distinction is deliberate and visible.
- Blind players can predict at least one advantage and one drawback from the compare UI.
- The accepted build floor produces different route choices on the proof-region matrix.
- No single build wins every route, objective, and encounter benchmark.
- Every D020-locked build has a material strength and weakness in representative campaign content, not just in a synthetic stat.
- At least one hybrid is credible; archetype labels guide rather than impose classes.
- Swapping, testing, undoing, and saving a loadout stays under the accepted Garage time budget.

Begin prototype balance with these explicitly nonfinal `[PLACEHOLDER]` gates: each required build is top-two in at least two representative scenarios and bottom-half in at least one; no build is top-two across more than half the matrix; a favored build improves time or resources by roughly 15–25% but never supplies the only campaign path. Replace the numbers with measured thresholds before content lock.

## 4. Extraction risk without destructive persistence

### Four security states

| State | Examples | Resolution rule |
|---|---|---|
| Committed permanent | Restoration, blueprints, chassis, owned/installed parts, and milestones committed before departure | Never removed by expedition failure |
| Immediate observation | Seen road/landmark and lightweight route/lore knowledge | May commit when observed; never includes material, capability, payout, or world mutation |
| Expedition escrow | Loose Scrap, intact part/cargo, newly found blueprint/chassis, objective payout, and pending restoration mutation | Commits only when the expedition extracts; settles under failure rules otherwise |
| Active expedition progress | Fuel, Integrity, position, Pressure, active branch/objective state, consumed sockets, escrow, and pending mutations | Checkpointed beside the immutable manifest for resume; resolves at the terminal transaction |

The value of a run is not only its haul: observed route knowledge can remain meaningful progress, while previously committed restoration and ownership remain safe. Supergiant explicitly combines repeated failure with permanent progression and continuing discovery in *Hades* ([FAQ](https://www.supergiantgames.com/blog/hades-faq/)). That is precedent for durable forward motion, not evidence for this project's exact escrow or recovery rules.

### Failure contract

- Owned chassis and equipped/owned parts never drop or permanently break.
- Previously committed restoration, blueprints, and campaign milestones never roll back.
- Newly found parts, blueprints, chassis, objective payouts, and restoration mutations remain escrowed until extraction. Completing a safehouse restoration may itself be a declared extraction boundary.
- Extraction commits all eligible escrow exactly once.
- Ordinary failure retains no part or cargo. A secured compartment may preserve one eligible intact part, blueprint, or cargo item physically assigned before failure only if that compartment consumes an explicit cargo/utility slot plus declared `Build Capacity` and survives prototype validation. Chassis, payouts, and pending world mutations are ineligible; there is no free automatic “best item.”
- Failure may retain a tuned, capped fraction of loose Scrap.
- Results states exactly what was secured, lost, retained, and why.
- Active-run abandon settles like failure. App quit/background resumes the exact manifest; neither path can duplicate rewards, reroll an outcome, or corrupt the save.

The prior 25% plus free-item recovery is too exploitable to retain as a default. Begin with the explicit `[PLACEHOLDER]` hypothesis of 15–20% loose Scrap, capped at 0.25 times a starter-part cost, and no ordinary cargo/part retention. Tune from behavior: failure must create regret and make voluntary return rational, but not erase enough time to cause grind or avoidance of interesting risk.

### Push/return evidence gate

Across scripted three-run tests:

- Players correctly predict secured versus exposed value before committing.
- Push and return are both rational in different states.
- Intentional failure is inferior to voluntary extraction after time and expected value are included.
- A failed 15–25-minute expedition still leaves comprehensible forward motion.
- No campaign-critical capability is lost to one failure.
- At least 80% of test players predict exactly what commits and what remains exposed before choosing push or return.
- Backgrounding, forced close, and power loss resume the immutable manifest plus latest valid atomic `ExpeditionProgress` checkpoint. Recovery never rolls an active expedition back to a Garage/safehouse convenience boundary; if no active checkpoint survives corruption, all active escrow/pending mutations are discarded and the loss is disclosed.

## 5. One-currency, anti-grind economy

### Currency model

**Scrap is the only spendable currency.** Fuel and Vehicle Integrity are expedition resources. Parts, blueprints, landmarks, discoveries, medals, and restoration milestones are owned content or achievements, not currencies.

The one-currency decision is a product inference for clarity and scope. The cited literature does not prove that one currency is universally better. Its risk is concentration: one dominant farm, price mistake, or surplus can distort the entire economy.

### Sources and sinks

| Scrap source | Rule |
|---|---|
| Extracted loose salvage | Reward route risk and carrying it home |
| Objective payout | Preview exact base and bonus conditions |
| Duplicate auto-conversion | Disclose the fixed return before departure/claim; no physical copy or confirmation trap |
| Optional mastery award | Use sparingly; capability/place is the primary reward |

| Scrap sink | Rule |
|---|---|
| Fabricate a known part | Exact item and price; no random outcome |
| Optional visible safehouse service | Must change a useful service; mandatory route restoration is objective-driven |
| Optional cosmetic fabrication | Never competes with a required early capability |
| Expedition preparation | Include only if it creates a real choice; never a recurring admission tax |

No repair timers, premium currency, paid skip, loot keys, random shop rerolls, durability tax on owned parts, or purchased inventory relief.

### Anti-grind rules

- Primary progression is gated by authored restoration and capability milestones, not a Scrap total alone.
- Required restoration completes through objectives and never charges Scrap.
- Every departure starts with the full baseline Fuel and Integrity allowance; bankruptcy cannot block play. A preparation purchase may add an optional advantage, never restore basic play access.
- Guarantee the first successful return's part choice from two mutually useful options and key capability blueprints through milestones.
- Never require the same solved low-risk template to repeat for campaign access.
- Reward first completion, new risk, discovery, harder conditions, and efficient play more than immediate repetition. Every repeat payout is fixed and disclosed before departure; do not use an opaque diminishing-return curve.
- Persist one namespaced `RewardLedger` (eligibility, claims, cooldowns) plus repetition history outside the active manifest. Reload, offer cancellation, loadout changes, safehouse Continue/entry, fast travel, failure, and abandon do not refresh or reroll offers, salvage, claimed sockets, or the manifest's finite reward budget.
- Every required capability has at least two viable acquisition paths.
- The ending does not require all parts, medals, discoveries, or mastery content.
- Free loadout changes and undo prevent experimentation from becoming a currency sink.

Zagal, Björk, and Lewis identify repeated tedious work used chiefly to consume time as a dark form of grinding ([original paper](https://ri.diva-portal.org/smash/get/diva2%3A1043332/FULLTEXT01.pdf)). The product gate here is therefore not “does the game contain repetition?” but “does mandatory repetition produce a new decision, skill test, or world result?”

### Economy evidence gate

- Simulate pessimistic, median, skilled, explorer, repeat-farm, high-failure, fail-fast, circling, safehouse-bounce, reload, and alternating-low-risk profiles from first session through ending.
- Record time to first choice, key capabilities, region gates, ending, and optional completion.
- Record Scrap earned/spent, idle surplus, blocked purchases, repeat count, failure recovery, and best Scrap-per-minute route.
- No mandatory grind wall, dead sink, dominant farm, unaffordable recovery spiral, or meaningless late surplus.
- No zero-Scrap or failure-heavy profile is locked out of required restoration, baseline service, or the ending.
- A fail-fast/farm strategy remains below the accepted fraction of cautious objective-play value per active minute; begin testing at the nonfinal `[PLACEHOLDER]` threshold of 70%.
- Full human playtests complete the campaign without replaying a solved activity solely for Scrap.
- Economy changes rerun failure/extraction, build access, campaign duration, and fallback-scope tests.

## 6. Sustainable activities and encounters

### Activity grammar

Lock three route-centered families:

1. **Delivery** — a known outbound burden changes the planned build and route; timing is an occasional declared modifier, not the family identity.
2. **Recovery** — the burden is acquired at the destination, changing return physics, capacity, and route after the player has already committed outward.
3. **Restoration** — a one-time authored objective permanently changes topology, a service, return safety, or information when its expedition commits.

**Mastery is an overlay**, not a fourth family: a fixed, optional Fuel, damage, cargo, time, drift, chassis, or assist rule can wrap a validated route/activity without pretending to be a new state machine. Dynamic road encounters are reusable complications, not additional menu families.

Do not imply physical towing. A winch is self-recovery only. A disabled vehicle or generator resolves as an authored site interaction or abstract cargo outcome unless a towing model receives its own prototype, handling evidence, and D020 cost.

### Module contract

Every authored activity instance declares:

- Family and player-facing purpose.
- Start, target, return, and eligible route sockets.
- Required and forbidden region/world states.
- Cargo or objective property.
- Compatible weather, threat, and encounter tags.
- Base/bonus reward and security timing.
- Permanent world mutation, if any.
- Failure, abort, resume, and repetition behavior.
- Estimated and measured authoring/QA/localization/art/audio cost.

Define and validate these production templates:

- `ContractDefinition`: family/decision grammar, cargo phase, state machine, supported condition axes, terminal/resume/escrow rules, and compatibility schema.
- `ContractInstance`: definition ID, campaign role, origin/target/return nodes, concrete cargo/conditions, first-clear/repeat reward, proof IDs, and measured marginal cost.
- `RestorationObjectiveDefinition`: one-time site/nodes, pending county/service/topology mutation, extraction boundary, all outcomes/resume rules, proof IDs, and unique-work cost.
- `EncounterDefinition`: decision, socket/eligibility, telegraph, threat budget, baseline/build-specific responses, graph fallback, persistence, cooldown/repetition group, and no-kill reward rule.
- `PartDefinition`: compatible slot, `Build Capacity` cost, capability, benefit, real burden, stacking group/clamp, source, ownership/duplicate rule, and scenario expectations.
- `LandmarkPackage`: route relationship, silhouette/navigation role, sockets, state change, discovery, accessibility cues, and asset/audio/localization/performance budget.

A bespoke mechanic must recur in at least `[PLACEHOLDER: three]` objectives or be costed as D020 unique work. Cosmetic reskins and modifier swaps never count as new production templates.

The director selects only compatible authored combinations. Valve's Director used designer-authored valid item locations with bounded runtime selection, explicitly avoiding both pure random placement and fixed uniformity ([presentation](https://cdn.fastly.steamstatic.com/apps/valve/2009/ai_systems_of_l4d_mike_booth.pdf)). This project should adopt the contract boundary, not the combat pacing curve.

### Variation axes

- Route pair and return point.
- Surface/weather/closure state.
- Cargo mass, fragility, noise, securing, or width.
- Optional bonus and push opportunity.
- Encounter set and pressure curve.
- Chassis/build affinity.
- World-state consequence.

A combination is not new content if it changes only names, reward amount, prop color, or travel distance. It counts toward variety only when blind players change route, build, driving, risk, or recovery behavior.

Subset's Advanced Edition enumerates content on separate axes—squads, weapons, enemies, bosses, objectives, pilots, and abilities ([official page](https://subsetgames.com/itb_ae.html)). That supports making the axes explicit; it does not prove that multiplication alone produces quality.

### Production-sustainability gate

For the Lowlands tranche, record person-hours and rework by discipline for:

- One landmark cluster.
- One safehouse state change.
- Three production `ContractInstance`s spanning at least two `ContractDefinition`s, including at least one decision-changing variant; the separately listed safehouse state change/Restoration Objective remains its own axis.
- Five encounter/event instances spanning declared templates, including at least one decision-changing variant.
- Twelve production-quality parts.

Then measure:

- Unique decisions per expedition, not theoretical permutations.
- Template/beat repeats before ending.
- Invalid or unfair combinations across the seed matrix.
- Authoring, integration, QA, localization, art, audio, and defect cost per accepted variant.
- Base-definition/template cost and marginal variant cost reported separately; D020 never extrapolates original-definition counts from the cheapest variant.
- Package, memory, streaming, and performance cost.
- Player naming and differentiation of retained families.
- A second author can create a validated data-only variant without runtime code inside the D020 time/rework budget.

Do not extrapolate from the fastest variant or count filler as throughput. D020 uses the repeatable tranche, explicit unique-work estimates, mandatory baseline, and risk reserve before multiplying launch counts.

## 7. Difficulty and accessibility

### Difficulty model

Ship descriptive presets for discovery plus a Custom configuration. The exact count and names need user testing; Microsoft currently recommends a broad range, ideally four or more, and the ability to change at any time without losing progress ([XAG 108](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/108)).

Independent dimensions should include:

- Incoming collision/threat damage.
- Fuel consumption and resource generosity.
- Threat density/aggression and a disclosed non-increasing modifier to action-triggered Pressure gain.
- Objective timing windows.
- Steering/brake/traction/recenter assistance.
- Auto-accelerate and reduced-input options.
- Recovery generosity and failure retention, with exact disclosure.
- Route/objective hint strength.

Presets are labels over these values, not separate content modes. Players may alter them during the campaign without losing save progress or access to the ending. Only an explicitly fixed-rule mastery trial may require a declared configuration.

### Accessibility is broader than difficulty

Required independent settings and evidence include:

- Remapping, sensitivity, dead zones, hold/toggle alternatives, left-handed touch, adjustable touch controls, and controller navigation.
- Text size, contrast, icon/shape redundancy, color customization where needed, and phone-scale hazard recognition.
- Visual equivalents for gameplay-critical audio and audio/haptic equivalents where feasible.
- Subtitle/caption controls and clear speaker/direction treatment where applicable.
- Camera shake, motion, blur, flashes, particles, and haptic intensity controls.
- Pause during all active single-player play and safe interruption/resume.
- No essential multipoint gesture and an alternative to every core gesture.
- VoiceOver, Voice Control, Switch Control, and Full Keyboard Access evaluated flow by flow; claim support only where [Apple's applicable App Store criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels) actually pass.
- First-launch access to high-value settings, then full settings at any time.

Apple's HIG says information should not depend on one sensory channel, gestures need alternatives, games should consider reaction-time/control accommodations, and interfaces should adapt to system accessibility preferences ([accessibility guidance](https://developer.apple.com/design/human-interface-guidelines/accessibility/)). These are design/test requirements; declaring an App Store accessibility label later does not prove them.

### Adaptive help boundary

Do not secretly rubber-band handling, rewards, or encounter outcomes from player success. Assistance is player-selected and visible. A gentle opt-in assist may improve after repeated failure, as Supergiant documents for *Hades* God Mode ([FAQ](https://www.supergiantgames.com/blog/hades-faq/)), but Keep Driving should never silently enable it or shame the player.

### Accessibility evidence gate

- Test with players who use the relevant access needs, not only the development team.
- Run every campaign-critical route, objective, Garage action, and result/save flow under each supported input/accessibility combination.
- Verify the same ending and permanent progression remain available.
- Verify assists do not introduce route skips, save exploits, impossible states, or UI lies.
- Record unsupported assistive-technology flows honestly instead of treating partial menu access as whole-game support.
- Audit smallest supported phone, bright/noisy environments, no-audio play, reduced motion, color-vision variants, touch-only, controller-only, and interrupted sessions.

## 8. Rewards, replay, and endgame

### Reward hierarchy

Prefer rewards in this order:

1. **Place power:** safehouse, crossing, route, shortcut, map knowledge, return safety.
2. **Capability:** chassis, named part, blueprint, workshop access.
3. **Choice:** new objective, alternate route condition, mastery rule.
4. **Expression:** paint, trophy, run card, photo/replay support if funded.
5. **Flexible value:** Scrap.

The first four create memories and options. Scrap fills gaps; it must not become the reason every activity exists.

### Completed-county replay layers

1. Finish missed landmarks, shortcuts, restorations, and blueprints.
2. Solve known routes with materially different builds.
3. Pursue optional mastery rules and medals.
4. Repeat selected routes/contracts under different per-departure conditions.
5. Start a full campaign again only through an explicit new profile/reset flow; the persistent county never silently resets and a second campaign is not required endgame content.
6. If D020 retains it, enter post-completion Expedition Mode.

Supergiant documents varied attempts, durable progression, assistance, and a late-game modifier system in *Hades* ([FAQ](https://www.supergiantgames.com/blog/hades-faq/)). Subset presents *Into the Breach* attempts as generated challenges with different tools ([official page](https://subsetgames.com/itb.html)). Neither source proves the required amount of content or the value of an endless mode here.

### Expedition Mode boundary

If retained by D020:

- Unlock only after the complete campaign ending.
- Reuse validated route, vehicle, encounter, economy, accessibility, and save systems.
- Retain the authored county graph; remix only declared conditions, closures, objectives, encounters, and rewards.
- Use local deterministic seeds shareable as text without an account.
- Score route risk, secured salvage, damage/Fuel efficiency, encounter resolution, and declared build rule—not distance alone.
- Grant expression and mastery records, not campaign-critical power.
- Never require a daily login, network connection, exclusive rotating reward, or profile reset.
- Preserve a locally replayable fallback for any featured seed.

If it does not fit capacity, remove it first. Completed-county play, alternate builds, unfinished discoveries, records, and mastery remain the coherent endgame.

### Replay evidence gate

- Players voluntarily choose different routes/builds after the ending instead of repeating the best Scrap farm.
- Seeds change decisions, not just prop placement.
- Mastery rules test settled verbs and publish all restrictions.
- No exclusive reward pressures a schedule or network connection.
- Expedition, if retained, adds demonstrated value after primary completion and is not required to justify an incomplete campaign.
- Full-campaign tests find a satisfying stopping point before completionist or endless play.
- At least four of five post-completion testers identify and voluntarily begin a non-Scrap next goal.

## Initial tuning hypotheses

These numbers are `[PLACEHOLDER]` prototype starting points, not launch locks or source facts:

| Variable | Initial hypothesis |
|---|---|
| Failure Scrap retention | 15–20%, capped at 0.25 times starter-part cost; no ordinary item retention |
| Standard success payout | 0.4–0.6 starter-part-cost units per expedition |
| Declared high-risk payout | 0.7–1.0 starter-part-cost units per expedition |
| Fail-fast/farm ceiling | Below 70% of cautious objective-play value per active minute |
| Hazard telegraph | At least 1.5 seconds time-to-collision at current speed |
| Untelegraphed event damage | Never above 25% of full Integrity |
| High-intensity overlap | One maximum, followed by 20–30 seconds of recovery opportunity |
| Prepared contract success | Tutorial at least 90%; standard 70–85%; declared high-risk 40–60% |
| Favored build advantage | 15–25% time/resource benefit without mandatory access |
| Clean-drive forecast | Fuel/time estimate within ±15% |

Replace every threshold from measured handling, economy, accessibility, and campaign data. A placeholder cannot become a launch requirement merely because it appears in this document.

## Cross-system failure modes

| Failure | Detection | Required response |
|---|---|---|
| Familiar world becomes solved | Route concentration and repeat-player tests | Improve meaningful condition/build interactions before adding map size |
| Randomness erases knowledge | Players cannot predict or explain outcomes | Stabilize topology; expose forecast and authored rules |
| Reload rerolls an expedition | Manifest/fault-injection comparison | Persist all rolled content and consumed/pending state; idempotent settlement |
| One build dominates | Benchmark matrix and route-choice tests | Add real tradeoff/lower cost or remove dominated content |
| Failure/abandon becomes optimal | Expected-value-per-minute and exploit tests | Escrow new value; remove free item retention and refresh paths |
| Failure destroys attachment | Churn/avoidance after loss; player interviews | Protect owned build and permanent progress; retune unsecured loss |
| Scrap creates a grind wall | Full-progression simulation and human campaign | Guarantee capability/milestone path; rebalance sources/sinks |
| Modular content feels cloned | Blind family naming and repetition review | Remove cosmetic variants; strengthen decision-changing axes |
| Slow/assisted play raises hidden pressure | Timing/accessibility matrix | Drive alert from disclosed actions, not elapsed wall time or success |
| Variant count inflates scope | Production-unit audit | Count final-pipeline state machines and decision grammars separately from parameter swaps |
| Difficulty hides accessibility barriers | Access-needs tests by mechanic/input | Add independent assists and presentation alternatives |
| Endgame cannibalizes campaign | Scope ledger or tests require it to justify value | Cut Expedition; finish campaign and mastery first |

## Decision summary

**Keep:** authored county macrograph; deterministic manifested population; direct Arcade-Real handling; continuous terrain costs; stable named sidegrades; voluntary extraction; protected previously committed progression; Scrap-only spending; three route-centered families plus mastery overlay; descriptive difficulty plus granular assists; finite ending.

**Sharpen:** persist the complete immutable manifest plus mutable progress checkpoint; escrow newly earned capability/material/world mutations; settle once by `resolution_id`; formalize stacking and build-distribution tests; make anti-grind gates measurable; count unique decisions rather than permutations; treat accessibility as a cross-system acceptance gate.

**Prototype before lock:** exact failure-retention percentage; route-decision composition; number of presets; part/chassis counts; economy prices and fixed repeat payouts; encounter pressure/telegraphs; campaign duration; Expedition Mode value and cost.

**Reject:** disposable random campaign maps; seed-only regeneration of active expeditions; invisible binary terrain locks; drift as mandatory basic locomotion; rarity inflation; hidden set bonuses; duplicate inventory for one active car; permanent loss of the owned car/build; auto-banked new blueprints/restoration on failure; paid or premium currency; random fabrication; Scrap-gated required restoration; repeat-to-progress objectives; generic checklist mission breadth; hidden rubber-banding; assistance penalties on the campaign ending; daily/streak endgame obligations; “number of seeds” as proof of variety.

## Downstream evidence required before production, content, or endgame lock

- Handling benchmark and five-player report showing approachable control plus mastery.
- Ten-thousand-seed manifest/graph-feasibility report across contracts, locked builds, and conditions; reload preserves each immutable manifest plus every authoritative `ExpeditionProgress` field from the latest atomic checkpoint.
- Hybrid proof-region expressive-range matrix and repeat-player route-memory report.
- Exhaustive compatible-loadout Pareto/dominance report plus four route-changing human-validated builds at the D020 floor.
- Three-run push/return/failure study with at least 80% exact security comprehension.
- Economy Monte Carlo covering cautious, risky, fail-fast, circling, safehouse-bounce, reload, failure-heavy, and alternating-low-risk strategies; no RNG/Scrap soft-lock.
- Pairwise cargo × weather × encounter × route × chassis compatibility and progression-dependency simulation.
- Fault injection at every expedition/objective transition: same immutable manifest plus position, Fuel, Integrity, Pressure branch, objective/encounter state, consumed sockets, escrow, and pending mutations after reload; every `resolution_id` commits exactly once.
- Lowlands activity/encounter expressive-range and measured production-cost report; eight of ten players distinguish delivery, recovery, and restoration by decision rather than fiction.
- Difficulty/accessibility matrix covering the campaign-critical loop on required inputs.
- Full-campaign repetition, grind, stopping-point, and ending report before any endgame claim.
- D020 capacity verdict before raw content multiplication or Expedition commitment.
