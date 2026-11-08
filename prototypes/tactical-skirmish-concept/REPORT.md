<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Do positioning, facing, range, line of sight and ammo make fights feel decided by the player's own choices? -->
<!-- Date: 2026-11-07 -->

# Concept Prototype Report: Tactical Skirmish

> **Date**: 2026-11-07
> **Prototype Path**: Engine (Godot 4.7.2, GDScript)
> **Concept File**: design/gdd/game-concept.md

---

## Hypothesis

If the player positions and faces a squad against an enemy squad using range, line of sight and ammo, they will feel their positioning decided the fight. True if, over 5 skirmishes, the player can say why they won or lost and changes their positioning on the next attempt within 2 minutes. False if outcomes feel random or the player just attack-moves and ignores facing and cover.

---

## Riskiest Assumption Tested

The 30-second tactical loop (Pillar 2, Hands-On Command) is satisfying on a 2D radar-symbol view. **Held up:** cover and positioning mattered for both sides. **Caveat:** one internal playtester (the developer), and the number of skirmishes played was not recorded.

---

## Approach

A 4 v 4 skirmish in one arena with line-of-sight-blocking walls. Units fire only inside weapon range, firing wedge and line of sight, turn at a limited rate, and have 24 rounds with no resupply. The enemy advances, engages the nearest visible unit, and takes cover when hurt.

**Path chosen:** Engine
**Reason for path:** The hypothesis is about how real-time positioning and facing feel, and a browser build would distort that.

**Shortcuts taken (intentional):**
- Hardcoded values
- One unit type with placeholder diamond symbols
- No menus or audio
- No plain-data simulation core (prototype code is throwaway)
- No throughput measurement (that is the separate technical spike)

---

## Result

**Observed from the user (debrief):**
- **Best moment:** Both sides used cover. The user wants the AI to be smarter in future ("both covered, but for future we need to make it smarter").
- **Controls:** "control looks good", "formations are okay". The Total War-style line drag (drag line = frontage, units face perpendicular) was added mid-session at the user's request, and the user said "now I can setup units better".
- **Worst moment:** "doesn't look like a tank, no turret, no rotations". The unit symbol is a diamond with a thin facing line, so the symbol itself never rotates.
- **Surprise:** Nothing.
- **Hypothesis check:** CONFIRMED.

**Verified by the headless self-test (not by play):**
- Simulation, line of sight, firing, ammo, enemy AI and win/lose run without errors or NaNs.
- A stall bug was found and fixed: units oscillated at wall corners because waypoints were re-picked every tick.
- Scripted dummy players (passive, or standing in a line) lose almost every run, so balance is untuned.

**Not recorded:** how many skirmishes were played, and how many were won.

---

## Metrics

| Metric | Value |
|--------|-------|
| Path used | Engine |
| Iterations to playable | 1 round after handoff (a path fix), plus 1 control revision |
| Prototype duration | One session (not timed) |
| Playtesters | 1 internal (the developer) / 0 external |
| Feel assessment | Controls good; formations okay; units don't read as tanks (no turret, no visible rotation) |
| Hypothesis verdict | CONFIRMED by the developer's own judgement; CD-PLAYTEST: the evidence does not reach the 5-skirmish pass condition, so Pillar 2 is **not yet validated** |

---

## Recommendation: PROCEED

Cover and positioning decided fights for both sides and the controls feel good, so the core loop is worth designing properly. The visuals and AI are design and art problems, not reasons to drop the concept. The reason was written from the user's observations, and the user did not give a separate one-sentence reason.

**Limits of this evidence:** a single playtester who is also the developer, no recorded skirmish count or win rate, untuned balance, and nothing about behaviour at scale (hundreds of units, skip-time) or under network latency.

**CD-PLAYTEST: CONCERNS** (creative-director, 2026-11-07). The user chose **Accept with noted concerns**: PROCEED stands for the next design steps, but Pillar 2 is not recorded as validated.

Why the director returned CONCERNS (not REJECT — the fantasy is present):
- The hypothesis's own test was not run: the skirmish count, repositioning between attempts, and win/loss explanations were not recorded, and the only tester built the prototype.
- Only some variables are evidenced. Cover and line of sight are evidenced; range is implied; ammo shows no sign of shaping a decision; facing may have come for free from the line-drag formation tool rather than from a choice.
- Balance is untuned, so "decided by my choices" is unproven without a win rate.
- Pillar drift to watch: independent hull and turret rotation could pull Pillar 2 toward micro (stays on-pillar only if the turret auto-tracks inside its wedge and the player's decision stays hull facing and position); "doesn't look like a tank" runs into the Living Radar rule "nothing decorates", so it is a visual-direction question, not art polish.

**Blocked until a re-test passes:**
- Recording Pillar 2 as validated in any gate or milestone document.
- Locking combat tuning values (ammo, turn rate, range, wedge angle) in a GDD's Tuning Knobs.
- Committing hull and turret rotation as a mechanic.

**Re-test conditions:**
1. At least one playtester who did not build the prototype.
2. Skirmish count and win rate recorded, with the 5-skirmish protocol actually run.
3. Balance tuned first so a competent human can win.
4. Facing and ammo use observed directly: was facing chosen on purpose beyond what the line drag gave, and did low ammo change a decision?
5. After each skirmish, ask "why did you win or lose?" and log whether the next positioning changed.

**Scope:** PROCEED covers only the 30-second tactical loop. It does not validate Pillars 1, 3, 4 or 5, Fellowship, the live-map hook, or the MVP core hypothesis.

**Routing:** game-designer (hull/turret pillar check; protect the frontage-line pattern; keep the fighting AI separate from the Pillar 4 standing-order AI); art-director via `/art-bible` (tactical-zoom richness vs one visual grammar); producer (schedule the re-test before Pillar 2 is marked validated or combat tuning is locked).

---

## If Proceeding

- **Core tuning values discovered:** None recorded. Balance is untuned; tune it in the tuning knobs once a system GDD exists.
- **Assumptions confirmed:** Positioning, cover and line of sight matter. A Total War-style frontage line is a good way to place units.
- **Assumptions disproved:** Plain radar diamonds are not enough at tactical zoom. Units need to read as vehicles with visible hull and turret rotation. This comes from one tester, so treat it as a signal, not proof.
- **Emergent mechanics:** Cover-seeking on both sides created reposition-or-flank decisions worth formalizing.
- **Design notes carried forward:** a smarter AI (the current one only advances, engages and takes cover when hurt); other tank types (for `/map-systems`); independent hull and turret rotation (a facing mechanic, not only art).

**Next steps:**
1. `/design-review design/gdd/game-concept.md`
2. `/gate-check`
3. `/art-bible` (vehicle readability and rotation at tactical zoom)
4. `/map-systems`
5. `/design-system [mechanic]` (use learnings in Tuning Knobs and Formulas sections)
6. Technical spikes P1 to P3 from the technical-director (throughput, geodata and line of sight, map rendering and zoom)

---

## If Pivoting

Not applicable: the verdict is PROCEED.

---

## If Killing

Not applicable: the verdict is PROCEED.

---

## Lessons Learned

- **What assumptions were broken by actually building this?**
  Greedy per-tick waypoint selection oscillates at wall corners. Production movement must commit to a route until it is reached.

- **What surprised us that didn't show up in the brainstorm?**
  Players react to unit identity and rotation straight away: the worst moment was that units did not look like tanks and did not visibly rotate. This is a single developer's reaction, but it points the same direction as the art-director's concern that radar symbols alone may not deliver the hands-on fantasy at tactical zoom.

- **What would we test differently next time?**
  Record the number of skirmishes played and won. Tune balance first so a competent human can win. Add a second playtester who did not build it.

---

> *Prototype code location: `prototypes/tactical-skirmish-concept/`*
> *This code is throwaway. Never refactor into production.*
