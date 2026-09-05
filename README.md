# polystack-devkit

Public **PolyStack DevKit** documentation, package metadata, and a nuget.org blank Aspire sample.

Use this repository to learn the DevKit surface, export `*.polystack-scheme.json`, and start a new AppHost without the private Multicloud platform.

| Artifact | Purpose |
|----------|---------|
| [Docs site](https://getpolystack.github.io/devkit) | **GitHub Pages** — Development Guide + Architecture (EN / PT-BR) |
| [DevelopmentGuide.md](./DevelopmentGuide.md) | Short markdown summary + pointer to the Pages site |
| [PACKAGE.md](./PACKAGE.md) | Short README embedded in DevKit NuGet packages |
| [samples/blank](https://github.com/getpolystack/devkit/tree/main/samples/blank) | Minimal Aspire AppHost restored from nuget.org |
| `packages/` | Optional staging folder for Trusted Publishing / release assets (gitignored binaries) |

Public fork: [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)

## NuGet

Current train: **`0.1.0-preview.7`**

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.7
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.7
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.7
dotnet add package PolyStack.Aspire.Hosting.Demo.Abstractions --version 0.1.0-preview.7
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

Open **[https://getpolystack.github.io/devkit](https://getpolystack.github.io/devkit)**. Tabs:

- **Development Guide** — install, compose, export scheme
- **Architecture** — conceptual module layout and scheme lifecycle

Language: `?lang=en` / `?lang=pt`. Page: `?page=guide` / `?page=architecture`.

## Demo UI

After AppHost `Build()`, open **http://localhost:18889/** for the Demo wizard → simplified topology. Scheme/topology stay on disk under `.polystack/` (metadata only; no download in the Demo UI).

## Maintainers

- Build docs: [`scripts/build-docs.ps1`](./scripts/build-docs.ps1) (app in `docs-page/` → output `docs/`)
- Sync public fork: [`scripts/publish-fork.ps1`](./scripts/publish-fork.ps1)

See [PUBLISH.md](./PUBLISH.md).
