---
name: github-projects
description: >
  Creates GitHub Projects, links them to repositories, and adds GitHub issues
  to them using the GitHub CLI (gh). Use when the user asks to create a GitHub
  project, track a release or roadmap in GitHub Projects, or create issues for
  user stories and add them to a project.
---
# GitHub Projects Skill

This skill manages GitHub Projects with the `gh` CLI through the Bash tool. The
following features are supported:

1. [Create a new GitHub Project](#1-create-a-new-github-project)
2. [Link a GitHub Project to a repository](#2-link-a-github-project-to-a-repository)
3. [Create an issue](#3-create-an-issue)
4. [Add an issue to a GitHub Project](#4-add-an-issue-to-a-github-project)

Before running any command, confirm that `gh` is installed and authenticated
with `gh auth status`. If it is not authenticated, ask the user to run
`gh auth login` themselves.

## 1. Create a new GitHub Project

To create a new GitHub Project, provide the following information:

- **Project Title**: The title of the project
- **Owner**: The GitHub user or organization that will own the project. If not
  specified, the default value of `@me` will be used, which refers to the
  authenticated user.

To create the project, run the following command:

```bash
gh project create --format json --owner {owner} --title "{project_title}"
```

The output is JSON. The `number` field is the project number used in later
commands, and the `url` field is the project URL.

If the output cannot be parsed, run `gh project list --owner {owner}` to check
whether the project was created before trying again, so that a duplicate
project is not created.

## 2. Link a GitHub Project to a repository

To link a GitHub Project to a repository, provide the following information:

- **Project Number**: The number of the project you want to link.
- **Owner**: The owner of the project.
- **Repository**: The name of the repository to link the project to, in the
  format `owner/repo`.

To link the project to the repository, run the following command:

```bash
gh project link {project_number} --owner {owner} --repo {repository}
```

## 3. Create an issue

To create an issue, provide the following information:

- **Repository**: The repository to create the issue in, in the format
  `owner/repo`.
- **Title**: The issue title.
- **Body**: The issue body, such as acceptance criteria.

Write the body to a temporary file, or pipe it on stdin, so that Markdown and
special characters are passed through unchanged. Then run:

```bash
gh issue create --repo {repository} --title "{title}" --body-file -
```

The command prints the URL of the new issue.

## 4. Add an issue to a GitHub Project

To add an existing issue to a project, provide the following information:

- **Project Number**: The number of the project.
- **Owner**: The owner of the project.
- **Issue URL**: The URL returned when the issue was created.

To add the issue, run the following command:

```bash
gh project item-add {project_number} --owner {owner} --url {issue_url}
```

Add issues one at a time, and check each command's exit status. If an add fails,
report the issue URL and error to the user rather than retrying silently.
