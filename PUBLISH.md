# How to publish (maintainers)

## Docs site (build)

The React app lives in `docs-page/` (original only). Build output goes to `docs/` (GitHub Pages).

```powershell
# Dev server
powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1 -Run

# Production build -> docs/
powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1
```

## Sync public fork (`getpolystack/devkit`)

This repo (`msmourao/polystack-devkit`) is the source of truth. The public fork is [getpolystack/devkit](https://github.com/getpolystack/devkit) (GitHub Pages: [getpolystack.github.io/devkit](https://getpolystack.github.io/devkit)).

With a local clone of the fork at `../devkit` (sibling folder):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1
```

The script copies public content into the fork, **excludes `scripts/` and `docs-page/`**, ensures the fork `.gitignore` ignores those folders, commits, and pushes to `getpolystack/devkit`.

```powershell
# Preview commit only
powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1 -SkipPush
```

Typical flow after editing docs content:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-docs.ps1
powershell -ExecutionPolicy Bypass -File scripts/publish-fork.ps1
```

## nuget.org Trusted Publishing field

That form is **not** for the software license. Fill:

| Field | Value |
|-------|--------|
| CI/CD Provider | GitHub Actions |
| Repository Owner | `getpolystack` |
| Repository | `devkit` |
| **Workflow File** | **`publish.yml`** |

Also set GitHub repo secret **`NUGET_USER`** = your nuget.org **username** (profile name, not email).

## Recommended path (private monorepo)

From the PolyStack monorepo:

```powershell
$env:NUGET_API_KEY = '<nuget.org API key>'
powershell -ExecutionPolicy Bypass -File scripts/publish-devkit.ps1 -Version 0.1.0-preview.6
```

This packs the DevKit profile, stages `.nupkg` files under this repo's `packages/` folder (gitignored), and pushes to nuget.org.

## Alternate path (GitHub Release + workflow)

1. Pack in the private monorepo (`scripts/pack-polystack.ps1 -Profile DevKit -Version 0.1.0-preview.6`).
2. Create a GitHub **Release** on `getpolystack/devkit` (e.g. tag `v0.1.0-preview.6`) and attach every `.nupkg`.
3. The **Publish to nuget.org** workflow runs on release (or run it manually after placing nupkgs in `packages/`).
4. Confirm packages on nuget.org.

License text for humans is [LICENSE](./LICENSE). Package metadata embeds the same file when packing from the monorepo.
