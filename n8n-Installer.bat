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
echo ✅ If the page doesn't open, double-click setup.html
echo ✅ إذا لم تفتح الصفحة، انقر مرتين على setup.html
echo.
pause
