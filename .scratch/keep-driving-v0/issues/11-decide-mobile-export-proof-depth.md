# Decide Mobile Export Proof Depth

Type: grilling
Status: resolved
Assignee: Codex
Blocked by: 10

## Question

What mobile export proof depth should Playable v0 require beyond the desktop-local performance proof?

The answer should decide whether the One-Shot Build Run needs only landscape mobile orientation expectations, a simulated mobile viewport/input proof, actual Android/iOS export artifacts, device smoke proof, or a deliberate deferral of real-device proof until after Playable v0 exists.

## Grilling log

- Playable v0 should defer real Android/iOS export artifacts and physical-device smoke proof until after the playable exists. The One-Shot Build Run should require landscape mobile simulation proof on desktop: landscape aspect, touch-sized HUD, virtual steering/buttons, and simulated mobile input.

## Answer

Playable v0 should use **Landscape Mobile Simulation Proof** as the mobile gate for the One-Shot Build Run.

The hard performance gate remains desktop-local proof: `60 FPS` with `p95 frame time <= 16.7ms` during the required high-speed world performance proof. Mobile readiness is a design and usability expectation for v0, not a real export gate.

The build run should prove:

- The game runs in a landscape phone-shaped viewport without layout breakage.
- The HUD is touch-sized and readable at landscape mobile scale.
- The driving controls include virtual steering plus gas, brake/reverse, and Handbrake Drift inputs.
- Simulated mobile input can start a run, drive, steer, brake, drift, collect pickups, collide, take damage, end a run, and use the Garage loop.
- The camera, UI, terrain readability, and action feedback still work at landscape mobile scale.

The build run should not require Android export artifacts, iOS export artifacts, signing/provisioning setup, installable mobile builds, App Store or Play Store work, or physical-device smoke proof.

Real-device mobile proof is deliberately deferred until after Playable v0 exists. That later proof can validate actual Android/iOS exports and device performance once the core game is built and worth packaging.
