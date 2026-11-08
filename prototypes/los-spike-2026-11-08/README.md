<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference? -->
<!-- Date: 2026-11-08 -->

# Line of Sight Spike (P2)

**PROTOTYPE - NOT FOR PRODUCTION.** Throwaway. Production is written from scratch.

*Created: 2026-11-08 · Status: **concluded** (PARTIAL; see [SPIKE-NOTE.md](SPIKE-NOTE.md))*

## Question
Can a heightfield-plus-cover line-of-sight query in GDScript over a hand-authored-style grid be fast enough for hundreds of units and accurate against a supersampled reference?

## Pass criteria (set before any run)
- **Accuracy:** against a 4x-supersampled reference ray march on the same grid: at most 1% disagreement PASS, up to 3% MARGINAL, more FAIL. At 4 m, 8 m and 16 m cells.
- **Cost:** 300 units x 4 candidate queries refreshed every tick averages 4 ms or less per tick = PASS. Passing only at a lower refresh rate (every 4th tick) = MARGINAL. Otherwise FAIL.
- **Reported only:** memory per grid; cost with 1 candidate per unit.

## Caveats
The accuracy test compares the stepping algorithm against a finer one on the same grid; it does not measure how well a grid represents real terrain. The terrain is synthetic (integer value noise plus random cover blocks), standing in for a hand-authored region.

## How to run
```bash
G=/Applications/Godot.app/Contents/MacOS/Godot
"$G" --headless --path prototypes/los-spike-2026-11-08 --import
"$G" --headless --path prototypes/los-spike-2026-11-08 -s res://bench.gd
```

## Findings
PARTIAL. Cost is low (2.5 ms per tick for 300 units x 4 candidates at 8 m cells: PASS). Accuracy vs the supersampled reference is MARGINAL at 4 m and 8 m (1.4% and 2.6% disagree) and FAILS at 16 m (5.4%). Symmetry was not tested. Details in [SPIKE-NOTE.md](SPIKE-NOTE.md).
