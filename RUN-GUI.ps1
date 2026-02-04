# ================================================
# Direct PowerShell launcher for GUI
# مشغل مباشر للواجهة الرسومية
# ================================================

# تغيير المسار للمجلد الحالي
Set-Location $PSScriptRoot

# تشغيل الواجهة
try {
    & ".\setup-gui.ps1"
} catch {
    Write-Host "Error launching GUI:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
