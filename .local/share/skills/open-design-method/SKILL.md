---
name: open-design-method
description: >-
  Ordered method for open-ended design tasks — orient in conventions, measure the real
  distribution, search the system's self-reference, read the tool's NON-capabilities,
  get decisions on the real forks, only then design. Judgement-heavy — sonnet-and-up
  floor for the skill as a whole. Load when facing an open design ask ("design a way
  to…", options analysis, partitioning/identity/sync schemes), when a doc or user names
  a protocol/standard as the direction, when graduating spike/prototype code into a
  production surface, when reversing a decision written in project canon, or when
  turning a settled design into engineering issues.
---

**FLOOR: [judgement: sonnet-and-up] for this skill as a whole.** The scaffold steps are individually mechanical, but the payoff — seeing which fork matters, which reframe is cheap, which residual is genuinely novel — is judgement. Rules below tagged tighter where noted; untagged steps are mechanical once you are above the floor.

The failure mode this skill exists to prevent: jumping straight to designing/coding. On an open task the design is the *last* step, and the clever move only becomes safe and obvious after the grounding sequence.

## The rubric (ordered — do not skip ahead)

1. **Orient in the conventions map first.** Load /atlas (or the repo's CONTEXT.md/ADRs) before touching the system — know where canon lives, how the thing is addressed, what already governs it.
2. **Survey the REAL distribution, not the headline total.** Measure the actual data/workload you are designing over; the skew is load-bearing, the total isn't. Make each design premise predict a number, then take the measurement — a single measured skew can refute the naive design outright (e.g. 80% of 27k drawers in one undifferentiated wing killed partition-by-wing before a line was drawn).
3. **Search the system's self-reference.** Check whether the system already stores decisions/notes about itself, and for prior art, before designing new structure.
4. **Read the tool's source for its NON-capabilities.** The gaps shape the design more than the features (no importer → the sole new code is an importer; machine-local embeddings → transport content and re-embed). Parity-check first: compare the installed package version (`uv tool list` / `pip show`) against the checkout's version file; if they differ, ground against the installed site-packages tree and version-qualify every claim. A checkout is neither ahead nor behind by assumption.
5. **Get decisions on the real forks before building.** Present structured options WITH a recommendation and evidence. Treat the answers as intent to refine, not a frozen spec.
6. **Only then design.** With distribution + constraints in hand, the reframe is cheap and verifiable instead of a guess.

## When a protocol/standard is named as the direction

Do not start from the protocol. State its semantics in one sentence, then search the existing architecture for where those semantics already live under another name; only the genuinely-absent residual justifies new machinery (an approval-gated lease already *is* token exchange). Corollary: separate the planes (who authenticates / what carries authority in flight / how elevation is granted) — options that look like alternatives often answer different planes. [judgement: opus-and-up]

## Cheap design-time interrogations (before any build)

- Routing an automated periodic probe (scrape, health check) through a component that manages lifecycle on demand: ask of the exact path "does GET here cause a state change?" If the component's job is lazy-loading, assume yes until the docs say otherwise.
- A write strategy leaning on platform/DB constraint features: list the features and check each exists in the TEST environment, not just prod. If test lacks one, choose a strategy whose correctness does not require it — the constraint often forces a strictly better design.
- When a design is overdetermined, order the stated rationales by durability: workload/semantics first, environment quirks last; mark any rationale with a known expiry ("until #NNNN lands") so a later reader doesn't fix it backwards.
- Two workstreams over the same code: classify each by the axis it changes (mechanism / payload-schema / policy). Orthogonal axes → parallel-safe with file-level sequencing; same axis → sequence or merge. Hunt the convergence: one strand's new fields are often the other's missing keys. [judgement: opus-and-up]

## Graduating spike code into a production surface

- **Scope from the sequencing doc.** Implement only the named step; put the deferred siblings verbatim in the PR body as "deliberately out of scope".
- **Re-decide the error contract.** Placeholder outputs acceptable in a spike are defects in an operator tool. Convert every placeholder into either a loud error (collect ALL problems, raise once, name the exact key) or an explicit default. Spotting which is [judgement: sonnet-and-up]; the conversion is mechanical.
- A spike's "mirrors X" comment is a claim — read X. The real thing usually has behaviour the spike lacks.
- Reuse sibling test conventions by reading them first; before copying a pattern, check whether it carries a known diagnostic — don't replicate debt.
- E2E against the real estate (read-only): validate the integration, not just the capability.
- Recall-surfaced hygiene (superseded PRs, stale canon drawers) is part of the resumed task — close it in the same session.

## Reversing written canon

A reversal of a decision recorded in project canon is a two-part act, never one: get the owner's explicit OK **citing the evidence** that contradicts the written decision, AND update the canon document in the same change. Never just implement the better answer.

## Honest corrections are part of the method

Recording corrections against your own proposals is the method working, not a failure log — the source note's value was the narrated approach *plus* its corrections.

- Offer a reframe as a **default, not an imposition**. The user's original axis encodes intent your cleaner substitute drops; keep an owner-override for the cases the clean axis wrongly excludes. [judgement: sonnet-and-up]
- Don't launder a challenge-to-the-framing into abandonment. Separate "this framing is wrong" from "there's nothing here" — over-correcting on a passing doubt discards real value. [judgement: sonnet-and-up]

## Exit ramp: settled design → engineering issues

Before drafting issues, run a read-only code survey answering exactly: (1) name/concept collisions with anything existing, (2) precedent patterns to conform to, (3) which design prerequisites already hold vs need building. Cite file:line in the issues. Run it in parallel with writing the design artefact — the survey gates the issues, not the spec. Ungrounded issues are plausible and wrong-shaped: the expensive kind of wrong.

## When NOT to use

For evidence/verification discipline see **ground-and-verify**; subagent orchestration → **delegation-and-fanout**; rebase/branch rescue → **branch-and-repo-surgery**; distilling the corpus itself → **mentor-distill**; the note-taking practice → **mentor**.

## Provenance

| Drawer | Topic | Distilled into |
|---|---|---|
| 22671d5b | airlock | rubric steps 1–6; both correction lessons (kept intact per 4/5 note's amendments) |
| c55ef73b | version-parity | installed-vs-checkout parity check (step 4) |
| 191ecafa | protocol-semantics | named-protocol section |
| d6175ab1 | probe-paths | probe state-change question; canon-reversal two-part act |
| 535c7383 | issue-spike | dialect-delta check; rationale durability; workstream axis classification |
| 95f02c1e | spike-graduation | graduation section |
| ac04455c | design-to-issues | exit-ramp survey |
