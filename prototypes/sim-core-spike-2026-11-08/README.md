<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically? -->
<!-- Date: 2026-11-08 -->

# Sim Core Spike (P1)

**PROTOTYPE - NOT FOR PRODUCTION.** Throwaway. Never import into production; production is written from scratch.

*Created: 2026-11-08 · Status: **concluded** (PARTIAL; see [SPIKE-NOTE.md](SPIKE-NOTE.md))*

## Question
Can a plain-data, fixed-point, fixed-tick simulation core written in GDScript run hundreds of units headless fast enough and deterministically, or must it move to C# or GDExtension?

## Pass criteria (set before any run)
- **Determinism:** same initial state + command log + seed gives an identical state hash on 5 runs; a snapshot taken mid-run and restored gives the same final hash as an uninterrupted run. Not 100% identical = FAIL.
- **MVP throughput:** 300 units, 10 Hz, 1 hour of world time (36,000 ticks): PASS at 30 s or less, MARGINAL 30-90 s, FAIL over 90 s.
- **Real-time headroom:** mean tick at most 1 ms and p99 at most 3 ms at 300 units.
- **Reported only:** scaling at 100/300/600/1000 units, per-phase cost, projected 8-hour skip-time catch-up at 300 units.

## Caveats
- Cross-OS determinism cannot be tested from one machine. The direction lookup tables are generated with floats at startup (an assumption, not a proof).
- The workload is representative, not the game: units advance, engage the nearest enemy in line of sight, fire, die and respawn so load stays constant.

## How to run
```bash
G=/Applications/Godot.app/Contents/MacOS/Godot
"$G" --headless --path prototypes/sim-core-spike-2026-11-08 --import
"$G" --headless --path prototypes/sim-core-spike-2026-11-08 -s res://bench.gd
# options after --:  --hour-ticks=N  --quick
```

## Findings
PARTIAL. Determinism and save/load PASS; 300-unit throughput MARGINAL (55 s for 1 hour of world time); mean tick 1.95 ms at 300 units (fails the 1 ms bar). Comfortably fast at MVP scale (0.33 ms at 100 units). Details and next steps in [SPIKE-NOTE.md](SPIKE-NOTE.md).
