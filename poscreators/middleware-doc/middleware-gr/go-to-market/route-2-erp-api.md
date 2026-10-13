---
slug: /poscreators/middleware-doc/greece/go-to-market/erp-api
title: 'Route 2: Transmitting through the myDATA ERP API'
---

# Route 2: Transmitting through the myDATA ERP API

On this route the documents are transmitted to myDATA through the **ERP API**, the interface AADE offers to businesses that report their own data, using the **merchant's own myDATA credentials** instead of a provider's. No e-invoicing provider stands between the business and AADE: the documents are registered in the merchant's name, receive their MARK directly, and carry no provider footer.

The fiskaltrust.Middleware performs the same work as on [Route 1](./route-1-fiskaltrust-licence.md) — it validates the request, maps it to the myDATA document type and classifications, numbers the document and transmits it — but it authenticates as the merchant and speaks the ERP endpoints rather than the provider endpoints.

:::info Becoming a licensed provider yourself is not part of this

An AADE provider licence (ΥΠΑΗΕΣ) is granted to the company that operates the platform, and it is obtained from AADE directly. fiskaltrust does **not** offer a route in which a PosCreator is brought to market under its own provider licence on top of the fiskaltrust.Middleware. The choice in Greece is therefore not "our licence or your licence", but **through a licensed provider or under the merchant's own myDATA credentials**.

:::

## What changes compared to Route 1

| Area | Route 1: licensed provider | Route 2: ERP API |
| ---- | -------------------------- | ---------------- |
| Credentials | fiskaltrust transmits with the provider credentials of the licence the Middleware operates under | The merchant's own myDATA credentials (`aade-user-id` and subscription key, obtained through TaxisNet from the myDATA REST portal) are configured for the queue |
| Who the document belongs to | The merchant, issued through the provider | The merchant, transmitted by the merchant's own ERP |
| Provider footer | Legal name, web address and licence identifier of the licensee are returned and must be printed | No provider footer; the provider signature items are not returned |
| Payment signature | The provider ID is transmitted as signing author of the card payment signature | Card payments still need a licensed e-invoicing provider: the payment signature required by *Α.1155/2023* is a provider signature |
| Cancellation | Only order slips (8.6) and delivery notes (9.3) can be cancelled; the generic cancellation call is not open to providers | AADE's generic `CancelInvoice` is available to ERP users, so a wider cancellation is technically possible |
| Provider statement | The merchant declares the provider to AADE within ten days (*Α.1112/2025*, art. 6) | Not applicable — there is no provider to declare |

Everything else is shared: the mapping to myDATA document types and classifications, the validation rules, the numbering, the MARK, UID and authentication code, the QR code and the digital receipt. The [Licensing](../licensing/licensing.md) chapter describes these mechanisms, and the [reference tables](../reference-tables/reference-tables.md) the values behind them.

## What this route does not change

- **Card payments still need a provider.** The payment signature of an interconnected terminal is issued by a licensed e-invoicing provider, so documents paid by card involve a provider on this route as well.
- **The POS terminal interconnection stays.** Card payments remain subject to *Α.1155/2023*; the terminal data belongs on the document either way.
- **Real-time transmission stays.** The ERP API is the same platform with the same availability characteristics; offline handling and the transmission-failure markers work the same way.

## What you build

The integration is the one described in [Route 1](./route-1-fiskaltrust-licence.md): every business case goes through the [PosSystem API](../../possystem-api/introduction.md), with the same receipt cases, charge item cases and pay item cases. The differences are operational rather than in the API:

1. **Collect the merchant's myDATA credentials during onboarding.** The merchant creates them in the myDATA REST portal with their TaxisNet login and hands them over; they are configured for the queue instead of fiskaltrust's provider credentials.
2. **Do not print a provider footer.** The provider signature items are not returned on this route, so a layout that hard-codes them would be wrong.
3. **Expect a different correction path** if the wider cancellation becomes available; until then use the refund and credit documents described in [Receipt Printing](../receipt-printing/receipt-printing.md).

## When to choose it

- The merchant already reports to myDATA from its own ERP and wants one channel and one set of credentials.
- The business case is invoicing rather than retail at the point of sale.
- The merchant prefers documents registered under its own credentials, without a provider named on them.

Choose [Route 1](./route-1-fiskaltrust-licence.md) when a licensed provider should cover the whole retail flow, including the provider footer, the digital receipt and the terminal interconnection.

For the commercial setup of the ERP route, contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu).
