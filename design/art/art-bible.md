# Art Bible: Philippine Conquest *(working title)*

> **Status**: Draft
> **Owned By**: art-director
> **Last Updated**: 2026-11-08
> **Art Director Sign-Off (AD-ART-BIBLE)**: CONCERNS (accepted) 2026-11-08. Second review after the revision round: 3 of the 8 earlier concerns resolved (Amber Standing hex, tactical richness, most smaller items) and 5 partly resolved. The art-director found no fundamental inconsistency. Five open items are recorded in the Open items register below (dashed inner-band spec, hatch vs the 0.065 ceiling, tag vs alert ticks, stale-plate checks, wording cleanup). The bible is not yet outsourceable for the `standing` frames.

`/art-bible` writes these nine sections in this order and replaces each
section's `[To be designed]` line as that section is approved. A section still
holding its placeholder is incomplete; a later run fills only those.

### Decision and item labels

- A1-A10: concept review decisions (design/gdd/reviews/game-concept-review-log.md). A1 offline/off-screen combat resolver. A2 whether standing orders can take ground. A3 simulation clock vs wall clock. A4 who pays for replacements. A5 what one player commands. A6 how forces cross islands. A7 campaign lifecycle (end or reset). A8 shared faction vision. A9 what enemies see of online presence. A10 pillar tiebreak order.
- B1-B13: concept text contradictions from the same review. B8 = veterancy vs "not stat checks".
- P1, P2, P3: prototype spikes. P1 tactical skirmish on a headless sim core (language choice). P2 geodata and line of sight (terrain source). P3 map rendering and zoom (separate views vs seamless; all pixel and draw-call verification).
- S1-S4 Section 3 shape principles. M1, M2 Section 2 mood principles. C1-C4 Section 5 principles. E1-E6 Section 6 principles. U1-U4 Section 7 principles. X1 Section 6 E5 composite legibility check. AP-1 to AP-20 Section 8 asset preferences. C-T, C-N the tactical and national densest composites (E5). L1, L2 loss-mark options (Section 5). TXT-D/H/B/L/M type tokens (Section 7).
- D-labels are section-local and are not defined elsewhere. Section 5 D3: whether callsign tags show for allies and enemies (meaning inferred from context; never defined). Section 6 D4: the terrain-ink ceiling cannot be met without dropping a fact (a finding for the user). D5: real military bases and place names in geodata (legal and sensitivity review; also cited in 7.10). D6: visibility class of damage (resolved 2026-11-07, line-of-sight gated). Section 8.T D1: the px unit (resolved, 8.R #1). 8.T D2: unit counts per band. 8.T D3: minimum-spec hardware. D3 therefore means two different things (Section 5 and 8.T).
- Terms: "under command" = full-intensity presence state (own faction only); "selected" = in the current selection set (shown by the brackets). "Command White" is a colour name only.

### Open items register (each once; sections that reference it; what it waits on)

- Enemy presence view: Sections 1, 4, 5, 7. Waits on A9.
- Faction vision and ally rows, tags and ticks: Sections 1, 5, 7. Waits on A8.
- Clocks, tick rate, durations, timestamps: Sections 5, 7. Waits on A3 and the tick-rate decision.
- Campaign end look: Sections 2 (State 7), 7. Waits on A7.
- Veterancy marks: Sections 5, 7. Waits on B8 and the combat design.
- Pillar conflicts between principles: Section 1. Waits on A10.
- Independent turret (Render A vs B): Sections 1, 3, 5, 8. Waits on the Pillar 2 re-test and the game-designer pillar check.
- National marker per unit or per force: Sections 3, 5, 7. Waits on map-systems design.
- Terrain source: Sections 3, 6. Waits on P2.
- Separate views vs seamless zoom, px unit verification, line widths, draw calls, colour in-engine: Sections 1-8. Waits on P3.
- Standing-order second cue (dashed inner band) and stale treatment (hollow plate) chosen 2026-11-07. Accent geometry and territory tint alpha (10%) set as starting values. Territory pattern (hatch at 20% alpha) and all these values stay open until verified in P3: Sections 1, 3, 4, 5, 6, 7, 8.
- Faction names, insignia, hue fixed per faction: Sections 3, 4. Creative-director and user.
- Blue-yellow real-flag adjacency and Amber vs Flightradar24 icon colour: Sections 4, 9. Creative-director and legal review.
- Loss mark confusion with the objective pulse: Sections 5, 7.2. Playtest.
- Tactical feedback budget (Option 2: about 100 of the 600 mark draw calls for a firing flash, hit mark, and wreck-as-cover only if the simulation keeps wrecks): Sections 1 item 8, 5, 6 E6. Revisited after the Pillar 2 re-test.
- Tactical detail stroke caps (infantry 9, support 6, armor 8, artillery 7): Sections 1 item 8, 5, 8.H. Starting values, verify in P3.
- River and lake edge (3 px Sea Night core, 2 px Chart Grey edges, 7 px total; E4 gap rule applies between different features): Sections 3, 4, 6. Starting values, verify in P3 against the ink ceilings.
- **From the second AD-ART-BIBLE review (2026-11-08, accepted with concerns):**
  - Dashed inner-band spec for `standing` frames (colour, inset, stroke, dash pattern, glyph clearance, notch handling inside a 16 px plate); Section 1 still says "dashed outline", which would break the closed casing ring (X1.3): Sections 1, 3, 5, 8.H. Blocks `standing` frame production. Waits on the P3 16 px dash check and an art-director spec.
  - The stale hollow plate is not covered by X1 items 1-2, the glyph contrast rule or AP-15 ("frames are opaque inside"); its faction-hue glyph is untested: Sections 4, 6 E5, 8.G, 8.H. Art-director.
  - The Faction B hatch (20% alpha) vs the 0.065 composite ceiling: an Amber hatch-line pixel is about 0.12 and the area average about 0.075 to 0.08 by the art-director's estimate, so the ceiling statement is overstated. Its colourblind-backup role is weak (about 1.5:1, no pass number) and the implementation is inconsistent (tile with modulate vs runtime lines): Sections 3, 4, 6, 7, 8. Waits on P3.
  - A callsign tag up to 96 px wide overlaps the bottom alert ticks (only the stub and strip were collision-checked). The overlay file count in 8.E (13) looks too low for per-band, per-category bracket files, and the accent file names use a different token order: Sections 4, 5, 8.C, 8.E, 8.H. Art-director and P3.
  - Wording cleanup: leftover "candidate" and "undecided" text for the chosen cues (Sections 1, 3, 4, 7); the frame-count rationale still says the second cue "doubles" frames although it adds none (Sections 5, 8); whether the river's Sea Night core counts toward the E4 ink ceilings (Section 6); and the casing wording (the casing is about 2.0:1 against a 0.065 composite, so the plate-to-casing edge carries the contrast) (Section 4).
- Ambient layer is not a "mark": Sections 2, 4. Creative-director confirmation.
- Render architecture (C3: one path, no extrapolation, at most one tick behind): Section 5, 8. Technical-director sign-off.
- Active-front distance D and whether combat events are public: 7.1. Game-designer.
- Combat values (wedge angle, range, low thresholds, hold-fire term), hit direction, enemy strength in line of sight: Sections 5, 7. Game-designer and combat GDD.
- Withdrawal route and queue persistence after deselection: Sections 2, 7.7. Game-designer.
- Briefing showing enemy composition, tactical slow-down or planning modifier: Sections 2, 7. Game-designer.
- Persistent war damage, shallow-water band, port and airfield: Section 6. Simulation scope and A6/A7.
- Typeface, wordmark, minimap, custom cursor: Section 7. User and ux-designer.

## 1. Visual Identity Statement

**Visual rule:**

> **Every mark is a fact its viewer is entitled to see. Nothing invents, nothing leaks.**

How an artist uses it: for any mark, ask two questions. (1) Which simulation fact does this encode? If none, remove it. (2) Who may know that fact? If the viewer may not, the mark must not exist for them or vary for them.

*Provenance:* adapted from the brainstorm anchor "Living Radar" ("Every mark on the map is a fact. Nothing decorates, and nothing that matters hides."). "Nothing that matters hides" contradicted hidden intent (Pillar 1), line of sight (Pillar 2) and the no-traditional-fog-of-war anti-pillar. "Nothing decorates" could be read as banning the hull and turret detail the prototype tester asked for. Alternatives considered: "If it's drawn, it's true; if it's secret, it isn't drawn" (shorter, but silent on vehicle readability and last-known marks) and "The map tells the truth, but only the part you've earned" (warmer, but ambiguous and hard to test).

### Visibility classes (supports the rule)

These classes state who sees what. They do not decide the open questions.

| Class | What it covers | Who sees it | Status |
|---|---|---|---|
| Public | Position and ownership of force markers at national zoom, territory ownership, objective ownership | All players, both factions | Fixed by Pillar 1 |
| Line-of-sight gated | Individual units inside an engagement (tactical view) | Whoever has line of sight, per the Pillar 2 visibility rule | Fixed by Pillar 2 |
| Owner-only | Own orders, destinations, timing, intent lines, own force's online or standing-order state | The owning player | **Provisional** on A9 |
| Faction-only | Intent data shared with faction-mates | Not decided; depends on A8 (shared faction vision). The art bible does not assume it either way. | **OPEN** |
| Never shown to the enemy | Any enemy-side visual that varies with online or offline status; any intent mark | Nobody on the opposing faction | **Provisional** on A9 (recommended) |

**Stale-information rule:** a mark for a unit whose current position the viewer cannot confirm (last-known, or line of sight lost inside an engagement) must look visibly different from a live mark (for example hollow, hatched or carrying an age tick). A live mark and a last-known mark must never be confusable in a screenshot. A stale or last-known mark is never drawn at reduced intensity, because intensity is reserved for the presence axis (Principle 3). Treatment (chosen 2026-11-07): a hollow plate (2 px faction-hue stroke with casing, glyph in faction hue, no fill), baked as a stale frame. Stale marks exist only for full intensity (AP-19.5): the viewer cannot lose track of an own unit, and every non-own unit is drawn at one fixed intensity, so a stale mark is never a standing-order mark. *(Amended 2026-11-07: "fading" removed as an example; see Section 3.)*

### Supporting principles

**Principle 1: Information is the loudest layer.** *Serves: The Country Is the Battlefield (Pillar 1).*
- *Test:* when two treatments compete for attention at national zoom, choose the one that makes ownership and active fronts readable first. A new viewer names each region's owner and the active fronts within 5 seconds with no legend.
- Terrain, labels and effects sit below force and territory marks in contrast and saturation. Land is a quiet desaturated dark neutral and sea is darker and cooler. The two faction hues are the only fully saturated colours, and the selection and combat-alert accent is reserved.

**Principle 2: One silhouette, more detail as you zoom.** *Serves: The Country Is the Battlefield (Pillar 1) for continuity across scale, and Hands-On Command (Pillar 2) for readability of facing at tactical zoom.*
- *Test:* when tactical-zoom detail is ambiguous (a turret, tracks, a hull outline), choose the detail that reveals unit type or orientation inside a frame that stays the same. A viewer can say "same unit" between the national marker and the tactical symbol without a label.
- "Nothing decorates" is replaced by "nothing invents". Hull shape encodes unit type and rotation encodes facing. Both are facts, so they are allowed and required at tactical zoom.
- The national marker's frame, faction hue and ownership cue persist at every zoom level. Tactical zoom adds hull and turret detail inside that frame and does not replace it.
- The whole symbol rotates with the simulation's facing. The prototype's fixed diamond with a thin facing line is the failure case.
- The symbol shows every orientation the simulation tracks and never invents one. If the simulation tracks one facing, the turret is drawn aligned with the hull. If a later decision adds an independent turret orientation, the symbol shows it. This section does **not** commit hull and turret rotation as a gameplay mechanic (blocked pending the Pillar 2 re-test and the game-designer pillar check).
- Strictly 2D top-down: rotated 2D sprites or vector symbols. No 3D models, no perspective.
- The MVP uses separate strategic and tactical views. The grammar must hold across that view switch now and across a seamless zoom later (prototype P3).

**Principle 3: Ownership is legible, and presence is read only on your own side.** *Serves: Your Force Is Yours (Pillar 3) for finding your own force, and The War Never Sleeps (Pillar 4) for showing which of your forces are under command or on standing orders.* **[PROVISIONAL on A9]**
- *Test:* when it is unclear whether a visual cue should show a unit's state, choose the cue that is visible only to its owner (or faction, where allowed). A player finds their own force in a crowded theater in under 2 seconds.
- Presence is shown on your own faction only: a unit under command renders at full intensity, a unit on standing orders at reduced intensity.
- Every enemy unit renders at one fixed intensity regardless of its real online or offline state. No visual property of an enemy unit (brightness, outline, animation, marker size) may vary with that unit's online or offline status.
- Brightness is never the only cue. Pair reduced intensity with a second cue (for example a dashed outline) so colourblind and low-contrast viewers can read it. Do not reuse that dashed outline for intent lines unless it stays clearly distinct. Own-only intent lines exist (decided 2026-11-07); faction-only is OPEN.
- The standing-order look must not be confusable with the reserved "this unit is selected" accent.
- Faction hue is never the only differentiator. Pair it with a shape or pattern cue, and carry per-player identity in a callsign or tag.
- Factions and insignia are fictional. No real flags or combatants.

**Principle 4: Human warmth is a fact too.** *Serves: Your Force Is Yours (Pillar 3).*
- *Test:* when the map risks feeling cold, choose a mark that carries real information about your force (a callsign, a veterancy mark) over a purely decorative warmth device.
- Callsigns and veterancy marks are the warm human accent. They follow the same visibility classes as everything else.

### Changes from the brainstorm anchor

| Brainstorm anchor | This section | Why |
|---|---|---|
| "Nothing that matters hides" | "Nothing leaks" plus visibility classes | The old clause contradicted Pillars 1 and 2 and the fog-of-war anti-pillar |
| "Nothing decorates" | "Nothing invents" | Hull, turret detail and rotation are facts; resolves the prototype's worst moment without opening the door to ornament |
| Dashed intent line on standing-order units | Intent lines, if they exist, are owner-only; standing-order cue is intensity plus a second cue | The old version showed hidden intent on the public map |
| "Presence is brightness" (all units) | Presence is an own-faction cue only [PROVISIONAL on A9] | Showing enemy presence reveals raid targets |
| Four principles with ownership and presence separate | Presence merged into the ownership principle; a fourth principle for human warmth | Keeps the set at four |
| No explicit 2D statement | 2D top-down stated directly | User decision |

### Provisional and open items

1. **A9** (enemy view of online presence): Principle 3's enemy rule assumes "enemies see nothing". If decided differently, Principle 3 and the "never shown to the enemy" row change.
2. **A8** (shared faction vision) decides whether faction-mates see each other's intent lines.
3. Whether intent lines exist at all. This section only constrains who may see them. *(Decided 2026-11-07: own-only intent lines exist; see Section 7 7.7.)*
4. Whether the simulation tracks an independent turret orientation (blocked pending the re-test and the game-designer pillar check). The section holds either way.
5. **A10** (pillar tiebreak order): this section does not rank pillars; a conflict between principles goes to the creative-director.
6. The stale treatment (hollow plate) and the standing-order second cue (dashed inner band) are chosen 2026-11-07, pending the P3 16 px dash check. Colourblind safety remains a hard constraint.
7. Seamless zoom vs separate views depends on prototype P3.
8. Material richness at tactical zoom: decided 2026-11-07 (Option 3). Richer layer-4 detail (hull, tracks, turret ring, barrel) is allowed only as facts, baked into the frames and capped by a stroke count per category (Section 5 LOD, starting values). No firing flash, hit mark or wreck budget yet: that option is revisited after the Pillar 2 re-test.

### Risks

- Per-unit hull and turret layers may strain the 2,000 draw-call starting target (unmeasured); flag to technical-artist for batching and atlasing.
- The map can feel cold or sterile; mitigated by the warm accent in Principle 4, which must also follow the visibility classes.
- If intensity is used for too many states it stops being a fact and becomes noise; limit intensity to one state axis.
- The tank-readability finding comes from one tester who also built the prototype; treat it as a signal, not proof.
- If last-known and live marks look alike, players will misjudge enemy positions; needs a playtest check.
- Colourblind safety is a hard requirement, but two saturated faction hues plus one accent leaves little room; design shape and pattern cues in from the start.
- Flightradar24 is a style reference only: no name, marks or copied UI.

## 2. Mood & Atmosphere

This is a 2D map UI, so "lighting" means five things: value contrast, colour temperature of the neutral ground, one ambient layer (vignette), motion, and UI chrome. There is no light source, no time of day and no shadow.

### Governing rules

**Principle M1: Mood lives in the ground, never in the marks.** *Serves: The Country Is the Battlefield (Pillar 1) through Section 1 Principle 1, and Section 1 Principle 3's one-intensity-axis rule.*
- Unit-mark brightness is already spent on one axis: under command (full) vs standing orders (reduced), own faction only. Mood may not brighten, dim, tint or fade any unit mark, its casing, or its accent geometry.
- Mood is delivered only by:
  - sea and land value,
  - the temperature of the neutral ground,
  - a symmetric edge vignette,
  - UI chrome (frame, panel tone, typography),
  - the motion of real events.
- Layer order, back to front: sea, land, terrain features, **ambient vignette**, territory tint, marks (with casing), accent geometry, UI. The vignette sits behind the marks. A mark at the screen edge is therefore never dimmed by it.
- *Test:* render one simulation frame with the ambient layer on and off. A pixel-diff restricted to unit marks, their casings and accent geometry is zero.

**Principle M2: Mood follows only what the viewer may know.** *Serves: The Country Is the Battlefield (Pillar 1: hidden intent), Hands-On Command (Pillar 2: line of sight). It is how Section 1's "nothing leaks" applies to atmosphere.*
- Allowed drivers of any ambient change:
  - (i) which view or screen the viewer is on,
  - (ii) public facts,
  - (iii) facts the viewer is entitled to: their own units' state, and enemies inside their line of sight.
- Banned drivers:
  - an unseen enemy's proximity, strength or direction,
  - any enemy's online or offline state,
  - any hidden intent.
- The vignette is radially symmetric and never directional, so it cannot point at an unseen threat.
- No ambient animation without a simulation fact behind it. That bans a radar sweep, drifting noise, scanlines, a pulsing "alive" glow and camera shake. Each one is decoration, which fails the first question of Section 1's rule: "which simulation fact does this encode?"
- No day/night tint, because the simulation has no time of day. A tint would invent a fact. If a time-of-day model is added later, it needs a new decision, not an art default.
- *Test (leak test):* render the same frame for one player in four conditions:
  1. enemy side online and active,
  2. enemy side offline,
  3. an unseen enemy force added outside line of sight,
  4. that force removed.
  
  The player's screenshots are pixel-identical in all four, ambient layer included.

**Why mood is subtle (Section 1 and the MDA table).** Fellowship is 1, Challenge is 2 and Fantasy is 3. Sensation is 6 and the concept says "clean, data-forward radar look". Mood is a supporting layer. It is not the main way the game earns emotion.

**Alternatives considered for how mood is carried:**
- (a) Tint and dim the unit marks per state. Rejected: it spends the intensity axis twice and breaks Principle 3.
- (b) A full-screen colour grade over everything, marks included. Rejected for the same reason, and because it pushes faction hues toward each other.
- (c) A different map palette per state. Rejected: it breaks the one-grammar-across-scale principle and the faction hues' constancy.
- (d) Chosen: shift the neutrals, the chrome and the vignette only. Faction hues, accent and marks stay constant in every state.

### Ambient parameters per state

These are starting values. Tune them in prototype P3 and the later UI work. Faction hues, the accent and mark casing never change between rows. Luminance is calculated from hex.

| State | Sea | Land | Vignette (terrain layer only, symmetric) | Chrome |
|---|---|---|---|---|
| National overview | #0B1620 | #2B2F2E (cool-neutral) | none | Panel Ink #101A22 |
| Tactical engagement | #0B1620 | #2E2F2B (warm-neutral, same luminance) | 0%, rising to a maximum of 14% in Sea Night while "contact" (below) | Panel Ink #101A22 |
| Objective captured or lost | unchanged | unchanged | none | unchanged, plus the ring event |
| Engagement lost, fall-back | #0A1520 | #292E30 (cooler, about 0.026 luminance) | 14% held, eased out over 8 s | Panel Ink #101A22 |
| Return, after-action review | #0B1620 | #2B2F2E | none | warm-neutral panel #171A1A, plus a 3 px Warm Paper screen frame |
| Menus and briefing | #08101A | #2B2F2E | none | Panel Ink #101A22, panels dominate |

Land luminance stays within about ±0.002 across all states. Temperature shifts at near-constant value, so the **terrain-versus-mark contrast budget in Section 4 does not move between states.**

### State definitions

**State 1: National map overview ("watching the war")**
- *Emotional target:* calm omniscience with a held breath. The viewer sees the whole war, nothing is hurried, and every mark is a fact someone made. Aesthetics served: Fantasy (3), Discovery (4), and Fellowship (1) through shared territory.
- *Lighting character:*
  - The land is the quietest value on screen and the sea sits slightly darker and cooler.
  - Faction hues (Section 4) are the only saturated colour.
  - Temperature is cool-neutral.
  - No vignette.
- *Atmospheric descriptors:* vigilant, wide, quiet, instrument-like, patient.
- *Energy:* 2 of 5. Motion is only real force movement and real ownership changes.
- *Mood-carrying elements:*
  - the contrast between a quiet field and loud, sparse force plates,
  - the faction-hue territory borders,
  - a low-contrast graticule and scale bar, which are position facts and are therefore allowed.
- *Visibility check:* everything shown is public (Section 1's Public class). Owner-only marks (own orders, own standing-order state) appear only on the owner's screen.

**State 2: Tactical engagement ("hands-on fight")**
- *Emotional target:* focused, controlled tension. "I am here, my facing and position decide this." It is dense, not frantic (anti-pillar: not an APM game). Aesthetic served: Challenge (2).
- *Lighting character:*
  - Land shifts warm-neutral at equal luminance. This marks "ground level" without changing contrast, and it is the only difference between the strategic and tactical neutrals.
  - Terrain features (walls, cover, building footprints) appear, with fills no lighter than luminance 0.04 (calculated).
  - **Contact vignette:** a symmetric darkening of the terrain layer, up to 14%, with 0.3 s onset and 4 s release. It is driven only by "one of my units is under fire" or "I have line of sight to a hostile". It never has a direction and never reacts to unseen enemies.
  - If the later UI work adds a tactical slow-down or order-planning pause (the concept lists "order queuing or tactical slowdown" as a pillar test), a **planning** modifier returns the land to the cool-neutral overview value. The time-scale change is a fact. **PROVISIONAL** on whether that mechanic exists.
- *Atmospheric descriptors:* focused, dense, exposed, deliberate.
- *Energy:* 4 of 5, capped by the lack of ambient motion.
- *Mood-carrying elements:*
  - hull plates with visible rotation (Section 3),
  - the casing line that keeps marks crisp against cover,
  - the contact vignette,
  - the accent brackets and alert pulses (Section 4).
- *Visibility check:* only own units and line-of-sight enemies are drawn. The vignette is not a threat radar.

**State 3: Objective captured (and its mirror, objective lost)**
- *Emotional target:* earned, shared satisfaction when you gain ground (Fellowship 1, Pillar 5). Sober recognition when you lose it. Capture is a faction fact, not a personal reward.
- *Lighting character:*
  - No change to the ground. It is an event, not a mode.
  - **Gained:** the objective ring fills with the new owner's hue, the territory border redraws, and one ring pulse travels **outward** (about 1.2 s). Territory tint resolves over about 2 s.
  - **Lost:** the same event in the other faction's hue, with the pulse travelling **inward**.
  - The pulse is in faction hue. It is not the accent (the accent is reserved) and never red.
- *Atmospheric descriptors:* resolved, shared, brief, clear.
- *Energy:* 3 of 5, a short spike (about 3 s) that settles back to the previous state's level.
- *Mood-carrying elements:* the outward-versus-inward pulse and the border redraw. On a capture, the callsigns of **your own** participating units appear in Warm Paper on a plate. This is the human-warmth fact of Section 1 Principle 4, and it is own-side only.
- *Visibility check:* ownership is public (Pillar 1), so both sides see the event. The pulse carries no information about who was online.

**State 4: Engagement lost / fall-back (not "defeat")**
- *Rationale for the rename:* the concept says forces fall back intact and losing costs resources, not progress (Pillar 4, Pillar 3). A wipe-out aesthetic would contradict the rules.
- *Emotional target:* sober, accountable, recoverable. "We lost the ground, not the war. Count the cost and regroup." The line is deliberately not punishing.
- *Lighting character:*
  - The sea and land cool a little at constant value (table above).
  - The 14% symmetric vignette is held, then eased out over about 8 s.
  - The summary strip uses Warm Paper type on Panel Ink and shows what survived, for example units intact and ammunition remaining. It shows no red or green.
- *Atmospheric descriptors:* sober, quiet, accountable, steady.
- *Energy:* 2 of 5, falling. It is the exhale after State 2.
- *Mood-carrying elements:* the cooled ground, the held vignette and the plain-type summary strip.
- *Own withdrawal route:* it is drawn as an owner-only intent line (own-only intent lines exist, decided 2026-11-07; see Section 7 7.7).
- *Visibility check:* the summary uses own-force data and public outcomes only. It reveals nothing about the enemy's remaining strength outside what was seen.

**State 5: Return after absence / after-action review**
- *Emotional target:* curiosity and homecoming. "What changed while I was away?" (Retention hook: curiosity.) Aesthetics served: Discovery (4), Narrative (5).
- *Lighting character:*
  - The map uses the overview base.
  - The chrome turns warm-neutral and a 3 px Warm Paper frame surrounds the screen. This is the only warm element, and it exists so a replay can never be mistaken for the live map. Replayed marks are not live, so that distinction is a fact the viewer is owed.
  - Changed territory borders get a Chart Mist 2 px outline plus a text delta ("changed since your last session"). They do not use the accent.
- *Atmospheric descriptors:* retrospective, orienting, warm-edged, ledger-like.
- *Energy:* 2 of 5, with a forward lean from the scrub control.
- *Mood-carrying elements:* the Warm Paper frame and a time-scrub bar with timestamped ticks.
- *Visibility check (important):*
  - The review replays only what was public at the time, or what the viewer's own units saw at the time.
  - Enemy movement during the absence appears only if it was public.
  - Nothing may hint at an enemy's online or offline activity. For example, there is no "enemy was active for N hours" readout.
  - A review that showed unseen enemy movement would leak.

**State 6: Menus and briefing**
- *Emotional target:* composed, prepared, "the table before the war". Aesthetic served: Fantasy (3).
- *Lighting character:*
  - The sea is darkest here (#08101A), so the land reads as a lit chart.
  - The panels dominate. The map is static, with no live marks.
  - The brightest elements are Warm Paper type and Command White used only as text emphasis. The accent geometry from Section 4 does not appear, because nothing is selected.
- *Atmospheric descriptors:* still, ordered, chart-like, deliberate.
- *Energy:* 1 of 5. There is no motion.
- *Mood-carrying elements:* the static chart, centred composition and typographic hierarchy (typeface detail is Section 7).
- *Visibility check:* a briefing shows only objectives, own force and public information. In the single-player MVP the AI's composition is a simulation fact. It follows the same classes. Whether the briefing may show it is a game-design decision, not an art default.

**State 7: Campaign end (victory or defeat). PROVISIONAL.**
- The concept lists "Does a campaign end or reset?" as an open question. This section deliberately defines no campaign-end look.
- When it is decided, it must follow the same levers as States 3 and 4, a larger version of the capture event, and no red or green.

### Distinctness check

| State | Distinguishing signature in a screenshot |
|---|---|
| National overview | cool ground, sparse plates, no vignette, no chrome weight |
| Tactical engagement | warm ground, terrain features, large rotated hull plates, possible vignette |
| Objective captured | ring pulse and border redraw over an otherwise unchanged state |
| Fall-back | cooler ground, held vignette, summary strip |
| Review | Warm Paper screen frame, scrub bar, warm panel |
| Menus and briefing | darkest sea, panel-dominated layout, no motion |

### Provisional

1. Campaign-end look (State 7) depends on the campaign end-or-reset decision.
2. The planning/slow-time modifier depends on whether tactical slow-down exists. A skip-time cue is a later question.
3. Whether the briefing may show enemy composition depends on the game design and Section 1's classes.
4. Own withdrawal routes: resolved 2026-11-07. Own-only intent lines exist (Section 7 7.7), so a withdrawal route is an owner-only intent line when the player gives one.
5. All vignette percentages and timings are starting values to tune.

### Risks

- Ambient treatments may be read as "marks that decorate". Section 1's rule speaks only of marks. M1 and M2 treat the ambient layer as ground, not marks, and the leak test and on/off diff are the guard. **This interpretation needs creative-director confirmation.**
- A contact vignette tied to line-of-sight enemies could still feel like "I sense threats". Playtest that it never fires without a visible cause.
- Warm and cool ground shifts are small. They may not read on cheap monitors, so the Warm Paper frame (review) and the layout (menus) must carry those states on their own.
- Warm Paper (callsigns, review frame) is a warm neutral close in hue to Amber. See Section 4 risk 5.

## 3. Shape Language

### Shape families

**Principle S1: Four shape families, four kinds of fact.** *Serves: The Country Is the Battlefield (Pillar 1) through Section 1 Principle 1.*
- **Agents** (things that act and face): plates with a forward point, drawn only for units.
- **Places** (things that are somewhere): circles, drawn for objectives and range or capture areas, and for the one-off loss mark (a place where an event occurred, Section 5). *(Amended 2026-11-07.)*
- **Structures** (made things): straight edges and right angles, drawn for buildings, walls, cover, bridges, roads (as piecewise-straight segments, never curves) and all UI chrome. *(Roads added 2026-11-07.)*
- **Land** (the ground): irregular curves and hard coast edges, drawn for coastline, regions and vegetation.
- Rule: nothing but a unit may point forward. No triangle or arrowhead appears in terrain, labels, UI chrome or icons that are not units. The OS pointer is an input device and not a mark, so it is exempt, and a unit's own firing wedge (Section 7) is part of that unit and is not a forward point. *(Clarified 2026-11-07.)* A forward point means "an agent is here, facing this way".
- *Test:* cover the colour of any screenshot. A new viewer sorts every shape into agent, place, structure or land with no legend.
- *What it communicates emotionally:* the agents are the only things on the map with direction and intent, which gives the war its sense of agency. The land stays inert and calm.

### Unit symbol structure

**Principle S2: One symbol, three layers.** *Serves: Section 1 Principle 2 (one silhouette, more detail as you zoom); Hands-On Command (Pillar 2).*

| Layer | Encodes | Persistence across zoom | Rotates with facing |
|---|---|---|---|
| Plate (frame) | Affiliation (which faction) | Always. Same silhouette at every zoom. | Yes |
| Category glyph | Unit category | Always. Reduces, never replaced. | Yes |
| Tactical detail (hull, tracks, turret, barrel) | Type and orientation facts | Added at tactical zoom only | Yes |
| Casing (1.5-2 px Sea Night outline) | Nothing (legibility only) | Always | Yes |

- Hull and tactical detail are added **inside** the plate. They never replace it, per Section 1 Principle 2.
- The whole symbol rotates with simulation facing. The prototype's fixed diamond with a thin facing line is the failure case.
- **Casing:** an outer dark outline lifts a mark off any terrain. It encodes nothing, and it is a legibility treatment of the mark. It is not an ornament.

**Affiliation plates must survive rotation**
- Because the whole symbol rotates, a plate that is a rotated copy of the other would flip a friendly into a hostile. The obvious bad pair is a square versus a diamond: a square at 45 degrees is a diamond.
- Alternatives considered:
  - (a) Square versus diamond. Rejected: they are rotations of each other.
  - (b) Circle versus another shape. Rejected: a circle shows no facing, and the plate is part of the rotating symbol.
  - (c) Filled versus hollow. Rejected: hollow is a candidate stale-mark cue.
  - (d) Rounded versus chamfered corners. Weak: the difference blurs at 14-16 px.
  - (e) Different regular polygons (five versus six sides). Rejected: at small sizes the vertex count is hard to resolve.
  - (f) **Chosen:** a **Shield** versus a **Swallowtail**. Both point forward. They differ in rear contour: the Shield has a convex, rounded rear and the Swallowtail has a concave V-notch in its rear.
- Why it survives rotation: the notch is fixed relative to the heading. No rotation turns a rounded rear into a notched rear.
- Assignment, working: **Faction A = Shield, Faction B = Swallowtail.** Both are fictional insignia shapes, with no real emblem referenced. Faction names and insignia remain open.
- Minimum plate sizes (recommendations to verify in P3): 16 px at national zoom, so the notch depth is at least 4 px (25% of plate length). The notch must still read at all of 0, 45, 90, 135, 180, 225, 270 and 315 degrees.
- *Test (rotation sweep):* render each plate at those 8 headings and 3 sizes, in greyscale and with hue removed. A naive viewer sorts them into A and B with no errors.

**Category glyphs (one distinguishing trait each)**

All glyphs are drawn as a knockout in Sea Night against the faction-hue plate. Each has a forward-only feature, so facing is always readable. A rotationally symmetric glyph would hide facing, which is a Pillar 2 fact.

| Category | Distinguishing trait | At tactical zoom adds | At national size reduces to | Status |
|---|---|---|---|---|
| Infantry | A round body with one small forward nub (asymmetric, so facing reads). Smallest footprint. Squads appear as clusters, and the frontage line from the prototype is a separate, line-based overlay. | Individual figure dots in a squad | Dot with nub | MVP |
| Armor | Long rectangular hull (about 1.6:1) with two track bars and a **barrel projecting beyond the hull**. The widest, heaviest glyph. | Hull, tracks, turret ring | Box with forward bar | MVP |
| Artillery | Narrow box with a **very long barrel (longer than the hull)** and two short rear trail ticks. The longest glyph for its width. | Barrel, trails, firing-arc origin | Narrow box with a long bar | Later |
| Support | Two boxes (cab in front, cargo behind) with **no barrel** | Cab and cargo detail | Two-box silhouette | Later |
| Air (placeholder) | Swept delta wing | Wing detail | Delta | Placeholder only. Serves no pillar yet (concept scope risk) |
| Naval (placeholder) | Long hull (about 3:1) with a pointed bow and flat stern | Hull detail | Long pointed bar | Placeholder only |

- *Reduction rule:* a glyph keeps its single trait at every size (nub, barrel, long barrel, cab, wing, pointed bow). At national size it loses everything else.
- *Test:* in greyscale at 16 px, a viewer names the category of each marker with a rotation sweep applied.

**Armor and the turret (PROVISIONAL, blocked pending the Pillar 2 re-test)**

The art bible does not commit independent turret rotation as a mechanic. This section draws both legal renders:
- **Render A, aligned turret:** the turret ring is concentric on the hull and the barrel runs along the hull axis. The prototype's single facing is enough.
- **Render B, independent turret:** the turret circle sits on the hull with its barrel at its own angle. The **hull's heading stays readable independently** through a small forward chevron on the hull front plus the track bars.
- The armor glyph includes the hull-front chevron in both renders, so switching A to B changes only the barrel. It does not redraw the symbol.
- Section 1 already states the rule: the symbol shows every orientation the simulation tracks and never invents one. Render B may not be used until the simulation tracks a second orientation.

**National marker to tactical symbol (Principle 2, made concrete)**
- **Constant:** plate silhouette, faction hue, ownership cue, the category glyph's single trait, and the casing.
- **Added at tactical zoom:** hull detail, tracks, barrel, turret, individual squad members, and the facing-sensitive firing wedge (a separate overlay, Section 7).
- **Not changed:** the plate silhouette never morphs. The detail appears inside it.
- **Open mapping problem:** a national marker represents a *force*, and the tactical view shows *individual units*. Section 1's "same unit" test therefore needs a mapping. This draft keeps the frame grammar per category and per affiliation, so it works under either mapping:
  - one national marker per unit (the plate and glyph map one to one), or
  - one national marker per force (the plate and the force's dominant category glyph).
- Which one is used, and how a mixed force shows composition (for example a count tick), is **OPEN** and decided with the map-systems design.
- *Test:* a viewer matches a national marker to its tactical counterpart by plate shape, hue and glyph trait with no label.

**How stale and last-known marks could differ (not decided)**

Section 1 requires a last-known mark to differ visibly from a live one and leaves the treatment to a later section. The constraint set is below. **Chosen 2026-11-07: hollow plate for stale, dashed inner band for standing orders.**

| Candidate | Works with the grammar | Conflict or cost |
|---|---|---|
| Hollow plate (stroke only, glyph kept) | Rotation-safe, does not touch intensity | Needs the casing and stroke to hold at 2 px minimum (Godot 4.7 line risk below) |
| Hatch fill on the plate | Colourblind-safe, a pattern cue | Territory-B may use a hatch (Section 4). Do not reuse it |
| Age tick or timestamp ("-0:42") near the mark | Carries the actual fact (age of information) | Adds text clutter at national zoom |
| Frozen last-known pose (no rotation smoothing, drawn exactly as last seen) | Honest, no new mark | Subtle. Cannot be the only cue |
| Dashed plate contour | Pattern cue | Candidate second cue for standing orders. Do not reuse it for both |
| **Fading (reduced opacity)** | None | **Conflicts with the one-intensity-axis rule** (Section 1 risk) and with enemy marks that must stay at one fixed intensity. It can also fall under the 3:1 contrast target (Section 4). |

- Rule carried forward: a stale or last-known mark may not be drawn at reduced intensity. Stale marks exist only for full intensity (AP-19.5). Section 1 was amended 2026-11-07 to drop "fading" as an example.
- Constraint: the stale treatment and the standing-order second cue must be different cues.

### Terrain and environment geometry

**Principle S3: The coastline is the identity; everything else is quiet.** *Serves: The Country Is the Battlefield (Pillar 1).*
- **What dominates:** large flat land polygons with a single continuous coastline stroke against the darker sea. The country is recognisable by its outline alone, and the archipelago's islands are the first thing a viewer reads on the whole-country map.
- **Rule for islets:** an island that would fall below a minimum drawn size becomes a dot, never disappears. Dropping an island deletes a fact, and the archipelago is the identity.
- **Coast treatment:** one continuous stroke (colour in Section 4, minimum width in the table below). No decorative shoreline effects.
- **Tactical terrain:** buildings and walls are right-angled structures, vegetation is irregular blobs, and elevation contours are thin curved lines (a tertiary, quietest layer). Cover is a structure or a land shape, never a triangle.
- **Geometry generalisation:** coastlines simplified for rendering at national zoom are a presentation choice. They must preserve every island and every strait that has a simulation or line-of-sight consequence. This depends on the geodata source (prototype P2) and is **OPEN**.
- *What it communicates emotionally:* the land is permanent, quiet and honest, and the human-made and mobile elements stand out against it.

**Minimum stroke widths (recommendations to verify in prototype P3).** The engine reference records that Godot 4.7 draws CanvasItem lines without the antialiasing feather, so lines look thinner (`breaking-changes.md` L31; `modules/rendering.md` L11), and advises widening lines that relied on the old look. That is **an unverified risk** for this line-heavy design. All values below are starting targets. How 4.7 renders them at different display scales is **NOT SOURCEABLE** from `docs/engine-reference/godot/` and needs checking at 1x and high-DPI.

| Element | National zoom | Regional zoom | Tactical zoom |
|---|---|---|---|
| Coastline | 2 px | 2 px | 2 px |
| River core (Sea Night; regional and tactical only) | not drawn | 3 px | 3 px |
| River and lake edge (Chart Grey, each side) | 2 px (lakes) | 2 px | 2 px |
| Territory border (faction hue) | 3 px | 2.5 px | 2 px |
| Mark casing | 1.5 px | 1.5 px | 2 px |
| Any information-bearing line | 2 px | 2 px | 2 px |
| Dashed strokes (if a dashed cue is used) | 2.5 px stroke, dash 6 px, gap 4 px | same | 2 px stroke, dash 6 px, gap 4 px |
| Hatch or pattern lines (Faction B territory hatch only; faction-hue line at 20% alpha, hand-calculated; P3 hatch-legibility test) | 2 px stroke, 8 px spacing | not applicable | not applicable |
| Elevation contours (tertiary, decorative-free) | not drawn | 1.5 px | 1.5 px |
| Active-front border, per side (added by Section 7) | 4 px | 3.5 px | 3 px |
| Graticule (Section 7) | 2 px | 2 px | not drawn |
| Selection box (Section 7) | not applicable | not applicable | 2 px plus 1.5 px casing |
| Firing wedge and range ring (Section 7) | not applicable | not applicable | 2 px plus 1.5 px casing |
| Frontage preview line (Section 7) | not applicable | not applicable | 2 px plus 1.5 px casing |
| Panel frame and chrome dividers, no fact (Section 7) | 1 px | 1 px | 1 px |

- A 1 px line is below the minimum for any mark that carries information.
- If dashes or hatch break up at national zoom in P3, the cue moves to a fill or glyph-based treatment. That is why the standing-order second cue stays provisional.

### UI shape grammar

**Principle S4: The UI obeys the map's shape rules without copying its shapes.** *Serves: The Country Is the Battlefield (Pillar 1) and Section 1 Principle 1.*
- Alternatives considered:
  - (a) UI echoes the plates: chamfered and notched panels. Rejected: a Swallowtail-like notch on a panel could read as a faction cue.
  - (b) A completely distinct HUD language (skeuomorphic or decorative). Rejected: it adds decoration and competes with the marks.
  - (c) **Chosen: hybrid.** UI chrome is rectilinear (structure family): square corners (0-2 px radius), 1 px frames with small corner ticks (a radar-scope idiom), and no forward points. The faction hues are used in the UI only where they carry data (ownership, faction identity). They are never decoration.
- UI chrome never uses Azure, Amber or Command White as fill.
- Circles in the UI are reserved for places, as on the map (objective and range indicators).
- *Test:* take a screenshot with the map hidden. Nothing in the UI reads as a unit, an objective or a faction.
- Detailed typography and iconography belong to Section 7.

### Hero versus supporting shapes

| Rank | Shape | Why |
|---|---|---|
| Hero | Unit plates (agent family), then objective rings | Ownership and force positions are the loudest layer (Principle 1) |
| Secondary | Territory border and tint, accent geometry on the marks that carry it | Region ownership and the selected or alert state |
| Supporting | Callsign tags, labels, range overlays | Human warmth and detail (Section 1 Principle 4) |
| Recessive | Coastline, structures, vegetation, contours, graticule | Land stays below the marks in contrast and saturation (Principle 1) |

### Provisional

1. Forward-point-only-for-agents (S1) is a convention this document proposes. If an air or naval symbol ends up needing a different point logic, revisit.
2. Turret render (A versus B): blocked pending the Pillar 2 re-test and the game-designer's pillar check.
3. Stale-mark treatment (hollow plate) and the standing-order second cue (dashed inner band): chosen 2026-11-07; verify at 16 px in P3.
4. National marker is one unit or one force: OPEN.
5. Whether a seamless zoom or separate views are used (prototype P3) changes the zoom bands in the line table, not the grammar.
6. Intent lines: decided 2026-11-07 (own-only intent lines exist). 7.7 specifies them as solid Chart Mist polylines, distinct from the standing-order cue per Section 1 Principle 3.

### Risks

- The Shield versus Swallowtail notch may blur at 16 px. This is the biggest shape risk and the rotation sweep is its test.
- Glyph reduction may make infantry and support look alike at 16 px. If they do, the nub and the cab need to be exaggerated.
- Per-unit hull and turret layers may strain the 2,000 draw-call starting target (unmeasured). Flag to the technical-artist for batching and atlasing. Also flag that rotating many sprites per frame is unmeasured: **NOT SOURCEABLE** from the engine reference.
- The tank-readability finding comes from one tester who also built the prototype.

## 4. Color System

### Primary palette (7 colours, plus UI-only and derived values)

Luminance and ratios are calculated from hex with the WCAG 2.x formula in sRGB, rounded. They are **not measured in-engine**.

| # | Name | Hex | Luminance (calc.) | Role and meaning |
|---|---|---|---|---|
| 1 | Sea Night | #0B1620 | 0.0075 | The sea, and the mark casing. Darker and cooler than land. |
| 2 | Land Slate | #2B2F2E | 0.027 | The land. A quiet desaturated dark neutral. |
| 3 | Azure (Faction A, working name) | #2E9BE0 | 0.29 | Faction A's identity. A fully saturated faction hue. |
| 4 | Amber (Faction B, working name) | #FFC247 | 0.60 | Faction B's identity. The other fully saturated faction hue. |
| 5 | Command White | #F5F8FA | 0.93 | The reserved accent: "this unit is selected" and "your unit is in combat alert". Never used as a fill. |
| 6 | Chart Grey | #5E6D72 | 0.145 | Coastline, borders of unowned or neutral things, graticule, tertiary terrain lines. |
| 7 | Warm Paper | #E6D9B8 | 0.70 | The human accent: callsigns, veterancy marks, review frame. A low-saturation warm neutral. |

**UI-only values**

| Name | Hex | Luminance (calc.) | Use |
|---|---|---|---|
| Panel Ink | #101A22 | 0.0097 | Panel and plate backgrounds |
| Chart Mist | #9AA8AC | 0.38 | Secondary UI text |

**Derived values: standing-order (reduced-intensity) colours.** Section 1 requires reduced intensity for own units on standing orders.

| Name | Hex (approx.) | Luminance (calc.) | Rule |
|---|---|---|---|
| Azure Standing | #247FB9 | 0.19 | Full Azure scaled to about 0.65 luminance |
| Amber Standing | #D29F39 | 0.39 | Full Amber scaled to about 0.65 luminance |

Define reduced intensity as a **luminance target**, not a percentage of RGB. Both factions step down by about the same ratio (about 1.4 to 1 for Azure and 1.5 to 1 for Amber as contrast ratios on a dark ground; about 1.5 to 1 for both as plain luminance ratios), so the cue reads equally for both.

### Why these hues (alternatives considered)

- **Faction pair, chosen: Azure versus Amber.**
  - It is the blue-yellow axis, which is the axis that survives red-green colour-vision deficiency (deuteranopia and protanopia). It also continues the prototype placeholders (cyan player, amber enemy).
  - Alternative: blue versus red. Rejected: it reproduces the two halves of the Philippine flag and the red-and-blue pairing of other real flags, and red is near-confusable with amber under protanopia and deuteranopia.
  - Alternative: teal versus magenta. Avoids every real flag, but it fails the red-green axis worse (magenta reads as blue under both deficiencies).
  - **Honest weaknesses of the chosen pair:**
    - (1) Tritanopia is the pair's weakest case. Blue and yellow converge toward teal and pink there. The luminance gap (about 1.9 to 1, calculated) and the plate shapes carry the pair in that case.
    - (2) Blue plus yellow is the pairing of a real current national flag (Ukraine) and also of a number of others. Azure leans cyan and Amber leans orange-gold to stay away from those exact hues. The two are never placed as adjacent bands, and no sun, star or stripe motif is used. Whether this is distant enough is a creative-director and legal-review call. It is not legal advice.
- **Accent, chosen: Command White (near-white).**
  - Under the red-green deficiencies, the only hues that stay distinct from both Azure and Amber are neutrals. White differs from both in hue and luminance (calculated 2.9 to 1 against Azure, but only 1.5 to 1 against Amber).
  - Alternative: magenta or hot pink. Distinct for normal vision and tritanopia, but under deuteranopia and protanopia it reads as blue and is confusable with Azure. This is reasoned, not measured. Its luminance is also close to Azure's.
  - Alternative: lime green. Confusable with Amber under red-green deficiencies.
  - Alternative: red or orange. Excluded: near Amber in hue and luminance.
  - Because white is close to Amber in luminance, the accent is carried by **geometry and animation**, not colour alone (below).
- **Neutrals:** Land is lighter than the sea by design. The land-sea ratio is only about 1.35 to 1 (calculated), so the coast depends on the Chart Grey stroke to be crisp.
- **Warm Paper** is the human accent. It carries the warmth that Section 1 Principle 4 calls for. It is low in saturation to keep it away from Amber.

### Semantic colour usage

| Colour | Communicates | Never used for |
|---|---|---|
| Azure | Faction A ownership: plates, territory border, objective ring, own-faction data | Decoration, UI fills, neutral things |
| Amber | Faction B ownership: same uses | Warnings, caution or damage |
| Command White | Brackets ("selected", static), diagonal ticks ("combat alert", pulsing), text emphasis (hover and pressed button labels count as text emphasis *(clarified 2026-11-07)*) | Fill, labels, territory, any faction identity |
| Chart Grey | Coast, river and lake edges, neutral or unowned objects, graticule, terrain lines | Marks (units, ownership, state, text). Terrain lines that carry a simulation fact are drawn in Chart Grey as terrain, not as marks |
| Warm Paper | Callsigns, veterancy marks, review frame, own-force data readouts (status strip, locate tick), the review scrub playhead, and control fills in the UI (toggle inner square, slider handle, segmented-selector underline, feed category cell) *(extended 2026-11-07)* | Plate fills, anything unit-coloured |
| Sea Night and Land Slate | The ground and the casing | Marks |
| Panel Ink and Chart Mist | UI panels and secondary text | Terrain or unit marks. Allowed for UI overlays drawn over the map, including the selection box, frontage preview line, slot squares and intent polylines, and for the review-state changed-border outline *(clarified 2026-11-07)* |

- **No red and no green anywhere.** Ammo, damage, strength and status are shown by fill level, numerals and shape, not by traffic-light colour. Red and green are the pair most likely to fail for the largest group of colour-blind players, and no pillar requires them.
- **One intensity axis.** Intensity is used for one state only: under command (full) versus standing orders (reduced), own faction only. Enemy marks are always at full. Mood never touches marks (Section 2). A stale mark does not use intensity (Section 3).
- **Accent separation (two meanings, one hue):** selection and combat alert must differ without colour.
  - **Selected** (*clarified 2026-11-07: the unit is in the current selection set; formerly "commanding"*): four static L-shaped corner brackets, aligned to the screen (not rotating with the unit), around the plate's rotated extent (dimensions in the accent geometry values below).
  - **Combat alert:** four short diagonal ticks at the plate's corners that expand outward in pulses (maximum 2 Hz, for about 3 s, then held static while the condition lasts). Starting pulse: 4 pulses at a 0.75 s period (about 1.33 Hz) over 3 s, by transform only (no opacity), then held static at the rest offset.
  - A unit that is selected and in alert shows both, and they stay distinguishable because the geometry and the motion both differ.
  - Provide a reduced-motion setting that holds the alert ticks static. Detailed accessibility settings belong in `design/accessibility-requirements.md`.
  - **Accent geometry values (starting values, verify in prototype P3; logical px at the 1920 x 1080 reference).**
- Bound: B = 0.707 x plate length L, the screen-aligned bound of the plate at any heading (W = L upper bound, as in AP-7). The real bound is smaller if the plate is narrower, so the box can look up to about 3 px loose at national.
- Brackets: 2 px Command White with 1.5 px casing. The stroke centre line sits 3 px outside B.
- Ticks: 2 px Command White with casing, 45 degrees, screen-aligned, starting 3 px beyond the bracket corner along the diagonal. A pulse moves them outward along the diagonal by the expansion distance, then snaps back.
- Values by band (L / bracket-box half-side to stroke centre / arm / tick length / pulse expansion): national 16 / 14.3 / 6 / 4 / 4; regional 24 / 20 / 8 / 5 / 6; tactical infantry 28 / 22.8 / 9 / 5 / 8; support 44 / 34 / 12 / 5 / 8; armor 48 / 37 / 12 / 5 / 8; artillery 56 / 42.6 / 14 / 5 / 8.
- Tag, stub and status strip are anchored at the bracket-box half-side plus 5.5 px (2.5 px of stroke half-width and casing, plus a 3 px clear gap): 19.8 / 25.5 / 28.3 / 39.5 / 42.5 / 48.1 px from the unit centre. The anchor applies whether or not the unit is selected, so nothing jumps on selection.
- Hand-checked collisions: the national stub (x within ±6) clears the bottom arms by position, since the stub top is 19.8 px and the bracket casing ends at 16.8 px. Tactical infantry ticks sit about 10 px outside the strip's half-width (15.5 px). The strip clears the top arms because its lower edge is at the anchor.
- **Territory:** a faction-hue tint at 10% alpha (starting value, P3) plus a faction-hue border. **Territory pattern (PROVISIONAL):** Faction A solid tint, Faction B fine 45-degree hatch (2 px faction-hue line, 8 px spacing, 20% alpha, hand-calculated; full-alpha lines would average about 0.19 over the area, far above the 0.065 ceiling), contested both. The pattern is the colourblind backup for tint-only ownership.

### Colour temperature rules

- Only the neutrals shift temperature, at near-constant luminance (Section 2 table). Faction hues and the accent are constant in every state.
- The overview ground is cool-neutral, the tactical ground is warm-neutral, and the fall-back ground is cooler. Review and menus are distinguished by chrome tone and layout, not by ground.
- A day/night shift is not used (no time of day in the simulation).
- If a seamless zoom is adopted (prototype P3), the overview-to-tactical temperature shift interpolates with zoom level.

### UI palette and where it diverges from the map palette

- The map palette is the seven primaries. The UI adds Panel Ink and Chart Mist and uses Warm Paper and Command White for text.
- Divergences:
  - UI chrome never fills with a faction hue (Section 3 S4).
  - Text uses Warm Paper or Command White on Panel Ink, never faction-hue text.
  - Secondary text uses Chart Mist, never Chart Grey, which is below the 4.5 to 1 text target on Panel Ink. Disabled controls are exempt and may use Chart Grey with a one-line reason in Chart Mist *(clarified 2026-11-07)*.
  - The accent in the UI marks only the thing selected.
- Interface typography belongs to Section 7.

### Contrast guidance (targets to verify, not measured facts)

Targets, borrowed from WCAG 2.x practice: at least 3 to 1 for non-text marks against their surroundings and at least 4.5 to 1 for text. Calculated from hex:

| Pair | Ratio (calc.) | Meets target? |
|---|---|---|
| Azure on Land Slate | 4.4 to 1 | Yes (3:1) |
| Azure on Sea Night | 6.0 to 1 | Yes |
| Amber on Land Slate | 8.4 to 1 | Yes |
| Amber on Sea Night | 11.4 to 1 | Yes |
| Command White on Land Slate | 12.7 to 1 | Yes |
| Azure Standing on Land Slate | 3.1 to 1 | Marginal |
| Azure Standing on its Sea Night casing | 4.2 to 1 | Yes |
| Amber Standing on Land Slate | 5.7 to 1 | Yes |
| Amber Standing versus Azure Standing | 1.8 to 1 | Luminance backup only |
| Chart Grey on Land Slate | 2.5 to 1 | **No, by design (below)** |
| Chart Grey on Sea Night | 3.4 to 1 | Yes |
| Warm Paper on Panel Ink (text) | 12.5 to 1 | Yes (4.5:1) |
| Chart Mist on Panel Ink (text) | 7.2 to 1 | Yes |
| Azure versus Amber | 1.9 to 1 | Luminance backup only |
| Command White versus Amber | 1.5 to 1 | Luminance backup only. Geometry carries it |

- **Mark casing is mandatory.** Every mark carries a 1.5-2 px Sea Night outline. The composite background under a mark (terrain fill plus any territory tint) has two ceilings (hand-blended in gamma space, tool-verify): terrain fills alone at most about 0.04, and fill plus territory tint (10% alpha) at most about 0.065 (Amber over a 0.04 fill about 0.063, Azure about 0.052; a linear blend would read higher and must be checked in P3) *(amended 2026-11-07)*, but a reduced-intensity mark on a lighter terrain fill can drop below 3 to 1 (Azure Standing on a 0.04 fill is about 2.7 to 1, and on the 0.065 composite about 2.1 to 1, hand-calculated). The casing guarantees the local contrast regardless of what is underneath.
- **Chart Grey is below 3 to 1 against land, on purpose.** Principle 1 says terrain sits below marks. The land-sea step does most of the work of the coast and the line only crisps it. If P3 shows that islets or the coast are lost at national zoom, raise Chart Grey to #6E7C80 (calculated 3.1 to 1 on land, 4.2 to 1 on sea).
- **Headroom for the intensity axis is narrow.** Full Azure to Azure Standing is only about 1.4 to 1 (calculated). Brightness alone cannot carry the full-versus-standing cue, so Section 1's second cue is mandatory.
- Godot's colour-space and HDR behaviour for these values is **NOT SOURCEABLE** from `docs/engine-reference/godot/` (the engine reference lists HDR output as a 4.7 feature but not its behaviour). Author in sRGB and verify in-engine in prototype P3.

### Colourblind safety

**Colourblind distinguishability in this section is reasoned, NOT measured.** The statements below come from the known behaviour of the three deficiency types and from the luminance values calculated above. They have not been tested with simulation or with colour-blind players.

| Pair | Where it could fail | Backup |
|---|---|---|
| Azure versus Amber (factions) | Tritanopia is the weak case. A weaker one under other deficiencies is low luminance gap (1.9 to 1). | Plate silhouette (Shield versus Swallowtail), the luminance gap, a callsign tag, the territory pattern, and per-player callsigns. Sound cues belong to the audio-director. |
| Command White versus Amber | Tritanopia, and a small luminance gap (1.5 to 1). | Accent geometry (screen-aligned brackets and ticks), not hue. |
| Under command (full) versus standing (reduced) intensity | A luminance-only difference of about 1.4 to 1 is easily lost on small marks and cheap displays. | The standing-order second cue (PROVISIONAL, candidates in Section 3). Not brightness alone. |
| Territory tint versus tint | Low-alpha tints of Azure and Amber converge toward neutral. | Territory border plus the fill pattern. |
| Warm Paper versus Amber | Similar hue and moderate luminance gap (0.70 versus 0.60). | Warm Paper is only used for text on a dark plate, never as a mark fill, and sits apart from marks. |
| Chart Grey versus Azure Standing | Similar luminance (0.145 versus 0.19), and hue is lost without colour vision. | The plate, casing and glyph. Terrain is a line, units are plates. |
| Live versus stale mark | Depends on the unchosen treatment. | Must differ by shape or pattern, not hue or intensity (Section 3). |

- **No red-green semantics anywhere.** No pair in this system depends on distinguishing red from green.
- Sound backup (for example a distinct cue for combat alert versus selection) is for the audio-director to decide. This section only says that a non-visual backup should exist for the alert.

**How it will be verified**
1. Produce reference screenshots: overview and tactical, with both factions, the accent states, standing orders, a stale mark and the territory patterns.
2. Run each through simulated deuteranopia, protanopia and tritanopia (for example a Machado-model simulator), plus a greyscale pass.
3. **Pass criteria:**
   - (a) Every faction, accent and standing-order pair is distinguishable in a 2-second glance by a naive reviewer, in each of the four renderings (three simulations plus greyscale), **without relying on hue**.
   - (b) The rotation sweep (Section 3) is passed in greyscale: plates are sorted into A and B at 8 headings and 3 sizes with no errors.
   - (c) Live and stale marks are distinguished in all four renderings.
   - (d) Accent brackets and alert ticks are told apart from each other and from every faction plate in all four renderings.
   - (e) Text meets 4.5 to 1 and marks meet 3 to 1 on a tool-recomputed table.
4. A miss on any criterion is a failure, and the corresponding cue moves to a shape or pattern backup.
5. Simulation is a screening step only. The recommended follow-up is a playtest with at least two players who have a diagnosed colour-vision deficiency. Do not mark colourblind safety as validated before that.

### Provisional

1. The exact hexes are working values pending the prototype P3 render and the verification above.
2. Whether a faction's hue is fixed per faction (as assumed here) or "friendly is always Azure" is not decided. Fixed per faction keeps shared screenshots consistent in a multiplayer setting and is recommended, but the user has not chosen.
3. Faction names, insignia and final plate shapes are open (fictional, no real flags or combatants).
4. The accent geometry, the territory pattern, the standing-order second cue and the stale treatment are PROVISIONAL.
5. A9: the enemy-presence rule behind Principle 3 holds as long as enemies see nothing. If A9 changes, the enemy-intensity rule (and this section's "enemy marks always at full") changes with it.
6. Mood's use of the ground (Section 2) depends on the creative-director confirming that an ambient layer is not a "mark".

### Risks

- Azure and Amber leave little room for a third saturated hue. The accent is a near-neutral, so any later status colour (objective states, warnings) must be shape or text, not a new hue.
- The blue-yellow pairing has real-flag adjacency (see above). Get a creative-director and legal-review opinion before locking.
- White as an accent is shared with the type palette. Keep text off the map layer so a label is never mistaken for an accent.
- Hand-calculated luminance may differ by a small amount from tool output. Recompute before locking.
- Reduced-intensity marks have almost no headroom (3.1 to 1 on land).

## 5. Character Design Direction

In this game the "characters" are units. There is no player avatar, no portrait, no rig and no 3D. This section covers how units are told apart (own, ally, enemy, neutral), how they move and give feedback, and how much detail they carry at each zoom. Every rule here comes from Section 1's two questions: which simulation fact does this mark encode, and who may know it.

Locked inputs used without change:
- The plate (Shield for Faction A, Swallowtail for Faction B), the category glyph, the tactical detail and the mandatory casing (Section 3 S2).
- The palette, with no red and no green (Section 4).
- One intensity axis, own side only (Section 1 Principle 3).
- No ambient animation without a simulation fact, and mood never touching marks (Section 2 M1 and M2).
- The accent: static screen-aligned brackets for "selected" and diagonal ticks for "combat alert" (Section 4).
- The alert pulse (max 2 Hz for about 3 s, then held static) and the reduced-motion setting for the ticks (Section 4).
- The capture ring pulse (about 1.2 s) and territory tint (about 2 s) (Section 2 State 3).

### Governing rules

**Principle C1: The commander is never drawn. The force carries the human.** *Serves: Your Force Is Yours (Pillar 3) and Section 1 Principle 4.*
- The player is an unseen commander. Nothing on the map represents the player as a body, a headquarters, a cursor avatar or a "you are here" pin. None of these has a simulation fact behind it, so each would invent one.
- Exactly two things stand for the commander, and both are facts:
  1. The Command White brackets on whatever the commander has selected (locked, Section 4).
  2. The callsign tag on the commander's own units (Principle 4: callsigns are the warm human accent).
- This section decides nothing that belongs to the concept. Whether a player commands one unit, a squad or a force (A5), and whether callsigns are per player or per unit (Section 1 says "per-player identity in a callsign or tag"; Section 2 State 3 shows "callsigns of your own participating units"), are open. The tag is drawn as a generic "callsign" slot that works for either.
- *Alternatives considered:*
  - (a) A per-player emblem. Rejected: it needs up to 50 designs, risks reading as a faction insignia, and Section 1 already says per-player identity lives in a callsign or tag.
  - (b) A commander marker at an HQ or home position. Rejected: the concept defines no such object.
  - (c) A commander portrait or avatar in the UI. Not a map mark and not decided here. Handed to Section 7 and the ux-designer.
  - (d) **Chosen:** callsign tag plus accent brackets only.
- *Test:* delete the callsign tags and the brackets from a screenshot. Nothing remaining on the map implies a person.

**Principle C2: Faction is read from the plate, ownership by you from the tag, and nothing else varies.** *Serves: Your Force Is Yours (Pillar 3) and Section 1 Principle 3.* **[PROVISIONAL on A8 and A9]**
- Faction (A or B) is read from plate silhouette first and hue second. Both are locked.
- "Mine" is read from a **non-intensity, non-accent cue** on own units only. Intensity is spent on under command versus standing orders. The brackets are reserved for "selected". The diagonal ticks are reserved for "alert". Dashes are held for the standing-order second cue, hollow plates for the stale mark, and hatch for Faction B territory.
- The own-force cue is the **callsign tag** (Warm Paper text on a Panel Ink backing) below the plate. Where the text cannot be read (national band), it collapses to the **tag stub**: a Warm Paper bar about 12 x 4 px on a Panel Ink backing, pinned below the bracket envelope (bracket-box half-side plus 5.5 px, Section 4 accent geometry values) and screen-aligned. The stub is a rectangle (structure family) and points nowhere.
- The tag and stub keep one fixed colour in every state. A standing-order own unit (dimmer plate) is therefore the easiest case to lose, and its tag stays at full strength to compensate.
- *Alternatives considered for the own-force cue:*
  - (a) A brighter own plate. Rejected: spends the intensity axis a second time.
  - (b) A thicker or coloured casing for own units. Rejected: the casing encodes nothing, by rule.
  - (c) Command White brackets on all own units. Rejected: overloads "selected", and the 2-second test would then depend on the player's current orders.
  - (d) A larger own plate. Rejected: a larger own plate would make size an ownership cue, and at tactical zoom plate size already encodes category. National and regional plates are the same size for every category.
  - (e) A circle around own units. Rejected: circles are the places family (Section 3 S1).
  - (f) **Chosen:** the tag and stub.
  - A "jump to my force" control and a force list are a complementary UI aid, not a substitute. Handed to Section 7 and the ux-designer.
- *Test (find my force):* a naive viewer is shown a screenshot of about 60 marks (30 per faction, half of own units on standing orders). Each viewer is asked to point to the nearest own unit. At least 90% of at least 8 viewers do so in 2 s or less. Run in colour, greyscale and the three colour-vision-deficiency simulations (Section 4's method). The test is run with the stub at its anchored distance (about 12 px from a 16 px plate at 0 degrees); record the nearest-own-unit errors that distance causes. A miss moves the cue to a larger, non-hue shape or a smaller offset.

**Principle C3: Motion is a fact with an owner, a duration and an end.** *Serves: Section 1's rule, Section 2 M2, and Hands-On Command (Pillar 2) for legible facing.*
- Every animation is one of three kinds, and nothing else exists:
  1. **Continuous.** Position and rotation interpolated between simulation ticks.
  2. **Event.** A one-shot mark with a stated duration, tied to a simulation event.
  3. **Held state.** A static change that lasts while a condition lasts.
- **No opacity changes on any mark, ever.** No fades in, fades out, pulses of brightness or cross-fades between zoom detail levels. Opacity is a brightness change, and brightness is the intensity axis (Section 1 Principle 3, Section 3 stale rule). Marks appear and disappear in one frame, or change by shape.
- **No extrapolation.** Render at most one tick behind the latest authoritative state. Never predict a position or path beyond the last known state. Prediction invents a fact and, for an enemy, leaks one.
- **One render path.** Every unit's interpolation, rotation, firing and loss presentation runs the same code regardless of who controls it. Nothing in the render path for a non-own unit takes controller state (human, AI, standing orders, online, offline) as an input.
- *Engineering sign-off:* one render path, no extrapolation and at most one tick behind are engineering requirements as well as art rules. They need technical-director sign-off before they are treated as locked. PROVISIONAL until given.
- *Test (leak test, extended from Section 2 M2):* render the same frame in the four M2 conditions. All unit pixels are identical. Then add a hidden enemy firing at one of the viewer's units. The screenshot differs only by feedback on the viewer's own unit, and no mark points toward the shooter.

**Principle C4: Detail follows zoom. The plate does not.** *Serves: Section 1 Principle 2.*
- The plate silhouette, hue, glyph trait and casing are identical in every band (locked in Section 3). Bands add detail inside the plate and never swap the symbol.
- A band change swaps detail in one frame with a small hysteresis. It never cross-fades.

### Who is who: the unit-state grammar

| | Own | Ally (faction-mate, multiplayer only) | Enemy | Neutral |
|---|---|---|---|---|
| Plate and hue | Own faction's | Same faction's | Opposing faction's | None. There is no neutral combatant in the concept. |
| Intensity | Full when under command, reduced when on standing orders (own-only) | **Fixed at full** until A8 and A9 decide whether faction-mates see presence | **Fixed at full**, always | Not applicable |
| Callsign tag and stub | Yes | Not shown until decided (D3) | Not shown until decided (D3) | Not applicable |
| Accent brackets (selected) | Yes | No | No | No |
| Alert ticks | Yes | No (A8) | No | No |
| Standing-order second cue | Yes (own-only, dashed inner band) | No | Never | No |
| Visibility class | Owner-only for state, tag and accent | Faction-only, **OPEN** (A8) | Line-of-sight gated | Public (objectives and territory in Chart Grey) |

- The MVP has no allies (no allied AI). The Ally column applies only when multiplayer faction-mates exist.
- "Neutral" is limited to what Section 4 already defines: unowned objectives and territory in Chart Grey. No neutral unit entity is invented here.
- Enemy units get no tag, stub, bracket, tick or second cue. The leak test above covers this.
- *Test (glance):* a viewer sorts 20 mixed plates into A and B at 100% accuracy in greyscale. This is the same rotation-sweep standard as Section 3.

### Motion and feedback rules

All durations are starting values to tune in P3. **They are PROVISIONAL on A3** (simulation clock versus wall clock) and on the simulation tick rate, which is not decided and is NOT SOURCEABLE from the engine reference.
- Presentation events (tracers, loss mark) run on a presentation clock. If a pause, slowdown or time-skip exists, whether that clock follows the simulation clock is decided with A3.
- During any time-skip no event marks are drawn. The after-action review summarises instead.

| Event (the fact) | Visual | Visibility | Duration and limits |
|---|---|---|---|
| Movement (position changed) | Interpolated translation. No walk cycle, tread scroll, bob, dust or speed lines. Track bars stay static. | Own always. Enemy only inside line of sight (Pillar 2). | Continuous. Lag is at most 1 tick. No extrapolation. |
| Turning (facing changed) | Whole symbol rotates by the shortest arc, at the simulation's real turn rate. If the simulation turns instantly, the symbol turns instantly. | Same as movement | Continuous. No added easing. Render B turret (independent) only if the simulation tracks a second orientation (Section 3). |
| Appearing (a unit enters line of sight) | Drawn at its current position in one frame. No slide, fade, ping or flash. | Line-of-sight gated | 0 s |
| Firing (a shot occurred) | A **tracer line** from the barrel tip to the shot's endpoint, in the shooter's faction hue, 2 px plus the mandatory casing. The endpoint is the target if hit, or the impact point if the simulation models misses. | Drawn **only if the viewer can see the shooter**. If an unseen shooter hits a viewer's unit, the viewer sees feedback on their own unit only (see Hit). No tracer, no direction. | Tactical band only. 0.2 s if hitscan, or the real flight time if the simulation has projectiles (mark which in the combat GDD). Overlapping identical tracers merge into one held line. No shot is dropped. |
| Hit (damage landed on a unit) | **Own unit:** alert ticks start (locked behaviour) and the optional strength strip steps down in one frame. **Enemy unit:** the tracer end only. | Own: owner-only. Enemy: line of sight only. | Alert ticks follow Section 4 (max 2 Hz, about 3 s, then static while the condition lasts). |
| Standing-order change (own unit goes on or off standing orders) | The plate steps between full and reduced colour in one frame and the second cue switches. | Owner-only | Instant. An eased transition would show an intermediate state that does not exist. |
| Loss (a unit ceased to exist) | See **Loss mark** below. | Own: always. Enemy: only if visible when it was lost. | 1.5 s hold (starting value). |
| Capture (objective changed hands) | **No unit animation.** The event belongs to the objective ring: Section 2 State 3 (about 1.2 s ring pulse, about 2 s tint). | Public | Locked. Participating own units' callsigns appear in Warm Paper on a plate, as locked. |
| Stale or last-known mark | Treatment: hollow plate (Section 3). Constraint: the live-to-stale switch happens in one frame, uses no opacity and does not animate. | Per the stale rule | Instant |

**Loss mark (L2 chosen 2026-11-07; Section 3 S1 amended to allow it; still PROVISIONAL on playtest confusion with the objective pulse).**
- Drafted default (L2): the plate is removed in one frame. A 2 px circle in the unit's faction hue, with casing, sized to the plate, stays at the location for 1.5 s and then is removed. It is static, with no opacity change.
- Why: Pillar 3 says losses cost something, and an instant disappearance is easy to miss.
- Resolved: Section 3 S1 was amended 2026-11-07 so the places family includes the one-off loss mark ("a place where an event occurred"). The remaining risk is closeness to the objective ring pulse.
- Separation from the ring pulse: diameter at most 1.5 times the plate length (objective rings are larger), no outward movement, and it is static for its whole life. Whether that is enough is a playtest question.
- Fallback (L1), only if playtest shows L2 is confused with the objective pulse: instant removal plus a text line in the event feed and the after-action summary (Section 7). No new mark.
- Withdrawal and falling back intact (Pillar 4) are not losses and show no mark. The unit simply moves.
- *Alternatives rejected:* a cross (diagonals collide with alert ticks), a plus sign (resembles a real medical insignia), a wreck sprite (invents a persistent object unless the simulation keeps wrecks), and a fade (opacity).

**Hit direction.** Whether a viewer is told the direction of an unseen attacker is a gameplay decision (Pillar 2 line of sight). The art default is no direction. Revisit if the game-designer decides otherwise.

**Reduced-motion setting.** This extends the setting Section 4 already requires for the alert ticks. Detailed settings belong in `design/accessibility-requirements.md`.
- When on:
  - Alert ticks are held static (locked).
  - Ring pulses are replaced by an immediate redraw of the final state.
  - Tracers appear as static lines for their normal duration.
  - The loss mark is already static.
  - Band swaps are already instant.
- Position and rotation interpolation cannot be removed, because unit displacement is the game. A "snap to tick" option that draws each tick without interpolation is offered at the cost of smoothness.
- No camera shake exists (locked in Section 2).
- *Test:* with the setting on, a recorded 60 s engagement contains no moving or changing mark other than unit displacement, rotation and the one-frame state changes listed above.

### LOD philosophy and detail budget

Three bands are used, matching Section 3's stroke table. **Zoom thresholds in world units are NOT decided** and depend on the P3 result (separate views or seamless zoom). Sizes are plate length along the facing axis, in screen pixels, and are recommendations to verify in P3. Marks are screen-size constant per band. A plate's size never encodes the unit's physical size, and a unit's position is its centre point.

| | National | Regional | Tactical |
|---|---|---|---|
| Plate length | 16 px (the locked minimum), all categories | 24 px, all categories | Infantry 28, Support 44, Armor 48, Artillery 56 px |
| Survives | Plate, casing, glyph trait (nub, bar, long bar), accent brackets and ticks, own tag stub | Same, plus own callsign tag (first 4 characters) | Everything |
| Added | none | Tag text | Hull, tracks, turret ring, barrel, squad figure dots (max 8), tracer lines, optional status strip (own only), veterancy ticks (own only, PROVISIONAL) |
| Lost versus the next band | Tag text, tactical detail | Tactical detail | none |

**Per-unit detail budget (stated as layers, because draw-call behaviour is not sourceable).**
- Layers: (1) casing, (2) plate fill, (3) glyph knockout, (4) tactical detail, (5) accent geometry (own, conditional), (6) callsign tag or stub (own, conditional), (7) status strip (tactical, own, PROVISIONAL).
- Layer counts per own unit: national 3 plus the stub, regional 3 plus accent plus tag, tactical up to 7. An enemy unit never exceeds layers 1 to 4.
- **Tactical detail cap (layer 4; decided 2026-11-07; starting values, verify in P3).** Layer 4 may be richer than the prototype's, but only with facts, baked into the frame (no extra draw call, no extra frame, no change to E3, C3 or E6). Each detail stroke must name a simulation fact (hull extent, track bar = tracked movement, turret ring and barrel = weapon, nub or cab = category trait). Stroke caps per category at tactical: infantry 9 (up to 8 figure dots plus the nub), support 6, armor 8, artillery 7. A stroke is one drawn line or closed shape outline, 2 px minimum, with at least 2 px between strokes. Flat fills only (Sea Night knockout on the plate): no texture, gradient, shading, tread segments or rivets. Regional and national frames carry none of it. Firing flash, hit marks and wreck presentation get no budget yet; they are revisited after the Pillar 2 re-test.
- Whether Godot merges draw commands across CanvasItems by texture or material is **NOT SOURCEABLE** from `docs/engine-reference/godot/`. Render cost is unmeasured. The budget is to be measured in P3 against the 2,000 draw-call starting target (unmeasured).
- Proposed starting allocation for the technical-artist to confirm: marks up to 600, terrain up to 600, UI up to 300, reserve at least 500 of the 2,000.
- Three build options are offered to the technical-artist:
  - **(i) Recommended to test first:** bake layers 1 to 4 into one frame per (faction x category x band x intensity state) and rotate it by transform. That is 24 frames for the MVP's 2 categories (2 categories x 3 bands x 4 colour variants: Azure full, Azure standing, Amber full, Amber standing), and about 48 with 4 categories. Stale frames exist only for full intensity (AP-19.5), so a baked stale treatment adds 50% (36 MVP frames, 72 with 4 categories), and the standing-order second cue replaces pixels in the standing frames and adds none (8.E, 8.R #4). Layers 5 to 7 stay separate overlays.
    - It uses fixed baked colours, so no alpha modulation is needed for intensity.
    - It may avoid the line-feather risk of vector lines (see Risks).
    - How filtered rotation of baked frames looks is **NOT SOURCEABLE** and needs a P3 check.
  - (ii) One sprite per layer. More draw commands, simpler authoring.
  - (iii) Vector drawing per unit each frame. This hits the line-feather issue directly.

**Veterancy marks and callsign tags (human warmth, Principle 4).**
- **Callsign tag:**
  - Warm Paper text on a Panel Ink backing, square corners, no frame. The backing doubles as the casing.
  - Screen-aligned: it never rotates and never points.
  - Anchored below the rotated-extent bound plus the bracket envelope (inner edge at the bracket-box half-side plus 5.5 px, 3 px clear of the bracket casing, Section 4 accent geometry values), whether or not the unit is selected. The plate's forward point is therefore never obscured at any heading. Starting values, verify in P3.
  - Typeface and minimum size belong to Section 7. The minimum cap height is 8 px at every band that shows text (set by Section 7; was a 7 px placeholder), to verify in P3.
  - Collisions: hide in this order, last first (own under command, own standing, others). A tag is never moved far enough from its plate to be mistaken for another unit's.
  - Visible to its owner. Faction-mates and enemies are PROVISIONAL (D3).
- **Veterancy marks (PROVISIONAL on B8 and the combat design):**
  - They exist only if the simulation records an experience level. Otherwise they are not drawn.
  - Form: 1 to 3 short horizontal Warm Paper ticks on the tag backing, at tactical band only (more levels use a numeral). Never on the plate.
  - **Banned:** chevrons (forward points, S1), stars (flag motif) and any pip pattern on the plate that collides with the armor track bars or squad figure dots.
  - Own-only by default, because showing an enemy's veterancy shows a stat.
- *Alternatives considered for veterancy:* plate border thickness (casing is constant), glyph colour (hue is faction), a numeral on the plate (clutter at 16 px). The tag-hosted ticks are chosen.

### Cross-section legibility (unit side)

A plate with its casing must read against the densest terrain composite allowed by Section 6. The test is **X1, defined in Section 6 (E5)**. The unit-side requirements it checks:
1. Plate-to-casing luminance of at least 3:1 for all four plate fills.
2. A closed casing ring at every size and heading.
3. The rotation sweep passing over the densest composite.
4. The casing being the darkest band across any plate-to-terrain edge.

### Provisional

1. **A9:** enemy presence. The "enemy fixed at full" rows assume enemies see nothing.
2. **A8:** allies' intensity, ticks, tags and second cue.
3. Intent lines: decided 2026-11-07 (own-only intent lines exist; on-map queue marks are specified in Section 7 7.7). Still open: whether the queue persists after deselection.
4. Independent turret orientation (Render A versus B).
5. The stale-mark and standing-order cues are chosen (Section 3, 2026-11-07). Verify at 16 px in P3.
6. One national marker per unit or per force (OPEN). If per force, a count indicator is needed and is not designed here.
7. Seamless zoom versus separate views (P3).
8. B8 veterancy, and whether the simulation records experience at all.
9. A3 clocks and the tick rate, for all durations.
10. The loss mark (L2 chosen, S1 amended 2026-11-07; still open on playtest confusion with the objective pulse), and whether units are destroyed or routed.
11. The status strip content (defined with the combat GDD) and whether enemy strength is shown inside line of sight (a game-design decision).
12. The "active front" overlay at national zoom. Section 1 Principle 1 requires it to read. Section 5 defines no unit animation for it. Handed to Section 7.

### Risks

- The tag stub may not pop out among 60 marks at 16 px. The find-my-force test is the guard. Fallback is a larger non-hue shape.
- Warm Paper is close to Amber in hue (Section 4 risk 5). The Panel Ink backing and the bar shape are the separation. Verify in the colour-vision-deficiency simulations.
- Godot 4.7 draws CanvasItem lines without the antialiasing feather, so lines look thinner (`breaking-changes.md` L31, `modules/rendering.md` L11). A 1.5 px casing may render unevenly or not as a solid ring at national zoom. Hardware MSAA for 2D is listed as quality but expensive (`modules/rendering.md` L51) and SMAA 1x is listed as new (`breaking-changes.md` L72). Whether either helps here is **NOT SOURCEABLE**. Test the casing at 1x and high-DPI in P3.
- Tracers carry the 1.5 px casing, so a 2 px tracer is about 5 px total. This may be too heavy in a dense fight.
- The loss ring may be mistaken for an objective pulse.
- Interpolating at most one tick behind adds visual latency. This matters for Hands-On Command if the tick is slow (tick rate unknown).
- Many rotating baked sprites per frame is unmeasured: **NOT SOURCEABLE**.
- A hit with no direction may feel unfair to a player under unseen fire. That is a gameplay decision for the game-designer.
- Callsigns are player-entered text. Moderation and length limits are not an art decision.

## 6. Environment Design Language

"Environment" here is the map's ground and the made things on it. There are no scenes and no dressing. The map is drawn flat and the terrain is the quietest layer (Section 1 Principle 1, Section 3 S3 and the hero-versus-supporting table). The terrain and cover data source is undecided (prototype P2), so every rule below is written to hold under all three candidates.

### Governing rules

**Principle E1: Draw the simulation's geometry, never a picture of a place.** *Serves: Section 1's rule and The Country Is the Battlefield (Pillar 1).*
- A terrain element is drawn only if the simulation treats it as at least one of: a line-of-sight blocker, cover, a movement-cost or impassable area, an objective, or an ownership boundary. Everything else is omitted.
- The render is a function of the geometry the simulation actually uses. If the simulation merges ten houses into one blocker, one block is drawn. If it treats each house separately, each is drawn. Presentation never merges, splits or smooths geometry that the simulation does not.
- Footprint categories below are a **presentation vocabulary** mapped from whatever classes the simulation exposes. The simulation, not this section, decides which classes exist.
- How E1 works under each P2 candidate:

| P2 candidate | What is drawn | What is never drawn |
|---|---|---|
| Real elevation plus OSM-derived data | Contours, footprints, roads and vegetation polygons the simulation uses | Detail finer than the data really resolves (a 30 m grid cannot justify tactical-scale contours: false precision invents a fact) |
| Hand-authored overlays | The authored footprints and areas exactly as authored | Any unauthored decoration |
| Coarse line of sight | Area polygons for each line-of-sight class (blocked, partial, open) | Individual buildings that block nothing (they would invent cover) |

- *Test:* for each P2 candidate, a reviewer lists every drawn terrain element in one tactical frame and names its simulation fact. Any element with no fact fails.

**Principle E2: The archipelago is shown by geography, not ornament.** *Serves: Pillar 1, Section 3 S3 and the setting.*
- The country is recognisable by its outline (locked in Section 3). The tropical archipelago character comes from four data-driven things:
  1. Fragmentation: many islands, bays and straits, with every islet kept as at least a dot (locked in S3).
  2. Sea dominance: the sea is the largest area and the slightly darker, cooler ground.
  3. Vegetation mass: dense vegetation is the default inland area and is large and irregular.
  4. Coastal and riverine settlement: built-up areas cluster along coasts and rivers, because the data places them there. This also decides where line of sight is blocked.
- *Alternatives considered for suggesting a tropical setting:*
  - (a) Palm or foliage icons. Rejected: decoration with no fact per icon.
  - (b) Green vegetation. Rejected: no green anywhere (Section 4).
  - (c) A stipple or dot pattern for forest. Rejected: it collides with the infantry figure dots in Section 5.
  - (d) A shallow-water band along coasts (reef shallows). Held back: it is a fact only if the simulation models shallows for landing or naval movement. **PROVISIONAL**, not in the MVP.
  - (e) **Chosen:** geography plus vegetation mass plus settlement pattern, with no ornament.
- **Culture and sensitivity.**
  - No building is distinguished by cultural or religious form. Footprints are rectangles classed by size and arrangement, not by architectural idiom.
  - No real flag, emblem or combatant insignia appears on any structure, and no real landmark is drawn as an identifier of a faction or combatant.
  - A place-of-worship, hospital or school footprint, if the data marks one, is drawn as a civic rectangle with no icon.
  - How civilian areas are treated in the fictional premise is a handoff to the narrative-director.

**Footprint categories (presentation vocabulary).** Structures are the right-angle family (Section 3 S1).

| Category | Shape | Simulation effect (the fact) | Notes |
|---|---|---|---|
| Wall or fence line | Straight segment, 2 px | Cover; blocks line of sight only if the simulation says so | Soft cover |
| Dwelling cluster | Block polygon (rectilinear), or individual rectangles | Line-of-sight blocker, hard cover | Individual footprints only at tactical and only where the simulation treats them separately |
| Compound | Wall lines enclosing an interior block | Walled enclosure: cover at the wall, blocker inside | No guard-tower or gate icons |
| Civic or commercial | Larger single rectangle | Blocker, hard cover | Differs from a dwelling by size only. No function icon. |
| Industrial | Large rectangle or multi-rectangle block | Blocker, hard cover | Same rule |
| Port (post-MVP) | Rectangular quay attached to the coast, squared ends | Movement surface and a possible objective | No pointed piers, no anchor or ship icons |
| Airfield (placeholder, post-MVP) | Long thin rectangle plus apron rectangle | Open hardstand: no cover, long clear line of sight | No threshold chevrons (forward points), no dashed centreline (dashes are reserved), no runway numbers |
| Bridge | Rectangle across a river, squared ends | Movement crossing | A destroyed bridge is PROVISIONAL (E6) |

- Real data hazard: OSM-derived data will reproduce real military bases, ports, airfields and place names. See Risks and decision D5.

**Principle E3: Flat fills and outlines. No texture.** *Serves: Section 1's rule and Section 4's contrast budget.*
- This is flat 2D vector art. It is not painted, not PBR, and has no normal maps, noise, grain, hill-shading or gradients.
- The one gradient on the map is the symmetric contact vignette on the terrain layer, which Section 2 already allows.
- Why:
  1. Any texture is a mark with no fact, which fails the first question.
  2. Texture adds luminance variance, which breaks the 0.04 fill cap and erodes mark contrast.
  3. The pattern vocabulary is already spent. A 45-degree hatch is held for Faction B territory. Dashes are held for the standing-order second cue. Dots belong to infantry. Hollow is held for the stale mark.
- **Allowed visual vocabulary:** a fill step, an outline, a contour line, and the territory tint and border (locked). **No terrain pattern is allowed.**
- Terrain types are separated by outline shape first (straight edges for structures, irregular curves for land) and by a fill step second. The fill steps are small (about 1.1:1), so they are a backup and cannot carry the distinction on a cheap monitor.
- Terrain fill luminance targets (calculated, to be tool-verified, all at or under the 0.04 cap):

| Terrain | Luminance target |
|---|---|
| Sea Night | 0.0075 (locked) |
| Dense vegetation | about 0.020 |
| Light vegetation (PROVISIONAL on P2 classes) | about 0.024 |
| Land Slate (open ground) | 0.027 (locked) |
| Built-up block | about 0.036 |
| Footprint, runway or apron | up to 0.040 (the cap) |

- Polygon edges may alias because lines have no feather in 4.7 (see Risks).

**Principle E4: Density follows facts, and terrain ink has a ceiling.** *Serves: Pillar 1 and Section 3's hero-versus-supporting ranking (terrain is recessive).*
- Drawn terrain that is not a fact is cut. Drawn terrain that is a fact has a ceiling so marks stay louder.
- **Global ceilings (starting values, verify in P3):**
  - Fill luminance at most 0.04.
  - Terrain stroke coverage in any 200 x 200 px window: at most 4% at national, 6% at regional, 10% at tactical.
  - Gap between the stroke edges of two DIFFERENT terrain features: at least 4 px. The rule does not apply between the two edges of one feature (a river's two Chart Grey edges are 3 px apart by design). Narrower gaps between different features are merged only where the simulation geometry is also merged (E1).
  - Contour spacing: at least 12 px at the current zoom. The contour interval widens as the view zooms out, and the interval is shown on the scale chrome (Section 7), because it is a fact.
  - Stroke weights: structure and vegetation outlines that carry a sim fact use the 2 px information-bearing minimum. Pure context contours stay at 1.5 px (Section 3 table).
- **Priority when the ceiling cannot be met without deleting a fact:** drop from the bottom of this list and stop at the first level that fits. Never drop line-of-sight blockers or hard cover.
  1. Line-of-sight blockers.
  2. Hard cover.
  3. Movement-cost and impassable areas.
  4. Soft cover.
  5. Context contours.
  - If the ceiling still cannot be met, that is a P2 and generalisation finding for the user, not a reason to draw less cover (see D4).
- **Terrain budget:** a starting proposal of up to 600 of the 2,000 draw calls (unmeasured). How Godot batches terrain is **NOT SOURCEABLE**. `TileMapLayer` replaces `TileMap` (`deprecated-apis.md` L16); whether either suits irregular polygon terrain is **NOT SOURCEABLE**.

**Area types.** Bands are National, Regional and Tactical (Section 3). "Not drawn" means the omission is deliberate.

| Area type | Facts it may carry | National | Regional | Tactical | Extra ceiling |
|---|---|---|---|---|---|
| **Open sea** (MVP) | Impassable to ground units; open line of sight | Sea Night fill, graticule, islet dots (locked) | Same | Same. Nothing added. | 0 props. Sealift routes are PROVISIONAL (A6). |
| **Coast** (MVP) | Hard edge between sea and land | 2 px Chart Grey stroke, irregular curve, hard edge | Same | Same | Coast stroke only. No wave rings, no foam. |
| **Inland water** (MVP) | Impassable or movement cost | Lakes only, as Sea Night fill with a 2 px Chart Grey stroke (same as the coast) | Lakes plus rivers: a 3 px Sea Night core with a 2 px Chart Grey edge on each side (7 px total) | Same, with fords and bridges | A river core is never narrower than 3 px (7 px with its edges). A river with a movement fact is never dropped. The two edges of one river are exempt from the E4 4 px gap rule; edges of different features are not. Starting values, verify in P3 against the ink ceilings. |
| **Lowland and farmland** (MVP) | Open ground, long line of sight | Base land fill. No marks. | Base fill plus roads | Base fill plus soft-cover lines (hedge, bund, wall) only if the simulation has them | No parcel or paddy boundaries unless they carry cover or movement cost. Crop texture is never drawn. |
| **Dense vegetation** (MVP) | Line-of-sight blocker, movement cost | One irregular polygon in the darker fill. No outline unless it matters at this scale. | Polygon plus a 2 px Chart Grey irregular edge where the simulation treats it as a blocker | Edge plus fill. No trees, no stipple. | One polygon per simulation area. |
| **Built-up** (MVP) | Line-of-sight blocker, hard cover | Rectilinear block polygon in the built-up fill. Name labels are Section 7. | Block polygons plus major roads | Individual footprints only where the simulation separates them, otherwise block polygons. 2 px Chart Grey outlines. | Merge rule in E4: presentation follows the simulation. |
| **Hills and mountains** (MVP if the data has elevation) | Movement cost, line of sight, sometimes cover | Not drawn | Contours at 1.5 px | Contours at 1.5 px. Spot heights only as numerals. | **No triangle peak symbol** (S1). Contour spacing at least 12 px. Interval no finer than the data supports. |
| **Roads and bridges** (MVP if the simulation has road speed) | Movement speed, crossing | Not drawn (a road is not a fact at this scale unless it is part of an objective) | 2 px for minor, 3 px for primary | Same | Straight segments only. Tracks are drawn only if the simulation gives them a different movement cost. |
| **Port** (Vertical Slice) | Movement surface, possible objective | Objective ring only | Footprint outline | Quay and building footprints | See footprint table. |
| **Airfield** (placeholder, out of scope) | Open hardstand | Not drawn | Rectangle outline | Runway and apron rectangles | See footprint table. |

- *Test (density):* for the densest tactical frame the real data produces, measure stroke coverage in the worst window. Pass is at or under the ceiling, or an itemised list of dropped facts (which must be empty under rule 1 and 2 of the priority list).

**Principle E5: A plate must read on the densest terrain.** *Serves: Section 3 S2 (casing) and Section 4 (contrast budget).*
- The densest composite is not terrain alone. It stacks every layer Section 2's layer order puts under a mark:
  - **C-T (tactical):** built-up footprints at the 0.04 fill cap, 2 px Chart Grey outlines at the closest legal spacing (4 px gap), the territory tint of the faction in question at the Section 4 alpha (10%, starting value), the contact vignette at 14%, and the warm-neutral tactical ground.
  - **C-N (national):** a Faction B territory 45-degree hatch (2 px stroke, 8 px spacing, faction-hue line at 20% alpha) over the built-up block fill and its 10% tint, with the coast stroke and graticule crossing it.
- **Territory tint (resolved 2026-11-07: two ceilings, tint alpha 10%).** Section 4 caps terrain fills alone at about 0.04 luminance and fill plus territory tint at about 0.065. The tint sits above terrain and below marks and lifts the background. By a gamma-space blend (hand-calculated, tool-verify; a linear blend reads higher, Amber about 0.096) a 10% Amber tint over a 0.04 fill gives about 0.063 and Azure about 0.052. Over open ground (0.027) Amber gives about 0.046 and Azure about 0.037. The check uses the 10% starting value. See Section 6 Provisional 7.
- **X1 (testable criterion):** the check passes only if every item holds on screenshots of C-T and C-N. Each is sampled from rendered pixels, not hex values, at 1x and high-DPI.
  1. **Plate-to-casing:** at least 3:1 for every plate fill. Calculated from hex: Azure 5.9, Amber 11.4, Azure Standing 4.2, Amber Standing 7.6. Tool-recompute from pixels.
  2. **Glyph-to-plate:** at least 3:1 for the Sea Night glyph on each fill (the same four values).
  3. **Casing continuity:** at every size (16, 24 and the tactical size) and all 8 headings, the casing ring has no gap, and its measured width is at least 1.5 px.
  4. **Casing is the darkest band:** along any line crossing a plate edge into terrain, the casing is the darkest region within 3 px. This matters most where a Chart Grey outline passes under a standing-order plate. Azure Standing (0.19) against Chart Grey (0.145) is only about 1.2:1 by calculation, so the casing is what separates them. The casing against Chart Grey is about 3.4:1.
  5. **Rotation sweep:** 8 headings x 3 sizes x both plates, over both composites, with a Chart Grey outline placed through the plate centre and another along its edge. A naive viewer sorts A from B with no errors, in colour, greyscale and the three colour-vision-deficiency simulations.
  6. **Overlap:** two opposing plates overlapped by half stay separable and sortable.
- A miss on any item fails the composite. The fix is lower terrain ink or a lower tint alpha, never a brighter or fatter mark.

**Principle E6: The world's story is state, not scenery.** *Serves: Pillar 1 and Section 1's rule.*
- Allowed storytelling is limited to facts about the state of the world:
  - Territory ownership: tint, border and objective ring (locked).
  - Captured-objective border change and its ring event (locked, Section 2 State 3).
  - Review of changes: Chart Mist 2 px outline on changed borders (locked, Section 2 State 5).
  - **Persistent war damage: PROVISIONAL** on the simulation recording destruction. This is not an MVP feature.
- **Damage marks, if they exist:**
  - Destroyed bridge: the rectangle with the centre span removed and two abutment stubs left, with the river edge unbroken.
  - Destroyed building: the footprint drawn as outline only (no fill), with its line-of-sight and cover class following the simulation (rubble may still be cover).
  - A wreck exists only if the simulation keeps wrecks as cover. If so, it is a small rectangle outline (structure family), never a plate.
  - Never drawn: craters, scorching, smoke, ash, weathering or any age-based change. A damage mark has no age.
- **Structures never take faction hue.** Ownership is shown only by the ring, tint and border (Section 4).
- **Visibility class of damage (decision D6, resolved 2026-11-07: line-of-sight gated).** A freshly destroyed bridge seen without line of sight can reveal when the enemy was active, which breaks Section 2 State 5 ("nothing may hint at an enemy's online or offline activity"). Options:
  - (a) **Line-of-sight gated:** damage appears when first seen, in its post-state. No "new" marker and no recency cue. **Recommended**, because the art default is no leak.
  - (b) Public for objective-linked structures only, line-of-sight gated for the rest.
  - (c) Fully public. Rejected: it reveals unseen enemy action.
  - Under (a), a viewer who last saw the site intact may later see it destroyed. How a remembered terrain state is shown versus its current state is the same problem as the stale-unit mark and is not solved here.
- Nothing in this section tells a cultural or political story. The fictional premise belongs to the narrative-director.
- *Test:* strip all text from a screenshot of a campaign mid-war. A viewer can name who holds each objective and what is no longer crossable or standing. No element tells a story that is not a world state.

### Provisional

1. **P2:** the terrain and cover source decides which elements exist. The rules hold under all three candidates (E1).
2. The vegetation class split (light versus dense) depends on the P2 classes.
3. Persistent war damage depends on the simulation recording destruction. Its persistence also depends on A7 (campaign end or reset).
4. The damage visibility class (D6).
5. Shallow-water band: depends on landing or naval movement (A6). Port and airfield footprints depend on naval and air scope (post-MVP).
6. Roads as structure family: Section 3 S1 amended 2026-11-07 (resolved).
7. Territory tint alpha: 10% starting value, composite ceiling about 0.065 (Section 4, decided 2026-11-07). Hatch line alpha (20% proposed) is a P3 check.
8. Seamless zoom versus separate views (P3). It changes band thresholds, not the grammar.
9. Contour precision and interval depend on the elevation data resolution.
10. All density and spacing numbers are starting values to verify in P3.

### Risks

- Under OSM-derived data, real military bases, ports, airfields and place names will appear in the fictional war. This is a cultural-sensitivity and legal-review handoff (D5), not an art default.
- A fill step of about 1.1:1 may not be visible on cheap monitors. Outline shape carries type, and the risk is that the map reads as one grey field with lines.
- Vegetation edges at 2 px in Chart Grey may crowd the tactical view in dense jungle, because the ink ceiling and the "never drop a blocker" rule can collide.
- Lines have no antialiasing feather in 4.7 (`breaking-changes.md` L31, `modules/rendering.md` L11), so thin structure outlines and diagonal edges may stair-step. How fill edges behave is **NOT SOURCEABLE**. Test at 1x and high-DPI in P3.
- Hand-calculated blends and luminance values may differ from tool output. Recompute before locking.
- A built-up block polygon at national zoom is not a fact the viewer can use unless names are readable. Labels belong to Section 7.
- Merging footprints into blocks can look like a real change in line of sight when the simulation geometry changes. Keep E1's merge rule strict.

## 7. UI/HUD Visual Direction

This game has no in-fiction screen, no bezel and no skeuomorphic chrome. The map is the instrument, and the interface is the part of the display that is not a place on the map. This section decides what goes on the map and what goes on screen. It also covers type, controls, icons, UI motion, and the items Sections 3 to 6 handed here.

**Assumptions stated once.**
- Pixel values are logical pixels at a 1920 x 1080 reference viewport and 100% UI scale.
- `project.godot` sets no stretch values. Godot 4.7 defaults new projects to `canvas_items` with `expand`, but existing projects keep their own settings (`modules/ui.md` L14). Which applies here is NOT DETERMINED. Re-verify every pixel value against the real stretch mode in prototype P3.
- All sizes, ratios and counts are starting values to verify in P3.

### Governing rules

**Principle U1: A fact with a place goes on the map. A fact about a set, about time, or about your session goes on screen.** *Serves: The Country Is the Battlefield (Pillar 1) through Section 1 Principle 1.*
- *Test (pan test):* pan the map until the thing is off screen. If the information should still be visible, it is screen-space. If it only makes sense at a location, it is map-anchored.
- Map-anchored (moves with the map, or is anchored to a mark):
  - callsign tag and stub
  - accent brackets
  - status strip
  - firing wedge
  - range ring
  - frontage preview
  - objective names and region names
  - active-front border
  - graticule
  - loss mark
- Screen-space (docked, rectilinear panels):
  - force list and jump control
  - selection and order panel
  - order-queue list
  - event feed
  - scale and readout cluster
  - state bar
  - review scrub bar
  - menus and briefing
- *Alternatives considered:*
  - (a) Map-only, with everything anchored to the map. Rejected. Set facts and time facts have no place, an off-screen force cannot be found, and the feed would need invented anchors.
  - (b) A conventional RTS bottom panel plus a minimap. Rejected for the MVP. A minimap is a second map and competes with "one live map" (Pillar 1). The MVP already has a separate national view. If one is added later it must use the same plate grammar at the national band and must not add cues.
  - (c) **Chosen:** the hybrid above.
- **Occupancy budget (starting values):** docked chrome covers at most 20% of the viewport at tactical and at most 12% at national and regional. The central 60% x 60% of the viewport is never covered by docked chrome. Public marks are facts the viewer is owed, so chrome must not routinely hide them. The ux-designer owns arrangement and this section owns chrome.

**Principle U2: The UI is subject to the same leak test as the map.** *Serves: Section 1's rule and Section 2 M2.*
- *Test (UI leak test, extends M2):* render the UI for one player in the four M2 conditions (enemy online, enemy offline, unseen enemy force added, that force removed). The UI pixels are identical in all four. The only allowed differences are feedback on the player's own units and facts in the player's line of sight.
- No UI element may carry enemy online state, enemy activity timing, enemy intent, or enemy counts the viewer has not observed. This covers lists, feeds, scoreboards, chat and tooltips.

**Principle U3: Chrome reads as structure and carries no fact of its own.** *Serves: Section 3 S4.*
- Restated test: with the map hidden, nothing in the UI reads as a unit, an objective or a faction.
- Consequences used throughout:
  - No plate silhouettes, no category glyph knockouts and no circles in chrome.
  - No forward points in chrome.
  - Faction hue appears in chrome only as one 3 px rule (see 7.8) and nowhere else.

**Principle U4: UI motion is instant.** Specified in the UI motion section below.

### Typography

**Personality: instrument-panel neutral.** The type is plain, squared and unadorned. It reads like a chart legend, not a poster. The faction war supplies the emotion, and the type stays quiet (the Section 1 and Section 2 MDA ranking puts Sensation lowest).

**One family, two weights.**
- Alternatives considered:
  - (a) Monospace throughout. Fits the radar idiom and gives tabular numerals for free, but it is wide, and callsign tags would collide far more often at the 8 px cap floor.
  - (b) Condensed grotesque. Narrow, so tags fit, but legibility drops at small sizes.
  - (c) Humanist sans. Warm, but it is less instrument-like, and warmth is already carried by Warm Paper.
  - (d) **Chosen:** a neutral grotesque with tabular lining figures, at two weights.

**Selection criteria for the typeface (the user chooses the font):**
- Sans serif with open apertures and a large x-height.
- Squared curves are preferred, to echo the rectilinear chrome.
- Tabular lining figures.
- Distinct 0 / O (slashed or dotted zero preferred) and distinct 1 / l / I.
- Latin Extended coverage including n-tilde, because real Philippine place names such as Las Pinas use it.
- A licence that allows embedding and redistribution.
- Candidate names to evaluate, **unverified for licence, hinting behaviour and coverage:** IBM Plex Sans, Inter, B612, Barlow. Font licences and rendering behaviour are NOT SOURCEABLE from `docs/engine-reference/godot/`.

**Weights.** Regular and Bold only. Text under 13 px em is Bold only, so stems stay at least about 1.5 px. Regular is allowed only at 14 px em and above.

**Banned:**
- Italics. A slant reads as a forward lean, against S1's spirit, and it is less legible at small sizes.
- Faction-hue text.
- All-caps body text.
- Outline or shadow effects used as decoration.

**Size hierarchy.** Tokens are defined by cap height, because the font is not chosen. Em size is derived: for a font with a cap-height ratio of about 0.72, 8 px cap is about 11 px em.

| Token | Use | Cap height | Weight | Colour on Panel Ink |
|---|---|---|---|---|
| TXT-D | Menu and briefing title | 22 px | Bold | Warm Paper |
| TXT-H | Panel titles, briefing section heads | 13 px | Bold | Warm Paper |
| TXT-B | Briefing and settings body, region names at national | 10 px | Regular if em is 14 px or more, else Bold | Warm Paper |
| TXT-L | Feed rows, list rows, button labels, tooltips, panel headers (uppercase) | 9 px | Bold | Warm Paper primary, Chart Mist secondary |
| TXT-M | Mark text: callsign tags, place labels, strip numerals, graticule edge labels, scale numerals | 8 px | Bold | Warm Paper (own-force data), Chart Mist (place and scale text) |

**Minimum readable size (hard floor): 8 px cap height at 100% UI scale.** No information-bearing text is ever smaller, at any zoom band. Text at 9 px cap or below still meets the full 4.5:1 target.

**Contrast (calculated):**

| Text on ground | Ratio |
|---|---|
| Warm Paper on Panel Ink | 12.5:1 |
| Chart Mist on Panel Ink | 7.2:1 |
| Command White on Panel Ink | about 16:1 |
| Chart Mist on Land Slate | about 5.6:1 |
| Chart Mist on a tinted composite background (about 0.063 luminance for Amber, ceiling 0.065, hand-blended; see Section 6 E5) | about 3.7 to 3.8:1 (fails 4.5) |

The last row is why map text always sits on a Panel Ink plate (7.10).

**Text size and scale.**
- A text-size setting of 100, 125, 150 and 200% scales all tokens together, including tags. Plate sizes follow the Section 5 band table and do not scale with it.
- Whether to add a separate mark-scale setting is handed to the ux-designer and `design/accessibility-requirements.md`.
- Raising text size increases tag collisions. The Section 5 hide order applies.

**Rendering notes.**
- Godot 4.7 changed the `ResourceImporterDynamicFont.hinting` default to 3 (was 1) (`breaking-changes.md` L40). What the values mean and how they affect 8 px cap text is NOT SOURCEABLE from the engine reference.
- Record the hinting value used per font. Check every token at 100, 125 and 150% and at high-DPI in P3. If TXT-M fails at 8 px cap, the fix is a different font or weight, never a smaller size.
- Text uses `tr()` keys throughout (`modules/ui.md` L81). Allow 40% extra width for translation in every fixed cell.

**Callsign tag (settles the Section 5 placeholder).**
- Typeface: the UI family at Bold. Size: TXT-M, **cap height at least 8 px at every band that shows text (regional and tactical)**. This raises the 7 px placeholder to 8 px. See the conflicts table at the end of Section 7, row 2.
- Display transform: uppercase. Stored strings are untouched. Uppercase removes the I / l ambiguity. Zero versus O relies on the font's slashed or dotted zero.
- Backing: Panel Ink, 3 px horizontal padding and 2 px vertical padding, square corners, no frame (the lack of a frame separates it from place labels).
- Width limit: 96 px, truncated with an ellipsis. Callsign length limits and moderation are not art decisions.
- At rest the tag shows the first 4 characters at regional and the full callsign at tactical (locked).
- On hover of the unit, or of its force-list row, the tag expands to the full callsign at any band. This adds no new mark.

### Chrome and controls

**Panel specification.**
- Fill: Panel Ink, opaque.
  - A translucent panel would let terrain and territory tint vary the text contrast, and it would blur the line between map and chrome.
- Frame: 1 px Chart Mist, pixel-aligned.
  - Panel Ink against Land Slate is only about 1.3:1 and against Sea Night about 1.04:1 (calculated), so the frame carries the panel edge.
  - Chart Mist on Panel Ink is 7.2:1.
- Corner ticks (S4): crop-mark stubs. Each frame edge extends 4 px past the corner as a 1 px Chart Mist line, so the two lines cross at the corner.
  - Crop marks are used instead of L-shapes so chrome corners can never be confused with the L-shaped selection brackets.
- Corner radius: 0.
- Dividers: 1 px Chart Grey (about 3.3:1 on Panel Ink, which meets the 3:1 non-text target).
- 1 px chrome lines carry no fact, so Section 3's 2 px minimum for information-bearing marks does not apply to them. Marks drawn over the map keep 2 px.
- Spacing scale: 4, 8, 12, 16, 24. Panel padding 8. List row height 24. Button height 32 primary and 24 secondary.
- Minimum hit target for any clickable element: 24 px high.
- Pixel-alignment method (integer rects versus theme styleboxes) goes to the technical-artist. Godot 4.7 draws CanvasItem lines without the antialiasing feather (`breaking-changes.md` L31). Whether 1 px frames stay crisp at fractional scale is NOT SOURCEABLE. Test in P3.

**Modals.** In-game modals are opaque Panel Ink panels over a map that stays at full brightness. There is no dimming scrim, because a dimmed map implies the world paused and it does not (Section 2 M1 and Section 5 C3 bound the map layer).

**Button states.** Godot 4.6 separated mouse hover from keyboard and gamepad focus (`modules/ui.md` L19, `modules/input.md` L16). Both can show on one control at once. Gamepad support is Partial, so each state must have its own visual.

| State | Visual |
|---|---|
| Rest | Panel Ink fill, 1 px Chart Mist frame with crop marks, Warm Paper Bold label |
| Mouse hover | Label becomes Command White (text emphasis only), crop marks extend from 4 px to 8 px |
| Keyboard or gamepad focus | Second 2 px Chart Mist frame outside the first, 3 px gap |
| Hover and focus together | Both cues, with no conflict |
| Pressed (held, instant) | Frame becomes 2 px, label Command White |
| Disabled | Frame and label Chart Grey, no crop marks, and a one-line reason in Chart Mist where there is space |

Disabled text in Chart Grey is a stated exemption. Section 4 says secondary text is never Chart Grey. A disabled control is not secondary text and is not operable. The clarification is recorded in Section 4 (UI palette) and in the Section 7 conflicts table, row 5.

**Control vocabulary (rectilinear, no forward points, no circles).**

| Need | Control |
|---|---|
| Toggle | 16 px square frame. On state is an 8 px Warm Paper inner square (no tick, no circle). |
| Choose one of N (replaces radio and dropdown) | Segmented selector: adjacent rectangles, the chosen one Warm Paper text with a 2 px underline rule |
| Number setting | Stepper: "-" button, numeral, "+" button |
| Slider | 2 px Chart Grey track, 2 px Chart Mist elapsed portion, 8 x 16 px Warm Paper rectangular handle |
| Text field | 1 px frame, 2 px vertical caret bar |
| Scrollbar | 4 px rectangle, no arrows |
| Tooltip | Panel Ink plate, 1 px Chart Mist frame, TXT-L |

- No dropdown carets, no radio circles, no sort arrows, no back arrows.
- A back control is a text button. A sort control is a text header with "ASC" or "DESC" text.
- Dropdowns are replaced by segmented selectors or a list panel.
- **Pointer cursor.** Use the OS default cursor for the MVP and treat it as an input device, not a mark (exempt from S1). A custom map cursor is deferred. Whether Godot supports custom cursors as needed is NOT SOURCEABLE from the engine reference.

### Iconography

**Text first.** Every control carries a text label. Icons are only allowed where the symbol is a rectilinear convention.

**Permitted glyphs (complete MVP set):**
- pause (two bars)
- plus and minus (two bars)
- close (a cross, only inside a framed 24 px cell, never on the map)
- the toggle square

**Style:**
- 16 px grid, 2 px strokes, square ends, one colour (Warm Paper or Chart Mist).
- No circles, no forward points, no plate silhouettes, no category glyph knockouts.

**Unit category in the UI is a three-letter text code** from the game glossary (for example INF, ARM). It is not an icon.
- Alternative: reuse the category glyphs without the plate. Rejected. The glyphs are defined by a forward feature (nub, barrel), so they break S1 and U3 and would read as units in chrome.

**Gamepad button prompts** are handed to the ux-designer. Many standard prompt shapes are circles and triangles and need their own rule.

### UI motion

**Principle U4: UI motion is instant unless a simulation fact or the viewer's own input drives it.** *Serves: Section 2 M2 and Section 5 C3.*
- All state changes are instant: panel open and close, hover, focus, press, screen changes and the feed insert.
- Allowed continuous motion:
  - the scrub playhead following the viewer's drag or playback
  - the camera pan and zoom (a P3 decision, not UI)
- Banned:
  - fades, slides, eases, overshoot and bounce
  - typewriter text reveal
  - pulsing or blinking UI elements. The only pulse in the product is the locked alert-tick pulse.
- Menu to briefing to map is a cut. This matches State 6 (energy 1 of 5, no motion).
- *Alternatives considered:*
  - 120-180 ms eased slides (modern HUD feel). Rejected. They add liveliness with no fact behind it and slow a repeated action.
  - A cross-fade between screens. Rejected as an unneeded opacity change.
- Reduced-motion setting: nothing further to remove. UI is already instant, which is also the safest default.
- *Test:* record a 60 s session with reduced-motion on. The only moving elements are unit marks, the camera and the viewer's own drags.

### 7.1 Active-front overlay at national zoom (settles Section 5 Provisional 12)

**Definition (public facts only).** A border segment is an **active front** while two opposing public force markers are within distance D of each other across that border.
- D is a starting value. It should be tied to a simulation constant such as engagement range, chosen by the game-designer. **PROVISIONAL.**
- Use hysteresis: on at D, off at 1.25 D. This stops flicker and is not an animation.
- The rule depends on positions only. It never depends on under-command state, standing-order state, online state or movement. Positions are public (Pillar 1), so an offline enemy force near a border triggers the same front as an online one.
- Contested objectives already show both patterns (Section 4). That is a separate cue and always stays.

**Alternatives considered:**
- (a) A front from public combat events ("a fight is happening"). Rejected for now. It could reveal when an unseen enemy acted, which fails Section 2 State 5 and U2. It would be admissible only if the game-designer rules that combat events are public.
- (b) Player-drawn front lines. Rejected. That is intent.
- (c) Chevron or zipper marks. Rejected by S1 (forward points).
- (d) Perpendicular ticks in Command White. Rejected. They spend the accent, and Command White ticks are the alert cue.
- (e) A dashed front line. Rejected. Dashes are held for the standing-order cue.
- (f) A pulsing front. Rejected by M2 and C3.
- (g) **Chosen: split border.**

**Visual (split border):**
- Where two opposing regions share an edge, each side's 3 px territory border (national) widens to 4 px while the front is active, in that side's own faction hue, drawn on its own side of the shared edge. The result is an 8 px two-tone band.
- It is static. It appears and disappears in one frame.
- The cue is spatial (each hue stays on its own side), plus luminance (Azure and Amber differ by about 1.9:1), plus the doubled width. It does not rely on hue alone.
- No red, no accent, no dash, no hatch, no opacity change, no label.
- *Test:* a new viewer names each region's owner and the active fronts within 5 seconds with no legend (Section 1 Principle 1). Run in greyscale and in the three colour-vision-deficiency simulations (Section 4 method).
- Hero ranking is unchanged. A front is secondary (territory border family), and the 16 px plates stay the loudest layer.
- The MVP has one small region. The front rule applies at regional zoom there and at national zoom later. Without a shared border between opposing regions, contested objectives carry the cue alone.
- Visibility class: public.

### 7.2 Firing wedge, weapon arc and range overlays (separate overlay, per Section 3)

**Firing wedge.** It is the unit's own agent-family overlay: anchored to the plate centre and rotating with the unit's facing.
- Shape: an outline-only circular sector (two straight radial edges and a range arc). The wide end is the arc at range, so it never reads as an arrowhead.
- It does not break S1 because it is the unit's own overlay and has no forward point away from the unit. This interpretation is recorded in Section 3 S1 (clarified 2026-11-07).
- Stroke: 2 px in the owner's faction hue, with the 1.5 px Sea Night casing, no dashes, no fill.
  - Fill is rejected. A translucent fill dims marks under it (breaks M1) and shifts terrain contrast.
  - Hatch is rejected (Faction B territory pattern).
  - Dashes are rejected (standing-order cue).
  - Command White is rejected (accent).
  - Opacity changes are rejected (C3).
- Density rule: full sector for 1 to 2 selected units, or for a hovered unit. For 3 or more selected units, draw only the range arc plus 6 px edge ticks perpendicular to the arc. This avoids a stack of overlapping sectors.
- It is drawn at tactical zoom only, for selected or hovered own units.
- Visibility class: owner-only. Enemy wedges are never drawn by art default, because an enemy's range and arc are a stat. Whether the viewer may see them is a game-design decision.
- Wedge angle and range come from the simulation (combat tuning values are blocked by the re-test in `REPORT.md`). The art draws whatever the simulation says and invents nothing.

**Range overlays.**
- Places family: a circle centred on an own unit's plate.
- Stroke: 2 px in the owner's faction hue with casing, solid, shown only on selection or hover.
- A numeral label (range in the simulation's display unit) sits on a Panel Ink plate at 12 o'clock in TXT-M Chart Mist.
- Capture and objective radii are not decided here. They belong to the locked objective ring grammar.
- Risk: three circles now exist on the map (objective rings, the loss mark, and range rings). They are separated by size, attachment (centred on a plate versus on a place), life (held, 1.5 s, or while selected) and the numeral label. Playtest for confusion.

### 7.3 Callsign tag typeface and size
See the Typography section above (TXT-M, Bold, 8 px cap minimum, uppercase, 96 px width limit, expand on hover).

### 7.4 Owner-only status strip (strength and ammunition, no red and no green)
- Layer 7, tactical band only, own units only, and only for plates 28 px or longer.
- Placement: screen-aligned, centred above the rotated-extent bound plus the bracket envelope (lower edge of the strip at the bracket-box half-side plus 5.5 px, so it clears the top bracket arms and alert ticks at every heading), so it never shares space with the tag below. Starting values, verify in P3.
- Construction: two rows, each 4 px high.
  - Row 1 is strength. Row 2 is ammunition.
  - Each row is segmented into at most 8 rectangular cells, each 3 px wide with a 1 px gap. Width is the greater of plate length and 31 px.
  - A filled cell is Warm Paper. An empty cell is a 1 px Chart Grey outline on a Panel Ink backing (fill versus outline is the shape cue).
  - If the simulation value is continuous, quantise to 8 cells for the strip and show exact numerals in the selection panel and on hover.
- Low threshold: a static 1 px Chart Mist tick across the row at the simulation's low-ammo or low-strength threshold. The threshold value comes from the combat GDD (NOT DECIDED). There is no pulse, no flash and no colour change.
- Numerals: on hover or solo selection, the exact value ("18") appears at the right end of the row in TXT-M Warm Paper on a Panel Ink backing.
- Empty state: all cells empty plus the numeral "0" shown regardless of hover.
- **Hold-fire state (prototype H key):** an own-only held-state label. A Panel Ink cell with Chart Mist Bold text (the glossary abbreviation, for example HF) sits at the left end of the strip. It is static and reuses no reserved cue (not brackets, ticks, dashes, hatch or intensity). The abbreviation must be a `tr()` key and the game-designer owns the term. Locale width is a risk.
- Alternatives rejected:
  - Red-to-green fill. Excluded by Section 4.
  - A continuous gradient bar. It breaks the flat fill rule (E3).
  - Pulsing at low ammo. The pulse is reserved for alert ticks.
  - A circular gauge. Circles are places.
- Visibility class: owner-only. Enemy strength inside line of sight is a game-design decision (Section 5 Provisional 11). The art default is not shown.
- Warm Paper is used as a strip fill here, which extends its semantic row (recorded in the Section 4 semantic colour table, extended 2026-11-07).

### 7.5 Event feed, after-action summary, and review scrub bar

**Event feed (screen-space, docked, provisional position bottom-right).**
- Panel 360 px wide, at most 6 rows of 24 px, newest at the bottom.
- A new row enters in one frame and the rows above shift up in the same frame. Rows never fade. The oldest row drops off when a seventh arrives. A longer log opens in an expandable panel. Persistent age cues are given by the timestamp, not by fading.
- Row layout:
  - a 16 px category cell
  - a timestamp in TXT-L Chart Mist with tabular figures
  - one line of TXT-L Warm Paper text, truncated with an ellipsis
- Category cell: a square with a Bold letter from the glossary (for example L for loss, O for objective, C for contact, A for ammunition).
  - **Filled Warm Paper cell with a Panel Ink letter** means an event that happened to your own force.
  - **Framed cell (1 px Chart Mist) with a Warm Paper letter** means a public or line-of-sight world event.
  - Loss and capture are therefore told apart by the cell shape and the letter, never by colour.
  - No ring or plate glyphs are used, which keeps U3.
- Rows allowed (each is a fact the viewer is entitled to):
  - own unit lost
  - objective captured or lost (public)
  - own unit under fire (first hit of an episode)
  - hostile sighted (line of sight)
  - hostile unit destroyed (only if seen)
  - own ammunition low (at the simulation threshold)
- Every row type uses one style regardless of who caused the event.
- Never shown:
  - any enemy online, offline, join or leave message
  - movement of unseen forces
  - intent
  - counts of unseen losses
  - any "enemy active" indicator
- Clicking a row jumps the camera to the event location only if the viewer is entitled to that location. The location of an unseen shooter is never given.
- Timestamps use the simulation clock or wall clock. **PROVISIONAL on A3.**
- Assistive technology: AccessKit screen-reader support exists from 4.5 (`modules/ui.md` L29), and `Control.accessibility_live` is typed `AccessibilityServer.AccessibilityLiveMode` in 4.7 (`modules/ui.md` L12). How a feed should announce rows is NOT SOURCEABLE. Hand it to the ux-designer and technical-artist.
- Sound for events is the audio-director's decision.

**After-action summary (States 4 and 5).**
- A single docked Panel Ink panel with a TXT-H title ("After-action"), and a TXT-L subtitle that names the state in plain text ("Engagement lost, fall-back" or "While you were away").
- Rows:
  - units intact (numerals "N of M")
  - units lost, with a list of own losses (callsign and time)
  - ammunition remaining (an 8-cell bar with numerals)
  - objectives changed (public, as text)
  - hostile units observed destroyed ("N, observed only")
- No kill ratio. A ratio built from observed events is misleading. Whether to show one is a game-design decision.
- No red and no green. Counts are numerals and fills are segmented bars.
- Nothing in the panel may derive from unseen enemy activity or enemy online time. There is no "enemy was active for N hours" readout (Section 2 State 5).

**Review scrub bar (State 5).**
- Docked at the bottom, full width, on the warm-neutral review chrome (#171A1A) with a 1 px Chart Mist frame. The locked 3 px Warm Paper screen frame stays.
- A text plate "REVIEW - NOT LIVE" (TXT-L Warm Paper) at top centre is the redundant cue for cheap monitors.
- Track: 8 px tall. The elapsed part is filled Chart Grey. The rest is empty.
- Event ticks: 2 x 8 px Chart Mist vertical bars.
  - There is one tick style only.
  - A tick exists only for events the viewer is entitled to see.
  - No tick density, heat map or count is drawn. Events that share a pixel merge into one tick.
- Playhead: a 2 px full-height Warm Paper bar with an 8 x 12 px rectangular cap. No triangle.
- Timestamps: TXT-M numerals at both ends and at the playhead.
- Transport controls are text buttons (Section 7 conflicts table, row 1): "PLAY", "PAUSE", "PREV EVENT", "NEXT EVENT", and speed buttons "1X", "4X", "16X". No chevrons or triangles.
- Replayed marks are not live. They use the same plate grammar, and the review frame and label are the only differences.

### 7.6 Scale bar, graticule and contour interval readout
- **Scale cluster:** one docked Panel Ink panel, provisionally bottom-left, holding the scale bar, the contour readout and the zoom-band name. An optional cursor-coordinate readout is a ux-designer decision.
- **Scale bar:** a 2 px Chart Mist horizontal bar with 8 px end ticks and a 4 px middle tick. Numerals in TXT-M Chart Mist above the ticks. Length snaps to a 1, 2, 5 sequence of round values and stays between 80 and 160 px. Units are metric.
- **Graticule:**
  - Drawn at national and regional zoom, not at tactical zoom.
  - 2 px Chart Grey solid lines on the ground, below terrain features and marks. Chart Grey on Sea Night is 3.4:1 and on Land Slate 2.5:1, so it is deliberately quiet.
  - Spacing is at least 200 px on screen. The interval snaps to round degree values.
  - Reason for the spacing: a 200 x 200 px window then holds at most one line per direction, about 2% stroke coverage. This uses half of Section 6 E4's 4% national ceiling. Re-measure with the real coast in P3.
  - Fallback if coast and graticule collide: ticks and labels only at the viewport edge, with no lines.
  - Labels sit at the viewport edge where each line meets it, on small Panel Ink plates, TXT-M Chart Mist. This keeps text off the map layer.
  - The coordinate system and projection are NOT DECIDED (P3).
- **Contour readout:** text "Contour interval 20 m" (value from the data) in TXT-L Chart Mist in the cluster. It is shown only when contours are drawn (regional and tactical, per Section 6). At national it is hidden and its slot stays reserved, so the cluster does not reflow. The interval is a fact and never finer than the data supports.

### 7.7 Selection box, frontage preview and order-queue indicators

**Selection box (left drag).**
- A plain 2 px Chart Mist rectangle outline with a 1.5 px Sea Night casing.
- No fill. A translucent fill would dim marks and break M1. No dashes. No corner ticks, which could be confused with the selection brackets. No Command White, which is reserved.
- On release, the selected own units get the Command White selection brackets in one frame (an event of 0 s). Section 7 reads **brackets as "selected"** (recorded in Section 4, Accent separation).
- On hover over any own unit, no new mark appears. The tag expands and the strip numerals show (see 7.3 and 7.4).

**Frontage-line preview (right drag, the protected prototype pattern).**
- The right-drag line is kept exactly as prototyped. Only the preview art is specified here.
- Line: 2 px Chart Mist with 1.5 px casing, from the drag start to the cursor.
  - Chart Mist is chosen because tracers use the shooter's faction hue (Section 5). A hue line would be confusable with a tracer in a fight.
- Slot markers: one 6 x 6 px Chart Mist square with casing at each slot position, equally spaced along the line, one per selected unit or squad. This shows how many slots exist, which is a fact from the simulation.
- Facing side: 8 px perpendicular stub ticks (2 px) at each slot on the facing side only. The result reads as a comb on one side of the line.
  - No arrowhead (S1). Diagonal ticks are not used (alert cue).
  - Which side faces is whatever the prototype and simulation rule defines. The rule is not stated in `REPORT.md`, so this section does not choose it.
- Readout: a Panel Ink plate at the cursor end, TXT-M Chart Mist, showing frontage length and slot count ("5 of 6" when a slot cannot be placed). An unplaceable slot is omitted rather than drawn hollow. Hollow is a stale-mark candidate.
- No ghost plates. A ghost needs reduced opacity (C3) or a hollow plate (stale candidate).
- The preview disappears in one frame on release. The real units then move, which is the simulation's own motion.
- Visibility class: owner-only and transient.

**Order queue.**
- Screen-space list (unconditional if order queuing exists): inside the selection panel, a numbered owner-only list, one row per order (number, order type and target as text) in TXT-L.
- **Own-only intent lines exist (decided 2026-11-07).** On-map queue marks show for selected units only:
  - a solid 2 px Chart Mist polyline with 1.5 px casing, with 16 px Panel Ink numbered squares (Bold numerals) at each waypoint
  - no dashes (dashes are reserved for the standing-order second cue, and Section 3 requires intent lines to be distinct from it), no arrowheads (S1), no circles (places)
  - owner-only: never drawn on enemy marks and never in any view the enemy receives (extend the Section 5 C3 leak test to them)
  - visually distinct from the 2 px faction-hue cased tracers (Chart Mist versus faction hue, plus the numeral squares)
  - the frontage preview collapses into these lines on release, and a command is acknowledged on the issuing player's screen on the same frame it is issued (showing your own order is a fact, not extrapolation)
- Whether the queue persists after deselection is undecided.

### 7.8 Commander representation (answers Section 5 C1 item (c))
**Recommendation: no portrait and no avatar.**
- Nothing in the concept or simulation backs one, so it would invent a fact (Section 1's rule). Pillar 3 says the force carries the human.
- Identity in the UI is the player's callsign as text only. It is a TXT-H Warm Paper Bold line in the force panel header.
- A 3 px faction-hue rule under that header marks which faction you belong to. It is a line and not a fill, so Section 3 S4 holds. The faction name is text and is the colourblind backup. Faction names remain open.
- *Alternatives rejected:* a generated or stock portrait (an invented fact, and needs art for up to 50 players), a per-player emblem (Section 5 already rejected it), a rank badge (needs a rank system the concept does not define).
- Reconsider only if the design adds a commander progression or rank mechanic.

### 7.9 Find-my-force aids (complements to the tag stub test)
These do not count towards the Section 5 find-my-force test. That test judges the stub and tag alone.
- **Force list:** a docked panel with one 24 px row per own unit or force.
  - callsign (TXT-L Warm Paper Bold)
  - category code (text, Chart Mist)
  - strength and ammunition as numerals
  - an order status text ("CMD" or "STANDING"), which is an own-only text backup for the unchosen standing-order second cue
- **Locate cue:** hovering a row (or keyboard-focusing it) expands the unit's map tag to the full callsign inside a 2 px Chart Mist frame. If the unit is off screen, a Warm Paper edge tick appears: a 2 x 16 px bar on the viewport edge nearest the unit, with casing. There is no arrowhead. Only hovered or selected rows (at most 8) show edge ticks.
- **Jump-to-force:** a text button plus a hotkey that centres the camera on the selected row, or cycles forces. The order of cycling and the hotkey are the ux-designer's.
- Click selects the unit (brackets on the map). A double click or the jump control moves the camera.
- All of these are own-only. Allies in the list are **PROVISIONAL on A8**.

### 7.10 Name labels for regions and places
- **Ground:** every map label sits on a Panel Ink plate with a 1 px Chart Grey frame and Chart Mist text. A frame marks a map-anchored label and separates it from the unframed callsign tag. The plate is treated as map-anchored UI chrome. This gives 7.2:1 text contrast regardless of tint, where bare Chart Mist on the tinted composite is only about 3.7 to 3.8:1 (about 3.0:1 on a 20% hatch line pixel, hand-calculated).
- **Alternatives considered:**
  - (a) Chart Grey text on land. Fails 4.5:1.
  - (b) Warm Paper text. It would dilute the own-force tag and stub cue and the find-my-force test.
  - (c) Command White text. Reserved accent, and Section 4 warns against text near the accent on the map layer.
  - (d) Bare Chart Mist text on land. Needs Section 4's semantic table amended and still fails on tinted ground.
  - (e) **Chosen:** plate plus Chart Mist.
- **Sizes:** region names TXT-B (10 px cap, Bold). Objective and settlement names TXT-M (8 px cap, Bold).
- **Placement:**
  - Region names are centred on the region centroid.
  - Objective names sit 6 px to the right of the ring, with no leader line.
  - Labels never overlap a plate. On collision the label yields and hides.
- **Density:** at most 12 labels per 1920 x 1080 viewport at national and regional. Priority is regions, then objectives, then settlements. Labels are hidden at tactical except objective names.
- **Content rule:** names come from data and never vary with ownership, activity or faction.
- Real place names may bring sensitive or real military names from geodata. This is handed to D5 (cultural sensitivity and legal review).

### 7.11 Menus and briefing (State 6)
- **Ground:** the locked State 6 values (Sea #08101A, Land #2B2F2E). The static chart has no live marks and no accent geometry.
- **Menu layout:** a centred 480 px column on the static national chart.
  - Title in TXT-D Warm Paper Bold. Wordmark and logo are PROVISIONAL (the title is a working title).
  - At most 6 buttons of 32 px height.
  - The primary action is wider and uses a 2 px frame. It has no colour change.
- **Briefing layout:** the static map takes the left 62% and a panel stack takes the right 38%.
  - Map: objectives with their rings and the player's own force marks, drawn per the normal grammar and static.
  - Panels: TXT-H headings, TXT-B body at no more than 60 characters per line, an own-force table, and a "Begin" button at the bottom of the stack.
  - Briefing content follows the visibility classes. It shows objectives, own force and public information only. Whether it may show enemy composition is a game-design decision (Section 2 State 6). If it is allowed it must be labelled as intelligence in plain text.
- **Screens in the MVP:** main menu, load and save, settings, pause, briefing, after-action. Controls come from the vocabulary above. Settings use segmented selectors and steppers.
- **Navigation:** keyboard and gamepad focus uses the focus frame. Both input paths must be tested (`modules/ui.md` L90).

### Players, chat, scoreboards, presence
The MVP is single-player, so none exists yet. For later multiplayer, the rule handed to the ux-designer is below.
- Allowed:
  - own faction's roster
  - faction chat among faction-mates
  - public scoreboard facts such as territory held, if public
- Never shown to the opposing faction:
  - any presence, join, leave, typing or "last seen" state
  - a roster of the opposing faction with online state
  - chat or system messages that reveal enemy activity
- Own faction presence visible to faction-mates is **PROVISIONAL on A8 and A9**.
- A global chat, if one exists, carries no presence indicators.
- U2's UI leak test is the check.

### Art direction versus readability: conflicts and how they were decided

| # | Conflict | Decision | Status |
|---|---|---|---|
| 1 | S1 bans forward points in chrome, but triangles are the fastest-read play and transport symbols | Text-labelled transport buttons, "pause" as two bars, OS pointer exempt | Art rule applied. Readability (instant recognition of play and step) acknowledged as legitimate. **Decided 2026-11-07 by the user: text-first, no triangles anywhere in chrome** |
| 2 | 8 px cap floor versus crowded tags at tactical | Floor kept. Tags yield by the Section 5 hide order, never shrink | Decided |
| 3 | Map labels need contrast, but terrain and marks must stay louder (Principle 1) | Low-contrast Panel Ink plates (1.3:1 against land) with Chart Mist text | Decided |
| 4 | Opaque panels cover public marks, but the map is the interface | Occupancy budget and clear centre region | Decided. Arrangement is the ux-designer's |
| 5 | Disabled-state legibility versus the "never Chart Grey for text" rule | Chart Grey allowed for disabled controls only, with a reason line | Clarification listed |
| 6 | Polished UI motion versus "no ambient motion" | Instant by default | Decided |
| 7 | Persistent feed versus clutter | Fixed 6 rows, no fade, expandable log | Decided |
| 8 | Uppercase callsigns versus recognising names | Uppercase display, stored string unchanged | Decided. Revisit if playtests find names hard to match |

### Stroke and size rows to add to Section 3's table (additions, not changes)

| Element | National | Regional | Tactical |
|---|---|---|---|
| Active-front border (per side) | 4 px | 3.5 px | 3 px |
| Graticule | 2 px | 2 px | not drawn |
| Selection box | not applicable | not applicable | 2 px plus 1.5 px casing |
| Firing wedge and range ring | not applicable | not applicable | 2 px plus 1.5 px casing |
| Frontage preview line | not applicable | not applicable | 2 px plus 1.5 px casing |
| Panel frame and chrome dividers (no fact) | 1 px | 1 px | 1 px |

Regional and tactical front widths are proposals to verify in P3. The 3 px at regional is a guess and not derived.

### Provisional

1. **A9 and A8:** enemy presence, faction vision, ally rows in lists and the feed, and ally tags.
2. **A3:** event timestamps, scrub-bar time axis and all durations.
3. Intent lines: decided 2026-11-07 (own-only intent lines exist; on-map queue marks are specified in 7.7).
4. Distance D for the active front, and whether combat events are public.
5. Combat values (wedge angle, range, low thresholds, hold-fire term) are blocked on the Pillar 2 re-test and the combat GDD.
6. Whether the national marker is one unit or one force, which changes the force list rows.
7. Seamless zoom versus separate views (P3), which changes the front widths by band.
8. The typeface, the wordmark and the title.
9. Whether a minimap or custom cursor ever exists.
10. Veterancy ticks (B8): the strip and tag layout already reserves space on the tag backing.
11. Standing-order second cue: the "CMD" and "STANDING" text is the interim own-only backup.
12. Campaign-end screens (State 7): no look is defined.

### Risks
- The split-border front may be too heavy (8 px) next to 16 px plates at national zoom. Test with the Principle 1 5-second test.
- Many small Bold 8 px labels depend on hinting and font choice. Godot 4.7 changed the hinting default (`breaking-changes.md` L40) and the effect is NOT SOURCEABLE. Test at 100, 125 and 150%.
- Godot 4.7 draws lines without the antialiasing feather (`breaking-changes.md` L31). Thin frames, crop marks, 2 px wedges and the graticule may stair-step. NOT SOURCEABLE how fills behave.
- Panels and wedges stack casing on 2 px lines (about 5 px total), which may be heavy in a dense fight.
- Banning triangles may slow recognition of transport controls (conflict 1).
- Text-only controls cost localisation width (40% allowance).
- Warm Paper stays close to Amber in hue. The strip fill, tag and edge tick rely on the Panel Ink backing and rectangular shapes (Section 4 risk 5).
- The viewer may confuse range rings, loss circles and objective rings (7.2).
- A front rule based on proximity may feel "wrong" if positions are far apart but a battle happens. That depends on D and the combat-event decision.
- The graticule uses half of the national stroke ceiling, which may leave too little room for the coast in dense archipelago views.
- Uppercase callsigns remove case information that players may use to recognise names.
- No sound or non-visual backup exists for the feed. That is for the audio-director and the ux-designer.

## 8. Asset Standards

This game is flat 2D vector-style art (Section 6 E3), so there are no polygons, PBR textures, normal maps or material slots. Section 8 has two halves written by different specialists, then a reconciliation block that records where an art preference and a technical limit disagree and what was decided.

- **Part 1, art direction (8.A to 8.J).** Every item is a PREFERENCE (the ideal), with its cost stated.
- **Part 2, technical constraints (8.T0 to 8.T7).** Every line is tagged SOURCED (from `docs/engine-reference/godot/`), TARGET (a decision or calculation, not an engine fact) or NOT SOURCEABLE (the engine reference does not cover it, so nothing may be assumed until observed in prototype P3).
- **Part 3, reconciliation (8.R).** Decisions of 2026-11-07.

#### Part 1: Art direction (preferences)

### 8.A Scope and assumptions (art-direction half)

- This is a flat 2D vector-style game (Section 6 E3). There are no polygons, PBR textures, normal maps or material slots.
- The asset universe is small and enumerable:
  - **Baked unit frames.** Layers 1-4 (casing, plate, glyph, tactical detail), one frame per variant. These are the only high-count image assets.
  - **Unit overlays.** Accent brackets, alert ticks, tag stub, loss ring, veterancy ticks. Layers 5-7 and event marks.
  - **Territory hatch tile.** The only tiled pattern.
  - **UI icons.** PROVISIONAL on Section 7.
- Terrain has no image assets. It is hex fills plus luminance targets applied to polygons from the P2 data (Section 6 E3 table), plus runtime strokes.
- Every colour used in an asset must be one of the Section 4 values: the 7 primaries, the 2 UI-only values, or the 2 derived standing colours.

### 8.B File formats

**AP-1 (PREFERENCE, ideal): author in vector, one parametric master per unit category, and generate the variant matrix by script.**
- Source is layered vector (SVG as the interchange format) with named groups: `casing`, `plate`, `glyph`, `detail`.
- The master uses palette tokens, not literal hexes. An export script substitutes hexes per faction and state, then rasterises each (band x state) frame at exact target size.
- Why:
  1. The matrix is 36 frames at MVP (and 72 at 4 categories). Hand-drawing it invites drift between Azure and Amber frames. Drift is itself a visibility leak: if one faction's frame is a pixel larger, size becomes a cue.
  2. A palette or plate change (both are still provisional) then regenerates everything.
  3. Plate silhouettes (Shield versus Swallowtail) share a single geometry source per band.
- Authoring tool is not chosen here (user decision).
- Costs: a small export script is needed in `tools/asset-pipeline/` (technical-artist territory). Without a script, parametric authoring degrades to hand-editing.
- Alternatives:
  - (b) Hand-drawn raster per frame. Rejected: breaks the "one source" rule and cannot scale to 2x.
  - (c) Runtime vector drawing per unit (Section 5 option iii). The art-side objection is the feather risk plus unmeasured cost. It stays a technical-artist call.

**AP-2 (PREFERENCE, ideal): imported format is lossless 8-bit RGBA PNG, rasterised from the vector master by the export script, not an SVG that the engine rasterises.**
- Why: our rasteriser gives us control of edge coverage (fractional 1.5 px casing), and it gives 1x/2x parity from one source.
- NOT SOURCEABLE: Godot's SVG import behaviour (rasterisation scale, whether it can re-rasterise for high-DPI). Test importing the SVG directly in P3 as the alternative.
- Costs: the 1x and 2x rasters are two file sets to track.
- Strip or normalise embedded colour profiles to plain sRGB. NOT SOURCEABLE: how the importer treats ICC profiles.

**AP-3 (PREFERENCE): keep vector sources out of the engine's import tree if the engine allows, otherwise segregate in one folder.**
- `project.godot` sits at the repo root, so every file under the repo is potentially visible to the importer.
- Whether `.gdignore` is the right mechanism is NOT SOURCEABLE.
- Costs: if sources must live in-tree, the editor imports SVGs nobody uses.

### 8.C Naming convention direction

Pattern: `[class]_[name]_[variant...]_[size]` in snake_case, extension lowercase. This follows the role pattern and the project's snake_case files (`project.yaml` `naming.files`).

**AP-4 (PREFERENCE): tokens are keyed on faction slot, not hue and not faction name. All three are working titles.**

| Slot | Tokens |
|---|---|
| Class | `unit` (baked frames and unit overlays), `env` (any terrain/territory image), `ui` (chrome and icons), `vfx` (event marks) |
| Name | unit category: `infantry`, `armor`, `artillery`, `support`, `air`, `naval`; or overlay kind: `accent_bracket`, `accent_ticks`, `tag_stub`, `loss_ring`, `vet_ticks` |
| Faction | `fa` (Faction A, working Shield/Azure), `fb` (Faction B, working Swallowtail/Amber) |
| State | `full`, `standing`, `stale` |
| Size | `nat`, `reg`, `tac` for units; logical pixel number for UI (`24`) |
| Scale suffix | `_2x` appended last. `@2x` is avoided: NOT SOURCEABLE whether Godot treats `@` specially |

Concrete examples:
- `unit_infantry_fa_full_nat.png`
- `unit_armor_fb_standing_tac.png`
- `unit_armor_fb_stale_tac_2x.png`
- `unit_artillery_fa_full_tac.png` (the tactical size is implied by category)
- `unit_accent_bracket_armor_tac.png`
- `unit_accent_ticks_nat.png`
- `unit_tag_stub_nat.png`
- `vfx_loss_ring_reg.png`
- `env_hatch_territory_fb_tile.png`
- `ui_icon_zoom_in_default_24.png`
- Sources: `unit_armor_master.svg`.

Rules:
- No heading in any name. Rotation is by transform.
- No `_wip`, `_final`, `_new` in exported folders.
- Source masters take `_master`.

**AP-5 (PREFERENCE): reserved-token ban.** No name token (split on `_`) may be any of: `online`, `offline`, `ai`, `bot`, `human`, `afk`, `active`, `inactive`, `idle`, `awake`, `asleep`, `controller`, `player`, `enemy`, `ally`, `own`, `mine`.
- Match whole tokens only, because a substring match on `ai` would hit `air`.
- Why: asset names are the first place a leak can be introduced, and the ban is greppable.
- `standing` is allowed. It is the own-side state defined in Section 4. It is selected by "owned by viewer", never by faction alone (see 8.I).
- Costs: none.

### 8.D Sprite and frame size tiers

**AP-6 (PREFERENCE): define plate length as the OUTER length including the casing, in logical pixels.**
- Section 5 says "plate length along the facing axis, in screen pixels". That does not say whether the casing is inside or outside, or logical versus physical.
- Outer length makes the 16 px minimum measurable on a screenshot.
- Costs: if the casing is inside, the plate is about 3 px smaller and the 4 px notch (Section 3) shrinks. Decided in 8.R #1 (outer length including the casing).

**AP-7 (PREFERENCE): frame canvas size is `ceil(sqrt(L^2 + W^2)) + 4 px`, where W is the plate width, then rounded up to an even number.** The canvas is therefore square and the pivot is the exact centre.
- The 4 px is a 2 px safe margin per side so filter bleed never clips.
- The table uses the conservative W = L. Recompute once plate proportions are fixed.

| Frame | L (outer) | Canvas at 1x, W = L upper bound | Canvas at 2x |
|---|---|---|---|
| National (all categories) | 16 | 28 | 56 |
| Regional (all categories) | 24 | 38 | 76 |
| Tactical infantry | 28 | 44 | 88 |
| Tactical support | 44 | 68 | 136 |
| Tactical armor | 48 | 72 | 144 |
| Tactical artillery | 56 | 84 | 168 |

- Arithmetic only: the whole set at 2x is low single-digit MB uncompressed. This is not sized against a memory ceiling, because the ceiling is unconfigured.
- Pivot is the unit's centre point (Section 5: "a unit's position is its centre point"). Rotation is about the canvas centre.
- Verify in P3 that rotation shows no half-pixel wobble. NOT SOURCEABLE: how Godot positions odd or even textures.

**AP-8 (PREFERENCE): rasterise each band at its own target size. Never downscale a large raster.**
- National and regional frames are separate authored reductions, not scaled copies. The casing stays 1.5 px (Section 3) at 16 and 24 px, so a scaled copy would change the casing width.
- Author with a 1x pixel-grid overlay and tune the national frame by eye. At 16 px, the Shield/Swallowtail notch (at least 4 px deep) must survive.
- Costs: more authoring review per band.

**AP-9 (PREFERENCE): high-DPI is native 2x frames from the same vector, not stretched 1x frames. Sizes are in logical pixels.**
- Section 3 asks for tests "at 1x and high-DPI". A 1x bitmap stretched 2x blurs the 1.5 px casing, which violates the X1 casing check.
- Alternative: always ship and use the 2x set and let the GPU minify at 1x. This halves the file set but depends on minification quality, which is NOT SOURCEABLE.
- Open: the common non-integer scales (125%, 150%) fit neither set, and how the stretch mode handles them is NOT SOURCEABLE.
- Costs: double the files and double the verification screenshots.

**AP-10 (PREFERENCE): rotation uses one baked frame per variant, rotated by transform.** This is Section 5 option (i).
- Fallback, only if the P3 rotation sweep fails at 16 px: pre-rotated frames for the national band only. That is 16 frames per variant at 22.5 degree steps, so heading is quantised.
- Heading quantisation hides facing information (Pillar 2) unless the steps are finer than what the simulation tracks. The simulation's heading resolution is not decided. This needs a game-designer check.
- Costs: file count and a possible fact-hiding quantisation.

**AP-11 (PREFERENCE): atlas thinking.**
- One atlas per scale (1x, 2x) for all unit frames and overlays, with at least 2 px padding between entries. Pad by dilating each frame's edge colour, so filter bleed reads as casing.
- If the engine batches by texture, that would put every mark on one texture.
- NOT SOURCEABLE: whether batching by texture or material happens, and how AtlasTexture behaves. This is a technical-artist call.
- `DrawableTexture2D` (`rendering.md` L10) might allow a load-time bake. Its behaviour is NOT SOURCEABLE.
- Costs: atlas packing needs a tool step. A bad pad shows as coloured fringes.

### 8.E Frame count

**AP-12 (PREFERENCE): frames per category-band are `fa_full`, `fa_standing`, `fb_full`, `fb_standing`, plus `fa_stale` and `fb_stale`.**
- Both factions need standing frames because the viewer may be either faction.
- Stale frames exist only alongside `full`. Stale marks apply to units the viewer cannot confirm, which are never own units, and non-own units are always at full intensity (Section 1 Principle 3).
- The standing second cue is baked into the `standing` frames. It replaces pixels and adds no frames.

| Case | Formula | Frames |
|---|---|---|
| MVP, 2 categories, no stale (Section 5 figure) | 2 x 3 bands x 4 | 24 |
| MVP with stale | 2 x 3 x 6 | 36 |
| 4 categories, no stale | 4 x 3 x 4 | 48 |
| 4 categories with stale | 4 x 3 x 6 | 72 |
| 6 categories with stale (air and naval placeholders) | 6 x 3 x 6 | 108 |

- The 2x set doubles the file count (36 to 72 files) but not the frame count.
- Section 5's "may double" for stale plus second cue is therefore an overestimate under the stale-on-full-only assumption. The increase is 50%, not 100%. See 8.R #4.
- Overlay count (MVP): brackets 4, ticks 4, stub 1, loss ring 4. That is about 13 more files.
- Render B (independent turret) splits the barrel into a separate rotating overlay for armor at tactical only. That adds one overlay and one draw per armor unit.

### 8.F LOD: the three zoom bands

**AP-13 (PREFERENCE): the bands are the LOD system. A frame never contains a lower band's content.**

| | National | Regional | Tactical |
|---|---|---|---|
| Frame carries | Casing, plate, glyph trait | Same as National, authored at 24 px | Casing, plate, glyph trait, hull, tracks, turret ring, barrel, squad dots (max 8) |
| Overlays | Accent, stub | Accent, tag text (runtime font) | Accent, tag, tracers, status strip, veterancy ticks |

- Switching is an instant swap with hysteresis, no cross-fade (Section 5 C4). The hysteresis margin is a code and P3 value and is not set here.
- Asset requirements that make the swap safe:
  - All bands share the same plate proportions and the same pivot.
  - The same variant exists in every band. A missing state must never fall back to a different state.
  - Every unit swaps bands in the same frame.
- Silhouette-nesting test: overlay the National frame scaled to the Regional size on the Regional frame. The plate contours agree within 1 px.
- Mipmapped LOD has no role for marks, because marks are screen-size constant per band.
- Costs: three authored frames per variant instead of one.

### 8.G Export settings philosophy

**AP-14 (PREFERENCE): colour space.**
- Author and export in sRGB 8-bit. Palette hexes (Section 4) are the only source of colour.
- No HDR, glow or tonemapping on the map layer.
- NOT SOURCEABLE: whether HDR output, glow or tonemapping affect the 2D canvas (the reference lists HDR output as a 4.7 feature but does not describe it), and how 2D colour space is handled.
- Verify in P3 with a palette round-trip: render a flat swatch of each palette hex and confirm the sampled pixel equals the hex within +-1 per channel.
- Costs: any technical-artist choice that enables a WorldEnvironment on the map fails the mood rules.

**AP-15 (PREFERENCE): alpha.**
- Frames are opaque inside. Partial alpha exists only as edge coverage, and no asset contains a semi-transparent interior. This supports the "no opacity changes on any mark" rule (Section 5 C3).
- Transparent pixels carry the casing colour (Sea Night) in their RGB (edge dilation).
- Whether the engine uses straight or premultiplied alpha is NOT SOURCEABLE. The dilation works in either case but must be verified for fringes.
- The only low-alpha elements on the map are the territory tint and the Faction B territory hatch (20% alpha), both applied as runtime colour or modulate, not baked into an asset interior.

**AP-16 (PREFERENCE): mipmaps off, linear filtering, for marks.**
- The reasoning is the screen-size-constant bands. Verify in P3.
- NOT SOURCEABLE: default filter and mipmap settings.
- Costs: if rotation at linear filtering blurs the national notch, the fallback is AP-10.

**AP-17 (PREFERENCE): lossless everywhere.**
- Why: X1 samples rendered pixels at 3:1 contrast along 1.5 px casings, and lossy artefacts would corrupt those edges.
- NOT SOURCEABLE: VRAM or lossy compression behaviour in 4.7. Any compression mode must pass X1 (A/B screenshot).
- Costs: memory, which the arithmetic above shows is small.

**AP-18 (PREFERENCE): handling the line-feather risk (`breaking-changes.md` L31).**
- Bake what is fixed geometry. That covers the plate, glyph, casing (including its fractional 1.5 px coverage), tag stub, brackets, ticks, standing cue, stale treatment and loss ring. The vector rasteriser produces proper edge coverage.
- Baking does NOT help variable-geometry lines. Those stay runtime lines: coastline, territory borders, tracers, contours, roads and the territory hatch if drawn as lines. They depend on P3 results and on the Section 3 widths.
- Order of preference for runtime lines:
  1. Test whether filled-polygon strokes (a stroke expanded into a polygon) look better than line primitives. NOT SOURCEABLE: how fill edges behave (also flagged in Section 6).
  2. Test MSAA 2D (expensive, `rendering.md` L51) and SMAA 1x (`rendering.md` L52). Whether either affects 2D canvas lines is NOT SOURCEABLE.
  3. Widen lines last, as the engine reference advises.
- Costs: widening raises ink coverage against the Section 6 E4 ceilings (4% national, 6% regional, 10% tactical).
- Consistency risk: baked marks will have soft, antialiased edges while runtime lines may be hard-edged. Compare side by side in P3.

### 8.H Per-asset checklists

Each item is pass/fail.

**Plate (baked layer 1-2)**
- Outer length equals the band's L. The canvas follows AP-7 and the pivot is at the centre.
- Fill is exactly one of the four plate hexes (Azure, Amber, Azure Standing, Amber Standing); the stale variant has no fill and a faction-hue stroke.
- The casing ring is closed at all 8 headings, at least 1.5 px, and is the darkest band at the plate edge.
- Notch depth is at least 25% of length (Swallowtail), and Shield and Swallowtail share a canvas size and pivot.
- The silhouette is unchanged by state, apart from the documented second cue.
- Passes the Section 3 rotation sweep (8 headings, 3 sizes, greyscale).

**Glyph**
- Sea Night knockout. Contrast against the plate is at least 3:1 (calculated: 5.9, 11.4, 4.2, 7.6).
- One distinguishing trait per category, and a forward-only feature so facing reads.
- Survives the reduction rule from Tactical to National.

**Tactical detail**
- Sits inside the plate and does not alter its silhouette. Hull, tracks and barrel are static.
- Squad dots at most 8, placed so they never collide with the track bars.
- Stroke count at or under the Section 5 tactical detail cap (infantry 9, support 6, armor 8, artillery 7; starting values), each stroke mapped to a named simulation fact, 2 px minimum with 2 px gaps, baked into the frame (no extra frame or overlay).
- No forward-pointing shapes other than the unit itself.

**Accent geometry (brackets, ticks)**
- Command White only, never a fill.
- Brackets are screen-aligned and static. Ticks pulse by transform, not by opacity.
- Distinguishable without colour (geometry differs).
- Starting dimensions (P3), by band (national, regional, infantry, support, armor, artillery): bracket arms 6 / 8 / 9 / 12 / 12 / 14 px; 2 px stroke with casing; stroke centre 14.3 / 20 / 22.8 / 34 / 37 / 42.6 px from the unit centre; ticks 4 / 5 / 5 / 5 / 5 / 5 px at 45 degrees, 3 px beyond the bracket corner; pulse expansion 4 / 6 / 8 / 8 / 8 / 8 px, 4 pulses at 0.75 s, by transform. Brackets and ticks clear the stub, tag and strip at all 8 headings.

**Tag and stub**
- Stub is a Warm Paper bar of about 12 x 4 px on Panel Ink, at a fixed colour in every state, screen-aligned.
- The tag backing is a plain rectangle and needs no image.
- The stub and tag are anchored at the bracket-envelope offset (Section 4 accent geometry values: bracket-box half-side plus 5.5 px), not the plate edge. Starting values, verify in P3.

**Loss ring and veterancy ticks**
- Ring is 2 px, faction hue, with casing, at most 1.5 x plate length, static. Ticks are Warm Paper horizontal bars on the tag backing. No chevrons or stars.

**Terrain fills (no images)**
- Hex and luminance values are as in Section 6 E3 and at or under 0.04.
- No texture, noise, gradient (except the vignette) or pattern.

**Territory hatch tile**
- 45 degrees, 2 px stroke, 8 px period, faction-hue line at 20% alpha (runtime modulate, not baked into the tile interior; see AP-15), the tile repeats seamlessly.
- It is screen-space and not world-space, and is checked at 2x.

**UI icons (PROVISIONAL on Section 7)**
- Rectilinear (Section 3 S4), 2 px strokes, no Azure, Amber or Command White fill, no red or green.
- No forward-pointing triangle or arrowhead (see the Section 7 conflicts table, row 1).
- Circles only for places.

### 8.I Visibility validation (asset side)

**AP-19 (PREFERENCE): five enforceable asset rules.**
1. **Name grep** (AP-5): no reserved token appears in any file name.
2. **Own-only cues are overlays.** Brackets, ticks, stub, tag and veterancy are never baked into a plate frame. The only own-side cue inside a frame is the `standing` intensity plus its second cue.
3. **One enemy frame set.** Enemy and own under-command units use the same `full` frames. There is no frame variant for "enemy", "ally", "online" or "offline".
4. **Selection key.** The frame selector keys on "owned by the viewer", never on faction alone. Both factions have `standing` frames, so a faction-only key could show a `standing` frame to the opposing player.
5. **Stale frames only exist for `full`.** A stale variant of `standing` would imply the viewer lost track of its own unit.

Automated check on the export script: for each (category, band), the canvas size and pivot are identical across all faction and state variants, and every non-edge pixel colour is in the palette list.

### 8.J Verification evidence (retained in `production/qa/evidence/`)

**AP-20 (PREFERENCE): evidence naming `asset_[test]_[1x|2x]_[yyyymmdd].png`.** Screenshots are retained, not discarded (project rule).
- Rotation sweep: 8 headings x 3 sizes x both plates.
- X1 on composites C-T and C-N, at 1x and 2x (Section 6 E5).
- Casing continuity at all sizes and headings.
- Band-swap before and after frames, showing no intermediate frame.
- M2 four-condition leak test (Section 5 C3): unit pixels identical.
- The three colour-vision-deficiency simulations (Section 4 method).
- Palette round-trip swatches.
- Compression A/B at X1.
- Side-by-side of a baked mark edge and a runtime line edge.

#### Part 2: Technical constraints (engine and pipeline)

### 8.T0 Scope and legend
- TARGET: this block covers engine and pipeline constraints only. Poly budgets, material slots and LOD meshes do not apply to a flat 2D vector game. The meaningful budgets here are frame time, frame dimensions and counts, canvas items per category, and texture memory. Art preferences are in the art-director half.
- SOURCED (`project.yaml` L36-42, `project.godot` L14): Godot 4.7.2, GDScript, Forward+, Godot Physics 2D (unused by the sim). `technical-preferences.md` L41-44: 60 fps, 16.6 ms, 2,000 draw calls as a starting target (unmeasured), memory ceiling `[TO BE CONFIGURED]`.
- SOURCED (`project.yaml` L50-56): file and scene names are snake_case.
- TARGET: frame time (16.6 ms) is the primary gate. Draw calls are a secondary proxy, because see 8.T4.

### 8.T1 Hard constraints and budgets by asset category

**Engine facts that bear on this game**
- SOURCED: in 4.7, CanvasItem lines are drawn without an antialiasing feather, so they look thinner. The reference advises widening lines that relied on the old thickness (`breaking-changes.md` L31; `rendering.md` L11; `current-best-practices.md` L76-77).
- SOURCED: the reference states this for lines only. NOT SOURCEABLE: how filled polygons, polygon edges, textured sprites or baked frames render at their edges, because `docs/engine-reference/godot/` does not cover them.
- SOURCED: writing one element of a packed array no longer calls the property's setter (`breaking-changes.md` L18; `current-best-practices.md` L48-50). This bears on the view layer, which is driven by packed snapshot arrays. Assign the whole array, or call the render API directly, where a setter must run.
- SOURCED: `get_format()` moved to `Texture2D` (`rendering.md` L13). Pipeline scripts that check a texture's format should call it on `Texture2D`.
- SOURCED: `ResourceImporterDynamicFont.hinting` default changed from 1 to 3 (`breaking-changes.md` L40). It affects the callsign tag text (cap height at least 8 px, bible Section 7 Typography, to verify). NOT SOURCEABLE: what the values mean.
- SOURCED: Shader Baker pre-compiles shaders to reduce startup hitching (`rendering.md` L23, L72).
- SOURCED: `DrawableTexture2D` exists, as a simple API for drawing onto textures (`rendering.md` L10). NOT SOURCEABLE: its cost, its line behaviour, and whether it suits runtime baking.
- NOT SOURCEABLE: any maximum texture or atlas size, any draw-call merge rule, any batching rule, any per-frame limit on canvas items or draw commands, and whether `TileMapLayer` suits irregular polygon terrain. None is covered by `docs/engine-reference/godot/`. The only related sourced fact is that `TileMapLayer` replaces `TileMap` (`deprecated-apis.md` L16).

**Per-category table**

| Category | Dimension, count and memory | Tag |
|---|---|---|
| Unit baked frames (build option (i)) | Frame cell must hold the plate rotated through any heading. Cell side is at least plate length x 1.414 plus casing plus margin. Plate lengths are from bible Section 5: 16 (national), 24 (regional), 28-56 (tactical). Superseded by AP-7 (8.D), which is the authority: canvas at 1x is 28 px (national), 38 px (regional) and 44 / 68 / 72 / 84 px (tactical infantry / support / armor / artillery); 2x doubles each. The earlier 32 / 48 / 96 px cells are kept only as a conservative upper bound for the memory arithmetic below. | TARGET (calculated) |
| Unit frame count | Planning figure: 36 frames for the MVP (8.E and 8.R #4: 2 categories x 3 bands x 6 variants, stale only on full intensity, AP-19.5). Lower bound: 24 (no stale frames). Upper bound: 96 (stale treatment and second cue each doubling the 24-frame base). A 2x display scale doubles the file count (36 to 72), not the frame count (8.E). With 4 categories, double all of these. | TARGET (calculated from the bible) |
| Texture memory, frames | 96 x 96 x 4 B = 36.9 KB per tactical frame at 1x, 147 KB at 2x. 96 frames at 2x is about 14 MB assuming uncompressed 4 bytes per pixel (a deliberate overestimate: the 96 px cell is the superseded size, and AP-7's largest canvas is 84 px at 1x and 168 px at 2x). Conclusion: memory is not the binding constraint. Rotation fidelity and per-item cost are. | TARGET (calculated). Engine VRAM overhead, mipmaps and compression: NOT SOURCEABLE |
| Memory ceiling | `[TO BE CONFIGURED]`. | NOT SOURCEABLE |
| Custom shaders, materials | Zero custom shaders in the map layer for MVP. Flat fills, strokes and baked frames need none. Every shader added after that is logged with the reason. If any exist, use Shader Baker. | TARGET. Whether extra materials split draw commands: NOT SOURCEABLE |
| Overdraw | Full-screen layers are sea, land, vignette and territory tint (bible Section 2 layer order). Overdraw cost and limits are NOT SOURCEABLE. | NOT SOURCEABLE |
| Nodes | No Node per unit (project design rule). Canvas items for marks scale with layers x categories x factions, not with unit count. | TARGET |
| Terrain polygons | No vertex cap can be set from the reference. Measure terrain submission cost in P3 and derive a cap from the result. | NOT SOURCEABLE (cap), TARGET (measure in P3) |

**Worst-case mark arithmetic (assumes one draw command per layer per mark, i.e. no merging; the assumption is conservative, not an engine fact)**

| Option | Own unit, tactical (layers) | Enemy unit (layers) | Break-even against the 600-call mark allocation |
|---|---|---|---|
| (ii) one sprite per layer, and (iii) per-frame vector drawing | up to 7 | up to 4 | about 85 own tactical units, or 150 enemy units |
| (i) baked frame plus overlays 5-7 | up to 4 (baked, accent, tag, status) | 1 | about 150 own units, or 600 enemy units |

- TARGET (calculated): at the bible's only stated figure of about 60 marks (Section 5 Risks), worst-case (ii)/(iii) is at most 420, so the 600 allocation is not at risk in the tactical band even with zero merging.
- TARGET (calculated): the national band under the 15-50 player long-term target could carry far more than 60 marks. No document states a unit count per band (decision D2).

### 8.T2 Importer and export constraints
- NOT SOURCEABLE: image and SVG import, texture filtering defaults, mipmaps, compression, colour space (sRGB versus linear), premultiplied alpha and alpha edge handling are not covered by `docs/engine-reference/godot/`. Nothing may be written as an import rule until it is observed in P3.
- NOT SOURCEABLE: whether vector (SVG) or raster (PNG) source gives crisper baked frames, and whether a rotated baked frame is filtered or pixel-snapped.
- TARGET: asset pipeline for P3 is source art kept in `assets/` with the frame list generated by a script from one definition. File names are snake_case per `project.yaml` L50-56. Pattern: `unit_<category>_<faction>_<state>_<size>` (the art-side order from AP-4, which is the authority; size is `nat`, `reg` or `tac`; `_2x` is appended last).
- TARGET: author colours as the bible's sRGB hex (Section 4, primary palette). In P3, sample rendered pixels and compare them to the authored hex.
- SOURCED (`rendering.md` L9): HDR output exists in 4.7 on Windows, macOS and Linux (Wayland). NOT SOURCEABLE: its default and its effect on 2D canvas colour.
- SOURCED (`breaking-changes.md` L51; `rendering.md` L20): glow and the tonemapper (AgX) are described as environment features. NOT SOURCEABLE: whether they act on a 2D-only scene. TARGET: add no WorldEnvironment glow or tonemapping to the map layer, per bible Section 4. Confirm by pixel sampling.
- SOURCED (`rendering.md` L43-45, L69): the reference places the Compositor post-processing node under WorldEnvironment or Camera3D. Do not use it for the vignette.
- TARGET: the vignette must not be a whole-frame post effect. Bible Section 2 M1 puts it behind territory tint and marks, and a whole-frame effect would dim the marks and fail the M1 pixel-diff test. This follows from the bible's own layer order, not from the engine.

### 8.T3 Rendering path constraints
- SOURCED (`rendering.md` L59-61): Forward+ is the default, full-featured, desktop-focused. Mobile is optimised for mobile and low-end, with limited features. Compatibility is OpenGL 3.3 / WebGL 2, with the broadest hardware support.
- SOURCED (`rendering.md` L17, L63; `breaking-changes.md` L52): D3D12 has been the default backend on Windows since 4.6 (was Vulkan), for better driver compatibility.
- NOT SOURCEABLE: the reference names no macOS or Linux backend. Do not state one. P3 records which backend each OS actually uses.
- SOURCED (`rendering.md` L48-54): AA options are MSAA 2D/3D (hardware, quality but expensive), Screen Space AA (FXAA fast and blurry, or SMAA sharp at moderate cost, new in 4.5), and TAA (temporal, best quality, ghosting on fast motion).
- NOT SOURCEABLE: which of these affect 2D lines or polygons, and whether MSAA 2D has a separate setting from MSAA 3D.
- TARGET: exclude TAA from consideration. The reference calls it temporal, and the bible's M1, M2 and leak tests require pixel-identical frames. NOT SOURCEABLE: whether TAA applies to 2D at all.
- SOURCED (`rendering.md` L12): `LinearToSRGB` no longer clamps under Forward+ and Mobile. NOT SOURCEABLE: whether that differs under Compatibility. If a visual shader is used, re-check colours after any renderer switch.
- TARGET: stay on Forward+ (`technical-preferences.md` L15 says "revisit after P3"). Include Compatibility as a P3 comparison. NOT SOURCEABLE: whether Forward+ buys anything for a flat 2D game.
- TARGET: implication of the 4.7 line change for thin-line assets. Treat every information-bearing stroke in the bible's stroke table (Section 3) as an unverified width. Measure the rendered width in pixels in P3 and widen where it fails. Fractional widths (1.5 and 2.5 px) are a risk: NOT SOURCEABLE how they render.

### 8.T4 Draw-call and performance budget plan
- TARGET: the 2,000 total is a starting target. Proposed split, from the bible's Section 5 and 6 proposal: marks 600, terrain 600, UI 300, reserve at least 500.
- TARGET (calculated): the same proportions as a frame-time split of 16.6 ms are about marks 5.0 ms, terrain 5.0 ms, UI 2.5 ms, reserve at least 4.2 ms.
- TARGET: the 16.6 ms frame time is the gate. Draw calls are used only if P3 finds a reliable counter.
- NOT SOURCEABLE: the reference covers no profiler, monitor, draw-call counter, canvas-item counter or GPU timing. P3 therefore cannot assume a counter exists.
- SOURCED: `Time.get_ticks_msec()` is the Time-singleton replacement for `OS.get_ticks_msec()` (`deprecated-apis.md` L32). It can time CPU-side frame deltas. NOT SOURCEABLE: that it can measure GPU time or draw commands.
- SOURCED (`current-best-practices.md` L180-181): `--headless` runs with a headless display. TARGET: P3 render measurements must be windowed runs on real hardware (the `project.yaml` `run` command is windowed). Evidence is retained screenshots in `production/qa/evidence/`, per the coding standard.
- TARGET: the per-category budget is stated in canvas items and layers (the unit the project controls), as in the 8.T1 arithmetic.
- NOT SOURCEABLE: candidate drawing mechanisms for the view layer (a custom draw per layer, a multi-instance 2D mesh, direct RenderingServer canvas calls). They come from model memory and are unverified against the reference. P3 must establish the mechanism, not assume it.
- TARGET, P3 benchmark scene:
  - Reuse bible Section 6's C-T (tactical) and C-N (national) composites, plus a regional composite.
  - Place marks at all 8 headings (0, 45, ... 315 degrees) in all 3 bands.
  - Use N own and N enemy units per band, with N set by decision D2.
  - Run at 1x and 2x display scale, on all three OSes, under Forward+ and Compatibility.
  - Include tracers and the tag stub or tag text.
  - Run the same scene as a control with option (iii).

### 8.T5 Build option to test first
- TARGET: test (i) first, baked layers 1-4 rotated by transform, as bible Section 5 already recommends. It avoids runtime vector lines, the one sourced risk (`breaking-changes.md` L31), and it keeps per-mark layers lowest (8.T1 table).
- TARGET: build (iii) in the same P3 scene as a control, so the comparison is measured. (ii) is a lower priority.
- TARGET: candidate option (iv), not in bible Section 5: bake the frames at startup at the actual display scale using `DrawableTexture2D` (SOURCED existence only, `rendering.md` L10). That removes authoring of 2x variants. Whether baking lines through it avoids the feather is NOT SOURCEABLE.
- NOT SOURCEABLE caveats for (i): filtered or snapped rotation of small baked frames, how frame edges render, whether atlasing is needed at all, and the cost of many rotated sprites per frame.

### 8.T6 High-DPI and stretch
- SOURCED (`ui.md` L13-14; `breaking-changes.md` L39; `current-best-practices.md` L151-153): new 4.7 projects default `display/window/stretch/mode` to `canvas_items` and `aspect` to `expand`. Existing projects keep their settings.
- SOURCED (`project.godot`, read in full, 14 lines): it holds only `config/name` and `config/features`. It has no `display/window/stretch` entries.
- NOT SOURCEABLE: the effective stretch mode and aspect for this project, what each mode does, and any DPI or content-scale behaviour. None is covered by `docs/engine-reference/godot/`.
- TARGET: every pixel value in bible Sections 3, 5 and 6 (1.5 px casing, 16 px plate, 8 px cap height) is undefined between a logical pixel and a physical pixel. Under any scaling stretch mode, a 1.5 px casing could be 3 physical px on a 2x display, or 0.75 px if the unit is misread. Resolved in 8.R #1: a px is a logical pixel at a 1920 x 1080 reference viewport (plate length is the outer length, AP-6). The stretch mode itself must still be set explicitly before P3.
- TARGET: the bake cell size (8.T1) and frame count both double at 2x if frames are baked at 1x.

### 8.T7 P3 checklist (all thresholds are PROPOSALS)

1. Measurement. Is there a usable per-frame draw-command or canvas-item count? Pass: a method is found and documented. Fail: fall back to frame time only and record that. NOT SOURCEABLE in the reference.
2. Frame time of (i) at N units (D2), on the minimum-spec hardware (D3). Pass: p99 at most 16.6 ms. Pass also requires p99 at most 8.3 ms on the developer machine, to leave 50% headroom.
3. (i) versus (iii) control. Record the cost ratio. Pass: the option that meets items 2 and 4 is chosen. If both do, choose the lower frame time.
4. Casing continuity (bible Section 6 X1.3). Pass: no ring gap and measured width at least 1.5 px, in 100% of 8 headings x 3 bands x 2 scales (48 combinations). Compare 1.5 px against 2 px casing.
5. Line widths. For the Section 3 stroke table, measure rendered width from pixels. Pass: at least 90% of the nominal width at every band and scale, and no stroke vanishes. Fail: widen, and report which table values moved.
6. AA options. For none, MSAA, FXAA and SMAA, record casing continuity (item 4) and frame cost. TAA is excluded. Pass: the chosen option keeps the leak test (bible Section 2 M2) pixel-identical across the four conditions.
7. Rotation fidelity. In greyscale at 16 px with a rotation sweep, can testers name each category? Bible Section 3 defines this test, and the notch must read at all 8 headings. Pass: the bible's test as written.
8. Colour. Sample rendered plate, land and sea pixels against the authored hex, with no WorldEnvironment and with HDR output explicitly off. Pass: each channel within 1 of 255. Also confirm the vignette pixel-diff on marks is zero (M1).
9. High-DPI and stretch. Apply the px unit fixed in 8.R #1, render at 1x and 2x, and measure. Pass: casing at least 1.5 logical px on both, and an identical logical layout.
10. Renderer comparison. Run Forward+ and Compatibility on Windows, macOS and Linux. Pass: pixel-identical within the item 8 tolerance (each channel within 1 of 255), or the differences are recorded. Also record the backend that was actually active on each OS.
11. View-layer update cost. Time the packed-array snapshot copy per frame, using whole-array assignment. Pass: at most 2 ms at N units.
12. Terrain cost. Measure the C-T and C-N composites (including the 20% alpha hatch at 2 px stroke and 8 px spacing, and a hatch-legibility check on a plain tint). Pass: within the terrain share (about 5.0 ms), and the ink ceilings (Section 6) hold.
13. Tag text. At the tactical band, 1x and 2x, is an 8 px cap height legible and uncorrupted by the hinting default change? Pass: judged by the art-director, with a retained screenshot.
14. Zoom. Can three discrete bands swap instantly (one frame, with hysteresis; no cross-fade, per Section 5 C3 and C4) without a visible pop, with plate size never below 16 px? This answers bible open item 7 (separate views versus seamless zoom). Pass: no visible pop in a retained recording or screenshot sequence.
15. Startup. With any custom shader present, is there a hitch in the first 10 seconds, with and without Shader Baker? Pass: no frame over 33 ms (a proposed bound, 2x frame time).

#### Part 3: Reconciliation

### 8.R Reconciliation: where a preference and a limit disagree (decided 2026-11-07)

| # | Disagreement | Decision | Follow-up |
|---|---|---|---|
| 1 | What "px" means. The project sets no stretch keys, so the effective stretch mode is NOT SOURCEABLE and every pixel minimum is untestable until the unit is fixed. | A "px" in this art bible is a **logical pixel at a 1920 x 1080 reference viewport**. Plate length is the outer length including the casing (AP-6). | Set the stretch mode and aspect explicitly in project settings before prototype P3 can verify any minimum. |
| 2 | Thin strokes (art: 1.5 px casing, 2 px lines, fractional widths) versus the engine reference's advice to widen lines after the 4.7 change (no antialiasing feather). | **Keep the art widths as targets.** Prototype P3 measures rendered widths. Widen only where a measurement fails, runtime lines last (AP-18). | Record which stroke-table values moved. Fractional widths (1.5 and 2.5 px) remain unverified. |
| 3 | Authoring pipeline and high-DPI. Art wants a vector master with native 1x and 2x frames. The technical half cannot source import, filter or batching behaviour. | **Adopt the art-director's pipeline as the plan:** a parametric vector master per category, a script that substitutes palette hexes and rasterises each band and state, lossless PNG, native 1x and 2x sets, `unit_` as the asset class prefix (not `char_`, which suggests characters; Section 5 C1). Prototype P3 verifies it. | Export script lives in `tools/asset-pipeline/` (technical-artist). Startup baking with `DrawableTexture2D` stays an optional P3 candidate (behaviour NOT SOURCEABLE). Test baked frames first, with per-frame vector drawing as the control. |
| 4 | Frame count. Art: 36 MVP frames (stale only on `full`, +50%). Technical: 24 is a lower bound and stale plus a second cue could each double it (up to 96). | Plan on **36 MVP frames** under the assumption that stale marks exist only for `full` intensity. Treat 96 as the upper bound. | Assumption now stated in Sections 1 and 3 (stale only for full intensity). |
| 5 | Baked marks have soft antialiased edges while runtime lines may be hard-edged, so the map could read as two styles. | Not decided here. | Side-by-side comparison in P3. |
| 6 | Independent turret (Render B) cannot be baked into one rotating frame for armor. | Unchanged and provisional. Under Render B the armor barrel becomes a separate overlay. | Decided after the Pillar 2 re-test and the game-designer pillar check. |

**Still open (not decided here):** target unit counts per band, minimum-spec hardware and the memory ceiling, the renderer (stay on Forward+ until P3, with Compatibility as a P3 comparison), whether to exclude temporal antialiasing outright, accepting frame time as the only gate if no draw-call counter exists, the P3 scope and time-box, and the tolerance for vignette banding on very dark values (a dither would be noise).

**Verification:** the 15-item P3 checklist in 8.T7 and the evidence list in 8.J. Both are proposals until prototype P3 runs.

## 9. Reference Direction

Five references, four for visual direction and one for interaction only, each pointing in a different direction (see the additive check at the end). Each entry gives one specific thing to take, the part of this bible it informs, and what to avoid. A reference is a source of a design principle only. It is never a source of art assets, icons, colours, layouts or branding.

**Sensitivity rule for all references.** No reference is a source of real flags, insignia, national or military branding, or real combatants (Section 1 Principle 3, last bullet; Section 6 E2). If a reference game uses real-world insignia, we ignore that part.

**Verification status.** Entries are marked VERIFIED (a source was checked in this run) or UNVERIFIED (from general familiarity, not checked by search). Treat UNVERIFIED notes as design intent and check them against the work before relying on them. Nothing below should be quoted as a fact about the reference.

### 9.1 Foxhole (game): the front must be readable from the map itself

- **Take:** the question its shared war map poses. Can a viewer see who holds what, and where the contested edge is, from the map alone, with no legend or panel? Our version is already specified: ownership by territory tint, and the 8 px two-tone split border for an active front (7.1). Use the reference as the reading test. A player who has never seen the map should find the front first, before any unit. Pillar 5 (shared territory and victory) is the reason the front is the thing to read.
- **Informs:** Section 1 Principle 1 (5-second ownership and front test); 7.1 (active-front split border); Section 4 (territory tint, Chart Grey for neutral).
- **Avoid:** its grit. Its roughness is texture, and we take its readability of fronts, not its texture (Section 6 E3: no grain, no noise, no hill-shading, no gradients). Do not take its icon set or its faction colour pair (Section 4 owns the palette). Do not borrow any grid or region structure the simulation does not use (E1). Do not borrow persistent-war tone as atmosphere (M1: mood lives in the ground, never in the marks).
- **Status:** UNVERIFIED. The concept's reference table already lists Foxhole for "persistent faction war"; the visual claim here is a design principle, not a description of its screen.

### 9.2 Men of War (game): facing and line of sight as the information the player acts on

- **Take:** the principle that where a unit faces, and what it can and cannot see, is the decision surface. Draw orientation as a simulation fact on a plate whose frame stays constant (S2, C4), with the unit's own firing wedge as the only directional overlay (7.2). Use it as the readability test at tactical zoom: from a screenshot, a viewer states each visible unit's facing and what it covers, with no tooltip.
- **Informs:** Section 1 Principle 2 (one silhouette, more detail as you zoom); S2 (plate, glyph, tactical detail, casing); C4; 7.2 (firing wedge, outline only); Pillar 2 (positioning, facing, timing).
- **Avoid:** its micro-intensity. We take its facing and line-of-sight readability, not its micro-intensity, per the NOT-a-reflex-or-APM-game anti-pillar. Order queuing and planning are the design test (Pillar 2). Do not take a 3D or textured look (Section 1 Principle 2: strictly 2D top-down; E3). Do not take enemy visibility cones: enemy range and arc are never drawn by art default (7.2), and showing them would leak (Section 1 rule, U2). Do not take national markings, which fall under the sensitivity rule above.
- **Status:** UNVERIFIED. I did not check what vision or facing display the game has. Only the principle is claimed.

### 9.3 Flightradar24 (non-game, style reference only): dense live data on a quiet ground

- **Take:** restraint under density. Many live marks can sit on one quiet map and stay legible because the ground recedes and each mark moves only when its data updates. For us: terrain stays quieter than marks (Principle 1, E4 ceilings), and motion is interpolation between real ticks, never ambient (C3, M2). Use it as the density test: at the target unit count, the viewer still finds their own force in under 2 seconds (Section 1 Principle 3).
- **Informs:** Section 1 Principle 1; Section 2 M1 and M2; C3 (continuous motion between ticks only); E4 (terrain ink ceiling); the cold-map risk in Section 1 (offset by callsigns, Principle 4).
- **Avoid:** its name, marks, icon silhouettes, layout and chrome. This is a style reference only (Section 1 Risks and the concept anchor). Specific divergences:
  - Colour-graded trails. FR24's own support page says trail colour encodes altitude, and its scale runs through green and blue to red (VERIFIED, see Sources). Our trails or paths, if any, may not use a gradient (E3), red or green (Section 4).
  - Dotted estimated-position trails. The same page says a dotted trail means the position is estimated outside coverage (VERIFIED). Our C3 bans extrapolation, and dashes are reserved for the standing-order cue. Last-known marks use the stale-mark treatment from Section 1, not an estimate.
  - Imagery basemaps (E3, E1).
  - A radar-sweep or any "alive" treatment (M2).
- **Status:** the trail colour and dotted-trail points are VERIFIED. Everything else is UNVERIFIED. Icon silhouettes and icon colours were NOT confirmed. Check that Amber marks do not read as FR24's icon colour (see Open items at the end of this section).

### 9.4 Imhof-style cartographic colour hierarchy (art and information-design tradition)

- **Take:** one rule of cartographic colour hierarchy. Large areas carry quiet, low-chroma colour, and strong saturation is reserved for small areas. It is the principle behind making terrain the quietest layer. Usable test (area-chroma rank test): rank every palette colour by the screen area it covers, and by its saturation. The two orders must be near inverse. Sea Night and Land Slate cover the most area and are the least saturated. Azure and Amber cover the least and are the most saturated. Command White is never a fill, so it is exempt from the area ranking (Section 4).
- **Informs:** Section 1 Principle 1; Section 4 (the only fully saturated colours are the two faction hues); E4 (fill luminance at most 0.04); S3 (the coastline is the identity, everything else is quiet).
- **Avoid:** the best-known part of the tradition. Shaded relief and hypsometric (elevation-tint) gradients are banned by E3 (no hill-shading, no gradients). Naturalistic lowland tints are out because the palette has no green (Section 4). Beautiful-map ornament is out (E2: geography, not ornament).
- **Status:** PARTLY VERIFIED. The Ordnance Survey cartography colour guide (a secondary source, see Sources) paraphrases the idea: strong saturated colours are kept to small areas and base colours are subdued. Imhof's own text was not checked. Do not attribute exact wording, an edition or a year to him.

### 9.5 Total War (game): interaction only, not a visual reference

- **Take:** one gesture that gives both position and facing. A right-drag draws a line. The line sets where the selected units stand and how wide the frontage is, and the drag direction sets which way they face. A live preview shows each slot before release, so the player sees the result before committing. Our version is already specified and protected in 7.7: a 2 px Chart Mist line, 6 x 6 px slot squares equally spaced (one per selected unit or squad), perpendicular stub ticks on the facing side, and a Panel Ink readout with frontage length and slot count. The reference is used as the interaction test: a player sets position, spacing and facing in one gesture with no menu and no click-spam, and reads the outcome in the preview before releasing. That serves Pillar 2: positioning, facing and timing win, not click speed. It is the planning-over-rapid-click design test (order queuing vs rapid-click micro).
- **Informs:** Section 7.7 (frontage-line preview, protected prototype pattern); Pillar 2 and the NOT-a-reflex-or-APM-game anti-pillar; Section 1 Principle 2 (facing is a simulation fact, shown in a constant frame); Section 3 S1 (no forward points outside units).
- **Avoid:**
  - **Everything visual.** This reference gives no look, no palette, no strategic-map presentation, no unit banners or cards, no UI chrome (E1, E3, S4, Section 7 U3).
  - **Real-world insignia, heraldry or flags** on anything (sensitivity rule above; Section 1 Principle 3).
  - **Forward-pointing placement markers.** A search result (a Steam discussion for one game in the series) describes yellow triangles that point toward the facing direction. Triangles and arrowheads are banned outside units by S1, so facing is shown only by the perpendicular stub ticks in 7.7.
  - **Ghost plates.** Do not preview units as translucent or hollow plates. A ghost needs reduced opacity (C3) or a hollow plate (a stale-mark candidate). 7.7 already bans it: slot squares only.
  - **Intent leaks.** The preview is owner-only and transient. It never appears in any view the enemy receives and never persists on the public map (Section 1 visibility classes, U2).
  - **Depth, ranks or formation types as a new mechanic.** 7.7 specifies frontage length and slot count only. Rank depth, formation presets and modifier-key behaviours are gameplay decisions for the game-designer, not art defaults.
- **Status:** PARTLY VERIFIED by search. A right-mouse drag that sets a unit's width and depth is described in the official Total War battle manual, as summarised in a search result (the manual page itself was not opened): https://r2enc.totalwar.com/en/manual/single-player/0078_enc_page_battle_play_phase_conflict/index.html. Drag direction reversing the facing, and the triangle markers, come from a Steam community discussion and are weaker evidence. The search found NO source for a translucent placement preview in any Total War game, so nothing in this entry claims one: the "live slot preview" is our own 7.7 design, justified by the prototype, not by Total War. Which game in the series, and the exact controls, were not established.

### Additive check

| Pair | Why they point in different directions |
|---|---|
| Foxhole / Men of War | Foxhole informs the national, shared level (who holds what, the front). Men of War informs the tactical, individual level (one unit's facing and sight). |
| Foxhole / Flightradar24 | Foxhole is about reading a boundary and its two owners. Flightradar24 is about legibility of many moving marks. |
| Foxhole / Imhof | Foxhole is a reading test for a public fact. Imhof is a rule for how colour is spent across the whole map. |
| Men of War / Flightradar24 | Men of War is detail added at close zoom. Flightradar24 is restraint at far zoom with many marks. |
| Men of War / Imhof | Men of War is about marks (orientation inside a fixed frame). Imhof is about the ground and the colour budget. |
| Flightradar24 / Imhof | Flightradar24 governs motion and density over time. Imhof governs static colour and area. |
| Total War (interaction) / Foxhole | Total War informs one gesture a player makes (7.7). Foxhole informs a reading test on the shared map (ownership and front). One is input, the other is output. |
| Total War (interaction) / Men of War | Both concern facing, but Men of War is the displayed fact (orientation in a fixed plate, the firing wedge, 7.2). Total War is how the player sets it (the drag). Display and command are different surfaces. |
| Total War (interaction) / Flightradar24 | Total War is a command gesture with a transient owner-only preview. Flightradar24 is passive display of live public data with no command input. |
| Total War (interaction) / Imhof | Total War has no colour or area content at all (interaction only). Imhof is about nothing but colour and area on the ground. They share no axis. |

**Total War is included as an interaction-only reference (9.5), by user decision. It is NOT a visual reference.** Its visual look and strategic-map presentation are not a source for anything here, because at the level of visible technique the strategic map points the same way as Foxhole (ownership on a map) and its look runs against E1, E3 and S3. What we take is only the drag-a-line-to-set-frontage-and-facing gesture and its live preview, which Section 7.7 already protects. If anyone proposes borrowing a Total War visual (banners, unit cards, map art, chrome), that needs a new decision and is not covered by this entry. Visual references are 9.1 to 9.4; the interaction-only reference is 9.5.

### Open items

- **Amber vs Flightradar24 icon colour (open, recorded 2026-11-07).** The art-director could not confirm Flightradar24's icon colour. Before the palette is locked, check a Flightradar24 screenshot against Amber (#FFC247) marks on the dark map. The faction hues are locked in Section 4, so any fix would have to come from shape and layout, not hue.
- **Reference table in the concept.** `design/gdd/game-concept.md` lists Total War as a game reference; this section credits it for interaction only. The documents differ on purpose.
- **Which Total War game and its exact controls** were not established; check against the game the team has in mind.
- **Verification.** Entries marked UNVERIFIED are design intent from general familiarity and must be checked against the work before anyone quotes them.
