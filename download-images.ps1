# ================================================
# تحميل صور Docker مسبقاً (Windows)
# Pre-download Docker Images (Windows)
# ================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "تحميل صور Docker (n8n + Cloudflare)" -ForegroundColor Cyan
Write-Host "Downloading Docker Images (n8n + Cloudflare)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من Docker
try {
    docker --version | Out-Null
    Write-Host "✅ Docker مثبت ويعمل" -ForegroundColor Green
    Write-Host ""

# 🆕 التحقق من ملف offline أولاً
if ((Test-Path "n8n-images.tar.gz") -or (Test-Path "n8n-images.tar")) {
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "🎉 تم العثور على ملف الصور Offline!" -ForegroundColor Green
    Write-Host "🎉 Found offline images file!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚡ سيتم التحميل من الملف المحلي (أسرع بكثير!)" -ForegroundColor Yellow
    Write-Host "⚡ Will load from local file (much faster!)" -ForegroundColor Yellow
    Write-Host ""
    
    if (Test-Path "load-images.ps1") {
        & ".\load-images.ps1"
        exit 0
    } else {
        Write-Host "⚠️  load-images.ps1 not found, loading manually..." -ForegroundColor Yellow
        if (Test-Path "n8n-images.tar.gz") {
            # Need 7-Zip or manual extraction
            Write-Host "Please extract n8n-images.tar.gz first or run load-images.ps1" -ForegroundColor Yellow
            exit 1
        } else {
            docker load -i n8n-images.tar
        }
        Write-Host "✅ Images loaded from offline file!" -ForegroundColor Green
        exit 0
    }
}

Write-Host "ℹ️  لم يتم العثور على ملف offline" -ForegroundColor Yellow
Write-Host "ℹ️  No offline file found" -ForegroundColor Yellow
Write-Host ""
Write-Host "📡 سيتم التحميل من الإنترنت..." -ForegroundColor Yellow
Write-Host "📡 Will download from internet..." -ForegroundColor Yellow
Write-Host ""

} catch {
    Write-Host "❌ Docker غير مثبت أو لا يعمل!" -ForegroundColor Red
    Write-Host "❌ Docker is not installed or not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "يرجى:" -ForegroundColor Yellow
    Write-Host "1. تثبيت Docker Desktop"
    Write-Host "2. تشغيل Docker Desktop"
    Write-Host "3. ثم شغّل هذا السكريبت مرة أخرى"
    exit 1
}

# الصور المطلوبة
$images = @(
    "n8nio/n8n:latest",
    "cloudflare/cloudflared:latest"
)

Write-Host "📦 الصور المطلوبة:" -ForegroundColor Cyan
Write-Host "📦 Required images:" -ForegroundColor Cyan
foreach ($img in $images) {
    Write-Host "   - $img" -ForegroundColor White
}
Write-Host ""

# التحقق من الصور الموجودة
Write-Host "🔍 التحقق من الصور الموجودة..." -ForegroundColor Yellow
Write-Host "🔍 Checking existing images..." -ForegroundColor Yellow
Write-Host ""

$needDownload = $false
foreach ($img in $images) {
    $exists = docker image inspect $img 2>$null
    if ($exists) {
        Write-Host "✅ $img - موجود مسبقاً" -ForegroundColor Green
        Write-Host "   Already downloaded" -ForegroundColor Gray
    } else {
        Write-Host "⬇️  $img - سيتم التحميل" -ForegroundColor Yellow
        Write-Host "   Will be downloaded" -ForegroundColor Gray
        $needDownload = $true
    }
}
Write-Host ""

if (-not $needDownload) {
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "✅ جميع الصور محملة مسبقاً!" -ForegroundColor Green
    Write-Host "✅ All images already downloaded!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "يمكنك الآن تشغيل:" -ForegroundColor Cyan
    Write-Host "You can now run:" -ForegroundColor Cyan
    Write-Host "  .\quick-start.ps1" -ForegroundColor White
    Write-Host ""
    exit 0
}

# تحميل الصور
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "🚀 بدء التحميل..." -ForegroundColor Yellow
Write-Host "🚀 Starting download..." -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏱️  هذا قد يستغرق 5-10 دقائق حسب سرعة الإنترنت" -ForegroundColor Yellow
Write-Host "⏱️  This may take 5-10 minutes depending on internet speed" -ForegroundColor Yellow
Write-Host ""

$total = $images.Count
$current = 0

foreach ($img in $images) {
    $current++
    
    $exists = docker image inspect $img 2>$null
    if ($exists) {
        Write-Host "[$current/$total] ⏭️  تخطي $img (موجود)" -ForegroundColor Gray
        Write-Host "        Skipping (already exists)" -ForegroundColor Gray
        continue
    }
    
    Write-Host "[$current/$total] ⬇️  تحميل $img..." -ForegroundColor Yellow
    Write-Host "        Downloading..." -ForegroundColor Gray
    Write-Host ""
    
    docker pull $img
    
    Write-Host ""
    Write-Host "[$current/$total] ✅ اكتمل تحميل $img" -ForegroundColor Green
    Write-Host ""
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "✅ اكتمل تحميل جميع الصور!" -ForegroundColor Green
Write-Host "✅ All images downloaded successfully!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# عرض حجم الصور
Write-Host "📊 حجم الصور المحملة:" -ForegroundColor Cyan
Write-Host "📊 Downloaded images size:" -ForegroundColor Cyan
Write-Host ""
docker images --format "table {{.Repository}}:{{.Tag}}`t{{.Size}}" | Select-String -Pattern "n8nio/n8n|cloudflare/cloudflared"
Write-Host ""

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "🎉 جاهز للتشغيل!" -ForegroundColor Green
Write-Host "🎉 Ready to run!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "الخطوة التالية:" -ForegroundColor Yellow
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "  .\quick-start.ps1" -ForegroundColor White
Write-Host ""
