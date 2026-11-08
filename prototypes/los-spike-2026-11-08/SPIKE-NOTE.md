<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference? -->
<!-- Date: 2026-11-08 -->

# Spike Note: Line of Sight (P2)

**Date**: 2026-11-08 · **Engine**: Godot 4.7.2.stable.official, headless, GDScript · **Machine**: the developer's Mac (model not recorded)

## Question tested
Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference?

## Result: PARTIAL

Pass criteria were set before any run (see README). Results from `bench.gd`:

| Cell size | Grid (4,096 m region) | Memory | Accuracy vs reference (5,000 pairs) | 300 units x 4 candidates, every tick | Every 4th tick | Cost verdict |
|---|---|---|---|---|---|---|
| 4 m | 1024 x 1024 | 5,120 KB | 1.36% disagree: **MARGINAL** | 4.43 ms | 1.11 ms | **MARGINAL** |
| 8 m | 512 x 512 | 1,280 KB | 2.56% disagree: **MARGINAL** | 2.48 ms | 0.62 ms | **PASS** |
| 16 m | 256 x 256 | 320 KB | 5.36% disagree: **FAIL** | 1.46 ms | 0.36 ms | **PASS** |

Reported only:
- Microseconds per query: 3.7 (4 m), 2.1 (8 m), 1.2 (16 m).
- One candidate per unit, 300 units, every tick: 1.69 ms (4 m), 0.61 ms (8 m), 0.36 ms (16 m).
- 600 units x 4 candidates, every tick: 8.85 ms (4 m), 4.96 ms (8 m), 2.92 ms (16 m).
- About 20-25% of the test pairs were blocked in the reference, so the test was not trivially all-clear.

## What this shows
- **Line of sight is not the bottleneck.** Cost is far lower than I expected: a few microseconds per query in GDScript. At 8 m cells, 300 units can check four candidates every tick for 2.5 ms (a budget the technical-director set at 4 ms), and one candidate per unit costs 0.6 ms.
- **Accuracy is the weak point, not speed.** Cell-stepping disagrees with a 4x supersampled march on the same grid in 1.4% (4 m) to 5.4% (16 m) of pairs, and it gets worse as cells get coarser. 16 m cells fail the accuracy bar.
- **A workable starting format for GDD 3:** 8 m cells (512 x 512 for a 4 km region, about 1.3 MB), integer centimetre heights, one cover-class byte per cell. Cost PASS, accuracy MARGINAL. If the region needs 4 m cells for accuracy, refresh line of sight every 4th tick, which brings the same load to 1.1 ms.

## Limits and caveats
- **The terrain is synthetic** (integer value noise plus random cover blocks). It stands in for a hand-authored region; it is not the region, and real terrain with long ridges or dense buildings may behave differently.
- **The accuracy test measures the stepping algorithm only.** The reference runs on the same grid, so it says nothing about how well any grid represents real terrain. Downsampling error (averaging heights, taking the maximum cover class) is in the grid but not in the mismatch figure.
- **The direction of the disagreement was not measured** (false blocks vs false clears), and the reference is itself an approximation, not ground truth.
- **Symmetry was not tested.** Cell stepping from A to B is not guaranteed to give the same answer as B to A. That matters for fairness (two units that cannot see each other symmetrically) and for ambush play. Treat it as untested.
- Hit chance and gameplay were not tested: this is a performance and stepping-accuracy spike only.
- One machine, one run each, no warm-up pass; treat the timings as order-of-magnitude.
- My first attempt crashed on a type error in my own `downsample` function (and hung, because the crash happened during startup). It was fixed and rerun; all numbers above are from the fixed version.

## What to do next
- **Put 8 m cells in the Terrain GDD as the starting format**, with 4 m cells and a staggered refresh as the fallback if accuracy matters more. The technical-director's sign-off on the region format and terrain query contract (C3) is still pending; this note is an input to it.
- **Add a symmetry rule to the GDDs:** evaluate each pair in a canonical order (lower unit id first) so A-sees-B always equals B-sees-A, and test it.
- **Decide an accuracy tolerance** (the criteria allowed up to 3% as marginal). A single deterministic function that is used identically by every system makes small disagreements a presentation matter, not a fairness bug, but only if symmetry holds.
- **Re-run this on the real hand-authored grid** once the region exists, with its real cover rule set, before GDD 3 is approved.
- P1's note applies to the rest: unit-count targets (D2) and minimum-spec hardware (D3) are still undecided.

> Spike results inform decisions; they do not make them. The developer decides whether PARTIAL is enough to proceed with GDD 3.
