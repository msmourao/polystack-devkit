# PolyStack DevKit — Development Guide

Public, local-first guide for structuring PolyStack-shaped applications and exporting an architecture scheme you can hand off later.

**Repository:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Packages:** `0.1.0-preview.6` (obfuscated) on [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo)  
**Blank sample:** [`samples/blank`](https://github.com/getpolystack/devkit/tree/main/samples/blank) (nuget.org)

---

## What the DevKit is

The DevKit lets you **compose modules the PolyStack way** — Presentation, Application, contracts, messaging edges, and local adapters — **without** Multicloud provisioning, the private settings editor, or CD pipelines.

| Piece | Role |
|-------|------|
| AppHost facade | Same composition surface as the private platform (`AsPolyStackDistributedApplicationBuilder`, `AddPolyStackModule`, …) |
| Schema extraction UI (`:18889`) | Read-only landing page + download of `*.polystack-scheme.json` |
| Scheme file | Architecture **metadata only** — no secrets, no binaries, no live BaseUrl/Host |
| Local host package | In-process adapters for local runs (message broker, persistence, auth stubs) |

The scheme is intended for a **future import step**: operators fill clouds and environment settings later. The export does **not** ship your application binaries.

> **NuGet note:** package IDs use the `PolyStack.Aspire.Hosting.Demo*` prefix because `Aspire.Hosting.*` is reserved on nuget.org. Project and assembly names still follow the Aspire hosting convention.

## Quick start (blank sample)

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# open http://localhost:18889/
```

Required packages (already referenced by the sample):

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.6
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.6
```

When you add an API host project, also reference:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.6
dotnet add package PolyStack.Presentation.HostedService --version 0.1.0-preview.6
```

## Compose modules in AppHost

```csharp
// Same surface as the platform — swap packages later without rewriting composition.
var poly = builder.AsPolyStackDistributedApplicationBuilder();

poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");

poly.Build().Run();
```

Also supported patterns:

- **Queues / topics** — `AddMessageQueue<TEvent>()`, `AddMessageTopic<TEvent>()`
- **External HTTP / Docker** — `AddDockerfile(...).AsExternalPolyStackModule(...)`
- **Frontend** — `AddViteApp(...).AsExternalPolyStackModule(..., StackModuleSource.Frontend)`
- **Hints / managed config** — `.WithHint(...)` and `.WithManagedConfig(...)` (captured into the scheme)

## Export `*.polystack-scheme.json`

1. Build / F5 the DevKit AppHost once.
2. Open **http://localhost:18889/**.
3. Optionally add feedback, then generate and download `*.polystack-scheme.json`.

The document includes `format: "polystack-scheme"`, a schema version, optional feedback, and a `security` block stating:

- no secrets / credentials / connection strings
- no binaries
- no live endpoints (egress is expressed as **logical keys** only)

Files are typically written under `.polystack/` next to the AppHost (regenerated on Build).

## If the UI shows “No resources loaded”

The catalog is empty. Typical causes:

1. The AppHost has not registered modules yet (the blank sample starts this way).
2. The schema UI was started alone, without a generated scheme/topology.
3. Build has not run, so `.polystack/*.polystack-scheme.json` was never written.

Fix: register at least one module, run AppHost Build, reload `:18889`.

## Module shape (checklist)

1. **Presentation** — marker type, controllers under `Controllers/`
2. **Application** — application builder + CQRS handlers
3. **Contracts** — request/response DTOs and events
4. **gRPC bridge** (PolyStack modules) — `{Module}GrpcService` under Presentation

Protocol convention: **PolyStack modules speak gRPC**; some external modules may use HTTP.

## Growing beyond the DevKit

When you are ready for the private platform:

```text
Demo.Host (local adapters)     → platform host selection
Demo AppHost facade            → Multicloud Aspire kit
*.polystack-scheme.json        → import tool (operator fills clouds / settings)
```

## Language

This guide and the schema UI follow the browser language (`?lang=pt` / `?lang=en`).
