---
name: implement-issue
description: >
  Implements the approved plan on a GitHub issue, keeps the issue up to date,
  and opens a pull request that closes it. Use when the user asks to implement,
  work on, or complete a GitHub issue.
argument-hint: "[issue number, URL, or requirement ID]"
disable-model-invocation: true
---
# Implement Issue Skill

This skill carries out a plan that stakeholders have reviewed and approved on a
GitHub issue. It does not start unless the plan is approved.

## 1. Prerequisites and resolve the issue

Confirm `gh` is installed and authenticated (`gh auth status`) and determine the
repository (`gh repo view --json nameWithOwner`). Resolve the issue from the
number, URL, or requirement ID as the `plan-issue` skill does (a requirement ID
is matched with `gh issue list --search "[{requirement_id}] in:title"`, and
needs exactly one match). Write bodies to files and use `--body-file`. Report
command failures instead of retrying silently.

```bash
gh issue view {number} --json number,title,body,labels,state,comments,url
```

The issue must be open.

## 2. Check the approval gate

Use the `issue-project` skill to find the issue's project item. Stop if the
issue is not in a project: a product owner or project manager must add it, and
you must not.

Then stop and tell the user to use `plan-issue` unless both are true:

- A comment on the issue contains the `<!-- issue-driven-development:plan -->`
  marker.
- The issue has the `plan-approved` label.

If the label is present but the project status is `Planning`, the plan was
approved by hand in GitHub. Set the status to `Ready` with the `issue-project`
skill and tell the user. If the status is anything other than `Ready` (or
`In Progress`, when resuming), tell the user and ask before continuing.

Then compare timing. Get when the label was applied and when the plan comment
was last edited:

```bash
gh api repos/{repository}/issues/{number}/timeline --paginate
```

If the plan comment's `updated_at` is later than the `labeled` event for
`plan-approved`, the plan changed after it was approved. Stop and ask the user.

Read the comments posted after the approval. If any ask for changes or raise
concerns, stop and summarize them, and suggest revising the plan with
`plan-issue`.

## 3. Create the issue branch

1. Require a clean working tree (`git status --porcelain`). If it is not clean,
   ask the user what to do.
2. If a branch that starts with `{number}-` already exists, switch to it.
3. Otherwise, fetch, and create `{number}-{slug}` from the up-to-date default
   branch, where the slug is the issue title in lowercase words separated by
   hyphens, without the requirement ID prefix.

The plugin's hook only allows edits on a branch like this, so do not edit files
before this step. Once the branch exists, use the `issue-project` skill to set
the status to `In Progress`.

## 4. Implement the plan

Work through the plan's tasks in order, using the issue body, the comments, and
the spec (the `Spec:` line) as context. Stay within the plan.

- Small deviations are fine. Note them for the report.
- If the plan turns out to be wrong or incomplete in a material way, stop,
  explain the problem, and suggest revising it with `plan-issue`, which needs
  another approval. Do not widen the scope on your own.

## 5. Verify

Run the tests, the build, or the application as the plan's verification section
says. A task counts as done only when it has been verified.

## 6. Update the plan comment

Change `- [ ]` to `- [x]` for the tasks that are done and verified, without
rewording any task, and update the comment in place:

```bash
gh api -X PATCH repos/{repository}/issues/comments/{comment_id} -F body=@{file}
```

## 7. Update the PRD

If the issue has a `Spec:` line and the `prd-tracking` skill is available, use
it to check off the acceptance criteria that are met. A pull request will close
the issue, so it should comment on the issue rather than close it.

## 8. Commit

Stage specific files, never `git add -A` or `git add .`. Use the
`conventional-commits` `commit` skill when it is available, and add the footer
`Refs: #{number}`. Otherwise follow the commit style of the project
(`git log -n 10 --format=%s`).

## 9. Open the pull request

Show the user the pull request title and body, and wait for their approval. Then:

```bash
git push -u origin {branch}
gh pr create --repo {repository} --title "{title}" --body-file {file}
```

The body has a summary, the completed tasks, any deviations from the plan, and
how it was verified. End it with `Closes #{number}` when every task is done. If
work remains, use `Refs #{number}` instead and offer to open a draft pull
request (`--draft`).

When the pull request is ready for review, use the `issue-project` skill to
move the issue to `Review`. A draft pull request is not ready for review, so
leave the issue `In Progress`.

## 10. Update the issue and report

Comment on the issue with a summary of what was done, what remains, and a link
to the pull request. Do not close the issue yourself; the pull request closes it
when it is merged. Tell the user what was done, any deviations, and the link.
