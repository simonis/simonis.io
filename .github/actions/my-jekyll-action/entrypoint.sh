#!/bin/sh
set -e

echo "Starting My Jekyll Action.."

if [ -z "${INPUT_GITHUB-TOKEN}" ]; then
  echo "::error::No GITHUB_TOKEN provided. Please set the 'github-token' parameter."
  exit 1
fi

# Needed because otherwise bundle/Jekyll can't create Gemfile.lock and write to docs/
chmod -R go+w .
ls -la

# Reset all file dates to the last commit date. This is necessary if we want
# to print the last modifiaction time in posts and documents, because they are
# based on the last file modification date. For more details see the explanation
# in _plugins/file-modification-date.rb
for f in `git ls-tree -r --name-only HEAD`; do touch -d `git log -1 --date=short --pretty='format:%ad' $f` $f; done

bundle exec jekyll build --trace --verbose --destination ./docs/

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

git add docs/

LAST_COMMIT=`git log -1 --pretty=format:"%s"`
git commit -m "Recreated for: $LAST_COMMIT"

git push "https://${GITHUB_ACTOR}:${INPUT_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
