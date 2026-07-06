---
name: atlas
description: Map of where durable information lives across stores (mempalace, auto-memory, obsidian notes, project docs/ADRs/CONTEXT.md) and the bespoke conventions on top. Consult BEFORE using mempalace, filing a memory, or creating a documentation artefact to orientate yourself and align to conventions.
---

Where durable information tends to live, and how to access it.

## Stores

- **Project docs** — `<repo>/docs/`
- **System CONTEXT.md files** — `<repo>/**/CONTEXT.md` are important local context for the project. Simple projects may have one at the repo root, others may be decomposed into nested context files for significant parts. Author at entry points via user-initiated `/system-model` skill before non-trivial work, self-reference ADRs
- **ADRs** — `<repo>/docs/adr/` (single bucket); per-repo conventions in that directory's `README.md` where it exists override similar specs in `~/notes/superuser/adr.md`
- **Personal notes** — `~/notes/<notebook>/`, Obsidian-flavoured md with its own backlink graph. Author only on request via `notes-authoring-agent`. Read/edit via `obsidian-cli` / `obsidian-markdown` / `obsidian-bases`.
- **Auto-memory** - Use your own memory tooling freely to supplement mempalace and aid discovery
- **MemPalace** — MCP `mempalace_*`. Cross-project, cross-session, even cross-tool and agent memories - supplements auto-memory

## Host map (WSL ↔ Windows)

One machine, two environments. WSL is the source of truth; Windows agents (Claude Desktop, Codex, Claude Code) attach to it. Paths above are WSL; equivalents:

- **MemPalace** — *one shared store*. WSL launches it stdio from `~/.mempalace`; Windows agents spawn the *same* binary against the *same* store via `wsl.exe` (`-d ubuntu-25.10 -e … -m mempalace.mcp_server`). Host-agnostic — `/handoff` and `/recall` behave identically either side.
- **Personal notes** — *one vault*. `~/notes` is a symlink resolving to `C:\Users\alexj\notes`, so WSL and Windows see the same Obsidian vault.
- **Skills** — `~/.local/share/skills` is canonical; `sync.sh` symlinks them on WSL and copies them into the Windows `…\.{claude,codex}\skills` dirs (one-way; re-run after edits).
- **Auto-memory** — *separate per host*: `~/.claude/projects/<p>/memory/` (WSL) vs `C:\Users\alexj\.claude\projects\<p>\memory\` (Windows). Not unified.
- **Repo docs / ADRs / CONTEXT.md** — repo-relative; identical from either host.

## Referencing

Only docs committed to repo (general, CONTEXT.md or ADRs) are referencable in docstrings, comments, PRs, Issues, Slack etc.
ADRs may be referenced in docstrings, other documentation should not be - assume the code is authoritative.
Personal notes and memory are ephemeral and generally considered not referencable.

Cross referencing between memories is fine! Personal notes and memory content may *inform* other content but take care with verbatim quotes.

## MemPalace — defer to its own tools first

- `mempalace_status` — protocol + AAAK dialect + palace counts
- `mempalace_get_aaak_spec` — dialect detail
- `mempalace_get_taxonomy` — live wing → room map
- Upstream docs for the canonical model (wings, rooms, halls, L0–L3 layers): a repo checkout MAY exist at `~/repos/3p/mempalace` (machine-dependent — this skill is shared across machines; useful for pulling latest and inspecting history when present). The install itself is a uv tool: source of truth on any machine is `~/.local/share/uv/tools/mempalace/` (site-packages includes the README)

## Bespoke conventions (not in mempalace's docs)

- **Wings** — bare `<project>` for our own (canonical form is `wing_<thing>`).
- **Rooms** — `gotchas` (noteworthy-but-not-docs-worthy quirks); `meta` (conventions about a wing itself; see "Recording new patterns" below).
- **Drawers** — file generously, concept-sized: tool specs, decisions, design rationales all belong. Not sentence-sized.
- **Diary** — entries reference drawer IDs rather than duplicating their prose.
- **Layers L0/L1** — unused; placeholder for future-us if cross-session identity ever becomes a real gap.

## Parallel graphs

Two graph layers exist — mempalace KG (structured claims) and Obsidian backlinks across `~/notes/`. Currently uncoordinated; search each in its own surface.

## Parallel graphs

Three graph layers exist, uncoordinated — search each in its own surface:
- **mempalace KG** — structured claims (`kg_query` / `kg_add`).
- **mempalace navigation graph** (3.3.6+) — hallways (entity co-occurrence *within* a wing) auto-promoting to tunnels (*across* wings), strengthened by Hebbian potentiation and faded by Ebbinghaus decay. Grown automatically at mine time, not hand-authored; traverse via `find_tunnels` / `follow_tunnels` / `traverse`.
- **Obsidian backlinks** — across `~/notes/`, in `~/notes/.obsidian/` its own surface.

## Skills that touch persistence

- `/recall` — load a prior session handoff (diary + linked drawers)
- `/handoff` — write a session handoff; promote durable bits to drawers
- `notes-authoring-agent` — `~/notes/`, on request only
- Auto-memory writes — e.g. per `~/.claude/CLAUDE.md`

## Recording new patterns

When a room convention or cross-store pattern emerges that's worth keeping, offer to update this skill for posterity AND drop a drawer at `wing=<project>, room=meta` so it's grep-able from inside mempalace.
