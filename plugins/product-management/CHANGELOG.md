# Changelog

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-10-03

### Added

- `/product-management:prd` command for writing product requirements documents
  from a product description. It writes an index and one file per feature to
  `docs/prd/`.
- `prd-tracking` skill for checking off PRD acceptance criteria as work is
  completed and updating the matching GitHub issues.
- `prd-status` skill for reporting progress against a PRD's acceptance
  criteria.
- `prd-revise` skill for revising a requirement in the PRD and updating its
  GitHub issue.
- `prd-split` skill for splitting a requirement that is too big into two,
  updating the existing GitHub issue and creating a new one.
- `prd-move` skill for moving a requirement to another feature group in the
  PRD.
- `github-projects` skill for creating GitHub Projects, linking them to
  repositories, and adding issues to projects using the GitHub CLI.
- `github-issues` skill for creating, finding, editing, commenting on, closing,
  and reopening GitHub issues using the GitHub CLI.

[Unreleased]: https://github.com/mfcollins3/claude-marketplace/commits/main/plugins/product-management
