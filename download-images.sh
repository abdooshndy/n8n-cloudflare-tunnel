#!/bin/bash

# ==================================================
# تجهيز صورة Docker
# Prepare Docker Image
# ==================================================

echo "=============================================="
echo "تجهيز صورة n8n المدمجة"
echo "Preparing Bundled n8n Image"
echo "=============================================="
echo ""

# Check if image exists
if docker image inspect n8n-custom:latest >/dev/null 2>&1; then
    echo "✅ Image n8n-custom:latest already exists."
    exit 0
fi

# Check for offline file
if [ -f "n8n-images.tar.gz" ]; then
    echo "🎉 Found offline package: n8n-images.tar.gz"
    echo "⚡ Loading images locally..."
    tar -xzf n8n-images.tar.gz -O | docker load
    echo "✅ Offline images loaded."
else
    echo "🔨 Building image locally (Internet required)..."
    echo "This may take 5-10 minutes..."
    echo ""
    docker build -t n8n-custom:latest .
fi

echo ""
echo "✅ Done!"
