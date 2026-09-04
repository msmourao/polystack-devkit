# Visão da arquitetura

Esta página descreve **como uma solução no formato PolyStack se organiza** com o DevKit público. O texto é conceitual de propósito: o suficiente para desenhar módulos e entregar um scheme, sem expor internos da plataforma privada.

---

## Por que esta arquitetura existe

Soluções no estilo PolyStack são feitas de **módulos componíveis** que rodam primeiro em local e depois mapeiam para uma plataforma completa (nuvens, settings, CD) **sem reescrever as fronteiras** dos módulos.

O DevKit mira três resultados:

1. **Costuras claras de módulo** — Presentation, Application e contracts permanecem separáveis.
2. **Topologia de runtime componível** — o AppHost declara como módulos e arestas se relacionam.
3. **Metadados de arquitetura portáveis** — um arquivo de scheme que captura estrutura, não segredos nem binários.

Fica **fora do escopo** do DevKit público (e não é documentado aqui): provisionamento Multicloud, editores privados de settings, adaptadores de inventário/nuvem e fluxos de CD do operador.

---

## Forma da solution

Uma solution DevKit típica se parece com isto:

```text
AppHost (Aspire)
  └─ registra módulos + filas/tópicos/externos opcionais
       └─ grava topology / scheme em .polystack/
       └─ sobe a UI de scheme em :18889

Api / Hosted service (por módulo ou host compartilhado)
  └─ assembly de Presentation
  └─ assembly de Application
  └─ assembly de Contracts
  └─ Persistence / messaging opcionais (locais no DevKit)
```

### AppHost

O AppHost é a **raiz de composição**. Pela fachada do DevKit você declara:

- quais módulos existem
- como eles se chamam (arestas lógicas síncronas)
- filas e tópicos
- processos externos (Docker, frontends, módulos HTTP/Python)

O Build pela fachada materializa metadados locais e anexa a UI de extração de scheme.

### Camadas de um módulo

Cada módulo PolyStack costuma se dividir por responsabilidade:

| Camada | Responsabilidade |
|--------|------------------|
| **Contracts** | DTOs e eventos compartilhados entre fronteiras |
| **Application** | casos de uso / handlers CQRS, orquestração de domínio |
| **Presentation** | superfície HTTP/gRPC, controllers, marker de presentation |
| **Persistence** (quando necessário) | adaptadores de armazenamento atrás das abstrações da Application |

Essa divisão mantém detalhes de transporte fora da lógica de negócio e preserva o mesmo formato de módulo na plataforma privada.

### Adaptadores de host local

Para execução local, o pacote **Host** do Demo liga defaults seguros (messaging in-memory, persistência local, auth no-op). São **substitutos de desenvolvimento**, não o stack Multicloud de produção.

---

## Modelo de comunicação (conceitual)

Dentro do stack, módulos preferem **contratos explícitos**:

- **Commands / queries** na Application (handlers no estilo CQRS)
- **Events** publicados em filas ou tópicos declarados no AppHost
- **Chamadas entre módulos** como arestas lógicas na composição (não como URLs de ambiente no scheme)

Externos (frontends, containers, serviços não-.NET) entram na topologia como **módulos nomeados** com um tipo de origem declarado. O scheme registra o relacionamento; endpoints vivos são preenchidos depois pelos operadores.

---

## Ciclo de vida do export de scheme

```text
Compor no AppHost
    → Build
        → .polystack/*.polystack-scheme.json (+ helpers de topology)
            → UI de scheme (:18889) para revisão / download
                → Importação futura na plataforma privada
```

O scheme responde perguntas como:

- Quais módulos existem e de que tipo são?
- Quais tipos de presentation / application ancoram o módulo?
- Quais chaves lógicas de messaging e egress foram declaradas?
- Quais hints / managed-config foram anexados?

Ele **não** responde de propósito:

- connection strings, API keys ou credenciais de nuvem
- binários publicados
- BaseUrl / Host vivos de produção

Essa separação permite que a arquitetura circule entre times e ambientes sem carregar segredos.

---

## O que o DevKit cobre (checklist do leitor)

Use isto como mapa de cobertura — não como dump de implementação:

- **Composição de módulos** via fachada Aspire AppHost
- **Templates em camadas** (Presentation / Application / Contracts)
- **Adaptadores locais** para o dia a dia de desenvolvimento
- **Export de scheme de arquitetura** para importação futura
- **Pacote opcional de testes estruturais** (`PolyStack.Architecture.Testing`) para guardar convenções a partir de um projeto de testes *na sua* solution

O DevKit **não** cobre: provisionamento de recursos em nuvem, hidratação privada de inventário, providers de auth de produção ou geração de CD. Isso pertence à plataforma privada depois da importação do scheme.

---

## Princípios que valem manter

1. **Componha por nome, configure depois** — o AppHost fala em nomes lógicos de módulo e recurso.
2. **Metadado ≠ segredo de runtime** — o scheme pode ser compartilhado; settings não.
3. **Mesmas costuras, host mais rico** — evoluir para Multicloud deve trocar pacotes de host/AppHost, não reescrever as camadas do módulo.
4. **Feedback local primeiro** — rode, inspecione `:18889`, ajuste a estrutura antes de qualquer trabalho em nuvem.

Para o passo a passo, use a aba **Guia de Desenvolvimento**.
