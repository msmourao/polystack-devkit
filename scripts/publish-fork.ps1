# Sync msmourao/polystack-devkit (this repo) to getpolystack/devkit (public fork).
#
# Usage (from repo root or anywhere):
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1 -SkipPush
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1 -ForkRoot "D:\path\to\devkit"
#
# Maintainer-only (versioned here, excluded from the fork):
#   scripts/   - publish/build helpers
#   docs-page/ - React docs app source (build output goes to docs/)

[CmdletBinding()]
param(
    [string]$ForkRoot = "",
    [string]$Message = "Sync from msmourao/polystack-devkit",
    [switch]$SkipPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SourceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if ([string]::IsNullOrWhiteSpace($ForkRoot)) {
    $ForkRoot = Join-Path (Split-Path $SourceRoot -Parent) "devkit"
}
$ForkRoot = [System.IO.Path]::GetFullPath($ForkRoot)
$ForkHttps = "https://github.com/getpolystack/devkit.git"

Write-Host "Source (original): $SourceRoot"
Write-Host "Fork clone:        $ForkRoot"

if (-not (Test-Path -LiteralPath (Join-Path $ForkRoot ".git"))) {
    throw "Fork clone not found or not a git repo: $ForkRoot"
}

Push-Location $ForkRoot
try {
    $originUrl = (git remote get-url origin 2>$null)
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($originUrl)) {
        throw "Could not read origin remote in $ForkRoot"
    }
    if ($originUrl -notmatch 'getpolystack[/:]devkit(\.git)?$') {
        throw "Fork origin must point to getpolystack/devkit. Current: $originUrl"
    }
    Write-Host "Fork origin:       $originUrl"

    $status = git status --porcelain
    if ($status) {
        throw "Fork working tree is not clean. Commit or stash changes in $ForkRoot first.`n$status"
    }
}
finally {
    Pop-Location
}

# Mirror tracked content into the fork, excluding maintainer-only trees and local junk.
$excludeDirs = @(
    ".git",
    "scripts",
    "docs-page",
    "bin",
    "obj",
    ".vs",
    ".aspire",
    ".idea",
    ".polystack",
    "packages"
)

$robocopyArgs = @(
    $SourceRoot,
    $ForkRoot,
    "/E",
    "/NFL", "/NDL", "/NJH", "/NJS", "/NP",
    "/XD"
) + $excludeDirs

Write-Host "Syncing files (excluding scripts/, docs-page/, and build artifacts)..."
& robocopy @robocopyArgs | Out-Null
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}
$global:LASTEXITCODE = 0

function Ensure-ForkIgnoreLine {
    param(
        [string]$GitIgnorePath,
        [string]$RelativePath,
        [string]$Comment
    )

    $text = if (Test-Path -LiteralPath $GitIgnorePath) {
        Get-Content -LiteralPath $GitIgnorePath -Raw
    } else {
        ""
    }
    if ($null -eq $text) { $text = "" }

    $pattern = '(?m)^' + [regex]::Escape($RelativePath) + '\s*$'
    if ($text -match $pattern) {
        return $false
    }

    if ($text.Length -gt 0 -and -not $text.EndsWith("`n")) {
        $text += "`n"
    }
    $text += "`n$Comment`n$RelativePath`n"
    Set-Content -LiteralPath $GitIgnorePath -Value $text -Encoding utf8 -NoNewline
    return $true
}

Push-Location $ForkRoot
try {
    $gitignorePath = Join-Path $ForkRoot ".gitignore"
    if (Ensure-ForkIgnoreLine -GitIgnorePath $gitignorePath -RelativePath "scripts/" -Comment "# Maintainer-only: lives in msmourao/polystack-devkit, not in this public fork") {
        Write-Host "Added scripts/ to fork .gitignore"
    }
    if (Ensure-ForkIgnoreLine -GitIgnorePath $gitignorePath -RelativePath "docs-page/" -Comment "# Maintainer-only: docs React app source; public site is docs/") {
        Write-Host "Added docs-page/ to fork .gitignore"
    }

    foreach ($dirName in @("scripts", "docs-page")) {
        $path = Join-Path $ForkRoot $dirName
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Recurse -Force
            Write-Host "Removed $dirName/ from fork working tree"
        }

        $tracked = git ls-files -- $dirName 2>$null
        if ($tracked) {
            git rm -r --cached --ignore-unmatch $dirName | Out-Null
            Write-Host "Untracked $dirName/ from fork index"
        }
    }

    git add -A
    $pending = git status --porcelain
    if (-not $pending) {
        Write-Host "No changes to publish (fork already up to date)."
        return
    }

    git commit -m $Message
    if ($LASTEXITCODE -ne 0) {
        throw "git commit failed in fork"
    }

    if ($SkipPush) {
        Write-Host "SkipPush set - commit created locally in $ForkRoot"
        return
    }

    Write-Host "Pushing to $ForkHttps ..."
    git push $ForkHttps HEAD:main
    if ($LASTEXITCODE -ne 0) {
        throw "git push failed for getpolystack/devkit"
    }

    Write-Host "Published to getpolystack/devkit."
    Write-Host "Docs: https://getpolystack.github.io/devkit"
}
finally {
    Pop-Location
}
