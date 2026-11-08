# Decisions made autonomously while the user slept — 2026-11-08

The user asked for autonomous overnight work and a playable "planned game" build, and said to decide what would otherwise need their input. Every decision below was made by Claude on the user's behalf. **Each one is overridable.** Where a decision was a creative or sensitive call, the alternative is listed.

| # | Decision | Alternatives | Why this one | Revisit when |
|---|----------|--------------|--------------|--------------|
| 1 | **A5: one player commands a small owned force of ~12 units** (a company: infantry squads plus armor) | A larger force with sub-commanders; variable size by rank | The creative-director's recommendation; the only scale the skirmish prototype supports | Before the Unit, Scenario & Tuning Data GDD |
| 2 | **A9: enemies see nothing about your online/offline presence** | Delayed or aggregated presence; fully public | Recommended in the concept review; presence would reveal raid targets; irrelevant in single-player but the projection is built that way | Before the Viewer Projection GDD |
| 3 | **D2 unit counts: about 12 per side at start (24 total) for the playable build; 100 units as the stress target** | Larger MVP counts | P1 showed 100 units costs 0.33 ms per tick; 300 units is marginal | Before the next throughput spike |
| 4 | **D3 minimum spec: the developer's current Mac, unmeasured** | A named lower-spec machine | No target hardware has been chosen | When a release platform is chosen |
| 5 | **Region: a clearly labelled SYNTHETIC placeholder region ("Test Region")**, not a real place | Invent a "traced" region from memory | Inventing real geography would misrepresent the Philippines and break the creative-director's "trace, don't compose" condition. The user still chooses and traces the real region. | When the user picks the real MVP region |
| 6 | **Faction names: "Azure Force" (player) and "Amber Force" (enemy)** as neutral fictional working names | Any other neutral fiction | Matches the art bible's hue names; no real flags or insignia | Before any outside playtester sees a build |
| 7 | **Pause toggle exists and is OFF by default** (SPACE toggles) | No pause at all | Honours the Pillar 2 re-test condition (at least one condition with pause off) | Re-test planning |
| 8 | **Standing orders: hold, withdraw-at-threshold, advance-if-uncontested** (A2 limited offensive verbs), doctrine-bound with an 80% accuracy modifier ("visibly weaker") | Hold and withdraw only | A2 confirmed by the user | GDD 11 |
| 9 | **The build is a throwaway prototype in prototypes/planned-game-v2/**, not production code | Starting src/ production code | Production needs the GDDs first; prototype rules forbid reuse | After GDDs |
| 10 | **No git commits, pushes or deletions** | — | CLAUDE.md: no commits without user instruction | — |

## Not decided (still the user's)
Which real region the MVP uses and its sensitivity and licensing check; the technical-director's sign-off on the region format; A4, A6, A7, A8; whether Challenge or Fellowship is ranked first; the outside tester for the Pillar 2 re-test; any commit or push.

## Build-time decisions (added during the overnight build)
| # | Decision | Why |
|---|----------|-----|
| 11 | Win rule: hold 2 of 3 objectives for 60 s, elimination, or a 20-minute tick limit (more objectives, then total hp) | Simple, readable, fits Pillar 5 framing for a single-player slice |
| 12 | Enemy AI (Amber) plays the objective-priority planner; armor to Crossroads, infantry split; reads only its viewer projection | Exercises the projection contract and keeps the AI honest |
| 13 | Public force-aggregate rings (1 km cells, 1-2 / 3-5 / 6+) shown for out-of-sight enemies | Applies the user's earlier decision (position public, composition hidden) coarsely |
| 14 | Prototype tuning (speeds, ranges, damage, accuracy 70-75%, cover 0/15/30/45%) is placeholder, hardcoded as data tables in sim.gd | Prototype rules allow it; real values belong to the Unit & Tuning GDD |
| 15 | Screenshots saved under prototypes/planned-game-v2/screenshots/, not production/qa/evidence/ | Prototypes must not write outside prototypes/ |
