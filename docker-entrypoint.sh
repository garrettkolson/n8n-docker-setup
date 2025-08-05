#!/bin/bash
set -e

if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
  git config --global credential.helper store
  git config --global user.email "golson@foxhire.com" && git config --global user.name "Garrett Olson"
  echo "https://$GIT_USERNAME:$GIT_PASSWORD@github.com" > ~/.git-credentials
fi

# Use a temp directory under /home/node so the node user has access
TEMP_REPO_DIR="/home/node/temp/repos/contracting"

# Create the directory if it doesn't exist
if [ ! -d "$TEMP_REPO_DIR" ]; then
  mkdir -p "$TEMP_REPO_DIR"
fi

cd "$TEMP_REPO_DIR"

git clone https://github.com/FoxHireLLC/Contracting.git .

exec "$@"
