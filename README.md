# polystack-devkit

Public **PolyStack DevKit** documentation, package metadata, and a nuget.org blank Aspire sample.

Use this repository to learn the DevKit surface, export `*.polystack-scheme.json`, and start a new AppHost without the private Multicloud platform.

| Artifact | Purpose |
|----------|---------|
| [`docs/`](./docs/) | **GitHub Pages** — Development Guide + Architecture (EN / PT-BR) |
| [DevelopmentGuide.md](./DevelopmentGuide.md) | Short markdown summary + pointer to `docs/` |
| [PACKAGE.md](./PACKAGE.md) | Short README embedded in DevKit NuGet packages |
| [samples/blank](./samples/blank) | Minimal Aspire AppHost restored from nuget.org |
| `packages/` | Optional staging folder for Trusted Publishing / release assets (gitignored binaries) |

## NuGet

Current train: **`0.1.0-preview.6`** (obfuscated binaries)

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.Abstractions --version 0.1.0-preview.6
```

> Package IDs use the `PolyStack.Aspire.Hosting.Demo*` prefix because `Aspire.Hosting.*` is reserved on nuget.org. Assemblies still follow the Aspire hosting naming convention.

## Quick start (blank sample)

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
```

Then open the schema UI: [http://localhost:18889/](http://localhost:18889/)

Register modules on the AppHost facade when you are ready; until then the catalog may show an empty state (expected for a blank host).

## Docs site

Open [`docs/`](./docs/) (or GitHub Pages). Tabs:

- **Development Guide** — install, compose, export scheme
- **Architecture** — conceptual module layout and scheme lifecycle

Language: `?lang=en` / `?lang=pt`. Page: `?page=guide` / `?page=architecture`.

## Schema UI

- Local UI after AppHost `Build()`: **http://localhost:18889/**
- Scheme file: architecture **metadata only** (no secrets, binaries, or live URLs)
- Language: browser `Accept-Language` / `navigator.language`, with `?lang=pt` / `?lang=en`

## Maintainers

Pack and push from the private PolyStack monorepo (`scripts/publish-devkit.ps1`), or attach `.nupkg` files to a GitHub Release and use Trusted Publishing. See [PUBLISH.md](./PUBLISH.md).
