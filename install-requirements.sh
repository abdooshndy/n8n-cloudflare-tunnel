#!/bin/bash

# ==================================================
# سكريبت تثبيت المتطلبات الأساسية
# Installation Script for Requirements
# ==================================================
# يقوم بتثبيت Docker و Docker Compose تلقائياً
# Automatically installs Docker and Docker Compose
# ==================================================

set -e

echo "=============================================="
echo "تثبيت المتطلبات الأساسية"
echo "Installing Required Dependencies"
echo "=============================================="
echo ""

# التحقق من نظام التشغيل
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "❌ نظام التشغيل غير مدعوم. استخدم Linux أو macOS"
    echo "❌ Unsupported OS. Use Linux or macOS"
    echo ""
    echo "لويندوز، قم بتحميل Docker Desktop يدوياً:"
    echo "For Windows, download Docker Desktop manually:"
    echo "https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# التحقق من الصلاحيات
if [ "$EUID" -eq 0 ]; then 
    echo "⚠️  لا تشغل هذا السكريبت بصلاحيات root"
    echo "⚠️  Don't run this script as root"
    echo ""
    echo "استخدم:"
    echo "Use:"
    echo "  ./install-requirements.sh"
    exit 1
fi

echo "📋 النظام المكتشف: $OS"
echo "📋 Detected OS: $OS"
echo ""

# تثبيت Docker على Linux
if [ "$OS" = "linux" ]; then
    echo "🔍 التحقق من تثبيت Docker..."
    if command -v docker &> /dev/null; then
        echo "✅ Docker مثبت مسبقاً"
        docker --version
    else
        echo "📦 تثبيت Docker..."
        echo ""
        echo "هل تريد تثبيت Docker؟ (y/n)"
        read -p "Do you want to install Docker? (y/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔄 جاري تحميل وتثبيت Docker..."
            curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
            sudo sh /tmp/get-docker.sh
            
            echo "👤 إضافة المستخدم الحالي لمجموعة docker..."
            sudo usermod -aG docker $USER
            
            echo "✅ تم تثبيت Docker بنجاح!"
            echo ""
            echo "⚠️  يجب إعادة تسجيل الدخول لتطبيق الصلاحيات"
            echo "⚠️  You need to log out and log back in for permissions to take effect"
            echo ""
            echo "أو استخدم الأمر:"
            echo "Or use the command:"
            echo "  newgrp docker"
        else
            echo "⏭️  تم تخطي تثبيت Docker"
        fi
    fi
    
    echo ""
    echo "🔍 التحقق من تثبيت Docker Compose..."
    if command -v docker-compose &> /dev/null; then
        echo "✅ Docker Compose مثبت مسبقاً"
        docker-compose --version
    else
        echo "📦 تثبيت Docker Compose..."
        echo ""
        echo "هل تريد تثبيت Docker Compose؟ (y/n)"
        read -p "Do you want to install Docker Compose? (y/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔄 جاري تثبيت Docker Compose..."
            sudo apt-get update
            sudo apt-get install -y docker-compose
            
            echo "✅ تم تثبيت Docker Compose بنجاح!"
        else
            echo "⏭️  تم تخطي تثبيت Docker Compose"
        fi
    fi
fi

# تعليمات لـ macOS
if [ "$OS" = "macos" ]; then
    echo "🍎 macOS مكتشف"
    echo ""
    
    if command -v docker &> /dev/null; then
        echo "✅ Docker Desktop مثبت مسبقاً"
        docker --version
    else
        echo "❌ Docker Desktop غير مثبت"
        echo ""
        echo "للتثبيت على macOS:"
        echo "To install on macOS:"
        echo ""
        echo "1. قم بتحميل Docker Desktop:"
        echo "   https://www.docker.com/products/docker-desktop/"
        echo ""
        echo "2. أو باستخدام Homebrew:"
        echo "   brew install --cask docker"
        echo ""
        echo "3. شغّل Docker Desktop من Applications"
    fi
fi

echo ""
echo "=============================================="
echo "✅ اكتمل فحص المتطلبات!"
echo "✅ Requirements check completed!"
echo "=============================================="
echo ""

# التحقق النهائي
echo "📊 الملخص النهائي:"
echo "📊 Final Summary:"
echo ""

if command -v docker &> /dev/null; then
    echo "✅ Docker: مثبت"
    echo "   Version: $(docker --version)"
else
    echo "❌ Docker: غير مثبت"
fi

if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose: مثبت"
    echo "   Version: $(docker-compose --version)"
else
    echo "❌ Docker Compose: غير مثبت"
fi

echo ""

if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    echo "🎉 جميع المتطلبات جاهزة!"
    echo "🎉 All requirements are ready!"
    echo ""
    echo "يمكنك الآن تشغيل:"
    echo "You can now run:"
    echo "  ./quick-start.sh"
else
    echo "⚠️  بعض المتطلبات مفقودة"
    echo "⚠️  Some requirements are missing"
    echo ""
    echo "يرجى تثبيت المتطلبات المفقودة قبل المتابعة"
    echo "Please install missing requirements before continuing"
fi

echo ""
echo "=============================================="
