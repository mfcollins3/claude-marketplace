# Changelog

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `plan-issue` skill for finding a GitHub issue and posting an implementation
  plan to it for review. It plans in plan mode, and posts a plan made with
  `/plan` to the issue.
- `approve-plan` skill for recording that a plan was approved.
- `implement-issue` skill for carrying out an approved plan, updating the
  issue, and opening a pull request that closes it.
- `issue-project` skill that requires the issue to be in a GitHub Project and
  moves it through the `Todo`, `Planning`, `Ready`, `In Progress`, `Review`, and
  `Done` statuses. The skills never add issues to a project or create them.
- Hook that blocks file changes unless the current branch is an issue branch.

[Unreleased]: https://github.com/mfcollins3/claude-marketplace/commits/main/plugins/issue-driven-development
