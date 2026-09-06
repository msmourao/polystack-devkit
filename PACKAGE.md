# PolyStack DevKit

Local-first packages for structuring PolyStack-shaped applications. Architecture metadata (`*.polystack-scheme.json`) is written under `.polystack/` for a future Settings import; the Demo sidecar is a wizard ending on a simplified topology.

## Install

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.Abstractions --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.8
```

> NuGet package IDs use `PolyStack.Aspire.Hosting.Demo*` because `Aspire.Hosting.*` is reserved on nuget.org.

## Docs

- Full bilingual guide + architecture: [getpolystack.github.io/devkit](https://getpolystack.github.io/devkit) · [DevelopmentGuide.md](https://github.com/getpolystack/devkit/blob/main/DevelopmentGuide.md)
- LLM / agents: [LLM.md](https://github.com/getpolystack/devkit/blob/main/LLM.md) · https://getpolystack.com/ai/getstarted.txt
- Blank Aspire sample: [samples/blank](https://github.com/getpolystack/devkit/tree/main/samples/blank)
- Repository: [getpolystack/devkit](https://github.com/getpolystack/devkit)

## Demo UI

After a DevKit AppHost `Build()`, open **http://localhost:18889/** for the Demo wizard → simplified topology. Scheme/topology files stay on disk (metadata only — no secrets, binaries, or live URLs); there is no scheme download in the Demo UI.
