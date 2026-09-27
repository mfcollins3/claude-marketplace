---
name: adr
description: Assists with creating and managing Architectural Decision Records (ADRs) for software projects.
disable-model-invocation: true
---
# Architectural Decision Record Skill

An [Architectural Decision Record](https://adr.github.io/) (ADR) is a document
that captures an important architectural decision made during the development of
a software product. ADRs are used to document the context, decision, and
consequences of architectural decisions, and they serve as a historical record
of the architectural evolution of the product.

## Tasks

1. [Create a new ADR](tasks/create-adr.md)
1. [Edit a proposed ADR](tasks/edit-proposed-adr.md)
1. [Approve a proposed ADR](tasks/approve-proposed-adr.md)
1. [Reject a proposed ADR](tasks/reject-proposed-adr.md)
1. [Deprecate an accepted ADR](tasks/deprecate-accepted-adr.md)

## Interpreting `/adr` Input

When invoked directly via the `/adr` command (e.g., `/adr Create an ADR about
using Microsoft Azure`), the text following the command is free-form input.
Use it to decide which task applies, then follow that task's file:

* **Create** — wording like "create", "write", "add", or "propose" a new
  decision → [Create a new ADR](tasks/create-adr.md). Everything after the
  intent verb describes the decision.
* **Edit** — wording like "edit", "update", "revise", or "change" →
  [Edit a proposed ADR](tasks/edit-proposed-adr.md). The input should
  identify which ADR to edit and describe the change to make.
* **Approve** — wording like "approve" or "accept" →
  [Approve a proposed ADR](tasks/approve-proposed-adr.md). The input should
  identify which ADR to approve.
* **Reject** — wording like "reject" or "decline" →
  [Reject a proposed ADR](tasks/reject-proposed-adr.md). The input should
  identify which ADR to reject and, ideally, why.
* **Deprecate** — wording like "deprecate", "supersede", or "obsolete" →
  [Deprecate an accepted ADR](tasks/deprecate-accepted-adr.md). The input
  should identify which ADR to deprecate and, ideally, why.

If the input doesn't identify which ADR it refers to (for edit, approve,
reject, or deprecate), or doesn't describe what to change or why, ask the
user before proceeding rather than guessing. If `/adr` is invoked with no
input at all, ask the user what they'd like to do.

## Rules

* Unless otherwise specified, all ADRs should follow the
  [provided template](resources/template.md).
* Unless otherwise specified, all ADRs should be placed in the `docs/adrs`
  subdirectory.
* Maintain an index of ADRs and their status in the `docs/adrs/README.md` file.
