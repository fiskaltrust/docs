---
slug: /poscreators/middleware-doc/general/cash-register-integration/additional-lines
title: Additional Lines on the Receipt
description: How a POS system adds text lines to a receipt rendered or printed by fiskaltrust, such as sublines below a charge item with cbChargeItemLines, receipt-level lines with cbReceiptLines and payment receipts with cbPayItemLines or Receipt.
tags: [cbChargeItemLines, cbReceiptLines, cbPayItemLines, ftChargeItemCaseData, Receipt, Cash Register Integration]
---

# Additional Lines on the Receipt

Besides the charge items and pay items, a receipt often carries text that has no price of its own: the size and colour of an article, a serial number, a table number or the payment receipt of a card payment. In the fiskaltrust.Middleware data model, the POS system sends this text as arrays of strings in the case data fields of the request. It does not send it as extra charge items.

This page describes these fields. They apply when fiskaltrust renders or prints the receipt, for example as a digital receipt, as PDF, PNG or ESC/POS output from the [POS System API](../../possystem-api/receipt-formats.md), or on a fiscal printer that the Middleware drives. When the POS system prints the receipt itself from the `ReceiptResponse`, it lays out its own lines.

## Overview

| Field | Sent in | Where it appears | Typical use |
|-------|---------|------------------|-------------|
| `cbChargeItemLines` | `ftChargeItemCaseData` of a charge item | Directly below the description of the charge item | Size, colour, serial number, return period, promotion text |
| `cbReceiptLines` | `ftReceiptCaseData` of the receipt | Once per receipt, outside the list of charge items | Table number, order reference, delivery information, loyalty balance |
| `cbPayItemLines` | `ftPayItemCaseData` of a pay item | In a block after the payments | Payment receipt of the POS system's own card terminal |
| `Receipt` | `ftPayItemCaseData` of a pay item | In a block after the payments | Payment receipt returned by the payment endpoint of the POS System API |

*Table 1. Fields that add text lines to the receipt.*

All fields are top-level properties of the case data object, see [Object fields](../data-structures/data-structures.md#object-fields). Each is an array of strings; every string is printed as its own line. Where the lines appear exactly, and whether a market supports a field at all, depends on the market and the output; see [Market-specific considerations](#market-specific-considerations).

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
- Charge items can be accumulated into one line for visualization, see [ChargeItem](../data-structures/data-structures.md#chargeitem). The accumulated line shows the sublines of the charge item with the lowest `Position` only. To keep different sublines, for example different serial numbers, send charge items that are not accumulated, for example with different descriptions.
- The ESC/POS output of the POS System API does not print `cbChargeItemLines`.
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

## Payment receipts

A card payment produces a payment receipt with the transaction data, for example the terminal ID, the masked card number and the authorisation code. To hand it over to the customer together with the fiscal receipt, the POS system sends it in the `ftPayItemCaseData` of the pay item. Two fields are available:

- `cbPayItemLines`: the POS system fills it, for example with the receipt text returned by its own card terminal.
- `Receipt`: the [payment endpoint](../../experience-middleware/payment.md) of the POS System API can return the payment receipt in this field of the returned pay items. The POS system takes over the pay items unchanged into `cbPayItems`, so the payment receipt is handed over without further work.

```json
{
  "Description": "Card",
  "Amount": 38.75,
  "ftPayItemCase": 4707422694881099781,
  "ftPayItemCaseData": {
    "cbPayItemLines": [
      "TID 3600140",
      "",
      "CUSTOMER RECEIPT",
      "18.01.2026         08:06:32",
      "Auth. code:          039505",
      "",
      "MASTERCARD",
      "XXXXXXXXXXXX7803",
      "AMOUNT        EUR     38.75",
      "",
      "Transaction approved"
    ]
  }
}
```

The following rules apply:

- The lines are printed after the payments, in a separate block per pay item. On the receipts rendered by fiskaltrust, the block is headed with the description and amount of the pay item, and the lines are printed centred in a monospaced font with their spaces kept, so that the layout of a terminal receipt is preserved.
- On the receipts rendered by fiskaltrust, an empty string is printed as an empty line, and an entry that contains line breaks (`\n`) is split into several lines. The ESC/POS output does not split entries, so send one line per entry.
- If a pay item carries both fields, only the lines of `Receipt` are printed.

## Market-specific considerations

The fields on this page are the interface default. Markets restrict them or add options, depending on the national receipt format and on the fiscal device or service that prints the receipt. Before implementing, consult the market pages:

- Italy: [Additional lines on the RT receipt](../../middleware-it-registratore-telematico/data-structures/data-structures.md#additional-lines-on-the-rt-receipt)
- Portugal: [Receipt options, configuration, and extension points](../../middleware-pt/certification/certification.md#receipt-options-configuration-and-extension-points)

## Related pages

- [Data Structures](../data-structures/data-structures.md#chargeitem): `ChargeItem`, `ftChargeItemCaseData`
- [Receipt Formats](../../possystem-api/receipt-formats.md): output formats of the POS System API
- [Discounts and Extras](discounts-and-extras.md): price reductions and surcharges, which are charge items with an amount
