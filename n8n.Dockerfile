FROM n8nio/n8n:latest

# Install dependencies for Git Credential Manager Core
FROM n8nio/n8n:latest

# Install git, curl, and bash using Alpine's package manager
USER root

RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    openssl \
    libstdc++ \
    icu-libs

# Optional: Use git-credential-store to avoid repeated GitHub prompts
RUN git config --global credential.helper store

# Optional: Add .netrc for GitHub authentication (less secure, but useful for automation)
# This part assumes you have a .netrc file to COPY in, or inject it via build args or secrets
# Uncomment and adjust if needed:
# COPY .netrc /root/.netrc
# RUN chmod 600 /root/.netrc

RUN npm install -g @anthropic-ai/claude-code

# Install .NET CLI (dotnet)
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel LTS \
    && rm dotnet-install.sh \
    && ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet

# Add GitHub CLI
RUN apk add github-cli

# Copy entrypoint script and set as entrypoint
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["n8n"]

USER node

