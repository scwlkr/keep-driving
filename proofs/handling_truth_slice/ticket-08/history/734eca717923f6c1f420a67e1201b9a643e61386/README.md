# Failed Candidate Evidence — `734eca7`

Retained diagnostic evidence for source candidate `734eca717923f6c1f420a67e1201b9a643e61386`. This directory is immutable history and is not an accepted ticket-08 candidate.

- Clean signed export, package hashes, automated smoke, 30/60/120 cadence, and 10 x 45 recognition preview preparation passed.
- The full 1,800-second feel run failed: `747.347 FPS` despite reported VSync, `149.513 ms` worst frame, and `+6.998%` RSS plateau growth.
- Review traced those failures to the measurement harness retaining 1,345,213 frame samples and synchronously executing `ps` on the render thread. They do not establish a gameplay leak or accepted performance.
- The capacity run was stopped after about nine minutes once the shared instrumentation defect was proven. `performance/capacity.log` is partial; no capacity report or RSS artifact exists.
- No human, physical-controller, audible-mix, sensory, or signoff evidence was collected. The automated live recognition check is explicitly marked `human_evidence=false`.
- Manifests inside this archive retain the absolute canonical paths recorded when this candidate occupied `proofs/handling_truth_slice/ticket-08/`; they must not be reused for a later candidate.

The active candidate paths are regenerated only after the harness fix, clean commit, export, and candidate freeze.
