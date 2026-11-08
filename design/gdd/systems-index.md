# Systems Index: Philippine Conquest *(working title)*

> **Status**: Draft
> **Created**: 2026-11-08
> **Last Updated**: 2026-11-08
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

Philippine Conquest is a persistent faction war on a live 2D map of the Philippines, where each player commands a small owned force hands-on inside a war that keeps moving when they log off. The mechanical scope is three things at once: a **deterministic, server-ready simulation** (plain data, fixed tick, commands as the only input), a **tactical layer** where positioning, facing, line of sight and ammo decide fights (Pillar 2), and a **live-map layer** where force positions are public and intent is hidden (Pillar 1). Pillars 3, 4 and 5 (owned forces, standing orders that run offline, shared faction victory) add economy, offline resolution and cooperation systems that the single-player MVP only partly exercises. The index holds **42 systems**: **16 MVP**, 15 Vertical Slice (12 single-player in VS-A, 3 multiplayer in VS-B), 9 Alpha and 2 Full Vision.

> **TD-SYSTEM-BOUNDARY: CONCERNS** (technical-director, 2026-11-08). The decomposition is sound at its root; every concern is an edit to this index or a scope statement the named GDD must carry. Applied here: Visibility split into Line of Sight & Detection (6) and Viewer Projection (7); the tick has one owner (1); a Scenario Definition now lives in the MVP (inside system 2); the multiplayer host (26) and input (13) moved out of Core; edges added (Combat→Terrain, Enemy AI→Unit Behaviour & Standing Orders, Command System carries the command log); bottlenecks widened. Contact & Engagement Management (19) depended on A1 and A3, which the user has now confirmed, so GDDs 17, 18 and 19 are unblocked on those decisions.
>
> **PR-SCOPE: UNREALISTIC** for the original 23-system MVP (about 19 months expected). **Revised and adopted 2026-11-08:** the MVP is thinned to 16 systems by folding Time Model and Factions & Ownership into the Simulation Core (1), Scenario Definition into Unit Data (2), the command log and playtest logging into the Command System (4), ammo and resupply into Combat (9), frontage ordering into Input (13), and the terrain and territory rendering into Map View (14); the geodata pipeline moves to Alpha (30) behind a **hand-authored MVP region**. The producer's re-baseline is **10–15 months for the MVP (plan on 12)** with a **Skirmish checkpoint at 5–7 months** (systems 1, 2, 3, 4, 6, 8, 9, 10 plus **thin versions of 7 Viewer Projection, 11 Unit Behaviour and 13 Input & Selection with the frontage line**, minimal HUD, presentation with placeholder combat and alert cues, and a basic enemy AI; the producer decides the schedule effect of adding the thin 7, 11 and 13). Cumulative tiers move out by the same 2–4 months. Estimates are uncalibrated until velocity is tracked. `modes.rigor` stays `full` by the user's choice.
>
> **Confirmed by the user 2026-11-08:** A1 one combat resolver (an event-driven strategic layer; any contact runs the full tactical simulation, never aggregated combat); A2 limited offensive standing-order verbs (for example advance if uncontested and retake a lost objective: doctrine-bound and visibly weaker than a human); A3 two clocks (fast strategic, 1:1 tactical on contact); A10 pillar tiebreak order 2 > 1 > 5 > 3 > 4. **Still working assumptions, NOT confirmed:** A4 a personal replacement quota earned from faction contribution (system 20 waits on it); A6 abstract sealift links between ports with no naval combat (system 31 waits on it). The concept review (`design/gdd/reviews/game-concept-review-log.md`) is still NEEDS REVISION: A1, A2, A3 and A10 are now decided, while A4 to A9 are not (A5 what one player commands, A7 campaign lifecycle, A8 how Fellowship is delivered and A9 what enemies see of presence also remain unconfirmed).
>
> **CD-SYSTEMS: CONCERNS, revised 2026-11-08** (creative-director). The decomposition is sound and every MVP system traces to a pillar. Applied here: thin 7, 11 and 13 added to the Skirmish checkpoint; Faction Command split (28 is now the simulation and faction-viewer half in VS-A, new 40 carries its replication in VS-B) and Allied AI (29) moved to VS-A, so Pillar 5's joint-push test gets a single-player signal and A4 has something to measure; new 41 Reconnaissance & Intelligence (Alpha) owns how intent leaks, and 28 owns faction-internal shared intent; new 42 Combat & Alert Sound Cues in VS-A with placeholder cues in MVP presentation (15). Decisions made by the user: the public strategic marker is a **force aggregate with position public; heading, destination and composition hidden** (GDD 7 carries that rule and must also define where the public regime ends and line-of-sight gating begins inside the MVP region); at least one condition of the Pillar 2 re-test runs with **pause off**, because the persistent game has none.
>
> **What the MVP tests (honest scope):** Pillar 2 fully; Pillar 1 on the map layer in one region; Pillar 4 in session only (one front on hold and withdraw orders while you fight another); Pillar 3 only as in-match loss aversion (no reinforcements until VS-A, system 20); Pillar 5 and Fellowship not at all.
>
> **Hand-authored MVP region: creative-director ruling ACCEPT WITH CONDITIONS** (technical-director sign-off on the format and the terrain query contract C3 is still pending). Conditions: (1) trace, don't compose: coastline, road topology, rivers, settlements and major elevation stay at real positions and scale, balance comes from the scenario (system 2) and never from moving geography, and the cover and elevation grid is derived from real land use by a written rule set, with no cover placed for gameplay reasons; (2) a real, nameable place, chosen by the user, with a sensitivity check; (3) big enough for Pillars 1 and 4: several objectives and approach routes, at least two separate front areas, one coastal edge and one road chokepoint; (4) recommended: show the whole country as a static non-playable frame in the strategic view; (5) the geodata pipeline (30) is critical to Pillar 1 at Alpha and not a cuttable tool, with a time-boxed P2 look at data-derived terrain before VS-A closes and a Pillar 2 re-test on pipeline output when it lands; (6) provenance: hand-tracing from OpenStreetMap still yields an ODbL-derived database, a licensing question for the user or legal.
>
> **Unconfirmed decisions in contracts:** A1 is now confirmed (2026-11-08), so GDD 9 may fix the full one-resolver contract (C5). The MVP region and the faction names are user decisions that systems 2 and 3 must not make, and faction names and insignia must be neutral fiction before any outside playtester sees a build.

### System notes (rationale and relationships)

**MVP systems**

- **1. Simulation Core & Spatial Model.** The Foundation. It owns the world-state store, the tick counter and loop, the fixed phase order within a tick, fixed-point units (a "must", per concept review item B10), named deterministic RNG streams, the spatial index, the per-tick event list, and, for the MVP, a single clock with pause and speed and the faction and ownership identifiers. The rule that matters most: each unit field has exactly one writing system, and all simulation state lives in this store, which is what lets Save/Load stay small and a server own the simulation later. It is the biggest GDD and the main God-Object risk, so its GDD carries two internal sections (Kernel and Spatial).
- **2. Unit, Scenario & Tuning Data.** The data schema for unit types, weapons, ammo and tuning values, plus the scenario definition the MVP secretly needs (starting forces, objectives, region bounds, win and lose rules). Loaded at initialisation into immutable plain-data tables. A bottleneck: movement, combat, economy and progression all read it. Gameplay values stay data-driven per the coding standards.
- **3. Terrain.** The runtime terrain query model: height, cover, concealment, passability, plus a strategic road, region and port graph. In the MVP the region is **hand-authored** (real coastline and roads traced, a hand-made cover and elevation grid), which removes the geodata research risk (prototype P2) from the critical path. It owns the cover and concealment tables that both Line of Sight (6) and Combat (9) read.
- **4. Command System.** The command envelope (issuer, faction, apply tick, type, payload), validation against the issuer's view, the per-unit order queue as data, and the command log that doubles as the replay and playtest record (skirmish count, win rate). It is the only external mutation path: every non-player decider (enemy AI, standing orders) emits commands through it.
- **5. Save/Load & Snapshot.** A versioned snapshot of the world store. It stays small only if the "all state in the store" contract holds. Derived caches (spatial index, path and line-of-sight caches) are rebuilt, never saved. The save format and the replication snapshot should be the same format.
- **6. Line of Sight & Detection.** Pure computation over terrain and positions, with line-of-sight refresh at a lower rate than the tick. Combat, behaviour and the AI read it. High risk until a tactical terrain source and a throughput budget exist.
- **7. Viewer Projection.** The server-ready seam: given simulation state and a viewer (a player, a faction or the AI), it returns what that viewer may know. Positions are public on the strategic layer, intent (orders, destinations, timing) is hidden, and unit visibility inside an engagement is gated by line of sight. The UI, the enemy AI and (later) replication all read only through it, so single-player screens can never see hidden intent. **MVP rules this GDD must carry:** the public strategic marker is a force aggregate with position public and heading, destination and composition hidden; where the public regime ends and line-of-sight gating begins inside the single MVP region (the engagement definition arrives with system 19 in VS-A); and any intent line is owner-only.
- **8. Movement & Pathfinding.** Tactical pathfinding over plain data (no engine navigation services inside the simulation), facing, and route commitment (the prototype's wall-corner oscillation is the standing lesson). The strategic road graph and sealift extensions are scope statements for the same GDD. Frontage placement geometry lives here, and its UI lives in Input (13).
- **9. Combat Resolution.** One resolution function (shooter, target, weapon, terrain query, RNG stream) used the same way live, offline and by the AI (A1). Range, firing arc, line of sight, hit chance, damage, **ammo consumption**, and resupply at owned objectives. Exactly one owner of the ammo field, so Combat and Ammo are no longer a cycle. Combat tuning values stay unlocked until the Pillar 2 re-test passes.
- **10. Territory & Objectives.** Capture by presence, contested state, faction-wide ownership, and the scenario's victory rule. Depends on positions and ownership and consumes combat events; it does not depend on pathfinding.
- **11. Unit Behaviour & Standing Orders.** Level 0 execution (engage, take cover, face, hold, withdraw) shared by player-ordered units, the enemy AI and standing orders, plus a thin posture layer: two standing-order verbs (hold, withdraw) with defined triggers. Offensive standing-order verbs wait on decision A2. Building behaviour once and sharing it is the point.
- **12. Enemy AI.** An objective-priority planner (choose an objective, assign squads, retreat on losses) that reads only its faction's Viewer Projection view, so it cannot see hidden intent. It selects postures from system 11 and issues commands through system 4. It is the hardest part of an RTS to make good and stays deliberately simple in the MVP.
- **13. Input & Selection.** Client-side: selection, box select, hover, the right-drag frontage line and its preview, order queue, hotkeys. It reaches the simulation only by issuing commands through system 4, and it is never simulation state.
- **14. Map View.** The strategic overview and the tactical view of the one region, camera and zoom, and the rendering of terrain, territory tint, borders and the active-front split border, per the art bible. Thin in the MVP: the strategic view is a read-only overview that can issue group move orders.
- **15. Unit & Combat Presentation.** Plates, glyphs, casing, tactical detail, rotation and the combat feedback (tracers, hit, loss mark, alert ticks), per the art bible, including colourblind-safe cues from day one. Reads only through Viewer Projection. The MVP includes placeholder combat and alert sound cues, because judging combat feel in silence risks false negatives on Pillar 2.
- **16. HUD, Panels & Menus.** Force list, selection panel, status strip, event feed, scale cluster, an end-of-match summary (answers "why did you win or lose?" for the re-test), a controls and help screen, and minimal menus and settings.

**Vertical Slice, Alpha and Full Vision systems**

- **VS-A, single-player front (17 to 25, 28, 29, 42).** Time Model & Clocks (the two-clock mapping, A3); Offline Resolution & Skip-Time (catch-up scheduling that contains zero combat rules: it schedules and Combat resolves, A1); Contact & Engagement Management (conditional on A1 and A3, and only needed once the map is too large to run everywhere at tactical resolution); Economy & Reinforcements (A4); After-Action, Event Feed & Review; Briefing & Scenario Setup UI; Accessibility (settings and options; the colourblind rules are already built into MVP rendering); Tutorial & Onboarding; Faction Identity & Premise (moved up from Alpha: a fictional two-faction war on a real country needs its premise and insignia settled before anything is shown publicly). Also in VS-A: Faction Objectives & Shared Intent (28, the simulation and faction-viewer half of Fellowship and Pillar 5, with its replication in 40), Allied AI (29, so the joint-push reward has a single-player signal and A4 something to measure), and Combat & Alert Sound Cues (42).
- **VS-B, multiplayer skirmish (26, 27, 40).** Multiplayer Server & Replication (server-authoritative; it wraps the simulation and replicates serialised Viewer Projection output, not nodes); Session, Roster & Presence (disconnect grace period, leak rules); Faction Command Replication (40, carries system 28's shared objectives and vision across the network, A8).
- **Alpha (30 to 37, 41).** Geodata Import Pipeline (an offline tool, not a runtime system; replaces the hand-authored region for the whole country); Inter-island Transit (abstract sealift, A6; moved out of the Vertical Slice because one landmass is enough until then); Logistics & Supply Network; Progression & Veterancy; Campaign Lifecycle (A7); Population & Faction Balance; Audio; Server Operations & Persistence (hosting, storage, accounts, moderation: previously missing from every tier). Reconnaissance & Intelligence (41): how intent leaks through scouting and observed preparation (Pillar 1's own design test), where faction-internal shared intent (system 28) meets it.
- **Full Vision (38, 39).** Air, Naval & Missile Domains (serve no pillar yet), and Telemetry & Analytics.

### Boundary contracts (from TD-SYSTEM-BOUNDARY; defined in the owning GDD, then the simulation ADR)

| ID | Owner | Contract |
|---|---|---|
| C1 World State & Tick | 1 | Entity IDs, plain-data components, one writer per field, fixed phase order (apply commands, deciders 12/11, movement 8, line of sight 6, combat 9, territory 10, emit events), named RNG streams, fixed-point units, no Node or engine service references, a per-tick event list |
| C2 Command Envelope | 4 | {issuer, faction, apply_tick, type, payload}; the only external mutation path; serialisable for log and replay |
| C3 Terrain Query | 3 | Pure functions at a fixed-point coordinate (height, cover, concealment, passability); strategic graph; immutable at runtime |
| C4 Viewer Projection | 7 | View(state, viewer) returns what that viewer knows; the only read path for UI, AI and replication |
| C5 Combat Resolver | 9 | One resolution function, online, offline and for the AI; target selection lives in 11 |
| C6 Unit & Tuning Schema | 2 | Unit fields, weapon and ammo data, scenario data, loaded into immutable tables |
| C7 Faction & Ownership | 1 | Faction IDs, force membership, hostility; read by 7, 10, 13 and 20 |

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Simulation Core & Spatial Model (inferred) | Core | MVP | Not Started | — | — |
| 2 | Unit, Scenario & Tuning Data (inferred) | Core | MVP | Not Started | — | 1 |
| 3 | Terrain (inferred) | Core | MVP | Not Started | — | 1 |
| 4 | Command System (inferred) | Core | MVP | Not Started | — | 1 |
| 5 | Save/Load & Snapshot | Persistence | MVP | Not Started | — | 1 |
| 6 | Line of Sight & Detection (inferred) | Gameplay | MVP | Not Started | — | 1, 3 |
| 7 | Viewer Projection (inferred) | Gameplay | MVP | Not Started | — | 1, 2, 6 |
| 8 | Movement & Pathfinding (inferred) | Gameplay | MVP | Not Started | — | 1, 2, 3, 4 |
| 9 | Combat Resolution | Gameplay | MVP | Not Started | — | 2, 3, 6, 8 |
| 10 | Territory & Objectives | Gameplay | MVP | Not Started | — | 1, 2, 9 |
| 11 | Unit Behaviour & Standing Orders | Gameplay | MVP | Not Started | — | 4, 6, 8, 9 |
| 12 | Enemy AI | Gameplay | MVP | Not Started | — | 4, 7, 10, 11 |
| 13 | Input & Selection (inferred) | UI | MVP | Not Started | — | 4, 7 |
| 14 | Map View | UI | MVP | Not Started | — | 3, 7, 10 |
| 15 | Unit & Combat Presentation (inferred) | UI | MVP | Not Started | — | 7, 9, 14 |
| 16 | HUD, Panels & Menus (inferred) | UI | MVP | Not Started | — | 2, 5, 11, 13 |
| 17 | Time Model & Clocks (inferred) | Core | Vertical Slice (A) | Not Started | — | 1 |
| 18 | Offline Resolution & Skip-Time | Gameplay | Vertical Slice (A) | Not Started | — | 5, 9, 11, 12, 17 |
| 19 | Contact & Engagement Management (inferred) | Gameplay | Vertical Slice (A) | Not Started | — | 1, 6, 8, 17 |
| 20 | Economy & Reinforcements | Economy | Vertical Slice (A) | Not Started | — | 2, 9, 10 |
| 21 | After-Action, Event Feed & Review (inferred) | UI | Vertical Slice (A) | Not Started | — | 5, 16, 18 |
| 22 | Briefing & Scenario Setup (inferred) | UI | Vertical Slice (A) | Not Started | — | 2, 16 |
| 23 | Accessibility (inferred) | Meta | Vertical Slice (A) | Not Started | — | 16 |
| 24 | Tutorial & Onboarding (inferred) | Meta | Vertical Slice (A) | Not Started | — | 13, 16 |
| 25 | Faction Identity & Premise (inferred) | Narrative | Vertical Slice (A) | Not Started | — | 1 |
| 26 | Multiplayer Server & Replication | Core | Vertical Slice (B) | Not Started | — | 1, 4, 5, 7, 17 |
| 27 | Session, Roster & Presence (inferred) | Meta | Vertical Slice (B) | Not Started | — | 1, 26 |
| 28 | Faction Objectives & Shared Intent | Gameplay | Vertical Slice (A) | Not Started | — | 7, 10 |
| 29 | Allied AI | Gameplay | Vertical Slice (A) | Not Started | — | 12, 28 |
| 30 | Geodata Import Pipeline (inferred) | Core | Alpha | Not Started | — | 3 |
| 31 | Inter-island Transit | Gameplay | Alpha | Not Started | — | 3, 8, 10 |
| 32 | Logistics & Supply Network | Economy | Alpha | Not Started | — | 9, 10, 20, 31 |
| 33 | Progression & Veterancy | Progression | Alpha | Not Started | — | 2, 9 |
| 34 | Campaign Lifecycle | Progression | Alpha | Not Started | — | 5, 10, 27 |
| 35 | Population & Faction Balance (inferred) | Gameplay | Alpha | Not Started | — | 27, 34 |
| 36 | Audio: music, ambient and mix (inferred) | Audio | Alpha | Not Started | — | 16, 42 |
| 37 | Server Operations & Persistence (inferred) | Persistence | Alpha | Not Started | — | 5, 26, 27 |
| 38 | Air, Naval & Missile Domains | Gameplay | Full Vision | Not Started | — | 8, 9, 31 |
| 39 | Telemetry & Analytics (inferred) | Meta | Full Vision | Not Started | — | 4, 27 |
| 40 | Faction Command Replication (inferred) | Gameplay | Vertical Slice (B) | Not Started | — | 26, 28 |
| 41 | Reconnaissance & Intelligence (inferred) | Gameplay | Alpha | Not Started | — | 7, 28 |
| 42 | Combat & Alert Sound Cues (inferred) | Audio | Vertical Slice (A) | Not Started | — | 9, 15 |

---

## Categories

| Category | Description | Typical Systems |
|----------|-------------|-----------------|
| **Core** | Foundation systems everything depends on | Simulation core, unit data, terrain, command system, time model, multiplayer host |
| **Gameplay** | The systems that make the game fun | Combat, movement, line of sight, territory, behaviour, AI, offline resolution |
| **Progression** | How the player grows over time | Veterancy, campaign lifecycle |
| **Economy** | Resource creation and consumption | Reinforcements, logistics |
| **Persistence** | Save state and continuity | Save/load, server operations |
| **UI** | Player-facing information displays | Input, map view, presentation, HUD, after-action, briefing |
| **Audio** | Sound and music systems | Audio |
| **Narrative** | Story and dialogue delivery | Faction identity and premise |
| **Meta** | Systems outside the core game loop | Accessibility, tutorial, session and presence, telemetry |

---

## Priority Tiers

| Tier | Definition | Target Milestone | Design Urgency |
|------|------------|------------------|----------------|
| **MVP** | Required for the core loop to function. Without these, you can't test "is this fun?" | First playable (Skirmish checkpoint at 5-7 months, MVP at 10-15) | Design FIRST |
| **Vertical Slice** | Required for one complete, polished area. Split into VS-A (single-player front) and VS-B (multiplayer skirmish). | Vertical slice / demo | Design SECOND |
| **Alpha** | All features present in rough form. Complete mechanical scope, placeholder content OK. | Alpha milestone | Design THIRD |
| **Full Vision** | Polish, edge cases, nice-to-haves, and content-complete features. | Beta / Release | Design as needed |

---

## Dependency Map

Layers follow TD-SYSTEM-BOUNDARY. Nothing in the simulation depends on the Host or Presentation layers.

### Foundation Layer (no dependencies)

1. Simulation Core & Spatial Model (1) — owns the store, the tick, fixed-point units, RNG and the event list; every other system reads or writes through it.

### Core Layer (depends on foundation)

1. Unit, Scenario & Tuning Data (2) — depends on: 1
2. Terrain (3) — depends on: 1
3. Command System (4) — depends on: 1
4. Save/Load & Snapshot (5) — depends on: 1
5. Time Model & Clocks (17) — depends on: 1

### Feature Layer (simulation systems; depends on core)

1. Line of Sight & Detection (6) — depends on: 1, 3
2. Viewer Projection (7) — depends on: 1, 2, 6
3. Movement & Pathfinding (8) — depends on: 1, 2, 3, 4
4. Combat Resolution (9) — depends on: 2, 3, 6, 8
5. Territory & Objectives (10) — depends on: 1, 2, 9
6. Unit Behaviour & Standing Orders (11) — depends on: 4, 6, 8, 9
7. Enemy AI (12) — depends on: 4, 7, 10, 11
8. Offline Resolution & Skip-Time (18) — depends on: 5, 9, 11, 12, 17
9. Contact & Engagement Management (19) — depends on: 1, 6, 8, 17
10. Economy & Reinforcements (20) — depends on: 2, 9, 10
11. Faction Objectives & Shared Intent (28) — depends on: 7, 10
12. Allied AI (29) — depends on: 12, 28
13. Inter-island Transit (31) — depends on: 3, 8, 10
14. Logistics & Supply Network (32) — depends on: 9, 10, 20, 31
15. Progression & Veterancy (33) — depends on: 2, 9
16. Campaign Lifecycle (34) — depends on: 5, 10, 27
17. Air, Naval & Missile Domains (38) — depends on: 8, 9, 31
18. Reconnaissance & Intelligence (41) — depends on: 7, 28

### Host Layer (wraps the simulation; never depended on by it)

1. Multiplayer Server & Replication (26) — depends on: 1, 4, 5, 7, 17
2. Session, Roster & Presence (27) — depends on: 1, 26
3. Geodata Import Pipeline (30, an offline tool) — depends on: 3
4. Server Operations & Persistence (37) — depends on: 5, 26, 27
5. Faction Command Replication (40) — depends on: 26, 28

### Presentation Layer (client; reads through Viewer Projection, writes only commands)

1. Input & Selection (13) — depends on: 4, 7
2. Map View (14) — depends on: 3, 7, 10
3. Unit & Combat Presentation (15) — depends on: 7, 9, 14
4. HUD, Panels & Menus (16) — depends on: 2, 5, 11, 13
5. After-Action, Event Feed & Review (21) — depends on: 5, 16, 18
6. Briefing & Scenario Setup (22) — depends on: 2, 16
7. Audio: music, ambient and mix (36) — depends on: 16, 42
8. Combat & Alert Sound Cues (42) — depends on: 9, 15

### Polish Layer (depends on everything)

1. Accessibility (23) — depends on: 16
2. Tutorial & Onboarding (24) — depends on: 13, 16
3. Faction Identity & Premise (25) — depends on: 1
4. Population & Faction Balance (35) — depends on: 27, 34
5. Telemetry & Analytics (39) — depends on: 4, 27

### Bottleneck systems

Systems with the most dependents, by direct count: **1** (about 13), **2**, **9**, **7**, **8**, **3**, **4**, **10**. Systems 2 and 7 were not flagged in the first draft and now are.

---

## Recommended Design Order

Design in this order. Independent systems at the same layer can be designed in parallel. **A1, A2, A3 and A10 are confirmed (2026-11-08)**, so GDDs 9, 11, 12, 17, 18 and 19 are unblocked on those decisions. GDD 20 still waits on A4 and GDD 31 on A6.

| Order | System | Priority | Layer | Agent(s) | Est. Effort |
|-------|--------|----------|-------|----------|-------------|
| 1 | Simulation Core & Spatial Model (1) | MVP | Foundation | technical-director, godot-specialist, systems-designer | L |
| 2 | Unit, Scenario & Tuning Data (2) | MVP | Core | game-designer, systems-designer, level-designer | M |
| 3 | Terrain (3) | MVP | Core | level-designer, technical-artist, godot-specialist | M |
| 4 | Command System (4) | MVP | Core | lead-programmer, gameplay-programmer | M |
| 5 | Save/Load & Snapshot (5) | MVP | Core | godot-specialist, lead-programmer | M |
| 6 | Line of Sight & Detection (6) | MVP | Feature | game-designer, godot-specialist | M |
| 7 | Viewer Projection (7) | MVP | Feature | technical-director, network-programmer, game-designer | M |
| 8 | Movement & Pathfinding (8) | MVP | Feature | ai-programmer, gameplay-programmer | L |
| 9 | Combat Resolution (9) | MVP | Feature | game-designer, systems-designer | L |
| 10 | Territory & Objectives (10) | MVP | Feature | game-designer, level-designer | M |
| 11 | Unit Behaviour & Standing Orders (11) | MVP | Feature | ai-programmer, game-designer | M |
| 12 | Enemy AI (12) | MVP | Feature | ai-programmer, game-designer | M |
| 13 | Input & Selection (13) | MVP | Presentation | ux-designer, ui-programmer | M |
| 14 | Map View (14) | MVP | Presentation | ux-designer, technical-artist, ui-programmer | M |
| 15 | Unit & Combat Presentation (15) | MVP | Presentation | art-director, technical-artist | M |
| 16 | HUD, Panels & Menus (16) | MVP | Presentation | ux-designer, ui-programmer | M |
| 17 | Time Model & Clocks (17) | Vertical Slice (A) | Core | systems-designer, technical-director | M |
| 18 | Offline Resolution & Skip-Time (18) | Vertical Slice (A) | Feature | systems-designer, technical-director, ai-programmer | L |
| 19 | Contact & Engagement Management (19) | Vertical Slice (A) | Feature | game-designer, technical-director | M |
| 20 | Economy & Reinforcements (20) | Vertical Slice (A) | Feature | economy-designer, game-designer | M |
| 21 | After-Action, Event Feed & Review (21) | Vertical Slice (A) | Presentation | ux-designer | M |
| 22 | Briefing & Scenario Setup (22) | Vertical Slice (A) | Presentation | ux-designer, level-designer | S |
| 23 | Accessibility (23) | Vertical Slice (A) | Polish | accessibility-specialist, ux-designer | M |
| 24 | Tutorial & Onboarding (24) | Vertical Slice (A) | Polish | ux-designer, game-designer | S |
| 25 | Faction Identity & Premise (25) | Vertical Slice (A) | Polish | narrative-director, art-director | S |
| 26 | Multiplayer Server & Replication (26) | Vertical Slice (B) | Host | network-programmer, technical-director | L |
| 27 | Session, Roster & Presence (27) | Vertical Slice (B) | Host | network-programmer, security-engineer | M |
| 28 | Faction Objectives & Shared Intent (28) | Vertical Slice (A) | Feature | game-designer | M |
| 29 | Allied AI (29) | Vertical Slice (A) | Feature | ai-programmer | M |
| 30 | Geodata Import Pipeline (30) | Alpha | Host | tools-programmer, technical-artist | M |
| 31 | Inter-island Transit (31) | Alpha | Feature | game-designer, level-designer | M |
| 32 | Logistics & Supply Network (32) | Alpha | Feature | economy-designer | M |
| 33 | Progression & Veterancy (33) | Alpha | Feature | game-designer, economy-designer | M |
| 34 | Campaign Lifecycle (34) | Alpha | Feature | game-designer, live-ops-designer | M |
| 35 | Population & Faction Balance (35) | Alpha | Polish | game-designer, live-ops-designer | M |
| 36 | Audio: music, ambient and mix (36) | Alpha | Presentation | audio-director, sound-designer | M |
| 37 | Server Operations & Persistence (37) | Alpha | Host | devops-engineer, security-engineer | M |
| 38 | Air, Naval & Missile Domains (38) | Full Vision | Feature | game-designer | L |
| 39 | Telemetry & Analytics (39) | Full Vision | Polish | analytics-engineer | S |
| 40 | Faction Command Replication (40) | Vertical Slice (B) | Host | network-programmer | S |
| 41 | Reconnaissance & Intelligence (41) | Alpha | Feature | game-designer | M |
| 42 | Combat & Alert Sound Cues (42) | Vertical Slice (A) | Presentation | audio-director, sound-designer | S |

Effort: S = 1 session, M = 2-3 sessions, L = 4+ sessions. The MVP's 16 GDDs come to roughly 33-42 design sessions (the producer's figure for the thinned MVP).

---

## Circular Dependencies

None found. Two couplings were resolved rather than left soft:

- **Combat Resolution (9) and Line of Sight & Detection (6):** cover and concealment values are terrain data owned by Terrain (3), so both read the same table and neither depends on the other for it.
- **Unit Behaviour & Standing Orders (11) and Enemy AI (12):** layered, not circular. System 11 holds execution and the posture layer; system 12 is a top-level decider that selects postures and issues commands through the Command System (4).

Ammo is the other near-cycle the first draft missed: Combat (9) is the sole writer of the ammo field and resupply is a Combat event, so there is no Ammo system to cycle with.

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| Simulation Core & Spatial Model (1) | Technical | Determinism with fixed-point units; language undecided (GDScript throughput is NOT SOURCEABLE); a rewrite if the language changes mid-build; the God-Object risk | Prototype spike P1 (headless sim, throughput, state-hash test) before the GDD; two internal sections; one writer per field |
| Terrain (3) | Technical | Tactical terrain data: a 30 m elevation grid cannot give micro-terrain line of sight | Hand-authored MVP region; the import pipeline waits for Alpha (30) |
| Line of Sight & Detection (6) | Technical | Per-tick cost against a terrain format that does not exist yet | Lower refresh rate, spatial hash, caches; spike P2 |
| Viewer Projection (7) | Design / Technical | The single seam that enforces hidden intent; if the UI reads raw state, multiplayer later breaks every screen | Make it the only read path from day one; leak tests per the art bible |
| Movement & Pathfinding (8) | Technical | Unit counts unmeasured; the prototype's route-oscillation bug; custom pathfinding is unpriced work | Route commitment rule; measure in P1 |
| Enemy AI (12) | Scope | The hardest RTS component to ship; solo first game | Objective-priority planner only in the MVP; shared behaviour layer |
| Unit Behaviour & Standing Orders (11) | Design | Offline exploits (farming, free shield, bimodal strength); depends on A2 | Two verbs only in the MVP; define triggers and lifetime in the GDD; decide A2 and A10 first |
| Offline Resolution & Skip-Time (18) | Technical / Design | The riskiest concept decision (A1); throughput of fast-forwarding hundreds of units | Resolver spike in pre-production; zero combat rules in 18 |
| Map View & Presentation (14, 15) | Technical | Line-feather change in Godot 4.7, rotated-sprite cost, draw-call budget (all unmeasured) | Prototype P3; art bible verification list |
| Multiplayer Server & Replication (26) | Technical / Scope | Server-authoritative architecture decided late forces a rewrite; hosting owner and cost undefined | ADR before MVP code; Server Operations in Alpha |
| Faction Objectives & Shared Intent (28) with Allied AI (29) | Design | Fellowship (the top aesthetic) is untested in the MVP; the single-player signal tests Pillar 5's mechanics, not Fellowship itself | Pillar 5's joint-push test gets a single-player signal in VS-A; humans first test Fellowship in the multiplayer skirmish (VS-B, system 40) |
| Economy & Reinforcements (20) | Design | Who pays for replacements (A4) is unconfirmed | Confirm A4 before its GDD |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 42 |
| Design docs started | 0 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 0/16 |
| Vertical Slice systems designed | 0/15 |

---

## Next Steps

- [ ] Review and approve this systems enumeration
- [x] Confirmed 2026-11-08: A1, A2, A3, A10. Still to confirm: A4 (before GDD 20), A6 (before GDD 31), and A5, A7, A8, A9
- [ ] Choose the real, nameable MVP region (user decision, with a sensitivity check) and run a licensing check on any traced data
- [x] P1 spike run 2026-11-08: PARTIAL (determinism and save/load PASS; GDScript marginal at 300 units, comfortable at MVP scale; see `prototypes/sim-core-spike-2026-11-08/SPIKE-NOTE.md`)
- [x] P2 spike run 2026-11-08: PARTIAL (line-of-sight cost PASS at 8 m cells; accuracy MARGINAL at 4 m and 8 m, FAIL at 16 m; symmetry untested; see `prototypes/los-spike-2026-11-08/SPIKE-NOTE.md`). Re-run on the real hand-authored grid before the Terrain GDD is approved.
- [ ] Set the unit-count target (D2) and minimum-spec hardware (D3)
- [ ] Pillar 2 re-test: include at least one condition with pause off
- [ ] Design MVP-tier systems first (use `/design-system [system-name]`), starting with the Simulation Core
- [ ] Run `/design-review` on each completed GDD
- [ ] Run `/gate-check technical-setup` when MVP systems are designed
- [ ] Validate the highest-risk systems with `/vertical-slice` before committing to Production
