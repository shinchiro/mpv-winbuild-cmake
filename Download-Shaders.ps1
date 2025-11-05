<#
.SYNOPSIS
    Downloads high-quality shaders for MPV

.DESCRIPTION
    This script downloads popular shaders for enhanced video quality:
    - Anime4K: AI-based anime upscaling
    - FSRCNNX: Neural network upscaling
    - SSimDownscaler: High-quality downscaling
    - Adaptive Sharpen: Smart sharpening filter
    - KrigBilateral: Advanced chroma upscaling

.PARAMETER ShaderPath
    Path to the shaders folder (default: ./shaders)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$ShaderPath = ".\shaders"
)

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "╔════════════════════════════════════════════════════════════════╗" "Cyan"
Write-ColorOutput "║         MPV High-Quality Shader Downloader                     ║" "Cyan"
Write-ColorOutput "╚════════════════════════════════════════════════════════════════╝" "Cyan"
Write-Host ""

# Create shader directory
if (-not (Test-Path $ShaderPath)) {
    New-Item -ItemType Directory -Path $ShaderPath -Force | Out-Null
    Write-ColorOutput "[+] Created shader directory: $ShaderPath" "Green"
} else {
    Write-ColorOutput "[i] Shader directory exists: $ShaderPath" "Yellow"
}

# Shader repositories
$shaders = @{
    "Anime4K" = @{
        "URL" = "https://github.com/bloc97/Anime4K/releases/latest/download/Anime4K_v4.0.zip"
        "Description" = "AI-based anime upscaling (best for anime)"
        "Files" = @(
            "Anime4K_Upscale_CNN_x2_M.glsl",
            "Anime4K_Upscale_CNN_x2_L.glsl",
            "Anime4K_Restore_CNN_M.glsl",
            "Anime4K_Restore_CNN_L.glsl",
            "Anime4K_Denoise_Bilateral_Mode.glsl",
            "Anime4K_Deblur_DoG.glsl"
        )
    }
    "FSRCNNX" = @{
        "URL" = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/1.1/FSRCNNX_x2_16-0-4-1.glsl"
        "Description" = "Neural network upscaling (high quality, slow)"
        "Direct" = $true
    }
    "SSimDownscaler" = @{
        "URL" = "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/SSimDownscaler.glsl"
        "Description" = "High-quality downscaling"
        "Direct" = $true
    }
    "Adaptive-Sharpen" = @{
        "URL" = "https://gist.githubusercontent.com/igv/8a77e4eb8276753b54bb94c1c50c317e/raw/adaptive-sharpen.glsl"
        "Description" = "Adaptive sharpening filter"
        "Direct" = $true
    }
    "KrigBilateral" = @{
        "URL" = "https://gist.githubusercontent.com/igv/a015fc885d5c22e6891820ad89555637/raw/KrigBilateral.glsl"
        "Description" = "Advanced chroma upscaling"
        "Direct" = $true
    }
}

foreach ($shaderName in $shaders.Keys) {
    Write-ColorOutput "`n[*] Downloading $shaderName..." "Cyan"
    Write-ColorOutput "    $($shaders[$shaderName].Description)" "Gray"

    $shader = $shaders[$shaderName]
    $url = $shader.URL

    try {
        if ($shader.Direct) {
            # Direct download
            $fileName = Split-Path $url -Leaf
            $outputPath = Join-Path $ShaderPath $fileName

            Write-ColorOutput "    Downloading: $fileName" "Yellow"
            Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing
            Write-ColorOutput "    [✓] Downloaded: $fileName" "Green"

        } else {
            # ZIP download (Anime4K)
            $tempZip = Join-Path $env:TEMP "$shaderName.zip"
            $tempExtract = Join-Path $env:TEMP $shaderName

            Write-ColorOutput "    Downloading archive..." "Yellow"
            Invoke-WebRequest -Uri $url -OutFile $tempZip -UseBasicParsing

            Write-ColorOutput "    Extracting..." "Yellow"
            Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

            # Copy specific files
            foreach ($file in $shader.Files) {
                $sourceFile = Get-ChildItem -Path $tempExtract -Filter $file -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($sourceFile) {
                    Copy-Item $sourceFile.FullName -Destination $ShaderPath -Force
                    Write-ColorOutput "    [✓] Extracted: $file" "Green"
                } else {
                    Write-ColorOutput "    [!] Not found: $file" "Red"
                }
            }

            # Cleanup
            Remove-Item $tempZip -Force
            Remove-Item $tempExtract -Recurse -Force
        }

    } catch {
        Write-ColorOutput "    [!] Error downloading $shaderName : $_" "Red"
    }
}

Write-Host ""
Write-ColorOutput "╔════════════════════════════════════════════════════════════════╗" "Green"
Write-ColorOutput "║                     Download Complete!                         ║" "Green"
Write-ColorOutput "╚════════════════════════════════════════════════════════════════╝" "Green"
Write-Host ""
Write-ColorOutput "Shaders have been downloaded to: $ShaderPath" "Yellow"
Write-Host ""
Write-ColorOutput "SHADER USAGE GUIDE:" "Cyan"
Write-ColorOutput "══════════════════" "Cyan"
Write-Host ""
Write-ColorOutput "1. ANIME4K (Best for Anime)" "Yellow"
Write-Host "   Profile: 1080p → 2K (Mode A - Fast)"
Write-Host "   glsl-shaders='~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl'"
Write-Host ""
Write-Host "   Profile: 1080p → 2K (Mode B - Balanced)"
Write-Host "   glsl-shaders='~~/shaders/Anime4K_Restore_CNN_L.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_L.glsl'"
Write-Host ""

Write-ColorOutput "2. FSRCNNX (Best for Live Action - Slow)" "Yellow"
Write-Host "   glsl-shaders='~~/shaders/FSRCNNX_x2_16-0-4-1.glsl'"
Write-Host ""

Write-ColorOutput "3. ADAPTIVE SHARPEN (Universal)" "Yellow"
Write-Host "   glsl-shaders='~~/shaders/adaptive-sharpen.glsl'"
Write-Host ""

Write-ColorOutput "4. SSIM DOWNSCALER (4K → 2K)" "Yellow"
Write-Host "   glsl-shaders='~~/shaders/SSimDownscaler.glsl'"
Write-Host ""

Write-ColorOutput "5. KRIGBILATERAL (Chroma Enhancement)" "Yellow"
Write-Host "   glsl-shaders='~~/shaders/KrigBilateral.glsl'"
Write-Host ""

Write-ColorOutput "COMBINATION EXAMPLES:" "Cyan"
Write-ColorOutput "════════════════════" "Cyan"
Write-Host ""
Write-Host "High-Quality 1080p Upscaling (Anime):"
Write-Host "  glsl-shaders='~~/shaders/Anime4K_Restore_CNN_L.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_L.glsl:~~/shaders/KrigBilateral.glsl:~~/shaders/adaptive-sharpen.glsl'"
Write-Host ""
Write-Host "High-Quality 1080p Upscaling (Live Action):"
Write-Host "  glsl-shaders='~~/shaders/FSRCNNX_x2_16-0-4-1.glsl:~~/shaders/KrigBilateral.glsl:~~/shaders/adaptive-sharpen.glsl'"
Write-Host ""
Write-Host "4K Downscaling to 2K:"
Write-Host "  glsl-shaders='~~/shaders/SSimDownscaler.glsl:~~/shaders/adaptive-sharpen.glsl'"
Write-Host ""

Write-ColorOutput "KEY BINDINGS (from input.conf):" "Cyan"
Write-ColorOutput "═══════════════════════════════" "Cyan"
Write-Host "  F6  - Toggle Anime4K"
Write-Host "  F7  - Toggle Adaptive Sharpen"
Write-Host "  F8  - Toggle SSIM Downscaler"
Write-Host "  F9  - Toggle FSRCNNX"
Write-Host "  F10 - Clear all shaders"
Write-Host ""
Write-ColorOutput "PERFORMANCE NOTES:" "Yellow"
Write-ColorOutput "═════════════════" "Yellow"
Write-Host "  • Anime4K_M:  Medium quality, fast (recommended)"
Write-Host "  • Anime4K_L:  High quality, moderate speed"
Write-Host "  • FSRCNNX:    Highest quality, slow (needs good GPU)"
Write-Host "  • Multiple shaders: Stack from bottom to top (processing order)"
Write-Host ""
Write-ColorOutput "To use shaders, add to mpv.conf:" "Green"
Write-Host "  glsl-shaders='~~/shaders/<shader-name>.glsl'"
Write-Host ""
