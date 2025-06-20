@echo off
:: Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as administrator.
    echo Restarting with elevated privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Mount EFI partition to Z: if not already correctly mounted
if exist Z:\ (
    echo Drive Z: already exists.
    if not exist Z:\EFI\ (
        echo But it is NOT an EFI partition. Please unmount Z: first.
        pause
        exit /b
    ) else (
        echo Z: is already a valid EFI partition.
    )
) else (
    echo Mounting EFI partition to Z: ...
    mountvol Z: /S

    if not exist Z:\EFI\ (
        echo Failed to mount EFI partition correctly on Z:
        pause
        exit /b
    )
)

:: Generate timestamp (YYYY-MM-DD_HH-mm-ss)
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "TIMESTAMP=%%a"

:: Set working directory to script location
cd /d "%~dp0"

:: Create backup directory (backups\TIMESTAMP)
set "BACKUP_DIR=backups\%TIMESTAMP%"
mkdir "%BACKUP_DIR%"

:: Export BCD to fixed filename
bcdedit /export "%BACKUP_DIR%\bcdbackup.bcd"

:: Save firmware info as readable UTF-8 file
powershell -NoProfile -Command "bcdedit /enum firmware | Out-File -FilePath '%BACKUP_DIR%\bcdedit_output.txt' -Encoding UTF8"

echo.
echo Backup complete.
echo Files saved to: %BACKUP_DIR%

:: Only pause if not called in silent mode
if /i "%1" neq "silent" (
    pause
)
