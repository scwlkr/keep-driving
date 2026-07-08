# Define Core Loop And Feel Target

Type: grilling
Status: resolved
Blocked by:

## Question

What exact player fantasy, moment-to-moment loop, camera feel, danger level, and "impressive enough" bar should Playable v0 optimize for?

This ticket should resolve the minimum fun target before implementation: what the player does every 10 seconds, every minute, and every run; what makes roads/paths valuable; how survival pressure works; and what proves the game is not a disposable toy demo.

## Answer

Playable v0 should optimize for a **Road Warrior Survival Expedition** fantasy: the player drives a beat-up car through an endless hostile Free-Roaming World, trying to push farther from the origin each run while surviving fuel pressure, vehicle damage, and escalating pursuit.

The moment-to-moment loop is route planning and forceful driving, not a lane-runner choice. The player scans an open Route Network, chooses among roads, dirt paths, offroad traces, grass, and rough terrain, reacts to Traversal Barriers such as water, dodges or smashes hazards, collects fuel/scrap when the risk is worth it, and keeps moving. Roads and paths should usually be faster or smoother, but the world must offer multiple viable routes and detours rather than one road/offroad binary.

Water belongs in v0 as a Traversal Barrier. The player routes around it or finds generated bridges/shallows. Full amphibious crossing upgrades are future scope, not required for v0.

The primary survival pressure is **fuel + damage + escalating pursuit**. Fuel forces movement and route choices. Damage makes crashes, enemies, and bad terrain matter. Escalating pursuit prevents camping and makes distance feel tense.

The run objective is to go farther from the origin and survive longer. The headline score is **Miles Driven**, supported by survival time, scrap collected, and enemies destroyed. World chunks remain stable within a run, but each new run starts with a fresh Run Seed so the origin and adventure are different every time, while upgraded cars can push farther.

The camera should be top-down or slightly angled top-down, readable on a landscape phone. Keep the car near center with more look-ahead in the travel direction, zoom out subtly at speed, and avoid aggressive camera rotation that would make mobile play disorienting.

Combat should be ram-first. The car is the main weapon. v0 should make crushing zombies/hostile blockers, shoving through light obstacles, and surviving impacts feel satisfying before adding shooting complexity.

The "impressive enough" bar for downstream tickets: a player should be able to start a fresh seeded run, see a varied open world with multiple routes and water barriers, feel terrain speed/handling differences, make meaningful route choices under fuel/damage/pursuit pressure, ram enemies or hazards, collect resources, and want to try again to beat their Miles Driven.
