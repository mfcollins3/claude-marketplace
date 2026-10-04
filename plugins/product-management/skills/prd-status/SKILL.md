---
name: prd-status
description: >
  Reports progress against a Product Requirements Document (the docs/prd/
  directory) by listing which acceptance criteria are complete and which
  remain, grouped by requirement. Use when the user asks for PRD status, what is
  left to build, or how far along the release is. Read-only.
argument-hint: "[path to PRD directory]"
---
# PRD Status Skill

This skill reports how much of a PRD has been completed. It only reads files.
Do not edit the PRD, and do not change GitHub issues. Use the `prd-tracking`
skill to check off criteria.

## 1. Locate the PRD

Use the path the user provided: $ARGUMENTS

If no path was provided, use the `docs/prd/` directory in the workspace. If it
does not contain a `README.md`, tell the user and stop.

## 2. Read the requirements

Read the tables in section 5 of `README.md` ("Current Version Requirements"),
one per feature group, for the list and order of requirements. Then read each linked file in `features/`
and collect:

- The requirement ID, feature name, and priority.
- Its acceptance criteria, counting `- [x]` as complete and `- [ ]` as
  remaining.

If a feature has no acceptance criteria, list it as "no criteria defined"
rather than as complete.

If a file in `features/` is not in the table, or a table row links to a missing
file, report it as an inconsistency instead of guessing.

## 3. Report

Present the results in this order:

1. **Overall progress**: criteria complete out of total, as a count and a
   percentage.
2. **Requirements table**, one row per requirement:

   | ID | Feature | Priority | Done | Status |
   | --- | --- | --- | --- | --- |

   Use `Done` for the count (for example `2/4`), and `Status` of `Complete`,
   `In progress`, or `Not started`.
3. **Remaining work**: the unchecked criteria, grouped by requirement, with
   Must-have requirements first.
4. **Open questions**: the items listed in the PRD's Open Questions section, if
   any, since they may block remaining work.

Keep the report short. Do not restate criteria that are already complete.
