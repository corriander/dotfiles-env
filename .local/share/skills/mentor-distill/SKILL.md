---
name: mentor-distill
description: >-
  Maintenance loop for the mentor skill family — re-distill the meta/mentor
  note corpus into the tiered skills. Load when a distillation pass is due:
  a batch of ~5+ new unprocessed mentor notes, any note scored 2/5 or lower,
  a floor-tag misfire observed in a lower tier, or Alex asks to "re-distill",
  "update the mentor skills", or "run a distillation pass". Also the reference
  for how the skill family relates to the note-taking practice.
---

The mentor practice (see `mentor` skill) feeds signed, outcome-scored method notes into mempalace `meta/mentor`. This skill consumes that corpus and maintains the distilled outputs — currently: `ground-and-verify`, `delegation-and-fanout`, `branch-and-repo-surgery`, `open-design-method`. Drawers are the archive; skills are the distillate. **Never delete or rewrite notes** — amendments co-sign, they don't mutate. Skills update **in place**.

**When NOT to use:** to *apply* distilled method, load the sibling directly (`ground-and-verify`, `delegation-and-fanout`, `branch-and-repo-surgery`, `open-design-method`); to *file* a note or run a session grounded, load `mentor`. This skill is only for evolving the skill family itself.

## 1. Triggers for a pass

Run a re-distillation pass when ANY of:
- **≥5 new notes** in `meta/mentor` not yet in any skill's provenance table.
- **Any note scored ≤2/5** — anti-pattern mining is urgent; a diagnosed dead end left unmined poisons by omission. Do not wait for a batch.
- **A floor-tag misfire observed**: a lower tier confidently misapplied a judgement-shaped rule (precedent: untagged judgement lessons shipped down-tier read as mechanical — 22671d amendment; judgement phrasing that didn't fire needed a mechanical proxy — c55ef7).
- **Owner request.**

## 2. The pass, in order

1. **Export the corpus.** `tools/bridge_publish_room.py` in the ackb repo exports any wing/room locally — run it against `meta/mentor`. Reassemble chunked drawers by `parent_drawer_id + chunk_index` before reading (c55ef7).
2. **Diff against provenance.** Each skill ends in a provenance table of drawer-id prefixes. Notes absent from every table = unprocessed. Also re-check notes whose score was revised via amendment.
3. **Run the 2×2** (tier from signature × outcome score — d4c705):
   - high tier × high score → distill as method into the owning sibling's section.
   - low tier × high score → strength to propagate down-tier; don't lose it to tier-weighting.
   - any tier × low score → **anti-pattern or workflow gap** — becomes a fence ("do not X") or a process fix, never method.
   - A 4/5 note is distillable **with its recorded corrections intact** — the corrections are the load-bearing part (5cfd1a, 22671d).
4. **Route each finding:**
   - Method rule → the owning skill's section; strengthen an existing rule with new evidence rather than adding a near-duplicate.
   - Anti-pattern → a fence in the relevant skill, or a process fix routed to the most upstream home that would have prevented it (spec, README, CLAUDE.md — 5cfd1a).
   - `GAP:` line recurring **≥2×** across notes → a skill-text or spec fix is now warranted (single occurrences stay banked — d4c705).
   - Correction-mining findings: remember a delta can indict the **spec**, not the model — route accordingly (5cfd1a).
5. **Update skills in place**, extend their provenance tables with the newly consumed drawer ids. Do not fork new skills unless a stable cluster has no owner. Prefer deriving signals from fields notes already carry; add zero new note-side ceremony (f671a7).
6. **Verify the updated skills two ways**: content (claims still true against the corpus) AND surface/consistency (frontmatter parses, description not truncated at an unquoted `#`, no drift between skills retelling the same fact). These are different review passes — a library needs both (77f726).

## 3. Tier re-expression

- **Respect floors.** `[judgement: <tier>-and-up]` tags travel with the rule verbatim. A tag is a *prediction of where the lesson dies* (e51500).
- **Convert judgement → mechanical only where a real proxy exists** — a burden-of-proof or default-value inversion that makes correct behaviour checkable rather than judgeable (f671a7; worked example: "interrogate the running system" → "compare installed version to checkout version file before trusting a checkout", c55ef7). No proxy → keep the tag; force-mechanised judgement misfires as confident-wrong behaviour.
- **A lesson with no proxy at a tier dies there. Expected, not failure** (e51500). Do not pad lower-tier expressions to fake coverage.
- Untagged rules must be genuinely mechanical — a lower model can follow them without exercising judgement. Audit this on every pass; untagged-but-judgement is the known misfire shape (22671d amendment).

## 4. Cross-machine convergence

- Skills live in `~/.local/share/skills`; `sync.sh` distributes across hosts. After a pass, re-run it.
- Mentor **notes** cross machines via the mempalace bridge (ackb `docs/specs/mempalace-bridge.md`).
- If a pass changed the **charter or conventions** (score anchors, floor-tag semantics, note shapes), publish the changed drawers back through the bridge so all hosts converge — a convention that diverges between machines re-creates the doc-conflict failure class the corpus itself documents (e09023).

## 5. Deferred — do not build now (owner ruling 3)

Recorded as the future maintenance-loop programme, explicitly not current work:
- **Sub-Sonnet injectable-context artefacts** (context-seeding for weak-tool-use local models). "Don't over-index on the tail" — needs empirical evolution, may be skipped entirely.
- **The yield-measurement experiment** (e51500): give tier N a note; have it (i) follow it and (ii) restate it for tier N−1; find where fidelity collapses. Floor tags are the predicted collapse points. This is the empirical programme that would validate the cascade theory — record results as mentor notes when it eventually runs.

## Provenance

| drawer | topic |
|---|---|
| d4c705 | charter |
| 741041 | charter-v1 |
| e51500 | cascade-theory |
| f671a7 | framework-shaping |
| 5cfd1a | delta-review |
| c55ef7 | version-parity |
| 22671d | floor-tag-amendment |
| 77f726 | dual-review |
| e09023 | doc-conflict |
