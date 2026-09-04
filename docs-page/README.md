# DevKit docs page (source). Built into ../docs for GitHub Pages.

## Develop

From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1 -Run
```

Or:

```powershell
cd docs-page
npm install
npm run dev
```

## Build (writes to `../docs`)

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1
```

Then sync the public fork:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1
```

Site: https://getpolystack.github.io/devkit
