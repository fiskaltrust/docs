---
slug: /poscreators/middleware-doc/italy/scu/ivaservizi
title: IvaServizi
---

# IvaServizi

## Signature Creation Unit

### Support

The _fiskaltrust.Middleware.SCU.IT.IVAServizi_ package connects the middleware with the government service https://ivaservizi.agenziaentrate.gov.it/ ("Documento Commerciale Online"). It logs in as a delegate (incaricato) for the configured `VATNumber`, then creates the corresponding sale/void/refund fiscal document for every receipt.

### Parameters

| Name | Description | Optional |
| ---- | ------------ |--------- |
| ClientTimeoutMs | The HTTP client timeout used when communicating with the government service. | `15000`<br />optional |
| UserName | The Fisconline/Entratel username of the professional account delegated (incaricato) to act on behalf of `VATNumber`. | mandatory |
| Password | Password for `UserName`. | mandatory |
| Pin | PIN for `UserName`. | mandatory |
| VATNumber | The delegating company's Italian VAT number (P.IVA) the SCU signs fiscal documents for. | mandatory |
| Sandbox | `true`: exercises the real AdE login/delegation flow on every request (useful as a login smoke-test) but returns a mocked document result — no fiscal document is ever created. `false`: submits real fiscal documents. | `false`<br />optional |
| LoginMode | Selects how the SCU logs in and resolves the AdE delegation before signing. See *Configuration* below. | `Browser`<br />optional |

*Table 1. Configuration parameters for the IvaServizi SCU.*

Please pay attention to the case-sensitive use of the parameters.

### Configuration

**LoginMode**

AdE (Agenzia delle Entrate) exposes no official API for Documento Commerciale Online — the government portal is a web application intended for human use. `LoginMode` selects how the SCU logs in and picks up the AdE delegation (incaricato) for `VATNumber` before it can sign anything:

| Value | Behavior |
| ----- | -------- |
| `Browser` (default) | Drives a headless browser through the actual AdE login and delegation pages, exactly as a human would. Most resilient to changes AdE makes to its internal API contract, since it follows the same UI a person uses; slower and heavier (a full browser session per login). |
| `Api` | Logs in and resolves the delegation directly over HTTP, without a browser — faster and lighter, but depends on AdE's internal (unpublished, reverse-engineered) API contract, which can change without notice. |
| `ApiWithBrowserFallback` | Tries `Api` first; if that login attempt fails for any reason other than the credentials/delegation themselves being wrong, falls back to `Browser` for that attempt. |

*Table 2. LoginMode values and their login behavior.*

Regardless of `LoginMode`, delegation is always resolved by matching `VATNumber` against the account's actual list of delegations returned by AdE — never assumed or guessed. If `VATNumber` isn't found among the account's delegations, the SCU fails the request rather than proceeding against a different company.

A login failure due to wrong credentials or an undelegated `VATNumber` is never retried automatically (regardless of `LoginMode`) — retrying the exact same rejected login would only risk AdE temporarily locking the account after repeated failed attempts.

**Setting LoginMode on a cloud-hosted cashbox**

For cloud-hosted cashboxes the SCU runs in a fiskaltrust service rather than in your launcher, so the value is read from the Signature Creation Unit's configuration in the Portal. Set `LoginMode` there, on the SCU itself.

Three steps are needed before the value takes effect, and skipping either of the last two leaves the setting saved but inactive:

1. Set `LoginMode` in the SCU configuration in the Portal.
2. Make sure that the SCU is linked to the cashbox. Configuring an SCU does not attach it. An unlinked SCU is left out of the configuration the service receives.
3. Rebuild the cashbox. The service is served a built configuration, so a Portal change is not visible until a rebuild regenerates it.

If an SCU sets no `LoginMode`, the hosting service applies its own default. Different cashboxes on the same service can therefore run different login modes.

### Troubleshooting

- **Receipts fail immediately with an authentication error, with no retries observed in the logs**: this is expected — a rejected login (wrong `UserName`/`Password`/`Pin`, or `VATNumber` not delegated to `UserName`) is treated as non-retryable so the same bad login attempt isn't repeated against AdE. Verify the credentials and the delegation on the AdE portal directly.
- **Receipts fail with "no delega found for P.IVA ..."**: `VATNumber` is not among the account's current AdE delegations. Check the delegations under the professional account's AdE portal.
- **`LoginMode` saved in the Portal has no effect on a cloud-hosted cashbox**: the value is saved on the SCU, but the service never receives it. Check that the SCU is linked to the cashbox, then rebuild the cashbox. Both steps are separate from saving the configuration.
