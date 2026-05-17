---
name: recall
description: Pull the relevant prior-session handoff out of the mempalace diary and summarise it so we can resume work. Use when the user says "recall", "pickup", "where did we get to", or otherwise signals they're resuming work from a previous session.
argument-hint: "optional free-form steering — topic hint, project slug, 'yesterday we did X', anything to bias which handoff to surface"
---

Resume from a prior session by finding the right diary entry, reading it (plus the drawers/tunnels it references), and summarising it back to the user. This is the read-side counterpart to `/handoff`. The user keeps the decision — don't start executing the resume plan; wait for them to greenlight.

If the user passed arguments, treat them as steering: a topic hint, a project slug, a phrase like "yesterday we did X". Use them to disambiguate and to sanity-check the entry you surface.

## Process

### 1. Decide scope

Default scope is the current working directory mapped to a project slug (e.g. cwd `/Users/alex/repos/asm` → `asm`). Steering args can widen, narrow, or redirect this — e.g. `asm/qa-foundations`, or a different project entirely.

### 2. Find candidate entries

Call `mempalace_diary_read agent_name="claude" last_n=5` (or more if needed) and filter to entries whose `wing`/`room` matches scope. Prefer recent over old, but don't assume the most recent entry is the right one — the user may be picking up a thread from earlier in the week.

If the obvious filter returns nothing, fall back to `mempalace_search` with keywords from the steering args.

### 3. Disambiguate loudly when ambiguous

If more than one entry plausibly matches, **don't guess**. List the candidates back to the user with one-line summaries (date, headline, why it's a candidate) and ask which to pick up. Silent wrong-entry picks are the failure mode this skill exists to prevent.

If exactly one entry matches, proceed.

### 4. Read deeper

For the chosen entry, also pull:
- Drawers it references (`mempalace_get_drawer`)
- Tunnels it sits on (`mempalace_follow_tunnels` from the entry, or relevant promotion candidates it mentioned)
- Any sibling entries in the same wing if the chosen entry points at them

Don't over-fetch — only follow links the entry itself surfaces or that are obviously load-bearing for the resume plan.

### 5. Consistency check against steering

If the user passed steering args and the chosen entry contradicts them (different topic, different branch, different decision), **surface the mismatch explicitly** before summarising. Examples:
- User says "yesterday we did the auth refactor" but the latest matching entry is about translation → flag it.
- User names a branch that doesn't appear in the entry → flag it.

Ask which to trust rather than smoothing it over.

### 6. Summarise back

Echo the recall in the same shape the manual loop produces:
- Header: which entry (date, slug, wing)
- What landed last session — commits, PRs, decisions
- Where we got to — branch/worktree state at sign-off
- Resume plan — the next-session-self action from the entry, with file:line where given
- Hygiene warnings — surface these out loud, don't bury them
- Open threads / deferred items worth raising before resuming

Then stop. Wait for the user to confirm the picture matches before doing any work from it.

## Principles

- **Disambiguate, don't guess.** Multiple candidate entries → list them, don't pick. The silent-pickup failure mode is what makes auto-pickup unsafe; manual confirmation is the feature.
- **Cite, don't gesture.** Entry slug + date, drawer paths, commit SHAs, PR numbers. The user should be able to grep their way to the source.
- **Read-only by default.** This skill recalls; it doesn't execute. Don't start the resume plan until the user greenlights it.
- **Trust current state over recalled state.** If the diary says PR #X is open but `gh pr view` shows it merged, trust gh. Verify load-bearing claims before acting on them.
- **Steering wins on conflict.** If steering args and the diary disagree, the user knows something the diary doesn't — flag and ask, don't silently follow the diary.
