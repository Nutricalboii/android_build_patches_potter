# 🐧 Ubuntu Touch on Moto G5 Plus (Potter)

> Halium 9.0 bring-up for the Motorola Moto G5 Plus — running Ubuntu Touch on Android hardware.

[![Kernel](https://img.shields.io/badge/Kernel-3.18%20msm8953-blue?logo=linux)](https://github.com/Nutricalboii/android_kernel_motorola_msm8953/tree/halium-9.0)
[![Halium](https://img.shields.io/badge/Halium-9.0-orange)](https://github.com/Halium/android)
[![Android Base](https://img.shields.io/badge/Base-LineageOS%2016.0-green)](https://lineageos.org)
[![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)]()

---

## 📱 Device

| Field | Value |
|---|---|
| **Device** | Motorola Moto G5 Plus |
| **Codename** | `potter` |
| **SoC** | Qualcomm Snapdragon 625 (MSM8953) |
| **Kernel** | Linux 3.18 |
| **Android Base** | LineageOS 16.0 (Android 9) |
| **Halium Version** | 9.0 |

---

## 📂 Repository Contents

| File/Directory | Description |
|---|---|
| `local_manifests/potter.xml` | Repo local manifest — adds device/kernel/vendor trees to Halium workspace |
| `check-kernel-config.sh` | Kernel config validation script (Halium requirements) |
| `AGENT_CONTEXT.md` | **Full project context for AI agents / new contributors** |
| `ROADMAP.md` | Complete step-by-step technical guide with diagrams |

---

## 🚀 Quick Start

### 1. Initialize Workspace

```bash
mkdir halium && cd halium
repo init -u https://github.com/Halium/android -b halium-9.0 -g default,-darwin --depth=1
```

### 2. Add Potter Manifest

```bash
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/potter.xml \
  https://raw.githubusercontent.com/Nutricalboii/android_build_patches_potter/main/local_manifests/potter.xml
```

### 3. Sync Sources

```bash
repo sync -c -j8 --no-clone-bundle --no-tags --force-sync
```

### 4. Build

```bash
source build/envsetup.sh
breakfast potter
mka halium-boot
```

---

## 📖 Documentation

- 📋 **[AGENT_CONTEXT.md](AGENT_CONTEXT.md)** — Full project state, constraints, next steps (for agents/contributors)
- 🗺️ **[ROADMAP.md](ROADMAP.md)** — Step-by-step technical guide with architecture diagrams

---

## 🔗 Related Repositories

| Repository | Purpose |
|---|---|
| [android_kernel_motorola_msm8953](https://github.com/Nutricalboii/android_kernel_motorola_msm8953) | Kernel source with 123 Halium patches on `halium-9.0` branch |
| [Halium/android](https://github.com/Halium/android) | Halium 9.0 source manifest |
| [UBports](https://github.com/ubports) | Ubuntu Touch project |

---

## 📊 Progress

- [x] Device preparation (bootloader unlock, TWRP)
- [x] Fix fastboot boot loop
- [x] Repository setup
- [x] Kernel config patching (123 changes)
- [x] Halium workspace initialization
- [x] Source sync (100% complete)
- [x] Build Halium boot image (Successful)
- [x] Build system image (Successful)
- [ ] Flash & boot test
- [ ] Ubuntu Touch rootfs integration

---

*Maintained by [@Nutricalboii](https://github.com/Nutricalboii)*

<!-- updated documentation check 16170 -->

<!-- updated documentation check 4081 -->

<!-- co-author contribution check 6828 -->
