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

touch xxx.txt
ls -la xxx.txt

chmod go+w .
chmod --recursive go+w docs/
ls -la

git status

sudo bundle exec jekyll build --trace --verbose --destination ./docs/

git status


