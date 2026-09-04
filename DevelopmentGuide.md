# PolyStack DevKit — Development Guide

> **HTML docs (GitHub Pages):** open [`docs/`](./docs/) in this repository.

Public, local-first guide for structuring PolyStack-shaped applications and exporting an architecture scheme.

**Repository:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Packages:** `0.1.0-preview.6` (obfuscated) on [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo)  
**Blank sample:** [`samples/blank`](./samples/blank)

The bilingual site under **[`docs/`](./docs/)** includes:

- Development Guide (`?page=guide`)
- Architecture overview (`?page=architecture`)
- Language toggle (`?lang=en` / `?lang=pt`)

---

## English (summary)

### Quick start (blank sample)

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# schema UI: http://localhost:18889/
```

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.6
```

### Compose modules

```csharp
var poly = builder.AsPolyStackDistributedApplicationBuilder();
poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");
poly.Build().Run();
```

### Export scheme

1. Build / F5 the DevKit AppHost.
2. Open **http://localhost:18889/**.
3. Generate and download `*.polystack-scheme.json` (metadata only — no secrets/binaries/live URLs).

---

## Português (resumo)

### Início rápido

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# UI de scheme: http://localhost:18889/
```

### Compor módulos

```csharp
var poly = builder.AsPolyStackDistributedApplicationBuilder();
poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");
poly.Build().Run();
```

### Exportar scheme

1. Build / F5 do AppHost DevKit.
2. Abra **http://localhost:18889/**.
3. Gere e baixe `*.polystack-scheme.json` (só metadados).

---

For the full bilingual guide and architecture overview, use the Pages site in [`docs/`](./docs/).
