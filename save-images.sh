#!/bin/bash

# ==================================================
# حفظ صور Docker كملف tar
# Save Docker images as tar file
# ==================================================

echo "=============================================="
echo "حفظ صور Docker"
echo "Saving Docker Images"
echo "=============================================="
echo ""

# التحقق من وجود الصور محلياً
echo "🔍 Checking if images exist..."
if ! docker image inspect n8nio/n8n:latest &> /dev/null; then
    echo "⬇️  Pulling n8n image..."
    docker pull n8nio/n8n:latest
fi

if ! docker image inspect cloudflare/cloudflared:latest &> /dev/null; then
    echo "⬇️  Pulling cloudflared image..."
    docker pull cloudflare/cloudflared:latest
fi

echo ""
echo "📦 Saving images to file..."
echo "This may take a few minutes..."
echo ""

docker save n8nio/n8n:latest cloudflare/cloudflared:latest | gzip > n8n-images.tar.gz

SIZE=$(du -h n8n-images.tar.gz | cut -f1)

echo ""
echo "=============================================="
echo "✅ Images saved successfully!"
echo "✅ تم حفظ الصور بنجاح!"
echo "=============================================="
echo ""
echo "📄 File: n8n-images.tar.gz"
echo "📊 Size: $SIZE"
echo ""
echo "Now you can distribute this file!"
echo "الآن يمكنك توزيع هذا الملف!"
echo ""
