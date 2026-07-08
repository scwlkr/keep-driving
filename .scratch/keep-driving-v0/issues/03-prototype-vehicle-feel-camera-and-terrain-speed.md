# Prototype Vehicle Feel Camera And Terrain Speed

Type: prototype
Status: resolved
Blocked by: 01

## Question

What vehicle controls, camera behavior, and terrain speed/handling differences make the Free-Roaming World feel good on a landscape phone?

Create a cheap Godot prototype or equivalent concrete artifact that tests steering, acceleration, braking, collision response, camera follow/zoom, and Road Advantage across terrain types.

## Answer

Resolved by grilling as a vehicle-feel spec. No runnable prototype was created in this pass because scwlkr explicitly asked to resolve the frontier through the grilling method.

Vehicle feel should be **Arcade-Real Handling**: accessible, fast, and readable, but with believable car weight. The car accelerates with gas, brakes/reverses separately, turns by steering the vehicle rather than moving twin-stick-style, keeps momentum, drifts slightly on loose terrain, and reacts to crashes by shoving/rotating instead of stopping dead.

v0 must include **Handbrake Drift**. The handbrake lets the player rotate sharply and slide through turns at the cost of traction/control. It should be useful for emergency turns, roadblock dodges, and dramatic offroad recovery, not a precision parking mechanic.

Landscape mobile control layout:

- Left thumb controls steering through a virtual steering wheel or left/right steering zone.
- Right thumb controls gas, brake/reverse, and handbrake buttons.
- Auto-gas can be considered later, but should not be default v0.

Terrain handling targets:

- Paved road: fastest, highest grip.
- Dirt path: slightly slower than paved road, easier to drift.
- Grass: medium slow, loose steering.
- Rough offroad: slow, bouncy, poor grip.
- Shallow water/mud: very slow and risky but passable.
- Deep water: Traversal Barrier unless crossed by bridge/shallows.

Camera target:

- Top-down with slight angle illusion from art/shadows, not a true 3D camera.
- Smooth follow.
- Look-ahead in travel direction.
- Zoom out subtly at high speed.
- Small screen shake on big impacts.
- Do not rotate the camera with the car.

Collision feel:

- Small obstacles break or shove aside.
- Medium obstacles slow the car, rotate/shove it, and damage it.
- Heavy obstacles, deep water, and debris walls hard-stop or force reroute.
- Enemies get satisfying ram impact and knockback, with damage based on speed.
- Avoid instant full stops except against major barriers.

Implementation/proof implications:

- The later build should expose tunable constants for acceleration, max speed, grip, drift, brake force, terrain multipliers, impact damage, camera smoothing, camera look-ahead, and speed zoom.
- Automated proof can verify terrain multipliers, max-speed differences, handbrake state changes, camera zoom response, and collision categories.
- Manual proof must include at least a 2-minute drive across road, dirt, grass, rough offroad, shallow water/mud, and barriers.
