# Conventional Commits Plugin

The Conventional Commits plugin helps Claude Code write Git commit messages that
follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification, with a short header and a wrapped, readable body.

## What's Included

### Commit Skill

The [`commit`](skills/commit/README.md) skill writes the commit message for the
staged changes and commits them. Messages it writes have:

* a header of 52 characters or fewer, in the form `type(scope): description`,
  with an imperative, lowercase description;
* a first-person, past-tense body wrapped at 72 characters;
* scopes taken from your project's `CLAUDE.md` or `CONTRIBUTING` file.

### Validation Hook

A hook checks every `git commit -F <file>` that Claude runs, and blocks the
commit with an explanation when the message breaks these rules. See the
[skill documentation](skills/commit/README.md) for details and for how to
define your project's scopes.

## Installation

This plugin is distributed through the
[`michaelfcollins3` Claude Code marketplace](../../README.md). First add the
marketplace, then install the plugin:

```bash
/plugin marketplace add mfcollins3/claude-marketplace
/plugin install conventional-commits@michaelfcollins3
```

## License

This plugin is licensed under the [MIT License](../../LICENSE.md).
