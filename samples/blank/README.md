# Blank Aspire sample (nuget.org)

Minimal PolyStack DevKit AppHost with **no ProjectReferences** to the private monorepo.

## Packages (`0.1.0-preview.8`)

- `PolyStack.Aspire.Hosting.Demo`
- `PolyStack.Aspire.Hosting.Demo.SchemaExtraction`
- transitive `PolyStack.*` DevKit runtime packages (nuget.org)
- `Aspire.Hosting.AppHost` `13.5.3`

## Run

```powershell
dotnet restore
dotnet run --project PolyStackBlankSolutionSample.AppHost
```

Open **http://localhost:18889/** after the host starts.

Until you register modules, the catalog may be empty — that is expected.

## Docs

See the [Development Guide + Architecture](https://getpolystack.github.io/devkit) ([markdown summary](https://github.com/getpolystack/devkit/blob/main/DevelopmentGuide.md)).

Agents / LLMs: [LLM.md](../../LLM.md) and https://getpolystack.com/ai/getstarted.txt
