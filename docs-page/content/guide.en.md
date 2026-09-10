# PolyStack DevKit — Development Guide

Public, local-first guide for building applications with PolyStack, Aspire, and .NET modules.  
**Repository:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Packages:** `0.1.0-preview.8` on [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo) (`PolyStack.Aspire.Hosting.Demo*`)  
**Blank sample:** [`samples/blank`](https://github.com/getpolystack/devkit/tree/main/samples/blank)  
**LLM / agents:** [LLM.md](https://github.com/getpolystack/devkit/blob/main/LLM.md) · https://getpolystack.com/ai/getstarted.txt

Mirrors the monorepo DevelopmentGuide recipe (declare-first). DevKit stays on Demo `:18889` and local adapters; Multicloud / Canary live in the private monorepo.

---

## 1. Choose your host

| | **DevKit (local-first)** | **Multicloud (platform)** |
|--|--------------------------|---------------------------|
| Sidecar | Demo SchemaExtraction **:18889** — wizard → topology (hollow; no scheme download UI) | Settings.App **:18888** — editable SoT + CD dry-run |
| AppHost mode | `PolyStackAppHostMode=DevKit` | `PolyStackAppHostMode=Multicloud` |
| Persistence / broker | SQLite + InMemory (+ Auth.None typical) | SqlServer/Postgre + DynamicSelection + Aws/Azure |
| On-disk artifacts | `.polystack/` scheme + topology + draft (metadata; Demo UI does **not** export) | `polystack-settings.json` (+ topology) |
| Sample | DevKit blank (`samples/blank` on nuget.org / this repo) | Canary (gold Multicloud harness in the monorepo) |

```powershell
# DevKit blank sample (this repo / nuget.org)
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# Demo wizard / topology: http://localhost:18889/
```

Required packages (already referenced by the blank sample) — train **0.1.0-preview.8+**:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.8
```

When you add an API host project, also reference:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.8
dotnet add package PolyStack.Presentation.HostedService --version 0.1.0-preview.8
```

> **NuGet note:** package IDs use the `PolyStack.Aspire.Hosting.Demo*` prefix because `Aspire.Hosting.*` is reserved on nuget.org. Project and assembly names still follow the Aspire hosting convention.

The Demo UI does **not** download the scheme. Files may still land under `.polystack/` (scheme + topology + draft) for tooling after AppHost `Build()`.

---

## 2. Compose the AppHost

```csharp
var inner = DistributedApplication.CreateBuilder(args);
var builder = inner.AsPolyStackDistributedApplicationBuilder();

// Multicloud only — Settings :18888 (not used in DevKit blank)
// builder.WithSettingsApp();

builder.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");

builder.AddViteApp("my-web", "../web")
    .AsExternalPolyStackModule(builder, "MyWeb", StackModuleSource.Frontend)
    .WithHint(builder, "frontend", "frontend.StaticSite(cdn=false)::Low");

builder.Build().Run();
```

Also available:

- Python / Docker → `AddDockerfile(...).WithHttpEndpoint(...).AsExternalPolyStackModule(...)`
- Queues / topics → `AddMessageQueue<TEvent>()`, `AddMessageTopic<TEvent>()`
- Hints / managed config → `WithHint`, `WithManagedConfig` (complements `[Hints]` / attributes)

---

## 3. Controllers (Presentation)

1. Marker: `IDynamicPresentation<TApplicationBuilder>`
2. Controllers under `Controllers/` (REST surface; Problem Details for errors)
3. Application: `ApplicationBuilder` + CQRS handlers
4. Contracts: DTOs `*Request` / `*Response`, events under `Events/`
5. Optional gRPC bridge: `{Module}GrpcService` under `Presentation/Grpc/` (Invoke → MVC)

Inferred protocol: **PolyStack modules → gRPC**, **Python → HTTP**.

---

## 4. Queues (declare, don’t pick a broker by hand)

```csharp
// AppHost — declare the logical queue
var queue = builder.AddMessageQueue<MyEventRequested>();

builder.AddPolyStackModule<MyHandlerPresentation, MyHandlerApplicationBuilder>("handler-api")
    .WithQueueEventSource(queue); // serverless: SQS / Service Bus mapping from settings
```

- Message contract in `*.Api.Contracts/Events/` (CloudEvents `type`)
- Consumer: implement `IMessageHandler<T>` (+ `IQueueConfig<T>` registration convention)
- **Do not** choose SQS vs Service Bus in application code — settings + DynamicSelection decide (DevKit local host uses in-memory adapters)

Topics:

```csharp
builder.AddMessageTopic<MyDomainEvent>();
```

---

## 5. Publish messages

```csharp
await publisher.PublishAsync(new MyEventRequested { /* ... */ }, cancellationToken);
```

Use `IMessagePublisher.PublishAsync` / CloudEvents. Queue names come from conventions (`QueueNameConvention`, `IQueueConfig<T>`), not from a typed FlowMessage registry.

**Do not revive** `FlowMessage` or `IQueueMappingRegistry`.

---

## 6. Object storage

- Subclass `ObjectStorage("logical-name")` in your module; discovery + settings overlays bind cloud targets
- **Do not** invent `AddObjectStorage(...)` on the AppHost
- Multicloud sample: Canary `canary-assets` in settings `objectStorages` (monorepo)

---

## 7. Hubs, sync calls, frontend

**Hubs (SignalR):**

```csharp
public sealed class CanaryModuleHubHandler : ModuleHubHandlerBase, IModuleHubHandler
{
    public static string Route => "/hubs/canary";
}
```

Auto-registered via hub declarations → topology. Browser transport: `websocket` (not gRPC).

**Sync module calls:**

```csharp
public sealed class MySynchronousModuleCallRegistrar : SynchronousModuleCallRegistrarBase
{
    protected override void RegisterSynchronousModuleCalls(IServiceCollection services)
    {
        Add<OtherModulePresentation>(services);
        AddExternal(services, "InstagramScanner"); // Python HTTP
    }
}
```

Aspire injects `PolyStack__Grpc__{ClientName}` (or Http for Python).

**Frontend (Vite):**

```csharp
builder.AddViteApp("canary-web", "../web")
    .AsExternalPolyStackModule(builder, "CanaryWeb", StackModuleSource.Frontend);
```

Settings `moduleCalls` example (Multicloud):

```json
{ "from": "CanaryWeb", "to": "Canary" }
```

Runtime config: CD stamps `dist/config.json`; local F5 can use `GET /api/settings/frontends/{key}/runtime-config`.

---

## 8. What lands on disk vs settings vs runtime inject

| Artifact | Role |
|----------|------|
| `polystack-settings.json` | Multicloud SoT: clouds, hosting, DBs, moduleCalls, frontends, objectStorages, CD flags |
| Topology / scheme under `.polystack/` | Catalog metadata for Aspire / Demo / Settings lab — **not** downloaded from Demo UI |
| `POLYSTACK_*` / `PolyStack__Grpc__*` env | Runtime inject from Aspire / CD stamps |
| Demo draft (`devkit-demo-draft.json`) | Hollow wizard state only — not production SoT |

Settings (:18888) is the Multicloud control plane. Demo (:18889) is onboarding / topology illustration.

Scheme documents may include `format: "polystack-scheme"`, a schema version, optional feedback, and a `security` block (no secrets / binaries / live endpoints — egress as logical keys only).

---

## 9. Samples

| Sample | Purpose |
|--------|---------|
| DevKit blank (`samples/blank`) | Consumer AppHost + Demo :18889 without monorepo ProjectRefs (nuget.org packages) |
| Canary (monorepo) | Gold Multicloud harness: dual DB, queues, hub, FE, object storage, Peer cross-module |

When you graduate beyond DevKit:

```text
Demo.Host (local adapters)     → platform host selection
Demo AppHost facade            → Multicloud Aspire kit
*.polystack-scheme.json        → import tool (operator fills clouds / settings)
```

---

## 9b. Canary recipes (Multicloud monorepo)

Declare-first patterns used by the gold harness (private monorepo `solutions/canary`):

| Recipe | Declare |
|--------|---------|
| Queues Canary↔Peer | `IQueueConfig<CanaryPeerNotified>` + Peer `IMessageHandler<>` |
| Topic | settings `topics.canary-domain-events` |
| Hub | `Route => "/hubs/canary"` on `ModuleHubHandlerBase` |
| Object storage | `ObjectStorage("canary-assets")` + settings `objectStorages` |
| API gateway harness | `apiGateways.clouds.Azure.enabled = false` |
| Egress | `egressCalls[]` (host allow-list; no raw HttpClient) |
| Sidecars | Settings **:18888** (full lab) · Demo hollow topology **:18889** · Config Lab playground uses the **same** hollow motor |

Shared hollow topology JS/CSS: monorepo `PolyStack.TopologyLab.Web` (Demo motor; Settings keeps full lab chrome). Presentation site Config Lab hosts the same assets via `/shared/topology-lab/`.

---

## 10. Troubleshooting

| Symptom | Fix |
|---------|-----|
| Wrong port / empty Settings UI | Multicloud → **:18888**; Demo wizard → **:18889** |
| Demo catalog empty | Ensure AppHost `Build()` ran with modules registered; check `.polystack/` |
| Expecting scheme download on :18889 | Removed from Demo UI — files still written under `.polystack/` for tooling |
| Blank sample catalog empty | Register at least one module (blank starts empty), run AppHost Build, reload `:18889` |
| Demo.Host restore missing ObjectStorage.InMemory | Use train **0.1.0-preview.8+** (package added to the public set) |

---

## 11. LLM / AI assistants

| Resource | Use |
|----------|-----|
| https://getpolystack.com/llms.txt | Site pointer |
| https://getpolystack.com/ai/getstarted.txt | Agent entrypoint (`#IDENTITY` / `#PREVIEW`) |
| [LLM.md](https://github.com/getpolystack/devkit/blob/main/LLM.md) | DevKit-specific agent notes (FETCH vs READING, PackageIds) |

Do **not** invent Multicloud CD from DevKit docs alone. Config Lab on getpolystack.com is an illustrative playground (mock data), not the delivery path.

## Language

This guide and the Demo UI follow the browser language (`?lang=pt` / `?lang=en`).
