Write-Host "============================================" -ForegroundColor Cyan
Write-Host "🌐 البحث عن رابط Quick Tunnel..." -ForegroundColor Cyan
Write-Host "🌐 Searching for Quick Tunnel URL..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$URL = docker logs n8n-bundled 2>&1 | Select-String -Pattern "https://[a-zA-Z0-9.-]*\.trycloudflare\.com" | Select-Object -Last 1

if (-not $URL) {
    Write-Host "❌ لم يتم العثور على الرابط بعد. انتظر قليلاً وحاول مرة أخرى." -ForegroundColor Red
    Write-Host "❌ URL not found yet. Please wait a moment and try again." -ForegroundColor Red
} else {
    Write-Host "✅ URL Found:" -ForegroundColor Green
    Write-Host ""
    Write-Host "   $URL" -ForegroundColor White
    Write-Host ""
}

Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
