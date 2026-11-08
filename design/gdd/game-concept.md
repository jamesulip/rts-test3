# Game Concept: Philippine Conquest *(working title)*

*Created: 2026-11-07*
*Status: Draft. Revised 2026-11-08: B3, B4, B10, B11 and B12 applied, the A10 tiebreak written into the Pillars, and the visual anchor replaced by a pointer to the art bible. Still open: B6, B7, B8, B9, B13 and decisions A4 to A9 (see `design/gdd/reviews/game-concept-review-log.md`).*

---

## Elevator Pitch

> It's a persistent military strategy game where you command your own force on a live, Flightradar-style map of the Philippines, joining a faction war that keeps going while you're offline, and fight the decisive battles yourself, hands-on.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Military RTS / persistent warfare, with a live operations map |
| **Platform** | PC (Windows, macOS, Linux) |
| **Target Audience** | Foxhole-style cooperative strategy players (see Target Player Profile) |
| **Player Count** | MVP: single-player vs AI. Long-term target: multiplayer, 15–50 concurrent |
| **Session Length** | 30–120 minutes |
| **Monetization** | None yet |
| **Estimated Scope** | Large (Full Vision 6–8+ years solo, per the producer; a funding or team decision) |
| **Comparable Titles** | Foxhole, Men of War, Total War, Command: Modern Operations |

---

## Core Fantasy

You are a commander in a real war across a whole country, with real stakes. You plan operations on a live map, conquer and hold ground, and win or lose the decisive engagements by your own hands. The war keeps moving when you log off.

---

## Unique Hook

Foxhole's persistent faction war, **and also the war itself is the interface**: a live Flightradar-style national map where force positions are public and only intent (orders, destinations, timing) is hidden. You can then zoom in and fight Men of War-style, hands-on.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 6 | Clean, data-forward radar look |
| **Fantasy** (make-believe, role-playing) | 3 | Commanding a nation-scale war |
| **Narrative** (drama, story arc) | 5 | Emergent war stories from persistent fronts |
| **Challenge** (obstacle course, mastery) | 2 | Tactical mastery of positioning, facing and line of sight |
| **Fellowship** (social connection) | 1 | Shared faction territory and victory; joint pushes (**untested in the single-player MVP**) |
| **Discovery** (exploration, secrets) | 4 | Reading the live map, spotting enemy movements |
| **Expression** (self-expression, creativity) | 7 | Force composition and doctrine choices |
| **Submission** (relaxation, comfort zone) | N/A | |

### Key Dynamics (Emergent player behaviors)

Players plan joint pushes, feint using the hidden-intent layer, hold ground, and get attached to their veteran forces.

### Core Mechanics (Systems we build)

1. Hands-on tactical combat (range, facing, line of sight, ammo)
2. A live map with public positions and hidden orders
3. Owned forces with replacement cost
4. Standing orders that run while you are away
5. Objective-based territory capture with faction-wide ownership

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | You own your force and your orders | Core |
| **Competence** (mastery, skill growth) | Tactical mastery of combined arms | Core |
| **Relatedness** (connection, belonging) | Faction operations that need others | Core (post-MVP) |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** (goal completion, collection, progression) — How: building up and keeping an owned, veteran force (secondary)
- [x] **Explorers** (discovery, understanding systems, finding secrets) — How: reading the live map and mastering combined-arms systems (secondary)
- [x] **Socializers** (relationships, cooperation, community) — How: faction operations and shared victory (primary)
- [x] **Killers/Competitors** (domination, PvP, leaderboards) — How: contesting territory against the opposing faction (primary)

### Flow State Design

- **Onboarding curve**: A single guided skirmish in the first 10 minutes.
- **Difficulty scaling**: AI doctrine tiers in single-player.
- **Feedback clarity**: The radar visual language shows state at a glance.
- **Recovery from failure**: Forces fall back intact rather than get wiped, so losing costs resources, not progress.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Position a unit or squad, set its facing, and fight within range and line of sight.

### Short-Term (5-15 minutes)
Move a force across terrain to an objective, fight, resupply, and decide whether to commit or retreat.

### Session-Level (30-120 minutes)
Check what changed on the map, join a push on one front, fight one or two real engagements, and set standing orders before leaving.

### Long-Term Progression
Your force grows through units and reinforcements; the faction's territory shifts over days; the goal is control of the country.

### Retention Hooks
- **Curiosity**: What changed on the map while I was away?
- **Investment**: Your owned force and what it has built.
- **Social**: Faction pushes that need other players.
- **Mastery**: Tactical skill with positioning, facing and combined arms.

---

## Game Pillars

### Pillar 1: The Country Is the Battlefield
One live map runs from nation to single unit. Forces' positions are public; their intent (orders, destinations, timing) is hidden.

*Design test*: A recon feature that reveals unit positions vs one that reveals intent → we choose the one that reveals intent, and protect intent as the hidden layer.

*Scope note*: The seamless nation-to-unit zoom is the pillar's target, but the MVP uses separate strategic and tactical views (see MVP Definition).

### Pillar 2: Hands-On Command
You win through decisions in positioning, facing and timing, not stat checks or click speed.

*Design tests*:
- Auto-resolving a battle vs letting players fight it → we choose letting players fight it.
- Order queuing or tactical slowdown vs rapid-click micro → we choose queuing.

*Visibility rule*: The national map shows force markers publicly. Inside an engagement, line of sight governs individual units, so ambush and flanking still exist.

### Pillar 3: Your Force Is Yours
Each player owns a force. Losses cost something and what you build persists.

*Design test*: A pooled, free-respawning army vs owned forces with replacement cost → we choose owned forces.

### Pillar 4: The War Never Sleeps
Standing orders keep working offline. They hold and withdraw well, attack poorly, and cannot replace you.

*Design tests*:
- Offline AI that fights as well as a player vs doctrine-bound weaker AI → we choose the weaker AI.
- An offline force wiped overnight vs one that falls back intact → we choose falling back.

### Pillar 5: Victory Is Shared
Forces are individual, but territory, supply and victory belong to the faction.

*Design test*: A solo-optimal reward vs one that pays for a joint push → we choose the joint-push reward.

### Pillar tiebreak order (decision A10, 2026-11-08)
When two pillar design tests disagree about the same feature, the higher pillar wins: **2 > 1 > 5 > 3 > 4** (Hands-On Command, then The Country Is the Battlefield, then Victory Is Shared, then Your Force Is Yours, then The War Never Sleeps). Pillar 4 is last because it is defined by what it cannot do.

### Anti-Pillars (What This Game Is NOT)

- **NOT an MMO**: Beyond 50 players is out of scope. It would swamp the project in infrastructure and compromise Pillar 2.
- **NOT traditional fog of war**: Plans are hidden, not positions. Hiding the map would compromise Pillar 1.
- **NOT auto-resolved combat**: Predetermined winners would compromise Pillar 2. Offline and off-screen fights use the same combat rules and the same resolver as live fights (decision A1, 2026-11-08): the strategic layer is event-driven and any contact runs the full tactical simulation, whether or not anyone is watching. There is no aggregated or dice-roll combat.
- **NOT a reflex or APM game**: Speed-clicking would compromise the planning and cooperation that Pillars 1 and 5 reward.
- **NOT a logistics simulator**: Supply exists to make positions and pushes matter, not to be a second game.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Foxhole | Persistent faction war, shared stakes | Owned forces; a live map as the interface | Proves a persistent faction war can hold a community |
| Men of War | Hands-on tactical control, line of sight and facing | Nation-scale persistence | Proves tactical depth is a draw |
| Total War | Conquest across a strategic map | Real-time, shared and persistent | Proves conquest on a map is compelling |

**Non-game inspirations**: Flightradar24 (live tracking map, data-forward display). It is a style reference only: no name, marks or copied UI.

---

## Target Player Profile

*These are hypotheses to validate.*

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 18–40 |
| **Gaming experience** | Mid-core to hardcore |
| **Time availability** | 30–120 minute sessions |
| **Platform preference** | PC |
| **Current games they play** | Foxhole, Hell Let Loose, Men of War |
| **What they're looking for** | Persistent war with real tactical depth |
| **What would turn them away** | Reflex-heavy play, pay-to-win, or a purely solo experience |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | Godot (the creator's stated preference; this repo pins 4.7.2 and the installed editor is 4.7.2.stable.official; `project.yaml` pins GDScript provisionally until spike P1 reports (GDScript, C# or GDExtension for the simulation core)) |
| **Key Technical Challenges** | Offline fidelity, tactical terrain data, plain-data server-ready simulation, country-scale map and precision |
| **Art Style** | 2D top-down symbols ("Living Radar") |
| **Art Pipeline Complexity** | Low–Medium |
| **Audio Needs** | Moderate |
| **Networking** | None in the MVP; server-authoritative design planned from day one |
| **Content Volume** | MVP: one small region, two unit categories |
| **Procedural Systems** | Terrain and cover derived from geodata (pipeline TBD) |

---

## Visual Identity Anchor: Living Radar

> **Superseded by `design/art/art-bible.md` Section 1, which is authoritative.** The brainstorm anchor ("Every mark on the map is a fact. Nothing decorates, and nothing that matters hides.") contradicted Pillar 1 (hidden intent), the Pillar 2 line-of-sight rule and the no-traditional-fog-of-war anti-pillar, and its "presence is brightness" and "dashed intent line" rules would have leaked intent. The art bible reworked it on 2026-11-07 and 2026-11-08. Do not cite the original wording. (Applies concept review items B1 and B2.)

**Visual rule (art bible Section 1):** "Every mark is a fact its viewer is entitled to see. Nothing invents, nothing leaks."

**Supporting principles** (one line each; the design tests and rules are in the art bible):
1. *Information is the loudest layer* (Pillar 1).
2. *One silhouette, more detail as you zoom* (Pillars 1 and 2).
3. *Ownership is legible, and presence is read only on your own side* (Pillars 3 and 4); provisional on decision A9.
4. *Human warmth is a fact too* (Pillar 3).

**Colour:** two saturated faction hues (Azure and Amber, working names) on a quiet dark ground, with a reserved Command White accent and no red or green anywhere. Palette, contrast and colourblind rules are in art bible Section 4.

**Open items:** see the Open items register at the top of the art bible (faction names and insignia, the dashed inner-band spec, the hatch ceiling, and others).
---

## Risks and Open Questions

### Design Risks
- Pillars 3 and 5 pull against each other ("my force" vs "our push"); the tension must be managed in reward design.
- A veteran snowball could disadvantage new players.
- 15–50 players across a country may leave the map empty.
- Fellowship, the top aesthetic, is untested in the single-player MVP.

### Technical Risks
Feasibility verdict (technical-director): **HIGH RISK** until prototypes pass.
- Offline combat fidelity: decided (A1, 2026-11-08): one resolver, an event-driven strategic layer, full tactical simulation on any contact. The skip-time throughput target is still to be set; spike P1 and the Offline Resolution GDD must answer it.
- Real elevation data (e.g. a 30 m global grid) is too coarse for micro-terrain line of sight; the terrain source is **open** (prototype P2).
- **NOT SOURCEABLE** from `docs/engine-reference/godot/`: simulation speed per language, unit-count limits, double-precision builds, terrain streaming, threading.
- Geodata licensing: OpenStreetMap needs attribution and share-alike (ODbL); Copernicus elevation has its own terms. Not legal advice; get a review before shipping.
- Float precision over a ~1,850 km country: sim positions **must** use integer or fixed-point units, no float may be read into hashed simulation state or a combat decision, and no engine services (navigation server, physics) run inside the simulation.
- Server-ready simulation must be designed from day one; bolting multiplayer onto a scene-tree simulation usually means a rewrite.

### Market Risks
- The audience is niche.
- Depicting a real country's military needs fictional factions and insignia.

### Scope Risks
- Producer verdict on the original MVP: **UNREALISTIC** (13–19 months solo). The creator adopted the trimmed MVP below; every estimate is uncalibrated until work is tracked.
- A multi-year solo project with no shipped checkpoint carries burnout risk; each tier should be a playable build.
- Air, naval and missile systems serve no pillar yet and should stay out of the MVP and Vertical Slice.

### Open Questions
- Terrain source: real elevation plus OpenStreetMap-derived cover, hand-authored overlays, or coarse line of sight? (prototype P2)
- Which language for the simulation: GDScript, C# or GDExtension? (prototype P1)
- Does a campaign end or reset?
- Is seamless nation-to-unit zoom feasible? (prototype P3)
- Multiplayer and simulation approach (server-authoritative recommended): record in an ADR.
- Full Vision: funding and team.

---

## MVP Definition

**Core hypothesis**: Commanding your own force on a map of the Philippines is fun and tactically satisfying on its own, against AI factions.

**What the MVP actually tests (B12, 2026-11-08):** Pillar 2 fully (Pillar 2 is **not yet validated**: the prototype's evidence is one developer-tester, and the CD-PLAYTEST re-test with an outside tester and a pause-off condition must pass first); Pillar 1 on the map layer in one region; Pillar 4 in session only (one front on hold and withdraw orders while you fight another); Pillar 3 only as in-match loss aversion (no reinforcements until Vertical Slice A); Pillar 5 and Fellowship not at all.

**Required for MVP** (trimmed per the producer and technical-director; build order is staged, skirmish first):
1. Separate strategic map and 2D tactical views of one small **hand-authored** region (real coastline and roads traced, cover and elevation grid made by hand; the geodata pipeline moves to Alpha; seamless zoom deferred)
2. Ground units (infantry and armor) with selection, movement and facing
3. Ground combat with range, line of sight and ammo
4. Player faction vs an AI enemy faction (enemy AI only; no allied AI)
5. Capturable objectives with faction ownership
6. Simple standing orders (hold, withdraw) plus save/load (skip-time later)
7. Ammo resupply only

**Explicitly NOT in MVP** (defer to later):
- Multiplayer and the dedicated server
- Seamless nation-to-unit zoom
- Allied AI
- Repair and the full logistics economy
- Air, naval, missiles and air defense
- The whole-country map

**Design rule**: The simulation is plain data with a fixed tick and commands as its only input, so a dedicated server could own it later.

### Scope Tiers (if budget/time shrinks)

Timelines are the producer's solo estimates, cumulative and uncalibrated until work is tracked.

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | One small hand-authored region, ground only | Trimmed single-player core loop (16 systems; see `design/gdd/systems-index.md`). A **Skirmish checkpoint** (simulation core, region, line of sight, movement, combat, objectives, minimal HUD, basic enemy AI) lands first. | 10–15 months, plan on 12 (including 2–3 months setup); Skirmish checkpoint at 5–7 months *(re-baselined 2026-11-08 from 8–11 after the system-by-system breakdown)* |
| **Vertical Slice A** | One front on one landmass (single-player) | Economy and reinforcements, skip-time and offline resolution, briefing, after-action, tutorial, accessibility, faction identity and premise | about 24–34 months cumulative |
| **Vertical Slice B** | The same front, multiplayer skirmish (about 4–8 players) | Server and replication, sessions and presence, shared faction vision, allied AI. First test of Fellowship and Pillar 5. | follows Vertical Slice A |
| **Alpha** | Whole country, shippable with no placeholders | Geodata import pipeline, inter-island sealift transit, logistics, campaign lifecycle, population balance, audio, server operations; multiplayer for 15 players | about 38–52 months cumulative |
| **Full Vision** | Complete content | All 13 phases, 50 players, offline-persistent war | 6–8+ years (a funding or team decision) |

---

## Next Steps

- [x] Install Godot and run `/setup-engine` (done 2026-11-07)
- [ ] Run the prototype spikes (`/prototype`): P1 tactical skirmish on a headless sim core, P2 geodata and line of sight, P3 map rendering and zoom
- [x] Create the art bible (`/art-bible`) (done 2026-11-08, accepted with concerns)
- [x] Decompose the concept into systems (`/map-systems`) (done 2026-11-08: `design/gdd/systems-index.md`)
- [ ] Design each system (`/design-system`), starting with the Simulation Core
- [ ] Create the architecture (`/create-architecture`) and an ADR on the server-authoritative simulation
- [ ] Build a vertical slice in Pre-Production (`/vertical-slice`)
- [ ] Validate the core loop with a playtest (`/playtest-report`)
