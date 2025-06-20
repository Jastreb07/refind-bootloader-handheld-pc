@echo off
setlocal EnableDelayedExpansion

:: --------------------------------------
:: Configuration
:: --------------------------------------
set "EFIDRIVE=Z:"
set "BOOTMGR_PATH=\EFI\refind\refind_x64.efi"
set "BOOTMGR_DESC=rEFInd"

:: --------------------------------------
:: Admin check
:: --------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as administrator.
    echo Restarting with elevated privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: --------------------------------------
:: Run backup first
:: --------------------------------------
echo Creating backup before installation...
call "%~dp0windows-backup.bat" silent
if %errorlevel% neq 0 (
    echo Backup failed or was aborted. Installation cancelled.
    pause
    exit /b
)

:: --------------------------------------
:: Mount EFI partition to %EFIDRIVE% (if not already mounted)
:: --------------------------------------
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

:: --------------------------------------
:: Theme selection
:: --------------------------------------
echo.
echo Available rEFInd themes:
set "THEME_INDEX=0"
for /d %%T in ("refind\themes\*") do (
    set /a THEME_INDEX+=1
    set "THEME_FOLDER[!THEME_INDEX!]=%%~nxT"
    echo !THEME_INDEX!^) %%~nxT
)

set /p THEME_CHOICE=Enter the number of the theme to use:
set "THEME_NAME=!THEME_FOLDER[%THEME_CHOICE%]!"

if not defined THEME_NAME (
    echo Invalid selection. Aborting installation.
    pause
    exit /b
)

:: Remove old include lines (if any) from refind.conf
findstr /V /I "include themes/" "refind\refind.conf" > "refind\refind_temp.conf"
move /Y "refind\refind_temp.conf" "refind\refind.conf" >nul

:: Append selected theme to refind.conf
echo include themes/!THEME_NAME!/theme.conf>> refind\refind.conf

echo.
echo Selected theme: !THEME_NAME!

:: --------------------------------------
:: Copy rEFInd to EFI partition
:: --------------------------------------
cd /d "%~dp0"
echo Copying rEFInd to EFI...
xcopy /E /Y refind %EFIDRIVE%\EFI\refind\

:: --------------------------------------
:: Set boot manager path and description
:: --------------------------------------
bcdedit /set "{bootmgr}" path "%BOOTMGR_PATH%"
bcdedit /set "{bootmgr}" description "%BOOTMGR_DESC%"

echo.
echo rEFInd has been successfully installed and configured.
echo.
echo Boot path set to: %BOOTMGR_PATH%
echo Description set to: %BOOTMGR_DESC%
echo.
echo.
echo ------------------------------------------------------------
echo   IMPORTANT: Manual BIOS/UEFI settings required!
echo ------------------------------------------------------------
echo   1. Disable "Secure Boot" in your UEFI/BIOS settings.
echo   2. Set the default boot option to "rEFInd Boot Manager".
echo   3. If rEFInd does not appear, try rebooting and entering BIOS.
echo   4. Make sure the EFI partition contains the rEFInd files.
echo.

:: Optional restart
set /p RESTART=Do you want to restart now? (y/n):
if /i "%RESTART%"=="y" (
    shutdown /r /t 5
)
