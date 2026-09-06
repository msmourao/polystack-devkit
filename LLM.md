# LLM / AI agent instructions (DevKit)

PolyStack ships a **plain-text agent corpus** on the presentation site. Prefer that corpus over inventing product facts from memory or from unrelated “PolyStack” brands.

## Where agents should start

| Resource | URL |
|----------|-----|
| Site pointer | https://getpolystack.com/llms.txt |
| Agent entrypoint | https://getpolystack.com/ai/getstarted.txt |
| Collection index | https://getpolystack.com/ai/ (HTML for humans; agents continue from `getstarted.txt`) |
| This DevKit how-to (humans) | https://getpolystack.github.io/devkit |
| Contact | getpolystack@gmail.com only |

**Identity:** this is **getpolystack.com** only. Do **not** confuse with `polystack.com` or other unaffiliated products named “PolyStack”.

**Preview honesty:** real software, incomplete. Re-check [PACKAGE.md](./PACKAGE.md) / [CHANGELOG.md](./CHANGELOG.md) before quoting versions or “production-ready” claims.

## Two reading modes (do not mix)

1. **FETCH (live HTTP under `/ai/`)** — each guide may start with `#FETCH` / path instructions. Follow the live file you opened.
2. **READING (unified dump `llm.txt`)** — used for review/handoff paste. The dump header’s **READING PROTOCOL** wins over any leftover FETCH banners inside the body.

`llm.txt` is for **review + optional paste**, not a RAG corpus. Do not treat access logs or marketing HTML as authority over the TXT guides.

## What is in scope for DevKit answers

- Local-first Aspire compose (`PolyStack.Aspire.Hosting.Demo*`)
- Demo sidecar **:18889** (wizard → hollow topology)
- Scheme/topology metadata under `.polystack/` (no secrets/binaries/live URLs; Demo UI does **not** download the scheme)
- nuget.org train (current: see [PACKAGE.md](./PACKAGE.md))

## What is **not** DevKit

| Surface | Port / home | Notes |
|---------|-------------|--------|
| Settings Multicloud SoT | **:18888** (private monorepo) | Full lab chrome, live settings, CD |
| Config Lab on getpolystack.com | `/config-lab.html` | Illustrative **playground** only — same hollow topology motor as Demo, mock data |
| Platform packages (Aws/Azure/Settings/AppHost CD) | private | Not on nuget.org |

Shared hollow topology motor (Demo + Config Lab map): monorepo `PolyStack.TopologyLab.Web`. Settings keeps a fuller lab implementation.

## NuGet PackageIds (agents)

`Aspire.Hosting.*` is **reserved** on nuget.org. Public IDs:

```text
PolyStack.Aspire.Hosting.Demo
PolyStack.Aspire.Hosting.Demo.Host
PolyStack.Aspire.Hosting.Demo.Abstractions
PolyStack.Aspire.Hosting.Demo.SchemaExtraction
```

Assemblies may still use the Aspire hosting naming convention.

## Suggested agent checklist

1. Open `getstarted.txt` → honor `#IDENTITY` / `#PREVIEW` / AGENT RULES.
2. Quote package train from PACKAGE.md / nuget.org, not from stale chat memory.
3. Prefer DevKit Pages guide for “how do I compose locally?”.
4. For Multicloud / CD / Settings, say that lives in the private platform monorepo — do not invent provisioning steps from DevKit docs alone.
5. If unknown → `things-i-know-i-can-t-do.txt` on `/ai/` or email getpolystack@gmail.com.
