---
name: public-repo-publishing
description: >-
  Curate work intended for a public repository without leaking private context
  or flooding the public tracker. Use when drafting, reviewing, or publishing
  public issues, pull requests, roadmaps, release notes, contribution guidance,
  or fork-specific integration documentation; when moving work from private
  notes or trackers into GitHub; or when deciding whether a planning artifact
  should be public at all.
---

# Public repository publishing

Treat public repository artifacts as a published corpus, not as disposable
working memory.

## Establish the boundary

Before authoring, identify:

- whether the repository is public;
- whether it is owned, forked, or third-party upstream;
- where private shaping and rationale live;
- whether publication is necessary now.

The concrete location of the private planning store is itself private. Learn
it from project memory, untracked local instruction files, or the user — never
from the public repository. A public signpost (AGENTS.md, CONTRIBUTING.md) may
state that curation happens privately, but must not name the private store's
path, host, or tooling.

Do not create or publish an issue, PR, discussion, or roadmap item without
explicit user authority. A useful private draft does not imply a useful public
artifact.

## Shape privately, publish selectively

Use the owner's established private planning store for exploration, dependency
trees, abandoned alternatives, implementation-specific mappings, and agent
working notes.

Public trackers should contain only material useful to their actual audience.
It is valid to publish none, one, or only the currently actionable part of a
larger private programme.

Preserve stable private identifiers when useful and record published URLs in
the private planning store. Do not make the public repository depend on that
store.

## Make public artifacts self-contained

Before publication, remove or generalize:

- private project and service names unless intentionally public;
- private repository references;
- inaccessible notes, memories, trackers, or documents;
- hostnames, usernames, filesystem paths, device names, and topology;
- credentials, tokens, logs, screenshots, model inventories, and personal data;
- unexplained implementation assumptions belonging to another project.

Replace private implementations with the public interface, capability, or
responsibility they fulfil. The public artifact must remain understandable
without access to private context.

## Curate issues and milestones

Use milestones for outcome-level sequencing and prioritisation. Use issues for
reviewable, actionable units—not every idea discovered during exploration.

An issue should normally state:

- the user-visible problem or capability;
- scope and deliberate exclusions;
- acceptance evidence;
- dependencies that are themselves public;
- relevant repository-local context.

Keep speculative descendants private until they become useful to publish.
Avoid bulk or mechanically generated issue trees.

## Respect repository practice

Read the repository's contribution and security guidance before publishing.

For third-party upstream work:

- use the required target branch and issue-first process;
- keep changes focused;
- avoid submitting agent-generated bulk work;
- include the requested tests, screenshots, or reproduction evidence.

For a public fork:

- preserve licence and attribution requirements;
- mark modifications appropriately;
- keep upstream and fork responsibilities distinguishable;
- ensure network-source obligations and source links are satisfied where
  applicable.

## Publication gate

Before publication, verify:

1. The user has approved publishing this artifact.
2. It is useful now rather than merely complete in the private plan.
3. It contains no inaccessible references or private implementation leakage.
4. It follows the target repository's contribution guidance.
5. Its scope and acceptance criteria are independently understandable.
6. The private publication log can be updated with the resulting URL.

Private reasoning may be richer than the published artifact. Do not erase it
merely because a curated public version now exists.
