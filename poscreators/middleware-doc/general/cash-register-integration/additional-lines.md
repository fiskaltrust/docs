---
slug: /poscreators/middleware-doc/general/cash-register-integration/additional-lines
title: Additional Lines on the Receipt
description: How a POS system adds text lines to a receipt rendered or printed by fiskaltrust, such as sublines below a charge item with cbChargeItemLines, receipt-level lines with cbReceiptLines and payment details with cbPayItemLines.
tags: [cbChargeItemLines, cbReceiptLines, cbPayItemLines, ftChargeItemCaseData, Receipt, Cash Register Integration]
---

# Additional Lines on the Receipt

Besides the charge items and pay items, a receipt often carries text that has no price of its own: the size and colour of an article, a serial number, a table number or the details of a card payment. In the fiskaltrust.Middleware data model, the POS system sends this text as arrays of strings in the case data fields of the request. It does not send it as extra charge items.

This page describes these fields. They apply when fiskaltrust renders or prints the receipt, for example as a digital receipt, as PDF, PNG or ESC/POS output from the [POS System API](../../possystem-api/receipt-formats.md), or on a fiscal printer that the Middleware drives. When the POS system prints the receipt itself from the `ReceiptResponse`, it lays out its own lines.

## Overview

| Field | Sent in | Where it appears | Typical use |
|-------|---------|------------------|-------------|
| `cbChargeItemLines` | `ftChargeItemCaseData` of a charge item | Directly below the description of the charge item | Size, colour, serial number, return period, promotion text |
| `cbReceiptLines` | `ftReceiptCaseData` of the receipt | Once per receipt, outside the list of charge items | Table number, order reference, delivery information, loyalty balance |
| `cbPayItemLines` | `ftPayItemCaseData` of a pay item | In a block after the payments | Card payment details from the terminal, such as the masked card number and authorisation code |

*Table 1. Fields that add text lines to the receipt.*

All three fields are top-level properties of the case data object, see [Object fields](../data-structures/data-structures.md#object-fields). Each is an array of strings; every string is printed as its own line. Where the lines appear exactly, and whether a market supports a field at all, depends on the market and the output; see [Market-specific considerations](#market-specific-considerations).

## Sublines below a charge item

To print additional lines below a charge item, the POS system adds the array `cbChargeItemLines` to the `ftChargeItemCaseData` of that charge item:

```json
{
  "Position": 1,
  "Quantity": 1,
  "Description": "T-Shirt",
  "Amount": 19.90,
  "VATRate": 20,
  "ftChargeItemCase": 4707422694881099795,
  "ftChargeItemCaseData": {
    "cbChargeItemLines": [
      "Colour: light blue",
      "Size: S",
      "Return until: 30.12.2026"
    ]
  }
}
```

The examples on this page use an Austrian queue: `4707422694881099795` is `ftChargeItemCase` `0x4154_2000_0000_0013` (delivery, normal VAT rate), `4707422694881099781` is `ftPayItemCase` `0x4154_2000_0000_0005` (credit card).

The lines are printed directly below the description, in the order of the array, before the line with quantity, unit price and amount:

```text
T-Shirt
Colour: light blue
Size: S
Return until: 30.12.2026
1 x 19.90                     19.90 A
```

*Figure 1. A charge item with three sublines on an 80 mm receipt.*

The following rules apply:

- The property name `cbChargeItemLines` is case-sensitive, and its value must be an array of strings. If `ftChargeItemCaseData` is not valid JSON or the property has another type, the receipt shows no sublines.
- On 80 mm receipts, the sublines are printed in a smaller font than the description.
- Charge items with the same `Description`, unit price and `ftChargeItemCase` can be accumulated into one line for visualization, see [ChargeItem](../data-structures/data-structures.md#chargeitem). The accumulated line shows the sublines of the charge item with the lowest `Position` only. To keep different sublines, for example different serial numbers, the charge items must differ in one of these values.
- Do not use line breaks in `Description` to create additional lines. Depending on the output, a line break is ignored or breaks the column layout of the receipt.

## Lines for the whole receipt

Text that belongs to the receipt rather than to one charge item, for example a table number or an order reference, is sent in the array `cbReceiptLines` of `ftReceiptCaseData`:

```json
"ftReceiptCaseData": {
  "cbReceiptLines": [
    "Table 12",
    "Order 4711"
  ]
}
```

These lines are not printed between the charge items. On the receipts rendered by fiskaltrust, they appear after the payments and the customer block, before the footer.

## Lines for a payment

Details of a payment, for example the data returned by a card terminal, are sent in the array `cbPayItemLines` of the `ftPayItemCaseData` of that pay item:

```json
{
  "Description": "Card",
  "Amount": 19.90,
  "ftPayItemCase": 4707422694881099781,
  "ftPayItemCaseData": {
    "cbPayItemLines": [
      "VISA **** **** **** 1234",
      "Auth. code: 123456",
      "Terminal ID: 87654321"
    ]
  }
}
```

The lines are printed in a separate block after the payments.

## Market-specific considerations

The fields on this page are the interface default. How a market renders them depends on the national receipt format and on the fiscal device or service that prints the receipt:

- **Italy:** receipts are printed by the RT printer or RT server. `cbChargeItemLines` is not printed; text lines between the charge items are created with charge items without amount. See [Additional lines on the RT receipt](../../middleware-it-registratore-telematico/data-structures/data-structures.md#additional-lines-on-the-rt-receipt).
- **Portugal:** the lines must not replace or imitate a mandatory element of the certified document. The Middleware adds the VAT exemption reason as a subline automatically. See [Receipt options, configuration, and extension points](../../middleware-pt/certification/certification.md#receipt-options-configuration-and-extension-points).
- **ESC/POS output** of the POS System API does not print `cbChargeItemLines`.

## Related pages

- [Data Structures](../data-structures/data-structures.md#chargeitem): `ChargeItem`, `ftChargeItemCaseData`
- [Receipt Formats](../../possystem-api/receipt-formats.md): output formats of the POS System API
- [Discounts and Extras](discounts-and-extras.md): price reductions and surcharges, which are charge items with an amount
