---
name: issue-project
description: >
  Checks that a GitHub issue is in a GitHub Project and moves it between the
  project's Status values (Todo, Planning, Ready, In Progress, Review, Done)
  using the GitHub CLI (gh). Used by the plan-issue, approve-plan, and
  implement-issue skills; do not use it to add issues to a project.
---
# Issue Project Skill

Work on an issue is tracked by the issue's **Status** in its GitHub Project. This
skill finds the issue's project item and changes its status. It never adds an
issue to a project: deciding what is in scope for a project belongs to the
product owner or project manager, not to the developer.

The project must have these Status values, with exactly these names:
`Todo`, `Planning`, `Ready`, `In Progress`, `Review`, and `Done`.

| Status        | Meaning                                    | Set by                    |
| ------------- | ------------------------------------------ | ------------------------- |
| `Todo`        | Created, not yet planned                   | Whoever creates the issue |
| `Planning`    | A plan is being written or reviewed        | `plan-issue`              |
| `Ready`       | The plan is approved                       | `approve-plan`            |
| `In Progress` | The plan is being implemented              | `implement-issue`         |
| `Review`      | A pull request is open for review          | `implement-issue`         |
| `Done`        | The pull request was merged                | GitHub (see the README)   |

`gh` needs the `project` scope. If a command reports a missing scope, ask the
user to run `gh auth refresh -s project` themselves.

## 1. Find the issue's project item

```bash
gh api graphql -F owner={owner} -F repo={repo} -F number={number} -f query='
query($owner:String!,$repo:String!,$number:Int!){
  repository(owner:$owner,name:$repo){
    issue(number:$number){
      projectItems(first:20){
        nodes{
          id
          status: fieldValueByName(name:"Status"){ ... on ProjectV2ItemFieldSingleSelectValue{ name } }
          project{
            id number title
            owner{ ... on User{login} ... on Organization{login} }
            field(name:"Status"){ ... on ProjectV2SingleSelectField{ id options{ id name } } }
          }
        }
      }
    }
  }
}'
```

Then check, and **stop** with a clear message when a check fails:

- **No project items.** The issue is not in a project. Tell the user that work
  cannot start until a product owner or project manager adds it to one. Do not
  add it yourself, and do not offer to.
- **More than one project item.** Ask the user which project tracks the work,
  and use only that one.
- **The project has no Status field, or is missing any of the six values.** Tell
  the user which are missing and that a project manager can add them by running
  the `product-management:project-upgrade` skill.

Remember the item `id`, the project `id`, the Status field `id`, the current
status name, and the option `id` for each status.

## 2. Set the status

Look up the option `id` by name, then:

```bash
gh project item-edit --id {item_id} --project-id {project_id} --field-id {status_field_id} --single-select-option-id {option_id}
```

Only move an issue along the table above. If the current status is not one the
calling skill expects (for example, an issue in `Review` being planned again),
tell the user and ask before changing it. Never move an issue to `Done`.

If setting the status fails after other work has been done, report the error and
tell the user which status to set by hand. Do not retry silently.
