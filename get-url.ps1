Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Search for Quick Tunnel URL..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Try to get URL directly from the log file inside the container
$URL = docker exec n8n-bundled grep -o "https://.*\.trycloudflare\.com" /tmp/cloudflared.log 2>$null | Select-Object -Last 1

if (-not $URL) {
    # Fallback to logs if exec fails (e.g. container down)
    $URL = docker logs n8n-bundled 2>&1 | Select-String -Pattern "https://[a-zA-Z0-9.-]*\.trycloudflare\.com" | Select-Object -Last 1
}

if (-not $URL) {
    Write-Host "URL not found yet. Please wait a moment and try again." -ForegroundColor Red
}
else {
    Write-Host "URL Found:" -ForegroundColor Green
    Write-Host ""
    Write-Host "   $URL" -ForegroundColor White
    Write-Host ""
    
    # Auto-copy to clipboard
    try {
        Set-Clipboard -Value $URL
        Write-Host "[OK] URL copied to clipboard!" -ForegroundColor Yellow
    }
    catch {
        # Fallback for older PowerShell
        $URL | clip
        Write-Host "[OK] URL copied to clipboard!" -ForegroundColor Yellow
    }
}

Write-Host ""
Read-Host "Press ENTER to close..."
