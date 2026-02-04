@echo off
REM ========================================================
REM n8n One-Click Launcher 🚀
REM ========================================================
chcp 65001 >nul
cd /d "%~dp0"
cls

echo ========================================================
echo n8n Launcher 🚀 (Single Container Edition)
echo ========================================================
echo.

REM 1. التحقق من ملف الإعدادات
if not exist ".env" (
    echo ❌ Configuration file (.env) not found!
    echo ❌ ملف الإعدادات غير موجود!
    echo.
    echo Please run 'n8n-Installer.bat' first.
    echo.
    pause
    exit /b
)

echo ✅ Configuration found (.env)
echo.

REM 2. التحقق من Docker
echo 🔍 Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is NOT running!
    echo ❌ يرجى تشغيل Docker Desktop أولاً.
    pause
    exit /b
)

REM 3. التعامل مع الصور (Hybrid Strategy)
echo 📦 Checking images...

REM تحقق هل الصورة موجودة بالفعل؟
docker image inspect n8n-custom:latest >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Image n8n-custom:latest not found.
    
    if exist "n8n-images.tar.gz" (
        echo 🎉 Found offline package: n8n-images.tar.gz
        echo ⚡ Loading images locally...
        tar -xzf n8n-images.tar.gz -O | docker load
        echo ✅ Offline images loaded.
    ) else (
        echo 🔨 Building image locally (Internet required)...
        echo This may take 5-10 minutes...
        docker build -t n8n-custom:latest .
    )
) else (
    echo ✅ Image exists.
)

REM 4. تشغيل الكونتينر
echo.
echo 🚀 STARTING N8N...
echo 🚀 جاري التشغيل...
echo.

docker-compose up -d

if errorlevel 1 (
    echo ❌ Error starting Docker Compose.
    pause
    exit /b
)

echo ✅ System is running!
echo.

REM 5. عرض الرابط (للوضع المجاني)
findstr /C:"N8N_HOST=quick-tunnel" .env >nul
if not errorlevel 1 (
    echo 🔗 Getting Quick Tunnel URL...
    echo.
    REM ننتظر قليلاً ليقوم السكريبت الداخلي بتوليد الرابط وحفظه
    timeout /t 10 /nobreak >nul
    
    echo ========================================================
    echo 🌐 Your n8n URL:
    echo ========================================================
    docker logs n8n-bundled 2>&1 | findstr "https://"
    echo ========================================================
) else (
    echo ========================================================
    echo ✅ Ready! Access via your domain.
    echo ========================================================
)

echo.
echo Press any key to close...
pause >nul
