FROM node:20-bookworm

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=2.1.76
ARG CODEX_VERSION=0.116.0
ARG GO_VERSION=1.24.1
ARG GOLANGCI_LINT_VERSION=v1.64.8

# Install basic development tools, firewall/proxy dependencies, Python, and PostgreSQL client
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  git \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  iproute2 \
  dnsutils \
  curl \
  jq \
  nano \
  vim \
  squid-openssl \
  openssl \
  python3 \
  python3-venv \
  python-is-python3 \
  postgresql-client \
  libpq-dev \
  pkg-config \
  build-essential \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /root-project /home/node/.claude /home/node/.codex /etc/squid/ssl /var/log/squid /var/spool/squid && \
  chown -R node:node /root-project /home/node/.claude /home/node/.codex && \
  chown -R proxy:proxy /etc/squid/ssl /var/log/squid /var/spool/squid

WORKDIR /root-project

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Install Go toolchain (requires root for /usr/local/go)
RUN ARCH=$(dpkg --print-architecture) && \
  wget -q "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" && \
  tar -C /usr/local -xzf "go${GO_VERSION}.linux-${ARCH}.tar.gz" && \
  rm "go${GO_VERSION}.linux-${ARCH}.tar.gz"
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$PATH

# Set up non-root user
USER node

# Set up Go workspace for non-root user
ENV GOPATH=/home/node/go
ENV PATH=$GOPATH/bin:$PATH
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=nano
ENV VISUAL=nano

# Default powerline10k theme
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude Code CLI and OpenAI Codex CLI with pinned versions.
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION} @openai/codex@${CODEX_VERSION}

# Copy and set up container init/firewall/proxy scripts
COPY proxy-allowlist.txt /usr/local/share/proxy-allowlist.txt
COPY init-devcontainer.sh render-squid-config.sh verify-egress.sh init-firewall.sh announce-egress-status.sh devcontainer-entrypoint.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-devcontainer.sh /usr/local/bin/init-firewall.sh /usr/local/bin/render-squid-config.sh /usr/local/bin/verify-egress.sh /usr/local/bin/announce-egress-status.sh /usr/local/bin/devcontainer-entrypoint.sh && \
  chmod 0644 /usr/local/share/proxy-allowlist.txt
ENTRYPOINT ["/usr/local/bin/devcontainer-entrypoint.sh"]
CMD ["sleep", "infinity"]
