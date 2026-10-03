# Product Management Plugin

The Product Management plugin adds tools for developing and managing software
products using Claude Code. It helps you write
[Product Requirements Documents (PRDs)](https://en.wikipedia.org/wiki/Product_requirements_document),
create GitHub Projects for a release, and turn the user stories in a PRD into
GitHub issues on that project.

## What's Included

### Product Requirements Document Agent

The `prd` agent interviews you about a product or feature, reviews the
codebase, and writes a PRD to `prd.md` in your workspace after you approve it.
It can then create a GitHub Project for the release and add one issue per user
story.

### GitHub Projects Skill

The `github-projects` skill uses the GitHub CLI (`gh`) to:

- Create a GitHub Project
- Link a project to a repository
- Create an issue
- Add an issue to a project

## Prerequisites

- The [GitHub CLI (`gh`)](https://cli.github.com/) must be installed.
- You must be authenticated with GitHub. Run `gh auth login` to sign in, then
  check with `gh auth status`.
- The token must include the `project` scope to create and modify GitHub
  Projects. If it does not, run `gh auth refresh -s project`.

## Installation

This plugin is distributed through the
[`michaelfcollins3` Claude Code marketplace](../../README.md). First add the
marketplace, then install the plugin:

```bash
/plugin marketplace add mfcollins3/claude-marketplace
/plugin install product-management@michaelfcollins3
```

## License

This plugin is licensed under the [MIT License](../../LICENSE.md).
