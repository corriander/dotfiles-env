---
name: atlas
description: Map of where durable information lives across stores (mempalace, auto-memory, obsidian notes, project docs/ADRs/CONTEXT.md) and the bespoke conventions on top. Use when persisting or recalling.
---

Where durable information tends to live, and how to access it.

## Stores

- **Project docs** — `<repo>/docs/`
- **Module CONTEXT.md** — `<repo>/**/CONTEXT.md`; author at module entry points before non-trivial work, self-reference ADRs
- **ADRs** — `<repo>/docs/adr/` (single bucket); spec at `~/notes/superuser/adr.md`
- **Auto-memory** (per-project, durable) — `~/.claude/projects/<slug>/memory/`, indexed by `MEMORY.md`
- **Personal notes** — `~/notes/<notebook>/`, Obsidian-flavoured md with its own backlink graph. Author only on request via `notes-authoring-agent`. Read/edit via `obsidian-cli` / `obsidian-markdown` / `obsidian-bases`.
- **MemPalace** — MCP `mempalace_*`. Cross-project, cross-session.

## MemPalace — defer to its own tools first

- `mempalace_status` — protocol + AAAK dialect + palace counts
- `mempalace_get_aaak_spec` — dialect detail
- `mempalace_get_taxonomy` — live wing → room map
- Upstream docs at `~/repos/3p/mempalace` for the canonical model (wings, rooms, halls, L0–L3 layers)

## Bespoke conventions (not in mempalace's docs)

- **Wings** — bare `<project>` for our own (canonical form is `wing_<thing>`).
- **Rooms** — `gotchas` (noteworthy-but-not-docs-worthy quirks); `meta` (conventions about a wing itself; see "Recording new patterns" below).
- **Drawers** — file generously, concept-sized: tool specs, decisions, design rationales all belong. Not sentence-sized.
- **Diary** — entries reference drawer IDs rather than duplicating their prose.
- **Layers L0/L1** — unused; placeholder for future-us if cross-session identity ever becomes a real gap.

## Parallel graphs

Two graph layers exist — mempalace KG (structured claims) and Obsidian backlinks across `~/notes/`. Currently uncoordinated; search each in its own surface.

## Skills that touch persistence

- `/recall` — load a prior session handoff (diary + linked drawers)
- `/handoff` — write a session handoff; promote durable bits to drawers
- `notes-authoring-agent` — `~/notes/`, on request only
- Auto-memory writes — per `~/.claude/CLAUDE.md`

## Recording new patterns

When a room convention or cross-store pattern emerges that's worth keeping, offer to update this skill for posterity AND drop a drawer at `wing=<project>, room=meta` so it's grep-able from inside mempalace.
