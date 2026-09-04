# PolyStack DevKit

Local-first packages for structuring PolyStack-shaped applications and exporting architecture metadata (`*.polystack-scheme.json`).

## Install

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.Abstractions --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.6
```

> NuGet package IDs use `PolyStack.Aspire.Hosting.Demo*` because `Aspire.Hosting.*` is reserved on nuget.org.

## Docs

- Full bilingual guide + architecture: [docs/](https://github.com/getpolystack/devkit/tree/main/docs) (GitHub Pages) · [DevelopmentGuide.md](https://github.com/getpolystack/devkit/blob/main/DevelopmentGuide.md)
- Blank Aspire sample: [samples/blank](https://github.com/getpolystack/devkit/tree/main/samples/blank)
- Repository: [getpolystack/devkit](https://github.com/getpolystack/devkit)

## Schema UI

After a DevKit AppHost `Build()`, open **http://localhost:18889/** to download `*.polystack-scheme.json` (metadata only — no secrets, binaries, or live URLs).
