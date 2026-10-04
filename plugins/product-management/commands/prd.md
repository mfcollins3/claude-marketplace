---
description: Generate a Product Requirements Document (PRD) from a product description
argument-hint: <description of the product or feature>
model: opus
---
# Product Requirements Document (PRD)

## Product description

The user provided the following product or feature description:

$ARGUMENTS

- You are a senior product management assistant.
- Your task is to create a comprehensive Product Requirements Document (PRD) for
  a product based on user input and research.
- You will ask questions of the user to obtain the necessary information needed
  to write the PRD. Ask follow-up questions when necessary to seek clarification
  on your task.
- Use the [PRD Templates](#prd-templates) as the templates for the generated
  PRD. The PRD is an index file (`README.md`) plus one file per feature in a
  `features` subdirectory.
- Unless directed to write the PRD to a specific location, write the PRD to the
  `docs/prd/` directory in the workspace.

## Instructions for Creating the PRD

1. **Analyze codebase**: Review the existing codebase to understand the current
   architecture, identify potential integration points, and assess technical
   constraints. Use this to make your questions specific.

2. **Ask clarifying questions**: Treat the product description above as the
   starting input. If it is empty, ask the user to describe the product or
   feature first. Before creating the PRD, ask questions to better understand
   the user's needs.

   - Identify missing information (e.g., target audience, key features,
     constraints). Do not ask about anything the description already covers.
   - Ask 3-5 questions to reduce ambiguity.
   - Use a bulleted list for readability.
   - Phrase questions conversationally (e.g., "To help me create the best PRD,
     could you clarify...").

3. **Overview**: Begin with a brief explanation of the project's purpose and
   scope.

4. **Headings**:

   - Use title case for the main document title only (e.g., PRD:
     {project_title}).
   - All other headings should use sentence case.

5. **Structure**: Organize the PRD according to the
   [provided templates](#prd-templates). Add relevant subheadings as needed.

   - Keep the table of contents in `README.md` directly below the document
     title, with one link per numbered section and, nested under section 5,
     one link per feature group. Replace the template's placeholder group
     entries with the real groups. Make each link's anchor match its heading
     using GitHub's rules (lowercase, punctuation removed, spaces replaced by
     hyphens), for example `### 5.1 Authentication` is `#51-authentication`.
     Update the links if you rename, renumber, add or remove a section or
     group.
   - Write one feature file per requirement ID in `features/`, named
     `{requirement_id}-{slug}.md`. The slug is the feature name in lowercase,
     with each run of non-alphanumeric characters replaced by a single hyphen
     (for example `GH-001-user-sign-in.md`).
   - Group related requirements under `### 5.N` headings in section 5 of
     `README.md`, and list every feature as a row in its group's table, in ID
     order, linking to its file. A group may have a single requirement.
   - Use relative paths for all links between files.

6. **Detail Level**:

   - Use clear, precise, and concise language.
   - Include specific details and metrics whenever applicable.
   - Ensure consistency and clarity throughout the document.

7. **User Stories and Acceptance Criteria**:

   - List ALL user interactions, covering primary, alternative, and edge cases.
   - Assign a unique requirement ID (e.g., GH-001) to each user story.
   - Include a user story addressing authentication/security if applicable.
   - Ensure each user story is testable.

8. **Final Checklist**: Before finalizing, ensure:

   - Every user story is testable.
   - Acceptance criteria are clear and specific.
   - All necessary functionality is covered by user stories.
   - Authentication and authorization requirements are clearly defined, if
     relevant.

9. **Formatting Guidelines**:

   - Consistent formatting and numbering.
   - No dividers or horizontal rules.
   - Format strictly in valid Markdown, free of disclaimers or footers.
   - Fix any grammatical errors from the user's input and ensure correct casing
     of names.
   - Refer to the project conversationally (e.g., "the project," "this
     feature").

10. **Confirmation**: After presenting the PRD, ask for the user's approval.

<!-- markdownlint-disable MD007 -->
   - If the user requests changes, make the necessary edits and confirm the
     final version with the user.
   - If the user approves:
      - Save `README.md` and every feature file to the PRD directory
        (`docs/prd/` by default). If the directory already contains a PRD,
        ask the user before overwriting it.
      - Ask the user if they would like to create a GitHub project for the
        release. If so, follow the steps in the
        [Create a GitHub Project](#create-a-github-project) section below.
<!-- markdownlint-enable MD007 -->

## Create a GitHub Project

If the user wants to create a GitHub project for the release, follow these
steps:

1. If the user did not specify the owner for the project, try to determine the
   owner based on the codebase. If you cannot determine the owner, ask the user
   to specify it.
2. Use the `github-projects` skill to create a new GitHub project for the
   release. If the user did not specify a project title to use, use the project
   title format: "{project_title}: v{version}".
3. After creating the project, link it to the GitHub repository if possible. If
   you cannot determine the repository, ask the user to specify it.
4. For each user story in the PRD, use the `github-issues` skill to create an
   issue in the repository, then use the `github-projects` skill to add it to
   the project. Use the format "[{requirement_id}] {user_story}" for the issue
   title, and include the acceptance criteria in the issue body, followed by a
   line naming the feature file, for example
   `Spec: docs/prd/features/GH-001-user-sign-in.md`.
5. After adding all user stories as issues, provide the user with a summary of
   the created GitHub project, including the project URL and a list of the
   created issues with their URLs.

## PRD Templates

### Index template (`README.md`)

```markdown
# [Product Name] - Product Requirements Document

## Table of contents

- [1. Product Overview](#1-product-overview)
- [2. User Personas](#2-user-personas)
- [3. Principles & Constraints](#3-principles--constraints)
- [4. Release Plan (High Level)](#4-release-plan-high-level)
- [5. Current Version: v1.0 Requirements](#5-current-version-v10-requirements)
  - [5.1 Feature group name](#51-feature-group-name)
  - [5.2 Feature group name](#52-feature-group-name)
- [6. Non-Functional Requirements](#6-non-functional-requirements)
- [7. Open Questions](#7-open-questions)
- [8. Decisions Log](#8-decisions-log)

## 1. Product Overview

### 1.1 Problem Statement

What problem are we solving? For whom? Why now?

### 1.2 Product Vision

Where is this product going long-term? (2-3 sentences max)

### 1.3 Success Criteria

How do we know this product is working? (Measurable outcomes)

## 2. User Personas

Who are the primary users? What are their goals and pain points? (Keep this
brief - 1-3 personas max to start)

## 3. Principles & Constraints

### 3.1 Design Principles

Ordered list of tradeoff-resolving principles. Example: "Simplicity over
flexibility" or "Offline-first"

### 3.2 Technical Constraints

- Platform targets
- Language/framework requirements
- Performance requirements
- Security requirements
- Integration requirements

### 3.3 Out of Scope

Explicitly state what this product is NOT. This is critical for AI agents who
will otherwise try to be helpful by adding things.

## 4. Release Plan (High Level)

### v1.0 - [Target Date] - [Theme]

Brief description of what "done" looks like for v1.

### v1.1 - [Target Date] - [Theme] (optional, tentative)

### v2.0 - [Target Date] - [Theme] (optional, tentative)

## 5. Current Version: v1.0 Requirements

Requirements are grouped by area. Each group has one table with one row per
requirement, in ID order. Each requirement is described in its own file in
`features/`.

### 5.1 [Feature group name]

| ID | Feature | Priority |
| --- | --- | --- |
| GH-001 | [Feature name](features/GH-001-feature-name.md) | Must-have |
| GH-002 | [Feature name](features/GH-002-feature-name.md) | Should-have |

### 5.2 [Feature group name]

(repeat pattern)

## 6. Non-Functional Requirements

- Performance targets
- Accessibility requirements
- Error handling philosophy
- Logging/observability needs

## 7. Open Questions

Things not yet decided. This is important - it signals to AI agents where NOT to
make assumptions.

## 8. Decisions Log

| Date | Decision | Rationale | Made By |
| --- | --- | --- | --- |

(Track key decisions so AI agents have context for WHY things are the way they
are)
```

### Feature template (`features/{requirement_id}-{slug}.md`)

```markdown
# GH-001: [Feature Name]

[Back to the PRD](../README.md)

**Requirement ID:** [e.g., GH-001]

**User Story:** As a [persona], I want to [action] so that [outcome].

**Acceptance Criteria:**

- [ ] Criterion 1
- [ ] Criterion 2

**Technical Notes:** Any implementation guidance for the AI agent.

**Priority:** Must-have | Should-have | Nice-to-have
```