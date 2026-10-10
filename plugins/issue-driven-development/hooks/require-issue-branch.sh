#!/usr/bin/env bash
# PreToolUse hook that blocks file changes in a Git repository unless the
# current branch is an issue branch such as `42-user-sign-in`.
#
# Exit codes:
#   0 - allow the tool call
#   2 - block the tool call; stderr is shown to Claude
set -u

if ! command -v jq >/dev/null 2>&1; then
    echo "issue-driven-development: jq is not installed; skipping the issue branch check" >&2
    exit 0
fi

[[ ${ISSUE_DRIVEN_DEVELOPMENT:-} == "off" ]] && exit 0

input=$(cat)
file=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

[[ -z $file ]] && exit 0
[[ $file == "~/"* ]] && file="$HOME/${file#\~/}"
[[ $file != /* && -n $cwd ]] && file="$cwd/$file"

# Find the nearest directory that exists; the file or its folders may be new.
dir=$(dirname -- "$file")
while [[ ! -d $dir && $dir != "/" ]]; do
    dir=$(dirname -- "$dir")
done

# Resolve symlinks (such as /var -> /private/var on macOS) so the path can be
# compared with the repository root.
dir=$(cd -- "$dir" 2>/dev/null && pwd -P) || exit 0
file="$dir/$(basename -- "$file")"

# Files outside a Git work tree (scratch files, plans, memory) are not project
# changes.
toplevel=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || exit 0

# The PRD is written before any issue exists.
[[ $file == "$toplevel/docs/prd/"* ]] && exit 0

branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || true)
issue_branch_re='^([^/]+/)?[0-9]+-'
[[ $branch =~ $issue_branch_re ]] && exit 0

if [[ -z $branch ]]; then
    branch="(detached HEAD)"
fi

cat >&2 <<MSG
Change blocked: this repository's current branch ($branch) is not an issue branch.
Changes require a GitHub issue with an approved plan. Use the plan-issue skill to
create or plan an issue. Once the plan has the plan-approved label, the user can
run implement-issue, which creates the issue branch. Do not work around this
block by editing files through Bash.
MSG
exit 2
