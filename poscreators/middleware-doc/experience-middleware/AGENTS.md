# AGENTS.md – Experience Middleware documentation

Area-specific guidance. The general rules in the root [AGENTS.md](../../../AGENTS.md) also apply. For InStore App pages, see the [InStore App AGENTS.md](../instore-app/AGENTS.md).

## PSP feature matrix ([payment.md](payment.md))

- The **Payment Service Provider (PSP) Feature Matrix** is the single source of truth for supported payment service providers and their features. Other pages (especially the InStore App pages) link to it via `payment.md#payment-service-provider-psp-feature-matrix` instead of listing providers. The InStore App settings page also links to `payment.md#notes` (SumUp note). Do not rename these headings without updating the incoming links.
- Values are InStore App versions (`1.x.y+`) or the symbols defined in the Legend table below the matrix.
- **Notes** below the matrix are only for information that is essential for using a provider (for example the SumUp note on the API key and feature scope). Do not add notes for certifications, provider app version compatibility or similar details from release notes unless the maintainer asks for it.
- Payment requests can be sent via the POS System API in the cloud or, optionally, locally via the **fiskaltrust Android launcher** (always use this full name). This is described once at the top of `payment.md`.

## Terminology ([terminology.md](terminology.md))

- Keep the definitions in line with the current product behaviour. For example, the InStore App both displays receipts and executes payments.
