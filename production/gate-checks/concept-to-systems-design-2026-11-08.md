## Gate Check: Concept → Systems Design

**Date**: 2026-11-08
**Checked by**: gate-check skill (`workflow: full`, studio specialist depth, 4-director panel)

### Required Artifacts: 3/3 present
- [x] design/gdd/game-concept.md — exists, 305 lines, every section filled
- [x] Game pillars — five pillars with design tests, plus anti-pillars
- [x] Visual Identity Anchor — a one-line rule and four principles (design/gdd/game-concept.md, "Visual Identity Anchor: Living Radar")

### Quality Checks: 3/3 passing
- [x] Concept reviewed — design/gdd/reviews/game-concept-review-log.md: NEEDS REVISION (not MAJOR REVISION NEEDED)
- [x] Core loop described (four timescales)
- [x] Audience identified (Target Player Profile, framed as hypotheses)
- [x] Recommended: concept prototype with REPORT.md PROCEED (prototypes/tactical-skirmish-concept/REPORT.md; CD-PLAYTEST CONCERNS accepted; Pillar 2 not validated)

### Director Panel Assessment (4 of 4 ran)

Creative Director:  CONCERNS — nothing blocks entry; the concept text contradicts confirmed decisions; A5 and A9 touch MVP GDDs
Technical Director: CONCERNS — nothing blocks entry; P1 and P2 need pass criteria and a time-box; the language pin contradicts the open question
Producer:           CONCERNS — nothing blocks entry; seven items must be scheduled as the phase's opening work
Art Director:       CONCERNS — nothing blocks entry; the concept's visual anchor contradicts Pillar 1

### Blockers
None. All four directors state that nothing blocks entering Systems Design.

### Concerns
1. The concept text contradicts confirmed decisions (lines refer to design/gdd/game-concept.md at gate time): line 157 and line 234 say offline fights use "coarser resolution" and offline fidelity was "resolved by decision" (A1 says never aggregated combat); line 238 says fixed-point "should" (B10 requires "must"); line 195 and line 299 carry stale engine text; lines 208, 213 and 216 are the visual anchor's old rules replaced by the art bible (B1/B2).
2. The A10 tiebreak (2 > 1 > 5 > 3 > 4) is not written into the Pillars section.
3. Open decisions that gate specific GDDs: A5 before the Unit, Scenario & Tuning Data GDD; A9 before Viewer Projection; A4 before Economy; A6 before Inter-island Transit; A7 before Campaign Lifecycle; A8 before the Faction Command GDDs.
4. Spike P1 (language, throughput, determinism) should run, time-boxed, before the Simulation Core GDD; the project.yaml language pin is provisional until it reports. P2 should be rescoped to line-of-sight cost over the hand-authored grid.
5. The user must pick the real MVP region (sensitivity and licensing check); the technical-director's sign-off on the region format and terrain contract C3 is pending.
6. The Pillar 2 re-test needs a date, an outside tester and a pause-off condition.
7. Plan Systems Design as strictly sequential (team.size studio vs one real developer); the Skirmish checkpoint with thin systems 7, 11 and 13 is roughly 5.5-8.5 months (plan on 7; low confidence).
8. Creative-director question: reorder the MDA ranking (Challenge first) or keep Fellowship first as a stated long-term aspiration.

### Chain-of-Verification
5 questions checked (3 by tool action: re-grep of the concept for stale text, re-check of required sections and the review verdict, re-scan for unresolved manual items) — verdict unchanged.

### Verdict: CONCERNS
The stage stays Concept unless the user explicitly accepts the risks above (not requested at the time of this report).
