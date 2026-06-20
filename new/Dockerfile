FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ============ System dependencies ============
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git make gcc build-essential \
    ripgrep fd-find zsh unzip \
    ca-certificates sudo locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

# ============ Neovim 0.12.2 ============
ARG NVIM_VERSION=0.12.2
RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz \
    && tar -xzf nvim-linux-x86_64.tar.gz \
    && mv nvim-linux-x86_64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz \
    && nvim --version | head -1

# ============ Node.js LTS ============
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && node --version && npm --version

# ============ Python ============
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && python3 --version

# ============ Lazygit ============
ARG LAZYGIT_VERSION=0.40.2
RUN curl -LO https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
    && tar xf lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz -C /tmp \
    && install /tmp/lazygit /usr/local/bin \
    && rm lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
    && lazygit --version

# ============ Pre-create state directories ============
# Para que los volúmenes named no fallen por permisos en el primer arranque
# Incluye .npm y .cache/pip que npm/pip crean al vuelo
RUN mkdir -p /home/nvim/.local/share/nvim \
    /home/nvim/.local/state/nvim \
    /home/nvim/.cache/nvim \
    /home/nvim/.cache/pip \
    /home/nvim/.npm \
    /home/nvim/.config \
    /home/nvim/work \
    && chown -R 1000:1000 /home/nvim/.local /home/nvim/.cache /home/nvim/.npm /home/nvim/.config /home/nvim/work

# ============ Non-root user ============
RUN useradd -m -s /bin/zsh -u 1000 -G sudo nvim

# ============ Sudoers (NOPASSWD para nvim) ============
# Usar /etc/sudoers.d/ en vez de append a /etc/sudoers (más seguro)
RUN echo "nvim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nvim \
    && chmod 440 /etc/sudoers.d/nvim

USER nvim
WORKDIR /home/nvim

# ============ Pyright ============
RUN pip3 install --user --break-system-packages pyright 2>/dev/null || \
    pip3 install --user pyright

ENV PATH="/home/nvim/.local/bin:${PATH}"

# NOTA: NO pre-instalamos lazy.nvim aquí porque el volumen `nvim-data`
# se monta encima y lo ocultaría. El bootstrap en `started.lua` lo clona
# en runtime dentro del volumen.

# NOTA: NO copiamos la config con COPY. Se monta via bind mount
# en docker-compose.yml para edición en vivo desde el host.

# ============ Entrypoint (arregla permisos de volúmenes) ============
COPY --chown=nvim:nvim --chmod=755 entrypoint.sh /home/nvim/.local/bin/entrypoint.sh

# ============ Healthcheck ============
HEALTHCHECK --interval=30s --timeout=3s \
    CMD nvim --headless +qall || exit 1

# ============ Default: bash para entrar al container ============
ENTRYPOINT ["/home/nvim/.local/bin/entrypoint.sh"]
CMD ["bash"]
