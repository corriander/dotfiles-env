---
name: handoff
description: Wrap a session into a mempalace diary entry (and drawer promotion when warranted) so a future session can pick up cleanly. Use when the user says "handoff", "wrap up", "save where we got to", or is closing down for the day/weekend.
argument-hint: "optional free-form steering — topic hint, project slug, next direction, anything to bias the handoff"
---

Persist the current session to mempalace so a fresh agent can resume it without ceremony and without markdown artefacts. Use the diary to chronicle (where we got to) and update or add drawers with canon.

If the user passed arguments, treat them as free-form steering (a topic hint, a focus area, a direction for the next session). Bias the entry accordingly; don't force them into a schema.

Orientate yourself with the `/atlas` skill if you haven't already - it provides context about information stores we use, including mempalace pointers.

## Process

### 1. Write what you already know first

You usually have most of the state in-session — branches touched, PRs reviewed, decisions made, files edited. Draft the entry from that. **Do not re-run investigation you've already done this session.** Re-grepping `git log` or `gh pr view` for things you just looked at is waste.

### 2. Investigate the gaps

Investigate only what you don't already know. Common gaps:
- Worktree state you haven't checked recently — `git status` / `git diff` for uncommitted work
- PRs that may have moved (review state, CI, mergeability) since you last looked
- Branch-local scratch files (`.notes.md`, `*-followups.md`) you didn't open
- Existing memory drawers — cross-reference, don't duplicate

If you have *no* picture of the session state (e.g. compaction wiped it), explore properly: `git log --since`, open PRs via `gh`, scratch files, memory drawers.

### 3. Hygiene check

Before writing, ask yourself explicitly: **is anything load-bearing only-local?**

- Unpushed commits
- Uncommitted changes
- Untracked files (e.g. working notes) within a worktree

If yes, flag it in the entry *and* surface it prominently to the user before they close down - this is high value and easy to overlook.
No need to explain the nature of destructive git actions, the user probably knows, but better to point out work at risk than not.

### 4. Write the diary entry

Use `mempalace_diary_write` with:
- `agent_name="claude"`
- `wing="<project>"` — the project slug (e.g. `asm`). **Required for routing** — omit it and the entry lands in `wing_claude` which is for your own memories.
- `topic` — finer-grained slug under the project (e.g. `admin-auth`).

Defer to `/atlas` (and mempalace's own tools/docs it points to) for AAAK format and palace conventions.

The handoff-specific content should cover, tersely:
- What landed — commits (SHAs), PRs (numbers + state), decisions made
- Stack/branch state at sign-off (open PRs, draft vs ready, mergeability)
- Resume plan — explicit first action for next-session-self, with file:line where known
- Hygiene warnings — single-copy commits, uncommitted work, worktrees not to reap
- Deferred / followups — what was punted, where it's tracked
- Promotion candidates — anything worth graduating from chronicle → canon

### 5. Promote canon if warranted

If the session produced a durable decision-with-rationale (architecture choice, "tried X picked Y", an invariant that constrains future work), or concepts or ideas of note, update or create the relevant drawer in the same turn. Don't duplicate things already captured in committed docs (`docs/`, ADRs, etc.) — link by path instead.

### 6. Report back

Echo the entry (or a faithful summary) to the user before they sign off, so they can sanity-check it while the context is fresh. Surface any hygiene warnings out loud — don't bury them in the diary entry.

## Principles

- **Cite, don't gesture.** File paths, commit SHAs, PR numbers, line numbers. Not "the auth refactor" or "that function".
- **Point-in-time only.** Don't persist anything derivable from current code state (architecture, conventions, file structure) — that's not what diary is for.
- **Stable pointers over transient ones.** Reference memory files and pushed branches over worktree paths and uncommitted changes — unless the transient state *is* the point, in which case flag it as such.
- **Investigative, not transcriptive.** A handoff that only captures what the user said out loud misses the bits they didn't think to mention.
