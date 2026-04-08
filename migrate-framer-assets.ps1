# ============================================================
#  Framer Asset Migration Script
#  Migrates all framerusercontent.com assets to shehanferoze.com
#
#  What this script does:
#    1. Scans all HTML files for framerusercontent.com URLs
#    2. Downloads all fonts + images to local asset folders
#    3. Rewrites every HTML file to point to your own domain
#
#  Folder structure created:
#    assets/
#      fonts/   <- all .woff2 font files
#      images/  <- all .png .jpg .webp .svg image files
#
#  Run from PowerShell:
#    .\migrate-framer-assets.ps1
# ============================================================

param(
    [string]$HtmlFolder    = "C:\Users\msfro\OneDrive\Documents\Claude\Projects\My Website\replacement check",
    [string]$AssetsFolder  = "C:\Users\msfro\OneDrive\Documents\Claude\Projects\My Website\assets",
    [string]$NewDomain     = "https://shehanferoze.com"
)

$ErrorActionPreference = "Continue"

# ── Directory Setup ──────────────────────────────────────────
$FontsDir  = Join-Path $AssetsFolder "fonts"
$ImagesDir = Join-Path $AssetsFolder "images"
New-Item -ItemType Directory -Force -Path $FontsDir  | Out-Null
New-Item -ItemType Directory -Force -Path $ImagesDir | Out-Null

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  PHASE 1 — Scanning HTML files" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$htmlFiles = Get-ChildItem -Path $HtmlFolder -Filter "*.html" -Recurse
Write-Host "  Found $($htmlFiles.Count) HTML files." -ForegroundColor Green

# Extract all unique framerusercontent.com URLs.
# Normalises everything to full https:// form immediately so downloads
# always use a valid absolute URL.
$allRawUrls = @{}
foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw

    # Match BOTH protocol-relative (//framer...) and absolute (https://framer...)
    # The regex captures from // onwards so we can normalise in one place.
    $matches = [regex]::Matches($content, '(?:https:)?//framerusercontent\.com/[^\s"''<>]+')
    foreach ($m in $matches) {
        $raw = $m.Value -replace '&amp;', '&'
        # Always store as full https:// URL
        $normalised = if ($raw -match '^//') { "https:$raw" } else { $raw }
        $allRawUrls[$normalised] = $true
    }
}

Write-Host "  Found $($allRawUrls.Count) unique Framer asset URLs." -ForegroundColor Green

# ── Categorise URLs ───────────────────────────────────────────
$fontUrls        = @()   # /assets/*.woff2
$imageUrls       = @()   # /images/* (any format)
$assetImageUrls  = @()   # /assets/*.png|jpg|webp|svg (non-font)

foreach ($url in $allRawUrls.Keys) {
    if ($url -match '/assets/[^?]+\.woff2') {
        $fontUrls += $url
    } elseif ($url -match '/images/') {
        $imageUrls += $url
    } elseif ($url -match '/assets/[^?]+\.(png|jpg|jpeg|webp|svg|gif)') {
        $assetImageUrls += $url
    }
}

Write-Host ""
Write-Host "  Asset breakdown:"
Write-Host "    Fonts (.woff2):    $($fontUrls.Count) files" -ForegroundColor Yellow
Write-Host "    Images (/images/): $($imageUrls.Count) URL variants" -ForegroundColor Yellow
Write-Host "    Asset images:      $($assetImageUrls.Count) files" -ForegroundColor Yellow

# ── URL Replacement Map ───────────────────────────────────────
# Maps every original URL (incl. query-param variants) -> new self-hosted URL
$urlMap = @{}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  PHASE 2 — Downloading Assets" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Helper: download with retry
function Download-Asset {
    param(
        [string]$Url,          # full https:// URL
        [string]$OutPath,
        [int]$BaseTimeout = 30
    )
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        try {
            $timeout = $BaseTimeout * $attempt
            Invoke-WebRequest -Uri $Url -OutFile $OutPath -ErrorAction Stop -TimeoutSec $timeout
            return $true
        } catch {
            if ($attempt -lt 3) {
                Write-Host "    Retry $attempt/3 (timeout ${timeout}s): $(Split-Path $OutPath -Leaf)" -ForegroundColor DarkYellow
                Start-Sleep -Seconds 3
            } else {
                Write-Warning "    FAILED after 3 attempts: $(Split-Path $OutPath -Leaf) — $($_.Exception.Message)"
                if (Test-Path $OutPath) { Remove-Item $OutPath -Force }
                return $false
            }
        }
    }
}

# ── Fonts ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "  [Fonts]" -ForegroundColor Magenta
$fontDownloaded = 0; $fontSkipped = 0; $fontFailed = 0

foreach ($url in ($fontUrls | Sort-Object -Unique)) {
    $dlUrl    = ($url -split '\?')[0]          # strip query params — full https:// URL
    $filename = ($dlUrl -split '/')[-1]
    $outPath  = Join-Path $FontsDir $filename
    $newUrl   = "$NewDomain/assets/fonts/$filename"

    $urlMap[$url] = $newUrl

    if (Test-Path $outPath) {
        $fontSkipped++
    } else {
        $ok = Download-Asset -Url $dlUrl -OutPath $outPath -BaseTimeout 30
        if ($ok) {
            $fontDownloaded++
            Write-Host "    + $filename" -ForegroundColor Gray
        } else {
            $fontFailed++
        }
    }
}
Write-Host "    Downloaded: $fontDownloaded  |  Already existed: $fontSkipped  |  Failed: $fontFailed" -ForegroundColor Green

# ── Images from /images/ ──────────────────────────────────────
Write-Host ""
Write-Host "  [Images from /images/]" -ForegroundColor Magenta
$imgDownloaded = 0; $imgSkipped = 0; $imgFailed = 0

# Group by base URL (strip query params) — same file, different scale-down variants
$imageBaseGroups = @{}
foreach ($url in $imageUrls) {
    $baseUrl = ($url -split '\?')[0]
    if (-not $imageBaseGroups.ContainsKey($baseUrl)) {
        $imageBaseGroups[$baseUrl] = [System.Collections.Generic.List[string]]::new()
    }
    $imageBaseGroups[$baseUrl].Add($url)
}

foreach ($baseUrl in $imageBaseGroups.Keys) {
    $filename = ($baseUrl -split '/')[-1]
    $outPath  = Join-Path $ImagesDir $filename
    $newUrl   = "$NewDomain/assets/images/$filename"

    # All query-param variants of this image → same clean new URL
    foreach ($variantUrl in $imageBaseGroups[$baseUrl]) {
        $urlMap[$variantUrl] = $newUrl
    }

    if (Test-Path $outPath) {
        $imgSkipped++
    } else {
        $ok = Download-Asset -Url $baseUrl -OutPath $outPath -BaseTimeout 60
        if ($ok) {
            $imgDownloaded++
            Write-Host "    + $filename" -ForegroundColor Gray
        } else {
            $imgFailed++
        }
    }
}
Write-Host "    Downloaded: $imgDownloaded  |  Already existed: $imgSkipped  |  Failed: $imgFailed" -ForegroundColor Green

# ── Asset Images (non-font files from /assets/) ───────────────
Write-Host ""
Write-Host "  [Asset images from /assets/]" -ForegroundColor Magenta
foreach ($url in ($assetImageUrls | Sort-Object -Unique)) {
    $dlUrl    = ($url -split '\?')[0]
    $filename = ($dlUrl -split '/')[-1]
    $outPath  = Join-Path $ImagesDir $filename
    $newUrl   = "$NewDomain/assets/images/$filename"
    $urlMap[$url] = $newUrl

    if (Test-Path $outPath) {
        Write-Host "    Already exists: $filename" -ForegroundColor DarkGray
    } else {
        $ok = Download-Asset -Url $dlUrl -OutPath $outPath -BaseTimeout 30
        if ($ok) { Write-Host "    + $filename" -ForegroundColor Gray }
    }
}

# ── Update HTML Files ─────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  PHASE 3 — Rewriting HTML Files" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

foreach ($file in $htmlFiles) {
    $content  = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    $count    = 0

    foreach ($oldUrl in $urlMap.Keys) {
        $newUrl = $urlMap[$oldUrl]

        # 1. Replace full https:// version
        $esc = [regex]::Escape($oldUrl)
        if ($content -match $esc) {
            $content = [regex]::Replace($content, $esc, $newUrl)
            $count++
        }

        # 2. Replace protocol-relative // version (same URL without https:)
        $prUrl = $oldUrl -replace '^https:', ''
        $escPr = [regex]::Escape($prUrl)
        if ($content -match $escPr) {
            $content = [regex]::Replace($content, $escPr, $newUrl)
            $count++
        }

        # 3. Replace HTML-entity-encoded variant (& → &amp; in query strings)
        $encUrl = $oldUrl -replace '&', '&amp;'
        if ($encUrl -ne $oldUrl) {
            $escEnc = [regex]::Escape($encUrl)
            if ($content -match $escEnc) {
                $content = [regex]::Replace($content, $escEnc, $newUrl)
                $count++
            }
        }
    }

    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Updated: $($file.Name)  ($count replacements)" -ForegroundColor Green
    } else {
        Write-Host "  No changes: $($file.Name)" -ForegroundColor DarkGray
    }
}

# ── Summary ───────────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  DONE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Assets saved to:" -ForegroundColor White
Write-Host "    Fonts:  $FontsDir" -ForegroundColor Yellow
Write-Host "    Images: $ImagesDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "    1. Push the 'assets' folder to your GitHub repo root" -ForegroundColor Gray
Write-Host "    2. Verify it's accessible at:" -ForegroundColor Gray
Write-Host "         https://shehanferoze.com/assets/fonts/" -ForegroundColor Gray
Write-Host "         https://shehanferoze.com/assets/images/" -ForegroundColor Gray
Write-Host "    3. Open a page in the browser -> Network tab" -ForegroundColor Gray
Write-Host "       All assets should now load from shehanferoze.com" -ForegroundColor Gray
Write-Host ""
