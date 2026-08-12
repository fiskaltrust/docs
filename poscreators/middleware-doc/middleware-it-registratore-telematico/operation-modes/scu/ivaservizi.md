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

### Troubleshooting

- **Receipts fail immediately with an authentication error, with no retries observed in the logs**: this is expected — a rejected login (wrong `UserName`/`Password`/`Pin`, or `VATNumber` not delegated to `UserName`) is treated as non-retryable so the same bad login attempt isn't repeated against AdE. Verify the credentials and the delegation on the AdE portal directly.
- **Receipts fail with "no delega found for P.IVA ..."**: `VATNumber` is not among the account's current AdE delegations. Check the delegations under the professional account's AdE portal.
