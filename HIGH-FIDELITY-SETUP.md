# MPV High-Fidelity Build & Configuration Guide

## 🎯 Optimized for 2K Non-HDR Displays with SVP

This comprehensive guide provides everything needed to build and configure MPV for maximum visual fidelity on a 2K (2560x1440) non-HDR display with SVP (SmoothVideo Project) frame interpolation.

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Quick Start](#quick-start)
3. [Building MPV](#building-mpv)
4. [Configuration](#configuration)
5. [SVP Integration](#svp-integration)
6. [Shader Setup](#shader-setup)
7. [Optimization Profiles](#optimization-profiles)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Settings](#advanced-settings)

---

## 💻 System Requirements

### Minimum Requirements
- **OS**: Windows 10/11 (64-bit)
- **CPU**: Intel Core i5 / AMD Ryzen 5 (4+ cores)
- **RAM**: 8GB (16GB recommended)
- **GPU**: DirectX 11 compatible (NVIDIA GTX 1050 / AMD RX 560 or better)
- **Storage**: 30GB free space for build

### Recommended for Best Experience
- **CPU**: Intel Core i7 / AMD Ryzen 7 (8+ cores)
- **RAM**: 16GB or more
- **GPU**: NVIDIA RTX 2060 / AMD RX 5700 or better
- **Storage**: SSD with 50GB+ free space

### Software Requirements
- **WSL2** (Ubuntu 22.04 or Arch Linux recommended)
- **PowerShell 5.1+** (included in Windows)
- **SVP 4** (for frame interpolation)

---

## 🚀 Quick Start

### Step 1: Install WSL2

```powershell
# Run in PowerShell as Administrator
wsl --install
# Restart your computer
```

### Step 2: Clone Repository

```powershell
cd C:\
git clone https://github.com/shinchiro/mpv-winbuild-cmake.git
cd mpv-winbuild-cmake
```

### Step 3: Build MPV

```powershell
# Run the high-fidelity build script
.\Build-MPV-HighFidelity.ps1
```

**Build Time**: 2-4 hours (first build), 30-60 minutes (incremental)

### Step 4: Install Configuration Files

```powershell
# After build completes, copy config files to the build output
# Build output location will be shown at the end of the build

cd <build-output-directory>  # e.g., build\mpv-x86_64-20250105
mkdir portable_config

# Copy configuration files
copy ..\..\mpv-highfidelity.conf portable_config\mpv.conf
copy ..\..\input-highfidelity.conf portable_config\input.conf
```

### Step 5: Download Shaders

```powershell
# From the mpv-winbuild-cmake directory
.\Download-Shaders.ps1 -ShaderPath "<build-output-directory>\portable_config\shaders"
```

### Step 6: Install SVP

1. Download SVP from: https://www.svp-team.com/wiki/Download
2. Install SVP 4 (free version works great)
3. Launch SVP Manager
4. Configure SVP settings (see [SVP Integration](#svp-integration))

### Step 7: Enjoy!

Launch `mpv.exe` and open a video file. SVP should automatically activate for frame interpolation.

---

## 🔨 Building MPV

### Build Script Options

```powershell
.\Build-MPV-HighFidelity.ps1 [options]
```

**Parameters:**

| Parameter | Values | Default | Description |
|-----------|--------|---------|-------------|
| `-Architecture` | x86_64, i686 | x86_64 | Target architecture |
| `-Compiler` | gcc, clang | gcc | Compiler toolchain |
| `-CleanBuild` | switch | false | Clean previous build |
| `-SkipConfig` | switch | false | Skip config file creation |
| `-Jobs` | number | auto | Number of parallel jobs |
| `-WSLDistro` | string | Ubuntu | WSL distribution name |

**Examples:**

```powershell
# Standard build (recommended)
.\Build-MPV-HighFidelity.ps1

# Clean build with Clang compiler
.\Build-MPV-HighFidelity.ps1 -CleanBuild -Compiler clang

# Build with specific job count
.\Build-MPV-HighFidelity.ps1 -Jobs 8

# Use different WSL distro
.\Build-MPV-HighFidelity.ps1 -WSLDistro Arch
```

### Build Features

This build includes:

✅ **Video Codecs**: H.264, H.265/HEVC, VP9, AV1, AV2
✅ **Audio Codecs**: AAC, Opus, FLAC, Vorbis, AC3, DTS
✅ **Hardware Acceleration**: D3D11VA, DXVA2, NVDEC, CUDA
✅ **Advanced Rendering**: Vulkan, libplacebo, ANGLE
✅ **High-Quality Scaling**: ewa_lanczos, FSRCNNX support
✅ **Color Management**: lcms2, ICC profile support
✅ **SVP Integration**: VapourSynth, AviSynth+
✅ **Subtitle Rendering**: libass with font shaping
✅ **Scripting**: Lua, JavaScript (ES6+)

---

## ⚙️ Configuration

### Configuration File Structure

```
mpv/
├── mpv.exe
├── mpv.com
├── portable_config/
│   ├── mpv.conf           # Main configuration
│   ├── input.conf         # Keybindings
│   ├── scripts/           # Lua/JS scripts
│   └── shaders/           # GLSL shaders
```

### mpv.conf Highlights

**Video Output:**
```ini
vo=gpu-next                    # New GPU renderer
gpu-api=d3d11                  # D3D11 (best compatibility)
hwdec=d3d11va                  # Hardware decoding
```

**Quality Settings:**
```ini
scale=ewa_lanczos              # High-quality upscaling
dscale=mitchell                # High-quality downscaling
cscale=ewa_lanczossoft         # Chroma upscaling
deband=yes                     # Remove banding artifacts
```

**Synchronization:**
```ini
video-sync=display-resample    # Smooth playback
audio-pitch-correction=yes     # Maintain audio pitch
```

**Color Management:**
```ini
icc-profile-auto=yes           # Use monitor ICC profile
target-prim=bt.709             # HD color primaries
target-trc=bt.1886             # Standard gamma for SDR
```

### input.conf Highlights

| Key | Action | Description |
|-----|--------|-------------|
| `Space` | Play/Pause | Toggle playback |
| `←/→` | Seek ±5s | Seek backward/forward |
| `↑/↓` | Seek ±60s | Seek 1 minute |
| `[/]` | Speed ±10% | Adjust playback speed |
| `9/0` | Volume | Adjust volume |
| `f` | Fullscreen | Toggle fullscreen |
| `d` | Deinterlace | Toggle deinterlacing |
| `D` | Deband | Toggle debanding |
| `i` | Interpolation | Toggle interpolation |
| `s` | Screenshot | Take screenshot |
| `~` | Stats | Show performance stats |
| `F1-F5` | Profiles | Switch quality profiles |
| `F6-F10` | Shaders | Toggle shaders |

---

## 🎬 SVP Integration

### SVP Configuration

1. **Launch SVP Manager**
2. **Application Settings** → **External players**
3. **Add MPV** (should auto-detect)
4. **SVP Profile Settings:**

   - **Frame interpolation mode**: To screen refresh rate
   - **Motion vectors precision**: 24 (quality) or 16 (balanced)
   - **Artifact masking**: Medium to Strong
   - **Rendering**: 2x or 60fps (for 60Hz display)

### MPV Settings for SVP

**In mpv.conf, ensure these settings:**

```ini
# Hardware decoding (SVP compatible)
hwdec=d3d11va

# Video sync
video-sync=display-resample
audio-pitch-correction=yes

# Disable MPV interpolation (let SVP handle it)
#interpolation=yes              # COMMENTED OUT

# Display refresh rate
override-display-fps=60
```

### SVP Troubleshooting

**Problem**: SVP not activating

**Solution**:
1. Check SVP Manager is running
2. Verify video format is supported (H.264, HEVC work best)
3. Try software decoding: `hwdec=no` (temporary)
4. Check SVP logs: SVP Manager → Application Settings → Logs

**Problem**: Stuttering with SVP

**Solution**:
1. Reduce SVP quality: Motion vectors → 16 or 12
2. Enable GPU acceleration in SVP
3. Reduce mpv quality: `scale=bilinear`, `deband=no`
4. Close background applications

**Problem**: Audio desync

**Solution**:
1. Enable: `video-sync=display-resample`
2. Enable: `audio-pitch-correction=yes`
3. Adjust: `audio-delay` (press `z/Z` keys)

---

## 🎨 Shader Setup

### Recommended Shader Profiles

#### For 1080p → 2K Upscaling (Anime)

**Fast (60+ fps):**
```ini
glsl-shaders="~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"
```

**Balanced (30-60 fps):**
```ini
glsl-shaders="~~/shaders/Anime4K_Restore_CNN_L.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_L.glsl:~~/shaders/adaptive-sharpen.glsl"
```

**Maximum Quality (requires powerful GPU):**
```ini
glsl-shaders="~~/shaders/Anime4K_Restore_CNN_L.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_L.glsl:~~/shaders/KrigBilateral.glsl:~~/shaders/adaptive-sharpen.glsl"
```

#### For 1080p → 2K Upscaling (Live Action)

**High Quality (requires good GPU):**
```ini
glsl-shaders="~~/shaders/FSRCNNX_x2_16-0-4-1.glsl:~~/shaders/adaptive-sharpen.glsl"
```

**Balanced:**
```ini
glsl-shaders="~~/shaders/adaptive-sharpen.glsl:~~/shaders/KrigBilateral.glsl"
```

#### For 4K → 2K Downscaling

```ini
glsl-shaders="~~/shaders/SSimDownscaler.glsl:~~/shaders/adaptive-sharpen.glsl"
```

### Shader Keybindings

Add to `input.conf`:

```ini
F6  change-list glsl-shaders toggle "~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"
F7  change-list glsl-shaders toggle "~~/shaders/adaptive-sharpen.glsl"
F8  change-list glsl-shaders toggle "~~/shaders/SSimDownscaler.glsl"
F9  change-list glsl-shaders toggle "~~/shaders/FSRCNNX_x2_16-0-4-1.glsl"
F10 change-list glsl-shaders clr ""
```

### Performance Impact

| Shader | GPU Usage | FPS Impact | Best For |
|--------|-----------|------------|----------|
| Anime4K_M | Low | ~5% | Anime upscaling |
| Anime4K_L | Medium | ~15% | Anime upscaling (quality) |
| FSRCNNX | High | ~30-40% | Live action upscaling |
| Adaptive Sharpen | Very Low | ~2% | General sharpening |
| KrigBilateral | Low | ~5% | Chroma enhancement |
| SSimDownscaler | Low | ~5% | 4K→2K downscaling |

---

## 📊 Optimization Profiles

### Profile Selection (Auto-Applied)

Profiles are automatically applied based on video resolution:

- **4K+ (3840x2160)**: 4k-downscale profile
- **1080p-2K (1920-2559)**: 1080p-upscale profile
- **720p- (<1920)**: 1080p-upscale profile

### Manual Profile Activation

Press `F1-F5` keys to manually apply profiles:

- **F1**: 4K downscale profile
- **F2**: 1080p upscale profile
- **F3**: Low-quality source enhancement
- **F4**: Anime optimization
- **F5**: Restore default

### Custom Profiles

Add to `mpv.conf`:

```ini
[profile-name]
profile-desc="Description"
scale=ewa_lanczossharp
deband-iterations=6
# ... other settings

[auto-condition]
profile-cond=width >= 3840 and height >= 2160
profile=profile-name
```

---

## 🔧 Troubleshooting

### Performance Issues

**Problem**: Playback stuttering or frame drops

**Solutions**:
1. Check stats: Press `~` key
2. Reduce shader quality: Press `F10` to clear shaders
3. Try different hwdec: `Ctrl+h` to cycle
4. Reduce debanding: Set `deband-iterations=2`
5. Disable interpolation (if not using SVP)
6. Check CPU/GPU usage in Task Manager

### Video Quality Issues

**Problem**: Excessive banding in gradients

**Solutions**:
1. Increase debanding: `deband-iterations=6`, `deband-threshold=64`
2. Enable dithering: `dither=fruit`
3. Check color depth: Press `i` to see format
4. Force higher bit depth: `vf=format=yuv420p10`

**Problem**: Soft/blurry image

**Solutions**:
1. Enable sharpening: Press `F7` (adaptive-sharpen)
2. Try sharper scaler: `scale=ewa_lanczossharp`
3. Reduce anti-ringing: `scale-antiring=0.5`
4. Enable sigmoid upscaling: `sigmoid-upscaling=yes`

**Problem**: Over-sharpened with halos

**Solutions**:
1. Disable sharpen shader: Press `F7`
2. Increase anti-ringing: `scale-antiring=0.9`
3. Use softer scaler: `scale=ewa_lanczossoft`

### Hardware Decoding Issues

**Problem**: Hardware decoding not working

**Solutions**:
1. Check support: Press `i`, look for "hwdec"
2. Try different methods: `Ctrl+h` to cycle
3. Update GPU drivers
4. Check format support: Some GPUs don't support all codecs
5. Fallback to software: `hwdec=no`

### Color Issues

**Problem**: Washed out or incorrect colors

**Solutions**:
1. Verify ICC profile: `icc-profile-auto=yes`
2. Check video color space: Press `i`
3. Force color space: `target-prim=bt.709`, `target-trc=bt.1886`
4. Disable color management: `icc-profile-auto=no`
5. Adjust gamma: Press `5/6` keys

### Audio Issues

**Problem**: Audio crackling or stuttering

**Solutions**:
1. Increase buffer: `audio-buffer=1.0`
2. Change audio output: `ao=wasapi` or `ao=sdl`
3. Disable exclusive mode: `audio-exclusive=no`
4. Check sample rate: `audio-samplerate=48000`

**Problem**: Audio/video desync

**Solutions**:
1. Enable sync: `video-sync=display-resample`
2. Enable pitch correction: `audio-pitch-correction=yes`
3. Manual adjustment: Press `z/Z` keys
4. Reset sync: `Ctrl+BS`

---

## 🚀 Advanced Settings

### Maximum Quality Configuration

For absolute maximum quality (requires powerful GPU):

```ini
# Advanced scaling
scale=ewa_lanczossharp
scale-blur=0.981251
scale-antiring=0.8
dscale=mitchell
dscale-antiring=0.8
cscale=ewa_lanczossoft
cscale-antiring=0.8
sigmoid-upscaling=yes
linear-downscaling=no
correct-downscaling=yes

# Maximum debanding
deband=yes
deband-iterations=6
deband-threshold=64
deband-range=20
deband-grain=64

# High precision
fbo-format=rgba32f
dither-depth=10
dither=fruit

# Color management
icc-profile-auto=yes
icc-3dlut-size=256x256x256
target-colorspace-hint=yes
```

### Performance Configuration

For maximum performance (lower quality):

```ini
# Fast scaling
scale=bilinear
dscale=bilinear
cscale=bilinear

# Minimal debanding
deband=no

# Basic precision
fbo-format=rgba16f
dither=no

# Hardware acceleration
hwdec=d3d11va
hwdec-codecs=all
```

### Logging & Debugging

Enable detailed logging:

```ini
log-file=~~/mpv.log
msg-level=all=v
```

View stats overlay:
- Press `~` (tilde) for basic stats
- Press `!` for detailed frame timing
- Press `@` for cache stats

---

## 📝 Additional Resources

### Official Documentation
- MPV Manual: https://mpv.io/manual/stable/
- MPV Wiki: https://github.com/mpv-player/mpv/wiki

### Shader Resources
- Anime4K: https://github.com/bloc97/Anime4K
- FSRCNNX: https://github.com/igv/FSRCNN-TensorFlow
- MPV User Shaders: https://github.com/mpv-player/mpv/wiki/User-Scripts#user-shaders

### SVP Resources
- SVP Documentation: https://www.svp-team.com/wiki/
- SVP Forum: https://www.svp-team.com/forum/

### Community
- MPV GitHub: https://github.com/mpv-player/mpv
- SVP Forum: https://www.svp-team.com/forum/
- Reddit: r/mpv

---

## 🎯 Recommended Setup Summary

For the **best experience on 2K non-HDR with SVP**:

### Configuration

```ini
# mpv.conf
vo=gpu-next
gpu-api=d3d11
hwdec=d3d11va
scale=ewa_lanczos
dscale=mitchell
cscale=ewa_lanczossoft
deband=yes
video-sync=display-resample
audio-pitch-correction=yes
icc-profile-auto=yes
```

### Shaders (1080p content)

```ini
glsl-shaders="~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl:~~/shaders/adaptive-sharpen.glsl"
```

### SVP Settings

- Frame interpolation: To screen refresh rate (60fps)
- Motion vectors: 16-24 (balanced to quality)
- Artifact masking: Medium to Strong

### Result

✨ Smooth 60fps playback
✨ Crystal-clear upscaling
✨ Accurate colors
✨ No banding artifacts
✨ Optimized performance

---

## 📄 License

This configuration guide is released under MIT License.

MPV and all included libraries are subject to their respective licenses.

---

## 👏 Credits

- **MPV**: mpv-player team
- **Anime4K**: bloc97
- **FSRCNNX**: igv
- **SVP**: SVP Team
- **mpv-winbuild-cmake**: shinchiro

---

**Enjoy your high-fidelity video experience! 🎬**
