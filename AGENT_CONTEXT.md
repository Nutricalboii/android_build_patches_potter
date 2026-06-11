# 🤖 AGENT CONTEXT — Read This First Before Doing Anything

> **This file is the single source of truth for the entire project.**
> If you are an AI agent picking up this project, read this file completely before
> touching any code, running any command, or making any decision.
> Deviating from the decisions documented here will break the build.

---

## 🎯 Project Goal

Port **Ubuntu Touch** (UBports) to the **Motorola Moto G5 Plus** (`potter`)
using **Halium 9.0** as the Android hardware compatibility layer.

**End result:** A working Ubuntu Touch installation on the Moto G5 Plus that
can make calls, use WiFi, and run Ubuntu Touch apps.

---

## 👤 Owner

- **GitHub:** [@Nutricalboii](https://github.com/Nutricalboii)
- **Name:** Vaibhav Sharma
- **Email:** vibhu8688108170@gmail.com
- **Device:** Motorola Moto G5 Plus (codename `potter`)

---

## 📱 Device Specs (LOCKED — Do Not Change)

| Field | Value |
|---|---|
| **Codename** | `potter` |
| **SoC** | Qualcomm Snapdragon 625 (MSM8953) |
| **Architecture** | `arm64` (primary) + `arm` (secondary) |
| **Kernel version** | Linux **3.18** (msm8953) |
| **Android base** | **LineageOS 16.0 (Android 9 / Pie)** |
| **Halium target** | **Halium 9.0** |
| **Bootloader** | Unlocked ✅ |
| **Recovery** | TWRP installed ✅ |

---

## ⚠️ CRITICAL DECISIONS — Never Override These

### 1. Android Base = LineageOS 16.0 ONLY
**Do NOT use Android 13, LineageOS 20, or any other base.**
Halium 9.0 requires Android 9.0 base trees. Using a newer Android base will
result in incompatible kernel configs, HAL interface mismatches, and build failures.

- ✅ Correct: `lineage-16.0` branch for device/kernel trees
- ❌ Wrong: `lineage-20.0`, `lineage-21.0`, `android-13`, etc.

### 2. Halium Version = 9.0 ONLY
The manifest URL is `https://github.com/Halium/android`, branch `halium-9.0`.
Do not change this. Halium 10/11 has different init systems and won't work with the 3.18 kernel.

### 3. Kernel Branch = `halium-9.0`
Our patched kernel lives at branch `halium-9.0` in
`github.com/Nutricalboii/android_kernel_motorola_msm8953`.
The `master` branch is the UNPATCHED LineageOS kernel — do not use it for builds.

### 4. Darwin Prebuilts = EXCLUDED
The repo workspace was initialized with `-g default,-darwin` to exclude macOS prebuilts.
**Do NOT re-run `repo init` without `-g default,-darwin`** — it will try to re-sync
several GB of macOS-only toolchains that are completely useless on Linux.

### 5. Storage Constraint
Always keep at least **50 GB free** on the root filesystem.
Current workspace is ~50 GB. Total disk: 937 GB. Check before large operations:
```bash
df -h /
```

---

## 📁 Repository Map

### Owned Repositories (can push directly)

| Repo | URL | Branch | Purpose |
|---|---|---|---|
| `android_build_patches_potter` | https://github.com/Nutricalboii/android_build_patches_potter | `main` | Patches, manifests, scripts, docs |
| `android_kernel_motorola_msm8953` | https://github.com/Nutricalboii/android_kernel_motorola_msm8953 | `halium-9.0` | Patched kernel source |

### Third-Party Repositories (read-only, no push access)

| Repo | URL | Branch | Used for |
|---|---|---|---|
| Halium manifest | https://github.com/Halium/android | `halium-9.0` | Source manifest |
| Device tree | https://github.com/LineageOS/android_device_motorola_potter | `lineage-16.0` | Hardware configs |
| Vendor blobs | https://github.com/TheMuppets/proprietary_vendor_motorola | `lineage-16.0` | Proprietary firmware |

---

## 🗂️ Local Workspace Structure

```
/home/vaibhavpandit/potter-ut/
├── android_build_patches_potter/    ← This repo (patches + docs)
│   ├── AGENT_CONTEXT.md             ← YOU ARE HERE
│   ├── ROADMAP.md                   ← Step-by-step technical guide
│   ├── README.md                    ← User-facing overview
│   ├── local_manifests/
│   │   └── potter.xml               ← Local manifest for halium workspace
│   └── check-kernel-config.sh       ← Kernel config validation script
│
├── android_kernel_motorola_msm8953/ ← Kernel source (our fork)
│   ├── arch/arm64/configs/
│   │   └── potter_defconfig         ← PATCHED (123 Halium changes applied)
│   └── ... (full kernel source)
│
└── halium/                          ← Main Halium build workspace (~50 GB)
    ├── .repo/
    │   ├── manifest.xml             ← Points to default.xml
    │   ├── manifests/default.xml    ← Halium 9.0 manifest (391 projects)
    │   └── local_manifests/
    │       └── potter.xml           ← Adds device/kernel/vendor trees
    ├── device/motorola/potter/      ← Device tree (synced from LineageOS)
    ├── kernel/motorola/msm8953/     ← Kernel source (synced from our fork)
    ├── vendor/motorola/             ← Vendor blobs (TheMuppets)
    └── ... (390 other repos)
```

---

## ✅ Completed Work (Do Not Redo)

### [DONE] Phase 1 — Device Preparation
- [x] Device identified: Moto G5 Plus, codename `potter`
- [x] Bootloader unlocked
- [x] TWRP installed
- [x] Fixed fastboot boot loop: `fastboot oem fb_mode_clear`

### [DONE] Phase 2 — Repository Setup
- [x] Created `android_build_patches_potter` repo on GitHub
- [x] Forked `android_kernel_motorola_msm8953` to `Nutricalboii` org
- [x] Created `halium-9.0` branch on kernel fork
- [x] Created `local_manifests/potter.xml` pointing to correct trees
- [x] Committed and pushed all files to `android_build_patches_potter/main`

### [DONE] Phase 3 — Kernel Configuration
- [x] Ran `check-kernel-config` against `potter_defconfig`
- [x] Applied **123 configuration patches** required for Halium 9.0
  - Cgroups v1 (systemd resource management)
  - All namespace types (LXC container isolation)
  - AppArmor + seccomp (app security)
  - Network filtering (container networking)
  - OverlayFS (container image layers)
- [x] Committed patched `potter_defconfig` to `halium-9.0` branch
- [x] Pushed to `github.com/Nutricalboii/android_kernel_motorola_msm8953`

### [DONE] Phase 4 — Halium Workspace
- [x] Initialized Halium 9.0 workspace with `repo init -g default,-darwin`
- [x] Created `.repo/local_manifests/potter.xml`
- [x] Sync completed 100% (391/391 repos)

### [DONE] Phase 5 — Build Halium Boot Image
- [x] Fixed modern host compiler compatibility and Python 3 syntax issues in the toolchain.
- [x] Patched kernel configuration for LXC, Namespaces, Cgroups, security, and networking.
- [x] Compiled `halium-boot.img` containing the kernel and Halium initramfs successfully.

### [DONE] Phase 6 — Build System Image
- [x] Patched legacy Android 9 build tools and V8 generator to run under Python 3.14.
- [x] Excluded invalid dummy proprietary `.apk`/`.jar` stubs.
- [x] Resolved fake `libril` prebuilt linkage and GPS Loc core logging reference errors.
- [x] Injected XML configs to pass verification and compiled `system.img` successfully.

---

## 🔄 Current State (June 11, 2026)

```
BUILD STATUS: halium-boot.img + system.img BUILT
BOOT STATUS: Kernel boots successfully (no more "device can't be trusted")
ISSUE: Device stuck in charger mode / black screen
NEXT: Add androidboot.bootmode=normal + rebuild + flash
```

### What Works
- Kernel boots successfully (console fix applied)
- halium-boot.img built and valid (15.5MB)
- system.img built successfully
- Android init runs from ramdisk
- USB gadget configured

### What's Broken
1. Charger mode (bootloader passes bootmode=charger)
2. Black screen (display driver not loading)
3. /system still has stock Android (not Halium)
4. No /lib/modules in ramdisk

---

## 📋 Next Steps (In Order — Do Not Skip)

### Step 1: Fix Charger Mode (TODAY)
```bash
# Add androidboot.bootmode=normal to force normal boot
cd /home/vaibhavpandit/potter-ut/halium/device/motorola/potter
# Edit BoardConfig.mk line 48:
# BOARD_KERNEL_CMDLINE := androidboot.bootmode=normal console=tty0 ...
```

### Step 2: Rebuild Boot Image (TODAY)
```bash
cd /home/vaibhavpandit/potter-ut/halium
source build/envsetup.sh && breakfast potter
mka halium-boot
```

### Step 3: Flash via TWRP (TODAY)
```bash
# Boot TWRP
fastboot boot recovery.img

# Flash boot image
adb push out/target/product/potter/halium-boot.img /tmp/
adb shell "dd if=/tmp/halium-boot.img of=/dev/block/mmcblk0p37 bs=4M"
adb shell "sync"
adb reboot
```

### Step 4: Test Boot
```bash
adb devices
adb shell dmesg | tail -50
adb shell ps | grep -E "init|surfaceflinger|zygote"
```

### Step 5: If Still Black Screen - Check Display Driver
```bash
# Check kernel config for display driver
grep -E "DRM|MDSS|MSM_DSM|FRAMEBUFFER" \
    kernel/motorola/msm8953/arch/arm64/configs/potter_defconfig

# Should have:
# CONFIG_DRM_MSM=y
# CONFIG_DRM_MSM_DSI=y
# CONFIG_FB_MSM_MDSS=y
```

### Step 6: Flash Halium system.img
```bash
# Flash via TWRP:
fastboot boot recovery.img
adb push out/target/product/potter/system.img /tmp/
adb shell "dd if=/tmp/system.img of=/dev/block/mmcblk0p53 bs=4M"
adb shell "sync"
adb reboot
```

### Step 7: Test Halium Boot
```bash
adb wait-for-device
adb shell getprop ro.halium.version
adb shell ps | grep -E "surfaceflinger|audioserver"
```

### Step 8: Install Ubuntu Touch Rootfs
After confirming Halium boots successfully, install the Ubuntu Touch rootfs
using the UBports installer or manually via TWRP.

---

## 🚫 Common Mistakes to Avoid

| Mistake | Why It's Wrong | Correct Action |
|---|---|---|
| Using `lineage-20.0` trees | Incompatible with Halium 9.0 kernel | Always use `lineage-16.0` |
| Running `repo init` without `-g default,-darwin` | Will re-sync ~6GB of macOS junk | Always include `-g default,-darwin` |
| Building from `master` branch of kernel | Unpatched, missing 123 Halium configs | Always use `halium-9.0` branch |
| Running `make clean` without reason | Destroys hours of build cache | Only clean if build is truly corrupted |
| Flashing without checking partition sizes | Could brick device | Verify sizes match BoardConfig.mk |
| Pushing to `master` branch of kernel fork | Pollutes the clean upstream copy | Always push to `halium-9.0` branch |
| Starting build before sync finishes | Partial source = broken build | Always wait for 100% sync |

---

## 🔧 Useful Commands Reference

```bash
# Check sync status (current active sync)
tail -n 5 ~/.gemini/antigravity-ide/brain/8d33727b-ff98-4221-bddd-d4029d2c3ef9/.system_generated/tasks/task-393.log

# Check disk space (always keep 50GB free)
df -h /

# Setup build environment (run every new terminal session)
cd /home/vaibhavpandit/potter-ut/halium
source build/envsetup.sh && breakfast potter

# Build the kernel+initramfs image
mka halium-boot

# Push changes to our repos
git -C /home/vaibhavpandit/potter-ut/android_build_patches_potter push origin main
git -C /home/vaibhavpandit/potter-ut/android_kernel_motorola_msm8953 push origin halium-9.0

# Flash device (device must be in fastboot mode)
fastboot flash boot out/target/product/potter/halium-boot.img
```

---

## 🏗️ Architecture At a Glance

```
Ubuntu Touch Apps
      │
   Lomiri UI (Mir display server)
      │
   systemd (init)
      │
   LXC Container boundary
      │
   Halium Android HAL
   (SurfaceFlinger, AudioFlinger, RIL, Camera HAL...)
      │
   Linux Kernel 3.18 (msm8953, our patched potter_defconfig)
      │
   Qualcomm MSM8953 Hardware (Snapdragon 625)
```

---

## 📦 Build Artifact Locations

| Artifact | Path | Notes |
|---|---|---|
| Kernel defconfig | `kernel/motorola/msm8953/arch/arm64/configs/potter_defconfig` | 123 patches applied |
| Halium boot image | `out/target/product/potter/halium-boot.img` | Built by `mka halium-boot` |
| System image | `out/target/product/potter/system.img` | Built by `mka systemimage` |
| Vendor image | `out/target/product/potter/vendor.img` | Auto-generated |

---

## 🔑 GitHub Repositories — Contribution Notes

When making commits to our owned repos, follow this pattern for good commit messages:
```
component: Short description of change

Longer explanation of what was changed and why.
Reference any issues: Fixes #N, Closes #N

Change-Id: I<hash>
```

Create GitHub Issues for tracking each phase of work. Create PRs when merging
feature branches. Use releases/tags to mark major milestones (e.g., `v0.1-kernel-patched`,
`v0.2-halium-boot`, `v1.0-working-ubuntu-touch`).

---

*This file is auto-maintained. Last updated: June 6, 2026.*
*Active Conversation ID: 8d33727b-ff98-4221-bddd-d4029d2c3ef9*
