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
    icu-libs \
    nano \
    sudo

# set up container culture info
RUN apk add --no-cache musl-locales
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8


# Optional: Use git-credential-store to avoid repeated GitHub prompts
RUN git config --global credential.helper store

RUN npm install -g @anthropic-ai/claude-code

# Install .NET CLI (dotnet)
RUN curl -Lo dotnet.tar.gz https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-musl-x64.tar.gz
RUN tar zxf dotnet.tar.gz -C /usr/local/bin

COPY ./NuGet.Config /usr/local/bin/NuGet.Config

# Add GitHub CLI
RUN apk add github-cli

# Copy entrypoint script and set as entrypoint
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["n8n"]

USER node

