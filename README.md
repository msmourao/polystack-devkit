# polystack-devkit

Public **PolyStack DevKit** documentation, package metadata, and a nuget.org blank Aspire sample.

Use this repository to learn the DevKit surface, export `*.polystack-scheme.json`, and start a new AppHost without the private Multicloud platform.

| Artifact | Purpose |
|----------|---------|
| [Docs site](https://getpolystack.github.io/devkit) | **GitHub Pages** — Development Guide + Architecture (EN / PT-BR) |
| [DevelopmentGuide.md](./DevelopmentGuide.md) | Short markdown summary + pointer to the Pages site |
| [LLM.md](./LLM.md) | **AI / LLM instructions** — where agents start (`getpolystack.com/ai`), identity, FETCH vs READING |
| [PACKAGE.md](./PACKAGE.md) | Short README embedded in DevKit NuGet packages |
| [PACKAGES.md](./PACKAGES.md) | Full public package list for this train |
| [CHANGELOG.md](./CHANGELOG.md) | Train notes |
| [samples/blank](./samples/blank) | Minimal Aspire AppHost restored from nuget.org |
| `packages/` | Optional staging folder for Trusted Publishing / release assets (gitignored binaries) |

Public brand (org): [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit) · Maintainer SoT: this repo (`msmourao/polystack-devkit`). Both remotes stay public; sync brand with `scripts/publish-fork.ps1`.

## Report issues

**Prefer brand inbox:** [getpolystack/devkit/issues](https://github.com/getpolystack/devkit/issues) (org `getpolystack` — enable Issues in repo settings if disabled).

**SoT mirror (Issues on):** [msmourao/polystack-devkit/issues](https://github.com/msmourao/polystack-devkit/issues)

- Use these for WebKit / DevKit samples, docs site, and **NuGet package** consumption problems.
- Platform Multicloud, Settings sidecar, and CD sources stay **private** (`polystack-framework`); consume via NuGet when published.
- Org admin login after user→org conversion: `getpolystack-user` (needed to toggle Issues / repo admin features). Operator `msmourao` has write on brand `devkit`.

## NuGet

Current train: **`0.1.0-preview.8`** (obfuscated binaries on nuget.org)

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.Abstractions --version 0.1.0-preview.8
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

## For AI assistants / LLMs

Start at **[LLM.md](./LLM.md)** or live **https://getpolystack.com/ai/getstarted.txt** (also linked from https://getpolystack.com/llms.txt).

Do not invent Multicloud CD steps from this repo alone. Config Lab on the marketing site is an illustrative playground; real delivery paths are DevKit (local) and the private Settings/Canary harness.

## Docs site

Open **[https://getpolystack.github.io/devkit](https://getpolystack.github.io/devkit)**. Tabs:

- **Development Guide** — install, compose, export scheme
- **Architecture** — conceptual module layout and scheme lifecycle

Language: `?lang=en` / `?lang=pt`. Page: `?page=guide` / `?page=architecture`.

## Demo UI

After AppHost `Build()`, open **http://localhost:18889/** for the Demo wizard → simplified topology (hollow motor shared with the presentation Config Lab map). Scheme/topology stay on disk under `.polystack/` (metadata only; no download in the Demo UI).

## Maintainers

- Build docs: [`scripts/build-docs.ps1`](./scripts/build-docs.ps1) (app in `docs-page/` → output `docs/`)
- Sync public fork: [`scripts/publish-fork.ps1`](./scripts/publish-fork.ps1)

See [PUBLISH.md](./PUBLISH.md).
