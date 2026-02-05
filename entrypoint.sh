#!/bin/sh

# ==================================================
# n8n + Cloudflare Tunnel Entrypoint
# ==================================================

echo "🚀 Starting n8n Bundled Container..."

# 1. Start Cloudflare Tunnel (if token provided)
if [ ! -z "$CLOUDFLARE_TUNNEL_TOKEN" ]; then
    echo "🔗 Starting Named Tunnel..."
    cloudflared tunnel --no-autoupdate run --token "$CLOUDFLARE_TUNNEL_TOKEN" &
    
elif [ "$N8N_HOST" = "quick-tunnel" ]; then
    echo "🔗 Starting Quick Tunnel..."
    cloudflared tunnel --url http://localhost:5678 --protocol http2 --no-autoupdate > /tmp/cloudflared.log 2>&1 &
    
    # Wait for URL generation
    sleep 5
    echo "============================================"
    echo "🌐 Quick Tunnel URL:"
    grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' /tmp/cloudflared.log | head -n 1
    echo "============================================"
else
    echo "⚠️  No Tunnel configured. Starting n8n locally only."
fi

# 2. Start n8n
echo "⚡ Starting n8n..."
exec n8n
