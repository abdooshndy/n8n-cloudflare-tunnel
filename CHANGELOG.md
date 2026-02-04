# n8n with Cloudflare Tunnel - Changelog

## Version 1.3.1 (2026-02-05)

### 🛡️ Security Fixes (Windows)
- **Fix:** Windows "Mark of the Web" security block for downloaded batch files.
- **New:** `Start-n8n.bat` local launcher included in package.
- **Change:** `setup.html` now only downloads `.env` config file (safe).
- **Change:** Installation flow updated to be safer and more reliable.

## Version 1.3.0 (2026-02-05)

### 🌍 Hybrid Distribution & Web Setup
- **New:** Browser-based setup interface (`setup.html`).
- **New:** Hybrid Distribution System (Lite/Full editions).
- **New:** Offline installation support with `n8n-images.tar.gz`.
- **New:** GitHub repository integration.
- **Improvement:** Smart `download-images` script auto-detects offline files.

## Version 1.1.0 (2026-02-04)

### 🎨 Windows GUI
- **New:** PowerShell GUI (`setup-gui.ps1`).
- **New:** `n8n-Installer.bat` wrapper.
- **Fix:** Improved WSL detection and auto-fix.

## Version 1.0.0 (2026-02-04)

### ✨ Initial Release

#### Features
- ✅ Docker-based n8n deployment
- ✅ Cloudflare Tunnel integration with two modes:
  - Quick Tunnel (free, no domain needed)
  - Named Tunnel (with custom domain)
- ✅ Cross-platform support (Linux, macOS, Windows)
- ✅ Automated installation scripts
- ✅ Quick start scripts for easy deployment
- ✅ URL extraction utilities
- ✅ Comprehensive Arabic documentation

#### Files Included
- `docker-compose.yml` - Main Docker Compose configuration
- `.env.example` - Environment variables template
- `README.md` - Complete documentation (Arabic)
- `INSTALLATION.md` - Quick installation guide (Arabic)
- `install-requirements.sh` - Requirements installer (Linux/macOS)
- `quick-start.sh` - Quick start script (Linux/macOS)
- `quick-start.ps1` - Quick start script (Windows)
- `get-url.sh` - URL extractor (Linux/macOS)
- `get-url.ps1` - URL extractor (Windows)
- `.gitignore` - Git ignore rules

#### Security
- ✅ HTTPS encryption via Cloudflare
- ✅ Basic authentication enabled
- ✅ Sensitive files protected by .gitignore
- ✅ Local-only port binding (127.0.0.1:5678)

#### Requirements
- Docker 20.10+
- Docker Compose 1.29+
- Internet connection

---

## Roadmap

### Planned Features
- [ ] Multi-language support (English version)
- [ ] Backup automation scripts
- [ ] Health monitoring dashboard
- [ ] Custom domain SSL certificate management
- [ ] Database integration options (PostgreSQL)

---

## Support

For issues and feature requests, please refer to README.md
