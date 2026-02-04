@echo off
REM ==================================================
REM n8n Easy Setup Launcher
REM مشغل إعداد n8n السهل
REM ==================================================

echo ============================================
echo n8n Easy Setup
echo إعداد n8n السهل
echo ============================================
echo.
echo Opening configuration page in browser...
echo جاري فتح صفحة الإعداد في المتصفح...
echo.

REM تغيير مسار العمل إلى مجلد السكريبت
cd /d "%~dp0"

REM فتح ملف HTML في المتصفح الافتراضي
start "" "setup.html"

echo.
echo ----------------------------------------------------
echo [IMPORTANT] AFTER YOU DOWNLOAD THE .env FILE:
echo [مهم] بعد تحميل ملف الإعدادات .env:
echo.
echo 1. Close the browser window
echo 1. أغلق المتصفح
echo.
echo 2. Run 'Start-n8n.bat' to start the system
echo 2. شغّل الملف 'Start-n8n.bat' لبدء النظام
echo ----------------------------------------------------
echo.
echo Press Enter to close this window...
pause >nul
