---
name: github-issues
description: >
  Creates, finds, edits, comments on, closes, and reopens GitHub issues using
  the GitHub CLI (gh). Use when the user asks to create or update a GitHub issue,
  or when another skill needs to keep an issue in sync with a PRD requirement.
  To add an issue to a GitHub Project, use the github-projects skill.
---
# GitHub Issues Skill

This skill manages GitHub issues with the `gh` CLI through the Bash tool. The
following features are supported:

1. [Create an issue](#1-create-an-issue)
2. [Find an issue](#2-find-an-issue)
3. [Edit an issue](#3-edit-an-issue)
4. [Comment on an issue](#4-comment-on-an-issue)
5. [Close or reopen an issue](#5-close-or-reopen-an-issue)

Before running any command, confirm that `gh` is installed and authenticated
with `gh auth status`. If it is not authenticated, ask the user to run
`gh auth login` themselves.

Every command needs the repository in the format `owner/repo`. If the user did
not specify it, try to determine it from the codebase, and ask if you cannot.

Write issue bodies to a temporary file, or pipe them on stdin, so that Markdown
and special characters are passed through unchanged.

## 1. Create an issue

Provide the repository, a title, and a body such as acceptance criteria:

```bash
gh issue create --repo {repository} --title "{title}" --body-file -
```

The command prints the URL of the new issue.

## 2. Find an issue

To find an issue by a requirement ID in its title:

```bash
gh issue list --repo {repository} --state all --search "[{requirement_id}] in:title" --json number,title,state,url
```

Use exactly one match. If there are none, or more than one, do not guess. Report
it to the user.

To see the GitHub Projects an issue belongs to:

```bash
gh issue view {issue_number} --repo {repository} --json projectItems
```

Each item has only the project's `title` and the issue's `status`. It does not
include the project number or owner. To get the number, which other commands
need, list the owner's projects and match on the title:

```bash
gh project list --owner {owner} --format json
```

Use the repository's owner unless the user says the project belongs to someone
else. If no project or more than one project has that title, ask the user which
one to use.

## 3. Edit an issue

Replace the title, the body, or both:

```bash
gh issue edit {issue_number} --repo {repository} --title "{title}" --body-file -
```

Editing replaces the whole body, so start from the issue's current body
(`gh issue view {issue_number} --repo {repository} --json body`) if only part of
it should change. Do not edit an issue's title or body when the user has not
asked for that.

## 4. Comment on an issue

```bash
gh issue comment {issue_number} --repo {repository} --body "{comment}"
```

## 5. Close or reopen an issue

```bash
gh issue close {issue_number} --repo {repository} --comment "{reason}"
gh issue reopen {issue_number} --repo {repository} --comment "{reason}"
```

Do not close or reopen an issue that the user did not ask you to, or that
another skill's instructions do not tell you to. Ask first if the issue's state
was changed by someone else.

## Errors

Check each command's exit status. If a command fails, report the issue number or
URL and the error to the user rather than retrying silently.
