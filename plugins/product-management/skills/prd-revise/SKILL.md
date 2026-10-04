---
name: prd-revise
description: >
  Revises a requirement in a Product Requirements Document (the docs/prd/
  directory) and updates the matching GitHub issue so both stay in sync. Use
  when the user wants to change a user story, its acceptance criteria,
  priority, or notes.
argument-hint: "[requirement ID] [what should change]"
disable-model-invocation: true
---
# PRD Revise Skill

Use this skill to change an existing requirement in the PRD and keep its GitHub
issue in sync. The PRD is the source of truth. It is a directory with an index
(`README.md`) and one file per requirement in `features/`. Do not use this
skill to check off criteria; use `prd-tracking` for that.

The user provided: $ARGUMENTS

## 1. Find the requirement

1. Locate the PRD directory. It is `docs/prd/` in the workspace unless the user
   says otherwise. If there is no PRD, stop and tell the user.
2. Identify the requirement by its ID (for example `GH-001`) or feature name,
   and find its file by matching `features/{ID}-*.md` or by looking it up in the
   index table in `README.md`. If it is unclear or more than one could apply,
   ask the user.
3. If the user has not said what should change, ask.

## 2. Propose the change

Show the user the requirement as it is now and as it would be after the
revision, then wait for approval before writing anything. Also tell the user:

- Which criteria are already checked (`- [x]`) and would no longer be accurate
  after the change. Ask whether to uncheck them. Never leave a criterion checked
  if the revision means it no longer holds.
- Whether the revision affects other requirements, such as dependencies or
  Out of Scope items.
- Any text elsewhere in the PRD that describes the old behavior, such as the
  overview, Open Questions, or the Decisions Log. Search `README.md` and the
  other feature files for it. List each place, and ask whether to update it.
  Never leave it unmentioned, but do not change it without approval.

Keep the requirement ID unchanged.

## 3. Update the PRD

After approval:

1. Edit only the requirement's feature file. Do not reword anything else.
2. If the feature's name changed, rename the file to match the new slug (use
   `git mv` if the file is tracked, or `mv` if `git mv` is not available), and
   update the feature's row in the index
   table in `README.md` so its text and link match. Also search the PRD
   directory for other links to the old file name and update them. If the
   priority changed, update the row's priority too.
3. Add an entry to the Decisions Log in `README.md` with the date, what
   changed, the rationale, and who decided.

## 4. Update the GitHub issue

Do this only if the requirement has a GitHub issue. Use the `github-issues`
skill.

1. Find the issue by requirement ID. If you cannot determine the repository or
   find exactly one issue, skip this step and tell the user.
2. Edit the issue so its title is `[{requirement_id}] {user_story}` and its body
   matches the revised acceptance criteria.
3. Add a comment saying what changed and why.
4. If the issue is closed and the revision adds unmet criteria, ask the user
   before reopening it.

## 5. Report

Tell the user what changed in the PRD, which issue was updated, any text
elsewhere in the PRD that still describes the old behavior, and anything you
skipped.
