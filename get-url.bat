@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0get-url.ps1"
if errorlevel 1 pause
