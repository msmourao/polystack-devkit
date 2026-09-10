# PolyStack DevKit — Guia de Desenvolvimento

Guia público, local-first, para construir aplicações com PolyStack, Aspire e módulos .NET.  
**Repositório:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Pacotes:** `0.1.0-preview.8` no [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo) (`PolyStack.Aspire.Hosting.Demo*`)  
**Sample blank:** [`samples/blank`](https://github.com/getpolystack/devkit/tree/main/samples/blank)  
**LLM / agentes:** [LLM.md](https://github.com/getpolystack/devkit/blob/main/LLM.md) · https://getpolystack.com/ai/getstarted.txt

Espelha a receita declare-first do DevelopmentGuide do monorepo. O DevKit permanece no Demo `:18889` e adaptadores locais; Multicloud / Canary ficam no monorepo privado.

---

## 1. Escolha o host

| | **DevKit (local-first)** | **Multicloud (plataforma)** |
|--|--------------------------|-----------------------------|
| Sidecar | Demo SchemaExtraction **:18889** — wizard → topologia (oco; sem UI de download do scheme) | Settings.App **:18888** — SoT editável + dry-run de CD |
| Modo do AppHost | `PolyStackAppHostMode=DevKit` | `PolyStackAppHostMode=Multicloud` |
| Persistência / broker | SQLite + InMemory (+ Auth.None típico) | SqlServer/Postgre + DynamicSelection + Aws/Azure |
| Artefatos em disco | `.polystack/` scheme + topologia + rascunho (metadados; a UI Demo **não** exporta) | `polystack-settings.json` (+ topologia) |
| Sample | Blank do DevKit (`samples/blank` no nuget.org / este repo) | Harness Canary ouro no monorepo **privado** em `solutions/canary` (domínio `e2etests` — **não** é caminho de sample DevKit) |

```powershell
# Sample blank do DevKit (este repo / nuget.org)
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# Wizard / topologia Demo: http://localhost:18889/
```

### Domínios (nomenclatura da plataforma — conceitual)

Ao evoluir para Multicloud, as solutions são particionadas por `polystack:domain` / Settings `solutionDomain`:

| Domínio | Papel (plataforma) |
|---------|--------------------|
| `default` | Site de apresentação / marketing |
| `e2etests` | Harness de validação Canary |
| `console` | Tag de produto do Admin Console (o CD continua a apontar ao Canary) |

O blank público do DevKit permanece local-first; **não** provisiona esses domínios.

### Mode A vs Mode B (ao ler claims Multicloud)

| Mode | Significado |
|------|-------------|
| **A** | Local / budgets de CI (`E2ELocal`) — caminho default |
| **B** | Cloud vivo opt-in (`E2ECloud`). Evidência de lab pode existir e depois ser **apagada** — nunca invente URLs permanentes a partir só da doc DevKit |

### Observação de erros (local / IA)

Prefira a fachada **Headless** do ExceptionTracker em loops locais e de IA (sem GitHub Issues). Wiring DevOps Issues fica na plataforma privada com enablement explícito — não no sample blank.

Pacotes necessários (já referenciados no sample blank) — trem **0.1.0-preview.8+**:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.8
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.8
```

Quando criar um projeto de API, referencie também:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.8
dotnet add package PolyStack.Presentation.HostedService --version 0.1.0-preview.8
```

> **Nota NuGet:** os IDs dos pacotes usam o prefixo `PolyStack.Aspire.Hosting.Demo*` porque `Aspire.Hosting.*` é reservado no nuget.org. Projetos e assemblies continuam no padrão de hosting do Aspire.

A UI Demo **não** faz download do scheme. Os arquivos ainda podem ser gravados em `.polystack/` (scheme + topologia + rascunho) para tooling após o `Build()` do AppHost.

---

## 2. Componha o AppHost

```csharp
var inner = DistributedApplication.CreateBuilder(args);
var builder = inner.AsPolyStackDistributedApplicationBuilder();

// Somente Multicloud — Settings :18888 (não usado no blank do DevKit)
// builder.WithSettingsApp();

builder.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");

builder.AddViteApp("my-web", "../web")
    .AsExternalPolyStackModule(builder, "MyWeb", StackModuleSource.Frontend)
    .WithHint(builder, "frontend", "frontend.StaticSite(cdn=false)::Low");

builder.Build().Run();
```

Também disponíveis:

- Python / Docker → `AddDockerfile(...).WithHttpEndpoint(...).AsExternalPolyStackModule(...)`
- Filas / tópicos → `AddMessageQueue<TEvent>()`, `AddMessageTopic<TEvent>()`
- Hints / managed config → `WithHint`, `WithManagedConfig` (complementam `[Hints]` / atributos)

---

## 3. Controllers (Presentation)

1. Marker: `IDynamicPresentation<TApplicationBuilder>`
2. Controllers em `Controllers/` (superfície REST; Problem Details para erros)
3. Application: `ApplicationBuilder` + handlers CQRS
4. Contracts: DTOs `*Request` / `*Response`, eventos em `Events/`
5. Ponte gRPC opcional: `{Module}GrpcService` em `Presentation/Grpc/` (Invoke → MVC)

Protocolo inferido: **módulos PolyStack → gRPC**, **Python → HTTP**.

---

## 4. Filas (declare; não escolha o broker à mão)

```csharp
// AppHost — declare a fila lógica
var queue = builder.AddMessageQueue<MyEventRequested>();

builder.AddPolyStackModule<MyHandlerPresentation, MyHandlerApplicationBuilder>("handler-api")
    .WithQueueEventSource(queue); // serverless: mapeamento SQS / Service Bus a partir dos settings
```

- Contrato de mensagem em `*.Api.Contracts/Events/` (CloudEvents `type`)
- Consumer: implemente `IMessageHandler<T>` (+ convenção de registro `IQueueConfig<T>`)
- **Não** escolha SQS vs Service Bus no código da aplicação — settings + DynamicSelection decidem (o host local do DevKit usa adaptadores in-memory)

Tópicos:

```csharp
builder.AddMessageTopic<MyDomainEvent>();
```

---

## 5. Publique mensagens

```csharp
await publisher.PublishAsync(new MyEventRequested { /* ... */ }, cancellationToken);
```

Use `IMessagePublisher.PublishAsync` / CloudEvents. Os nomes das filas vêm de convenções (`QueueNameConvention`, `IQueueConfig<T>`), não de um registro tipado FlowMessage.

**Não reative** `FlowMessage` nem `IQueueMappingRegistry`.

---

## 6. Object storage

- Subclasse `ObjectStorage("logical-name")` no seu módulo; discovery + overlays de settings ligam os alvos na nuvem
- **Não** invente `AddObjectStorage(...)` no AppHost
- Sample Multicloud: Canary `canary-assets` em settings `objectStorages` (monorepo)

---

## 7. Hubs, chamadas sync, frontend

**Hubs (SignalR):**

```csharp
public sealed class CanaryModuleHubHandler : ModuleHubHandlerBase, IModuleHubHandler
{
    public static string Route => "/hubs/canary";
}
```

Auto-registrados via declarações de hub → topologia. Transporte no browser: `websocket` (não gRPC).

**Chamadas sync entre módulos:**

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

O Aspire injeta `PolyStack__Grpc__{ClientName}` (ou Http para Python).

**Frontend (Vite):**

```csharp
builder.AddViteApp("canary-web", "../web")
    .AsExternalPolyStackModule(builder, "CanaryWeb", StackModuleSource.Frontend);
```

Exemplo de `moduleCalls` nos settings (Multicloud):

```json
{ "from": "CanaryWeb", "to": "Canary" }
```

Config de runtime: o CD grava `dist/config.json`; no F5 local pode usar `GET /api/settings/frontends/{key}/runtime-config`.

---

## 8. O que vai para disco vs settings vs inject em runtime

| Artefato | Papel |
|----------|-------|
| `polystack-settings.json` | SoT Multicloud: clouds, hosting, DBs, moduleCalls, frontends, objectStorages, flags de CD |
| Topologia / scheme em `.polystack/` | Metadados de catálogo para Aspire / Demo / lab Settings — **não** baixados pela UI Demo |
| Env `POLYSTACK_*` / `PolyStack__Grpc__*` | Inject em runtime via Aspire / stamps de CD |
| Rascunho Demo (`devkit-demo-draft.json`) | Estado oco do wizard apenas — não é SoT de produção |

Settings (:18888) é o control plane Multicloud. Demo (:18889) é onboarding / ilustração de topologia.

Documentos de scheme podem incluir `format: "polystack-scheme"`, versão de schema, feedback opcional e um bloco `security` (sem segredos / binários / endpoints vivos — egress só com chaves lógicas).

---

## 9. Samples

| Sample | Propósito |
|--------|-----------|
| Blank do DevKit (`samples/blank`) | AppHost consumidor + Demo :18889 sem ProjectRefs do monorepo (pacotes nuget.org) |
| Canary (monorepo `solutions/canary`) | Harness Multicloud de referência: dual DB, filas, hub, FE, object storage, Peer cross-module; domínio `e2etests` |

Quando for além do DevKit:

```text
Demo.Host (adaptadores locais)  → seleção de host da plataforma
Fachada AppHost Demo            → kit Aspire Multicloud
*.polystack-scheme.json         → ferramenta de importação (operador preenche nuvens / settings)
```

---

## 9b. Receitas Canary (Multicloud monorepo)

Padrões declare-first do harness ouro (monorepo privado **`solutions/canary`**, domínio `e2etests` — não sob `samples/`):

| Receita | Declarar |
|---------|----------|
| Filas Canary↔Peer | `IQueueConfig<CanaryPeerNotified>` + Peer `IMessageHandler<>` |
| Topic | settings `topics.canary-domain-events` |
| Hub | `Route => "/hubs/canary"` em `ModuleHubHandlerBase` |
| Object storage | `ObjectStorage("canary-assets")` + settings `objectStorages` |
| API gateway (harness) | `apiGateways.clouds.Azure.enabled = false` |
| Egress | `egressCalls[]` (allow-list de host; sem HttpClient cru) |
| Sidecars | Settings **:18888** (lab full) · Demo topologia hollow **:18889** · playground Config Lab usa o **mesmo** motor hollow |

Motor hollow de topologia partilhado: monorepo `PolyStack.TopologyLab.Web` (Demo; Settings mantém o lab completo). No site de apresentação, o Config Lab carrega `/shared/topology-lab/`.

---

## 10. Solução de problemas

| Sintoma | Correção |
|---------|----------|
| Porta errada / UI Settings vazia | Multicloud → **:18888**; wizard Demo → **:18889** |
| Catálogo Demo vazio | Garanta que o `Build()` do AppHost rodou com módulos registrados; verifique `.polystack/` |
| Esperava download do scheme em :18889 | Removido da UI Demo — os arquivos ainda são gravados em `.polystack/` para tooling |
| Catálogo do sample blank vazio | Registre ao menos um módulo (o blank começa vazio), rode o Build do AppHost, recarregue `:18889` |
| Restore do Demo.Host sem ObjectStorage.InMemory | Use o trem **0.1.0-preview.8+** (pacote incluído no set público) |

---

## 11. LLM / assistentes de IA

| Recurso | Uso |
|---------|-----|
| https://getpolystack.com/llms.txt | Ponteiro do site |
| https://getpolystack.com/ai/getstarted.txt | Entrada para agentes (`#IDENTITY` / `#PREVIEW`) |
| [LLM.md](https://github.com/getpolystack/devkit/blob/main/LLM.md) | Notas DevKit (FETCH vs READING, PackageIds) |

**Não** invente CD Multicloud só a partir da documentação DevKit. O Config Lab em getpolystack.com é playground ilustrativo (dados mock), não o caminho de entrega.

## Idioma

Este guia e a UI Demo seguem o idioma do navegador (`?lang=pt` / `?lang=en`).
