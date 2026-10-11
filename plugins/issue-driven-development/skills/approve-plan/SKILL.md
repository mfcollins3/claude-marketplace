---
name: approve-plan
description: >
  Records that the plan on a GitHub issue has been reviewed and approved, by
  swapping the plan-proposed label for plan-approved and moving the issue to the
  Ready status. Use when the user says the plan for an issue is approved.
argument-hint: "[issue number, URL, or requirement ID]"
disable-model-invocation: true
---
# Approve Plan Skill

Approval is a decision by the people who reviewed the plan. This skill only
records it when the user says it has been made; never run it on your own.
Someone may also approve a plan by hand in GitHub by changing the label. In that
case the `implement-issue` skill moves the issue to `Ready` itself.

## 1. Prerequisites and resolve the issue

Confirm `gh` is installed and authenticated and determine the repository, then
resolve the issue as the `plan-issue` skill does. The issue must be open.

## 2. Check the plan and project

- A comment containing the `<!-- issue-driven-development:plan -->` marker must
  exist. If not, tell the user to use `plan-issue`.
- Use the `issue-project` skill to find the issue's project item. Stop if it is
  not in a project. The status should be `Planning`; if it is anything else,
  tell the user and ask before continuing.
- Read the comments posted after the plan. If any ask for changes that are not
  reflected in the plan, show them to the user and ask whether to approve anyway.

## 3. Approve

1. Swap the labels:

   ```bash
   gh issue edit {number} --repo {repository} --remove-label plan-proposed --add-label plan-approved
   ```

   Create `plan-approved` first if it does not exist (see `plan-issue`).
2. Use the `issue-project` skill to set the status to `Ready`.
3. Comment on the issue that the plan was approved, naming the approver if the
   user tells you who it is.

## 4. Report

Tell the user the issue is ready, and that
`/issue-driven-development:implement-issue {number}` starts the work.
