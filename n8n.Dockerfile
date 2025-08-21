FROM n8nio/n8n:latest

# Install git, curl, and bash using Alpine's package manager
USER root

RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    openrc \
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

# Add GitHub CLI
RUN apk add github-cli

# Download MSSQL tools and dependencies
RUN curl -O https://download.microsoft.com/download/fae28b9a-d880-42fd-9b98-d779f0fdd77f/msodbcsql18_18.5.1.1-1_amd64.apk
RUN curl -O https://download.microsoft.com/download/7/6/d/76de322a-d860-4894-9945-f0cc5d6a45f8/mssql-tools18_18.4.1.1-1_amd64.apk

# Install the MSSQL packages
RUN apk add --allow-untrusted msodbcsql18_18.5.1.1-1_amd64.apk
RUN apk add --allow-untrusted mssql-tools18_18.4.1.1-1_amd64.apk

COPY ./odbc.ini /etc/odbc.ini

# Copy entrypoint script and set as entrypoint
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["n8n"]

USER node

