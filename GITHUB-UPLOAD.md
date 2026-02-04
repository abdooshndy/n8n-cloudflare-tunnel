# 📤 رفع المشروع إلى GitHub

## 1. إنشاء المستودع (Repository)

1. اذهب إلى [GitHub.com](https://github.com/new)
2. أنشئ مستودع جديد باسم: `n8n-cloudflare-tunnel`
3. لا تقم بتهئته (لا تضف README أو .gitignore الآن)

## 2. رفع الكود (Lite Version)

افتح Terminal في مجلد المشروع ونفذ:

```bash
# 1. تهيئة Git
git init

# 2. إضافة الملفات
git add .

# 3. حفظ التغييرات
git commit -m "Initial commit: v1.3.0 Hybrid Edition"

# 4. إعادة تسمية الفرع الرئيسي
git branch -M main

# 5. ربط المستودع (استبدل الرابط برابط مستودعك)
git remote add origin https://github.com/USERNAME/n8n-cloudflare-tunnel.git

# 6. الرفع
git push -u origin main
```

## 3. رفع الصور (Full Version) عبر Releases

بما أن ملف `n8n-images.tar.gz` كبير (~400MB)، لا ينصح برفعه مباشرة مع الكود (GitHub يرفض الملفات > 100MB).

**الحل: استخدم GitHub Releases**

1. اذهب لصفحة المستودع على GitHub
2. اضغط **Releases** (يمين الصفحة)
3. اضغط **Draft a new release**
4. في العنوان اكتب: `v1.3.0`
5. في الوصف، انسخ محتوى `CHANGELOG.md`
6. في قسم **Attach binaries**:
   - اسحب وأفلت ملف `n8n-cloudflare-tunnel-v1.3.0-lite.tar.gz`
   - اسحب وأفلت ملف `n8n-cloudflare-tunnel-v1.3.0-full.tar.gz`
7. اضغط **Publish release**

---

## 🎯 النتيجة النهائية

سيكون لديك:
1. **الكود المصدري:** متاح للتصفح والتطوير على GitHub.
2. **صفحة Releases:** تحتوي على روابط تحميل مباشرة للنسختين (Lite و Full).
3. **رابط واحد:** يمكنك مشاركته مع الجميع!

---

## 💡 نصيحة

إذا كنت تريد رفع الصور للكود مباشرة (وليس Releases)، يجب استخدام **Git LFS**:

```bash
git lfs install
git lfs track "*.tar.gz"
git add .gitattributes
git commit -m "Setup Git LFS"
git add n8n-images.tar.gz
git commit -m "Add offline images"
git push origin main
```
*ملاحظة: Git LFS لديه حدود مجانية (1GB bandwidth/storage).*
