---
name: ground-and-verify
description: >-
  Grounding and verification playbook — the constraint pass before acting, parity
  checks (installed vs checkout, test vs prod dialect), live-system truth over prose,
  re-verifying recalled or issue-tracked state, enumerating a tool's NON-capabilities,
  and cheap-first verification economics. Load at session start for any substantive
  task; mid-task when two sources disagree, when resuming from a handoff/diary/issue
  checklist, before an expensive live run (LLM call, deploy, long job), before
  adopting a named protocol/standard, or before trusting any "not implemented" claim.
---

This is the mentor skill's §1 ("work grounded") evolved into a full playbook, distilled
from the meta/mentor corpus. It stays consistent with §1 — if the two ever diverge,
flag it; don't silently pick one. Rules are mechanical unless floor-tagged
`[judgement: <tier>-and-up]`.

## 1. The constraint pass — every task, before your first substantive change

1. List the artefacts that **constrain** the change: ADRs, CONTEXT.md, conventions
   skills, the live schema of any API/tool you will call. Read the constraining ones —
   not everything.
2. If your plan contradicts one, stop and reconcile **before** writing anything.
3. If a routed convention source is missing on this host, do not author from memory:
   read the live exemplar in the sibling repo the conventions propagate from and
   **adapt** it — never copy verbatim (copied boilerplate goes stale in place).
4. When new evidence reverses a decision written in project canon, the reversal is a
   two-part act: get the owner's explicit OK citing the evidence, AND update the canon
   document in the same change. Never just implement the better answer.

## 2. Parity checks — before trusting any source as "ground truth"

- **Installed vs checkout.** Before citing a tool's schema/source as grounding:
  (1) find how it is actually launched (MCP config, `which`); (2) compare the installed
  package version (`pip show` / `uv tool list`) to the checkout's version file;
  (3) if they differ, ground against the installed site-packages tree and
  version-qualify every claim ("as of X.Y.Z"). A checkout is neither ahead nor behind
  by assumption — check, don't infer.
- **Test vs prod dialect.** When a design leans on an environment feature (DB
  constraint types, FK enforcement, index kinds), list the features and check each
  exists in the TEST environment, not just prod. If the test dialect lacks one, choose
  a strategy whose correctness doesn't require it rather than accepting divergent test
  semantics.

## 3. Live ground truth beats prose — when sources disagree or claims are load-bearing

- When two docs disagree, or a doc disagrees with behaviour, interrogate the running
  system (live schema, installed version, package source) before editing any prose.
  Merge by **qualifying**, not by choosing — both sides are often right for different
  versions.
- A claim about tool behaviour is incomplete without the version observed. Told a fix
  is "pending"? Find the commit and run `git tag --contains <sha>` — it's often
  already released.
- A "mirrors X" / "same as X" comment is a claim; read X.
- **Negative claims need a search you can describe.** Treat any "not implemented /
  does not exist / not started" — from a subagent report or a doc's own Status line —
  as unverified. Run one broad grep across the whole plausible surface (not just the
  file the spec names) and check the changelog/commit log for the feature's name.
  Positive claims carry their evidence; negative claims are silently sensitive to
  where the reader looked.
- When two evidence sources contradict, don't average or pick — resolve by direct
  interrogation of the code, then say in the deliverable which source was wrong.

## 4. Re-verify recalled and tracked state — on any resume, recall, or old checklist

- **Diary/memory state is a hypothesis.** One cheap live query per load-bearing claim
  (`gh pr list`, `git log`, a grep) before acting on it.
- **Issue checklists staler than a week:** (a) `gh pr view <n> --json state,mergedAt`
  every referenced PR — closed-unmerged means the work may have landed via another
  chain, so grep main for the symbols that PR introduced; extend one hop to PRs
  *stacked on* the referenced PR, not just PRs the issue names; (b) grep main for
  every symbol/constraint the checklist names; (c) implement only the residue, and
  record the found-delta in your PR body so the issue can be re-baselined.
- **Claimed bug at file:line:** write the failing test FIRST and run it against
  unmodified code. If it does not fail exactly as predicted, stop — the issue is
  stale, wrong, or misread. Keep the red output; it's proof the bug is real and
  current, and guards against fixing an already-fixed bug.

## 5. Enumerate NON-capabilities — before designing against a tool or protocol

- Read the tool's source for what it **cannot** do (no importer, whole-export-only,
  machine-local state, prune-on-missing-path). The gaps shape the design more than
  the features; each gap is a concrete constraint.
- When a doc or user names a standard/protocol as the direction, do not start from
  the protocol. State its semantics in one sentence, then search the existing
  architecture for where those semantics already live under another name; only the
  genuinely absent residue justifies new machinery. Corollary: separate the planes
  (who authenticates / what carries authority / how elevation is granted) — options
  that look like alternatives often answer different planes.
  [judgement: opus-and-up]
- **Probe-path state change.** Before routing any automated periodic probe (scrape,
  health check, watchdog) through a component that manages lifecycle on demand, ask
  of the exact path: "does GET here cause a state change?" If the component's job is
  lazy-loading, assume yes until the docs say otherwise.

## 6. Verification economics — before any expensive live run

- Run every failure/guard path that doesn't incur the expense FIRST — guards exercise
  most of the same plumbing for free, and often surface env/wiring issues on their own.
- Then query actual fixture state and pick the single most evidence-dense subject:
  the one live run that falsifies the most independent claims, preferring subjects
  that light up optional feature branches. One well-chosen run replaces four.
  [judgement: sonnet-and-up for subject selection]

## 7. Cheap mechanical closes — before shipping

- Derive lint/format/type-check file lists from `git diff --name-only <base>...HEAD`,
  never from recollection — memory drops file *creations* first, exactly what
  added-file gates check.
- Before fixing one instance, grep for siblings of the same defect; fix the set or
  record why not.
- Know each tool's false-success shape (e.g. `{"success": true, "noop": true}`) and
  check for it — "success: true" is not "it did what I meant".
- Batch independent lookups into one round-trip; serialise only true dependencies.
- Before filing knowledge, search for where it already lives; merge into the
  established home and leave a pointer — a second copy is a future conflict.

## When NOT to use

Delegation briefs and fan-out verification → `delegation-and-fanout`. Rebase/squash/
worktree mechanics → `branch-and-repo-surgery`. Open-ended design sequencing →
`open-design-method`. Note-taking practice → `mentor`; corpus-to-skill work →
`mentor-distill`.

## Provenance

| Drawer | Topic |
|---|---|
| e090238 | grounding omnibus (§1, §3, §7) |
| c55ef73 | version-parity (§2, §5) |
| 535c738 | issue-scope re-verify, test dialect, git-derived file lists (§2, §4, §7) |
| 95f02c1 | recalled-state re-verify, mirrors-X (§3, §4) |
| 87707eb | red-first failing test (§4) |
| fbea4ff | negative claims (§3) |
| 22671d5 | NON-capabilities, design grounding (§5) |
| 191ecaf | architecture-already-implements (§5) |
| d6175ab | probe-path state change, canon reversal (§1, §5) |
| 0354f8b | live-verification economics (§6) |
