## Review — 2026-11-07 — Verdict: NEEDS REVISION
Review mode: full · Workflow: full
Scope signal: M
Specialists: game-designer, systems-designer, ai-programmer, network-programmer, godot-specialist, qa-lead; senior reviewer creative-director
Blocking items: 23 (10 decisions A1-A10, 13 text contradictions B1-B13) | Recommended: deferred items (ADRs, per-system GDDs, spikes)
Summary: The concept's identity holds (live national map, public positions and hidden intent, hands-on fights); no pillar, hook or fantasy needs replacing. It is underdecided rather than wrong: about ten decisions inside the existing pillars are open, and two are written as "resolved by decision" when they are not (offline combat fidelity, intact fallback). The Visual Identity section contradicts Pillar 1. The user chose to proceed without revising now; the verdict stays NEEDS REVISION and the items remain open.
Prior verdict resolved: First review
Findings:
- [BLOCKING] Decision A1 (Technical Risks, Anti-Pillars): offline and off-screen combat needs one resolver; "coarser resolution" reintroduces auto-resolve. Recommended: event-driven strategic layer, full tactical sim on any contact
- [BLOCKING] Decision A2 (Pillar 4): can standing orders take ground? Recommended: limited offensive verbs
- [BLOCKING] Decision A3 (Core Loop): sim clock vs wall clock. Recommended: two clocks
- [BLOCKING] Decision A4 (Pillars 3 and 5): who pays for replacements. Recommended: personal quota earned from faction contribution
- [BLOCKING] Decision A5 (Core Fantasy): what one player commands. Recommended: small owned force
- [BLOCKING] Decision A6 (Scope Tiers, Risks): how forces cross islands. Recommended: abstract sealift links, one landmass until after Vertical Slice
- [BLOCKING] Decision A7 (Open Questions): campaign lifecycle. Recommended: seasonal campaigns with victory and reset
- [BLOCKING] Decision A8 (Core Fantasy, MDA): how Fellowship is delivered. Recommended: shared faction vision plus objectives exceeding one force
- [BLOCKING] Decision A9 (Visual Identity): what enemies see of online presence. Recommended: nothing
- [BLOCKING] Decision A10 (Pillars): pillar tiebreak order. Recommended: 2 > 1 > 5 > 3 > 4
- [BLOCKING] Visual Identity Anchor: "dashed intent line" and presence brightness contradict Pillar 1 (B1, B2)
- [BLOCKING] Anti-Pillars / Technical Risks: "coarser resolution" and "resolved by decision" (B3, B4)
- [BLOCKING] Risks vs Scope Tiers: naval contradiction (B5)
- [BLOCKING] Flow State Design: "forces fall back intact" contradicts Pillar 3 (B6)
- [BLOCKING] Pillar 2: "tactical slowdown" impossible on a shared clock; veterancy vs "not stat checks" (B7, B8)
- [BLOCKING] Core Fantasy: no "we"; "nation-scale commander" vs squad-level control (B9)
- [BLOCKING] Technical Risks / MVP design rule: "should" must be "must" for fixed-point; no engine services inside the sim (B10)
- [BLOCKING] Technical Considerations / Next Steps: stale engine facts (B11)
- [BLOCKING] MVP Definition: hypothesis overclaims; fully tests Pillar 2 only (B12)
- [BLOCKING] Core Identity: "15-50 concurrent" ambiguous (B13)
- [RECOMMENDED] Sim ADR, combat/AI GDDs, multiplayer ADR, economy GDD, QA thresholds, art-bible line-drawing check, narrative premise, glossary and registry seeding
Reviewed-Content-Hash: design/gdd/game-concept.md 128a1bf897cc3ea4e100046874746be3514b461b
Reviewed-Content-Hash: design/registry/entities.yaml dfeacb02917f751cb1dfd88cf490c7ec3d8d2d0f
Reviewed-Content-Hash: .claude/skills/design-review/SKILL.md a63d8fba9b7142eeb43791f061e2e1533c429b43
Reviewed-Content-Hash: prototypes/tactical-skirmish-concept/REPORT.md 6e8cd6ef09dad96515ff274c7c4a191e708f6892

## Decisions recorded — 2026-11-08
The user confirmed four of the ten open decisions from the 2026-11-07 review (the review itself is unchanged: NEEDS REVISION until the text contradictions B1-B13 are applied and the remaining decisions are made).
- A1 one resolver: an event-driven strategic layer; any contact runs the full tactical simulation, never aggregated combat.
- A2 limited offensive standing-order verbs (advance if uncontested, retake a lost objective), doctrine-bound and visibly weaker than a human.
- A3 two clocks: fast strategic, 1:1 tactical on contact.
- A10 pillar tiebreak order: 2 > 1 > 5 > 3 > 4.
Still open: A4 (replacement quota), A5 (what one player commands), A6 (island crossing), A7 (campaign lifecycle), A8 (how Fellowship is delivered), A9 (what enemies see of presence). Text contradictions B1-B13 in design/gdd/game-concept.md are not yet applied (B3, B4 and B12 now have their answers available from A1 and the revised MVP definition).

## Text fixes applied — 2026-11-08
Applied to design/gdd/game-concept.md: B1/B2 (the visual anchor is replaced by a pointer to art bible Section 1), B3 (anti-pillar now says one resolver, no aggregated combat), B4 (offline fidelity decided, not "resolved by coarser resolution"), B5 (Vertical Slice split and naval/logistics tier contradictions fixed earlier on 2026-11-08), B10 (fixed-point is a "must"), B11 (engine text current), B12 (MVP hypothesis states what the MVP actually tests), and the A10 tiebreak written into the Pillars section.
Still open: B6 ("falls back intact" as a general failure rule), B7 ("tactical slowdown" cannot work on a shared clock and conflicts with the pause-off re-test), B8, B9, B13, and decisions A4 to A9. The concept review verdict stays NEEDS REVISION until those are resolved and a re-review runs.
