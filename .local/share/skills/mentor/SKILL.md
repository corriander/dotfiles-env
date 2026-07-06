---
name: mentor
description: Cross-model working-method practice — ground work in constraint sources before acting, and file signed method observations to mempalace meta/mentor. Reference at session start, when told to "take mentor notes", or whenever a method choice materially changes an outcome.
---

We are building a bank of skills to lift less-capable models toward stronger working behaviour, ahead of an explicit capability/cost hierarchy (e.g. Fable → Opus → Sonnet → local). Currently in the take-notes phase: observations accrue in mempalace `wing=meta, room=mentor`; skills are distilled from them later. This skill has two duties, both lightweight.

## 1. Work grounded (always, every task)

Before your first substantive change:
1. List the artefacts that **constrain** the task: ADRs (`docs/adr/`), `CONTEXT.md` files, conventions skills (`/atlas`), and the live schema of any API/tool you will call.
2. Read the constraining ones — not everything.
3. Check your plan against them. If your intended output contradicts one, stop and reconcile **before** writing anything.

While working:
- When two docs disagree, or a doc disagrees with behaviour, interrogate the running system (live schema, installed version, package source) before editing prose. Merge by qualifying, not by choosing.
- Version-qualify any claim about a moving dependency; `git tag --contains <sha>` pins a fix to its release.
- Before fixing one instance, grep for siblings of the same defect.
- Before filing knowledge anywhere, search for where it already lives; merge into the established home and leave a pointer.
- Batch independent lookups into one round-trip; serialise only true dependencies.
- Know each tool's false-success shape (e.g. `noop: true`) and check for it.

## 2. Take mentor notes (only when earned)

When you notice a method choice **materially changed the outcome** — caught an error, avoided a dead end, resolved ambiguity, prevented a regression — file it to mempalace with `add_drawer`, `wing=meta`, `room=mentor`, and pass your model id as `added_by`.

- Read the charter drawer in `meta/mentor` before your first write of a session.
- Entry shape: **Situation → Method → Why it mattered → Distillable rule**, with the rule phrased so a smaller model can follow it mechanically.
- End every entry with a signature line: `— signed: <your exact model id> (<date>)`. The signature is **load-bearing** — entries are weighted by the capability tier that wrote them. Never omit or approximate it. Corrections and failure observations are as valuable as successes; sign those too.
- **Outcome score (HITL while we're shaping this).** When wrapping the task a note came from (sign-off or `/handoff`), ask Alex for a single **1–5 outcome score** for the task — one question, no rubric interrogation, optionally one phrase of why. Record it as the drawer's final line, after the signature: `— outcome: <n>/5 (alex, <date>)[: <one-phrase reason>]`. Anchors: **5** = would delegate this task-shape again unchanged; **3** = landed, but needed rework or hand-holding; **1** = wrong direction / dead end. The score ranks the *task outcome*, and therefore how much weight the note's methodology deserves when distilling. This is **not** the mempalace AAAK diary star rating — never conflate the two. A low-scoring task still deserves a note (often the best ones — capture what method would have prevented the outcome). If no score is available when filing, file anyway and append it later via full-content `update_drawer`.
- Don't log routine work. One sharp rule beats five vague ones. If a rule already exists, strengthen it with new evidence and co-sign rather than duplicating.

## 3. Mine human corrections (delta reviews)

When Alex has hand-edited model output (an ADR, spec, doc, code) and asks for a review of his changes before it ships:

1. **Review honestly first.** Diff the model revision against his edit and flag anything his changes broke, contradicted, or made inconsistent. The review must stay a real review — deference here poisons the signal.
2. **Classify every delta** into exactly one of:
   - **Correction** — the model output was wrong or ungrounded. Name the constraint source that would have prevented it (ADR spec, CONTEXT.md, prior decision), or note that none exists yet.
   - **Preference/framing** — legitimate output Alex wanted said differently. Guidance-shaped: belongs in whatever spec governs the artefact type.
   - **New information** — Alex knew something the model could not have. Explicitly no guidance action (do not overfit guidance to the unknowable).
3. **Route each learning to the most upstream home that would have prevented it**, and propose the concrete edit rather than just observing: per-repo `docs/adr/README.md` → `~/notes/superuser/adr.md` → project CLAUDE.md → a skill → (only if nowhere else fits) a standalone mentor note.
4. **File a mentor drawer** (`wing=meta, room=mentor`): shape **Artefact → Deltas (classified) → Inferred gap → Where routed**. Signed by the reviewing model as usual, with the corrections credited: `(corrections: alex)`. The outcome score applies to the original authoring task, not the review.
