# Changelog

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `plan-issue` skill for finding or creating a GitHub issue and posting an
  implementation plan to it for review.
- `implement-issue` skill for carrying out an approved plan, updating the
  issue, and opening a pull request that closes it.
- Hook that blocks file changes unless the current branch is an issue branch.

[Unreleased]: https://github.com/mfcollins3/claude-marketplace/commits/main/plugins/issue-driven-development
