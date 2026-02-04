#!/bin/bash

# ==================================================
# تحميل صور Docker مسبقاً
# Pre-download Docker Images
# ==================================================

set -e

echo "=============================================="
echo "تحميل صور Docker (n8n + Cloudflare)"
echo "Downloading Docker Images (n8n + Cloudflare)"
echo "=============================================="
echo ""

# التحقق من Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker غير مثبت!"
    echo "❌ Docker is not installed!"
    echo ""
    echo "يرجى تشغيل install-requirements.sh أولاً"
    echo "Please run install-requirements.sh first"
    exit 1
fi

echo "✅ Docker مثبت ويعمل"
echo ""

# 🆕 التحقق من ملف offline أولاً
if [ -f "n8n-images.tar.gz" ] || [ -f "n8n-images.tar" ]; then
    echo "=============================================="
    echo "🎉 تم العثور على ملف الصور Offline!"
    echo "🎉 Found offline images file!"
    echo "=============================================="
    echo ""
    echo "⚡ سيتم التحميل من الملف المحلي (أسرع بكثير!)"
    echo "⚡ Will load from local file (much faster!)"
    echo ""
    
    if [ -f "load-images.sh" ]; then
        ./load-images.sh
        exit 0
    else
        echo "⚠️  load-images.sh not found, loading manually..."
        if [ -f "n8n-images.tar.gz" ]; then
            gunzip -c n8n-images.tar.gz | docker load
        else
            docker load -i n8n-images.tar
        fi
        echo "✅ Images loaded from offline file!"
        exit 0
    fi
fi

echo "ℹ️  لم يتم العثور على ملف offline"
echo "ℹ️  No offline file found"
echo ""
echo "📡 سيتم التحميل من الإنترنت..."
echo "📡 Will download from internet..."
echo ""

# الصور المطلوبة
IMAGES=(
    "n8nio/n8n:latest"
    "cloudflare/cloudflared:latest"
)

echo "📦 الصور المطلوبة:"
echo "📦 Required images:"
for img in "${IMAGES[@]}"; do
    echo "   - $img"
done
echo ""

# التحقق من الصور الموجودة
echo "🔍 التحقق من الصور الموجودة..."
echo "🔍 Checking existing images..."
echo ""

NEED_DOWNLOAD=0
for img in "${IMAGES[@]}"; do
    if docker image inspect $img &> /dev/null; then
        echo "✅ $img - موجود مسبقاً"
        echo "   Already downloaded"
    else
        echo "⬇️  $img - سيتم التحميل"
        echo "   Will be downloaded"
        NEED_DOWNLOAD=1
    fi
done
echo ""

if [ $NEED_DOWNLOAD -eq 0 ]; then
    echo "=============================================="
    echo "✅ جميع الصور محملة مسبقاً!"
    echo "✅ All images already downloaded!"
    echo "=============================================="
    echo ""
    echo "يمكنك الآن تشغيل:"
    echo "You can now run:"
    echo "  ./quick-start.sh"
    echo ""
    exit 0
fi

# تحميل الصور
echo "=============================================="
echo "🚀 بدء التحميل..."
echo "🚀 Starting download..."
echo "=============================================="
echo ""
echo "⏱️  هذا قد يستغرق 5-10 دقائق حسب سرعة الإنترنت"
echo "⏱️  This may take 5-10 minutes depending on internet speed"
echo ""

TOTAL=${#IMAGES[@]}
CURRENT=0

for img in "${IMAGES[@]}"; do
    CURRENT=$((CURRENT + 1))
    
    if docker image inspect $img &> /dev/null; then
        echo "[$CURRENT/$TOTAL] ⏭️  تخطي $img (موجود)"
        echo "        Skipping (already exists)"
        continue
    fi
    
    echo "[$CURRENT/$TOTAL] ⬇️  تحميل $img..."
    echo "        Downloading..."
    echo ""
    
    docker pull $img
    
    echo ""
    echo "[$CURRENT/$TOTAL] ✅ اكتمل تحميل $img"
    echo ""
done

echo "=============================================="
echo "✅ اكتمل تحميل جميع الصور!"
echo "✅ All images downloaded successfully!"
echo "=============================================="
echo ""

# عرض حجم الصور
echo "📊 حجم الصور المحملة:"
echo "📊 Downloaded images size:"
echo ""
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | grep -E "n8nio/n8n|cloudflare/cloudflared"
echo ""

echo "=============================================="
echo "🎉 جاهز للتشغيل!"
echo "🎉 Ready to run!"
echo "=============================================="
echo ""
echo "الخطوة التالية:"
echo "Next step:"
echo "  ./quick-start.sh"
echo ""
