# AGENTS.md

Guidance for AI agents working in this repository. See [README.md](README.md) for the general repository structure, contribution flow and CI.

## Git

- **Do not commit or push on your own initiative.** The maintainers usually commit and push themselves. Creating a branch, editing files and `git rm` are fine; leave all changes uncommitted. Commit or push only when the user explicitly asks for it.
- When asked for a PR description, provide the text only. Keep it short and technical: one line per changed file or area, no marketing language, no diff-hunk links.

## Repository basics

- Content only; the site is built by [fiskaltrust/service-docs-ui](https://github.com/fiskaltrust/service-docs-ui) (Docusaurus). A local build is usually not available here, so verify links and anchors manually, as described in [Writing conventions](#writing-conventions).
- The sidebar is defined manually in `poscreators/toc.js` and `posdealers/toc.js`. A page that is not listed there is still built and reachable by URL. Check `toc.js` and search for incoming links before deleting or renaming a page.
- Documentation pages should start with front matter with the fields `slug`, `title`, `description`, `tags` and `type`. For `slug`, `title`, `description` and `tags`, see [Writing Documentation Pages](README.md#writing-documentation-pages) in the README. For `type`, see [Document type](#document-type).
- `poscreators/middleware-doc/` is the only copy of the Middleware documentation. It is no longer mirrored to `fiskaltrust/businesscase`; that repository keeps only the business case samples (`example/`).
- Agent instruction files (`AGENTS.md`, `CLAUDE.md`) are excluded from the site build by the docs plugin configuration in service-docs-ui (`docusaurus.config.js`, `exclude`). Do not add front matter to them.

## Document type

Every Markdown documentation page must define a `type` field in its front matter to identify its primary purpose.

### Allowed values

Use only the following values:

- `overview`: Introduces a product, feature, system, or concept and explains its purpose or main components.
- `guide`: Provides instructions for completing a specific task or configuring a feature.
- `process`: Describes a workflow, sequence of activities, or decision-making process.
- `reference`: Provides factual, structured information that users consult, such as API endpoints, parameters, fields, configuration options, or technical specifications.
- `tutorial`: Teaches users how to use a feature or develop a skill through a learning-oriented, step-by-step example.
- `troubleshooting`: Helps users identify the cause of a problem and find a solution.

### Rules

1. Use exactly one `type` value per page, selected from the allowed values.
2. Determine the type based on the page's primary purpose, not its title, topic, or location in the documentation hierarchy.
3. Distinguish between `guide` and `process`:
   - Use `guide` when the primary goal is to help users complete a task.
   - Use `process` when the primary goal is to explain how a workflow operates, including its stages, activities, or decisions.
4. Use `reference` for information users consult as needed rather than instructions they follow to complete a task.
5. Do not introduce new types or use alternative names without approval.
6. When creating a new page, assign the most appropriate type.
7. When editing an existing page, preserve its type unless the page's primary purpose has changed or the existing type is incorrect.
8. When the type is ambiguous, choose the closest match based on the definitions in [Allowed values](#allowed-values).
9. Use `tags` to identify topics, technologies, products, or countries covered by the page. Do not use tags as substitutes for document types.

### Front matter example

```yaml
---
slug: /poscreators/configure-the-middleware
title: Configure the Middleware
description: Learn how to configure the middleware.
type: guide
tags: [middleware, configuration]
---
```

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
- To send the reader to a page in the Portal, name the menu path and the sidebar, then the action, for example: "In the Portal, open `Company info` > `Employees` in the left sidebar, then click `+Add`." Always give the backticked labels: they identify the target for screen reader users, and "left sidebar" only helps to find it on the screen.
- For the verbs to use for UI interactions, see [UI interaction verbs](#ui-interaction-verbs).
- **The docs must match the UI.** Write every Portal label exactly as the Portal shows it, including spelling and capitalization, even when the source code or a release note spells it differently. For example, `Master data`, not `master data`, and `Change username`, not `Change user name`.
- Highlight in **bold**, not in italics. Figure and table captions stay italic, as described in the first rule of this list.
- To refer to another page in the docs, write "For more information, see [Page title](path.md).", not only "See [Page title](path.md)."
- Existing pages link to other pages in this repo with relative paths to the `.md` file (for example `../faq/faq.md#for-developers`); follow that convention. Absolute `https://docs.fiskaltrust.eu/...` URLs are only used for pages outside this repo (for example the API reference).
- Always use `docs.fiskaltrust.eu` as the docs domain, never `docs.fiskaltrust.cloud`. This does not apply to other hosts under `docs.fiskaltrust.cloud` (for example `middleware-samples.docs.fiskaltrust.cloud`), which have no `.eu` equivalent.
- Docusaurus generates anchors from **headings** only. Bold FAQ questions (`**Q: ...**`) are not headings and have no anchor, so link to the nearest `##` heading instead.
- After editing, verify that every new link target file and anchor exists (for example with `grep -n "^#" <file>`).
- State only facts from the source (release notes, the app, the user). Do not add assumptions or caveats that the source does not contain; ask instead.
- Prefer a single source of truth. If content is duplicated elsewhere, replace the copy with a short summary and a link rather than maintaining both.
- For where to place screenshots in procedures, see [Screenshot placement](#screenshot-placement).
- For wording that works with screen readers, see [Accessible wording](#accessible-wording).
- Do not use `"`, `'`, `&`, `<` or `>` in image alt text: the site build escapes them twice, so they show up as entities such as `&#39;`. Reword instead, for example "the authorizations of the employee", "Terms and Conditions".

### Accessible wording

Some readers use a screen reader or a zoomed or reflowed layout, so they cannot see where something is on the screen or the page. Refer to content and UI elements by their name, label or order, not by their position or appearance.

| Avoid | Write instead |
|---|---|
| "in the top-right corner", "the icon at the top" | Name the element by its label: "click `Save`" |
| "the table below", "as shown above" | "the following table", "as described in [Section title](#section-title)", "*Table 2*" |
| "the button on the right", "the green button" | The label of the button: "click `+Add`" |
| "above" | "previously" |
| "click here", "this link" | Link text that names the target: "For more information, see [Page title](path.md)." |

Do not rely on a screenshot alone to explain a step: the text must contain everything needed, and the screenshot supports it. For alt text, see the image alt text rule in [Writing conventions](#writing-conventions).

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
1. In the Portal, open `Configuration` > `Signature creation unit` in the left sidebar.

   ![Signature creation unit page in the fiskaltrust.Portal with the list of SCUs and the Add button](images/scu-list.png)

   *Figure 1. The `Signature creation unit` page.*

2. Enter the required configuration details.
3. Click `Save`.
```

### UI interaction verbs

Use consistent, precise verbs when describing user interactions.

| Verb | Use when the user… |
|---|---|
| **Select** | picks a value or item inside an open drop-down, list, menu or radio-button group, or a checkbox or tab |
| **Click** | activates a button, link or other clickable element |
| **Enter** | provides a value in a text field or input |
| **Type** | types text, when the physical input action matters |
| **Open** | goes to a page or section, including a full sidebar path such as `PosDealer` > `Invitation`, or expands a drop-down, menu or dialog |
| **Choose** | makes a decision, or when the specific interaction is not important |
| **Enable / Disable** | changes a feature's state |
| **Turn on / Turn off** | operates a toggle switch |
| **Clear** | deselects a checkbox or removes a selected value |
| **Browse** | navigates to or locates a file or folder |
| **Drag and drop** | moves a file or item into a designated area |

- Prefer **Select** over **Click** when the purpose is to choose an option or value, whatever the input device.
- Do not use **Click** as a generic verb for every interaction, and do not use **Select** and **Click** interchangeably. Keep the verbs consistent within a page and across related pages.
- **Open** gets the user to something; **Select** picks one item inside it. For one control, the first action is Open and the second is Select: "Open the `Surrogate rights` drop-down and select `Full (Write/Read, Contract Conclusion)`."
- For Portal navigation, write the whole sidebar path with **Open**, as described in [Writing conventions](#writing-conventions): "In the Portal, open `PosDealer` > `Invitation` in the left sidebar", not "Open `PosDealer` and select `Invitation`".
- When one instruction opens a control and chooses a value, combine both: "Open the `Country` drop-down and select `Germany`."
- Use the exact UI labels, in backticks as described in [Writing conventions](#writing-conventions).
- Do not describe a control's behavior or state unless the UI or a reliable source confirms it.
- Use platform-neutral language. Avoid mouse-specific instructions unless the interaction requires a mouse.

| Preferred | Avoid |
|---|---|
| Select `Germany` from the `Country` drop-down. | Click `Germany` in the `Country` drop-down. |
| Select the `Enable e-invoicing` checkbox. | Click the `Enable e-invoicing` checkbox. |
| Click `Save` to apply the changes. | Select `Save` to apply the changes. |
| Enter your API key in the `API key` field. | Click the `API key` field and type your API key. |
| In the Portal, open `Configuration` > `Queues` in the left sidebar. | Click `Configuration` and click `Queues`. |
| Turn on the `PosDealer` toggle. | Click the `PosDealer` toggle. |

## Area-specific guidance

- InStore App: [poscreators/middleware-doc/instore-app/AGENTS.md](poscreators/middleware-doc/instore-app/AGENTS.md)
- Experience Middleware (payment, PSP feature matrix, terminology): [poscreators/middleware-doc/experience-middleware/AGENTS.md](poscreators/middleware-doc/experience-middleware/AGENTS.md)
