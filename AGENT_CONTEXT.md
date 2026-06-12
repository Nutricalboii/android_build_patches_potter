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
- [x] Flashed system.img (621MB) to system partition (mmcblk0p53).

### [DONE] Phase 6B — Rootfs Preparation
- [x] Downloaded UBports rootfs: ubuntu-touch-android9-armhf.tar.gz (546MB)
- [x] Extracted rootfs, confirmed /sbin/init exists, proper structure
- [x] Created rootfs.img (1804MB ext4) at /tmp/rootfs.img
- [x] Fixed Python 3.14 compat issue in halium/system/sepolicy/build/file_utils.py
- [x] Fixed charger mode: added androidboot.bootmode=normal to BOARD_KERNEL_CMDLINE
- [x] Added panic=10, datapart=/dev/block/bootdevice/by-name/userdata, systempart=/dev/block/bootdevice/by-name/system

---

## 🔄 Current State (June 12, 2026)

```
BUILD STATUS: halium-boot.img + system.img REBUILT AND FLASHED (stable display configs, F2FS initramfs fix, and logger service included)
BOOT STATUS: Kernel boots past blue Motorola screen to black screen (stuck)
ROOTFS STATUS: Flashed successfully to userdata (mmcblk0p54)
LOGGER STATUS: Appended custom logcat service 'logger' to init.mmi.rc (flashed)
NEXT: Reboot to TWRP recovery, retrieve boot logs from last_kmsg to diagnose the black screen hang.
```

### What Works
- Kernel boots successfully (charger mode fixed)
- Boot image size optimized (14.8MB, switches to Image.gz without DTB duplication to fit 16.0MB partition)
- F2FS support added to initramfs mounting scripts to prevent syntax-crash hangs on userdata partition
- halium-boot.img flashed to boot partition
- system.img (627MB, with logger service) flashed to system partition
- rootfs.img created (1804MB) and dd-flashed directly to userdata partition
- Python 3.14 build system compatibility fixes (insertkeys.py, file_utils.py, post_process_props.py)

### What's Broken / In Progress
1. **Serial console** - CONFIG_SERIAL_MSM_HSL not set
2. **Black screen hang** - Needs logs from last_kmsg to identify where initramfs or userspace mounts are hanging.

---

## 📋 Next Steps (In Order — Do Not Skip)

### Step 1: Flash Rebuilt system.img (TODAY)
```bash
# Push the rebuilt system.img to TWRP
adb push out/target/product/potter/system.img /tmp/
adb shell "dd if=/tmp/system.img of=/dev/block/bootdevice/by-name/system bs=4M"
adb shell "sync"
```

### Step 2: Test Boot & Retrieve Logs
```bash
# Reboot using fastboot boot (to bypass unlocked bootloader warnings)
adb reboot bootloader
fastboot boot out/target/product/potter/halium-boot.img

# Let it boot (blue screen) for 30s. If it stalls, reboot back to TWRP and pull logs:
adb reboot recovery
adb pull /cache/boot_log.txt ./
adb pull /cache/recovery/last_kmsg ./
```

### Step 3: If Still Black Screen - Fix Display Driver
```bash
# Check kernel config for display driver
grep -E "FB_MSM_MDP|FRAMEBUFFER_CONSOLE" \
    kernel/motorola/msm8953/arch/arm64/configs/potter_defconfig

# Need to add:
# CONFIG_FB_MSM_MDP=y
# CONFIG_FRAMEBUFFER_CONSOLE=y
```

### Step 4: If Build System Issues
```bash
# Python 3.14 compat issues in TeleService
# Check halium/system/sepolicy/build/file_utils.py
# May need to fix additional Python 3.14 deprecations
```

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
fastboot flash userdata /tmp/rootfs.img
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
| Halium boot image | `out/target/product/potter/halium-boot.img` | Built by `mka halium-boot`, flashed |
| System image | `out/target/product/potter/system.img` | Built by `mka systemimage`, flashed (621MB) |
| Vendor image | `out/target/product/potter/vendor.img` | Auto-generated |
| rootfs.img | `/tmp/rootfs.img` | 1804MB ext4, ready to flash |
| UBports rootfs | Downloaded from ci.ubports.com | 546MB compressed |

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

*This file is auto-maintained. Last updated: June 11, 2026.*
*Active Conversation ID: 8d33727b-ff98-4221-bddd-d4029d2c3ef9*
