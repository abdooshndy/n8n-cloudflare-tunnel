@echo off
REM ========================================================
REM n8n One-Click Launcher 🚀
REM ========================================================
chcp 65001 >nul
cls

echo ========================================================
echo n8n Launcher 🚀
echo ========================================================
echo.

REM 1. التحقق من ملف الإعدادات
if not exist ".env" (
    echo ❌ Configuration file (.env) not found!
    echo ❌ ملف الإعدادات غير موجود!
    echo.
    echo Please run 'n8n-Installer.bat' or open 'setup.html' first,
    echo fill in your data, and click "Download .env".
    echo.
    echo يرجى فتح setup.html أولاً وتحميل ملف .env
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

REM 3. تحديد نوع Tunnel من ملف .env
findstr /C:"N8N_HOST=quick-tunnel" .env >nul
if errorlevel 1 (
    set PROFILE=named-tunnel
    echo 🔗 Mode: Named Tunnel
) else (
    set PROFILE=quick-tunnel
    echo 🔗 Mode: Quick Tunnel
)

REM 4. تحميل الصور (Hybrid Check)
echo.
echo 📦 Checking images...

if exist "n8n-images.tar.gz" (
    echo 🎉 Found offline images: n8n-images.tar.gz
    echo ⚡ Loading images locally...
    
    REM محاولة استخدام tar/docker مباشرة
    tar -xzf n8n-images.tar.gz -O | docker load >nul 2>&1
    if errorlevel 1 (
        echo ⚠️ Failed to load compressed file directly.
        echo Trying manual extraction...
        docker load -i n8n-images.tar >nul 2>&1
    )
    echo ✅ Offline images loaded.
) else (
    echo 📡 No offline file found. Checking Docker Hub...
    
    docker image inspect n8nio/n8n:latest >nul 2>&1
    if errorlevel 1 (
        echo ⬇️  Downloading n8n image...
        docker pull n8nio/n8n:latest
    )
    
    docker image inspect cloudflare/cloudflared:latest >nul 2>&1
    if errorlevel 1 (
        echo ⬇️  Downloading cloudflared image...
        docker pull cloudflare/cloudflared:latest
    )
)

REM 5. تشغيل n8n
echo.
echo 🚀 STARTING N8N...
echo 🚀 جاري التشغيل...
echo.

docker-compose --profile %PROFILE% up -d

if errorlevel 1 (
    echo ❌ Error starting Docker Compose.
    pause
    exit /b
)

echo ✅ System is running!
echo.

REM 6. عرض الرابط
if "%PROFILE%"=="quick-tunnel" (
    echo 🔗 Getting your URL...
    echo 🔗 جاري جلب الرابط (انتظر قليلاً)...
    timeout /t 10 /nobreak >nul

    echo.
    echo ========================================================
    echo 🌐 Your n8n URL:
    echo ========================================================
    echo.
    powershell -ExecutionPolicy Bypass -Command "docker-compose logs cloudflared-quick-tunnel 2>&1 | Select-String -Pattern 'https://[a-zA-Z0-9.-]*\\.trycloudflare\\.com' | Select-Object -Last 1"
    echo.
    echo ========================================================
    echo If URL not shown, run: .\get-url.ps1
) else (
    echo.
    echo ========================================================
    echo ✅ Done! Access n8n at your domain.
    echo ========================================================
)

echo.
echo Press any key to close...
pause >nul
