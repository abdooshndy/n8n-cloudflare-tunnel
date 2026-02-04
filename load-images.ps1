# ================================================
# تحميل صور Docker (Windows)
# Load Docker Images (Windows)
# ================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "تحميل صور Docker" -ForegroundColor Cyan
Write-Host "Loading Docker Images" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# البحث عن الملف
$tarFile = "n8n-images.tar"
$gzFile = "n8n-images.tar.gz"

if (Test-Path $gzFile) {
    Write-Host "📦 Found compressed file: $gzFile" -ForegroundColor Green
    Write-Host "Extracting..." -ForegroundColor Yellow
    
    if (Get-Command 7z -ErrorAction SilentlyContinue) {
        7z x $gzFile
        $tarFile = "n8n-images.tar"
    } else {
        Write-Host "❌ 7-Zip not found!" -ForegroundColor Red
        Write-Host "Please extract $gzFile manually or install 7-Zip" -ForegroundColor Yellow
        exit 1
    }
} elseif (Test-Path $tarFile) {
    Write-Host "📦 Found file: $tarFile" -ForegroundColor Green
} else {
    Write-Host "❌ File not found!" -ForegroundColor Red
    Write-Host "❌ الملف غير موجود!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Looking for: n8n-images.tar or n8n-images.tar.gz" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📦 Loading images from file..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""

docker load -i $tarFile

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "✅ Images loaded successfully!" -ForegroundColor Green
Write-Host "✅ تم تحميل الصور بنجاح!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 You can now start n8n:" -ForegroundColor Cyan
Write-Host "  .\quick-start.ps1" -ForegroundColor White
Write-Host ""
