---
slug: /poscreators/middleware-doc/greece/data-structures
title: Data Structures
description: How cbCustomer fields are transmitted to myDATA as the document counterpart for Greece, and how refunds and voids reference documents from other systems by their MARK.
tags: [Greece, cbCustomer, ftReceiptCaseData, MARK, Data Structures, myDATA, Middleware]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Greek market.

## cbCustomer

- The customer is transmitted to myDATA as the counterpart of the document. Without `cbCustomer`, no counterpart is transmitted and the customer is treated as domestic.
- `cbCustomer` is required for myDATA document types that need customer information, such as invoices.

| Field Name            | Description |
|-----------------------|-------------|
| `CustomerCountry`     | Determines whether the customer is domestic (`GR`, `EL` or empty), from another EU country or from a third country. This category also determines the myDATA document type and income classification. The counterpart is only transmitted when the country code is valid. |
| `CustomerName`        | Name of the counterpart. Only transmitted for customers outside Greece or when the receipt carries transport information. |
| `CustomerZip`         | Postal code of the counterpart's address. The address is only transmitted when both `CustomerZip` and `CustomerCity` are set. |
| `CustomerCity`        | City of the counterpart's address. The address is only transmitted when both `CustomerZip` and `CustomerCity` are set. |

*Table 1. cbCustomer fields read by the Middleware for the Greek market.*

## ftReceiptCaseData

### PreviousReceiptReference

A refund or void references the original document with `cbPreviousReceiptReference` when the original receipt was processed by the same queue; the Middleware then transmits the MARK of that receipt to myDATA. A document that was issued by another system, for example another cash register or an invoice that was not issued through the Middleware, is referenced by its MARK in `ftReceiptCaseData.GR.PreviousReceiptReference.invoiceMark`.

| Field Name     | Data Type | Description |
|----------------|-----------|-------------|
| `invoiceMark`  | `long`, numeric `string`, or an array of these | One or more MARKs of the referenced documents. An empty array is rejected; omit the field instead. |

*Table 2. Fields of `ftReceiptCaseData.GR.PreviousReceiptReference`.*

```json
"ftReceiptCaseData": {
  "GR": {
    "PreviousReceiptReference": {
      "invoiceMark": [400001234567890]
    }
  }
}
```

The MARKs in `invoiceMark` are added to the MARKs of the receipts referenced in `cbPreviousReceiptReference`, so both can be used in the same request. The Middleware does not look up an external MARK; it is transmitted to myDATA as given. Depending on the resulting myDATA document type, the MARKs are transmitted as `correlatedInvoices` or `multipleConnectedMarks`:

| Request | myDATA document type | Field |
|---------|----------------------|-------|
| Receipt with the `IsReturn/IsRefund` flag (retail refund) | 11.4 | `multipleConnectedMarks` |
| Invoice with the `IsReturn/IsRefund` flag | 5.1 with a reference, 5.2 without a reference | `correlatedInvoices` |
| Order (`0x3004`) with the `IsVoid` flag | 8.6 | `multipleConnectedMarks` |

*Table 3. myDATA fields for referenced MARKs in refunds and voids.*

- An invoice refund becomes a correlated credit note (5.1) as soon as it carries a reference, whether in `cbPreviousReceiptReference`, in `invoiceMark`, or as `correlatedInvoices` or `multipleConnectedMarks` in `ftReceiptCaseData.GR.mydataoverride.invoice.invoiceHeader`.
- The void of an Order (8.6) requires one of these references and `cbArea` (the table number); otherwise the request is rejected. The `IsVoid` flag is not supported for other document types; use a refund instead.
