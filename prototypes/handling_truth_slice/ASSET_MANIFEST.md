# Handling Truth Slice Asset Manifest

Status: candidate provenance recorded; production admission and family multiplication remain blocked by presentation, performance, and human evidence.

This manifest covers every committed source asset in `prototypes/handling_truth_slice/assets/`. SHA-256 is over the committed source file, before Godot import. For every runtime asset row below, the exact committed import path is the runtime path plus `.import`; Godot 4.7 stable (`5b4e0cb0f`) generated those sidecars. `.godot/imported/` is disposable cache, not provenance.

## Package and review record

| Field | Value |
|---|---|
| Stable package ID | `kd.phase2.drive-hero.v1` |
| Tranche | Desktop Truth Slice A / Phase-2 Drive hero |
| Allowed use | Keep Driving source, candidate builds, evidence tools, and compiled distribution if the asset is admitted; third-party rights remain those below |
| Ownership/license review | Source, creator, license, member, and hash recorded; OFL texts ship beside the compiled candidate; no unresolved attribution requirement |
| Style/readability review | Project-authored working palette applied; phone-scale recognition, contrast/color-independence, and human approval `PENDING` |
| Production state | Isolated prototype/candidate only; no family multiplication or production admission |
| Importer/preset version | Godot `4.7.stable.official.5b4e0cb0f`; committed `.import` sidecars are authoritative |
| Memory/package class | One Drive-hero tranche; hero route/vehicle/audio measured individually, recognition-only assets excluded from the playable PCK |

## Source registry

| Source ID | Creator / provenance | License | Source |
|---|---|---|---|
| `OGA-ENGINE` | domasx2; edited loops derived from the page's identified public-domain PDSounds recording | CC0 1.0 | [racing car engine sound loops](https://opengameart.org/content/racing-car-engine-sound-loops) |
| `OGA-SFX` | rubberduck; members copied from `sfx_loops.zip` | CC0 1.0 | [30 CC0 SFX loops](https://opengameart.org/content/30-cc0-sfx-loops) |
| `KENNEY-IMPACT` | Kenney; members copied from `kenney_impact-sounds.zip` | CC0 1.0 | [Impact Sounds](https://www.kenney.nl/assets/impact-sounds) |
| `KENNEY-UI` | Kenney; members copied from `kenney_ui-audio.zip` | CC0 1.0 | [UI Audio](https://www.kenney.nl/assets/ui-audio) |
| `ATKINSON` | Braille Institute of America; downloaded from the maintained font repository | SIL OFL 1.1 | [Atkinson Hyperlegible](https://github.com/googlefonts/atkinson-hyperlegible) |
| `BARLOW` | The Barlow Project Authors; downloaded from the maintained font repository | SIL OFL 1.1 | [Barlow](https://github.com/jpt/barlow) |
| `PROJECT` | Authored directly in this repository for the ticket-08 candidate; no external source or asset-pack derivative | Project work product; no third-party attribution | Runtime source path below |

Third-party audio was copied and renamed without source re-encoding. The Godot importer produces the runtime representation. CC0 attribution is not required, but creator, source, member name, and hash remain recorded for auditability.

## Import and runtime policy

| Family | Import preset / format | Runtime loop / bus / concurrency | Scale, pivot, collision, alternatives, and review |
|---|---|---|---|
| Engine layers | Source WAV PCM s16le, mono, 44.1 kHz; Godot sample importer `compress/mode=2` | Runtime forward loop; `Vehicle`; one voice per idle/load/high layer | Speed/load blend; visual speed/load equivalents; audible/mix review pending |
| Surface loops | Ogg Vorbis stream; road/dirt/mud stereo 48 kHz, grass stereo 44.1 kHz | Runtime loop; one shared `World` voice | Road/dirt/grass/mud state routing; visual surface equivalent; audible/mix review pending |
| Impacts | Ogg Vorbis, stereo 44.1 kHz | One-shot; `Vehicle`; three independently counted voices per light/medium/heavy family before deterministic stealing | Weight and Integrity visual/camera equivalents; audible/severity review pending |
| Reward/warning/UI | Ogg Vorbis stereo; warning 48 kHz, reward/UI 44.1 kHz | One-shot; `UI`; two countable routine-UI voices plus dedicated reward and warning voices | HUD/world equivalents; masking and sensory-independence review pending |
| Fonts | Dynamic font importer; antialiasing on, embedded bitmaps off, system fallback allowed, compression on | UI only | Center/baseline per Control; high-text-scale and phone proof pending |
| Playable SVGs | Texture importer, lossless mode 0, SVG scale 1.0, no mipmap generation | One authored route backdrop plus sprites | Sprite pivots centered; hero visual scale 0.46; barrier visuals scale to collision diameter; collision remains explicit Circle/Rectangle shapes |
| Recognition-only SVGs | Same texture preset; excluded from playable export preset | Evidence harness only | Neutral density backdrop plus isolated single-category routes; 896×414 timed preview/human evidence pending |
| Dust VFX | Same texture preset | One `GPUParticles2D`, 24-particle cap | Centered particle texture, no collision; Reduced Effects/human/performance review pending |

## Audio

| Runtime source path | Source ID / original member | Authorship status | Candidate status | SHA-256 |
|---|---|---|---|---|
| `prototypes/handling_truth_slice/assets/audio/engine_idle.wav` | `OGA-ENGINE` / `loop_0.wav` | Third-party | Imported; audible mix and human approval pending | `69d74b106509037ce547429e4c3f9ae906b0fffe88d0bb8b3b5a8b0cfc239048` |
| `prototypes/handling_truth_slice/assets/audio/engine_load.wav` | `OGA-ENGINE` / `loop_2.wav` (download endpoint `loop_2_0.wav`) | Third-party | Imported; audible mix and human approval pending | `e26bef6f1804670aba02b6b9a8c5485cf05a6a1e902a5a50c098230ace49967f` |
| `prototypes/handling_truth_slice/assets/audio/engine_high.wav` | `OGA-ENGINE` / `loop_4.wav` | Third-party | Imported; audible mix and human approval pending | `a526c06f9cd1db5b2d69695864316f48bec9089aa2ac3817ebf400fcd1c18a27` |
| `prototypes/handling_truth_slice/assets/audio/surface_asphalt.ogg` | `OGA-SFX` / `rolling.ogg` | Third-party | Imported; audible mix and human approval pending | `24b5fd290b2008de9b087687ae41db833068a86ef7c0f1b230ce8bf0859b7291` |
| `prototypes/handling_truth_slice/assets/audio/surface_dirt.ogg` | `OGA-SFX` / `noise_02.ogg` | Third-party | Imported; audible mix and human approval pending | `b1cb867f85c2735023943686e8d4976f1c29c094c5951cf1f6ce91ce70cac5ba` |
| `prototypes/handling_truth_slice/assets/audio/surface_mud.ogg` | `OGA-SFX` / `water_flowing.ogg` | Third-party | Imported; audible mix and human approval pending | `1a431f77d61661becdc87a5b1832d47f83a12a5c0b001077e41a202e739797a7` |
| `prototypes/handling_truth_slice/assets/audio/surface_grass.ogg` | `KENNEY-IMPACT` / `Audio/footstep_grass_000.ogg` | Third-party | Imported; audible mix and human approval pending | `9d49497777405d78d7cf7f2888e28277f3a23192300cfd1d79d54876b20f479f` |
| `prototypes/handling_truth_slice/assets/audio/impact_light.ogg` | `KENNEY-IMPACT` / `Audio/impactMetal_light_000.ogg` | Third-party | Imported; audible mix and human approval pending | `33b5e6e37c6e9d54e07bf5a89b12c76e879f40c1ea83cdd82714df1d6f9fec6d` |
| `prototypes/handling_truth_slice/assets/audio/impact_medium.ogg` | `KENNEY-IMPACT` / `Audio/impactMetal_medium_000.ogg` | Third-party | Imported; audible mix and human approval pending | `a96f879fec0864a8938e0c745b6996a6c5679c16a234ce31a01cc995e8401003` |
| `prototypes/handling_truth_slice/assets/audio/impact_heavy.ogg` | `KENNEY-IMPACT` / `Audio/impactMetal_heavy_000.ogg` | Third-party | Imported; audible mix and human approval pending | `e07045693e4a2b3d165c424e3dab4c781d9ff8880a386880ac89a51315d7f831` |
| `prototypes/handling_truth_slice/assets/audio/warning.ogg` | `OGA-SFX` / `alarm_02.ogg` | Third-party | Imported; audible mix and human approval pending | `26f1a445657e35c2639a0fecb2535c19a890cf3d70f65606d5729429efa95c1f` |
| `prototypes/handling_truth_slice/assets/audio/reward.ogg` | `KENNEY-UI` / `Audio/switch36.ogg` | Third-party | Imported; audible mix and human approval pending | `1dd3cf29291219ab2eed0292d5c3b06b1e102ea70821099e741fc127734ffa04` |
| `prototypes/handling_truth_slice/assets/audio/ui_confirm.ogg` | `KENNEY-UI` / `Audio/click1.ogg` | Third-party | Imported; audible mix and human approval pending | `59175ac17cd49a68dd736285738441287636112a84a6f7ce0d89921bda5a5360` |

## Fonts and license evidence

| Runtime source path | Source ID / original member | Authorship status | Candidate status | SHA-256 |
|---|---|---|---|---|
| `prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Regular.otf` | `ATKINSON` / `fonts/otf/AtkinsonHyperlegible-Regular.otf` | Third-party | Imported; candidate UI only | `4a0397a3709c5fc99e38d05469dcfbf1b3481196e89a01b7377f3163b188258e` |
| `prototypes/handling_truth_slice/assets/fonts/AtkinsonHyperlegible-Bold.otf` | `ATKINSON` / `fonts/otf/AtkinsonHyperlegible-Bold.otf` | Third-party | Imported; candidate UI only | `682c9737bfb6c1d3ba4f9cd5fdc814775c097f317656aad177867cc07d7e15df` |
| `prototypes/handling_truth_slice/assets/fonts/BarlowCondensed-Bold.otf` | `BARLOW` / `fonts/otf/BarlowCondensed-Bold.otf` | Third-party | Imported; candidate UI only | `97b4e0050f3674a503b8cd5f42fc3d7a5c72e42ab8ff26e2fcce9dafed07d3e7` |

The license texts are provenance evidence, not imported runtime assets:

| Evidence path | Applies to | SHA-256 |
|---|---|---|
| `prototypes/handling_truth_slice/assets/fonts/OFL-Atkinson-Hyperlegible.txt` | `ATKINSON`; copyright 2020 Braille Institute of America, Inc. | `64b9cae8727cb41ea9e8843103e69647c82383f3a902e2bb39b2c5d92083b6e1` |
| `prototypes/handling_truth_slice/assets/fonts/OFL-Barlow.txt` | `BARLOW`; copyright 2017 The Barlow Project Authors | `10b0e6bb43166a50fbe7cde2895bd7f703738a5da843acb5c97c95dc9ea26817` |

## Visuals

All visual sources are `PROJECT` work product authored as SVG in the repository. They have no third-party source, embedded external bitmap, or required attribution.

| Runtime source path | Role | Authorship status | Candidate status | SHA-256 |
|---|---|---|---|---|
| `prototypes/handling_truth_slice/assets/visual/barrier_heavy.svg` | Heavy obstacle | Project-authored | Imported; recognition/human approval pending | `ae87d8829f33045c38883c880d64ba1f965ef62f8cc411e31d040cdd6fcdac4e` |
| `prototypes/handling_truth_slice/assets/visual/barrier_light.svg` | Breakable light obstacle | Project-authored | Imported; recognition/human approval pending | `c0f2fe932fea25bdd3241291731a4220e6d03d3b776a08e13f99946e21cdaee4` |
| `prototypes/handling_truth_slice/assets/visual/barrier_medium.svg` | Medium obstacle | Project-authored | Imported; recognition/human approval pending | `d5ebc00aafbcb4ca3516cb04060507134525b29dd166ababdc360d88b7b20190` |
| `prototypes/handling_truth_slice/assets/visual/cargo.svg` | Cargo silhouette | Project-authored | Imported; recognition/human approval pending | `059997df902464e244d9aee9e3a229bde5d33133998ce6731b98683d899fa6c7` |
| `prototypes/handling_truth_slice/assets/visual/dust_particle.svg` | Surface/slide VFX particle | Project-authored | Imported; performance/sensory approval pending | `87d1c66e596e419743a064d1a1e8f4dfb9eb956f1b343086c6dfaf357879acc2` |
| `prototypes/handling_truth_slice/assets/visual/fuel.svg` | Fuel silhouette/HUD icon | Project-authored | Imported; recognition/human approval pending | `b57b6bab18aa1a44e25e7b52ab62339330a6331ecf0a729be0a8660fbedf422f` |
| `prototypes/handling_truth_slice/assets/visual/hero_wagon.svg` | Hero vehicle | Project-authored | Imported; recognition/handling approval pending | `cf967ddd2f8d657f8276c7b54692f33cfe9b4204987344dca8644588901b1278` |
| `prototypes/handling_truth_slice/assets/visual/integrity.svg` | Integrity HUD icon | Project-authored | Imported; recognition/human approval pending | `05f92c5462a1fe31f71ded882e6b099c58bde6dd7b5d7306c41876e70bea9d75` |
| `prototypes/handling_truth_slice/assets/visual/lowlands_first_road.svg` | Lot, connected road/fork/surfaces, marked handling-lab fixtures, region field | Project-authored | Imported; readability/performance approval pending | `b2919278515ad73312c0cb3749e6e6d0c88a7150b8a1808588cef0b270a7cd4c` |
| `prototypes/handling_truth_slice/assets/visual/objective.svg` | Objective marker | Project-authored | Imported; recognition/human approval pending | `aa6d1c66c1223493fb7a6b094262603299b8baf0b28a4f2fd40b9d499fcb8ca4` |
| `prototypes/handling_truth_slice/assets/visual/radio_relay.svg` | Radio-relay landmark | Project-authored | Imported; recognition/human approval pending | `3e6abfce785b85d7f2aa2c2a1eaae101e9b84cfb3ea96ec6aabc3107817241b0` |
| `prototypes/handling_truth_slice/assets/visual/recognition_density.svg` | Semantic-neutral Lowlands density backdrop for positive/negative recognition trials | Project-authored | Imported; evidence harness only | `b5eec24a67a85580b6c0b980251ac122749d3f0bfeb3c605bd8f0068934d2a42` |
| `prototypes/handling_truth_slice/assets/visual/repair.svg` | Repair silhouette | Project-authored | Imported; recognition/human approval pending | `1b5f167f8d3aedc0e835ec220495bcab459cbceb59a2b1f4890db4211b4a9078` |
| `prototypes/handling_truth_slice/assets/visual/reward.svg` | Reward silhouette | Project-authored | Imported; recognition/human approval pending | `648169246f3550a46ac1c3e3043c15dc3dafe35e1a52bf9b79ff42f13c2c1797` |
| `prototypes/handling_truth_slice/assets/visual/route_dirt.svg` | Isolated dirt-route recognition stimulus/control | Project-authored | Imported; evidence harness only | `e464a30a56befc7b9593e89207fbc0829ef69e6d48efaa79d13ada1d526a3594` |
| `prototypes/handling_truth_slice/assets/visual/route_mud.svg` | Isolated mud-route recognition stimulus/control | Project-authored | Imported; evidence harness only | `033d19602e44c083c75815713ea34d8b7dbc5159ebab38146f1131b864ff6a93` |
| `prototypes/handling_truth_slice/assets/visual/route_primary.svg` | Isolated primary-road recognition stimulus/control | Project-authored | Imported; evidence harness only | `0ea8a820623b6e1557e8be82a149f41222e12344699fdfb03a1c25157d8b264d` |
| `prototypes/handling_truth_slice/assets/visual/safehouse.svg` | Safehouse silhouette | Project-authored | Imported; recognition/human approval pending | `b3c749a3854f8804091f1a6d4bbea03396482cd2eaddfd92bec1824a2a369cab` |
| `prototypes/handling_truth_slice/assets/visual/threat.svg` | Threat silhouette | Project-authored | Imported; recognition/human approval pending | `e7ae7962a73a8dbbbac6927c22fffc17c568d84435c6b1c235ea65aa78a487a0` |

## Candidate cost ledger

| Measurement | Current value | Admission state |
|---|---:|---|
| Source asset files | 37 | Exact; includes two OFL texts and four recognition-only visuals |
| Source bytes — audio | 528,738 | Exact |
| Source bytes — fonts/licenses | 210,575 | Exact |
| Source bytes — playable + recognition visuals | 15,626 | Exact |
| Source bytes — total | 754,939 | Exact |
| Playable PCK bytes | `PENDING_CLEAN_EXPORT` | Export script records in embedded provenance |
| Signed app file bytes | `PENDING_CLEAN_EXPORT` | Frozen `candidate.json` records after signing and verification |
| Runtime texture/buffer/video memory | `PENDING_CLEAN_1800S_RUNS` | Benchmark report records renderer peaks |
| Unique textures/materials, draws/nodes | `PENDING_CLEAN_1800S_RUNS` | Benchmark report records peaks |
| Audio voices/output latency | `PENDING_CLEAN_1800S_RUNS` | Monophonic players plus benchmark report |
| Audio buffers | 38,960-byte imported engine-sample payload + 332,073-byte embedded Ogg packet payload | Exact export-safe runtime resource evidence; clean benchmark repeats the fields |
| Audio mix time | Godot 4.7 exposes output latency but no public audio-thread time monitor | Full-frame performance plus audible/mix capture remain required; this is not an admission pass |
| VFX emitters/particles | 1 / 24 cap; clean peak pending | Automated contract green; release evidence pending |
| Haptic cadence | Desktop no-op: 0 events / 0 Hz | Recorded explicitly; cannot satisfy later physical-device haptic evidence |

## Admission rule

This inventory proves traceability only. An asset or family remains a candidate until the exact clean build passes deterministic import/export, source/license review, rendered performance and package measurement, randomized phone-scale recognition where applicable, audible/mix checks where applicable, and the frozen human evidence in `PLAYTEST_EVIDENCE.md`. Any source-file change requires a new hash, fresh import metadata, a new candidate build, and rerun of affected evidence.
