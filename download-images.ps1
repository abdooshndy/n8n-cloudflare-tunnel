# ==================================================
# تجهيز صورة Docker
# Prepare Docker Image
# ==================================================

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "تجهيز صورة n8n المدمجة" -ForegroundColor Cyan
Write-Host "Preparing Bundled n8n Image" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Check if image exists
docker image inspect n8n-custom:latest >$null 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Image n8n-custom:latest already exists." -ForegroundColor Green
    exit
}

# Check for offline file
if (Test-Path "n8n-images.tar.gz") {
    Write-Host "🎉 Found offline package: n8n-images.tar.gz" -ForegroundColor Green
    Write-Host "⚡ Loading images locally..." -ForegroundColor Yellow
    
    # Try direct load
    tar -xzf n8n-images.tar.gz -O | docker load
    
    Write-Host "✅ Offline images loaded." -ForegroundColor Green
} else {
    Write-Host "🔨 Building image locally (Internet required)..." -ForegroundColor Yellow
    Write-Host "This may take 5-10 minutes..." -ForegroundColor Yellow
    Write-Host ""
    
    docker build -t n8n-custom:latest .
}

Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green
Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
