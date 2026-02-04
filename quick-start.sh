#!/bin/bash

# ==================================================
# برنامج بدء سريع لـ n8n مع Cloudflare Tunnel
# Quick Start Script for n8n with Cloudflare Tunnel
# ==================================================

set -e

echo "=============================================="
echo "تنصيب n8n مع Cloudflare Tunnel"
echo "n8n with Cloudflare Tunnel Setup"
echo "=============================================="
echo ""

# التحقق من Docker
echo "🔍 التحقق من تثبيت Docker..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker غير مثبت. يرجى تثبيت Docker أولاً."
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose غير مثبت. يرجى تثبيت Docker Compose أولاً."
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker و Docker Compose مثبتان"
echo ""

# التحقق من ملف .env
if [ ! -f .env ]; then
    echo "⚠️  ملف .env غير موجود"
    echo "⚠️  .env file not found"
    echo ""
    
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ تم نسخ .env.example إلى .env"
        echo "✅ Copied .env.example to .env"
        echo ""
    else
        echo "❌ ملف .env.example غير موجود!"
        echo "❌ .env.example file not found!"
        exit 1
    fi
fi

echo "✅ ملف .env موجود"
echo ""

# سؤال المستخدم عن نوع النفق
echo "=============================================="
echo "اختر نوع Cloudflare Tunnel:"
echo "Choose Cloudflare Tunnel type:"
echo "=============================================="
echo ""
echo "1) Quick Tunnel (مجاني، بدون domain)"
echo "   Free, no domain needed"
echo "   رابط HTTPS عشوائي يتغير عند إعادة التشغيل"
echo "   Random HTTPS URL (changes on restart)"
echo ""
echo "2) Named Tunnel (مع domain خاص)"
echo "   With custom domain"
echo "   رابط HTTPS ثابت (يحتاج domain وتوكن)"
echo "   Fixed HTTPS URL (needs domain + token)"
echo ""
read -p "اختر (1 أو 2) / Choose (1 or 2): " tunnel_choice

PROFILE=""
if [ "$tunnel_choice" = "1" ]; then
    PROFILE="quick-tunnel"
    echo ""
    echo "✅ تم اختيار Quick Tunnel (مجاني، بدون domain)"
    echo "✅ Selected Quick Tunnel (free, no domain)"
    echo ""
    echo "⚠️  ملاحظة: الرابط سيتغير عند كل إعادة تشغيل"
    echo "⚠️  Note: URL will change on every restart"
    echo ""
elif [ "$tunnel_choice" = "2" ]; then
    PROFILE="named-tunnel"
    echo ""
    echo "✅ تم اختيار Named Tunnel (مع domain)"
    echo "✅ Selected Named Tunnel (with domain)"
    echo ""
    
    # التحقق من التوكن
    source .env
    if [ -z "$CLOUDFLARE_TUNNEL_TOKEN" ] || [[ "$CLOUDFLARE_TUNNEL_TOKEN" == *"your_tunnel_token_here"* ]] || [[ "$CLOUDFLARE_TUNNEL_TOKEN" == *"eyJhIjoieHh"* ]]; then
        echo "❌ خطأ: لم يتم تعيين CLOUDFLARE_TUNNEL_TOKEN في ملف .env"
        echo "❌ Error: CLOUDFLARE_TUNNEL_TOKEN not set in .env"
        echo ""
        echo "يرجى:"
        echo "Please:"
        echo "  1. اذهب إلى Cloudflare Dashboard"
        echo "  2. Zero Trust → Networks → Tunnels"
        echo "  3. أنشئ نفق جديد واحصل على التوكن"
        echo "  4. ضع التوكن في ملف .env"
        exit 1
    fi
else
    echo "❌ اختيار غير صحيح"
    echo "❌ Invalid choice"
    exit 1
fi

# التحقق من كلمة المرور
source .env
if [ "$N8N_PASSWORD" = "change_this_to_a_strong_password" ]; then
    echo "⚠️  تحذير: لم تقم بتغيير كلمة المرور الافتراضية!"
    echo "⚠️  Warning: You haven't changed the default password!"
    echo ""
    read -p "هل تريد المتابعة على أي حال؟ (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# إنشاء المجلدات المطلوبة
echo "📁 إنشاء المجلدات المطلوبة..."
mkdir -p n8n-data cloudflare
echo "✅ تم إنشاء المجلدات"
echo ""

# بدء الخدمات
echo "🚀 بدء تشغيل الخدمات..."
echo "🚀 Starting services..."
echo ""

docker-compose --profile $PROFILE up -d

echo ""
echo "⏳ انتظار بدء الخدمات..."
sleep 8

# عرض الحالة
echo ""
echo "📊 حالة الكونتينرات:"
echo "📊 Container status:"
docker-compose --profile $PROFILE ps

echo ""
echo "=============================================="
echo "✅ تم التنصيب بنجاح!"
echo "✅ Installation completed successfully!"
echo "=============================================="
echo ""

if [ "$PROFILE" = "quick-tunnel" ]; then
    echo "🔗 للحصول على رابط HTTPS الخاص بك:"
    echo "🔗 To get your HTTPS URL:"
    echo ""
    echo "   docker-compose logs cloudflared-quick-tunnel"
    echo ""
    echo "   ابحث عن سطر مثل:"
    echo "   Look for a line like:"
    echo "   https://random-name.trycloudflare.com"
    echo ""
    echo "📝 لعرض الرابط الآن:"
    echo "📝 To show the URL now:"
    echo ""
    docker-compose logs cloudflared-quick-tunnel 2>&1 | grep -i "https://" | tail -1 || echo "   جاري الاتصال... استخدم الأمر أعلاه بعد ثوان / Connecting... use command above in a few seconds"
else
    echo "🌐 يمكنك الآن الوصول إلى n8n عبر:"
    echo "🌐 You can now access n8n at:"
    echo "   https://$N8N_HOST"
fi

echo ""
echo "🔑 بيانات الدخول:"
echo "🔑 Login credentials:"
echo "   User: $N8N_USER"
echo "   Password: [المحفوظة في .env / Saved in .env]"
echo ""
echo "📝 لمشاهدة السجلات:"
echo "📝 To view logs:"
echo "   docker-compose --profile $PROFILE logs -f"
echo ""
echo "🛑 لإيقاف الخدمات:"
echo "🛑 To stop services:"
echo "   docker-compose --profile $PROFILE down"
echo ""
echo "=============================================="
