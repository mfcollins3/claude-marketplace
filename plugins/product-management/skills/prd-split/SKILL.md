---
name: prd-split
description: >
  Splits a requirement in a Product Requirements Document (the docs/prd/
  directory) that is too big into two requirements, and updates the existing
  GitHub issue and creates a new one so the PRD and GitHub stay in sync. Use
  when the user says a user story is too large.
argument-hint: "[requirement ID] [how to split it]"
disable-model-invocation: true
---
# PRD Split Skill

Use this skill to split one requirement in the PRD into two, and to keep GitHub
in sync. The PRD is the source of truth. It is a directory with an index
(`README.md`) and one file per requirement in `features/`.

The user provided: $ARGUMENTS

## 1. Find the requirement

1. Locate the PRD directory. It is `docs/prd/` in the workspace unless the user
   says otherwise. If there is no PRD, stop and tell the user.
2. Identify the requirement by its ID (for example `GH-001`) or feature name,
   and find its file by matching `features/{ID}-*.md` or by looking it up in the
   index table in `README.md`. If it is unclear, ask the user.

## 2. Propose the split

Propose the split and wait for approval before writing anything. Show:

- **First requirement**: keeps the original ID. Give its feature name, user
  story, acceptance criteria, and priority.
- **Second requirement**: gets the next unused ID. Find it by scanning the PRD
  the index table and the names of the files in `features/` for the highest
  existing ID with the same prefix and adding one. Give its
  feature name, user story, acceptance criteria, and priority.

Rules:

- Every original acceptance criterion goes to exactly one of the two
  requirements. Do not drop criteria. Add a criterion only if the split needs
  one, and say so.
- Criteria that are already checked (`- [x]`) stay checked, and go with the
  requirement they belong to.
- Each half must be a testable user story on its own.
- If the user has said how to split it, follow that. Otherwise suggest a split
  and explain why.

## 3. Update the PRD

After approval:

1. Rewrite the original requirement's feature file as the first requirement. If
   its feature name changed, rename the file to match the new slug (use
   `git mv` if the file is tracked), update its row in the index table, and
   update any other links to the old file name in the PRD directory.
2. Create a feature file for the second requirement at
   `features/{new_requirement_id}-{slug}.md`, using the same format as the
   other feature files.
3. Add the second requirement's row to the index table in `README.md`, directly
   after the original's row, in the same feature group. Update the original's row if its name or priority
   changed. Do not change any other file or renumber anything.
4. Add an entry to the Decisions Log in `README.md` with the date, the split,
   the rationale, and who decided.

## 4. Update GitHub

Do this only if the original requirement has a GitHub issue. Use the
`github-issues` skill and the `github-projects` skill.

1. Find the original issue by requirement ID. If you cannot determine the
   repository or find exactly one issue, skip this section and tell the user.
2. Edit the original issue so its title and body match the first requirement.
3. Create a new issue titled `[{new_requirement_id}] {user_story}`, with the
   second requirement's acceptance criteria in the body, followed by a line
   naming its feature file, for example
   `Spec: docs/prd/features/GH-004-user-sign-in-with-passkey.md`.
4. Find which GitHub Project the original issue is in, as described in the
   `github-issues` skill. That gives you the project's title, which you match to
   a project number. Use the `github-projects` skill to add the new issue to
   that project. If the issue is in no project, skip this step. If you cannot
   tell which project, ask the user.
5. Comment on each issue linking to the other and saying the story was split.
6. If the original issue was closed but the first requirement still has
   unchecked criteria, ask the user before reopening it. If all criteria of the
   first requirement are checked and the second's are not, leave the original
   closed.

## 5. Report

Tell the user what the two requirements are, the PRD changes, and the URLs of
both issues, along with anything you skipped.
