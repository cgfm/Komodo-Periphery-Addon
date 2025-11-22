# Multi-stage build for Komodo Periphery Home Assistant Addon
FROM ghcr.io/moghtech/komodo-periphery:latest AS periphery-binary

# Use Debian bookworm for native glibc compatibility and better security
FROM debian:bookworm-slim

# Install essential dependencies for Home Assistant Add-on integration
RUN apt-get update && apt-get install -y \
    bash \
    jq \
    curl \
    wget \
    netcat-openbsd \
    ca-certificates \
    procps \
    xz-utils \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install s6-overlay for service management (Home Assistant Add-on standard)
ARG S6_OVERLAY_VERSION=3.1.6.2
RUN wget -O /tmp/s6-overlay.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
    && tar -C / -Jxpf /tmp/s6-overlay.tar.xz \
    && wget -O /tmp/s6-overlay-arch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz" \
    && tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz \
    && rm -f /tmp/s6-overlay*.tar.xz

# Install bashio for Home Assistant Add-on logging and configuration
RUN curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.14.3.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio*

# Copy Komodo Periphery binary from the official image
COPY --from=periphery-binary /usr/local/bin/periphery /usr/local/bin/periphery

# Copy root filesystem
COPY rootfs /

# Create directories for Home Assistant integration
RUN \
    mkdir -p /data \
    && mkdir -p /config \
    && mkdir -p /share \
    && mkdir -p /ssl \
    && mkdir -p /addons \
    && mkdir -p /backup \
    && mkdir -p /media \
    && mkdir -p /share/komodo/stacks \
    && mkdir -p /share/komodo/repos \
    && mkdir -p /share/komodo/builds \
    && mkdir -p /etc/komodo

# Set proper permissions for run script
RUN chmod +x /run.sh

# Create health check script
RUN echo '#!/bin/bash\ncurl -k -s --max-time 5 https://localhost:8120/health || curl -k -s --max-time 5 https://localhost:8120/ || exit 1' > /health.sh \
    && chmod +x /health.sh

# Set up s6-overlay services for komodo-periphery
RUN mkdir -p /etc/s6-overlay/s6-rc.d/komodo-periphery \
    && echo "longrun" > /etc/s6-overlay/s6-rc.d/komodo-periphery/type \
    && echo "#!/bin/bash\nexec /run.sh" > /etc/s6-overlay/s6-rc.d/komodo-periphery/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/komodo-periphery/run \
    && mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d \
    && echo "komodo-periphery" > /etc/s6-overlay/s6-rc.d/user/contents.d/komodo-periphery

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /health.sh

# Set working directory
WORKDIR /etc/komodo

# Expose port
EXPOSE 8120

# Labels
LABEL \
    io.hass.name="Komodo Periphery" \
    io.hass.description="Komodo Periphery Server - Manages containers on remote servers" \
    io.hass.arch="aarch64|amd64" \
    io.hass.type="addon" \
    io.hass.version="2" \
    maintainer="Home Assistant Community Add-ons <hello@addons.community>" \
    org.opencontainers.image.title="Home Assistant Add-on: Komodo Periphery" \
    org.opencontainers.image.description="Komodo Periphery Server - Manages containers on remote servers" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Home Assistant Community Add-ons <hello@addons.community>" \
    org.opencontainers.image.licenses="GPL-3.0" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-komodo-periphery" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-komodo-periphery/blob/main/README.md"

# Use s6-overlay as init system
ENTRYPOINT ["/init"]

# Start script via s6-overlay
CMD []
