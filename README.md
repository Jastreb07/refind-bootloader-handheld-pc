# rEFInd Bootloader (Dual Boot) for Gaming Handheld PCs

## 📄 Screenshots

![alt text](https://github.com/Jastreb07/refind-bootloader-handheld-pc/blob/main/refind/themes/Steam_Deck/screenshot.png)
![alt text](https://github.com/Jastreb07/refind-bootloader-handheld-pc/blob/main/refind/themes/Lenovo_Legion_Go/screenshot.png)

<details>
  <summary>More screenshots</summary>
![alt text](https://github.com/Jastreb07/refind-bootloader-handheld-pc/blob/main/refind/themes/Asus_ROG_Ally/screenshot.png)
![alt text](https://github.com/Jastreb07/refind-bootloader-handheld-pc/blob/main/refind/themes/MSI_Claw/screenshot.png)
![alt text](https://github.com/Jastreb07/refind-bootloader-handheld-pc/blob/main/refind/themes/Zotac_Zone/screenshot.png)

</details>

---

## 📄 License

MIT License — free for all use, modifications, and redistribution.  
Attribution appreciated but not required.

This project includes and builds upon the [rEFInd boot manager](https://www.rodsbooks.com/refind/), which is licensed under the terms described in its own [LICENSE](https://sourceforge.net/projects/refind/).  
Please ensure compliance with rEFInd's original license when distributing modified versions.

---

## ⚠️ Disclaimer

This project is provided **"as is"** without warranty of any kind.

By using these scripts and tools, you acknowledge that:

- You are responsible for any changes made to your system.
- The author(s) of this project **accept no liability** for potential issues, including (but not limited to) data loss, boot failures, or system instability.
- Always create proper backups before modifying your EFI or bootloader settings.

Use at your own risk.

---

> Built for handheld tinkerers who want a bootloader as polished as their hardware.

Custom rEFInd bootloader themes, configurations, and tools tailored for modern gaming handheld PCs. This project provides a clean, controller-friendly bootloader experience — ideal for dual-boot setups with Windows, SteamOS, and Bazzite OS.

---

## 🧭 Contents

- [Installation (Windows)](#%EF%B8%8F-installation-instructions-windows)
- [Updating](#-updating-refind)
- [Backups & Restores](#-backups--restores)
- [Manually Select a Bootloader](#-manually-select-a-bootloader-in-biosuefi)
- [Customizing](#-customizing-the-background-and-icons-for-refind)

---

## ✅ Supported Devices

- ASUS ROG Ally
- Lenovo Legion Go
- MSI Claw
- Zotac Zone
- ...and more

---

## 🧩 OS Compatibility

- ✅ Windows 10 / 11
- ✅ SteamOS (Bazzite OS, HoloISO, ChimeraOS)
- ✅ All UEFI-capable Linux distributions

---

## 🎮 Features

- Controller-friendly rEFInd themes for handhelds
- Touchscreen-friendly and controller-compatible interface
- Predefined entries for Windows, SteamOS, Bazzite
- Fully Windows-compatible install/update/backup scripts
- Ready-to-use `refind/` EFI folder with theme selector
- Automatic BCD and EFI configuration restore

---

## 🔧 Customizing the Background and Icons for rEFInd

You can personalize this rEFInd theme by replacing the background image and icons to match your style or device branding.

---

### 🖼️ Background Image Requirements

- **Format**: `.png` (required)
- **Recommended Resolution**: `1920 x 1200 pixels`
    - Works well on most handheld gaming PCs
    - Resolution may vary depending on device (e.g. 1280×800 or 1920×1080)

---

### 📁 How to Replace the Background

1. Prepare your custom image:
    - Format: `.png`
    - Resolution: ideally `1920×1200`
    - File name: `background.png`

2. Overwrite the existing file: refind/themes/[Device_Name]/background.png

### ✅ Apply changes by running:
- **Run**: `windows-update.bat`
- 
---

## ⚙️ Installation Instructions (Windows)

> All `.bat` scripts must be run as **Administrator**.

### 🔧 BIOS/UEFI Preparation (Important!)

After installing rEFInd, make sure to:

1. **Disable Secure Boot** in BIOS/UEFI
2. **Set rEFInd as first boot option** in boot order

> On most handhelds, enter BIOS/UEFI by holding **Power Button + Volume Up** during startup.

---

### 📁 Step-by-Step Installation

#### 1. Download & Extract

- Download the latest version from the [Releases](https://github.com/Jastreb07/refind-bootloader-handheld-pc/releases) section.
- Extract all files.

#### 2. Run `windows-install.bat`

This script will:

- Mount the EFI partition to drive `Z:`
- Automatically create a full backup (EFI + BCD) before making changes
- Save the backup in the `backups\YYYY-MM-DD_HH-mm-ss\` folder
- Copy the `refind/` folder into `Z:\EFI\`
- Register rEFInd as the default boot manager via BCD (`bootmgr`)

💡 You can re-run this script at any time to reinstall or update your rEFInd setup.

---

## 🔄 Updating rEFInd

#### 🆙 `windows-update.bat`

This script updates your existing rEFInd installation:

- Mounts the EFI partition (`Z:`)
- Automatically create a full backup (EFI + BCD) before making changes
- Save the backup in the `backups\YYYY-MM-DD_HH-mm-ss\` folder
- Copies the latest `refind/` folder from your current working directory
- **Does not change boot order or overwrite BCD**

Use it whenever you change themes, icons, or configuration files.

---

## 💾 Backups & Restores

#### 📦 `windows-backup.bat`

Creates a full timestamped backup of:

- Your EFI partition (`Z:\EFI`)
- Your current BCD configuration (`bcdbackup.bcd`)
- A readable bootloader state (`bcdedit_output.txt`)

All backups are saved in `backups\YYYY-MM-DD_HH-mm-ss\`.

#### ♻️ `windows-restore.bat`

- Lists all available backups for selection
- Re-imports the BCD configuration
- Automatically restores the correct `{bootmgr}` path and description from the backup
- Verifies and mounts the EFI partition before proceeding

🔧 After restoring, make sure to:
- Re-enter your BIOS/UEFI (**Power Button + Volume Up** on most handhelds)
- If the restored backup includes the Windows Bootloader as default,
  you may need to **manually set rEFInd as the first boot option** in the boot order again

---

## 🔀 Manually Select a Bootloader in BIOS/UEFI

If your system boots into the wrong bootloader after a restore (e.g. Windows Bootloader instead of rEFInd, or vice versa), you can manually select the correct bootloader via the BIOS/UEFI.

#### 🧭 How to change the boot order:

1. **Enter the BIOS/UEFI/UEFI menu**
    - Hold **Power Button + Volume Up** when turning on your device
    - Alternatively, press **DEL** or **F2** during startup (depending on the manufacturer)

2. **Go to the “Boot” tab or section**

3. **Find the boot order list**
    - You should see entries like:
        - `rEFInd Boot Manager`
        - `Windows Boot Manager`
        - `SteamOS`
        - `EFI USB Device`, etc.

4. **Use the provided keys (usually F5/F6 or arrow keys) to move your preferred bootloader to the top**
    - Example: Move `Windows Boot Manager` to top if you want to boot directly into Windows again

5. **Save and exit BIOS/UEFI**
    - Usually **F10**, then confirm changes

💡 On some handhelds, you can also access a **one-time boot menu** (e.g. by holding **Volume Down + Power**), where you can choose the bootloader without changing the permanent order.
