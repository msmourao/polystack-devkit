# How to publish (maintainers)

## nuget.org Trusted Publishing field

That form is **not** for the software license. Fill:

| Field | Value |
|-------|--------|
| CI/CD Provider | GitHub Actions |
| Repository Owner | `getpolystack` |
| Repository | `polystack-devkit` |
| **Workflow File** | **`publish.yml`** |

Also set GitHub repo secret **`NUGET_USER`** = your nuget.org **username** (profile name, not email).

## Recommended path (private monorepo)

From the PolyStack monorepo:

```powershell
$env:NUGET_API_KEY = '<nuget.org API key>'
powershell -ExecutionPolicy Bypass -File scripts/publish-devkit.ps1 -Version 0.1.0-preview.3
```

This packs the DevKit profile, stages `.nupkg` files under this repo's `packages/` folder (gitignored), and pushes to nuget.org.

## Alternate path (GitHub Release + workflow)

1. Pack in the private monorepo (`scripts/pack-polystack.ps1 -Profile DevKit -Version 0.1.0-preview.3`).
2. Create a GitHub **Release** on `getpolystack/polystack-devkit` (e.g. tag `v0.1.0-preview.3`) and attach every `.nupkg`.
3. The **Publish to nuget.org** workflow runs on release (or run it manually after placing nupkgs in `packages/`).
4. Confirm packages on nuget.org.

License text for humans is [LICENSE](./LICENSE). Package metadata embeds the same file when packing from the monorepo.
