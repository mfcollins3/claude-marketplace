# Software Architecture Plugin

The Software Architecture plugin adds tools for designing and managing
software architecture directly inside Claude Code. It helps coding agents
capture and maintain architectural knowledge so that it can be referenced in
future sessions and used to guide code generation that is consistent with
past decisions.

## What's Included

### Architectural Decision Record (ADR) Skill

The [`adr`](skills/adr/README.md) skill assists with creating and managing
[Architectural Decision Records](https://adr.github.io), documents that
capture the context, decision, and consequences of significant architectural
choices (for example, why a particular database, cloud provider, or
programming language was chosen).

The skill supports:

* Creating a new ADR to capture an architectural decision.
* Creating a new ADR that extends or supersedes an existing ADR.
* Editing a proposed ADR to revise or clarify its intent.
* Approving a proposed ADR after it has been reviewed and accepted.
* Rejecting a proposed ADR if it is decided not to adopt it.
* Deprecating an accepted ADR when it becomes obsolete.

ADRs produced by the skill follow the
[Markdown Architectural Decision Record (MADR)](https://adr.github.io/adr-templates/#markdown-architectural-decision-records-madr)
template and are stored in the `docs/adrs` directory of your project.

See the [ADR skill documentation](skills/adr/README.md) for more details on
how to use it, including how to reference it from your own `CLAUDE.md` or
`AGENT.md` instructions.

## Installation

This plugin is distributed through the
[`michaelfcollins3` Claude Code marketplace](../../README.md). First add the
marketplace, then install the plugin:

```bash
/plugin marketplace add mfcollins3/claude-marketplace
/plugin install software-architecture@michaelfcollins3
```

## License

This plugin is licensed under the [MIT License](../../LICENSE.md).
