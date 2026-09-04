# Build (or run) the DevKit docs React app from docs-page/.
# Build output goes to ../docs (GitHub Pages), not dist/.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1 -Run
#   powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1 -Install

[CmdletBinding()]
param(
    [switch]$Run,
    [switch]$Install
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$appRoot = Join-Path $repoRoot "docs-page"
$docsOut = Join-Path $repoRoot "docs"

if (-not (Test-Path -LiteralPath (Join-Path $appRoot "package.json"))) {
    throw "docs-page app not found at $appRoot"
}

Push-Location $appRoot
try {
    $needsInstall = $Install -or -not (Test-Path -LiteralPath (Join-Path $appRoot "node_modules"))
    if ($needsInstall) {
        Write-Host "npm install in docs-page..."
        npm install
        if ($LASTEXITCODE -ne 0) {
            throw "npm install failed"
        }
    }

    if ($Run) {
        Write-Host "Starting docs-page dev server (vite)..."
        npm run dev
        if ($LASTEXITCODE -ne 0) {
            throw "npm run dev failed"
        }
        return
    }

    Write-Host "Building docs-page -> $docsOut"
    npm run build
    if ($LASTEXITCODE -ne 0) {
        throw "npm run build failed"
    }

    $nojekyll = Join-Path $docsOut ".nojekyll"
    if (-not (Test-Path -LiteralPath $nojekyll)) {
        Set-Content -LiteralPath $nojekyll -Value "" -Encoding ascii
    }

    $count = @(Get-ChildItem -LiteralPath $docsOut -Force | Select-Object -ExpandProperty Name).Count
    Write-Host "Docs site ready in docs/ ($count entries)."
    Write-Host "Public URL after fork sync: https://getpolystack.github.io/devkit"
}
finally {
    Pop-Location
}
