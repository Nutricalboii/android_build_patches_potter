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
- [x] `repo sync` in progress → **98% complete (385/391 repos)**
  - Running as background task in: `potter-ut/halium/`
  - Monitor: `tail -f ~/.gemini/antigravity-ide/brain/8d33727b-ff98-4221-bddd-d4029d2c3ef9/.system_generated/tasks/task-393.log`

---

## 🔄 Current State (June 6, 2026)

```
SYNC STATUS: 98% — 385/391 repos synced
ACTIVE TASK: repo sync (task-393)
BLOCKING: Nothing else can run until sync completes
```

**DO NOT start the build until sync shows 100% and exits cleanly.**

---

## 📋 Next Steps (In Order — Do Not Skip)

### Step 1: Verify Sync Completion
```bash
# Wait for task-393 to complete, then verify:
cd /home/vaibhavpandit/potter-ut/halium
repo status 2>&1 | tail -20
# Should show no errors
```

### Step 2: Verify Workspace Integrity
```bash
# Check key directories exist
ls device/motorola/potter/BoardConfig.mk
ls kernel/motorola/msm8953/arch/arm64/configs/potter_defconfig
ls vendor/motorola/potter/

# Verify our kernel has the halium patches
grep "CONFIG_CGROUPS=y" kernel/motorola/msm8953/arch/arm64/configs/potter_defconfig
```

### Step 3: Setup Build Environment
```bash
cd /home/vaibhavpandit/potter-ut/halium
source build/envsetup.sh
breakfast potter
# Should output: including device/motorola/potter/...
```

### Step 4: Build Halium Boot Image
```bash
# Build kernel + Halium initramfs (~1-2 hours depending on CPU)
mka halium-boot 2>&1 | tee /tmp/build_halium_boot.log
```

### Step 5: Verify Build Output
```bash
ls -lh out/target/product/potter/halium-boot.img
# Should be ~15-30 MB
```

### Step 6: Build System Image (if boot works)
```bash
mka systemimage 2>&1 | tee /tmp/build_system.log
```

### Step 7: Flash to Device
```bash
adb reboot bootloader
fastboot flash boot out/target/product/potter/halium-boot.img
fastboot flash system out/target/product/potter/system.img
fastboot reboot
```

### Step 8: Test Halium Boot
```bash
adb wait-for-device
adb shell getprop ro.halium.version
adb shell ps | grep -E "surfaceflinger|audioserver"
```

### Step 9: Install Ubuntu Touch Rootfs
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
