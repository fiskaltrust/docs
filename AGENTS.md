# AGENTS.md

Guidance for AI agents working in this repository. See [README.md](README.md) for the general repository structure, contribution flow and CI.

## Git

- **Do not commit or push on your own initiative.** The maintainers usually commit and push themselves. Creating a branch, editing files and `git rm` are fine; leave all changes uncommitted. Commit or push only when the user explicitly asks for it.
- When asked for a PR description, provide the text only. Keep it short and technical: one line per changed file or area, no marketing language, no diff-hunk links.

## Repository basics

- Content only; the site is built by [fiskaltrust/service-docs-ui](https://github.com/fiskaltrust/service-docs-ui) (Docusaurus). A local build is usually not available here, so verify links and anchors manually (see below).
- The sidebar is defined manually in `poscreators/toc.js` and `posdealers/toc.js`. A page that is not listed there is still built and reachable by URL. Check `toc.js` and search for incoming links before deleting or renaming a page.
- Documentation pages should start with front matter (`slug`, `title`).
- `poscreators/middleware-doc/` is the source of truth for the Middleware documentation. Its `general/` and `middleware-*/` folders are mirrored to `doc/compliance-middleware/` in [fiskaltrust/businesscase](https://github.com/fiskaltrust/businesscase) by `.github/workflows/notify-businesscase.yml`. Edit them here, not in businesscase.
- Agent instruction files (`AGENTS.md`, `CLAUDE.md`) are excluded from the site build by the docs plugin configuration in service-docs-ui (`docusaurus.config.js`, `exclude`). Do not add front matter to them.

## Documentation layers

The Middleware documentation is organised in three layers. Put content in the most general layer it is true for, and link from there to the more specific layers.

1. **Middleware data model** (`poscreators/middleware-doc/general/`): the abstracted data model that point-of-sale fiscalization and eInvoicing share, for example `ReceiptRequest` and `cbCustomer`. Describe fields generically, without feature- or market-specific rules, terms or examples.
2. **Feature abstraction** (for eInvoicing: `poscreators/middleware-doc/e-invoicing/`): how a feature works across markets, for example the mapping of `cbCustomer` to EN 16931. No market-specific rules, terms or examples.
3. **Market** (`poscreators/middleware-doc/middleware-<market>/`, for example `middleware-de-kassensichv/e-invoicing/`): national requirements, formats and identifiers, for example the XRechnung rules or the Leitweg-ID.

A reader integrating one market needs layers 1 and 2 and the pages of that market only; a PosCreator in France, for example, does not need to know what a Leitweg-ID is. Market-specific content found in layer 1 or 2 belongs on the market pages, with a link from the general page.

## Writing conventions

- Figures and tables get an italic caption below them, numbered per page: `*Figure 1. ...*`, `*Table 1. ...*`. Keep the numbering consistent when adding or removing figures and tables.
- Admonitions use Docusaurus syntax (`:::info`, `:::warning`, `:::tip`).
- Write Portal menu names and UI labels in backticks, for example `Edit profile`.
- Write a path through nested menus with `>` between the backticked labels, for example `Tools` > `Exports`.
- **The docs must match the UI.** Write every Portal label exactly as the Portal shows it, including spelling and capitalization, even when the source code or a release note spells it differently. For example, `Master data`, not `master data`, and `Change username`, not `Change user name`.
- Highlight in **bold**, not in italics. Figure and table captions stay italic (see above).
- To refer to another page in the docs, write "For more information, see [Page title](path.md).", not only "See [Page title](path.md)."
- Existing pages link to other pages in this repo with relative paths to the `.md` file (for example `../faq/faq.md#for-developers`); follow that convention. Absolute `https://docs.fiskaltrust.eu/...` URLs are only used for pages outside this repo (for example the API reference).
- Always use `docs.fiskaltrust.eu` as the docs domain, never `docs.fiskaltrust.cloud`. This does not apply to other hosts under `docs.fiskaltrust.cloud` (for example `middleware-samples.docs.fiskaltrust.cloud`), which have no `.eu` equivalent.
- Docusaurus generates anchors from **headings** only. Bold FAQ questions (`**Q: ...**`) are not headings and have no anchor, so link to the nearest `##` heading instead.
- After editing, verify that every new link target file and anchor exists (for example with `grep -n "^#" <file>`).
- State only facts from the source (release notes, the app, the user). Do not add assumptions or caveats that the source does not contain; ask instead.
- Prefer a single source of truth. If content is duplicated elsewhere, replace the copy with a short summary and a link rather than maintaining both.
- For where to place screenshots in procedures, see [Screenshot placement](#screenshot-placement).
- Do not use `"`, `'`, `&`, `<` or `>` in image alt text: the site build escapes them twice, so they show up as entities such as `&#39;`. Reword instead, for example "the authorizations of the employee", "Terms and Conditions".

### Screenshot placement

Place each screenshot as close as possible to the instruction it supports, while keeping the procedure easy to scan. Highlight UI elements in the text (label in bold or a tip admonition), not with boxes or number markers drawn on the screenshot.

| Screenshot shows | Placement |
|---|---|
| One step (an action or its direct result) | Directly after that step, indented under it so the list numbering continues. Use this for most procedures. |
| Several related steps | After the last of those steps. |
| The final result of the procedure | After the last step. |
| The page or interface as a whole, to help readers recognize it before they start | Before the first step. |

Do not group several screenshots before a long numbered list: readers then have to scroll back and forth to match text and interface.

Example of a screenshot after a specific step (caption below the image, image and caption indented by three spaces):

```markdown
1. Select `Configuration` > `Signature creation unit`.

   ![Signature creation unit page in the fiskaltrust.Portal with the list of SCUs and the Add button](images/scu-list.png)

   *Figure 1. The `Signature creation unit` page.*

2. Enter the required configuration details.
3. Select `Save`.
```

## Area-specific guidance

- InStore App: [poscreators/middleware-doc/instore-app/AGENTS.md](poscreators/middleware-doc/instore-app/AGENTS.md)
- Experience Middleware (payment, PSP feature matrix, terminology): [poscreators/middleware-doc/experience-middleware/AGENTS.md](poscreators/middleware-doc/experience-middleware/AGENTS.md)
