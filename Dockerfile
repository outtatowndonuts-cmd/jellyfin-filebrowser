FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    supervisor \
    ffmpeg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Jellyfin
RUN curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | gpg --dearmor -o /usr/share/keyrings/jellyfin-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jellyfin-keyring.gpg] https://repo.jellyfin.org/debian bookworm main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt-get update && apt-get install -y jellyfin && \
    rm -rf /var/lib/apt/lists/*

# Install File Browser
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    mv /root/filebrowser /usr/local/bin/filebrowser

# Create directories with proper permissions
RUN mkdir -p /data/media /data/config /data/cache && \
    mkdir -p /var/log/supervisor && \
    chown -R jellyfin:jellyfin /data && \
    chmod -R 755 /data

# Create Supervisor config
RUN cat > /etc/supervisor/conf.d/services.conf << 'EOF'
[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid

[program:jellyfin]
command=/usr/bin/jellyfin --datadir=/data/config --cachedir=/data/cache
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/jellyfin.err.log
stdout_logfile=/var/log/supervisor/jellyfin.out.log
user=jellyfin
environment=JELLYFIN_DATA_DIR=/data/config,JELLYFIN_CACHE_DIR=/data/cache

[program:filebrowser]
command=/usr/local/bin/filebrowser --root /data/media --address 0.0.0.0 --port 8080 --database /data/config/filebrowser.db
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/filebrowser.err.log
stdout_logfile=/var/log/supervisor/filebrowser.out.log
user=root
EOF

# Expose ports
EXPOSE 8096 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8096/health || exit 1

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/services.conf"]

