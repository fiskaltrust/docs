# AGENTS.md

Guidance for AI agents working in this repository. See [README.md](README.md) for the general repository structure, contribution flow and CI.

## Git

- **Do not commit or push on your own initiative.** The maintainers usually commit and push themselves. Creating a branch, editing files and `git rm` are fine; leave all changes uncommitted. Commit or push only when the user explicitly asks for it.
- When asked for a PR description, provide the text only. Keep it short and technical: one line per changed file or area, no marketing language, no diff-hunk links.

## Repository basics

- Content only; the site is built by [fiskaltrust/service-docs-ui](https://github.com/fiskaltrust/service-docs-ui) (Docusaurus). A local build is usually not available here, so verify links and anchors manually (see below).
- The sidebar is defined manually in `poscreators/toc.js` and `posdealers/toc.js`. A page that is not listed there is still built and reachable by URL. Check `toc.js` and search for incoming links before deleting or renaming a page.
- Documentation pages should start with front matter (`slug`, `title`).
- Agent instruction files (`AGENTS.md`, `CLAUDE.md`) are excluded from the site build by the docs plugin configuration in service-docs-ui (`docusaurus.config.js`, `exclude`). Do not add front matter to them.

## Writing conventions

- Figures and tables get an italic caption below them, numbered per page: `*Figure 1. ...*`, `*Table 1. ...*`. Keep the numbering consistent when adding or removing figures and tables.
- Admonitions use Docusaurus syntax (`:::info`, `:::warning`, `:::tip`).
- Existing pages link to other pages in this repo with relative paths to the `.md` file (for example `../faq/faq.md#for-developers`); follow that convention. Absolute `https://docs.fiskaltrust.eu/...` URLs are only used for pages outside this repo (for example the API reference).
- Always use `docs.fiskaltrust.eu` as the docs domain, never `docs.fiskaltrust.cloud`.
- Docusaurus generates anchors from **headings** only. Bold FAQ questions (`**Q: ...**`) are not headings and have no anchor, so link to the nearest `##` heading instead.
- After editing, verify that every new link target file and anchor exists (for example with `grep -n "^#" <file>`).
- State only facts from the source (release notes, the app, the user). Do not add assumptions or caveats that the source does not contain; ask instead.
- Prefer a single source of truth. If content is duplicated elsewhere, replace the copy with a short summary and a link rather than maintaining both.

## Area-specific guidance

- InStore App: [poscreators/middleware-doc/instore-app/AGENTS.md](poscreators/middleware-doc/instore-app/AGENTS.md)
- Experience Middleware (payment, PSP feature matrix, terminology): [poscreators/middleware-doc/experience-middleware/AGENTS.md](poscreators/middleware-doc/experience-middleware/AGENTS.md)
