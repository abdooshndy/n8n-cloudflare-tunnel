@echo off
REM ==================================================
REM دليل البدء السريع - Windows
REM Quick Start Guide - Windows
REM ==================================================

chcp 65001 >nul
cls

echo ============================================
echo مرحباً في n8n مع Cloudflare Tunnel
echo Welcome to n8n with Cloudflare Tunnel
echo ============================================
echo.

REM التحقق من Docker Desktop
echo 📋 التحقق من متطلبات التشغيل...
echo 📋 Checking requirements...
echo.

REM فحص WSL أولاً
echo 🔍 التحقق من WSL...
echo 🔍 Checking WSL...
wsl --status >nul 2>&1
if errorlevel 1 (
    echo.
    echo ⚠️  WSL يحتاج تحديث أو تثبيت
    echo ⚠️  WSL needs update or installation
    echo.
    echo ⭐ حل تلقائي متاح!
    echo ⭐ Automatic fix available!
    echo.
    echo يرجى:
    echo Please:
    echo 1. أغلق هذه النافذة
    echo 2. انقر بالزر الأيمن على FIX-WSL.bat
    echo 3. اختر "Run as administrator"
    echo 4. انتظر حتى ينتهي
    echo 5. ثم شغّل هذا الملف مرة أخرى
    echo.
    pause
    exit /b 1
)

echo ✅ WSL جاهز
echo ✅ WSL is ready
echo.

docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop غير مثبت!
    echo ❌ Docker Desktop is not installed!
    echo.
    echo يرجى تثبيت Docker Desktop أولاً:
    echo Please install Docker Desktop first:
    echo.
    echo 1. افتح الرابط التالي:
    echo    https://www.docker.com/products/docker-desktop/
    echo.
    echo 2. حمّل Docker Desktop for Windows
    echo.
    echo 3. ثبّت البرنامج وأعد تشغيل الحاسوب
    echo.
    echo 4. شغّل Docker Desktop من قائمة Start
    echo.
    echo 5. انتظر حتى يصبح Docker Desktop جاهزاً
    echo.
    echo 6. ثم شغّل هذا الملف مرة أخرى
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop مثبت!
echo ✅ Docker Desktop is installed!
docker --version
echo.

REM التحقق من تشغيل Docker
docker ps >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Docker Desktop غير مشغل!
    echo ⚠️  Docker Desktop is not running!
    echo.
    echo يرجى:
    echo Please:
    echo.
    echo 1. شغّل Docker Desktop من قائمة Start
    echo 2. انتظر حتى يصبح جاهزاً (أيقونة Docker في الـ System Tray)
    echo 3. ثم شغّل هذا الملف مرة أخرى
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop يعمل!
echo ✅ Docker Desktop is running!
echo.

REM التحقق من ملف .env
if not exist .env (
    echo 📝 إنشاء ملف .env...
    echo 📝 Creating .env file...
    copy .env.example .env >nul
    echo ✅ تم إنشاء ملف .env
    echo.
    echo ⚠️  يرجى تعديل ملف .env وتغيير كلمة المرور!
    echo ⚠️  Please edit .env file and change the password!
    echo.
    notepad .env
    echo.
    echo اضغط أي زر بعد حفظ ملف .env...
    echo Press any key after saving .env...
    pause >nul
)

echo.
echo ============================================
echo ============================================
echo 🚀 جاهز للتشغيل!
echo 🚀 Ready to start!
echo ============================================
echo.
echo الطريقة الأسهل (GUI):
echo Easiest Way (GUI):
echo.
echo    انقر مرتين على n8n-Installer.bat
echo    Double click n8n-Installer.bat
echo.
echo ============================================
echo.
pause
