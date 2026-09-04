# DevKit package list (nuget.org)

Current train: **`0.1.0-preview.6`**

## DevKit shell

| Package | Role |
|---------|------|
| `PolyStack.Aspire.Hosting.Demo.Abstractions` | Topology schema / validation / catalog types |
| `PolyStack.Aspire.Hosting.Demo.Host` | Local host wiring (InMemory broker, SQLite, Auth.None) |
| `PolyStack.Aspire.Hosting.Demo` | AppHost facade (`AsPolyStackDistributedApplicationBuilder`, scheme export, schema UI attach) |
| `PolyStack.Aspire.Hosting.Demo.SchemaExtraction` | Read-only catalog UI on `:18889` (runnable `tools/` payload) |
| `PolyStack.Architecture.Testing` | Architecture convention tests (add from your `*.Tests` project) |

> Assemblies remain named `Aspire.Hosting.PolyStackDemo*`. NuGet IDs use the `PolyStack.` vendor prefix because `Aspire.Hosting.*` is reserved on nuget.org.

## Application / presentation

| Package |
|---------|
| `PolyStack.Application.Core` |
| `PolyStack.Application.Cqrs.Abstractions` |
| `PolyStack.Application.Mapping.Abstractions` |
| `PolyStack.Application.Persistence.Abstractions` |
| `PolyStack.Presentation.Core` |
| `PolyStack.Presentation.HostedService` |
| `PolyStack.Presentation.Auth.Abstractions` |
| `PolyStack.Presentation.Auth.None` |
| `PolyStack.Presentation.Auth.Provider.Abstractions` |
| `PolyStack.Presentation.Auth.Provider.None` |

## Domain / shared

| Package |
|---------|
| `PolyStack.Common` |
| `PolyStack.Domain` |
| `PolyStack.Mediator` |
| `PolyStack.Grpc.Contracts` |
| `PolyStack.ServiceDefaults` |
| `PolyStack.Hints.Abstractions` |
| `PolyStack.Infrastructure.Core` |

## Messaging / storage / persistence (local-first)

| Package |
|---------|
| `PolyStack.Infrastructure.MessageBroker.Abstractions` |
| `PolyStack.Infrastructure.MessageBroker.Core` |
| `PolyStack.Infrastructure.MessageBroker.InMemory` |
| `PolyStack.Infrastructure.MessageBroker.Resources.Abstractions` |
| `PolyStack.Infrastructure.ObjectStorage.Abstractions` |
| `PolyStack.Infrastructure.ObjectStorage.Disabled` |
| `PolyStack.Infrastructure.Persistence.Abstractions` |
| `PolyStack.Infrastructure.Persistence.Core` |
| `PolyStack.Infrastructure.Persistence.DatabaseProvider.Abstractions` |
| `PolyStack.Infrastructure.Persistence.Sqlite` |
| `PolyStack.Infrastructure.WebSocket.Abstractions` |
| `PolyStack.Infrastructure.WebSocket.Core` |
| `PolyStack.Infrastructure.WebSocket.Disabled` |
| `PolyStack.Infrastructure.WebSocket.SignalR` |

## Not in this feed (platform — private)

`Host.BuildTimeSelection`, Multicloud Aspire kits, cloud persistence/auth adapters, Settings.*, Inventory.*, Deploy, ProjectGenerator, etc.
