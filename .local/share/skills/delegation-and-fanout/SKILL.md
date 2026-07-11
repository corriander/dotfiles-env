---
name: delegation-and-fanout
description: >-
  Orchestrating subagents: writing delegation briefs/mandates, sizing and
  launching fan-outs under quota/cap pressure, evaluating agent reports
  (especially negative claims), and recovering/resuming journaled workflows.
  Load whenever you are about to spawn Task/Explore/agent() workers — parallel
  authoring, parallel review, delegated git surgery, repo surveys — or when a
  fan-out is mid-flight and a usage cap, window reset, or failed agent forces a
  stop/resume decision. You are the orchestrator; the agents are not you.
---

You are the orchestrator. Delegated work is only as good as the brief you write, and agent reports are claims, not facts. Lifecycle: **brief → launch → evaluate → recover**.

## 1. Brief

- **Put verification in the mandate, not the review.** Every authoring brief carries: "verify every command, flag, path, and claim against the repo before stating it; unverifiable → drop or label '(unverified — re-check)'." Wrongness has teeth where claims execute (commands, SQL, flags) — aim the burden there. This mostly works (2 findings in 72 probes on a mandate-carrying skill) but never replaces independent review (§3).
- **Memory is substrate, never source.** Hand private memory/session context to subagents as a compiled excerpts file with hard rules: embed the knowledge, never cite the memory store, re-verify every file:line anchor — code has drifted since the memory was written.
- **Gate scope on fresh human answers, not recalled state.** Memory tells you where the front WAS; only the human knows where it IS. Before delegating a campaign-shaped effort, ask the gating questions (observed confirmation rate of memory-derived "laws": 1 in 4). Never promote an observed team stance to codified law without explicit confirmation. [judgement: Sonnet-and-up for spotting which decisions are scope-steering]
- **Brief conflict-bearing git work with PRINCIPLES, not "resolve sensibly".** Include: the exact command with fork-point SHA; the expected conflict files; a keep-what resolution principle per file ("keep BOTH subcommands"); the rebase ours/theirs inversion warning (`ours` = new base, `theirs` = replayed commit — reverse of merge intuition); required expected-value verification (test counts, commit counts, range-diff report-back); and **NO PUSH** — pushing is yours. Authoring the resolution principles requires knowing what each side intends [judgement: sonnet-and-up]; the verification checklist is mechanical.
- **Pre-scope read-only surveys with exact questions.** When turning a settled design into issues, spawn a repo survey asking precisely: (1) name/concept collisions, (2) precedent patterns to conform to, (3) which prerequisites already hold vs need building — and run it in parallel with artefact-writing so it costs no wall-clock. The survey gates the issues, not the spec; cite file:line in the issues.

## 2. Launch — fan-out economics

| Lever | What it buys | Rule |
|---|---|---|
| Window sizing | Not losing in-flight work | Size the fan-out to COMPLETE inside the current quota window. If a known cap arrives first, don't launch. |
| Pre-cap stop | ~sunk-cost only, vs total loss | In-flight agents at a cap die unrecoverably (one lesson cost ~1.3M tokens re-bought); completed calls journal free. Stop in-flight agents (TaskStop) BEFORE the cap, relaunch clean after reset. |
| Batching | Blast radius | Batching limits how much one failure takes down. It does NOT cut total spend. |
| Scope cut by risk class | Total spend | Per-item factual verification only where claims EXECUTE (commands, flags, SQL); whole-set reviewers where risks are consistency-shaped (18 agents → 11 here, ~1M saved). |
| Cold resume | Cheapest gap-crossing | Keep-alive pings to hold a prompt cache (~5-min TTL) cost more than one cold read. Resume cold. |

## 3. Evaluate output

- **Negative claims from delegated readers are weak evidence.** A positive finding carries its citation; a negative finding cites only where the reader looked. Fan-out amplifies this: spot-check misses read back as confident "not implemented". Before repeating any "not implemented / doesn't exist / not started" claim (agent report OR a doc's own Status line): run one broad grep across the whole plausible surface (`grep -rli <term> <app-dir>`, not just the file the spec names) and check the changelog/commit log for the feature name.
- **When sources contradict** (agent report vs changelog, doc vs code): don't average or pick — interrogate the code directly, then say in the deliverable which source was wrong.
- **Enumerable facts: extract, don't summarise.** One `grep -H '^..Status' docs/adr/*.md` beats a delegated summary of 15 statuses and catches the agent's internal inconsistencies.
- **Expected-value verification makes success claims falsifiable.** "37 tests passed" not "tests passed". After delegated git surgery, re-run the cheapest sufficient verification yourself before any force-push: test suites, `git log --oneline` span, conflict-marker grep, spot-check the resolved hunks. A rebase that "completes" is not a rebase that's correct.
- **Audit the primary checkout after every delegation that runs git in a shared repo.** Isolation flags are intention, not guarantee — an agent launched with worktree isolation has done its checkout+commit in the user's primary checkout and not mentioned it. After each such delegation: `git worktree list` and `git -C <primary> status --short --branch`. If the primary moved: verify clean, finish anything needing the branch checked out there, restore the original branch. (A colliding `git worktree add` erroring "already checked out at ..." is the tell.) Consider a "never cd out of your worktree" clause in briefs.
- **Two reviewer shapes, both required.** Per-fact content verification cannot catch surface/consistency defects: frontmatter/routing breakage (e.g. YAML truncation at an unquoted '#'), fixes claimed landed but not landed, drift between sibling artefacts retelling the same fact. A delivered set needs whole-set reviewers (doctrine + usability) in addition to per-item fact-checkers.

## 4. Recover / resume

- **Only completed calls journal.** Resume a journaled workflow with an IDENTICAL script — completed `agent()` calls replay free.
- **Don't edit the script to skip a redundant re-run.** Journal cache matching is prefix-shaped; a mid-array edit can invalidate completed siblings worth far more than the redundancy.
- **Approaching a window reset with agents in flight:** stop them, set a background timer, relaunch clean after reset (saved ~350K vs riding into the cap). There is no "stop fan-out at spend threshold" primitive — TaskStop + sleep timer is the workaround.

## When NOT to use

Grounding/verification method for your OWN work → **ground-and-verify**; rebase/branch mechanics you're doing yourself → **branch-and-repo-surgery**; shaping an open design → **open-design-method**; distilling notes into skills → **mentor-distill**; the note-taking practice itself → **mentor**.

## Provenance

| Drawer | Topic |
|---|---|
| 77f7264d8ec | runbook-mandates |
| 80b5f39f25c | fan-out-economics |
| fbea4ffa7dc | negative-claims |
| 0393ef1d916 | git-delegation |
| 898c3e4dad0 | worktree-escape |
| ac04455c930 | survey-gating |
