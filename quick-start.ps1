# ================================================
# برنامج بدء سريع لـ n8n مع Cloudflare Tunnel (ويندوز)
# Quick Start Script for n8n with Cloudflare Tunnel (Windows)
# ================================================

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "تنصيب n8n مع Cloudflare Tunnel" -ForegroundColor Cyan
Write-Host "n8n with Cloudflare Tunnel Setup" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# التحقق من Docker
Write-Host "🔍 التحقق من تثبيت Docker..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    docker-compose --version | Out-Null
    Write-Host "✅ Docker و Docker Compose مثبتان" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker أو Docker Compose غير مثبت. يرجى تثبيتهما أولاً." -ForegroundColor Red
    Write-Host "❌ Docker or Docker Compose is not installed. Please install them first." -ForegroundColor Red
    exit 1
}
Write-Host ""

# التحقق من ملف .env
if (-Not (Test-Path .env)) {
    Write-Host "⚠️  ملف .env غير موجود" -ForegroundColor Yellow
    Write-Host "⚠️  .env file not found" -ForegroundColor Yellow
    Write-Host ""
    
    if (Test-Path .env.example) {
        Write-Host "هل تريد إنشاء ملف .env من النموذج؟" -ForegroundColor Yellow
        Write-Host "Do you want to create .env from template?" -ForegroundColor Yellow
        $confirm = Read-Host "اضغط Enter للمتابعة أو Ctrl+C للإلغاء / Press Enter to continue or Ctrl+C to cancel"
        
        Copy-Item .env.example .env
        Write-Host "✅ تم نسخ .env.example إلى .env" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  يجب عليك الآن تعديل ملف .env وملء جميع المعلومات المطلوبة!" -ForegroundColor Yellow
        Write-Host "⚠️  You MUST now edit the .env file and fill in all required information!" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "افتح ملف .env وأكمل التالي:" -ForegroundColor Cyan
        Write-Host "Open .env file and complete the following:" -ForegroundColor Cyan
        Write-Host "  1. N8N_HOST (مثل: n8n.yourdomain.com)"
        Write-Host "  2. WEBHOOK_URL (مثل: https://n8n.yourdomain.com)"
        Write-Host "  3. N8N_USER (اسم المستخدم)"
        Write-Host "  4. N8N_PASSWORD (كلمة مرور قوية)"
        Write-Host "  5. CLOUDFLARE_TUNNEL_TOKEN (توكن من Cloudflare)"
        Write-Host ""
        
        # فتح الملف للتحرير
        notepad .env
        
        $confirm = Read-Host "اضغط Enter بعد الانتهاء من تعديل .env / Press Enter after editing .env"
    } else {
        Write-Host "❌ ملف .env.example غير موجود!" -ForegroundColor Red
        Write-Host "❌ .env.example file not found!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ ملف .env موجود" -ForegroundColor Green
Write-Host ""

# قراءة المتغيرات من .env
$envVars = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)$') {
        $envVars[$matches[1].Trim()] = $matches[2].Trim()
    }
}

# التحقق من التوكن
if (-Not $envVars.ContainsKey("CLOUDFLARE_TUNNEL_TOKEN") -or 
    $envVars["CLOUDFLARE_TUNNEL_TOKEN"] -eq "your_tunnel_token_here") {
    Write-Host "❌ خطأ: لم يتم تعيين CLOUDFLARE_TUNNEL_TOKEN في ملف .env" -ForegroundColor Red
    Write-Host "❌ Error: CLOUDFLARE_TUNNEL_TOKEN not set in .env" -ForegroundColor Red
    Write-Host ""
    Write-Host "يرجى:" -ForegroundColor Yellow
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "  1. اذهب إلى Cloudflare Dashboard"
    Write-Host "  2. Zero Trust → Networks → Tunnels"
    Write-Host "  3. أنشئ نفق جديد واحصل على التوكن"
    Write-Host "  4. ضع التوكن في ملف .env"
    exit 1
}

# التحقق من كلمة المرور
if ($envVars["N8N_PASSWORD"] -eq "change_this_to_a_strong_password") {
    Write-Host "⚠️  تحذير: لم تقم بتغيير كلمة المرور الافتراضية!" -ForegroundColor Yellow
    Write-Host "⚠️  Warning: You haven't changed the default password!" -ForegroundColor Yellow
    Write-Host ""
    $confirm = Read-Host "هل تريد المتابعة على أي حال؟ (y/n)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        exit 1
    }
}

# إنشاء المجلدات
Write-Host "📁 إنشاء المجلدات المطلوبة..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "n8n-data" | Out-Null
New-Item -ItemType Directory -Force -Path "cloudflare" | Out-Null
Write-Host "✅ تم إنشاء المجلدات" -ForegroundColor Green
Write-Host ""

# بدء الخدمات
Write-Host "🚀 بدء تشغيل الخدمات..." -ForegroundColor Yellow
Write-Host "🚀 Starting services..." -ForegroundColor Yellow
Write-Host ""

docker-compose up -d

Write-Host ""
Write-Host "⏳ انتظار بدء الخدمات..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# عرض الحالة
Write-Host ""
Write-Host "📊 حالة الكونتينرات:" -ForegroundColor Cyan
Write-Host "📊 Container status:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host "✅ تم التنصيب بنجاح!" -ForegroundColor Green
Write-Host "✅ Installation completed successfully!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 يمكنك الآن الوصول إلى n8n عبر:" -ForegroundColor Cyan
Write-Host "🌐 You can now access n8n at:" -ForegroundColor Cyan
Write-Host "   https://$($envVars['N8N_HOST'])" -ForegroundColor White
Write-Host ""
Write-Host "🔑 بيانات الدخول:" -ForegroundColor Cyan
Write-Host "🔑 Login credentials:" -ForegroundColor Cyan
Write-Host "   User: $($envVars['N8N_USER'])" -ForegroundColor White
Write-Host "   Password: [المحفوظة في .env / Saved in .env]" -ForegroundColor White
Write-Host ""
Write-Host "📝 لمشاهدة السجلات:" -ForegroundColor Cyan
Write-Host "📝 To view logs:" -ForegroundColor Cyan
Write-Host "   docker-compose logs -f" -ForegroundColor White
Write-Host ""
Write-Host "🛑 لإيقاف الخدمات:" -ForegroundColor Cyan
Write-Host "🛑 To stop services:" -ForegroundColor Cyan
Write-Host "   docker-compose down" -ForegroundColor White
Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
