---
slug: /poscreators/middleware-doc/belgium/go-to-market/fdm-event-operations
title: FDM event operations
---

# FDM event operations

The FPS Finance defines eight event types and fifteen GraphQL mutations that a cash register system uses to register events on the FDM. The POS does not call these mutations itself. It sends a `ReceiptRequest` with the matching `ftReceiptCase` to the fiskaltrust.Middleware, and the fiskaltrust.Middleware calls the mutation.

This page lists every mutation, the receipt case that triggers it, and its implementation status.

:::caution Implementation status

The request formats of all fifteen mutations are implemented in the fiskaltrust.Middleware. The mapping from receipt cases to mutations is being added step by step. The status below reflects the current sandbox; receipt cases marked *to be defined* do not yet have a final mapping.

:::

## Coverage of the FDM mutations

| Event (label) | FDM mutation | fiskaltrust receipt case | Status |
| ------------- | ------------ | ------------------------ | ------ |
| NORMAL (`N`) | `signSale` | POS receipt `0x4245_2000_0000_0001` (and unknown `…_0000`), including refunds with the refund flag | **Available** |
| NORMAL (`N`), training | `signSale` with training | POS receipt with the training flag `0x0002` in `gggg`; the FDM registers it with label `T` | **Available** |
| REPORT (`R`) | `signReportTurnoverZ` | Daily closing `0x4245_2000_0000_2011` | **Available** (turnover totals in development, see below) |
| REPORT (`R`) | `signReportTurnoverX` | To be defined | In development |
| REPORT (`R`) | `signReportUserX` | To be defined | In development |
| REPORT (`R`) | `signReportUserZ` | To be defined | In development |
| INVOICE (`I`) | `signInvoice` | Invoice `…_1001` (B2C), `…_1002` (B2B), `…_1003` (B2G) with `cbPreviousReceiptReference` to the VAT receipts | In development |
| PRO FORMA (`P`) | `signOrder` | Order `…_3004` | In development |
| PRO FORMA (`P`) | `signPreBill` | Table check / provisional bill `…_0006` | In development |
| PRO FORMA (`P`) | `signCostCenterChange` | To be defined | In development |
| FINANCIAL (`F`) | `signMoneyInOut` | Payment transfer `…_0002` | In development |
| FINANCIAL (`F`) | `signDrawerOpen` | To be defined | In development |
| FINANCIAL (`F`) | `signPaymentCorrection` | To be defined | In development |
| COPY (`C`) | `signCopy` | Copy receipt `…_3010` with `cbPreviousReceiptReference` to the original | In development |
| SOCIAL (`S`) | `signWorkIn` | To be defined | In development |
| SOCIAL (`S`) | `signWorkOut` | To be defined | In development |

*Table 1. FDM mutations and their fiskaltrust receipt cases.*

:::warning Receipt cases without an FDM mapping

Until a receipt case is mapped to its mutation, the sandbox either accepts it **without sending it to the FDM** (the response carries no FDM signature) or rejects it as not yet implemented. A response without FDM signature items is never a valid fiscal document. Do not build production flows on these cases before they are marked as available.

:::

The initial-operation receipt (`…_4001`), the out-of-operation receipt (`…_4002`), and the zero receipt (`…_2000`) are handled by the fiskaltrust.Middleware itself and do not create an FDM event.

## Mapping of the fiskaltrust data model

### VAT codes

The FDM calculates the taxable amounts and the VAT itself, based on the VAT code of every line. The fiskaltrust.Middleware derives the code from the VAT rate of the charge item:

| `VATRate` of the charge item | FDM VAT code |
| ---------------------------- | ------------ |
| 21 % | `A` |
| 12 % | `B` |
| 6 % | `C` |
| 0 % with VAT type *Zero VAT rate* (`7`) | `D` |
| 0 % with any other VAT type, e.g. *Not taxable* (`8`) | `X` (outside the scope of VAT) |

*Table 2. Mapping of VAT rates to FDM VAT codes.*

Other rates are rejected. Use code `X` (a 0 % *Not taxable* charge item) for deposits, empties, and the sale of multi-purpose vouchers.

### Payment types

| `ftPayItemCase` | FDM payment type |
| --------------- | ---------------- |
| `00` Unknown | `UNKNOWN` |
| `01` Cash | `CASH` |
| `02` Non-cash | `OTHER` |
| `03` Crossed cheque | `CHEQUE_OTHER` |
| `04` Debit card | `CARD_DEBIT` |
| `05` Credit card | `CARD_CREDIT` |
| `06` Voucher (by money value) | `VOUCHER_OTHER` |
| `07` Online payment | `ONLINE` |
| `08` Loyalty program / customer card | `LOYALTY_REWARDS` |
| `09` Accounts receivable | Not supported |
| `0A` SEPA transfer, `0B` other bank transfer, `0C` transfer to cashbook, `0D` internal consumption, `0E` grant, `0F` ticket restaurant | `OTHER` |

*Table 3. Mapping of payment types.*

A pay item with the tip flag (`0x0040`) is sent with amount type `TIP`. The finer FDM payment types (`CHEQUE_MEAL`, `VOUCHER_STORE`, `VOUCHER_SUPPLIER`, `APP`, `CUSTOMER_CREDIT`, `ROOM_CREDIT`), the payment provider, the input method (manual or EFT), and the `ROUNDING` amount type are in development.

### Negative quantities

The FDM requires a reason for every negative quantity. A charge item with the refund flag (`0x0002`), or on a receipt with the refund flag (`0x0100`), is sent with the reason `REFUND`. Negative lines without a refund flag are currently sent without a reason and rejected by the FDM; the mapping of the other reasons (`CORRECTION`, `PRICE_CHANGE`, `VOUCHER`, …) is in development.

### Current limitations of the sale mapping

The following parts of the FDM data model are not yet filled by the fiskaltrust.Middleware and are in development:

- Reference to the original VAT receipt (`fdmRefs`) for a complete refund.
- Price changes (discounts and surcharges) attached to a product line.
- Composite products (`COMPOSITE_PRODUCT` with sub-products), e.g. menus and item packages, and products with more than one VAT code.
- Quantity types other than `PIECE`, e.g. `KILOGRAM` for weight-based items.
- Product IDs, GTINs, and departments from the POS master data.
- Cost centers (tables, seats, rooms) and transfers.
- The ticket medium `DIGITAL` / `PAPER_DIGITAL` for digital VAT receipts.
- The turnover totals of the Z report (per department, VAT code, payment type, and negative-quantity reason).

## Control data returned to the POS

For every event the FDM signs, the fiskaltrust.Middleware adds the following items to `ftSignatures`:

| Caption | Format | Content |
| ------- | ------ | ------- |
| `DigitalSignature` | Text | The FDM's digital signature of the event |
| `ShortSignature` | Text | The short signature to print on the VAT receipt |
| `VerificationUrl` | QR code | The URL from which the POS generates the QR code |

*Table 4. Signature items returned by the fiskaltrust.Middleware.*

The complete FDM response, including the counters and the VAT calculation, is stored in `ftStateData` of the response. The mapping of the remaining control data (`fdmId`, `fdmDateTime`, event label, event and total counter, footer lines) into dedicated signature items is in development.

If the FDM refuses an event, the response is marked as failed and contains the FDM's error message together with its code (for example `INVALID_REQUEST` and the sub-code naming the field). Messages the FDM marks as mandatory for display must be shown to the user.

## Walkthrough

fiskaltrust walks through the supported operations with PosCreators in the sandbox. Contact your fiskaltrust account manager to schedule a session.
