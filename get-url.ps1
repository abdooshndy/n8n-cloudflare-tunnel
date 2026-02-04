# ================================================
# سكريبت للحصول على رابط Quick Tunnel (ويندوز)
# Script to get Quick Tunnel URL (Windows)
# ================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "🔗 جاري البحث عن رابط Cloudflare Quick Tunnel..." -ForegroundColor Yellow
Write-Host "🔗 Searching for Cloudflare Quick Tunnel URL..." -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من تشغيل الكونتينر
$containerRunning = docker ps --filter "name=cloudflared-quick-tunnel" --format "{{.Names}}"

if (-Not $containerRunning) {
    Write-Host "❌ الكونتينر غير مشغل!" -ForegroundColor Red
    Write-Host "❌ Container is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "شغّل الخدمات أولاً:" -ForegroundColor Yellow
    Write-Host "Start the services first:" -ForegroundColor Yellow
    Write-Host "  docker-compose --profile quick-tunnel up -d" -ForegroundColor White
    exit 1
}

Write-Host "✅ الكونتينر مشغل، جاري استخراج الرابط..." -ForegroundColor Green
Write-Host "✅ Container is running, extracting URL..." -ForegroundColor Green
Write-Host ""

# انتظار قليل للتأكد من الاتصال
Start-Sleep -Seconds 2

# استخراج الرابط
$logs = docker-compose logs cloudflared-quick-tunnel 2>&1 | Out-String
$URL = [regex]::Match($logs, 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com').Value

if (-Not $URL) {
    Write-Host "⏳ لم يتم العثور على الرابط بعد. جاري الانتظار..." -ForegroundColor Yellow
    Write-Host "⏳ URL not found yet. Waiting..." -ForegroundColor Yellow
    Write-Host ""
    Start-Sleep -Seconds 5
    $logs = docker-compose logs cloudflared-quick-tunnel 2>&1 | Out-String
    $URL = [regex]::Match($logs, 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com').Value
}

if (-Not $URL) {
    Write-Host "❌ لم يتم العثور على الرابط." -ForegroundColor Red
    Write-Host "❌ URL not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "جرب مراجعة السجلات يدوياً:" -ForegroundColor Yellow
    Write-Host "Try checking logs manually:" -ForegroundColor Yellow
    Write-Host "  docker-compose logs cloudflared-quick-tunnel" -ForegroundColor White
    exit 1
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "✅ تم العثور على الرابط!" -ForegroundColor Green
Write-Host "✅ URL Found!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 رابط n8n الخاص بك:" -ForegroundColor Cyan
Write-Host "🌐 Your n8n URL:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   $URL" -ForegroundColor White
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 انسخ هذا الرابط واستخدمه للوصول إلى n8n" -ForegroundColor Yellow
Write-Host "📋 Copy this URL and use it to access n8n" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔑 بيانات الدخول موجودة في ملف .env" -ForegroundColor Yellow
Write-Host "🔑 Login credentials are in .env file" -ForegroundColor Yellow
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
