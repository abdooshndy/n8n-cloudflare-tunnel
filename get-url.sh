#!/bin/bash

echo "============================================"
echo "🌐 البحث عن رابط Quick Tunnel..."
echo "🌐 Searching for Quick Tunnel URL..."
echo "============================================"
echo ""

URL=$(docker logs n8n-bundled 2>&1 | grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' | tail -1)

if [ -z "$URL" ]; then
    echo "❌ لم يتم العثور على الرابط بعد. انتظر قليلاً وحاول مرة أخرى."
    echo "❌ URL not found yet. Please wait a moment and try again."
else
    echo "✅ URL Found:"
    echo ""
    echo "   $URL"
    echo ""
fi
