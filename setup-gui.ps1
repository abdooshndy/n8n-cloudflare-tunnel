<#
.SYNOPSIS
    n8n Easy Setup GUI
    واجهة رسومية لتنصيب وإعداد n8n بسهولة
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==========================================
# تهيئة النموذج (Form)
# ==========================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "n8n Easy Setup for Windows"
$form.Size = New-Object System.Drawing.Size(600, 750)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::White

# خطوط وألوان
$headerFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$labelFont = New-Object System.Drawing.Font("Segoe UI", 10)
$inputFont = New-Object System.Drawing.Font("Segoe UI", 10)
$primaryColor = [System.Drawing.Color]::FromArgb(255, 10, 112, 221) # n8n Blue-ish

# ==========================================
# العنوان
# ==========================================
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "n8n + Cloudflare Tunnel Setup"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $primaryColor
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($titleLabel)

$subTitleLabel = New-Object System.Windows.Forms.Label
$subTitleLabel.Text = "إعداد تلقائي وسهل | Automated Easy Setup"
$subTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$subTitleLabel.ForeColor = [System.Drawing.Color]::Gray
$subTitleLabel.AutoSize = $true
$subTitleLabel.Location = New-Object System.Drawing.Point(22, 50)
$form.Controls.Add($subTitleLabel)

# ==========================================
# قسم الإعدادات (Configuration)
# ==========================================
$groupBoxConfig = New-Object System.Windows.Forms.GroupBox
$groupBoxConfig.Text = "Configuration | الإعدادات"
$groupBoxConfig.Font = $headerFont
$groupBoxConfig.Location = New-Object System.Drawing.Point(20, 80)
$groupBoxConfig.Size = New-Object System.Drawing.Size(540, 380)
$form.Controls.Add($groupBoxConfig)

# ---- Username ----
$lblUser = New-Object System.Windows.Forms.Label
$lblUser.Text = "Username (اسم المستخدم):"
$lblUser.Font = $labelFont
$lblUser.Location = New-Object System.Drawing.Point(20, 40)
$lblUser.AutoSize = $true
$groupBoxConfig.Controls.Add($lblUser)

$txtUser = New-Object System.Windows.Forms.TextBox
$txtUser.Text = "admin"
$txtUser.Font = $inputFont
$txtUser.Location = New-Object System.Drawing.Point(20, 65)
$txtUser.Size = New-Object System.Drawing.Size(240, 30)
$groupBoxConfig.Controls.Add($txtUser)

# ---- Password ----
$lblPass = New-Object System.Windows.Forms.Label
$lblPass.Text = "Password (كلمة المرور):"
$lblPass.Font = $labelFont
$lblPass.Location = New-Object System.Drawing.Point(280, 40)
$lblPass.AutoSize = $true
$groupBoxConfig.Controls.Add($lblPass)

$txtPass = New-Object System.Windows.Forms.TextBox
$txtPass.Font = $inputFont
$txtPass.Location = New-Object System.Drawing.Point(280, 65)
$txtPass.Size = New-Object System.Drawing.Size(240, 30)
# $txtPass.PasswordChar = "*" # Uncomment to hide password
$groupBoxConfig.Controls.Add($txtPass)

# ---- Tunnel Type ----
$lblTunnel = New-Object System.Windows.Forms.Label
$lblTunnel.Text = "Tunnel Type (نوع الاتصال):"
$lblTunnel.Font = $labelFont
$lblTunnel.Location = New-Object System.Drawing.Point(20, 110)
$lblTunnel.AutoSize = $true
$groupBoxConfig.Controls.Add($lblTunnel)

$radioQuick = New-Object System.Windows.Forms.RadioButton
$radioQuick.Text = "Quick Tunnel (Free, No Domain)"
$radioQuick.Font = $labelFont
$radioQuick.Location = New-Object System.Drawing.Point(30, 135)
$radioQuick.Size = New-Object System.Drawing.Size(400, 30)
$radioQuick.Checked = $true
$groupBoxConfig.Controls.Add($radioQuick)

$radioNamed = New-Object System.Windows.Forms.RadioButton
$radioNamed.Text = "Named Tunnel (Custom Domain)"
$radioNamed.Font = $labelFont
$radioNamed.Location = New-Object System.Drawing.Point(30, 165)
$radioNamed.Size = New-Object System.Drawing.Size(400, 30)
$groupBoxConfig.Controls.Add($radioNamed)

# ---- Advanced Settings (Hidden by default or managed by logic) ----
$lblToken = New-Object System.Windows.Forms.Label
$lblToken.Text = "Cloudflare Token:"
$lblToken.Font = $labelFont
$lblToken.Location = New-Object System.Drawing.Point(20, 200)
$lblToken.AutoSize = $true
$lblToken.Enabled = $false
$groupBoxConfig.Controls.Add($lblToken)

$txtToken = New-Object System.Windows.Forms.TextBox
$txtToken.Font = $inputFont
$txtToken.Location = New-Object System.Drawing.Point(20, 225)
$txtToken.Size = New-Object System.Drawing.Size(500, 30)
$txtToken.Enabled = $false
$groupBoxConfig.Controls.Add($txtToken)

$lblDomain = New-Object System.Windows.Forms.Label
$lblDomain.Text = "Domain (e.g. n8n.example.com):"
$lblDomain.Font = $labelFont
$lblDomain.Location = New-Object System.Drawing.Point(20, 260)
$lblDomain.AutoSize = $true
$lblDomain.Enabled = $false
$groupBoxConfig.Controls.Add($lblDomain)

$txtDomain = New-Object System.Windows.Forms.TextBox
$txtDomain.Font = $inputFont
$txtDomain.Location = New-Object System.Drawing.Point(20, 285)
$txtDomain.Size = New-Object System.Drawing.Size(500, 30)
$txtDomain.Enabled = $false
$groupBoxConfig.Controls.Add($txtDomain)

# Event Handler for Radio Buttons
$radioQuick.Add_CheckedChanged({
    $txtToken.Enabled = $false
    $lblToken.Enabled = $false
    $txtDomain.Enabled = $false
    $lblDomain.Enabled = $false
    $txtToken.Text = ""
    $txtDomain.Text = ""
})

$radioNamed.Add_CheckedChanged({
    $txtToken.Enabled = $true
    $lblToken.Enabled = $true
    $txtDomain.Enabled = $true
    $lblDomain.Enabled = $true
})

# ==========================================
# أزرار التحكم (Actions)
# ==========================================
$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "1. Save Settings | حفظ الإعدادات"
$btnSave.Font = $labelFont
$btnSave.Location = New-Object System.Drawing.Point(20, 325)
$btnSave.Size = New-Object System.Drawing.Size(500, 40)
$btnSave.BackColor = [System.Drawing.Color]::LightGray
$groupBoxConfig.Controls.Add($btnSave)

$btnDownload = New-Object System.Windows.Forms.Button
$btnDownload.Text = "2. Download Images | تحميل الملفات"
$btnDownload.Font = $labelFont
$btnDownload.Location = New-Object System.Drawing.Point(20, 480)
$btnDownload.Size = New-Object System.Drawing.Size(260, 50)
$form.Controls.Add($btnDownload)

$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "3. START n8n | تشغيل"
$btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnStart.Location = New-Object System.Drawing.Point(290, 480)
$btnStart.Size = New-Object System.Drawing.Size(270, 50)
$btnStart.BackColor = $primaryColor
$btnStart.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($btnStart)

$btnGetUrl = New-Object System.Windows.Forms.Button
$btnGetUrl.Text = "4. Get URL | الحصول على الرابط"
$btnGetUrl.Font = $labelFont
$btnGetUrl.Location = New-Object System.Drawing.Point(20, 540)
$btnGetUrl.Size = New-Object System.Drawing.Size(540, 40)
$form.Controls.Add($btnGetUrl)

$btnStop = New-Object System.Windows.Forms.Button
$btnStop.Text = "Stop n8n | إيقاف"
$btnStop.Font = $labelFont
$btnStop.Location = New-Object System.Drawing.Point(20, 590)
$btnStop.Size = New-Object System.Drawing.Size(540, 40)
$btnStop.ForeColor = [System.Drawing.Color]::Red
$form.Controls.Add($btnStop)

# ==========================================
# الحالة (Status Bar)
# ==========================================
$statusStrip = New-Object System.Windows.Forms.StatusStrip
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.Text = "Ready..."
$statusStrip.Items.Add($statusLabel)
$form.Controls.Add($statusStrip)

# ==========================================
# وظائف (Functions)
# ==========================================

function Update-Status ($text) {
    $statusLabel.Text = $text
    $form.Refresh()
}

$btnSave.Add_Click({
    Update-Status "Saving configuration..."
    
    # Validation
    if ([string]::IsNullOrWhiteSpace($txtPass.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a password!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    if ($radioNamed.Checked) {
        if ([string]::IsNullOrWhiteSpace($txtToken.Text) -or [string]::IsNullOrWhiteSpace($txtDomain.Text)) {
            [System.Windows.Forms.MessageBox]::Show("Token and Domain are required for Named Tunnel!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    }

    # Prepare .env content
    $envContent = @"
# Generated by Easy Setup GUI
N8N_USER=$($txtUser.Text)
N8N_PASSWORD=$($txtPass.Text)
TIMEZONE=Africa/Cairo

"@

    if ($radioQuick.Checked) {
        $envContent += @"
# Quick Tunnel Mode
N8N_HOST=quick-tunnel
WEBHOOK_URL=http://localhost

"@
    } else {
        $envContent += @"
# Named Tunnel Mode
N8N_HOST=$($txtDomain.Text)
WEBHOOK_URL=https://$($txtDomain.Text)
CLOUDFLARE_TUNNEL_TOKEN=$($txtToken.Text)

"@
    }

    $envContent | Out-File -FilePath ".env" -Encoding UTF8
    [System.Windows.Forms.MessageBox]::Show("Configuration saved successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    Update-Status "Configuration saved."
})

$btnDownload.Add_Click({
    Update-Status "Downloading images... (Check console)"
    Start-Process powershell -ArgumentList "-NoExit", "-File", ".\download-images.ps1"
    Update-Status "Download started in new window."
})

$btnStart.Add_Click({
    Update-Status "Starting n8n..."
    
    if (-not (Test-Path ".env")) {
        [System.Windows.Forms.MessageBox]::Show("Please save settings first!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $profile = "quick-tunnel"
    if ($radioNamed.Checked) { $profile = "named-tunnel" }

    # Command to start docker-compose
    $cmd = "docker-compose --profile $profile up -d"
    
    Start-Process powershell -ArgumentList "-Command", $cmd
    
    [System.Windows.Forms.MessageBox]::Show("Services starting! Wait 10-20 seconds then click 'Get URL'", "Info", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    Update-Status "Services starting..."
})

$btnGetUrl.Add_Click({
    Update-Status "Getting URL..."
    Start-Process powershell -ArgumentList "-NoExit", "-File", ".\get-url.ps1"
    Update-Status "Check the popup window for URL"
})

$btnStop.Add_Click({
    Update-Status "Stopping services..."
    Start-Process powershell -ArgumentList "-Command", "docker-compose down"
    Update-Status "Stop command sent."
})

# ==========================================
# تشغيل النموذج
# ==========================================
$form.ShowDialog()
