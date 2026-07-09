# Write One-Shot Build Run Prompt

Type: task
Status: resolved
Assignee: Codex
Blocked by: 12, 13

## Question

Write the final One-Shot Build Run prompt that a manager Codex session can execute to coordinate parallel agents/sessions until Keep Driving Playable v0 is built and verified.

The prompt should include repo setup, issue plan, agent boundaries, proof requirements, commit cadence, and exact final reporting requirements.

## Grilling log

- The final prompt should be an autonomous manager `/goal` prompt that can create local build tickets, spawn agents, edit code, run proofs, and keep committing until the Done Bar passes.

## Answer

The final One-Shot Build Run prompt is recorded at [Keep Driving v0 One-Shot Build Run Prompt](../one-shot-build-run-prompt.md).

It launches an **Autonomous Build Manager** that reads the wayfinder map and resolved tickets, creates local `build-XX-*.md` implementation tickets in `.scratch/keep-driving-v0/issues/`, coordinates parallel agents by explicit local ticket claims, commits frequently, enforces the Playable v0 Done Bar, and reports exact proof results.

The prompt deliberately keeps the first build run local. It does not initialize GitHub issues, does not require real Android/iOS export proof, and does not allow the build to pass as a lane runner, corridor runner, disconnected tech demo, or partial feature checklist.
