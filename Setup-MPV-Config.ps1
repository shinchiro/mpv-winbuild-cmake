<#
.SYNOPSIS
    Quick setup script for MPV high-fidelity configuration

.DESCRIPTION
    This script copies all configuration files to your MPV installation
    and downloads necessary shaders for maximum visual quality.

.PARAMETER MPVPath
    Path to MPV installation directory (contains mpv.exe)

.PARAMETER DownloadShaders
    Download shaders (Anime4K, FSRCNNX, etc.)

.EXAMPLE
    .\Setup-MPV-Config.ps1 -MPVPath "C:\mpv"

.EXAMPLE
    .\Setup-MPV-Config.ps1 -MPVPath ".\build\mpv-x86_64-20250105" -DownloadShaders
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Path to MPV directory (containing mpv.exe)")]
    [string]$MPVPath,

    [Parameter(Mandatory=$false)]
    [switch]$DownloadShaders = $false
)

# Color output
function Write-Status {
    param([string]$Message, [string]$Type = "Info")
    $color = switch ($Type) {
        "Success" { "Green" }
        "Error" { "Red" }
        "Warning" { "Yellow" }
        default { "Cyan" }
    }
    $prefix = switch ($Type) {
        "Success" { "[✓]" }
        "Error" { "[✗]" }
        "Warning" { "[!]" }
        default { "[*]" }
    }
    Write-Host "$prefix $Message" -ForegroundColor $color
}

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       MPV High-Fidelity Configuration Setup                   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Validate MPV path
if (-not (Test-Path $MPVPath)) {
    Write-Status "MPV path does not exist: $MPVPath" "Error"
    exit 1
}

$mpvExe = Join-Path $MPVPath "mpv.exe"
if (-not (Test-Path $mpvExe)) {
    Write-Status "mpv.exe not found in: $MPVPath" "Error"
    Write-Status "Please provide the correct path to MPV installation" "Warning"
    exit 1
}

Write-Status "Found MPV installation at: $MPVPath" "Success"

# Create portable_config directory
$configDir = Join-Path $MPVPath "portable_config"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    Write-Status "Created portable_config directory" "Success"
} else {
    Write-Status "portable_config directory exists" "Info"
}

# Create subdirectories
$scriptsDir = Join-Path $configDir "scripts"
$shadersDir = Join-Path $configDir "shaders"

foreach ($dir in @($scriptsDir, $shadersDir)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Status "Created $(Split-Path $dir -Leaf) directory" "Success"
    }
}

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Configuration files to copy
$configFiles = @{
    "mpv-highfidelity.conf" = "mpv.conf"
    "input-highfidelity.conf" = "input.conf"
    "svp-integration.conf" = "svp-integration.conf"
}

Write-Host ""
Write-Status "Copying configuration files..." "Info"

foreach ($source in $configFiles.Keys) {
    $sourcePath = Join-Path $scriptDir $source
    $destName = $configFiles[$source]
    $destPath = Join-Path $configDir $destName

    if (-not (Test-Path $sourcePath)) {
        Write-Status "Source file not found: $source" "Warning"
        continue
    }

    # Backup existing config
    if (Test-Path $destPath) {
        $backupPath = "$destPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $destPath $backupPath -Force
        Write-Status "Backed up existing $destName to $(Split-Path $backupPath -Leaf)" "Warning"
    }

    # Copy new config
    Copy-Item $sourcePath $destPath -Force
    Write-Status "Installed: $destName" "Success"
}

# Copy README
$readmePath = Join-Path $scriptDir "HIGH-FIDELITY-SETUP.md"
if (Test-Path $readmePath) {
    $destReadme = Join-Path $configDir "README-HIGH-FIDELITY.md"
    Copy-Item $readmePath $destReadme -Force
    Write-Status "Copied documentation to portable_config" "Success"
}

# Download shaders if requested
if ($DownloadShaders) {
    Write-Host ""
    Write-Status "Downloading shaders..." "Info"

    $shaderScript = Join-Path $scriptDir "Download-Shaders.ps1"
    if (Test-Path $shaderScript) {
        & $shaderScript -ShaderPath $shadersDir
    } else {
        Write-Status "Shader download script not found" "Warning"
        Write-Status "You can manually run: .\Download-Shaders.ps1 -ShaderPath '$shadersDir'" "Info"
    }
} else {
    Write-Host ""
    Write-Status "Skipping shader download (use -DownloadShaders to download)" "Info"
    Write-Status "To download later: .\Download-Shaders.ps1 -ShaderPath '$shadersDir'" "Info"
}

# Create a quick reference file
$quickRefPath = Join-Path $configDir "QUICK-REFERENCE.txt"
$quickRef = @"
╔════════════════════════════════════════════════════════════════╗
║        MPV High-Fidelity Setup - Quick Reference               ║
╚════════════════════════════════════════════════════════════════╝

INSTALLATION DATE: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
MPV LOCATION: $MPVPath

═══════════════════════════════════════════════════════════════════
KEY FEATURES ENABLED
═══════════════════════════════════════════════════════════════════

✓ GPU acceleration (D3D11)
✓ Hardware video decoding
✓ High-quality upscaling (ewa_lanczos)
✓ Debanding for smooth gradients
✓ Color management with ICC profiles
✓ SVP integration ready
✓ 60fps display sync

═══════════════════════════════════════════════════════════════════
ESSENTIAL KEYBOARD SHORTCUTS
═══════════════════════════════════════════════════════════════════

PLAYBACK:
  Space       - Play/Pause
  ←/→         - Seek 5 seconds
  ↑/↓         - Seek 60 seconds
  [ / ]       - Decrease/Increase speed
  m           - Mute
  9 / 0       - Volume down/up
  f           - Fullscreen

QUALITY CONTROLS:
  d           - Toggle deinterlacing
  D           - Toggle debanding
  i           - Toggle interpolation
  h           - Cycle hardware decoding
  F1-F5       - Quality profiles
  F6-F10      - Shader toggles

VIDEO ADJUSTMENTS:
  1 / 2       - Decrease/Increase contrast
  3 / 4       - Decrease/Increase brightness
  5 / 6       - Decrease/Increase gamma
  7 / 8       - Decrease/Increase saturation

INFO & STATS:
  o           - Cycle OSD level
  `` (tilde)  - Toggle performance stats
  i           - Show file info
  I           - Show format

SCREENSHOTS:
  s           - Screenshot (with subtitles)
  S           - Screenshot (without subtitles)

═══════════════════════════════════════════════════════════════════
SVP INTEGRATION
═══════════════════════════════════════════════════════════════════

1. Download SVP: https://www.svp-team.com/wiki/Download
2. Install SVP 4
3. Start SVP Manager
4. Open a video with MPV
5. SVP should auto-activate

To enable SVP integration in mpv.conf, add:
  include="~~/svp-integration.conf"

═══════════════════════════════════════════════════════════════════
RECOMMENDED SHADERS
═══════════════════════════════════════════════════════════════════

For 1080p → 2K (Anime):
  F6 - Toggle Anime4K upscaling

For 1080p → 2K (Live Action):
  F9 - Toggle FSRCNNX upscaling

For Sharpening:
  F7 - Toggle Adaptive Sharpen

For 4K → 2K:
  F8 - Toggle SSIM Downscaler

Clear All Shaders:
  F10 - Remove all active shaders

═══════════════════════════════════════════════════════════════════
TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

Stuttering/Frame Drops:
  - Press F10 to disable shaders
  - Press Ctrl+h to cycle hardware decoder
  - Check stats with `` key
  - Reduce deband iterations in mpv.conf

Blurry Image:
  - Press F7 to enable sharpening
  - Try scale=ewa_lanczossharp in mpv.conf

Color Issues:
  - Check ICC profile with icc-profile-auto=yes
  - Press 5/6 to adjust gamma
  - Verify display color settings

SVP Not Working:
  - Restart SVP Manager
  - Check input-ipc-server=mpvpipe in mpv.conf
  - Try hwdec=no for software decoding
  - Update GPU drivers

═══════════════════════════════════════════════════════════════════
FILES IN THIS CONFIGURATION
═══════════════════════════════════════════════════════════════════

mpv.conf                  - Main configuration file
input.conf               - Custom keybindings
svp-integration.conf     - SVP-specific settings
README-HIGH-FIDELITY.md  - Complete documentation
shaders/                 - GLSL shader files
scripts/                 - Lua/JS scripts

═══════════════════════════════════════════════════════════════════
UPDATING CONFIGURATION
═══════════════════════════════════════════════════════════════════

To update, run:
  .\Setup-MPV-Config.ps1 -MPVPath "$MPVPath"

Old configs are automatically backed up with timestamps.

═══════════════════════════════════════════════════════════════════
SUPPORT & DOCUMENTATION
═══════════════════════════════════════════════════════════════════

Full Documentation: README-HIGH-FIDELITY.md
MPV Manual: https://mpv.io/manual/stable/
SVP Forum: https://www.svp-team.com/forum/
MPV Wiki: https://github.com/mpv-player/mpv/wiki

═══════════════════════════════════════════════════════════════════

Enjoy your high-fidelity video experience! 🎬
"@

$quickRef | Out-File -FilePath $quickRefPath -Encoding UTF8
Write-Status "Created quick reference: QUICK-REFERENCE.txt" "Success"

# Summary
Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    Setup Complete!                             ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Configuration installed to:" -ForegroundColor Yellow
Write-Host "  $configDir`n" -ForegroundColor White

Write-Status "Next Steps:" "Info"
Write-Host "  1. Review: $configDir\QUICK-REFERENCE.txt"
Write-Host "  2. Read full docs: $configDir\README-HIGH-FIDELITY.md"
if (-not $DownloadShaders) {
    Write-Host "  3. Download shaders: .\Download-Shaders.ps1 -ShaderPath '$shadersDir'"
    Write-Host "  4. Install SVP: https://www.svp-team.com/wiki/Download"
    Write-Host "  5. Launch MPV and enjoy!"
} else {
    Write-Host "  3. Install SVP: https://www.svp-team.com/wiki/Download"
    Write-Host "  4. Launch MPV and enjoy!"
}
Write-Host ""

Write-Status "To enable SVP, add this line to mpv.conf:" "Info"
Write-Host "  include=`"~~/svp-integration.conf`"`n" -ForegroundColor White

Write-Status "Test your installation:" "Info"
Write-Host "  $mpvExe <your-video-file>`n" -ForegroundColor White

Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Press any key to view the full documentation..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Open documentation
$readmeInConfig = Join-Path $configDir "README-HIGH-FIDELITY.md"
if (Test-Path $readmeInConfig) {
    Write-Host "`nOpening documentation..." -ForegroundColor Green
    Start-Process $readmeInConfig
}
