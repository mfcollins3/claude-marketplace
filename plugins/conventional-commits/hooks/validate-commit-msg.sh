#!/usr/bin/env bash
# PreToolUse hook that validates the message of `git commit -F <file>`.
#
# Exit codes:
#   0 - allow the tool call
#   2 - block the tool call; stderr is shown to Claude
set -u

if ! command -v jq >/dev/null 2>&1; then
    echo "conventional-commits: jq is not installed; skipping commit message validation" >&2
    exit 0
fi

input=$(cat)
command=$(jq -r '.tool_input.command // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

commit_re='(^|[;&|(]|[[:space:]])git[[:space:]]+(-[Cc][[:space:]]+[^[:space:]]+[[:space:]]+|-[^[:space:]]+[[:space:]]+)*commit([[:space:]]|$)'
[[ $command =~ $commit_re ]] || exit 0

# Only look at what follows `commit`, so `git -C <dir>` is not mistaken for -C.
matched=${BASH_REMATCH[0]}
command=" ${command#*"$matched"}"

# Commits that do not write a new message.
no_edit_re='[[:space:]]--no-edit([[:space:]]|$)'
reuse_re='[[:space:]](-[cC]|--reuse-message|--reedit-message)([[:space:]=]|$)'
[[ $command =~ $no_edit_re || $command =~ $reuse_re ]] && exit 0

inline_re='[[:space:]](-[a-zA-Z]*m|--message)([[:space:]=]|$)'
file_re='[[:space:]](-[a-zA-Z]*F|--file)[[:space:]=]+("[^"]+"|'"'"'[^'"'"']+'"'"'|[^[:space:];&|]+)'

if [[ $command =~ $inline_re ]]; then
    echo "Commit blocked: do not pass the message with -m/--message. Write the message to a file and run 'git commit -F <file>' so it can be validated." >&2
    exit 2
fi

if [[ ! $command =~ $file_re ]]; then
    # Merge commits and similar commits that open no editor message.
    merge_re='[[:space:]]--(no-edit|squash|fixup)([[:space:]=]|$)'
    [[ $command =~ $merge_re ]] && exit 0
    echo "Commit blocked: write the message to a file and run 'git commit -F <file>' so it can be validated." >&2
    exit 2
fi

file=${BASH_REMATCH[2]}
file=${file#[\"\']}
file=${file%[\"\']}

if [[ $file == "-" ]]; then
    echo "Commit blocked: 'git commit -F -' reads the message from stdin. Write the message to a file and pass its path to -F." >&2
    exit 2
fi

[[ $file == "~/"* ]] && file="$HOME/${file#\~/}"
[[ $file != /* && -n $cwd ]] && file="$cwd/$file"

if [[ ! -f $file ]]; then
    echo "Commit blocked: message file '$file' does not exist yet. Create it first, then run 'git commit -F'." >&2
    exit 2
fi

# Drop comment lines, then trailing blank lines.
lines=()
while IFS= read -r line || [[ -n $line ]]; do
    [[ $line == "#"* ]] && continue
    lines+=("$line")
done <"$file"
while ((${#lines[@]} > 0)) && [[ -z ${lines[${#lines[@]}-1]//[[:space:]]/} ]]; do
    unset 'lines[${#lines[@]}-1]'
done

errors=()
header=${lines[0]:-}
header_re='^[a-z]+(\([a-z0-9._/-]+\))?!?: [a-z]'

if [[ -z $header ]]; then
    errors+=("The message is empty.")
else
    [[ $header =~ $header_re ]] || errors+=("Header must look like 'type(scope): description' or 'type: description', with a lowercase type and a description starting with a lowercase letter: '$header'")
    ((${#header} > 52)) && errors+=("Header is ${#header} characters; the limit is 52: '$header'")
    [[ $header == *"." ]] && errors+=("Header must not end with a period.")
fi

if ((${#lines[@]} > 1)) && [[ -n ${lines[1]} ]]; then
    errors+=("Line 2 must be blank (separate the header from the body).")
fi

long_token_re='[^[:space:]]{31,}'
for ((i = 1; i < ${#lines[@]}; i++)); do
    line=${lines[i]}
    ((${#line} <= 72)) && continue
    # Allow long lines holding URLs, paths, code spans, or long symbols.
    if [[ $line == *"://"* || $line == *"/"* || $line == *'`'* || $line =~ $long_token_re ]]; then
        continue
    fi
    errors+=("Line $((i + 1)) is ${#line} characters; wrap body lines at 72.")
done

if ((${#errors[@]} > 0)); then
    echo "Commit blocked: the commit message does not follow the conventions:" >&2
    for e in "${errors[@]}"; do
        echo "  - $e" >&2
    done
    echo "Fix the message in $file and run 'git commit -F' again." >&2
    exit 2
fi

exit 0
