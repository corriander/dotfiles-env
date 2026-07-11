---
name: branch-and-repo-surgery
description: >-
  Mechanical git procedures for risky repo state: rescuing stale or stacked
  branches after a squash-merge, rebasing across a rewritten mainline, moving a
  parked/stale worktree branch pointer forward, classifying diverged branches
  (ahead/behind counts mislead), previewing merge conflict surfaces, safe
  force-pushing, and recovering files that exist only on a branch tip. Load
  before any rebase, force-push, branch rescue, merge of a long-diverged
  branch, or when a destructive git command is denied by a guard.
---

Floor: **any tool-capable tier** — every rule here is mechanical; none requires judgement. Follow the commands as written.

## Invariants (always, before any history rewrite)

- **Safety-push first.** Push the branch AS-IS before any rewrite (`git push -u origin <branch>` if it has no upstream). The remote copy is the rollback point; the riskiest operations then run with zero unrecoverable-loss exposure.
- **`--force-with-lease` only.** Never bare `--force`.
- **Verify after, before force-pushing:** `git range-diff <old-span> <new-span>` (commits should be byte-identical except intended resolutions) + `grep -rn '<<<<<<<' .` for conflict markers + check commit count and subjects with `git log --oneline`.

## Classify branches by content diff, not commit counts

When mainline history was rewritten (squash/re-review) after branches forked, ahead/behind counts and branch names mislead — a branch can show 20+ ahead and carry nothing novel. Before planning any merge/port:

1. File-level delta each branch actually carries:
   `comm -13 <(git ls-tree -r --name-only origin/main -- <dir> | sort) <(git ls-tree -r --name-only <branch> -- <dir> | sort)`
   plus `git diff origin/main...<branch> --stat` for changed-in-both files.
2. `git rev-list --count origin/main..<branch>` and the reverse, for divergence shape only — never as evidence of novelty.
3. Classify each branch: **superseded / partially-backported / genuinely-novel**. Superseded content predating review passes on main should be re-cut against current main, not merged forward.
4. Check tips for documents that exist on no checked-out tree: `git ls-tree -r --name-only <branch>` then `git show <branch>:<path>`. Review artefacts and handover docs often live only there.

## Rebasing across a squash-merged base

A branch forked from a base that was later squash-merged into the rebase target must NEVER get a plain `git rebase <target>` — it would replay the base's entire foreign history on top of its own squashed content: conflict storm plus duplicated changes.

1. Safety-push (invariant above).
2. Detect the squash by content, not history: `git diff <target> <old-base-branch-tip>` — **empty output means the target is content-identical to the squashed base tip**, which both licenses using it as the rebase target and mandates `--onto`.
3. `git rebase --onto <target> <fork-point-sha> <branch>` — only the branch's OWN commits replay. Get the fork point from recorded state (diary/PR) or `git merge-base <branch> <old-base-branch-tip>` — never merge-base against the target: its rewritten history yields the old base's own fork point from main, and using that replays the base's foreign commits, recreating the exact failure above.
4. Verify (invariant above), then `git push --force-with-lease`.

During any rebase conflict, remember the inversion: `ours` = the new base, `theirs` = the commit being replayed — the reverse of merge intuition.

## Preview a large merge before touching the working tree

For any long-diverged merge, enumerate the conflict surface first:
`git merge-tree --write-tree <branch> <main>` — names the exact conflicting files, converting a scary merge into a known quantity, with the working tree untouched.

## Moving a parked branch pointer forward

To sync a stale/parked branch (e.g. a worktree branch) to a descendant commit like `origin/main`, use `git merge --ff-only <target>`, never `git reset --hard <target>`:

- Preconditions (both checkable): `git status --porcelain` empty AND `git log <target>..HEAD` empty (no unique commits).
- Identical end state to `reset --hard`, but fails loudly if either precondition is wrong instead of destroying anything, and does not trip destructive-action permission guards.
- General form: when a guard denies a broad-capability command, find the narrower command that expresses only the effect you need — don't retry or escalate.

## When surgery contradicts recorded canon

If what you find in git (or what the surgery requires) reverses a decision written down in project canon (roadmap, design doc, ADR), the reversal is a **two-part act**: get the owner's explicit OK citing the evidence, AND update the canon document in the same change. Never just implement the better answer. (Design-side method for reaching such reversals: see `open-design-method`.)

## When NOT to use

Verifying claims/fixes → `ground-and-verify`. Briefing agents to do git work (conflict principles, worktree-escape audits) → `delegation-and-fanout`. Open-ended design → `open-design-method`. Distilling notes into skills → `mentor-distill`; the note-taking practice itself → `mentor`.

## Provenance

| Drawer | Topic |
|---|---|
| d4d577e6 | squash-rescue |
| 313a3872 | classification |
| 8bd922db | ff-only |
| 0393ef1d | ours/theirs |
| d6175ab1 | canon-reversal |
