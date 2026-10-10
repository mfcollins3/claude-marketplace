# Conventional Commits Skill

The `commit` skill helps AI coding agents write Git commit messages that follow
the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification, and commits the changes that are already staged.

## The Rules

* **Header**: `type(scope): description`, at most 52 characters in total. The
  description is in the imperative mood ("create the API") and starts with a
  lowercase letter. The scope is optional.
* **Body**: written in the first person and past tense ("I created the API"),
  wrapped at 72 characters. It can span several paragraphs. A line holding a
  long symbol name, URL, or file name can go past 72 characters.
* **Footers**: `BREAKING CHANGE:` and trailers such as `Refs: #123`.

The skill never stages files, amends commits, or pushes unless you ask.

## Defining Scopes

Scopes belong to your project. The skill looks for a list of them, and stops at
the first list it finds:

1. `CLAUDE.md` in your project.
2. A `CONTRIBUTING` file, searched in the places
   [GitHub supports](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors),
   in GitHub's order of precedence: `.github/`, then the repository root, then
   `docs/`.

Add a section like this to either file:

```markdown
## Commit Scopes

Use these scopes in Conventional Commits messages:

* `api`: the REST API
* `web`: the web front end
```

If your project defines no scopes, the skill leaves the scope out.

## Validation Hook

The plugin includes a `PreToolUse` hook that checks the message file passed to
`git commit -F`. It blocks the commit and explains the problem when:

* the header is longer than 52 characters, does not match
  `type(scope): description`, or its description does not start with a
  lowercase letter;
* the second line is not blank;
* a body line is longer than 72 characters (unless it holds a URL, path, code
  span, or other long token);
* the message is passed with `-m` instead of a file.

The hook needs [`jq`](https://jqlang.org). Without it, the hook does nothing.
It does not check tense or whether a scope is one your project defines; the
skill covers those.
