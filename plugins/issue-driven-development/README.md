# Issue-Driven Development Plugin

The Issue-Driven Development plugin makes Claude Code work from GitHub issues.
Claude does not change a project without an issue, writes a plan on the issue
so stakeholders can review it, and implements the plan only after it is
approved. It works well with the issues created by the
[Product Management plugin](../product-management/README.md), but works with
any GitHub issue.

## The Workflow

Work is tracked by the issue's **Status** in a GitHub Project. The issue must
already be in a project: a product owner or project manager decides what is in
scope, so no skill in this plugin creates issues or adds them to a project.

| Step | What happens | Status |
| --- | --- | --- |
| Created | A product owner adds the issue to the project. | `Todo` |
| 1. Plan | Run `plan-issue`. Claude explores the code, drafts a plan, and posts it as a comment on the issue with the `plan-proposed` label. | `Planning` |
| 2. Review | Stakeholders comment on the issue. Run `plan-issue` again and Claude works the feedback into the plan. | `Planning` |
| 3. Approve | Run `approve-plan`, or replace `plan-proposed` with `plan-approved` by hand. | `Ready` |
| 4. Implement | Run `implement-issue`. Claude creates a branch named for the issue and carries out the plan, checking off tasks on the plan comment. | `In Progress` |
| 5. Review | Claude opens a pull request that closes the issue. | `Review` |
| 6. Merge | The pull request is merged and GitHub closes the issue. | `Done` |

## What's Included

### Plan Issue Skill

The `plan-issue` skill finds the issue (by number, URL, or requirement ID such
as `GH-001`). It never creates one. It puts Claude in plan mode so exploration
is read-only, then writes a plan with a summary, approach, task checklist, files
likely to change, verification, acceptance criteria mapping, risks, and what is
out of scope. You approve the plan with plan mode's normal prompt, which here
only means "post it to the issue"; Claude does not start implementing. If you
already made a plan with `/plan`, the skill uses that plan instead of starting
over. It never changes project files. Claude may use it on its own when you ask
for a change:

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

### Approve Plan Skill

The `approve-plan` skill records that the plan was reviewed and approved. It
swaps `plan-proposed` for `plan-approved`, moves the issue to `Ready`, and
comments on the issue. Only the user can run it.

```text
/issue-driven-development:approve-plan 3
```

### Project Statuses

The project that tracks the issue must have a **Status** field with these
values: `Todo`, `Planning`, `Ready`, `In Progress`, `Review`, and `Done`. The
skills stop with a message if the issue is not in a project, or the project is
missing a value. Projects created by the Product Management plugin have them. For
an existing project, run `/product-management:project-upgrade`.

The skills never move an issue to `Done`. Turn on the project's built-in
workflow for this: open the project, choose **Workflows**, enable **Item
closed**, and set its status to `Done`. GitHub closes the issue when a pull
request with `Closes #N` is merged, and the workflow does the rest. A pull
request that is closed without merging leaves the issue open in `Review`, so
move it back by hand.

### Labels

The skills create these labels in the repository if they are missing:

| Label | Meaning |
| --- | --- |
| `plan-proposed` | A plan is waiting for review. |
| `plan-approved` | The plan was reviewed and approved. |

The label is the record of approval: its timestamp is how `implement-issue`
detects a plan that was edited after it was approved. The status follows it.

## Recommended CLAUDE.md

Claude decides when to use skills, so add an instruction like this to the
`CLAUDE.md` file of your project:

```markdown
## Workflow

Do not change the project without a GitHub issue. Use the `plan-issue` skill
to find the issue, which must be in a GitHub Project, and post a plan to it.
Never create issues or add them to a project. When a plan made with `/plan` is
approved, do not implement it: post it to the issue with `plan-issue` first.
Do not implement until the user runs `implement-issue` on an issue whose plan
has the `plan-approved` label.
```

## Prerequisites

- The [GitHub CLI (`gh`)](https://cli.github.com/) must be installed.
- You must be authenticated with GitHub. Run `gh auth login` to sign in, then
  check with `gh auth status`.
- The token needs the `project` scope to change an issue's status. If it does
  not have it, run `gh auth refresh -s project`.
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
