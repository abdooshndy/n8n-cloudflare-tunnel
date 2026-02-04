@echo off
REM ========================================================
REM n8n One-Click Launcher 🚀
REM ========================================================
chcp 65001 >nul
cd /d "%~dp0"
cls

echo ========================================================
echo n8n Launcher 🚀
echo ========================================================
echo.

:CHECK_CONFIG
REM 1. التحقق من ملف الإعدادات
if not exist ".env" (
    echo ❌ Configuration file (.env) not found!
    echo.
    echo 1. Opening setup page...
    start "" "setup.html"
    echo.
    echo 2. Please fill data and click "Download Configuration"
    echo 3. Save the .env file in this folder
    echo.
    echo [WAITING] Waiting for .env file...
    echo [انتظار] بانتظار تحميل ملف الإعدادات...
    echo.
    pause
    cls
    echo ========================================================
    echo n8n Launcher 🚀
    echo ========================================================
    echo.
    goto CHECK_CONFIG
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

REM تحديد أمر Docker Compose المناسب (V1 vs V2)
docker compose version >nul 2>&1
if not errorlevel 1 (
    set DOCKER_COMPOSE_CMD=docker compose
) else (
    set DOCKER_COMPOSE_CMD=docker-compose
)

echo ✅ Using: %DOCKER_COMPOSE_CMD%
echo.

REM 3. التعامل مع الصور
echo 📦 Checking images...

%DOCKER_COMPOSE_CMD% images -q n8n >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Image needs setup.
    
    if exist "n8n-images.tar.gz" (
        echo 🎉 Found offline package: n8n-images.tar.gz
        echo ⚡ Loading images locally...
        tar -xzf n8n-images.tar.gz -O | docker load
    ) else (
        echo 🔨 Building image locally (Internet required)...
        echo This may take 5-10 minutes...
        %DOCKER_COMPOSE_CMD% build --no-cache
        if errorlevel 1 (
            echo ❌ Build failed! Check internet connection.
            pause
            exit /b
        )
    )
) else (
    echo ✅ Image ready.
)

REM 4. تشغيل الكونتينر
echo.
echo 🚀 STARTING N8N...
echo 🚀 جاري التشغيل...
echo.

%DOCKER_COMPOSE_CMD% up -d

if errorlevel 1 (
    echo ❌ Error starting containers.
    pause
    exit /b
)

echo ✅ System is running!
echo.

REM 5. عرض الرابط
findstr /C:"N8N_HOST=quick-tunnel" .env >nul
if not errorlevel 1 (
    echo 🔗 Getting Quick Tunnel URL...
    echo Please wait...
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
