#!/bin/bash

set -e
set -u
set -o pipefail

SCRIPT_DIR="$( cd $(dirname "$0") ; pwd )"
REPO_PATH=$( git -C "$SCRIPT_DIR" rev-parse --show-toplevel )

cd "$REPO_PATH"

readme-generator --config=/config.json --values=/values.yaml --readme=/README.md

IS_DIRTY=0
HAS_UNTRACKED=0

git -C "$REPO_PATH" diff --no-ext-diff --quiet || IS_DIRTY=1
git -C "$REPO_PATH" diff --no-ext-diff --cached --quiet || IS_DIRTY=1
git -C "$REPO_PATH" ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null && HAS_UNTRACKED=1

RESULT=$(( IS_DIRTY + HAS_UNTRACKED ))

if [[ "$RESULT" -eq 0 ]]; then
    echo 'Documentation is up-to-date'
else
    echo 'You need to update documetation: run `make prepare && make all`'
    echo 'Changed files:'
    git status --porcelain
    exit 1
fi

exit 0