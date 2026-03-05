# fiskaltrust Documentation Content

This repository contains the documentation content for the [fiskaltrust documentation platform](https://docs.fiskaltrust.cloud). It is consumed as a Git submodule by [fiskaltrust/service-docs-ui](https://github.com/fiskaltrust/service-docs-ui), which uses [Docusaurus](https://docusaurus.io/) to build and deploy the site.

## Documentation Structure

The content is organized into audience-specific sections, each with its own sidebar navigation defined in a `toc.js` file.

```
.
├── poscreators/    # Technical integration guides and middleware API docs for POS system developers
├── posdealers/     # Business, onboarding and operational docs for POS resellers
├── faq/            # General reference pages (terminology, customer roles)
└── sidebars.js
```

### Sidebar Navigation

The sidebar structure is defined manually via JavaScript files rather than auto-generated from the directory layout. The root `sidebars.js` imports the sidebar definitions from `poscreators/toc.js` and `posdealers/toc.js`.

When you add, remove, or rename a page, you must update the corresponding `toc.js` file to reflect the change in the sidebar.

### Writing Documentation Pages

Each Markdown file should start with [Docusaurus front matter](https://docusaurus.io/docs/api/plugins/@docusaurus/plugin-content-docs#markdown-front-matter):

```yaml
---
slug: /poscreators/my-new-page
title: My New Page
---
```

Use standard Markdown for content. Docusaurus also supports [MDX](https://docusaurus.io/docs/markdown-features) if you need React components.

Place images in an `images/` directory next to the Markdown files that reference them and use relative paths.

## Contributing

1. Fork or branch this repository.
2. Edit or add Markdown files in the appropriate section (`poscreators/`, `posdealers/`, or `faq/`).
3. Update the sidebar in the relevant `toc.js` file if you added, removed, or renamed a page.
4. Open a pull request against the `main` branch.

Every page on the live site has an "Edit this document" link at the bottom that takes you directly to the source file on GitHub.

> For instructions on previewing your changes locally in the context of the full site, see the [service-docs-ui README](https://github.com/fiskaltrust/service-docs-ui#readme).

## CI/CD

Pull requests are automatically validated with a link check ([lychee](https://github.com/lycheeverse/lychee-action)) and a full Docusaurus site build to catch broken links and build errors before merging.

When a pull request is merged to `main`, the site is automatically rebuilt and deployed to https://docs.fiskaltrust.cloud.

> For a full overview of how the workflows across all repositories fit together, see the [CI/CD Workflows section in the service-docs-ui README](https://github.com/fiskaltrust/service-docs-ui#cicd-workflows).

## Link Checking Configuration

Link checking is configured via two files:

- `lychee.toml`: general settings (timeout, retry wait time).
- `.lycheeignore`: URL patterns to exclude from checking (e.g. sandbox URLs, localhost, known false positives).

If a new external URL is consistently flagged as a false positive, add a matching pattern to `.lycheeignore`.
