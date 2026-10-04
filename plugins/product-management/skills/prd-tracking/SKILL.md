---
name: prd-tracking
description: >
  Keeps a Product Requirements Document (the docs/prd/ directory) up to date as
  work is completed. Use after implementing, fixing, or verifying work that
  satisfies a PRD requirement, to check off its acceptance criteria and update
  the matching GitHub issue.
---
# PRD Tracking Skill

The PRD is the source of truth for what has been built. It is a directory with
an index (`README.md`) and one file per requirement in `features/`. Use this
skill to keep each requirement's acceptance criteria in sync with the work that
has actually been completed.

## 1. Find the requirement

1. Locate the PRD directory. It is `docs/prd/` in the workspace unless the user
   says otherwise. If there is no PRD, stop and tell the user.
2. Find the requirement the work relates to, by its requirement ID (for example
   `GH-001`) or by its feature name. Find its file by matching
   `features/{ID}-*.md`, or look the feature up in the index table in
   `README.md`. If more than one requirement could apply, or none clearly does,
   ask the user instead of guessing.

## 2. Check off acceptance criteria

In the requirement's feature file, change `- [ ]` to `- [x]` for a criterion
only when all of the following are
true:

- The work that satisfies it is complete.
- You verified it, such as by running the tests or the application, not just by
  writing the code.

Rules:

- Leave criteria that are only partly met, or that you did not verify,
  unchecked. Tell the user what remains.
- Do not reword, add, remove, or reorder criteria while checking them off.
- If the work reveals that a requirement needs to change or is too big, do not
  edit it yourself. Describe the problem to the user and suggest the `prd-revise`
  or `prd-split` skill. If they would rather not change it now, record it under
  **Open Questions** in the PRD's `README.md`.

## 3. Update the GitHub issue

Do this only if the requirement has a GitHub issue. Issues created from the PRD
have the title format `[{requirement_id}] {user_story}`. Use the `github-issues`
skill.

1. Find the issue by requirement ID. If you cannot determine the repository or
   find exactly one matching issue, skip this step and tell the user.
2. If some criteria are still unchecked, comment on the issue with a summary of
   progress.
3. If every criterion for the requirement is checked, close the issue with the
   comment "All acceptance criteria are met."

Do not reopen or edit issues that the user has closed or changed on their own.

## 4. Report

Tell the user which criteria you checked, which remain, and which issues you
commented on or closed.
