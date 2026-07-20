---
name: codex
description: Delegate coding tasks to the OpenAI Codex CLI (codex exec) so Claude can orchestrate while Codex does the implementation grunt work. Use whenever the user says "codex", "delegate/offload this", "have codex do it", "farm this out", or asks to conserve Claude quota by running a subtask on an OpenAI model. Covers model selection (gpt-5.6-sol/terra/luna, gpt-5.5) and reasoning-effort defaults.
---

# Codex delegation

Run coding subtasks on the OpenAI Codex CLI non-interactively via `codex exec`, keeping Claude as the orchestrator: Claude scopes the task, Codex implements, Claude reviews the result.

## Models and effort defaults

Always pass `-m` and `-c model_reasoning_effort=...` explicitly — don't rely on `~/.codex/config.toml`, which may drift.

| Model | Character | Default effort |
|-------|-----------|----------------|
| `gpt-5.6-sol` | Latest frontier agentic coding model. **Default choice.** | `medium` |
| `gpt-5.6-terra` | Balanced everyday agentic coding | `medium` |
| `gpt-5.6-luna` | Fast and affordable; quick mechanical tasks | `medium` |
| `gpt-5.5` | Frontier for complex coding/research | `high` |

Why: the 5.6 family is not as cheap in practice as pitched, so hold it at `medium` unless the user asks for more. `gpt-5.5` is extremely cheap even at `high`/`xhigh`, so effort is free to crank — use `xhigh` for hard debugging or research-shaped tasks when latency is acceptable. All of this is user-overridable; if the user names a model or effort, use it without debate.

Selection heuristic when the user doesn't specify: default `gpt-5.6-sol`; drop to `gpt-5.6-luna` for small mechanical edits (renames, boilerplate, test scaffolding); reach for `gpt-5.5` at high/xhigh when the task is deep (gnarly bug, algorithm, research) and you'd rather spend time than money.

## Invocation

```sh
codex exec \
  -m gpt-5.6-sol -c model_reasoning_effort="medium" \
  -s workspace-write \
  -C /path/to/project \
  -o /tmp/codex-last-message.md \
  "<self-contained task prompt>" </dev/null
```

- **Always end the invocation with `</dev/null`.** When stdin is a pipe (which it always is from a tool harness), `codex exec` prints "Reading additional input from stdin..." and blocks reading it *before opening a session* — a run without this can hang forever having done nothing: no session file, no API usage, empty output. Learned the hard way (30-minute ghost run, 2026-07-18).
- **Watchdog every backgrounded run**: within a minute of launch, confirm a new rollout file appeared under `~/.codex/sessions/YYYY/MM/DD/`. No session file + zero-byte output = ghost run; kill and relaunch (or implement inline) instead of waiting. User-side corroboration: Codex quota not moving means nothing is running.
- Long prompts: write the brief to a file and pass `"$(cat brief.txt)"` — avoids shell-quoting hazards and keeps the brief reusable for a relaunch.
- `-s read-only` for review/analysis tasks; `workspace-write` when Codex should edit files. Never use the `--dangerously-*` flags.
- `-o <file>` captures Codex's final message — read it afterwards instead of parsing the full transcript.
- `--skip-git-repo-check` if the target directory isn't a git repo.
- Long tasks: run in the background and check the `-o` file when it exits.
- If other work is happening in the same checkout concurrently, fence it: list the files Codex must not touch in the brief.
- Follow-ups in the same Codex session: `codex exec resume --last "<follow-up>"`.

## Writing the task prompt

Codex shares none of Claude's conversation context. Make the prompt self-contained: concrete file paths, the expected behaviour or acceptance criteria, and any constraints (e.g. "don't touch the public API", "match existing test style"). A good delegation prompt reads like a small ticket, not a chat message.

Example:

```sh
codex exec -m gpt-5.6-luna -c model_reasoning_effort="medium" -s workspace-write \
  -C ~/repos/example-app -o /tmp/codex-last-message.md \
  "In src/utils/dates.ts, add a formatRelative(date: Date): string helper that returns '3 days ago' style strings. Add unit tests alongside the existing ones in src/utils/dates.test.ts and run the test suite to confirm they pass."
```

## After the run

Read the `-o` file and skim `git diff` in the target repo. Claude stays responsible for the result: verify the change does what was asked before reporting back, and report Codex's outcome faithfully (including failures).
