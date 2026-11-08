<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically? -->
<!-- Date: 2026-11-08 -->

# Spike Note: Sim Core (P1)

**Date**: 2026-11-08 · **Engine**: Godot 4.7.2.stable.official, headless, GDScript · **Machine**: the developer's Mac (model and clock not recorded)

## Question tested
Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically, or must it move to C# or GDExtension?

## Result: PARTIAL

Pass criteria were set before any run (see README). Measured results from `bench.gd`, full run:

| Criterion | Result | Verdict |
|---|---|---|
| Determinism: 5 runs, same state + command log + seed, 6,000 ticks | identical hash on all 5; a different seed gives a different hash | **PASS** |
| Save/load: snapshot mid-run through `var_to_bytes`, restore, resume | restored state matches the snapshot hash; resumed run matches the uninterrupted run (snapshot 21,980 bytes) | **PASS** |
| MVP throughput: 300 units, 10 Hz, 1 h world time (36,000 ticks) | **55.1 s** wall (65x real time) vs a 30 s bar | **MARGINAL** (30-90 s band) |
| Real-time headroom, 300 units: mean tick at most 1 ms | mean **1.95 ms** | **FAIL** |
| Real-time headroom, 300 units: p99 tick at most 3 ms | p99 **2.90 ms** | PASS (barely) |

Reported only (not pass/fail):

| Units | ms per tick | ticks per second |
|---|---|---|
| 100 | 0.33 | 3,020 |
| 300 | 1.96 | 511 |
| 600 | 6.54 | 152 |
| 1000 | 15.54 | 64 |

- Cost grows **faster than linearly** (3x the units costs 6x; 6x the units costs 20x), because units converge into contact and the nearest-enemy search scans every unit in the neighbouring hash cells.
- 99% of tick time is the per-unit update (behaviour, line of sight, movement, combat). Rebuilding the spatial hash is 1%.
- Projected VS-A catch-up: an 8-hour skip (288,000 ticks) at 300 units would take about **441 s (7.4 minutes)** at the measured rate.
- The workload sanity check confirmed combat: 48,941 shots, 16,366 hits and 3,242 kills in the timed run.

## What this does and does not show
- It shows the architecture rules in the contracts are workable in GDScript: struct-of-arrays state, integer fixed-point positions, a seeded RNG inside the state, commands as the only input, no Node or engine service inside the simulation, and a snapshot that round-trips to bytes.
- **At MVP scale it is comfortably fast enough.** An MVP skirmish is tens of units (the prototype was 8); at 100 units the tick costs 0.33 ms, about 2% of a 16.6 ms frame. The 300-unit criteria were deliberately stricter than the MVP needs.
- **At 300 units the tick is about 2 ms**, roughly 12% of a 16.6 ms frame budget. That is workable for real-time play but leaves little room, and skip-time at that scale is slow.
- **It does not compare languages.** No C# or GDExtension version was built, so this spike cannot say how much faster either would be. Any claim of a speed-up would be unsourced.
- **Unit counts are still undecided** (art bible open item D2), so "enough" is not yet defined.

## Limits and caveats
- Cross-OS determinism was not tested (one machine). The direction lookup tables are generated with floats at startup, which is an assumption.
- The first workload was wrong: units spawned too far apart to meet, so the first quick run saw no combat. The sanity check caught it, the bases were moved closer, and all numbers above are from the fixed workload.
- The optimisations tried: none. The obvious candidates are unmeasured: a hash cell no larger than the weapon range, staggering target selection (re-evaluate every few ticks), and early-outs.
- Timings are from one machine and one run each, without a warm-up pass; treat them as order-of-magnitude.

## What to do next
- **Keep GDScript for the MVP simulation core.** It passes determinism and save/load and is fast enough at MVP scale. The project.yaml language pin can stay "GDScript" but remains provisional for VS-A.
- **Keep the simulation behind a narrow command-and-snapshot interface** (contracts C1, C2 and C5) so the per-unit update loop can move to C# or GDExtension later if VS-A skip-time at scale needs it. Record the decision and its trigger in the simulation ADR at Technical Setup.
- **Before VS-A,** run a second spike: apply the cheap optimisations above, then build the same loop in C# (or a GDExtension) and measure both on the same machine. Decide the language for the offline-resolution path from that, not from this note.
- **Set the unit-count target (D2)** and minimum-spec hardware (D3) so the next spike has pass criteria that mean something.
- **Fold this into the Simulation Core GDD:** one writer per field, a fixed phase order, an event list, integer units, and the snapshot equal to the save format. This spike's `sim.gd` is throwaway and must be rewritten, never extended.
- P2 (line of sight over the hand-authored grid) is still to be run before the Terrain GDD.

> Spike results inform decisions; they do not make them. The developer decides whether PARTIAL is enough to proceed with GDD 1.
