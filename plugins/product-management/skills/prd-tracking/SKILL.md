---
name: prd-tracking
description: >
  Keeps a Product Requirements Document (prd.md) up to date as work is
  completed. Use after implementing, fixing, or verifying work that satisfies a
  PRD requirement, to check off its acceptance criteria and update the matching
  GitHub issue.
---
# PRD Tracking Skill

`prd.md` is the source of truth for what has been built. Use this skill to keep
its acceptance criteria in sync with the work that has actually been completed.

## 1. Find the requirement

1. Locate the PRD. It is `prd.md` in the root of the workspace unless the user
   says otherwise. If there is no PRD, stop and tell the user.
2. Find the requirement the work relates to, by its requirement ID (for example
   `GH-001`) or by its feature name. If more than one requirement could apply,
   or none clearly does, ask the user instead of guessing.

## 2. Check off acceptance criteria

Change `- [ ]` to `- [x]` for a criterion only when all of the following are
true:

- The work that satisfies it is complete.
- You verified it, such as by running the tests or the application, not just by
  writing the code.

Rules:

- Leave criteria that are only partly met, or that you did not verify,
  unchecked. Tell the user what remains.
- Do not reword, add, remove, or reorder criteria while checking them off.
- If the work reveals that a requirement needs to change, do not edit it
  yourself. Describe the change to the user and, if they agree, record it under
  **Open Questions** or **Decisions Log** in the PRD.

## 3. Update the GitHub issue

Do this only if the requirement has a GitHub issue. Issues created from the PRD
have the title format `[{requirement_id}] {user_story}`.

1. Find the issue:

   ```bash
   gh issue list --repo {repository} --state all --search "[{requirement_id}] in:title"
   ```

   If you cannot determine the repository or find exactly one matching issue,
   skip this step and tell the user.

2. If some criteria are still unchecked, add a comment summarizing progress:

   ```bash
   gh issue comment {issue_number} --repo {repository} --body "{progress summary}"
   ```

3. If every criterion for the requirement is checked, close the issue:

   ```bash
   gh issue close {issue_number} --repo {repository} --comment "All acceptance criteria are met."
   ```

Do not reopen or edit issues that the user has closed or changed on their own.

## 4. Report

Tell the user which criteria you checked, which remain, and which issues you
commented on or closed.
