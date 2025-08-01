#!/bin/bash
set -e

if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
  git config --global credential.helper store
  echo "https://$GIT_USERNAME:$GIT_PASSWORD@github.com" > ~/.git-credentials
fi

exec "$@"
