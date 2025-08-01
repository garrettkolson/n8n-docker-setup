#!/bin/bash
set -e

if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
  git config --global credential.helper store
  echo "https://$GIT_USERNAME:$GIT_PASSWORD@github.com" > ~/.git-credentials
fi

# Use a temp directory under /home/node so the node user has access
TEMP_REPO_DIR="/home/node/temp/repos/contracting"

# Create the directory if it doesn't exist
if [ ! -d "$TEMP_REPO_DIR" ]; then
  mkdir -p "$TEMP_REPO_DIR"
fi

cd "$TEMP_REPO_DIR"

# Only clone if the repo doesn't already exist (check for .git directory)
if [ ! -d .git ]; then
  git init
  git clone https://github.com/FoxHireLLC/contracting.git .
fi


# Install Claude Code CLI
# if [ ! -d /home/node/temp ]; then
#   mkdir -p /home/node/temp
# fi

# curl -L https://github.com/anthropics/claude-code-cli/releases/latest/download/claude-code-linux-amd64 -o /home/node/temp/claude-code \
#     && chmod +x /home/node/temp/claude-code

# Add /home/node/temp to PATH so claude-code can be found
#export PATH="/home/node/temp:$PATH"

exec "$@"
