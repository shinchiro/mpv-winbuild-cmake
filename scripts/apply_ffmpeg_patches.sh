#!/usr/bin/env bash
set -euo pipefail

src_dir="${1:-}"
patch_root="${2:-}"
cavs_repo="${3:-}"
cavs_ref="${4:-}"
cavs_patch_path="${5:-}"

if [[ -z "$src_dir" || -z "$patch_root" || -z "$cavs_repo" || -z "$cavs_ref" || -z "$cavs_patch_path" ]]; then
  echo "Usage: apply_ffmpeg_patches.sh <source_dir> <patch_root> <cavs_repo> <cavs_ref> <cavs_patch_path>" >&2
  exit 1
fi

apply_ffmpeg_patch() {
  local patch_path="$1"
  if [[ ! -f "$patch_path" ]]; then
    echo "Missing FFmpeg patch file: $patch_path" >&2
    exit 1
  fi
  if ! patch -d "$src_dir" -p1 --forward < "$patch_path"; then
    patch -d "$src_dir" -p1 --forward -l < "$patch_path"
  fi
}

fetch_git_ref() {
  local url="$1"
  local ref="$2"
  local dest="$3"

  rm -rf "$dest"
  git init "$dest" >/dev/null
  git -C "$dest" remote add origin "$url"
  git -C "$dest" fetch --depth 1 origin "$ref" || git -C "$dest" fetch origin "$ref"
  git -C "$dest" checkout --detach FETCH_HEAD >/dev/null
}

# Apply local FFmpeg davs2 patches first.
apply_ffmpeg_patch "$patch_root/0001-libdavs2-export-pkt_pos-from-decoder-output.patch"
apply_ffmpeg_patch "$patch_root/0004-libdavs2-export-sequence-display-color-metadata.patch"

# Resolve cavs/dra base patch path (allow override from env).
if [[ -n "${FFMPEG_CAVS_DRA_PATCH_PATH:-}" && -f "${FFMPEG_CAVS_DRA_PATCH_PATH}" ]]; then
  cavs_patch="$FFMPEG_CAVS_DRA_PATCH_PATH"
elif [[ -n "${DEFAULT_CAVS_DRA_PATCH_PATH:-}" && -f "${DEFAULT_CAVS_DRA_PATCH_PATH}" ]]; then
  cavs_patch="$DEFAULT_CAVS_DRA_PATCH_PATH"
else
  cavs_patch="$cavs_patch_path"
fi

if [[ ! -f "$cavs_patch" ]]; then
  cache_dir="$(dirname "$cavs_patch")"
  mkdir -p "$cache_dir"
  fetch_git_ref "$cavs_repo" "$cavs_ref" "$cache_dir"
fi

if [[ ! -f "$cavs_patch" ]]; then
  echo "Missing FFmpeg cavs/dra patch file: $cavs_patch" >&2
  exit 1
fi

if ! git -C "$src_dir" apply -p2 --check "$cavs_patch" 2>/dev/null; then
  if ! git -C "$src_dir" apply -p2 --check --recount --ignore-space-change --ignore-whitespace "$cavs_patch" 2>/dev/null; then
    echo "Failed to validate FFmpeg cavs/dra patch against current FFmpeg checkout" >&2
    exit 1
  fi
fi

if ! git -C "$src_dir" apply -p2 "$cavs_patch" 2>/dev/null; then
  git -C "$src_dir" apply -p2 --recount --ignore-space-change --ignore-whitespace "$cavs_patch"
fi

# Apply cavs/dra follow-up patches.
apply_ffmpeg_patch "$patch_root/0002-libcavs-fix-macos-build-compat.patch"
apply_ffmpeg_patch "$patch_root/0003-libcavs-preserve-field-order-and-output-flags.patch"
