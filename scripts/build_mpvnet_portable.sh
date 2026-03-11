#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<USAGE
Usage: build_mpvnet_portable.sh [options]

Options:
  --mpvnet <path>        Path to mpv.net repo (default: ../mpv.net).
  --output <path>        Output root dir (default: <repo>/artifacts/mpv.net).
  --build-x64 <path>     mpv-winbuild-cmake build dir for x64 (default: <repo>/build-x64).
  --build-arm64 <path>   mpv-winbuild-cmake build dir for arm64 (default: <repo>/build-arm64).
  --config <Debug|Release>  mpv.net build config (default: Debug).
  --skip-mpv             Skip building mpv/libmpv.
  --skip-mpvnet          Skip building mpv.net.
  --reconfigure          Force re-run cmake configure step.

Env:
  MEDIAINFO_DLL          Path to MediaInfo.dll to include in portable output (legacy: copied to both).
  MEDIAINFO_DLL_X64      Path to MediaInfo.dll for x64 portable output.
  MEDIAINFO_DLL_ARM64    Path to MediaInfo.dll for ARM64 portable output.
  MEDIAINFO_VERSION      MediaInfo version string, e.g. 25.07 (used if download URL isn't provided).
  MEDIAINFO_URL_X64      Full URL to MediaInfo DLL x64 7z package.
  MEDIAINFO_URL_ARM64    Full URL to MediaInfo DLL ARM64 7z package.
USAGE
}

MPVNET_ROOT=""
OUTPUT_ROOT=""
BUILD_X64=""
BUILD_ARM64=""
MPVNET_CONFIG="Debug"
SKIP_MPV=0
SKIP_MPVNET=0
RECONFIGURE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mpvnet)
      MPVNET_ROOT="$2"; shift 2;;
    --output)
      OUTPUT_ROOT="$2"; shift 2;;
    --build-x64)
      BUILD_X64="$2"; shift 2;;
    --build-arm64)
      BUILD_ARM64="$2"; shift 2;;
    --config)
      MPVNET_CONFIG="$2"; shift 2;;
    --skip-mpv)
      SKIP_MPV=1; shift;;
    --skip-mpvnet)
      SKIP_MPVNET=1; shift;;
    --reconfigure)
      RECONFIGURE=1; shift;;
    -h|--help)
      usage; exit 0;;
    *)
      echo "Unknown option: $1" >&2
      usage; exit 1;;
  esac
done

if [[ -z "$MPVNET_ROOT" ]]; then
  if [[ -d "$REPO_ROOT/../mpv.net" ]]; then
    MPVNET_ROOT="$REPO_ROOT/../mpv.net"
  else
    echo "mpv.net repo not found. Use --mpvnet to specify its path." >&2
    exit 1
  fi
fi

if [[ -z "$OUTPUT_ROOT" ]]; then
  OUTPUT_ROOT="$REPO_ROOT/artifacts/mpv.net"
fi

if [[ -z "$BUILD_X64" ]]; then
  BUILD_X64="$REPO_ROOT/build-x64"
fi

if [[ -z "$BUILD_ARM64" ]]; then
  BUILD_ARM64="$REPO_ROOT/build-arm64"
fi

if [[ -f "$MPVNET_ROOT/src/MpvNet.sln" ]]; then
  MPVNET_SRC="$MPVNET_ROOT/src"
elif [[ -f "$MPVNET_ROOT/MpvNet.sln" ]]; then
  MPVNET_SRC="$MPVNET_ROOT"
else
  echo "Could not locate MpvNet.sln under: $MPVNET_ROOT" >&2
  exit 1
fi

MPVNET_PROJECT="$MPVNET_SRC/MpvNet.Windows/MpvNet.Windows.csproj"
if [[ ! -f "$MPVNET_PROJECT" ]]; then
  echo "Missing project file: $MPVNET_PROJECT" >&2
  exit 1
fi

mkdir -p "$OUTPUT_ROOT"


ensure_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing required command: $cmd" >&2
    exit 1
  }
}

fetch_url() {
  local url="$1"
  local out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$out"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$out" "$url"
  else
    echo "Missing curl or wget for downloading: $url" >&2
    exit 1
  fi
}

fetch_text() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$url"
  else
    echo "Missing curl or wget for downloading: $url" >&2
    exit 1
  fi
}

resolve_mediainfo_url() {
  local arch_tag="$1" # x64 or ARM64
  local env_url="$2"
  local env_version="$3"

  if [[ -n "$env_url" ]]; then
    echo "$env_url"
    return 0
  fi

  if [[ -n "$env_version" ]]; then
    echo "https://mediaarea.net/download/binary/libmediainfo0/${env_version}/MediaInfo_DLL_${env_version}_Windows_${arch_tag}_WithoutInstaller.7z"
    return 0
  fi

  local page
  page="$(fetch_text "https://mediaarea.net/en/MediaInfo/Download/Windows" || true)"
  if [[ -z "$page" ]]; then
    page="$(fetch_text "https://fr.mco.mediaarea.net/en/MediaInfo/Download/Windows" || true)"
  fi
  if [[ -z "$page" ]]; then
    echo ""; return 1
  fi

  local filename
  filename=$(echo "$page" | grep -oE "MediaInfo_DLL_[0-9.]+_Windows_${arch_tag}_WithoutInstaller\.7z" | head -n1 || true)
  if [[ -z "$filename" ]]; then
    echo ""; return 1
  fi

  local version
  version=$(echo "$filename" | sed -n 's/.*MediaInfo_DLL_\([0-9.]*\)_Windows_.*/\1/p')
  if [[ -z "$version" ]]; then
    echo ""; return 1
  fi

  echo "https://mediaarea.net/download/binary/libmediainfo0/${version}/${filename}"
}

download_mediainfo_dll() {
  local arch_tag="$1"   # x64 or ARM64
  local out_dir="$2"
  local url="$3"

  if [[ -f "$out_dir/MediaInfo.dll" ]]; then
    return 0
  fi

  if [[ -z "$url" ]]; then
    echo "MediaInfo download URL for ${arch_tag} not resolved." >&2
    return 1
  fi

  local seven_zip=""
  if command -v 7z >/dev/null 2>&1; then
    seven_zip="7z"
  elif command -v 7za >/dev/null 2>&1; then
    seven_zip="7za"
  else
    echo "Missing 7z/7za for extracting MediaInfo archive." >&2
    return 1
  fi

  local cache_dir="$OUTPUT_ROOT/_cache/mediainfo/${arch_tag}"
  mkdir -p "$cache_dir"
  local archive="$cache_dir/MediaInfo_${arch_tag}.7z"
  fetch_url "$url" "$archive"

  local extract_dir="$cache_dir/extracted"
  rm -rf "$extract_dir"
  mkdir -p "$extract_dir"
  ${seven_zip} x -y "$archive" -o"$extract_dir" >/dev/null

  local dll_path
  dll_path=$(find "$extract_dir" -maxdepth 3 -name 'MediaInfo.dll' -print -quit || true)
  if [[ -z "$dll_path" ]]; then
    echo "MediaInfo.dll not found in downloaded archive for ${arch_tag}." >&2
    return 1
  fi
  cp "$dll_path" "$out_dir/MediaInfo.dll"
}

configure_build() {
  local build_dir="$1"
  local target_arch="$2"
  local toolchain="$3"

  if [[ $RECONFIGURE -eq 1 || ! -f "$build_dir/build.ninja" ]]; then
    mkdir -p "$build_dir"
    cmake -G Ninja \
      -B "$build_dir" \
      -S "$REPO_ROOT" \
      -DTARGET_ARCH="$target_arch" \
      -DCOMPILER_TOOLCHAIN="$toolchain"
  fi
}

build_mpv_x64() {
  configure_build "$BUILD_X64" "x86_64-w64-mingw32" "gcc"
  ninja -C "$BUILD_X64" gcc
  ninja -C "$BUILD_X64" mpv
}

build_mpv_arm64() {
  configure_build "$BUILD_ARM64" "aarch64-w64-mingw32" "clang"
  ninja -C "$BUILD_ARM64" llvm
  ninja -C "$BUILD_ARM64" rustup
  ninja -C "$BUILD_ARM64" llvm-clang
  ninja -C "$BUILD_ARM64" mpv
}

if [[ $SKIP_MPV -eq 0 ]]; then
  echo "==> Building mpv (x64)"
  build_mpv_x64
  echo "==> Building mpv (arm64)"
  build_mpv_arm64
fi

libmpv_x64="$BUILD_X64/packages/mpv-dev/libmpv-2.dll"
libmpv_arm64="$BUILD_ARM64/packages/mpv-dev/libmpv-2.dll"

if [[ ! -f "$libmpv_x64" ]]; then
  echo "Missing libmpv x64: $libmpv_x64" >&2
  exit 1
fi

if [[ ! -f "$libmpv_arm64" ]]; then
  echo "Missing libmpv arm64: $libmpv_arm64" >&2
  exit 1
fi

if [[ $SKIP_MPVNET -eq 0 ]]; then
  echo "==> Building mpv.net ($MPVNET_CONFIG)"
  dotnet publish "$MPVNET_PROJECT" --self-contained false --configuration "$MPVNET_CONFIG" --runtime win-x64
  dotnet publish "$MPVNET_PROJECT" --self-contained false --configuration "$MPVNET_CONFIG" --runtime win-arm64
fi

publish_x64="$MPVNET_SRC/MpvNet.Windows/bin/$MPVNET_CONFIG/win-x64/publish"
publish_arm64="$MPVNET_SRC/MpvNet.Windows/bin/$MPVNET_CONFIG/win-arm64/publish"

if [[ ! -d "$publish_x64" ]]; then
  echo "Missing publish dir: $publish_x64" >&2
  exit 1
fi

if [[ ! -d "$publish_arm64" ]]; then
  echo "Missing publish dir: $publish_arm64" >&2
  exit 1
fi

version="$(sed -n 's:.*<FileVersion>\([^<]*\)</FileVersion>.*:\1:p' "$MPVNET_PROJECT" | head -n1)"
if [[ -z "$version" ]]; then
  version="0.0.0.0"
fi

output_dir_x64="$OUTPUT_ROOT/mpv.net-v${version}-portable-x64"
output_dir_arm64="$OUTPUT_ROOT/mpv.net-v${version}-portable-ARM64"

rm -rf "$output_dir_x64" "$output_dir_arm64"
mkdir -p "$output_dir_x64" "$output_dir_arm64"

cp -R "$publish_x64/"* "$output_dir_x64/"
cp -R "$publish_arm64/"* "$output_dir_arm64/"

bin_root="$MPVNET_SRC/MpvNet.Windows/bin/$MPVNET_CONFIG"
extra_x64=("mpvnet.com")
extra_arm64=("mpvnet.com")

for f in "${extra_x64[@]}"; do
  if [[ -f "$bin_root/$f" ]]; then
    cp "$bin_root/$f" "$output_dir_x64/$f"
  fi
done

for f in "${extra_arm64[@]}"; do
  if [[ -f "$bin_root/win-arm64/$f" ]]; then
    cp "$bin_root/win-arm64/$f" "$output_dir_arm64/$f"
  fi
done

if [[ -n "${MEDIAINFO_DLL_X64:-}" && -f "$MEDIAINFO_DLL_X64" ]]; then
  cp "$MEDIAINFO_DLL_X64" "$output_dir_x64/MediaInfo.dll"
elif [[ -n "${MEDIAINFO_DLL:-}" && -f "$MEDIAINFO_DLL" ]]; then
  cp "$MEDIAINFO_DLL" "$output_dir_x64/MediaInfo.dll"
elif [[ -f "$bin_root/MediaInfo.dll" ]]; then
  cp "$bin_root/MediaInfo.dll" "$output_dir_x64/MediaInfo.dll"
else
  url_x64="$(resolve_mediainfo_url "x64" "${MEDIAINFO_URL_X64:-}" "${MEDIAINFO_VERSION:-}")"
  download_mediainfo_dll "x64" "$output_dir_x64" "$url_x64" || true
fi

if [[ -n "${MEDIAINFO_DLL_ARM64:-}" && -f "$MEDIAINFO_DLL_ARM64" ]]; then
  cp "$MEDIAINFO_DLL_ARM64" "$output_dir_arm64/MediaInfo.dll"
elif [[ -n "${MEDIAINFO_DLL:-}" && -f "$MEDIAINFO_DLL" ]]; then
  cp "$MEDIAINFO_DLL" "$output_dir_arm64/MediaInfo.dll"
elif [[ -f "$bin_root/win-arm64/MediaInfo.dll" ]]; then
  cp "$bin_root/win-arm64/MediaInfo.dll" "$output_dir_arm64/MediaInfo.dll"
else
  url_arm64="$(resolve_mediainfo_url "ARM64" "${MEDIAINFO_URL_ARM64:-}" "${MEDIAINFO_VERSION:-}")"
  download_mediainfo_dll "ARM64" "$output_dir_arm64" "$url_arm64" || true
fi

locale_dir="$bin_root/Locale"
if [[ -d "$locale_dir" ]]; then
  cp -R "$locale_dir" "$output_dir_x64/Locale"
  cp -R "$locale_dir" "$output_dir_arm64/Locale"
fi

cp "$libmpv_x64" "$output_dir_x64/libmpv-2.dll"
cp "$libmpv_arm64" "$output_dir_arm64/libmpv-2.dll"

zip_output_x64="$OUTPUT_ROOT/mpv.net-v${version}-portable-x64.zip"
zip_output_arm64="$OUTPUT_ROOT/mpv.net-v${version}-portable-ARM64.zip"

if command -v 7z >/dev/null 2>&1; then
  7z a -tzip -mx9 "$zip_output_x64" "$output_dir_x64"/* >/dev/null
  7z a -tzip -mx9 "$zip_output_arm64" "$output_dir_arm64"/* >/dev/null
elif command -v zip >/dev/null 2>&1; then
  (cd "$output_dir_x64" && zip -r "$zip_output_x64" .) >/dev/null
  (cd "$output_dir_arm64" && zip -r "$zip_output_arm64" .) >/dev/null
elif command -v python3 >/dev/null 2>&1; then
  python3 - <<PY
import os, zipfile

def zipdir(src, dst):
    with zipfile.ZipFile(dst, 'w', compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(src):
            for name in files:
                path = os.path.join(root, name)
                rel = os.path.relpath(path, src)
                zf.write(path, rel)

zipdir("$output_dir_x64", "$zip_output_x64")
zipdir("$output_dir_arm64", "$zip_output_arm64")
PY
else
  echo "Warning: no zip tool found, skipping zip creation." >&2
fi

echo "==> Done"
echo "Output directory: $OUTPUT_ROOT"
