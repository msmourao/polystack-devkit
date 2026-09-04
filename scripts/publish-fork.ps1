# Sync msmourao/polystack-devkit (this repo) to getpolystack/devkit (public fork).
#
# Usage (from repo root or anywhere):
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1 -SkipPush
#   powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1 -ForkRoot "D:\path\to\devkit"
#
# The scripts/ folder is versioned here but excluded from the fork (fork .gitignore lists scripts/).

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

# Mirror tracked content into the fork, excluding maintainer-only scripts/ and local junk.
$excludeDirs = @(
    ".git",
    "scripts",
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

Write-Host "Syncing files (excluding scripts/ and build artifacts)..."
& robocopy @robocopyArgs | Out-Null
# robocopy exit codes 0-7 are success; >=8 is failure
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}
$global:LASTEXITCODE = 0

Push-Location $ForkRoot
try {
    # Ensure fork ignores scripts/ even if someone copies it in later.
    $gitignorePath = Join-Path $ForkRoot ".gitignore"
    $gitignoreText = if (Test-Path -LiteralPath $gitignorePath) {
        Get-Content -LiteralPath $gitignorePath -Raw
    } else {
        ""
    }
    if ($null -eq $gitignoreText) {
        $gitignoreText = ""
    }
    if ($gitignoreText -notmatch '(?m)^scripts/') {
        if ($gitignoreText.Length -gt 0 -and -not $gitignoreText.EndsWith("`n")) {
            $gitignoreText += "`n"
        }
        $gitignoreText += "`n# Maintainer-only: lives in msmourao/polystack-devkit, not in this public fork`nscripts/`n"
        Set-Content -LiteralPath $gitignorePath -Value $gitignoreText -Encoding utf8 -NoNewline
        Write-Host "Added scripts/ to fork .gitignore"
    }

    $scriptsPath = Join-Path $ForkRoot "scripts"
    if (Test-Path -LiteralPath $scriptsPath) {
        Remove-Item -LiteralPath $scriptsPath -Recurse -Force
        Write-Host "Removed scripts/ from fork working tree"
    }

    $trackedScripts = git ls-files -- "scripts" 2>$null
    if ($trackedScripts) {
        git rm -r --cached --ignore-unmatch scripts | Out-Null
        Write-Host "Untracked scripts/ from fork index"
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

    Write-Host "Pushing to origin..."
    git push origin HEAD
    if ($LASTEXITCODE -ne 0) {
        throw "git push failed for getpolystack/devkit"
    }

    Write-Host "Published to getpolystack/devkit."
    Write-Host "Docs: https://getpolystack.github.io/devkit"
}
finally {
    Pop-Location
}
