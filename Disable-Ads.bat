@echo off
chcp 65001 >nul
:: Otomatik Yönetici Yetkisi İsteme
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: PowerShell Betiğini Çalıştır
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "WindowsDeBloat.ps1"