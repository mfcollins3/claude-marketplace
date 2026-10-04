# Product Management Plugin

The Product Management plugin adds tools for developing and managing software
products using Claude Code. It helps you write
[Product Requirements Documents (PRDs)](https://en.wikipedia.org/wiki/Product_requirements_document),
create GitHub Projects for a release, and turn the user stories in a PRD into
GitHub issues on that project.

## What's Included

### Product Requirements Document Command

The `/product-management:prd` command interviews you about a product or
feature, reviews the codebase, and writes a PRD to the `docs/prd/` directory in
your workspace after you approve it. It can then create a GitHub Project for the
release and add one issue per user story.

The PRD is split into files so that it stays manageable as it grows. The index
holds the overview, personas, principles, release plan, non-functional
requirements, open questions, and decisions log, plus a table of the
requirements. Each requirement has its own file, named by its requirement ID:

```text
docs/prd/
  README.md
  features/
    GH-001-user-sign-in.md
    GH-002-password-reset.md
```

To write the PRD somewhere else, say so in your description.

Follow the command with a description of the product or feature:

```text
/product-management:prd A mobile app that lets neighbors share tools
```

The command uses your description as its starting point and only asks about
what is missing. It runs in your main conversation, so you can answer its
questions and request revisions to the draft.

### PRD Tracking Skill

The `prd-tracking` skill keeps the PRD up to date as work is completed. When
Claude finishes and verifies work that satisfies a requirement, the skill
checks off that requirement's acceptance criteria in its feature file and, if
the requirement has a
GitHub issue, comments on the issue or closes it once every criterion is met.
The skill never rewords criteria. Changes to scope are raised with you first.

Claude decides when to use skills, so it may occasionally skip this one. For
reliable behavior, add an instruction like this to the `CLAUDE.md` file of the
project that contains the PRD:

```markdown
## Product requirements

The product requirements are in `docs/prd/`. Read `docs/prd/README.md` for
context, and the feature file in `docs/prd/features/` for the requirement you
are working on. When you complete and verify work that satisfies a requirement,
use the `prd-tracking` skill to check off its acceptance criteria.
```

### PRD Status Skill

The `prd-status` skill reports progress against the PRD: overall completion,
the status of each requirement, the acceptance criteria that remain, and any
open questions. It only reads the PRD and never changes it. Ask Claude "what's
left on the PRD?", or run it directly, optionally with the path to the PRD
directory:

```text
/product-management:prd-status
```

### PRD Revise Skill

The `prd-revise` skill changes a requirement in the PRD, such as its user
story, acceptance criteria, or priority, and updates the matching GitHub issue.
If the feature is renamed, it renames the feature file and updates the index.
It shows you the proposed change before writing anything, asks whether to uncheck
criteria that no longer hold, and records the change in the Decisions Log. Claude
only runs it when you ask:

```text
/product-management:prd-revise GH-003 Allow sign-in with a passkey as well
```

### PRD Split Skill

The `prd-split` skill splits a requirement that is too big into two. The original
requirement keeps its ID, and the second gets the next unused ID. Acceptance
criteria, including ones already checked, are divided between the two, and the
second gets a new feature file. The original GitHub issue is updated, and a new
issue is created in the same GitHub
Project. Claude only runs it when you ask:

```text
/product-management:prd-split GH-003
```

### PRD Move Skill

The `prd-move` skill moves a requirement to a different feature group, or into a
new one, by changing the PRD's index. It asks before removing a group that the
move leaves empty, updates the table of contents, and records the move in the
Decisions Log. The feature file and GitHub issue are unchanged. Claude only runs
it when you ask:

```text
/product-management:prd-move GH-003 Authentication
```

### GitHub Projects Skill

The `github-projects` skill uses the GitHub CLI (`gh`) to:

- Create a GitHub Project
- Link a project to a repository
- Add an issue to a project

### GitHub Issues Skill

The `github-issues` skill uses the GitHub CLI (`gh`) to:

- Create an issue
- Find an issue
- Edit an issue
- Comment on an issue
- Close or reopen an issue

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
