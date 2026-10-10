# Issue-Driven Development Plugin

The Issue-Driven Development plugin makes Claude Code work from GitHub issues.
Claude does not change a project without an issue, writes a plan on the issue
so stakeholders can review it, and implements the plan only after it is
approved. It works well with the issues created by the
[Product Management plugin](../product-management/README.md), but works with
any GitHub issue.

## The Workflow

1. **Plan.** Ask Claude for a change, or run `plan-issue`. Claude finds or
   creates the issue, explores the code, drafts a plan, and posts it as a comment
   on the issue with the `plan-proposed` label.
2. **Review.** Stakeholders comment on the issue. Run `plan-issue` again and
   Claude works the feedback into the plan.
3. **Approve.** Someone replaces the `plan-proposed` label with `plan-approved`.
4. **Implement.** Run `implement-issue` with the issue. Claude creates a branch
   named for the issue, carries out the plan, checks off tasks on the plan
   comment, and opens a pull request that closes the issue.

## What's Included

### Plan Issue Skill

The `plan-issue` skill finds the issue (by number, URL, or requirement ID such
as `GH-001`) or drafts a new one for your approval. It writes a plan with a
summary, approach, task checklist, files likely to change, verification,
acceptance criteria mapping, risks, and what is out of scope. You review it in
the conversation before it is posted. It never changes project files. Claude may
use it on its own when you ask for a change:

```text
/issue-driven-development:plan-issue GH-003
```

### Implement Issue Skill

The `implement-issue` skill refuses to start unless the issue has a plan and the
`plan-approved` label, and unless the plan was not edited after it was approved.
It then creates the `{number}-{slug}` branch, implements and verifies the tasks,
updates the plan comment, commits, and opens a pull request with `Closes #N`.
If work remains, the pull request uses `Refs #N` instead. Claude only runs it
when you ask:

```text
/issue-driven-development:implement-issue 3
```

If the plugin finds that the plan is wrong while implementing, it stops and
suggests revising the plan with `plan-issue`.

### Issue Branch Guard

A hook blocks the `Edit`, `Write`, and `NotebookEdit` tools in a Git repository
unless the current branch looks like an issue branch, such as `42-user-sign-in`
or `feature/42-user-sign-in`. The following are always allowed:

- Files outside a Git repository.
- Files under `docs/prd/`, so you can write the PRD before any issue exists.
- Everything, when the `ISSUE_DRIVEN_DEVELOPMENT` environment variable is `off`.
  Set it under `env` in your `settings.json` to opt out.

The guard has limits. It cannot see changes made through Bash, such as
`sed -i` or shell redirection, and it never calls GitHub, so it trusts the branch
name. The skills tell Claude not to work around it.

Install the plugin at project scope (`--scope project`) to enforce the workflow
only in the projects that want it.

### Labels

The skills create these labels in the repository if they are missing:

| Label | Meaning |
| --- | --- |
| `plan-proposed` | A plan is waiting for review. |
| `plan-approved` | The plan was reviewed and approved. |

## Recommended CLAUDE.md

Claude decides when to use skills, so add an instruction like this to the
`CLAUDE.md` file of your project:

```markdown
## Workflow

Do not change the project without a GitHub issue. Use the `plan-issue` skill
to find or create the issue and post a plan to it. Do not implement until the
user runs `implement-issue` on an issue whose plan has the `plan-approved`
label.
```

## Prerequisites

- The [GitHub CLI (`gh`)](https://cli.github.com/) must be installed.
- You must be authenticated with GitHub. Run `gh auth login` to sign in, then
  check with `gh auth status`.
- [`jq`](https://jqlang.org/) must be installed for the guard hook. Without it,
  the hook prints a warning and allows the change.

## Installation

This plugin is distributed through the
[`michaelfcollins3` Claude Code marketplace](../../README.md). First add the
marketplace, then install the plugin:

```bash
/plugin marketplace add mfcollins3/claude-marketplace
/plugin install issue-driven-development@michaelfcollins3
```

## License

This plugin is licensed under the [MIT License](../../LICENSE.md).
