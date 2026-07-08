# Decide Combat Enemy And Obstacle Model

Type: grilling
Status: resolved
Blocked by: 01

## Question

What is the v0 combat and hazard model: zombies only, human blockers too, ramming, shooting, vehicle damage, obstacle types, spawn pressure, and failure conditions?

The answer should keep scope tight enough for one build run while still making the world dangerous and satisfying.

## Answer

Playable v0 combat should be **Car-Only Combat** against zombies and physical hazards. The car is the weapon; the player survives by ramming, dodging, shoving through light obstacles, picking routes through the Free-Roaming World, and managing Vehicle Damage.

Active enemies in v0 are **Zombies** only. Human blockers, raiders, armed enemies, and shooting are out of scope for v0. Hazards may still include static non-human blockers such as wreckage, fences, debris, boulders, water, and roadblocks.

Zombies should be simple roaming/swarming contact threats, not special variants. They can wander while idle, notice or drift toward the car when nearby, cluster more as Pursuit Pressure rises, damage the vehicle on contact, and die or knock back when rammed with enough speed. v0 does not need ranged attacks, grab states, boss enemies, armor types, or complex navigation.

Obstacle interactions should use weight classes:

- Light Obstacles break or shove aside with satisfying impact feedback.
- Medium Obstacles slow, rotate, shove, and damage the car, but may be forced through at enough speed.
- Heavy Obstacles, deep water, dense wreckage, and major Traversal Barriers hard-stop or force rerouting.

Roadblocks should be generated obstacle clusters, especially on tempting roads and bridges. They should create quick route decisions: ram through a light gap, squeeze around, leave the road, or reroute. They should not become authored puzzle gates.

Vehicle Damage is the combat failure track. Impacts, zombie contact, medium/heavy obstacle collisions, and bad barrier hits reduce it. Reaching zero Vehicle Damage ends the run. Fuel failure remains part of the wider survival loop, with exact fuel/resource tuning left to the resources and progression ticket.

Spawn pressure should come from distance from origin plus Pursuit Pressure. Roads and bridges should be faster but more dangerous, attracting more zombies, blockers, and roadblocks. Offroad should usually be slower and rougher but can be safer or provide escape routes. Keep an origin safe radius, enforce spawn caps, and never spawn active threats directly on top of the player.

Proof requirements for the build run:

- Ramming zombies at speed kills or knocks them back.
- Low-speed contact with zombies damages the car without instantly ending the run.
- Light, medium, and heavy obstacle classes produce visibly different collision outcomes.
- Vehicle Damage can end a run.
- Spawn pressure increases with distance or Pursuit Pressure while respecting caps and the origin safe radius.
- The combat model still preserves 360-degree Free-Roaming World movement; hazards pressure route choice without turning the game into a corridor or lane runner.
