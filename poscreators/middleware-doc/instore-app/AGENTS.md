# AGENTS.md – InStore App documentation

Area-specific guidance. The general rules in the root [AGENTS.md](../../../AGENTS.md) also apply.

## Updating the docs for a new InStore App release

Release notes are published at `https://docs.fiskaltrust.eu/changelog/instoreapp/<version>` (for example `.../1.3.2`). For a release update:

1. Read the release notes and compare every feature, improvement and bug fix with the pages in this folder.
2. Bump the version in the info box at the top of [available-settings/settings.md](available-settings/settings.md).
3. Update settings, the introduction and the FAQ for new or changed behaviour. Pure bug fixes usually need no doc change.
4. Check the other sections of the repo that mention the InStore App (see [Related pages outside this folder](#related-pages-outside-this-folder)).
5. Present the findings to the maintainer before editing; they decide the scope.

## Payment service providers

- **Do not list the supported payment service providers** in this folder. Refer generically to the [PSP feature matrix](../experience-middleware/payment.md#payment-service-provider-psp-feature-matrix) instead, so that adding a new provider only requires changing the matrix.
- Naming a single provider is fine where something applies only to it, for example a terminal printer tied to the payment configuration (Shift4) or a device store used for installation (PAX / Viva / Global Payments stores).
- Exception: a provider gets its own subsection in [available-settings/settings.md](available-settings/settings.md) (under Payment settings) only if it needs extra configuration in the app, for example Hobex ECR, Shift4 and SumUp (API key).
- Settings that exist for only some providers (for example **Use Sandbox app**) are described generically ("Some payment providers offer ...") without naming them.

## Connectivity and local communication (since 1.3.2)

Describe this consistently in the introduction, the FAQ and the setup guide:

- Payment requests are supported via two paths:
  - **Cloud backend** (POS System API in the cloud): requires a permanent internet connection.
  - **Local communication** (optional): a POS app on the same device triggers payments via the fiskaltrust Android launcher ([Android IPC](../possystem-api/android-ipc.md)). This works offline and requires a fiskaltrust Android launcher version that supports it.
- An internet connection is **always** required for the initial configuration, even if payments are later triggered only locally.
- Always write **"fiskaltrust Android launcher"**, never just "Android launcher", to avoid confusion with the Android system launcher (home screen app).
- The home screen status icons **Cloud** and **On device** show which path is available (see the introduction).

## Facts to keep consistent

- **Print Delay**: default 30 seconds, only in Consumer mode (settings, printer guide, introduction).
- Printer option **No printing** and payment option **No payment** (receipts and printing only).
- **Dummy Payment Provider**: only visible when paired with a sandbox CashBox.

## Related pages outside this folder

- [experience-middleware/payment.md](../experience-middleware/payment.md): PSP feature matrix and notes (see the [AGENTS.md there](../experience-middleware/AGENTS.md)).
- [experience-middleware/terminology.md](../experience-middleware/terminology.md): InStore App definition.
- [digital-receipt/receive-receipts.md](../digital-receipt/receive-receipts.md): only a short summary of the InStore App receipt flow that links to [introduction/introduction.md](introduction/introduction.md). Keep the details in the introduction; do not duplicate them there again.
- [possystem-api/android-ipc.md](../possystem-api/android-ipc.md): the cloud-based `/pay` supports more payment variants than the InStore App executes directly. Do not change its `/pay` section or its requirements and limitations to match the InStore App.
