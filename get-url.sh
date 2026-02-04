#!/bin/bash

# ==================================================
# سكريبت للحصول على رابط Quick Tunnel
# Script to get Quick Tunnel URL
# ==================================================

echo "🔗 جاري البحث عن رابط Cloudflare Quick Tunnel..."
echo "🔗 Searching for Cloudflare Quick Tunnel URL..."
echo ""

# التحقق من تشغيل الكونتينر
if ! docker ps | grep -q "cloudflared-quick-tunnel"; then
    echo "❌ الكونتينر غير مشغل!"
    echo "❌ Container is not running!"
    echo ""
    echo "شغّل الخدمات أولاً:"
    echo "Start the services first:"
    echo "  docker-compose --profile quick-tunnel up -d"
    exit 1
fi

echo "✅ الكونتينر مشغل، جاري استخراج الرابط..."
echo "✅ Container is running, extracting URL..."
echo ""

# انتظار قليل للتأكد من الاتصال
sleep 2

# استخراج الرابط
URL=$(docker-compose logs cloudflared-quick-tunnel 2>&1 | grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' | tail -1)

if [ -z "$URL" ]; then
    echo "⏳ لم يتم العثور على الرابط بعد. جاري الانتظار..."
    echo "⏳ URL not found yet. Waiting..."
    echo ""
    sleep 5
    URL=$(docker-compose logs cloudflared-quick-tunnel 2>&1 | grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' | tail -1)
fi

if [ -z "$URL" ]; then
    echo "❌ لم يتم العثور على الرابط."
    echo "❌ URL not found."
    echo ""
    echo "جرب مراجعة السجلات يدوياً:"
    echo "Try checking logs manually:"
    echo "  docker-compose logs cloudflared-quick-tunnel"
    exit 1
fi

echo "=============================================="
echo "✅ تم العثور على الرابط!"
echo "✅ URL Found!"
echo "=============================================="
echo ""
echo "🌐 رابط n8n الخاص بك:"
echo "🌐 Your n8n URL:"
echo ""
echo "   $URL"
echo ""
echo "=============================================="
echo ""
echo "📋 انسخ هذا الرابط واستخدمه للوصول إلى n8n"
echo "📋 Copy this URL and use it to access n8n"
echo ""
echo "🔑 بيانات الدخول موجودة في ملف .env"
echo "🔑 Login credentials are in .env file"
echo ""
echo "=============================================="
