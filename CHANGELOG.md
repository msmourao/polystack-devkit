# Changelog

## 0.1.0-preview.8

- nuget.org train refreshed (**obfuscated** via Dotfuscator Community; a few assemblies still ship clear when CE cannot rewrite .NET 10 metadata)
- Added `PolyStack.Infrastructure.ObjectStorage.InMemory` to the public DevKit set (required by `Demo.Host`)
- Docs: agent/LLM entry (`LLM.md`) pointing at https://getpolystack.com/ai/ + FETCH vs READING protocol
- Docs: topology surfaces triangle — Demo `:18889` hollow motor = Config Lab playground map; Settings `:18888` remains full lab (private)
- Blank sample pinned to `0.1.0-preview.8` (nuget.org only)

## 0.1.0-preview.7

- Demo sidecar (`:18889`): wizard (clouds → frontends/storage/modules/databases/groups) ending on a simplified topology
- Local draft `devkit-demo-draft.json` (`PolyStack_DEVKIT_DRAFT`); scheme/topology still written under `.polystack/` for future Settings import — **no** scheme download UI
- Docs and blank sample aligned to the Demo wizard flow

## 0.1.0-preview.6

- Renamed DevKit shell projects to Aspire hosting convention (`Aspire.Hosting.PolyStackDemo*`)
- Public NuGet package IDs: `PolyStack.Aspire.Hosting.Demo*` (`Aspire.Hosting.*` is reserved on nuget.org)
- Docs site under `docs/` with Development Guide + Architecture (EN / PT); public URL: https://getpolystack.github.io/devkit
- Blank sample restored from nuget.org only

## 0.1.0-preview.5

- Package train refresh on nuget.org (obfuscated)

## 0.1.0-preview.4

- Obfuscated DevKit package train (Dotfuscator Community; a few assemblies ship clear when CE cannot rewrite .NET 10 metadata)
- nuget.org publish of obfuscated `0.1.0-preview.4`

## 0.1.0-preview.3

- First public docs + blank Aspire sample in this repository
- Sidecar attach via NuGet `tools/` payload (`dotnet exec`) for nuget.org-only AppHosts
- Package train aligned on nuget.org: DevKit shell + local-first dependencies

## 0.1.0-preview.2

- DevKit package set refresh on nuget.org
- Sidecar bilingual landing page and empty-catalog guidance

## 0.1.0-preview.1

- Initial public DevKit preview packages on nuget.org
- Local-first runtime + DevKit shell (no cloud adapters)
- License: free binary use; source of the private platform is not published here
