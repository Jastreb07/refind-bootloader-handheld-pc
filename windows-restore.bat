@echo off
setlocal EnableDelayedExpansion

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

:: Set working directory to script location
cd /d "%~dp0"

:: List available backup folders
echo Available backups:
set "INDEX=0"
for /d %%F in (backups\*) do (
    set /a INDEX+=1
    set "FOLDER[!INDEX!]=%%F"
    echo !INDEX!^) %%~nxF
)

:: Ask user for input
set /p CHOICE=Enter the number of the backup you want to restore:

:: Validate input
if not defined FOLDER[%CHOICE%] (
    echo Invalid selection. Exiting...
    pause
    exit /b
)

:: Get selected folder
set "SELECTED_FOLDER=!FOLDER[%CHOICE%]!"

:: Check if bcdbackup.bcd exists
if not exist "!SELECTED_FOLDER!\bcdbackup.bcd" (
    echo No bcdbackup.bcd found in the selected backup. Exiting...
    pause
    exit /b
)

:: Import BCD
bcdedit /import "!SELECTED_FOLDER!\bcdbackup.bcd"
if %errorlevel% neq 0 (
    echo Failed to import BCD. Operation aborted.
    pause
    exit /b
)

:: Try to read path and description for {bootmgr} from bcdedit_output.txt
set "BOOTMGR_PATH="
set "BOOTMGR_DESC="

if exist "!SELECTED_FOLDER!\bcdedit_output.txt" (
    for /f "tokens=1,* delims=:" %%A in ('findstr /R "^path ^description" "!SELECTED_FOLDER!\bcdedit_output.txt"') do (
        set "KEY=%%A"
        set "VAL=%%B"
        if /i "!KEY!"=="path" set "BOOTMGR_PATH=!VAL:~1!"
        if /i "!KEY!"=="description" set "BOOTMGR_DESC=!VAL:~1!"
    )

    :: Apply values if found
    if defined BOOTMGR_PATH (
        bcdedit /set "{bootmgr}" path !BOOTMGR_PATH!
    )
    if defined BOOTMGR_DESC (
        bcdedit /set "{bootmgr}" description "!BOOTMGR_DESC!"
    )

    echo.
    echo Boot manager settings restored
::    echo Path: !BOOTMGR_PATH!
::    echo Description: !BOOTMGR_DESC!
) else (
    echo No bcdedit_output.txt found – skipping boot manager path/description restoration.
)

echo.
echo Backup successfully restored from: !SELECTED_FOLDER!

:: Optional restart
set /p RESTART=Do you want to restart now? (y/n):
if /i "%RESTART%"=="y" (
    shutdown /r /t 5
)
