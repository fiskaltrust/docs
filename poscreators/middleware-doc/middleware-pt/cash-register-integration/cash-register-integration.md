---
slug: /poscreators/middleware-doc/portugal/cash-register-integration
title: Cash Register Integration
description: Cash register integration under Portuguese law, including what the Portuguese Middleware validates and how to fix validation errors.
tags: [Cash Register Integration, Portugal, Middleware]
---

# Cash Register Integration

This chapter describes the cash register integration in accordance with Portuguese law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of the general part.

## Validation errors

The Portuguese Middleware validates each `ReceiptRequest` before it signs it. If a request fails validation, the receipt is not signed, no receipt number is consumed, and the response is returned as described in [Error Handling](../../general/cash-register-integration/error-handling.md#how-error-messages-are-returned):

- `ftState` is `0x5054_2000_EEEE_EEEE` (see [ftState](../reference-tables/service-status-ftstate.md)).
- `ftSignatures` contains a failure signature with `Caption` `FAILURE`, `ftSignatureFormat` `0x1` (text) and `ftSignatureType` `0x5054_2000_0000_3000`.
- `Data` contains a text that describes the failed validation.

The response reports one validation error, even if the request violates several rules. Correct the reported error and send the request again; further errors are reported one at a time.

The POS system should base its logic on the `ftState`. The text in `Data` is meant for display and logging; it can change between Middleware versions, so do not parse it.

The following sections describe what the Middleware validates and how to fix a request that fails validation.

### General request data

| What is validated | How to fix |
|-------------------|------------|
| The country code in `ftReceiptCase`, `ftChargeItemCase` and `ftPayItemCase` is `PT` (`0x5054`). | Use the Portuguese cases from the [reference tables](../reference-tables/reference-tables.md) for the receipt, all charge items and all pay items. |
| `cbChargeItems` and `cbPayItems` are present. | Always send both lists. Send an empty list if a receipt has no charge items or no pay items. |
| `Currency` is `EUR`. | Send amounts in euro. |
| Training mode is only used on queues where it has been enabled. | Do not set the training flag in `ftReceiptCase` unless training mode has been enabled for the queue. |
| `cbReceiptReference` is unique. | Use a new `cbReceiptReference` for every receipt. A reference that was used by a successfully processed receipt cannot be used again. |
| `cbReceiptMoment` is in UTC and close to the time at which the Middleware processes the receipt. | Send `cbReceiptMoment` in UTC and keep the clock of the POS system synchronized. Send the receipt to the Middleware when it is created. |
| `Position` of charge items and pay items starts at 1 and increases by 1 without gaps. | Number the positions 1, 2, 3, … in each list, or do not set them. |

*Table 1. Validation of general request data.*

### User and customer

| What is validated | How to fix |
|-------------------|------------|
| `cbUser` is a string with at least 3 characters that identifies the operator. | Always send `cbUser` as a string, for example the operator's name. Do not send a JSON object. |
| `cbCustomer` is a valid customer object. | Send `cbCustomer` as a JSON object with the customer fields of the [data model](../../general/data-structures/data-structures.md), or omit it. |
| A Portuguese customer VAT ID is a valid NIF. | If `CustomerVATId` is a Portuguese NIF (`CustomerCountry` is empty or `PT`), send the 9-digit number without prefix or spaces, and check it for typing errors. For foreign customers, set `CustomerCountry` to the customer's country. |

*Table 2. Validation of the user and the customer.*

### Charge items

| What is validated | How to fix |
|-------------------|------------|
| Every charge item has a `Description` of at least 3 characters. | Send a meaningful article description. |
| `Description` contains only characters that can be encoded in Windows-1252. | Remove emojis and other special characters from the description. |
| `Quantity` and `Amount` are not 0. | Do not send charge items with zero quantity or zero amount. |
| The VAT rate is supported in Portugal: reduced (6 %), intermediate (13 %), normal (23 %) or not taxable (0 %). | Use one of these VAT rates in [ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md). |
| `VATRate` matches the VAT rate in `ftChargeItemCase`. | Send the percentage that belongs to the VAT rate of the case, for example `23` for the normal rate. |
| `VATAmount` matches `Amount` and `VATRate`. | Calculate `VATAmount` as `Amount / (100 + VATRate) * VATRate`, or do not send it; the Middleware then calculates it. |
| A charge item with 0 % VAT has a tax exemption reason. | Set the nature of VAT (`NN`) in `ftChargeItemCase` to the Portuguese tax exemption reason that applies. |
| The type of service in `ftChargeItemCase` is supported in Portugal. | Use one of the types of service listed in [ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md). |
| A discount or extra has the same VAT rate as the line item it belongs to. | Send the discount directly after its line item, with the same `VATRate` and the same VAT rate in `ftChargeItemCase`. |
| A discount is negative and does not exceed the amount of its line item. | Send discounts with a negative `Amount`. Positive extras are not allowed. |
| Outside refunds and voids, charge items have a positive `Quantity` and `Amount`. Only discounts are negative. | Do not reduce a sale with negative items. To give money back, issue a [refund](#references-refunds-voids-and-payment-transfers). |

*Table 3. Validation of charge items.*

### Totals and legal limits

| What is validated | How to fix |
|-------------------|------------|
| The sum of the charge items equals the sum of the pay items. Table checks (`0x0006`) and pro forma invoices (`0x0007`) are not checked. | Make sure that the pay items cover exactly the receipt total. |
| Cash payments do not exceed 3,000 € in total. | Do not accept more than 3,000 € in cash for one receipt. |
| A POS receipt (`0x0001`) does not exceed 100 € net. Services (type of service _other service_) on a POS receipt do not exceed 100 € net. Refunds are not checked. | Issue an invoice (`0x1000`–`0x1003`) instead of a POS receipt. |
| Table checks (`0x0006`) and pro forma invoices (`0x0007`) contain no pay items. | Send these working documents with an empty `cbPayItems` list. |
| Delivery notes (`0x0005`) and pro forma invoices (`0x0007`) do not use the transport information flag. | Do not set the transport information flag. |

*Table 4. Validation of totals, legal limits and working documents.*

### Handwritten receipts

For handwritten receipts, only the following rules are checked in addition to the [general request data](#general-request-data) and the [user](#user-and-customer).

| What is validated | How to fix |
|-------------------|------------|
| The handwritten flag is used only for invoices (`0x1000`–`0x1003`). | Use an invoice case (`0x1000`–`0x1003`) together with the handwritten flag. |
| The handwritten flag is not combined with a refund, partial refund or void. | Send refunds and voids without the handwritten flag. |
| `ftReceiptCaseData` contains the series and number of the handwritten document in `PT.Series` and `PT.Number`, and `Number` is at least 1. | Send the series and number printed on the handwritten document. |
| `PT.Series` contains no spaces. | Remove spaces from the series. |
| Each combination of series and number is recorded only once. | Check whether the handwritten document has already been recorded. Do not send it again. |

*Table 5. Validation of handwritten receipts.*

### References, refunds, voids and payment transfers

Unreferenced refunds are not supported in Portugal. Every refund must reference the original receipt in `cbPreviousReceiptReference`:

- **Full refund:** the refund flag is set in `ftReceiptCase`. The request must contain all items of the original receipt with negated `Quantity` and `Amount`.
- **Partial refund:** the refund flag is not set in `ftReceiptCase`, but it is set in the `ftChargeItemCase` of at least one charge item. All charge items and pay items must have the refund flag set, and the refunded quantities and amounts must not exceed the original.

| What is validated | How to fix |
|-------------------|------------|
| Refunds, partial refunds, voids, payment transfers (`0x0002`) and copies (`0x3010`) reference the original receipt. | Set `cbPreviousReceiptReference` to the `cbReceiptReference` of the original receipt. Reference exactly one receipt. |
| A full refund or void contains the same items as the original receipt, with negated `Quantity` and `Amount`. | Copy the charge items and pay items of the original receipt and negate `Quantity` and `Amount`. Keep all other fields, including `cbCustomer`, unchanged. |
| A partial refund contains only refund items that exist in the original receipt, with the same unit price, VAT rate and `ftChargeItemCase`. | Take the refunded items from the original receipt. Set the refund flag on every charge item and pay item. |
| The refunded quantities and amounts, including earlier partial refunds, do not exceed the original. | Refund only what has not been refunded yet. |
| The original receipt has not been fully refunded or voided yet. | Check the state of the original receipt before sending a refund or void. A fully refunded or voided receipt cannot be refunded or voided again. |
| A receipt that has been invoiced, refunded or partially refunded is not voided. | Do not void the receipt. |
| A receipt that is not a refund, void or payment transfer and references another receipt (for example, an invoice for a table check) shares at least one line item with it. | Reference the receipt whose items are being invoiced. |
| A payment transfer references an invoice (`0x1000`–`0x1003`) that has not been refunded. | Reference the original invoice. |
| A payment transfer contains a charge item with type of service _receivable_, the same `cbCustomer` as the invoice, and does not exceed the open amount of the invoice. | Send the paid amount as a receivable charge item, copy `cbCustomer` from the invoice, and pay at most the amount that is still open. |

*Table 6. Validation of references, refunds, voids and payment transfers.*
