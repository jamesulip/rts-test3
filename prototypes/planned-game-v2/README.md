<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Does the planned MVP (deterministic command-driven simulation, viewer projection, art-bible look) play as intended? -->
<!-- Date: 2026-11-08 -->

# Planned Game v2 (prototype)

**Status: BUILT, NOT YET PLAYTESTED BY A HUMAN.** Built autonomously overnight on 2026-11-08 at the user's request. Automated checks pass; whether it is fun is unknown.

## Hypothesis
If the planned MVP architecture is built as designed (plain-data deterministic simulation, commands as the only input, a viewer projection as the only read path, a few standing orders, the Living Radar look), a player commanding a ~12-unit force against an AI will make positioning and order decisions that feel meaningful, and will understand why they won or lost.

True if: in 3 games the player can say why they won or lost, uses frontage lines and at least one standing order without prompting, and never asks "how did the enemy know that?".
False if: the player only right-clicks, ignores standing orders, or the fog/projection makes play feel blind rather than tense.

## How to run
Godot 4.7.2 (not on PATH):

    /Applications/Godot.app/Contents/MacOS/Godot --path prototypes/planned-game-v2

Or open `prototypes/planned-game-v2/project.godot` in the editor and press F5. The briefing screen lists the controls.

## Controls (also on the briefing screen)
| Input | Action |
|---|---|
| Left-click / drag box | Select (Shift adds). Ctrl+A all, T armor, I infantry, Esc clear |
| Right-click | Move (a group spreads on a small grid) |
| Right-drag | Frontage line: units spread along it and face away from it |
| S / C | Stop / toggle hold fire |
| H / W / A / F | Standing orders: hold / withdraw when hurt or out of ammo / advance if clear (toward the mouse point) / clear |
| Space | Pause toggle (OFF by default, per the Pillar 2 re-test condition) |
| 1 / 2 / 3 | Speed 1x / 2x / 4x |
| Top-left buttons | ZOOM - / + / MAP, SPEED PAUSE / 1x / 2x / 4x |
| + / - keys, mouse wheel, trackpad pinch, two-finger scroll | Zoom (4 bands: whole map, wide, tactical, close) |
| Arrows, middle-drag, click or drag the minimap, Home | Pan, whole map |

Goal: hold 2 of 3 objectives for 60 s, or eliminate the Amber Force. Playtest notes go to `user://playtest-v2.log` (Godot user data folder) when a game ends.

## What is in it
| File | Role |
|---|---|
| region.gd | Synthetic 4 km "Test Region" (NOT a real place): 8 m grid, heights, cover, roads, A* on a 64x64 coarse grid, LOS (canonical pair order) |
| sim.gd | Plain-data simulation: 10 Hz tick, integer mm, seeded RNG in state, validated commands, one fire resolver, objectives, victory, hash, snapshot/restore |
| vproj.gd | Viewer projection: own units in full, enemies only in line of sight (position, kind, facing), stale last-known marks, coarse force-aggregate rings |
| ai.gd | Objective-priority planner for the enemy; reads only its projection, acts only via commands |
| main.gd | Input, camera, art-bible drawing (Shield and Swallowtail plates, selection brackets, dashed standing band, hollow stale plates, territory tint, HUD, briefing/end) |
| selftest.gd | Headless checks |

## Automated results (2026-11-08, Godot 4.7.2, Apple M5 Pro)
`godot --headless --path prototypes/planned-game-v2 -s res://selftest.gd` -> **20 passed, 0 failed**:
region deterministic; paths reachable; commands for unowned units rejected; LOS symmetric (0 of 3,000 pairs differ); two identical 2,500-tick runs give the same hash (with combat); different seed differs; save, load and continue equals an uninterrupted run; projection carries only public keys; every visible enemy is in sight; changing hidden enemy hp/ammo/orders does not change the viewer's view (both factions); every one of 6 AI-vs-AI games ended with a result; 100 units run at about 1.2 ms per tick; no unit freezes on cross-map move orders (0 of 96 over 8 seeds); no ordered unit idles 300 ticks in AI-vs-AI games; planning a 12-unit move order takes ~4 ms.
`-- --smoke` runs the main scene headless with simulated input: 12 units selected, 3 player commands accepted, 0 rejected, drawing runs without errors.
Shots now travel as visible projectiles (visual only: the sim resolves each shot at fire time, so a unit can die a moment before the projectile lands). Screenshots (`screenshots/play-0*.png`) were captured from a real windowed run and looked at by the author: base start, fight, national zoom, briefing, end screen. **They are AI-vs-AI states** (`--shot` turns the AI on for both sides), which is why selected units read "MOVING WITHDRAW"; when you launch normally your force starts idle with no orders.

## Known limits and things that look wrong
- **Projection is not the only read path in the UI** (prototype shortcut): tracers and death rings read `sim.events`, the HUD reads objective and hold counters, and the end screen reads `sim.stats` and the enemy's survivor count. It does not leak hidden information during play here because there are only two factions (every shot or death involves one of your units), every weapon range is shorter than every sight radius, and LOS is symmetric; the end-screen enemy count is a deliberate post-game reveal. Enemy AI does go through the projection only.
- AI-vs-AI is **not balanced**: after the pathing fix Azure (faction 0, which thinks first each cycle) won 6 of 6 seeds (earlier, with the stuck-unit bug, Amber won 5 of 6). Cause not investigated; one seed ended in a time-limit stalemate (1v3).
- No unit-unit collision; units pile up at arrival points (move groups use a small grid offset to soften this).
- Brute-force target search (fine at 100 units); `isqrt` uses float sqrt (not proven cross-platform deterministic; cross-OS determinism untested).
- Terrain is random noise plus scattered blocks. It reads as "buildings" but is not designed ground, so it says little about cover play.
- Plates stack in a pile when many stale contacts share a place; stale labels overlap.
- Tracers from many shooters at one target draw as a fan; readable but busy.
- HUD text is the engine's fallback font, not the art bible's typography. Art-bible open items (dashed band spec, stale plate checks, hatching) were not resolved here.
- Human feel (pace, readability, whether orders matter, whether the fog feels fair) is **untested**.

## Findings
(To be filled after a human playtest. Run `/prototype` debrief or tell Claude what you saw.)

## Change log
- 2026-11-08 (later): projectiles instead of instant lines; on-screen zoom and speed buttons, trackpad zoom, minimap click-pan; **stuck-unit fix**: path grid refined from 64 m to 32 m cells that must be fully walkable (was 60% walkable, so waypoint segments clipped buildings), bases clear a larger area (spawns could land inside blocked cells), destinations snap to walkable ground, groups share one path search, intermediate waypoints count as reached within 12 m.
