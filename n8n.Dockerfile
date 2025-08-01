FROM n8nio/n8n:latest

# Install dependencies for Git Credential Manager Core
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    gpg \
    gnupg \
    ca-certificates \
    libc6 \
    libcurl4 \
    libexpat1 \
    libz3-4 \
    libssl3 \
    libicu70

# Install Git Credential Manager Core
RUN curl -L -o /tmp/gcmcore.deb https://github.com/GitCredentialManager/git-credential-manager/releases/latest/download/gcm-linux_amd64.deb \
 && dpkg -i /tmp/gcmcore.deb \
 && rm /tmp/gcmcore.deb

# Configure Git to use GCM
RUN git config --global credential.helper manager-core

# Install Claude Code CLI
RUN curl -L https://github.com/anthropics/claude-code-cli/releases/latest/download/claude-code-linux-amd64 -o /usr/local/bin/claude-code \
    && chmod +x /usr/local/bin/claude-code

# Copy entrypoint script and set as entrypoint
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["n8n"]

