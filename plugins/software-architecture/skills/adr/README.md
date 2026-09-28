# Architectural Decision Record Skill

## About Architectural Decision Records

[Architectural Decision Records](https://adr.github.io), or ADRs, are documents
that capture significant design and architectural decisions that affect the
evolution of a software project or product. Architectural decision records can
capture why a specific programming language was chosen, or why the developers
chose [PostgreSQL](https://www.postgresql.org) over
[MongoDB](https://www.mongodb.com) for persisting data, or why the application
is being hosted in [Azure](https://azure.microsoft.com) instead of
[AWS](https://aws.amazon.com).

In the age of AI coding agents, Architectural Decision Records can be helpful
in providing context and knowledge to the coding agents and LLMs to help
understand what patterns and practices are being used by the software product.
This can help to improve the outcome of coding prompts by ensuring that
generated code follows established practices and conforms to past decisions.

## About the ADR Skill

The `adr` skill was created to help AI coding agents and LLMs to produce ADRs
and capture important architectural decisions during coding sessions. The `adr`
skill provides several important activities to guide the coding agents in
writing, managing, and maintaining ADRs.

Architectural Decision Records produced by this skill output ADRs using the
[Markdown Architectural Decision Record (MADR)](https://adr.github.io/adr-templates/#markdown-architectural-decision-records-madr)
template.

The `adr` skill supports the following use cases:

* Creating a new ADR to capture an architectural decision.
* Creating a new ADR that extends or supersedes an existing ADR.
* Editing an ADR to revise or clarify the intent of the ADR, or to include new
  information captured in a subsequent agent session.
* Approving an ADR after it has been reviewed and accepted.
* Rejecting an ADR if it is decided not to adopt it.
* Deprecating an ADR when the ADR becomes obsolete.

## How to Use the ADR Skill

The ADR skill can be invoked as necessary in coding agents to create an
architectural decision record, but the recommended way to use the skill is to
reference the skill in your agent's instructions (e.g., `AGENT.md` or
  `CLAUDE.md`).

For example, you can add the following block to your agent instructions file:

```markdown
## Architectural Decision Records

* Capture important architectural decisions as
  [Architectural Decision Records](https://adr.github.io).
* Use the `adr` skill to write the Architectural Decision Record document.
```

The skill can also be invoked directly with the `/adr` command, followed by
free-form text describing what you want to do. The wording you use determines
which task the skill performs.

## Examples

### Creating a new ADR

```plain
/adr Create an ADR about using PostgreSQL instead of MongoDB for persisting
order data, since we need strong transactional guarantees across orders and
inventory.
```

This drafts a new `docs/adrs/draft-postgresql-for-order-data.md` file in the
`proposed` state, using the [template](resources/template.md), and adds it to
the `docs/adrs/README.md` index. The skill will ask follow-up questions if it
needs more detail, such as who the decision-makers are or what other options
were considered.

### Editing a proposed ADR

```plain
/adr Edit the PostgreSQL ADR to add read replicas as a considered option.
```

This updates the matching `proposed` ADR in `docs/adrs`, refreshing its `date`
field and adding the new option. If the skill can't tell which ADR you mean,
it will ask you to clarify (e.g., by number or title).

### Approving a proposed ADR

```plain
/adr Approve ADR "PostgreSQL for order data"
```

This moves the ADR from `proposed` to `accepted`, assigns it the next
available ADR number, renames it from `draft-{title}.md` to `{number}-{title}.md`,
and updates the `docs/adrs/README.md` index accordingly.

### Rejecting a proposed ADR

```plain
/adr Reject ADR-0004, we decided to stick with MongoDB for now because the
migration cost outweighs the benefit this quarter.
```

This sets the ADR's status to `rejected`, records the reason, renames it to
`rejected-{title}.md`, and updates the index.

### Deprecating an accepted ADR

```plain
/adr Deprecate ADR-0002 since ADR-0007 supersedes it with a new caching
strategy.
```

This sets the accepted ADR's status to `deprecated`, records why, and updates
the index. Use the "Create" task instead (with a note that it supersedes an
existing ADR) when the new decision should also mark the old one as
superseded rather than merely deprecated.
