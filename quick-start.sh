#!/bin/bash

# ==================================================
# بدء التشغيل السريع
# Quick Start
# ==================================================

echo "=============================================="
echo "🚀 تشغيل n8n (الوضع الموحد)"
echo "🚀 Starting n8n (Single Mode)"
echo "=============================================="
echo ""

# 1. Check/Build Image
./download-images.sh || exit 1

echo ""
echo "🚀 Starting Container..."
docker-compose up -d

echo ""
echo "✅ System is running!"
echo ""

# 2. Get URL if Quick Tunnel
if grep -q "N8N_HOST=quick-tunnel" .env 2>/dev/null; then
    echo "🔗 Getting Quick Tunnel URL..."
    echo "Please wait 10 seconds..."
    sleep 10
    
    echo "============================================"
    echo "🌐 Your n8n URL:"
    echo "============================================"
    docker logs n8n-bundled 2>&1 | grep "https://"
    echo "============================================"
else
    echo "✅ Ready! Access via your domain defined in .env"
fi
