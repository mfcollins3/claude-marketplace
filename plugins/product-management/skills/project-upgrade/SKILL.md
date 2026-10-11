---
name: project-upgrade
description: >
  Adds the Todo, Planning, Ready, In Progress, Review, and Done Status values to
  an existing GitHub Project, keeping its issues' current statuses. Use when the
  user asks to upgrade or update a project's statuses, or when the
  issue-driven-development plugin reports that a project is missing a status.
argument-hint: "[project number] [owner]"
disable-model-invocation: true
---
# Project Upgrade Skill

Projects created by this plugin have the Status values that the
`issue-driven-development` plugin needs. This skill brings an older project, or
one created by hand, up to the same set. It changes only the project's Status
options. It does not add, move, or remove any issues.

## 1. Find the project

Confirm that `gh` is installed and authenticated with `gh auth status`, and that
the token has the `project` scope (otherwise ask the user to run
`gh auth refresh -s project`).

The user may give a project number and owner. Otherwise, use the `github-issues`
skill's steps for finding the projects an issue belongs to, or list the owner's
projects (`gh project list --owner {owner}`) and ask which one. The owner
defaults to the repository's owner.

## 2. Upgrade the Status values

Follow [Set up the Status values](../github-projects/SKILL.md#4-set-up-the-status-values)
in the `github-projects` skill, which shows the user what will change and asks
for approval before it changes anything.

## 3. Report items without a status

Items added to a project by hand, or before it had a `Todo` status, may have no
status. List them:

```bash
gh project item-list {project_number} --owner {owner} --format json --limit 200
```

Show the items whose `status` is empty. Ask whether to set them to `Todo`. Do not
guess for items that are already closed or merged, and leave those alone unless
the user says what to do. Set the status of each approved item with
`gh project item-edit` as described in the `github-projects` skill.

## 4. Report

Tell the user the project's statuses now, any options that were kept but are not
one of the six, and the one-time setup the `issue-driven-development` plugin
needs for `Done`: in the project's **Workflows**, enable **Item closed** and set
its status to `Done`.
