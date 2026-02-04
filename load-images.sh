#!/bin/bash

# ==================================================
# تحميل صور Docker من ملف tar
# Load Docker images from tar file
# ==================================================

echo "=============================================="
echo "تحميل صور Docker"
echo "Loading Docker Images"
echo "=============================================="
echo ""

if [ ! -f "n8n-images.tar.gz" ]; then
    echo "❌ File n8n-images.tar.gz not found!"
    echo "❌ ملف n8n-images.tar.gz غير موجود!"
    echo ""
    echo "Please download n8n-images.tar.gz first."
    echo "يرجى تحميل ملف n8n-images.tar.gz أولاً."
    exit 1
fi

echo "📦 Loading images from file..."
echo "This may take a few minutes..."
echo ""

gunzip -c n8n-images.tar.gz | docker load

echo ""
echo "=============================================="
echo "✅ Images loaded successfully!"
echo "✅ تم تحميل الصور بنجاح!"
echo "=============================================="
echo ""
echo "🎉 You can now start n8n:"
echo "  ./quick-start.sh"
echo ""
