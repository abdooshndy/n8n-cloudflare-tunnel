# ================================================
# حفظ صور Docker (Windows)
# Save Docker Images (Windows)
# ================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "حفظ صور Docker" -ForegroundColor Cyan
Write-Host "Saving Docker Images" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من وجود الصور
Write-Host "🔍 Checking if images exist..." -ForegroundColor Yellow
$n8nExists = docker image inspect n8nio/n8n:latest 2>$null
if (-not $n8nExists) {
    Write-Host "⬇️  Pulling n8n image..." -ForegroundColor Yellow
    docker pull n8nio/n8n:latest
}

$cfExists = docker image inspect cloudflare/cloudflared:latest 2>$null
if (-not $cfExists) {
    Write-Host "⬇️  Pulling cloudflared image..." -ForegroundColor Yellow
    docker pull cloudflare/cloudflared:latest
}

Write-Host ""
Write-Host "📦 Saving images to file..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""

docker save n8nio/n8n:latest cloudflare/cloudflared:latest -o n8n-images.tar

# Compress with 7zip if available, otherwise inform user
if (Get-Command 7z -ErrorAction SilentlyContinue) {
    7z a -tgzip n8n-images.tar.gz n8n-images.tar
    Remove-Item n8n-images.tar
    $file = "n8n-images.tar.gz"
} else {
    Write-Host "ℹ️  7-Zip not found. File saved without compression." -ForegroundColor Yellow
    $file = "n8n-images.tar"
}

$size = (Get-Item $file).Length / 1MB
$sizeStr = "{0:N2} MB" -f $size

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "✅ Images saved successfully!" -ForegroundColor Green
Write-Host "✅ تم حفظ الصور بنجاح!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "📄 File: $file" -ForegroundColor White
Write-Host "📊 Size: $sizeStr" -ForegroundColor White
Write-Host ""
Write-Host "Now you can distribute this file!" -ForegroundColor Cyan
Write-Host "الآن يمكنك توزيع هذا الملف!" -ForegroundColor Cyan
Write-Host ""
