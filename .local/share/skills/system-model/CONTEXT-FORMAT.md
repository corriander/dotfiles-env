# CONTEXT.md Format

`CONTEXT.md` describes the **system in focus** at the scope relevant to the current question.

Keep it short. Prefer a tight model over exhaustive documentation.

## Template

```md
# <System Name>

<One or two sentences on what the system is and why it exists.>

## Function

<What the system does, stated plainly.>

## Environment

- **<External actor or system>** — <relationship to this system>

## Interfaces

- **<Interface>** (<direction>, <counterparty>) — <protocol or mechanism>; <guarantees that matter>

## Assumptions

- <Constraint or assumption being held constant>

## Subsystems

- [<Subsystem>](./path/to/CONTEXT.md) — <only if this subsystem warrants its own model>

## Language

**<Canonical term>**:
<What it is.>
_Avoid_: <ambiguous or overloaded alternatives>

## Relationships

- A **<term>** <relates to> one or more **<term>**

## C4 Orientation

<Optional. If useful, describe the nearest C4 reading for this frame. Treat it as a framing aid, not an absolute classification.>

## Views

### <Optional view name>
> <Question this view serves>

## Flagged ambiguities

- <Optional. Record resolved term conflicts or modelling ambiguities worth preserving>
```

## Rules

- Model the system in focus. Do not try to record every possible frame at once.
- Match the decomposition to the question. Decompose only as far as is useful.
- `Environment` means outside the chosen boundary, not "the supersystem".
- Use a nested `CONTEXT.md` when a subsystem needs its own boundary, interfaces, assumptions, and language.
- Use `Views` when the boundary stays the same but the perspective changes.
- `Interfaces` should include the guarantees that matter: direction, protocol, delivery semantics, ordering, idempotency, auth, or similar.
- `Language` is local to this system. Define terms that matter here; omit general software concepts.
- Keep definitions tight. Define what a thing is, not everything it does.
- If multiple words exist for the same concept, pick one canonical term and mark the others to avoid.
- `C4 Orientation` is optional. If used, scope it to the current frame.
- `CONTEXT.md` is not a decision log, ticket, status report, runbook, or agent notebook. Put decisions in ADRs.
