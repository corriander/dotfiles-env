---
name: system-model
description: Grilling session that frames the system under discussion, stress-tests a plan against its boundaries and language, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's system model, interfaces, and documented decisions.
disable-model-invocation: true
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

## What CONTEXT.md is for

`CONTEXT.md` is a lightweight model of the system in focus: its boundary, environment, interfaces, assumptions, internal decomposition, and the language used to describe it precisely.

This skill combines:

- systems thinking, to choose the right boundary and decomposition for the question
- C4, as a practical software modelling vocabulary
- DDD-style language discipline, to keep terms precise and local to the system being discussed

Use `CONTEXT.md` to capture the system model and its language. Do not use it as general project memory, a design spec, a task list, or agent instructions.

## Frame the system first

Before sharpening terminology or debating structure, establish the frame.

A system model is relative to the question being asked.

Choose a boundary around the thing under discussion. Everything outside that boundary is the environment. Everything inside it is a part of the system.

Treat an internal part as a **subsystem** if we may need to model it in its own right. Treat it as a **component** if it is a terminal part for the current discussion.

This is pragmatic, not absolute. The same thing may be a system in one conversation and a subsystem in another.

Example: to an engine manufacturer, a jet engine is a system composed of subsystems and components. To an airframe integrator, that same engine is a propulsion subsystem within the aircraft system. The useful decomposition depends on the question.

Use C4 as the default software vocabulary when it helps:

- **System**: the thing under discussion in its environment
- **Container**: a major internal part; often the closest C4 approximation to a subsystem
- **Component**: a unit part within that frame

Do not force a universal mapping between your system model and C4. If C4 is useful, use it as an orientation aid for the current frame.

Work through these, one at a time:

1. What system are we reasoning about?
2. What question are we trying to answer?
3. Where is the boundary, and what is outside it?
4. What crosses that boundary: interfaces, data, events, control signals, guarantees?
5. What assumptions or constraints are we holding constant?
6. What does the system do?
7. Which internal parts matter for this question?

If `CONTEXT.md` already exists for the system in scope, read it first and anchor the framing in what is already there. Challenge anything that looks stale, contradictory, or mismatched to the question.

## File layout

```text
/
|-- CONTEXT.md
|-- docs/
|   `-- adr/
|       |-- 0001-....md
|       `-- 0002-....md
`-- src/
    `-- <subsystem>/
        |-- CONTEXT.md
        `-- docs/adr/
```

Nested `CONTEXT.md` files describe a subsystem in its own terms, as the system in focus for that scope. A parent may link to its children, but there is no separate map file.

Create files lazily. If no `CONTEXT.md` exists at the scope you need, create one when the framing step has something worth capturing. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the existing model

When the user's plan contradicts `CONTEXT.md`, call it out immediately. Boundary, interface ownership, assumptions, and terminology all count.

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. The right term depends on the system in focus, so frame first, then sharpen language.

### Discuss concrete scenarios

When interfaces, relationships, or guarantees are being discussed, stress-test them with specific scenarios. Use examples that force precision about what crosses the boundary, when, and with what guarantees.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it clearly.

### Update CONTEXT.md inline

When the frame crystallises or a term is resolved, update `CONTEXT.md` right there. Do not batch the updates. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

### Views versus nested CONTEXT.md

Use a **View** when the boundary stays the same but the perspective changes, for example runtime, deployment, data, or failure modes.

Create a nested `CONTEXT.md` when the boundary moves inward and a subsystem becomes the system in focus.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder why it was done this way
3. **The result of a real trade-off** — there were genuine alternatives and one was chosen for specific reasons

If any of the three is missing, skip the ADR.

For ADR format, read `~/notes/superuser/adr.md` and follow it even when it differs from conventions you might know. If that file is not accessible on this machine, stop and tell the user before drafting an ADR rather than guessing.
