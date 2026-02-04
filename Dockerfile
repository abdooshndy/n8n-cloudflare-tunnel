# Stage 1: Get cloudflared binary from official image
FROM cloudflare/cloudflared:latest AS cloudflared

# Stage 2: Build final image
FROM n8nio/n8n:latest

USER root

# Copy cloudflared binary
COPY --from=cloudflared /usr/local/bin/cloudflared /usr/local/bin/cloudflared

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch back to n8n user
USER node

ENTRYPOINT ["/entrypoint.sh"]
