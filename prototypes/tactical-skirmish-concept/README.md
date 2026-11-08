# Tactical Skirmish Prototype

**PROTOTYPE - NOT FOR PRODUCTION.** Throwaway code. Never import from or into production.

*Created: 2026-11-07 · Status: **concluded** (PROCEED, creative-director CONCERNS; see [REPORT.md](REPORT.md))*

## Hypothesis

If the player positions and faces a squad against an enemy squad using range, line of sight and ammo, they will feel their positioning decided the fight.

- **True if:** over 5 skirmishes the player can say *why* they won or lost and changes their positioning on the next attempt within 2 minutes.
- **False if:** outcomes feel random, or the player just attack-moves and ignores facing and cover.

Riskiest assumption under test: the 30-second tactical loop is satisfying on a 2D radar-symbol view (Pillar 2, Hands-On Command).

## How to run

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path prototypes/tactical-skirmish-concept
```

Or open `prototypes/tactical-skirmish-concept/project.godot` in the Godot editor and press Play.

Headless self-test (no window; prints two scripted scenarios):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path prototypes/tactical-skirmish-concept -- --selftest
```

## Controls

| Input | Action |
|-------|--------|
| Left click / drag | Select a unit / box-select (Shift adds) |
| Right click | Move selected units |
| Right drag | Total War style: draw a line; units spread evenly along it and arrive facing perpendicular to it (drag left to right = face up). A live preview shows each slot and facing |
| H | Toggle hold fire on selected (save ammo, ambush) |
| A | Select all |
| R | Restart |

## What the rules are

- 4 vs 4, one flat arena with walls that block line of sight and movement.
- Units fire only at enemies that are inside weapon range, inside their firing arc (the wedge), and in line of sight. They turn at a limited rate, so facing matters.
- Hit chance falls with distance. Each unit has 24 rounds and no resupply.
- Enemy AI: advance, engage the nearest visible target, take cover when hurt.

## Explicitly cut

Map, strategic view and zoom, objectives, standing orders, save/load, multiple unit types, supply, multiplayer, audio, menus, architecture, and throughput measurement (that is the separate technical spike).

## Findings

Verdict: **PROCEED**, with CONCERNS from the creative-director. Pillar 2 is **not yet validated**.

- Cover and line of sight mattered for both sides. The frontage-line drag fits the pillar.
- Worst moment: units do not read as tanks (no turret, no visible rotation).
- Needed before Pillar 2 counts as validated: a playtester who did not build it, a recorded skirmish count and win rate, tuned balance, and direct observation of facing and ammo use.

Full detail and the re-test conditions are in [REPORT.md](REPORT.md).
