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
