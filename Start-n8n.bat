@echo off
cd /d "%~dp0"
cls

echo ========================================================
echo n8n Launcher
echo ========================================================
echo.

:CHECK_CONFIG
REM 0. Auto-Rename Config
if exist "n8n.env" (
    echo [INFO] Found n8n.env, updating configuration...
    move /Y "n8n.env" ".env" >nul
)
if exist "env" (
    echo [INFO] Found env file, updating configuration...
    move /Y "env" ".env" >nul
)

REM 1. Check Configuration
if not exist ".env" (
    echo [ERROR] Configuration file .env not found!
    echo.
    echo 1. Opening setup page...
    start "" "setup.html"
    echo.
    echo 2. Please fill data and click "Download Configuration"
    echo 3. Save the .env file in this folder
    echo.
    echo [WAITING] Waiting for .env file...
    echo.
    pause
    cls
    goto CHECK_CONFIG
)

echo [OK] Configuration found (.env)
echo.

echo [INFO] Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Desktop is NOT running!
    echo Please start Docker Desktop first.
    pause
    exit /b
)

docker compose version >nul 2>&1
if not errorlevel 1 (
    set DOCKER_COMPOSE_CMD=docker compose
) else (
    set DOCKER_COMPOSE_CMD=docker-compose
)

echo [OK] Using: %DOCKER_COMPOSE_CMD%
echo.

echo [INFO] Checking images...
%DOCKER_COMPOSE_CMD% images -q n8n >nul 2>&1
if errorlevel 1 (
    if exist "n8n-images.tar.gz" (
        echo [INFO] Found offline package: n8n-images.tar.gz
        echo [INFO] Loading images locally...
        tar -xzf n8n-images.tar.gz -O | docker load
    ) else (
        echo [INFO] Building image locally - Internet required...
        echo This may take 5-10 minutes...
        %DOCKER_COMPOSE_CMD% build --no-cache
        if errorlevel 1 (
            echo [ERROR] Build failed! Check internet connection.
            pause
            exit /b
        )
    )
) else (
    echo [OK] Image ready.
)

echo.
echo [INFO] STARTING N8N...
echo.

%DOCKER_COMPOSE_CMD% up -d

if errorlevel 1 (
    echo [ERROR] Error starting containers.
    pause
    exit /b
)

echo [OK] System is running!
echo.

findstr /C:"N8N_HOST=quick-tunnel" .env >nul
if not errorlevel 1 (
    echo [INFO] Getting Quick Tunnel URL...
    echo Please wait...
    timeout /t 10 /nobreak >nul
    
    echo ========================================================
    echo Your n8n URL:
    echo ========================================================
    docker logs n8n-bundled 2>&1 | findstr "https://"
    echo ========================================================
) else (
    echo ========================================================
    echo Ready! Access via your domain.
    echo ========================================================
)

echo.
echo Press any key to close...
pause >nul
