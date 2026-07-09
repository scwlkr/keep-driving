# Decide Build Run Tracking Model

Type: grilling
Status: resolved
Assignee: Codex
Blocked by: 07

## Question

Should the One-Shot Build Run initialize GitHub repo/issues for parallel agents, or stay local until Playable v0 exists?

The answer should decide where implementation tasks live during the first build run, how agents coordinate, what artifacts must be committed, and when GitHub issue setup becomes required.

## Grilling log

- The first One-Shot Build Run should stay local in `.scratch/keep-driving-v0/issues/`. Agents coordinate through local tracker files and commits. GitHub issues are only required after Playable v0 exists or if remote/human-visible coordination becomes necessary.

## Answer

The One-Shot Build Run should use a **Local Build Run Tracker** for the first implementation pass.

Implementation tasks should live in `.scratch/keep-driving-v0/issues/`, not GitHub issues. The manager prompt should create or update local markdown implementation tickets there, assign/claim work by editing those files, and require each agent/session to commit its own completed slice with proof artifacts before handing back.

Coordination should happen through:

- local markdown ticket status, owner/claim, blockers, and notes;
- frequent git commits with narrow scope;
- committed proof outputs, screenshots, logs, or test notes where relevant;
- a final manager pass that reads local tracker state and git history before reporting Done Bar status.

The first build run should not spend time initializing GitHub repo issues unless the local workflow becomes insufficient. GitHub issue setup becomes required only after Playable v0 exists, or earlier if coordination needs remote visibility, multiple humans, durable public tracking, or cross-machine agents that cannot safely share the local tracker.

This keeps the first build focused on producing the playable game and its proofs while preserving enough local structure for parallel Codex sessions to coordinate.
