---
name: commit
description: >
  Writes Git commit messages that follow the Conventional Commits
  specification and commits the staged changes. Use whenever creating a git
  commit or when the user asks for a commit message.
---
# Conventional Commits Skill

This skill writes a commit message that follows the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification and commits the changes that are already staged.

## 1. Gather context

Run these commands to see what is being committed and how the project words its
commits:

```bash
git status
git diff --staged
git log -n 10 --format=%s
```

If nothing is staged, ask the user what to stage. Do not run `git add -A` or
`git add .` on your own.

## 2. Find the scopes

Scopes are defined by the project, never by this skill. Look for a list of
commit scopes (usually a "Commit Scopes" section) and stop at the first list
you find:

1. The project's `CLAUDE.md`.
2. The project's `CONTRIBUTING` file. Look in the places GitHub supports, in
   GitHub's order of precedence: `.github/`, then the repository root, then
   `docs/`. Use the first one that exists. It is usually `CONTRIBUTING.md`, but
   accept any extension.

Only use scopes from that list. If no scope fits, or the project lists none,
leave the scope out. Never invent a scope. If the staged changes span unrelated
scopes, suggest splitting them into separate commits.

## 3. Choose a type

| Type | Use for |
| --- | --- |
| `feat` | A new feature |
| `fix` | A bug fix |
| `build` | Build system or dependency changes |
| `chore` | Maintenance that changes no source or tests |
| `ci` | CI configuration and scripts |
| `docs` | Documentation only |
| `perf` | A performance improvement |
| `refactor` | A change that neither fixes a bug nor adds a feature |
| `revert` | Reverting an earlier commit |
| `style` | Formatting, with no change in meaning |
| `test` | Adding or correcting tests |

If the project's `CLAUDE.md` or `CONTRIBUTING` file defines its own list of
types, use that list instead.

## 4. Write the header

The first line is `<type>[(<scope>)][!]: <description>`.

* At most **52 characters** in total, including the type, scope, and colon.
* The description is in the **imperative mood** ("create the API", not
  "created", "creates", or "will create").
* The description **starts with a lowercase letter** and has no trailing
  period.
* Add `!` before the colon for a breaking change.
* If the header is too long, shorten the wording. Do not drop a scope that the
  project requires.

## 5. Write the body

* Leave one blank line after the header.
* Write in the **first person and past tense** ("I added the endpoint", "I
  fixed the null check"), not the imperative mood of the header.
* Explain what changed and why, not how.
* Wrap lines at **72 characters**. Use as many lines and paragraphs as needed.
  A line may go longer when it holds a long symbol name, URL, or file name that
  cannot be broken. Put such a token on its own line where possible.
* Leave the body out for trivial changes.

## 6. Add footers

After a blank line, add any footers:

* `BREAKING CHANGE: <description>` for a breaking change, wrapped at 72.
* Git trailers such as `Refs: #123`.
* Any attribution trailer that the environment asks for (for example
  `Co-Authored-By`) goes last.

## 7. Commit

Write the message to a temporary file, then commit it:

```bash
git commit -F {message_file}
```

Do not use `-m` or pass the message in a heredoc. This plugin includes a hook
that validates the file passed to `-F`. If it blocks the commit, it explains
which rule failed. Fix the message and run the command again.

Never use `--no-verify` or `--amend`, and never push, unless the user asks. If
a pre-commit hook fails, fix the problem, stage the fix, and create a new
commit. When the commit succeeds, show the user the result of `git log -1`.

## Examples

Good, with a scope:

```text
feat(api): create the orders endpoint

I added the POST /orders endpoint and the validation for its request
body. Orders are stored with the pending status until payment clears.

Refs: #42
```

Good, without a scope:

```text
fix: handle an empty config file
```

Good, with a breaking change:

```text
feat(auth)!: replace session cookies with tokens

I replaced the cookie sessions with signed tokens so that the API can
run without shared state. Clients must now send the token in the
Authorization header.

BREAKING CHANGE: session cookies are no longer accepted.
```

Bad headers:

| Header | Problem |
| --- | --- |
| `feat(api): Create the orders endpoint` | Description starts with a capital letter |
| `feat(api): created the orders endpoint` | Past tense instead of imperative |
| `feat(api): create the orders endpoint for all customers` | 55 characters, over the 52 limit |
| `fix(stuff): handle an empty config file` | `stuff` is not a scope the project defines |

Bad body:

```text
fix: handle an empty config file

Add a check for empty files and return the defaults.
```

The body should say "I added a check for empty files and returned the
defaults."
