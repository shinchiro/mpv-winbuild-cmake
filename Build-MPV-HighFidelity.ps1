<#
.SYNOPSIS
    High-Fidelity MPV Build Script for 2K Non-HDR Displays with SVP Support

.DESCRIPTION
    This PowerShell script builds MPV with optimal settings for:
    - 2K (2560x1440) non-HDR monitors
    - 60fps playback with SVP (SmoothVideo Project)
    - Maximum visual fidelity
    - Hardware acceleration
    - Advanced upscaling and downscaling

.NOTES
    Requirements:
    - WSL2 (Ubuntu or Arch Linux recommended)
    - At least 16GB RAM
    - 30GB free disk space
    - 4+ CPU cores recommended

    Build Time: 2-4 hours (first build)
                30-60 minutes (incremental builds)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('x86_64', 'i686')]
    [string]$Architecture = 'x86_64',

    [Parameter(Mandatory=$false)]
    [ValidateSet('gcc', 'clang')]
    [string]$Compiler = 'gcc',

    [Parameter(Mandatory=$false)]
    [switch]$CleanBuild,

    [Parameter(Mandatory=$false)]
    [switch]$SkipConfig,

    [Parameter(Mandatory=$false)]
    [int]$Jobs = 0,

    [Parameter(Mandatory=$false)]
    [string]$WSLDistro = 'Ubuntu'
)

# Color output functions
function Write-Header {
    param([string]$Message)
    Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║ $($Message.PadRight(61)) ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "[*] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[i] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Red
}

function Write-Success {
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor Green
}

# Main script
Write-Header "MPV High-Fidelity Build Script - 2K Non-HDR + SVP Optimized"

# Detect CPU cores
if ($Jobs -eq 0) {
    $Jobs = (Get-CimInstance -ClassName Win32_ComputerSystem).NumberOfLogicalProcessors
    Write-Info "Detected $Jobs CPU cores"
}

# Check WSL2
Write-Step "Checking WSL2 installation..."
$wslCheck = wsl --list --verbose 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "WSL2 is not installed or not working properly"
    Write-Info "Please install WSL2: https://learn.microsoft.com/en-us/windows/wsl/install"
    exit 1
}
Write-Success "WSL2 is available"

# Check if distro exists
Write-Step "Checking WSL distro '$WSLDistro'..."
$distroExists = wsl -d $WSLDistro -e bash -c "echo OK" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "WSL distro '$WSLDistro' not found"
    Write-Info "Available distros:"
    wsl --list
    exit 1
}
Write-Success "Distro '$WSLDistro' is ready"

# Get script directory and convert to WSL path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WSLPath = wsl wslpath -a "'$ScriptDir'" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Failed to convert path to WSL format"
    exit 1
}
Write-Info "Build directory: $WSLPath"

# Architecture mapping
$targetArch = if ($Architecture -eq 'x86_64') { 'x86_64-w64-mingw32' } else { 'i686-w64-mingw32' }
Write-Info "Target architecture: $targetArch"
Write-Info "Compiler: $Compiler"

# Create build configuration script for WSL
$buildScript = @"
#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  High-Fidelity MPV Build - Starting Build Process\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

cd "$WSLPath"

# Install dependencies
echo -e "\${GREEN}[*] Checking and installing dependencies...\${NC}"
if command -v apt-get &> /dev/null; then
    echo -e "\${YELLOW}[i] Detected Debian/Ubuntu system\${NC}"
    sudo apt-get update
    sudo apt-get install -y \
        build-essential cmake ninja-build pkg-config \
        git gyp mercurial subversion \
        python3 python3-pip \
        nasm yasm \
        autoconf automake libtool \
        m4 texinfo bison flex \
        libgmp-dev libmpfr-dev libmpc-dev \
        libssl-dev \
        gperf ragel \
        rst2pdf \
        docbook2x \
        7zip
elif command -v pacman &> /dev/null; then
    echo -e "\${YELLOW}[i] Detected Arch Linux system\${NC}"
    sudo pacman -Syu --needed --noconfirm \
        base-devel cmake ninja pkg-config \
        git gyp mercurial subversion \
        python python-pip \
        nasm yasm \
        autoconf automake libtool \
        m4 texinfo bison flex \
        gmp mpfr mpc \
        openssl \
        gperf ragel \
        rst2pdf \
        docbook2x \
        p7zip
else
    echo -e "\${RED}[!] Unsupported distribution. Please install dependencies manually.\${NC}"
    exit 1
fi

echo -e "\${GREEN}[✓] Dependencies installed\${NC}"

# Clean build if requested
if [ "$($CleanBuild.IsPresent)" = "True" ]; then
    echo -e "\${YELLOW}[*] Cleaning previous build...\${NC}"
    rm -rf build
    echo -e "\${GREEN}[✓] Build directory cleaned\${NC}"
fi

# CMake Configuration
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  Configuring Build with High-Fidelity Settings\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

mkdir -p build
cd build

cmake .. \
    -G Ninja \
    -DTARGET_ARCH=$targetArch \
    -DCOMPILER_TOOLCHAIN=$Compiler \
    -DGCC_ARCH=x86-64-v3 \
    -DMAKEJOBS=$Jobs \
    -DENABLE_CCACHE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=\$(pwd)/install

echo -e "\${GREEN}[✓] CMake configuration complete\${NC}"

# Download sources
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  Downloading Source Packages\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

ninja download

echo -e "\${GREEN}[✓] Source packages downloaded\${NC}"

# Build toolchain
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  Building Toolchain (This will take 20-40 minutes)\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

ninja $Compiler

echo -e "\${GREEN}[✓] Toolchain built successfully\${NC}"

# Build MPV with all dependencies
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  Building MPV (This will take 1-3 hours)\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

ninja mpv

echo -e "\${GREEN}[✓] MPV built successfully\${NC}"

# Find the output directory
BUILD_DIR=\$(find . -maxdepth 1 -type d -name "mpv-*" | head -n 1)

if [ -z "\$BUILD_DIR" ]; then
    echo -e "\${RED}[!] Could not find MPV build output directory\${NC}"
    exit 1
fi

echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${CYAN}  Creating Configuration Files\${NC}"
echo -e "\${CYAN}════════════════════════════════════════════════════════════════\${NC}"

# Create portable_config directory
mkdir -p "\$BUILD_DIR/portable_config"
mkdir -p "\$BUILD_DIR/portable_config/scripts"
mkdir -p "\$BUILD_DIR/portable_config/shaders"

echo -e "\${GREEN}[✓] Created portable_config directory\${NC}"

echo -e "\${GREEN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${GREEN}  BUILD COMPLETE!\${NC}"
echo -e "\${GREEN}════════════════════════════════════════════════════════════════\${NC}"
echo -e "\${YELLOW}[i] Output location: \$BUILD_DIR\${NC}"
echo -e "\${YELLOW}[i] To access from Windows: \${NC}"
echo -e "\${YELLOW}    cd \"\$(wslpath -w \$(realpath \$BUILD_DIR))\"\${NC}"
echo ""
echo -e "\${CYAN}Next steps:\${NC}"
echo -e "  1. Copy configuration files to portable_config/"
echo -e "  2. Install SVP (SmoothVideo Project)"
echo -e "  3. Run mpv.exe and enjoy high-fidelity playback!"
echo ""
"@

# Write build script to temp file
$tempScript = [System.IO.Path]::GetTempFileName()
$buildScript | Out-File -FilePath $tempScript -Encoding UTF8

# Convert temp script path to WSL
$tempScriptWSL = wsl wslpath -a "'$tempScript'"

# Execute build in WSL
Write-Header "Executing Build in WSL"
Write-Info "This will take 2-4 hours on first build..."
Write-Info "Press Ctrl+C to cancel"

wsl -d $WSLDistro bash "$tempScriptWSL"

# Clean up temp script
Remove-Item $tempScript

if ($LASTEXITCODE -eq 0) {
    Write-Header "Build Completed Successfully!"

    # Find the build output directory
    $buildOutput = wsl -d $WSLDistro bash -c "cd '$WSLPath/build' && find . -maxdepth 1 -type d -name 'mpv-*' | head -n 1"

    if ($buildOutput) {
        $windowsPath = wsl -d $WSLDistro bash -c "cd '$WSLPath/build/$buildOutput' && pwd" | ForEach-Object { wsl wslpath -w $_ }

        Write-Success "MPV built successfully!"
        Write-Info "Output location: $windowsPath"
        Write-Info ""
        Write-Header "Next Steps"
        Write-Host "1. Configuration files will be created in the next step"
        Write-Host "2. Install SVP from: https://www.svp-team.com/wiki/Download"
        Write-Host "3. Copy the configuration files to mpv/portable_config/"
        Write-Host "4. Launch mpv.exe and enjoy!"
        Write-Host ""

        # Create config files if not skipped
        if (-not $SkipConfig) {
            Write-Step "Creating configuration files..."
            & "$PSScriptRoot\Create-MPV-Configs.ps1" -OutputPath "$windowsPath\portable_config"
        }
    }
} else {
    Write-Error-Custom "Build failed! Check the output above for errors."
    exit 1
}
