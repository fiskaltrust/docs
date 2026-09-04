# E-Invoicing market pages — authoring template (internal)

> **Not a published page.** The filename starts with `_`, so the Docusaurus docs plugin
> excludes it from the build (`exclude: ["**/README.md", "**/*_/**", "**/_*"]` in
> `docusaurus.config.js`). It documents the standard for adding an E-Invoicing section
> to a new market. Reference implementations: **Austria (AT)** and **France (FR)**.

## Files and location

Each market gets **two pages** under its own middleware folder:

```
poscreators/middleware-doc/<market-folder>/e-invoicing/overview.md
poscreators/middleware-doc/<market-folder>/e-invoicing/setup.md
```

`<market-folder>` is the existing per-market folder, e.g. `middleware-at-rksv`,
`middleware-fr-boi-tva-decla-30-10-30`.

### Frontmatter, title, H1 (keep verbatim, swap the country)

| Page | `slug` | `title` | H1 |
| --- | --- | --- | --- |
| Overview | `/poscreators/middleware-doc/<country>/e-invoicing/overview` | `Overview` | `# E-Invoicing in <Country> — Overview` |
| Setup | `/poscreators/middleware-doc/<country>/e-invoicing/setup` | `"Setup & testing"` | `# Set up and test e-invoicing (<Country>)` |

`<country>` in the slug is the plain country name (`austria`, `france`), independent of the
folder name. The `slug` is the stable URL — do not derive it from the file path.

### TOC (`poscreators/toc.js`)

Add one `E-Invoicing` category to the market's block, **immediately after its
`reference-tables` entry** (last position, above any deprecated "Receipt signing APIs" node):

```js
{
  type: "category",
  collapsed: true,
  label: "E-Invoicing",
  items: [
    "poscreators/middleware-doc/<market-folder>/e-invoicing/overview",
    "poscreators/middleware-doc/<market-folder>/e-invoicing/setup",
  ],
},
```

## Two variants — pick by the market's reality

The **section types are the standard**; the labels below differ by variant. Do not force a
market into the wrong one.

| | **API-first** (FR; and DE, IT, PL packs) | **Portal-first** (AT today) |
| --- | --- | --- |
| The POS-driven API path is… | available now — e-invoicing rides in `/sign` + `/issue` (+ `/journal`) | not built yet; today runs via Portal back office / InStore App |
| Overview lead callout | `:::info` "Built into calls you already make" | `:::info` "No code change required today" |
| Integration impact subsections | `### Unchanged interfaces` + `### Extended endpoints` | `### Existing integration` + `### Delivery paths` (Methods A/B/C) |
| Workflow section | `## The integration flow` (Sign → Issue → Poll → Archive) | `## Method A: the Portal workflow` + `## Method C: …` (not yet available) |
| Setup end-to-end example | real `/sign` → `/issue` → poll → `/journal` flow; mark unknown names `TBC` | "expected shape, pending" — marked not-yet-runnable |

Both variants share: `## Regulatory status` table, `## Terminology` (glossary), `## Related pages`;
and the Setup skeleton `## Prerequisites` → `## Enable e-invoicing in the Portal` → `## Sandbox validation` (+ end-to-end example).

## Rules that never change

- **No webhooks.** The PosSystem API is request/response and idempotent — status is **polled**
  (replay with the same `x-operation-id`), never pushed. State this explicitly; add a
  `:::note Status is polled, not pushed`.
- **Never fabricate.** No invented endpoints, case codes, field names, or Portal steps. Use
  `<… — TBC>` placeholders and flag them with a `:::caution` (e.g. "endpoint names pending
  final sign-off", or "pending <Market> availability"). A pending example is fine; a
  confident wrong one is not.
- **Callout vocabulary:** `:::info` lead highlight · `:::warning` key regulatory nuance
  (dates/mandate) · `:::note` polled-status / cross-reference · `:::caution` draft / pending /
  illustrative.
- **Relative links** from `<market-folder>/e-invoicing/`:
  - Delivery concept: `../../experience-middleware/delivery.md`
  - v0→v2 migration: `../../possystem-api/migration-guide.md`
  - Market appendix: `../appendix-<market-folder>.md`
  - Getting Started (portal-registration, integration-checklist): `../../../getting-started/<page>.md`
  - Sibling page: `./overview.md` / `./setup.md` (anchors: `#<kebab-heading>`)
  - POS System API reference (absolute): `https://docs.fiskaltrust.cloud/apis/pos-system-api`
- **Regulatory content is source-of-truth-sensitive.** Dates, formats, and identifiers come
  from the market's technical pack / factsheet — verify before publish, don't carry over from
  another market.

## Checklist for a new market

1. Create `overview.md` + `setup.md` from the variant above; swap all country-specific content.
2. Fill the `Regulatory status` and `Terminology` tables from the market's pack.
3. Add the `E-Invoicing` category to `toc.js` after that market's `reference-tables`.
4. Verify: `node -e "require('./poscreators/toc.js')"` parses; dev build reports **0 broken
   links / 0 broken anchors**; every `TBC` is inside a `:::caution`.
