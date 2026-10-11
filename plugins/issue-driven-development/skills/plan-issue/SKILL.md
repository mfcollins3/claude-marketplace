---
name: plan-issue
description: >
  Plans work on a GitHub issue and posts the plan to the issue as a comment so
  stakeholders can review it before any change is made. Use whenever the user
  asks for a change to the project and there is no approved plan, when the user
  asks to plan or re-plan an issue, or to find the issue for the work.
argument-hint: "[issue number, URL, or requirement ID | description of the work]"
---
# Plan Issue Skill

Every change to the project starts with a GitHub issue that is in a GitHub
Project, and a plan that stakeholders have reviewed. This skill finds the issue,
writes the plan, and posts it to the issue. It never changes project files, and
it never creates issues or adds them to a project, because what is in scope is
decided by the product owner or project manager. The `approve-plan` and
`implement-issue` skills take over once the plan is reviewed.

## 1. Prerequisites

Confirm that `gh` is installed and authenticated with `gh auth status`. If it
is not, ask the user to run `gh auth login` themselves. Get the repository with
`gh repo view --json nameWithOwner`; if it cannot be determined, ask.

Write issue and comment bodies to a temporary file and pass `--body-file`, so
that Markdown passes through unchanged. Check every command's exit status and
report failures instead of retrying silently.

## 2. Resolve the issue

The user may give an issue number, an issue URL, a requirement ID such as
`GH-001`, or only a description of the work.

- For a requirement ID, run
  `gh issue list --search "[{requirement_id}] in:title" --state all --json number,title,state,url`
  and use exactly one match. If there are none or several, ask the user.
- For a description, search for an existing issue first
  (`gh issue list --search "{keywords}" --json number,title,state,url`) and
  show the user any likely matches.
- If there is no issue, stop. Tell the user that a product owner or project
  manager must create it and add it to the project first. You may offer a
  suggested title and description for them to pass along, but do not create it.

If the issue is closed, tell the user and ask before continuing.

Then use the `issue-project` skill to find the issue's project item. If the
issue is not in a project, stop and tell the user a product owner or project
manager must add it. Do not add it yourself.

## 3. Move the issue to Planning

When the project status is `Todo`, use the `issue-project` skill to set it to
`Planning` now, since planning has begun. If it is already `Planning`, leave it.
If it is `Ready` or `In Progress`, the user is revising an existing plan, which
section 9 covers. If it is `Review` or `Done`, ask the user before continuing.

## 4. Enter plan mode

Plan mode makes planning read-only, so the plan is made without changing
anything.

- **Already in plan mode:** continue in it.
- **The user already made a plan with `/plan`:** do not plan again. Read the
  plan file (the most recent file in `~/.claude/plans/`, confirming with the user
  that it is the right one), use it as the draft, and skip to section 6 to put
  it into the template. Check it against the issue as in section 5.
- **Otherwise:** call `EnterPlanMode`. If the user declines, continue without
  it, and make no file edits.

While in plan mode, write the plan to the plan file in the format of section 6,
so that it can be posted to the issue as it is.

## 5. Gather context (read-only)

```bash
gh issue view {number} --json number,title,body,labels,state,comments,url
```

If the body has a `Spec:` line, read the feature file it names and
`docs/prd/README.md`. Explore the codebase to understand what needs to change.
Do not edit any project files during planning.

## 6. Draft the plan

Write the plan from [resources/plan-template.md](resources/plan-template.md).
Keep the first line, the `<!-- issue-driven-development:plan -->` marker, since
other skills use it to find the plan. Fill in every section, or remove the
acceptance criteria mapping if the issue has no spec. Tasks are a `- [ ]`
checklist ordered by dependency, and each should be small enough to verify.

## 7. Get the user's approval

In plan mode, finish with `ExitPlanMode`, which shows the plan to the user.
Otherwise show the draft in the chat. Revise it until the user is happy. Do not
post it before then.

The user's approval here is permission to **post the plan to the issue**. It is
not permission to implement it, even though plan mode normally treats approval
that way: stakeholders have not reviewed the plan yet. After the user approves,
go straight to section 8, and do not start any of the plan's tasks. The plugin's
hook blocks file changes on a branch that is not an issue branch, but do not rely
on it.

## 8. Post the plan

If no comment on the issue contains the marker:

1. Make sure the labels exist, and create any that are missing:

   ```bash
   gh label list --repo {repository} --search plan --json name
   gh label create plan-proposed --repo {repository} --color FBCA04 --description "A plan is waiting for review"
   gh label create plan-approved --repo {repository} --color 0E8A16 --description "The plan has been reviewed and approved"
   ```

2. Post the plan as a comment, not in the issue body, because the body may be
   rewritten by other skills:

   ```bash
   gh issue comment {number} --repo {repository} --body-file {file}
   ```

3. Add the label: `gh issue edit {number} --repo {repository} --add-label plan-proposed`.

## 9. Revise an existing plan

If a comment with the marker already exists, enter plan mode as in section 4,
then:

1. Read the comments posted after it and work their feedback into the plan.
   Ask the user about feedback that is unclear or conflicting.
2. Show the user the revised plan, with `ExitPlanMode` as in section 7.
3. Update the plan comment in place. Find its ID in the issue's comments
   (`gh api repos/{repository}/issues/{number}/comments`), then:

   ```bash
   gh api -X PATCH repos/{repository}/issues/comments/{comment_id} -F body=@{file}
   ```

4. Post a short comment saying which feedback was addressed.
5. If the issue has `plan-approved` and the change is material, ask the user
   before removing it and adding `plan-proposed`, since the plan needs another
   review. If they agree, also use the `issue-project` skill to move the issue
   back to `Planning`.

## 10. Report

Give the user the link to the plan comment and the next steps: stakeholders
review the plan on the issue, then the user runs
`/issue-driven-development:approve-plan {number}` (or someone replaces
`plan-proposed` with `plan-approved` by hand), and then
`/issue-driven-development:implement-issue {number}`.
