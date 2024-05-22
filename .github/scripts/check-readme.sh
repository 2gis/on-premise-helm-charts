#!/bin/bash

set -e
set -u
set -o pipefail

# Define directories
SCRIPT_DIR="$( cd $(dirname "$0") ; pwd )"
REPO_PATH=$( git -C "$SCRIPT_DIR" rev-parse --show-toplevel )

cd "$REPO_PATH"

# Run the generator for each subdirectory in charts
for chart in charts/*; do
  if [ -d "$chart" ]; then
    echo "Building README for $chart..."
    readme-generator --config="$REPO_PATH/bitnami-config.json" --values="$REPO_PATH/$chart/values.yaml" --readme="$REPO_PATH/$chart/README.md"
    echo ""
  fi
done

# Check for unsaved changes in the repository
IS_DIRTY=0
HAS_UNTRACKED=0

git -C "$REPO_PATH" diff --no-ext-diff --quiet || IS_DIRTY=1
git -C "$REPO_PATH" diff --no-ext-diff --cached --quiet || IS_DIRTY=1
git -C "$REPO_PATH" ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null && HAS_UNTRACKED=1

RESULT=$(( IS_DIRTY + HAS_UNTRACKED ))

if [[ "$RESULT" -eq 0 ]]; then
  echo -e '\033[0;32mDocumentation is up-to-date\033[0m'
else
  echo -e '\033[0;31mYou need to update documentation: run `make prepare && make all`\033[0m'
  echo 'Changed files:'
  git status --porcelain
  exit 1
fi

exit 0
