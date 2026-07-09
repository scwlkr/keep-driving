# Decide Visual Audio And Asset Direction

Type: grilling
Status: resolved
Blocked by: 01

## Question

What visual style, asset sourcing approach, feedback effects, and audio direction should make the Road Warrior Survival Expedition feel impressive in Playable v0 without overloading the One-Shot Build Run?

The answer should decide the v0 look and feel: readable top-down terrain, roads/paths/water/barriers, car/enemy/obstacle silhouettes, impact effects, UI mood, music/engine/impact audio, and whether generated/procedural/simple custom assets are acceptable.

## Grilling log

- v0 should use a stylized, high-contrast 2D top-down look made from simple custom/procedural assets during the build run. Prioritize readable terrain, routes, hazards, silhouettes, and feedback over photorealism, polished asset packs, or a long art pipeline.
- Terrain readability should use clear terrain colors with strong route contrast: paved roads dark/clean, dirt paths warm/brown, grass green, rough offroad gray/olive, water bright blue, and barriers high-contrast. The player should understand route quality and danger at a glance on a landscape phone.
- The car, Zombies, pickups, and Obstacles should use simple icon-like silhouettes with distinct shapes and colors, not detailed sprites. The car must read by heading, Zombies can be small moving dark/red figures, pickups must be instantly distinct by type, and light/medium/heavy Obstacles should read by visual weight.
- v0 should spend effect effort on juicy impact and movement feedback: dust trails, tire skid marks, hit flashes, debris bursts, screen shake, engine pitch response, and pickup pulses. These effects are the main polish lever for making simple assets feel impressive and making ramming, drifting, damage, and collection readable.
- Audio should be minimal but reactive: a looped engine sound with pitch by speed, tire/skid sounds, impact thuds by obstacle weight, pickup chimes, fuel and damage warnings, simple zombie hit cues, and optional low ambient music. Generated or bundled-safe simple audio is acceptable; reactive feedback matters more than a composed soundtrack.
- The UI mood should be rugged dashboard survival, but extremely small: Fuel, Vehicle Damage, Miles Driven, Scrap, current upgrade hints/results, and Garage controls only. v0 should not include ornate menus, minimap, quest UI, inventory, lore panels, or cinematic overlays.

## Answer

Playable v0 should use **Stylized Survival Readability**: a bold, high-contrast 2D top-down look made from simple custom/procedural assets during the build run. The art direction should make the Free-Roaming World readable and exciting without depending on photorealism, polished asset packs, or a long art pipeline.

Terrain should communicate route quality at a glance on a landscape phone. Use strong color/value separation: paved roads dark and clean, dirt paths warm/brown, grass green, rough offroad gray/olive, water bright blue, and Traversal Barriers high-contrast. Roads and paths should be visibly attractive route choices without making the world feel like lanes.

The car, Zombies, pickups, and Obstacles should use simple icon-like silhouettes with distinct shapes and colors. The car must read clearly by heading. Zombies can be small moving dark/red figures. Fuel, Scrap, and Repair Pickups must be instantly distinct. Light, medium, and heavy Obstacles should read by visual weight before impact.

Most polish effort should go into motion and impact feedback: dust trails, tire skid marks, hit flashes, debris bursts, screen shake, engine pitch response, and pickup pulses. These effects are the cheapest way to make simple assets feel impressive and make ramming, drifting, damage, and collection readable.

Audio should be minimal but reactive. Include a looped engine sound with pitch by speed, tire/skid sounds, impact thuds by obstacle weight, pickup chimes, fuel and damage warnings, simple zombie hit cues, and optional low ambient music. Generated or bundled-safe simple audio is acceptable; reactive feedback matters more than a composed soundtrack.

The UI mood should be rugged dashboard survival, kept extremely small: Fuel, Vehicle Damage, Miles Driven, Scrap, current upgrade hints/results, and Garage controls only. Ornate menus, minimap, quest UI, inventory, lore panels, cinematic overlays, and soundtrack-heavy presentation are out of scope for v0.

Proof requirements for the build run:

- Terrain and route types remain distinguishable in motion on a landscape phone-sized viewport.
- The player car, Zombies, pickups, and obstacle weight classes are recognizable without reading labels.
- Ramming, drifting, damage, pickups, fuel danger, and low Vehicle Damage produce visible and audible feedback.
- The UI exposes only the v0 survival/progression state needed to play and restart.
- The game still feels like a Road Warrior Survival Expedition even with simple generated/custom assets.
