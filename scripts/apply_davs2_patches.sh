#!/usr/bin/env bash
set -euo pipefail

src_dir="${1:-}"
patch_root="${2:-}"
target_cpu_family="${3:-}"

if [[ -z "$src_dir" || -z "$patch_root" || -z "$target_cpu_family" ]]; then
  echo "Usage: apply_davs2_patches.sh <source_dir> <patch_root> <target_cpu_family>" >&2
  exit 1
fi

patches=(
  "$patch_root/0001-enable-10bit-build-and-propagate-frame-packet-position.patch"
)

if [[ "$target_cpu_family" == "aarch64" ]]; then
  patches+=(
    "$patch_root/0002-enable-arm64-neon-detect-and-keep-vectorization.patch"
    "$patch_root/0003-add-aarch64-neon-primitives-for-copy-add-avg.patch"
    "$patch_root/0004-add-aarch64-neon-mc-interpolation.patch"
    "$patch_root/0005-add-aarch64-neon-mc-ext-primitives.patch"
    "$patch_root/0006-add-aarch64-neon-deblock-luma.patch"
    "$patch_root/0007-add-aarch64-neon-deblock-chroma.patch"
    "$patch_root/0008-add-aarch64-neon-intra-basic-10bit.patch"
    "$patch_root/0009-add-aarch64-neon-intra-bilinear-10bit.patch"
  )
fi

patches+=(
  "$patch_root/0010-export-sequence-display-color-description.patch"
)

for patch_path in "${patches[@]}"; do
  if [[ ! -f "$patch_path" ]]; then
    echo "Missing davs2 patch file: $patch_path" >&2
    exit 1
  fi
  if ! git -C "$src_dir" apply --check "$patch_path" >/dev/null 2>&1; then
    git -C "$src_dir" apply --check --ignore-space-change --ignore-whitespace "$patch_path"
  fi
  if ! git -C "$src_dir" apply "$patch_path"; then
    git -C "$src_dir" apply --ignore-space-change --ignore-whitespace "$patch_path"
  fi
done
