---
slug: /poscreators/middleware-doc/poland/data-structures
title: Data Structures
description: Data structure rules for Poland — mandatory PLN currency on every request, separating return positions from sales, how discounts and extras are assigned to sale lines, and which additional lines the POSNET register prints on the receipt.
tags: [Data Structures, Currency, Receipt Case, Discount, Additional Lines, cbPayItemLines, Poland]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Polish market.

## Currency

The queue currency for Poland is **PLN**. The receipt (`Currency`) and every charge item and pay item must carry `PLN` explicitly — the data format defaults to EUR, so POS Creators must set the currency on each request. Requests violating this rule are rejected with the validation error code `CurrencyMustMatchMarket`.

## Sale and return positions

A Polish fiscal document must not mix sale and return positions: the register protocol processes returns as separate non-fiscal documents. Send returns as their own receipts flagged with `IsReturn/IsRefund` (`0x0100_0000_0000`) and reference the original receipt via `cbPreviousReceiptReference`. Discounts/extras and voids are position modifiers, not return positions.

## Discounts and extras

The [POSNET register](../operation-modes/scu/posnet.md) prints a charge item with the flag `Discount` (`0x0000_0000_0004_0000`) as a discount (rabat, negative amount) or an extra (narzut, positive amount) on the sale line it belongs to. In addition to the general rules in [Discounts and Extras](../../general/cash-register-integration/discounts-and-extras.md), the following rules apply. They describe the POSNET SCU, which is in preview; see [Scope of the preview](../operation-modes/scu/posnet.md#scope-of-the-preview).

- **Assignment by `Position`**: if the discount or extra has a `Position`, it belongs to the sale line whose `Position` has the same integer part; for example, `1.1` belongs to position `1`, even if another position was sent in between. A fractional `Position` whose integer part matches no sale line of the receipt is rejected.
- **Assignment by order**: without a `Position`, the discount or extra belongs to the sale line before it.
- **Subtotal discount**: a discount or extra without a `Position` and with no sale line before it applies to the subtotal of the receipt (rabat od podsumy); the register distributes it over the VAT rates of the receipt.
- **One per sale line**: a sale line carries at most one discount or extra. Send several discounts on one position as a single discount, or split the sale into one position per discount.
- **VAT rate**: a discount or extra uses the same VAT rate in `ftChargeItemCase` as the position it belongs to, or no VAT rate (`0`); it is then granted at the rate of the position.
- **Amount**: the amount of a discount or extra is not `0`. A line discount must not exceed the value of its position, and a subtotal discount must be less than the subtotal, because the register cannot print a negative sale line or a receipt with a total of zero or less.
- **Voids**: a discount or extra cannot be voided with `IsVoid`. Send the position with the discount or extra it ends up with. A discount or extra that directly follows the void (storno) of the position it would belong to is rejected; send it after the position, before the void, or name the position in `Position`.
- **Returns**: a return document cannot contain discounts or extras. Send the returned positions with the value that is handed back.

## Additional lines on the receipt

In Poland, the receipt (*paragon fiskalny*) is printed by the [POSNET register](../operation-modes/scu/posnet.md), not rendered by fiskaltrust. The fields described in [Additional Lines on the Receipt](../../general/cash-register-integration/additional-lines.md) are therefore printed by the register, and the Polish middleware adds the object `PL.printout` in `ftReceiptCaseData` for the register's own footer elements. Everything below is printed **inside the fiscal receipt**: the receipt and its additional lines are one document with one document number, and the paper is cut once, after the last line. The POSNET SCU is in preview; see [Scope of the preview](../operation-modes/scu/posnet.md#scope-of-the-preview).

| Option | Sent in | Status | Where it is printed |
|--------|---------|--------|---------------------|
| Lines for the whole receipt (`cbReceiptLines`) | `ftReceiptCaseData` | Supported | Left-aligned lines after the footer lines of the receipt |
| Payment receipt (`cbPayItemLines`, `Receipt`) | `ftPayItemCaseData` of a pay item | Supported | Left-aligned lines after the lines for the whole receipt |
| Barcode (`PL.printout.barcode`) | `ftReceiptCaseData` | Supported | At the end of the receipt |
| Footer lines (`PL.printout.lines`) | `ftReceiptCaseData` | Supported | After the fiscal footer of the receipt |
| Information lines (`PL.printout.infoLines`) | `ftReceiptCaseData` | Supported | At the end of the receipt, above the barcode |
| Cashier and register number | `cbUser`, `cbTerminalID` | Supported | In the fiscal footer of the receipt |
| QR code (`PL.printout.qrCode`) | `ftReceiptCaseData` | Planned | |
| Sublines below a charge item (`cbChargeItemLines`) | `ftChargeItemCaseData` of a charge item | Planned | |

*Table 1. Additional lines on the Polish receipt and their status.*

### Tested devices

POSNET offers several fiscal printer models, with different firmware versions, and not every model or firmware version prints these options in the same way or supports them at all. *Supported* in Table 1 means that the option was tested and its printout checked on the devices in Table 2. On other models or firmware versions, the options have not been tested yet.

| Printer | Software version | Connection | Host | Fiscalized |
|---------|------------------|------------|------|------------|
| POSNET THERMAL XL2 ONLINE | 30.01 | USB | Android POS terminal V8 (Android 11), fiskaltrust Android launcher 2.0.0-beta | No (sandbox) |

*Table 2. Devices on which the supported options were tested.*

### Order on the receipt

The register prints the receipt in a fixed order. The additional lines follow the fiscal footer (document number, register number and cashier, signature and the unique number of the register), and the information lines and the barcode are always printed last:

```text
SUMA PLN                              100,00
ROZLICZENIE PŁATNOŚCI
KARTA Mastercard                  100,00 PLN
00025 #02 238689            2026-10-23 13:55
8008CC3B99C59F0806E02A8DD8398A559E591894
               ZBF 2101002396
Ilość sprzedanych towarów:                 1
Nr transakcji:                            16

Otrzymano Mastercard 100,00
Zwrot towaru do dnia: 2026-10-30
|--------------------------------------|
|CARDHOLDER COPY                       |
|Card                          ****9999|
|APPROVED                              |
|--------------------------------------|
   Zwrot lub wymiana nieużywanego towaru
    wraz z metką na podstawie paragonu
  w ciągu 30 dni. Nie dotyczy kosmetyków.
||||||||||||||||||||||||||||||||||||||||
         20260930004000200016
```

*Figure 1. End of a receipt with footer lines, a payment receipt, information lines and a barcode (shortened).*

### Lines for the whole receipt

The register prints the strings of `cbReceiptLines` in `ftReceiptCaseData`, described in [Lines for the whole receipt](../../general/cash-register-integration/additional-lines.md#lines-for-the-whole-receipt), inside the fiscal receipt:

- Every string is printed as its own left-aligned line, after the footer lines of the receipt and before the payment receipts.
- A line holds up to 40 characters. Send one line per entry.

`cbReceiptLines` can be sent in the same object as `PL`:

```json
"ftReceiptCaseData": {
  "cbReceiptLines": [
    "Dziękujemy za zakupy!",
    "Karta klubowa: 238689"
  ],
  "PL": {
    "printout": {
      "barcode": "20260930004000200016"
    }
  }
}
```

### Payment receipts

The register prints the payment receipt of a pay item, sent in `cbPayItemLines` or `Receipt` of its `ftPayItemCaseData` as described in [Payment receipts](../../general/cash-register-integration/additional-lines.md#payment-receipts), inside the fiscal receipt:

- Every string is printed as its own left-aligned line, after the footer lines and the lines for the whole receipt. The payment receipts of several pay items follow each other in the order of the pay items.
- A line holds up to 40 characters. Send the payment receipt formatted for this width, one line per entry.
- If a pay item carries both fields, only the lines of `Receipt` are printed.
- Unlike on the receipts rendered by fiskaltrust, the payment receipt has no heading with the description and amount of the pay item, and the lines are not centred.

### Footer elements of the register

The object `PL.printout` in `ftReceiptCaseData` sets the elements of the register's footer for this receipt. All properties are optional:

| Property | Description | Limits |
|----------|-------------|--------|
| `barcode` | Barcode printed at the end of the receipt, with its text below it | Up to 30 ASCII letters and digits |
| `lines` | Footer lines, see [Footer lines](#footer-lines) | |
| `infoLines` | Information lines printed at the end of the receipt, above the barcode | Up to 3 lines |
| `infoLinesAlign` | `center` prints the information lines centred; without it, they are left-aligned | `center` |

*Table 3. Properties of `PL.printout`.*

#### Footer lines

Each entry of `lines` is an object with a `text`. How the register prints it depends on the other properties:

| Entry | Printed as | Example |
|-------|------------|---------|
| `label` and `text` | Line with the register's own label on the left and `text` on the right | `{ "label": "itemCount", "text": "1" }` prints `Ilość sprzedanych towarów:` … `1` |
| `align: "left"` and `text` | Left-aligned text in normal size, up to 40 characters | `{ "text": "Zwrot towaru do dnia: 2026-10-30", "align": "left" }` |
| `text` only | Text aligned to the right, behind an empty column of 15 characters | `{ "text": "" }` prints an empty line |

*Table 4. Footer lines in `PL.printout.lines`.*

The labels `itemCount` (*Ilość sprzedanych towarów*) and `transactionNumber` (*Nr transakcji*) are available. Use `align: "left"` for free text: a line with `text` only is aligned to the right, and a longer text wraps.

### Cashier and register number

The fiscal footer of the receipt shows the register number and the cashier, for example `#02 238689`. The register takes them from the request:

- `cbUser`: the cashier, a string or a number of up to 32 characters.
- `cbTerminalID`: the register number, up to 8 characters.

Without these fields, the register prints its defaults (`#001 KIEROWNIK`).

### Limits and error handling

- Values that the register cannot print, for example a `cbTerminalID` with more than 8 characters or a barcode with more than 30 characters, are rejected with a validation error that names the field, before anything is printed. Send values within the limits.
- The register prints at most 60 lines after a receipt: the footer lines, the lines for the whole receipt and the lines of all payment receipts together. A receipt with more lines is rejected before anything is printed.
- The additional lines are printed after the register has closed the fiscal receipt. If printing them fails, for example because the connection to the register is lost, the receipt is still issued: the response is successful and carries a signature with the caption `Dodatkowe linie nie wydrukowane`, whose text ends with "The fiscal receipt was issued: do not send it again." Do not send such a receipt again; it would be issued a second time.

### Example

A sale paid by debit card, with a payment receipt, footer lines, information lines, a barcode, the cashier and the register number:

```json
{
  "ftCashBoxID": "<cashbox-id>",
  "cbTerminalID": "02",
  "cbUser": "238689",
  "cbReceiptReference": "20260930004000200016",
  "cbReceiptMoment": "2026-09-30T12:49:11Z",
  "ftReceiptCase": 5786034805636333569,
  "Currency": "PLN",
  "cbChargeItems": [
    {
      "Quantity": 1,
      "Description": "Inne produkty",
      "Amount": 100.00,
      "VATRate": 23,
      "ftChargeItemCase": 5786034805636333571,
      "Currency": "PLN"
    }
  ],
  "cbPayItems": [
    {
      "Quantity": 1,
      "Description": "Mastercard",
      "Amount": 100.00,
      "ftPayItemCase": 5786034805636333572,
      "Currency": "PLN",
      "ftPayItemCaseData": {
        "cbPayItemLines": [
          "|--------------------------------------|",
          "|CARDHOLDER COPY                       |",
          "|Card                          ****9999|",
          "|Auth. code                        1234|",
          "|TOTAL                       PLN 100.00|",
          "|APPROVED                              |",
          "|--------------------------------------|"
        ]
      }
    }
  ],
  "cbReceiptAmount": 100.00,
  "ftReceiptCaseData": {
    "PL": {
      "printout": {
        "barcode": "20260930004000200016",
        "lines": [
          { "label": "itemCount", "text": "1" },
          { "label": "transactionNumber", "text": "16" },
          { "text": "" },
          { "text": "Otrzymano Mastercard 100,00", "align": "left" },
          { "text": "Zwrot towaru do dnia: 2026-10-30", "align": "left" }
        ],
        "infoLines": [
          "Zwrot lub wymiana nieużywanego towaru",
          "wraz z metką na podstawie paragonu",
          "w ciągu 30 dni. Nie dotyczy kosmetyków."
        ],
        "infoLinesAlign": "center"
      }
    }
  }
}
```

`5786034805636333569` is `ftReceiptCase` `0x504C_2000_0000_0001` (POS receipt), `5786034805636333571` is `ftChargeItemCase` `0x504C_2000_0000_0013` (normal VAT rate of 23%), and `5786034805636333572` is `ftPayItemCase` `0x504C_2000_0000_0004` (debit card payment).
