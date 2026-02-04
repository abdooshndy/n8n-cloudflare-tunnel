@echo off
REM ==================================================
REM إصلاح مشكلة WSL - يجب تشغيله كـ Administrator
REM Fix WSL Issue - Must run as Administrator
REM ==================================================

chcp 65001 >nul
cls

echo ============================================
echo إصلاح Docker Desktop - WSL Update
echo Fixing Docker Desktop - WSL Update
echo ============================================
echo.

REM التحقق من صلاحيات Administrator
net session >nul 2>&1
if errorlevel 1 (
    echo ❌ يجب تشغيل هذا الملف كـ Administrator!
    echo ❌ This file must be run as Administrator!
    echo.
    echo كيفية التشغيل كـ Administrator:
    echo How to run as Administrator:
    echo.
    echo 1. انقر بالزر الأيمن على الملف
    echo    Right-click on the file
    echo.
    echo 2. اختر "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo ✅ تشغيل بصلاحيات Administrator
echo ✅ Running with Administrator privileges
echo.

echo 🔄 جاري تحديث WSL...
echo 🔄 Updating WSL...
echo.
echo يرجى الانتظار... قد يستغرق هذا بضع دقائق
echo Please wait... This may take a few minutes
echo.

REM تحديث WSL
wsl --update

if errorlevel 1 (
    echo.
    echo ❌ فشل تحديث WSL
    echo ❌ Failed to update WSL
    echo.
    echo جرب الحل اليدوي:
    echo Try manual solution:
    echo.
    echo 1. افتح PowerShell كـ Administrator
    echo 2. شغّل: wsl --install
    echo 3. ثم شغّل: wsl --update
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ تم تحديث WSL بنجاح!
echo ✅ WSL updated successfully!
echo.

echo 🔄 إعادة تشغيل WSL...
echo 🔄 Restarting WSL...
wsl --shutdown

echo.
echo ============================================
echo ✅ اكتمل الإصلاح!
echo ✅ Fix completed!
echo ============================================
echo.

echo الآن:
echo Now:
echo.
echo 1. أعد تشغيل Docker Desktop
echo    Restart Docker Desktop
echo.
echo 2. انتظر حتى يصبح جاهزاً
echo    Wait until it's ready
echo.
echo 3. شغّل START-WINDOWS.bat مرة أخرى
echo    Run START-WINDOWS.bat again
echo.

pause
