#!/bin/sh
set -e

echo "Starting My Jekyll Action.."

if [ -z "${INPUT_GITHUB-TOKEN}" ]; then
  echo "::error::No GITHUB_TOKEN provided. Please set the 'github-token' parameter."
  exit 1
fi

pwd

ls -la

id

# Needed because otherwise bundle/Jekyll can create Gemfile.lock and write to docs/
chmod go+w .
chmod -R go+w docs/
ls -la

git status

bundle exec jekyll build --trace --verbose --destination ./docs/

ls -la

git status

git add docs/
LAST_COMMIT=`git log -1 --pretty=format:"%s"`
git commit -m "Recreated for: $LAST_COMMIT"

git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git push "https://${GITHUB_ACTOR}:${INPUT_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
