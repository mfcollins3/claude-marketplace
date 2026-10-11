---
name: github-projects
description: >
  Creates GitHub Projects, sets up their Status values, links them to
  repositories, and adds GitHub issues to them using the GitHub CLI (gh). Use when the user asks to create a GitHub
  project, or track a release or roadmap in GitHub Projects. To create or edit
  the issues themselves, use the github-issues skill.
---
# GitHub Projects Skill

This skill manages GitHub Projects with the `gh` CLI through the Bash tool. The
following features are supported:

1. [Create a new GitHub Project](#1-create-a-new-github-project)
2. [Link a GitHub Project to a repository](#2-link-a-github-project-to-a-repository)
3. [Add an issue to a GitHub Project](#3-add-an-issue-to-a-github-project)
4. [Set up the Status values](#4-set-up-the-status-values)

Before running any command, confirm that `gh` is installed and authenticated
with `gh auth status`. If it is not authenticated, ask the user to run
`gh auth login` themselves.

## 1. Create a new GitHub Project

To create a new GitHub Project, provide the following information:

- **Project Title**: The title of the project
- **Owner**: The GitHub user or organization that will own the project. If not
  specified, the default value of `@me` will be used, which refers to the
  authenticated user.

To create the project, run the following command:

```bash
gh project create --format json --owner {owner} --title "{project_title}"
```

The output is JSON. The `number` field is the project number used in later
commands, and the `url` field is the project URL.

If the output cannot be parsed, run `gh project list --owner {owner}` to check
whether the project was created before trying again, so that a duplicate
project is not created.

Then set up the project's Status values as described in
[Set up the Status values](#4-set-up-the-status-values).

## 2. Link a GitHub Project to a repository

To link a GitHub Project to a repository, provide the following information:

- **Project Number**: The number of the project you want to link.
- **Owner**: The owner of the project.
- **Repository**: The name of the repository to link the project to, in the
  format `owner/repo`.

To link the project to the repository, run the following command:

```bash
gh project link {project_number} --owner {owner} --repo {repository}
```

## 3. Add an issue to a GitHub Project

Use the `github-issues` skill to create, find, or edit the issue itself. To add
an existing issue to a project, provide the following information:

- **Project Number**: The number of the project.
- **Owner**: The owner of the project.
- **Issue URL**: The URL returned when the issue was created.

To add the issue, run the following command:

```bash
gh project item-add {project_number} --owner {owner} --url {issue_url} --format json
```

The output has the new item's `id`. New issues start in the `Todo` status, so
set that now, using the project ID and Status field ID from section 4:

```bash
gh project item-edit --id {item_id} --project-id {project_id} --field-id {status_field_id} --single-select-option-id {todo_option_id}
```

If the project has no `Todo` status, tell the user and suggest the
`project-upgrade` skill. The issue is still added.

Add issues one at a time, and check each command's exit status. If an add fails,
report the issue URL and error to the user rather than retrying silently.

## 4. Set up the Status values

Every project that tracks PRD issues uses these Status values, in this order:
`Todo`, `Planning`, `Ready`, `In Progress`, `Review`, and `Done`. A new project
only has `Todo`, `In Progress`, and `Done`. This section both sets up a new
project and upgrades an existing one, and can be run again safely.

1. Get the Status field and the project's ID:

   ```bash
   gh project field-list {project_number} --owner {owner} --format json
   gh project view {project_number} --owner {owner} --format json
   ```

   The `id` of the field named `Status` is the field ID, and the project's `id`
   is the project ID. If there is no `Status` field, tell the user and stop.

2. Read the field's current options, with their colors and descriptions:

   ```bash
   gh api graphql -F field={field_id} -f query='query($field:ID!){node(id:$field){... on ProjectV2SingleSelectField{options{id name color description}}}}'
   ```

3. Build the full list of options with `jq -f` and this program, saved to a
   temporary file. Options that already exist keep their ID, color, and
   description, which keeps the status of the issues that use them. Missing ones
   are added in the right place, and other options the user has added are kept
   after the six.

   ```jq
   def wanted: [["Todo","GRAY"],["Planning","PURPLE"],["Ready","BLUE"],["In Progress","YELLOW"],["Review","ORANGE"],["Done","GREEN"]];
   def clean: {id, name, color, description} | with_entries(select(.value != null));
   . as $existing
   | [ wanted[] as $w
       | (($existing | map(select(.name == $w[0])) | first) // {name: $w[0], color: $w[1], description: ""})
       | clean ]
     + [ $existing[] | select(.name as $n | (wanted | map(.[0]) | index($n)) == null) | clean ]
   ```

   Names are matched exactly. An option such as `To Do` or `Doing` is not
   renamed, because the right mapping is the user's decision. Tell the user about
   any such options, and that they can be renamed in the project's settings
   before running this again.

4. If the list is the same as the current options, report that the project is
   already up to date and stop. When upgrading an existing project, show the user
   which statuses will be added and which are kept, and wait for approval.

5. Replace the options. The mutation replaces the whole list, and options passed
   without an `id` are created, so always send the list from step 3:

   ```bash
   jq -n --arg field {field_id} --slurpfile opts {options_file} \
     '{query: "mutation($field: ID!, $opts: [ProjectV2SingleSelectFieldOptionInput!]!) { updateProjectV2Field(input: {fieldId: $field, singleSelectOptions: $opts}) { projectV2Field { ... on ProjectV2SingleSelectField { options { id name } } } } }", variables: {field: $field, opts: $opts[0]}}' \
     | gh api graphql --input -
   ```

   Confirm that the response lists the six statuses.

Items that have no status are not changed. The `project-upgrade` skill reports
them.
