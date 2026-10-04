---
name: prd-move
description: >
  Moves a requirement in a Product Requirements Document (the docs/prd/
  directory) from one feature group to another, or into a new group. Use when
  the user wants to regroup a requirement. Only the index changes; the feature
  file and GitHub issue stay as they are.
argument-hint: "[requirement ID] [target group]"
disable-model-invocation: true
---
# PRD Move Skill

Use this skill to move a requirement to a different feature group in the PRD.
Groups are the `### 5.N` headings in section 5 of `docs/prd/README.md`, each
with a table of requirements. Moving a requirement only changes the index. The
requirement's feature file, its ID, and its GitHub issue do not change. To
change what a requirement says, use `prd-revise`.

The user provided: $ARGUMENTS

## 1. Find the requirement and the target group

1. Locate the PRD directory. It is `docs/prd/` in the workspace unless the user
   says otherwise. If there is no PRD, stop and tell the user.
2. Identify the requirement by its ID (for example `GH-001`) or feature name,
   by looking it up in the group tables in `README.md`. If it is unclear, ask
   the user.
3. Identify the target group, which is an existing group or a new one the user
   names. If the user has not said, ask. If the requirement is already in the
   target group, stop and tell the user.

## 2. Propose the change

Show the user what will change, then wait for approval before writing anything:

- The requirement's current group and the target group, and whether the target
  is new. A new group is numbered after the last existing group.
- If the move leaves the current group empty, that the group would be removed
  and the groups after it renumbered. Ask whether to remove it or keep it
  empty.

## 3. Update the PRD

After approval, change only `README.md`:

1. Remove the requirement's row from its current group's table. Keep the row's
   text, link, and priority exactly as they are.
2. Add the row to the target group's table, in ID order. For a new group, add a
   `### 5.N {group name}` heading with a table that has the same columns as the
   other groups.
3. If a group was added or removed, renumber the headings of the groups after
   it. Then update the table of contents so there is one entry per group, and
   each entry's link text and anchor match its heading (for example
   `### 5.2 Accounts` is `#52-accounts`).
4. Add an entry to the Decisions Log with the date, the move, the rationale, and
   who decided.

Do not edit the feature file, and do not rename or move any file.

## 4. GitHub

Do nothing. Issues are found by requirement ID, and the feature file path in
their bodies does not change.

## 5. Report

Tell the user which requirement moved, from which group to which, and any group
that was added, removed, or renumbered.
