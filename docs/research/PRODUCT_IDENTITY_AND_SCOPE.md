# Product Identity and Launch Scope Research

Status: resolved recommendation for Wayfinder ticket 02
Research date: 2026-07-11
Public name: unresolved; `Keep Driving` is an internal working title only

## Question

What single-player fantasy, audience, design pillars, world promise, session loops, player journey, business model, and launch boundary produce the strongest realistic 1.0?

## Resolved recommendation

Build a **premium, offline-first, single-player, top-down survival-driving roguelite where every road is a build decision**.

The player restores a battered car and a broken county from a Garage, learns an authored road network, adapts the car to different surfaces and threats, takes route-centered expeditions, and decides whether to push for a better haul or bring the current haul home. The campaign is a finite restoration journey; deterministic conditions make repeated travel tactically different; if retained by D020, a post-campaign Expedition Mode preserves the prototype's endless-survival appeal.

The title-independent promise is:

> Build the car. Read the county. Take the risk. Bring it home.

This position is stronger than a generic “road-trip survival game” because it makes four concrete distinctions: real-time top-down driving mastery, roads that remain optional rather than rails, a county the player learns rather than a disposable sequence of maps, and extraction risk expressed through the car rather than an on-foot party or inventory RPG.

## What the primary sources establish

These are source facts, not claims that a particular feature will make this project commercially successful.

| Primary source | Confirmed fact | Product inference |
|---|---|---|
| [YCJY official page](https://www.whycjwhy.com/keepdriving/index.html) and [Steam product page](https://store.steampowered.com/app/2756920/Keep_Driving/) | A released game already uses the exact title **Keep Driving**. It is presented as a road-trip management RPG about mapping a route, customizing and repairing a car, and resolving challenges in a procedurally generated world. Steam says its endings take roughly 1-4 hours and carries YCJY's trademark assertion. | The current name cannot safely identify this product. The overlap is broader than spelling: road trip, route choice, car customization, and procedural variation are already in the other product's public promise. Rename is the practical default; the exact-title exception requires both qualified written legal clearance and documented positioning/search-confusion approval. |
| [Pacific Drive official site](https://www.pacificdrivegame.com/) | Pacific Drive presents a first-person driving-survival loop built around a car companion, Garage-based excursions, gathering resources, maintaining/upgrading the car, and returning safely from changing hazards. | “Car + Garage + hostile excursions + upgrades” is established adjacent territory, not sufficient differentiation. This project must lead with top-down physical handling, open route choice, a learnable county, and safehouse restoration. |
| [Overland official site](https://overland-game.com/) | Overland presents a post-apocalyptic, turn-based road trip with fuel, creatures, hard choices, a traveling party, items, and randomly generated levels and roadmaps. | Avoid party management, on-foot tactics, item soup, and disposable random maps. Keep the player embodied in the car and make driving the resolution system. |
| [art of rally official site](https://www.artofrally.com/) | art of rally presents stylized rally driving with beginner-friendly options and expert driving techniques. | A stylized presentation can support both accessibility and handling mastery; “mobile-friendly” must not mean flattening the driving model. |
| [art of rally App Store listing](https://apps.apple.com/us/app/art-of-rally/id6459581344) | As checked on 2026-07-11, the iOS listing is paid, controller-supported, A12-or-later, top-down, declares Data Not Collected, and offers one paid content expansion. Apple identifies privacy labels as developer-provided and unverified. | This is a useful iOS precedent for premium top-down driving, controller support, a bounded device floor, a developer-declared privacy-minimal model, and later paid expansion. It does not prove demand, price, rating, scope, or technical feasibility for this project. |
| [Apple business-model guidance](https://developer.apple.com/app-store/business-models/) | Apple defines the paid model as one upfront payment for all functionality with no additional charges or IAP, and says successful paid apps are often positioned as premium experiences through outstanding design, functionality, and marketing. | A one-time premium purchase fits the intended complete, offline experience; it also raises the quality and value bar. |
| [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) | Apple requires accurate metadata, a unique app name, adequate lasting value, data minimization, and access without login when significant account features do not exist. It also prohibits copycat representations and unauthorized use of another developer's product name. | Distinctive name clearance, a complete campaign, honest captures, no forced account, and minimal SDK/data surface are product requirements, not launch polish. |
| [Apple lifecycle guidance](https://developer.apple.com/documentation/uikit/preparing-your-ui-to-run-in-the-background) | Apple tells games to pause, save user data, stop major work, and prepare for suspension on background transition. | Sessions may be 15-25 minutes, but every expedition must tolerate interruption and resume from a trustworthy boundary. “Mobile session” is a reliability contract, not merely shorter content. |

No cited source establishes a required number of regions, landmarks, parts, objectives, hours, or price. Those are product hypotheses and must earn commitment through playtests and measured content throughput.

## Product identity

### Single-player fantasy

> I turn a wreck into my machine, learn a dangerous county, choose the road my build can survive, take one more calculated risk, and bring the car and haul home.

The emotional cadence is anticipation, flow, pressure, improvisation, relief, and curiosity. The car is simultaneously avatar, equipment, health, cargo capacity, and expression. There is no separate on-foot power fantasy.

### Audience

**Primary:** players who enjoy systemic survival decisions, roguelite risk, route planning, buildcraft, exploration, and accessible arcade driving; players who want a complete premium game that works offline and supports 15-25 minute sessions that can chain into a longer evening.

**Secondary:** top-down driving players who value handling mastery but do not need licensed motorsport, and mobile players seeking a console-like single-player experience with touch and controller support.

**Not the target:** simulation purists, lap-racing competitors, idle/F2P progression players, party-management road-trip RPG players, on-foot open-world players, and multiplayer-first players.

This audience definition is an inference from the intended mechanics and the adjacent products above. It is not a measured market segment. Validate the promise and store-page language with players who have not seen the prototype.

### Design pillars

1. **Road choice is the game.** Every useful stretch reveals or rewards a decision: fast road, safer detour, offroad cut, optional signal, confrontation, or return. A feature that does not improve a route decision needs a strong reason to exist.
2. **The car is the character.** Chassis and parts change handling, route access, cargo, noise, impact, endurance, or recovery. An upgrade that only lengthens a stat bar fails the pillar.
3. **The return makes risk meaningful.** Carried value remains exposed until secured. Continue, divert, extract, and fail must produce legible, materially different outcomes without deleting all long-term progress.
4. **Readable physical mastery.** Surface, mass, drift, collision, damage, threats, and objectives must read at speed on the smallest supported phone. Assists widen access without erasing momentum or consequence.
5. **Crafted place, systemic trips.** The player learns authored regions, landmarks, roads, shortcuts, and safehouses while seeded weather, closures, threats, and rewards change the tactical problem. Neither pure random infinity nor one-use authored content satisfies the promise.

## World promise

The current provisional target is one connected county with three mechanically distinct region identities, recognizable landmarks, multiple routes between major destinations, build-conditional shortcuts, and safehouses whose restoration changes the usable network. Phase 3 must lock or rebaseline the count from measured capacity; regional contrast itself remains required. Roads are advantages, never invisible rails; the player may leave them wherever terrain permits.

The county feels reactive through weather, closures, migrating threat pressure, safehouse state changes, ambient wildlife, distant signals, and changed roadside evidence. Do not build generalized civilian traffic, a persistent population simulation, or on-foot NPC interaction for 1.0. Those systems add AI, collision, content, and mobile-performance cost without strengthening the route/build/return decision.

The world promise is **learnable but not solved**: repeated travel strengthens spatial knowledge while deterministic conditions keep the best choice contextual.

## Session loops and player journey

The durations below are testable targets, not market facts.

| Horizon | Promised loop | Required clean boundary |
|---|---|---|
| 10-30 seconds | Read surface/fork/threat/reward -> choose -> commit through driving -> feel outcome -> reassess | Pause immediately; no hidden input or damage while interrupted |
| 15-25 minutes | Pick objective/loadout -> make several route decisions -> complete, detour, or push -> extract/fail -> make one meaningful Garage decision | Autosave at departure, secured return, outcome, and safe active-expedition checkpoints |
| 45-75 minutes | Chain two or three expeditions -> discover a landmark/shortcut -> specialize or revise a build -> advance restoration | Finish at Garage/safehouse with no cleanup obligation |
| Provisional 8-12 active hours | Learn all region rules -> unlock chassis/build options -> restore the primary county network -> complete a final expedition testing route, build, driving, and risk judgment | D020 locks/rebaselines the range; complete ending with no mandatory random grind |
| Provisional 20-30 active hours | World completion, alternate builds, mastery goals, and seeded Expedition Mode if retained | D020 locks/rebaselines the range; respectful stopping points and no daily streak or absence penalty |

Player journey:

1. **First minute:** start in the Garage lot, move within ten seconds, read the immediate destination and basic Fuel/Integrity state, then see a road fork or reward signal.
2. **First expedition:** learn surface and collision through play, take one optional risk, reach the first safehouse, and understand that returning secures the haul.
3. **First specialization:** choose between mutually useful parts; learn that a scout, rammer, offroad build, and hauler prefer different routes.
4. **County opening:** restore safehouses, discover landmarks and shortcuts, encounter new regional constraints, and—under the current provisional target—acquire a second chassis.
5. **Mastery:** use route knowledge and a prepared build to solve late-region pressure rather than out-leveling it.
6. **Primary completion:** restore the county network and finish a route that combines the game's settled verbs.
7. **Ongoing play:** unfinished discoveries, alternate builds, mastery trials, and—if retained by D020—seeded Expedition Mode remain; no profile reset is required.

## Ethical business model

Launch as a **one-time paid app containing the complete 1.0 game**.

- No ads, consumable currency, loot boxes, energy, battle pass, subscription, pay-to-win part, paid revive, forced account, mandatory network connection, or gameplay-critical daily obligation.
- No launch IAP. This keeps the value promise and App Review surface simple while the new product establishes trust.
- No advertising, cross-app tracking, or third-party analytics SDK at launch. Optional crash diagnostics require a specific support benefit, disclosure, privacy review, retention rule, and consent path where applicable.
- Final regional price is unresolved. Decide it near launch from current same-platform market research, tested value communication, production quality, and total content—not from one comparator's mutable price.
- A later, substantial region/story expansion may be sold as a clearly bounded non-consumable purchase only after 1.0 is complete and stable. Never carve a required ending, promised chassis, or launch system out of the paid base game.

## Launch-scope boundary

### Required for 1.0.0

- A distinctive, qualified-cleared public name and title-independent visual identity.
- One complete offline single-player restoration campaign with a real ending; post-campaign Expedition Mode is the provisional target and first Required cut if D020 cannot fund it.
- Production Arcade-Real handling, road/offroad surface behavior, ramming/collision, recovery, camera, audio, VFX, and haptics.
- One connected county with the D020-locked regional target (currently three identities), meaningful route alternatives, landmarks, safehouses, build-conditional shortcuts, weather, and deterministic encounter variation.
- Route-centered objectives, voluntary extraction, Fuel, Vehicle Integrity, unsecured haul, Scrap, Garage loadouts, sidegrade parts, and multiple viable chassis/build archetypes.
- Complete first-launch, Garage, map, expedition, pause, results, settings, accessibility, save/error, ending, and resume flows.
- Keyboard/controller desktop reference plus responsive iPhone-landscape touch/controller support; lifecycle, offline, performance, memory, thermal, battery, save, update, and App Store evidence on supported devices.
- Premium one-time purchase with no launch IAP, ads, account, tracking, or mandatory backend.
- Localization-ready English, accurate store assets/metadata, privacy/legal/support readiness, and zero open release-blocking defects.

The current planning targets—three regions, 15 landmarks, six safehouses, 24 objectives, 15 encounter templates, three chassis, six part slots, 36 parts, an 8-12-hour primary arc, and 20-30 hours of completion/mastery—form a coherent **production target**, not source-proven minimums. Phase 3 must apply the dated, discipline-by-discipline capacity formula, unique-work estimates, 30% risk reserve, cut ladder, and coherent fallback in `PRODUCT_VISION.md`; revising counts or duration openly is preferable to filler or compromised reliability.

### Valuable if capacity allows

- Additional chassis and sidegrade parts beyond the D020-locked Required target after required build diversity passes.
- Photo mode, replay/run card, cosmetics, extra mastery trials, and more encounter variants.
- Game Center achievements or optional cloud save after local saves, privacy, entitlement, and service behavior pass separately.
- Alternate touch schemes such as tilt steering.
- Native iPad layout and additional launch localizations only with full UI, device, store-asset, and QA capacity.

Nothing enters this bucket merely because implementation has started. A Valuable feature is cut if it threatens a Required acceptance gate or candidate freeze.

### Post-1.0 expansion

- New county region, restoration arc, landmarks, safehouses, activity modules, weather, chassis, and parts.
- A substantial paid narrative/content expansion that does not invalidate base saves or builds.
- Larger Expedition rule sets, asynchronous ghosts, and competitive services after privacy and operating-cost review.
- Co-op/multiplayer only as a separately funded architecture and production effort.
- Mod support only after platform, security, save, and content-pipeline feasibility is demonstrated.

### Explicitly out of scope

- On-foot mode, party management, dialogue-heavy RPG, shooter inventory, base building, crafting-resource soup, licensed cars, realistic repair simulation, generalized traffic, persistent population simulation, pure procedural infinity as the campaign, real-time multiplayer, mandatory backend, and live-service retention mechanics.

## Identity and name gate

Research may continue under the working title, but public identity work must assume a rename. Before the Phase-2 signed iOS feasibility build—or any production App Store record, production bundle ID, logo/icon, public URL, marketing campaign, or final branded art—one of these routes must pass:

1. **Exact-title exception:** qualified counsel supplies written clearance for `Keep Driving` and the intended territories/services, including every required condition, and a documented positioning/search-confusion review affirmatively passes the exact title; or
2. **Rename route:** a distinctive replacement title receives equivalent written clearance and passes documented pronunciation, recall, storefront/search ambiguity, competitor-confusion, and promise-fit review.

Apple independently asks developers to use distinctive names, prohibits unauthorized third-party product names, and warns against copycat representation ([product-page guidance](https://developer.apple.com/app-store/product-page/), [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)). Store availability, a subtitle, punctuation, or a different logo cannot substitute for legal clearance.

This research records product and platform risk; it is not a legal conclusion about ownership, registration, infringement, or likelihood of confusion.

## Validation still required

- Five new players can state the fantasy, immediate goal, and push/return choice after the first-minute slice.
- Players interested in both systemic survival and accessible driving prefer the resolved promise over generic road-trip, racing, or zombie-combat alternatives.
- At least three builds produce different route choices without a dominant option.
- The production slice demonstrates the planned decision density and supplies measured content-authoring time; only then lock raw launch counts.
- Current App Store pricing and comparable-product research is repeated shortly before price lock.
- The selected public name is tested for distinctiveness, pronunciation, recall, search ambiguity, competitor confusion, and fit with the final experience; these tests supplement rather than replace counsel and are mandatory even for the exact-title exception.

## Decision summary

**Keep:** premium/offline single-player, top-down Arcade-Real driving, authored county plus systemic conditions, car-as-character, extraction risk, safehouse restoration, and a bounded campaign. Expedition endgame remains the provisional target until scope lock.

**Sharpen:** lead with “every road is a build decision”; make route knowledge and real-time handling the differentiation; treat interruption-safe sessions and privacy as product features.

**Defer:** raw content-count lock until vertical-slice throughput, exact price until launch research, and all Valuable features until Required gates pass.

**Reject:** exact-title launch without both qualified written legal clearance and documented positioning/search-confusion approval, “Pacific Drive but top-down,” on-foot/party systems, generic open-world checklist content, filler used to hit counts, multiplayer, and live-service monetization.
