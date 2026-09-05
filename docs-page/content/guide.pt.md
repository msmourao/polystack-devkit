# PolyStack DevKit — Guia de Desenvolvimento

Guia público, local-first, para estruturar aplicações no formato PolyStack e exportar um scheme de arquitetura para uso posterior.

**Repositório:** [github.com/getpolystack/devkit](https://github.com/getpolystack/devkit)  
**Pacotes:** `0.1.0-preview.7` no [nuget.org](https://www.nuget.org/packages/PolyStack.Aspire.Hosting.Demo)  
**Sample blank:** [`samples/blank`](https://github.com/getpolystack/devkit/tree/main/samples/blank) (nuget.org)

---

## O que é o DevKit

O DevKit permite **compor módulos no formato PolyStack** — Presentation, Application, contratos, arestas de messaging e adaptadores locais — **sem** provisionamento Multicloud, editor privado de settings ou pipelines de CD.

| Peça | Papel |
|------|--------|
| Fachada do AppHost | Mesma superfície de composição da plataforma privada (`AsPolyStackDistributedApplicationBuilder`, `AddPolyStackModule`, …) |
| Sidecar Demo (`:18889`) | Wizard (nuvens → … → grupos) até a topologia simplificada + rascunho local |
| Arquivo de scheme | **Metadados** de arquitetura — sem segredos, sem binários, sem BaseUrl/Host vivos |
| Pacote de host local | Adaptadores in-process para execução local (broker, persistência, auth stub) |

O scheme alimenta um **passo futuro de importação**: nuvens e settings de ambiente são preenchidos depois. O export **não** inclui binários da aplicação.

> **Nota NuGet:** os IDs dos pacotes usam o prefixo `PolyStack.Aspire.Hosting.Demo*` porque `Aspire.Hosting.*` é reservado no nuget.org. Projetos e assemblies continuam no padrão de hosting do Aspire.

## Início rápido (sample em branco)

```powershell
cd samples/blank
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
# abra http://localhost:18889/
```

Pacotes necessários (já referenciados no sample):

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo --version 0.1.0-preview.7
dotnet add package PolyStack.Aspire.Hosting.Demo.SchemaExtraction --version 0.1.0-preview.7
```

Quando criar um projeto de API, referencie também:

```powershell
dotnet add package PolyStack.Aspire.Hosting.Demo.Host --version 0.1.0-preview.7
dotnet add package PolyStack.Presentation.HostedService --version 0.1.0-preview.7
```

## Compor módulos no AppHost

```csharp
var poly = builder.AsPolyStackDistributedApplicationBuilder();

poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("mymodule-api");

poly.Build().Run();
```

Também:

- **Filas / tópicos** — `AddMessageQueue<TEvent>()`, `AddMessageTopic<TEvent>()`
- **HTTP / Docker externo** — `AddDockerfile(...).AsExternalPolyStackModule(...)`
- **Frontend** — `AddViteApp(...).AsExternalPolyStackModule(..., StackModuleSource.Frontend)`
- **Hints / managed config** — `.WithHint(...)` e `.WithManagedConfig(...)` (entram no scheme)

## Exportar `*.polystack-scheme.json`

1. Faça Build / F5 do AppHost DevKit uma vez.
2. Abra **http://localhost:18889/**.
3. Opcionalmente preencha feedback e baixe `*.polystack-scheme.json`.

O documento traz `format: "polystack-scheme"`, versão de schema, feedback opcional e um bloco `security` garantindo: sem segredos, sem binários, sem endpoints vivos (egress só com chaves lógicas). Em geral o arquivo fica em `.polystack/` (regenerado no Build).

## Se a página mostrar “Nenhum recurso carregado”

O catálogo está vazio. Causas comuns:

1. O AppHost ainda não registrou módulos (o sample blank começa assim).
2. A UI foi iniciada sozinha, sem topology/scheme gerados.
3. O Build não rodou, então `.polystack/*.polystack-scheme.json` não existe.

Correção: registre ao menos um módulo, rode o Build do AppHost, recarregue `:18889`.

## Forma de um módulo (checklist)

1. **Presentation** — marker + controllers
2. **Application** — builder + handlers CQRS
3. **Contracts** — DTOs e eventos
4. **Ponte gRPC** (módulos PolyStack) — `{Module}GrpcService`

Convenção: **módulos PolyStack falam gRPC**; alguns externos podem usar HTTP.

## Evoluir além do DevKit

Quando for para a plataforma privada:

```text
Demo.Host (adaptadores locais)  → seleção de host da plataforma
Fachada AppHost Demo            → kit Aspire Multicloud
*.polystack-scheme.json         → ferramenta de importação (operador preenche nuvens / settings)
```

## Idioma

Este guia e a UI de scheme seguem o idioma do navegador (`?lang=pt` / `?lang=en`).
