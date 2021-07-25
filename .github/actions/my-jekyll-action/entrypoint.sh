#!/bin/sh
set -e

echo "Starting My Jekyll Action.."

if [ -z "${INPUT_GITHUB-TOKEN}" ]; then
  echo "::error::No GITHUB_TOKEN provided. Please set the 'github-token' parameter."
  exit 1
fi

pwd

ls -la

git status

bundle exec jekyll build --trace --verbose --destination ./docs/

git status


