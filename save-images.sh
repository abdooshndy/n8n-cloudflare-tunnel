#!/bin/bash

# ==================================================
# حفظ صورة Docker المدمجة
# Save Bundled Docker Image
# ==================================================

echo "=============================================="
echo "حفظ صورة Docker المدمجة"
echo "Saving Bundled Docker Image"
echo "=============================================="
echo ""

# 1. Build the image first
echo "🔨 Building image..."
docker build -t n8n-custom:latest .

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""

# 2. Save the image
echo "📦 Saving image to n8n-images.tar.gz..."
echo "This may take a few minutes..."

docker save n8n-custom:latest | gzip > n8n-images.tar.gz

echo ""
echo "=============================================="
echo "✅ Image saved successfully!"
echo "✅ تم حفظ الصورة بنجاح!"
echo "=============================================="
echo ""
echo "📄 File: n8n-images.tar.gz"
du -h n8n-images.tar.gz
echo ""
