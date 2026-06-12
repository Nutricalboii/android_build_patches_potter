#!/bin/bash
# Script to apply custom Halium 9.0 build patches to the ROM workspace.
# Run this from the root of the ROM workspace (e.g. halium/).

PATCHES_DIR="$(cd "$(dirname "$0")/patches" && pwd)"

apply_patch() {
  local target_dir="$1"
  local patch_file="$2"
  local full_patch_path="$PATCHES_DIR/$patch_file"
  
  if [ -d "$target_dir" ] && [ -f "$full_patch_path" ]; then
    echo "=== Applying $patch_file to $target_dir ==="
    git -C "$target_dir" apply --whitespace=nowarn "$full_patch_path"
  else
    echo "Skipping $patch_file (target directory or patch file not found)"
  fi
}

apply_patch "build/make" "build_make.patch"
apply_patch "art" "art.patch"
apply_patch "system/bt" "system_bt.patch"
apply_patch "system/sepolicy" "system_sepolicy.patch"
apply_patch "packages/services/Telephony" "packages_services_Telephony.patch"
apply_patch "libcore" "libcore.patch"
apply_patch "external/v8" "external_v8.patch"
apply_patch "halium/libhybris" "halium_libhybris.patch"
apply_patch "bionic" "bionic.patch"
apply_patch "prebuilts/clang/host/linux-x86" "prebuilts_clang_host_linux-x86.patch"
apply_patch "prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9" "prebuilts_gcc_arm.patch"
apply_patch "prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9" "prebuilts_gcc_x86.patch"
apply_patch "prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9" "prebuilts_gcc_aarch64.patch"

echo "=== Patches applied successfully ==="
