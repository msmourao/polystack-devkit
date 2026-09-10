# Architecture overview

This page describes **how a PolyStack-shaped solution is organized** when you use the public DevKit. It is intentionally conceptual: enough to design modules and hand off architecture metadata, without exposing private platform internals.

---

## Why this architecture exists

PolyStack-style solutions are built as **composable modules** that can run locally first and later map onto a fuller platform (clouds, settings, CD) without rewriting the module boundaries.

**Maturity today:**

| Surface | Role |
|---------|------|
| **Public DevKit** | Local Aspire compose + Demo wizard ending on a simplified topology; scheme/topology may be written under `.polystack/` for tooling |
| **Presentation Config Lab** | Illustrative browser playground — same hollow topology motor as Demo, mock inventory (not Multicloud delivery) |
| **Private Multicloud Settings** (`:18888` when available) | Source of truth for operational settings, clouds, groups, and CD — not part of the public DevKit |

**Solution domains (platform):** when Multicloud is in play, inventory and CD are partitioned by `polystack:domain` — `default` (presentation), `e2etests` (Canary harness at monorepo `solutions/canary`), `console` (Admin Console product tag). The public DevKit blank does not create those domains.

**Maturity honesty:** local DevKit + Mode A tests are the everyday path. Live Multicloud Mode B may be proven in a **lab** and then wiped — do not treat lab URLs as permanent product endpoints.

The DevKit focuses on three outcomes:

1. **Clear module seams** — Presentation, Application, and contracts stay separable.
2. **Composable runtime topology** — AppHost declares how modules and edges relate.
3. **Portable architecture metadata** — scheme/topology files under `.polystack/` capture structure, not secrets or binaries. The Demo UI has **no download**.

What stays **out of scope** for the public DevKit (and is not documented here): Multicloud provisioning, private settings editors, inventory/cloud adapters, and operator CD workflows.

---

## Solution shape

A typical DevKit solution looks like this:

```text
AppHost (Aspire)
  └─ registers modules + optional queues/topics/externals
       └─ may write topology / scheme under .polystack/
       └─ starts Demo wizard UI on :18889

Api / Hosted service (per module or shared host)
  └─ Presentation assembly
  └─ Application assembly
  └─ Contracts assembly
  └─ optional Persistence / messaging adapters (local in DevKit)
```

### AppHost

The AppHost is the **composition root**. Through the DevKit facade you declare:

- which modules exist
- how they call each other (logical sync edges)
- message queues and topics
- external processes (Docker, frontend apps, HTTP/Python-style modules)

Building through the facade materializes local metadata and attaches the Demo wizard UI.

### Module layers

Each PolyStack module is usually split by responsibility:

| Layer | Responsibility |
|-------|----------------|
| **Contracts** | DTOs and events shared across boundaries |
| **Application** | use-cases / CQRS handlers, domain orchestration |
| **Presentation** | HTTP/gRPC surface, controllers, presentation marker |
| **Persistence** (when needed) | storage adapters behind application abstractions |

This split keeps transport details out of business logic and makes the same module shape usable later on the private platform.

### Local host adapters

For local runs, the Demo **Host** package wires safe defaults (in-memory messaging, local persistence, no-op auth). Those adapters are **development stand-ins**, not the production Multicloud stack.

---

## Communication model (conceptual)

Inside the stack, modules prefer **explicit contracts**:

- **Commands / queries** inside Application (CQRS-style handlers)
- **Events** published to queues or topics declared in AppHost
- **Module-to-module calls** expressed as logical edges in composition (not hard-coded environment URLs in the scheme)

Externals (frontends, containers, non-.NET services) join the topology as **named modules** with a declared source kind. The scheme records the relationship; live endpoints are filled later by operators.

---

## Wizard → topology lifecycle

```text
Compose in AppHost
    → Build
        → .polystack/*.polystack-scheme.json (+ topology helpers, when written)
            → Demo UI (:18889) wizard → simplified topology (no download)
                → Future import into the private platform (Settings SoT)
```

The scheme answers questions like:

- Which modules exist, and what kind are they?
- Which presentation / application types anchor a module?
- Which logical messaging and egress keys were declared?
- Which hints / managed-config keys were attached?

It deliberately **does not** answer:

- connection strings, API keys, or cloud credentials
- published binaries
- live BaseUrl / Host values for production

That separation lets architecture travel between teams and environments without shipping secrets.

---

## What the DevKit covers (reader checklist)

Use this as a coverage map — not an implementation dump:

- **Module composition** via Aspire AppHost facade
- **Layered module templates** (Presentation / Application / Contracts)
- **Local execution adapters** for day-to-day development
- **Demo wizard → topology** plus optional scheme/topology files under `.polystack/` for later tooling
- **Optional structural testing package** (`PolyStack.Architecture.Testing`) to guard conventions from a test project in *your* solution

The DevKit does **not** cover: cloud resource provisioning, private inventory hydration, production auth providers, CD generation, or Addon modules such as ExceptionTracker publish paths. Those belong to the private platform after you import architecture metadata. For local/AI error observation, prefer a Headless facade (no GitHub Issues) when the platform packages are available.

---

## Design principles worth keeping

1. **Compose by name, configure later** — AppHost talks in logical module and resource names.
2. **Metadata ≠ runtime secrets** — scheme/topology under `.polystack/` is safe to share; Settings are not.
3. **Same seams, richer host** — growing to Multicloud should swap host/AppHost packages, not rewrite module layers.
4. **Local-first feedback** — run, walk the `:18889` wizard to topology, adjust structure before any cloud work.

For hands-on steps, switch to the **Development Guide** tab.
