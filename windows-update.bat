@echo off
:: Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as administrator.
    echo Restarting with elevated privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Define EFI mount drive (changeable)
set "EFIDRIVE=Z:"

:: Check and mount EFI partition to %EFIDRIVE%
if exist %EFIDRIVE%\ (
    echo Drive %EFIDRIVE% already exists.
    if not exist %EFIDRIVE%\EFI\ (
        echo But it is NOT an EFI partition. Please unmount %EFIDRIVE% first.
        pause
        exit /b
    ) else (
        echo %EFIDRIVE% is already a valid EFI partition.
    )
) else (
    echo Mounting EFI partition to %EFIDRIVE% ...
    mountvol %EFIDRIVE% /S

    if not exist %EFIDRIVE%\EFI\ (
        echo Failed to mount EFI partition correctly on %EFIDRIVE%
        pause
        exit /b
    )
)

:: Change to the directory where this script is located
cd /d "%~dp0"

:: Copy the entire 'refind' folder into the EFI partition and overwrite all files without prompt
xcopy /E /Y refind Z:\EFI\refind\

echo.
echo Update complete.
pause