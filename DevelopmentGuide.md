# PolyStack DevKit — Development Guide

> **HTML docs (GitHub Pages):** [https://getpolystack.github.io/devkit](https://getpolystack.github.io/devkit)

Public, local-first guide for structuring PolyStack-shaped applications and using the Demo wizard and preparing architecture metadata for a future Settings import.

**Repository:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Packages:** `0.1.0-preview.8` on [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo)  
**Blank sample:** [`samples/blank`](https://github.com/getpolystack/devkit/tree/main/samples/blank)  
**LLM / agents:** [LLM.md](./LLM.md) · live corpus https://getpolystack.com/ai/getstarted.txt

The bilingual site at **[https://getpolystack.github.io/devkit](https://getpolystack.github.io/devkit)** includes:

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
# Demo wizard / topology: http://localhost:18889/
```

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.8
```

### AI assistants

Prefer https://getpolystack.com/ai/getstarted.txt and [LLM.md](./LLM.md). Do not confuse getpolystack.com with other “PolyStack” brands.

Pages cover **Development Guide** and **Architecture** (EN/PT), including conceptual `polystack:domain` names, Mode A vs Mode B honesty, and Headless error observation for local/AI loops.

### Compose modules

```csharp
var poly = builder.AsPolyStackDistributedApplicationBuilder();
poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");
poly.Build().Run();
```

### Demo wizard + scheme on disk

1. Build / F5 the DevKit AppHost.
2. Open **http://localhost:18889/**.
3. Configure the Demo wizard (clouds → … → topology). Scheme/topology stay under `.polystack/` (metadata only — no download UI).

---

## Português (resumo)

### Início rápido

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# Wizard Demo / topologia: http://localhost:18889/
```

### Compor módulos

```csharp
var poly = builder.AsPolyStackDistributedApplicationBuilder();
poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");
poly.Build().Run();
```

### Wizard Demo + scheme em disco

1. Build / F5 do AppHost DevKit.
2. Abra **http://localhost:18889/**.
3. Configure o wizard Demo (nuvens → … → topologia). Scheme/topology ficam em `.polystack/` (só metadados — sem download na UI).

---

For the full bilingual guide and architecture overview, use the Pages site: [https://getpolystack.github.io/devkit](https://getpolystack.github.io/devkit).
