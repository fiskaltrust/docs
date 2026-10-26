---
slug: /poscreators/middleware-doc/poland/scu/posnet/receipt-elements
title: POSNET Receipt Elements
description: All elements a POSNET Online fiscal printer can print on a Polish fiscal receipt — the printer command behind each element, its options, whether it is optional, where it is printed, and whether the fiskaltrust.Middleware supports it.
tags: [POSNET, SCU, Receipt, Printout, Poland]
---

# POSNET Receipt Elements

This page lists the elements that a [POSNET](posnet.md) Online fiscal printer can print on a fiscal receipt (*paragon fiskalny*), from the top of the receipt to the bottom. For each element it shows the printer command, the options, whether the element is optional, where it is printed, and whether the fiskaltrust.Middleware supports it. The list follows the POSNET protocol specification POT-I-DEV-37, version 6403.

The fiskaltrust.Middleware sends the commands for you; a POS system never sends printer commands itself. The column *fiskaltrust.Middleware* tells you which elements you can use today and which request field controls them:

- **Supported**: the Middleware prints the element; the field that controls it is named.
- **Planned**: the element is planned and will be documented once it is tested on the devices; it is not available for integration yet.
- **Not available**: the Middleware does not print the element.

The other columns describe the printer:

- **Optional**: whether the element can be left out.
- **Position**: *fixed* means the printer decides where the element is printed; *in order* means it is printed in the order in which it is sent.
- **Set**: *per receipt* means the element is sent with every receipt; *in the printer* means it is stored in the printer once and applies to every receipt.

Support depends on the printer model and its firmware; see [Tested devices](../../data-structures/data-structures.md#tested-devices).

## Always printed

The printer always prints the following elements, as the Polish regulations require; they cannot be switched off: the header with the mandatory data of the business, the title *PARAGON FISKALNY*, the date and time, the sale lines, the VAT summary, the total (*SUMA PLN*), the payment block (*ROZLICZENIE PŁATNOŚCI*) and the fiscal footer with the document number, the register number and cashier, the signature, the fiscal logo and the unique number of the printer. A printer that is not fiscalized also prints *NIEFISKALNY*.

## Top of the receipt

| Element | Printer command | Options | Optional | Position | Set | fiskaltrust.Middleware |
|---------|-----------------|---------|----------|----------|-----|------------------------|
| Header text: company name, postal code and city (mandatory), street, house number and other data (optional), additional text | `hdrset` (`tx`) | Formatting: centred, tall, wide, underlined, italic, inverted, 4× size, bold; up to 600 bytes. The header data is also used for the JPK file. | Company name, postal code and city are mandatory | Fixed, top | In the printer | Not available |
| Header graphic (logo) | `imgheaderset` (`no`) | Graphic slot 1–500; `0` = no graphic | Yes | Fixed, top | In the printer | Not available |

*Table 1. Elements at the top of the receipt.*

## Sale lines and totals

| Element | Printer command | Options | Optional | Position | Set | fiskaltrust.Middleware |
|---------|-----------------|---------|----------|----------|-----|------------------------|
| Item name | `trline` (`na`) | Up to 80 characters | No | In order | Per receipt | Supported: `Description` of the charge item |
| Item description | `trline` (`op`) | Up to 50 characters, below the item | Yes | Below the item | Per receipt | Planned |
| Unit of measure | `trline` (`jm`) | Up to 4 characters | Yes | In the item line | Per receipt | Not available |
| Void (storno) of an item | `trline` (`st`) | | Yes | In order | Per receipt | Supported: `IsVoid` in `ftChargeItemCase`, see [Discounts and extras](../../data-structures/data-structures.md#discounts-and-extras) |
| Discount or extra on an item | `trline` (`rp`/`rw`, name `rn` up to 25 characters), `trdiscntline` | Percentage or amount | Yes | Below the item | Per receipt | Supported: charge item with the flag `Discount`, see [Discounts and extras](../../data-structures/data-structures.md#discounts-and-extras) |
| Discount or extra on the subtotal | `trdiscntsubtot` | Percentage or amount, name up to 25 characters | Yes | At the subtotal | Per receipt | Supported: charge item with the flag `Discount` without a sale line before it |
| Discount or extra on the whole receipt | `trdiscntbill` | Several per receipt | Yes | At the total | Per receipt | Not available |
| Discount in one VAT rate | `trdiscntvat` | | Yes | VAT summary | Per receipt | Not available |
| Promotion | `trdiscntpromo` | Name up to 25 characters | Yes | Below the item | Per receipt | Not available |
| Packaging and deposits | `trpack`, `trpackprnend` | Issued or returned, description up to 40 characters | Yes | Own block | Per receipt | Not available |
| Advance payment | `tradvance` | Name up to 80 characters, default *ZALICZKA* | Yes | In order | Per receipt | Not available |
| Compact VAT summary | `billtaxcompressset` | On or off | Yes | VAT summary | In the printer | Not available |
| Separator lines | `billseparatorset` | On or off | Yes | Between the blocks | In the printer | Not available |

*Table 2. Sale lines and totals.*

## Payment and buyer

| Element | Printer command | Options | Optional | Position | Set | fiskaltrust.Middleware |
|---------|-----------------|---------|----------|----------|-----|------------------------|
| Payment method | `trpayment` (`ty`, `na`) | Cash, card, cheque, voucher, credit, other, transfer; name up to 25 characters (not printed for cash); change | At least one payment | Fixed, payment block | Per receipt | Supported: pay items (`ftPayItemCase`, `Description`) |
| Payment in a foreign currency | `trpaymentcurr` | Amount, exchange rate, three-letter currency code | Yes | Payment block | Per receipt | Not available |
| Tax number of the buyer (*NIP nabywcy*) | `trnipset` (`ni`, highlighted `dw`, label `ds` up to 56 characters) | Default label *NIP NABYWCY:* | Yes | Fixed, with the footer | Per receipt | Supported: `ReceiverIsBusiness` with `CustomerVATId`, see [Receipt case definitions](../../receipt-case-definitions/receipt-case-definitions.md) |

*Table 3. Payment and buyer.*

## Footer

| Element | Printer command | Options | Optional | Position | Set | fiskaltrust.Middleware |
|---------|-----------------|---------|----------|----------|-----|------------------------|
| Cashier and register number | `ftrcfg` (`cc` up to 32, `cn` up to 8, `ca`), `login` | For the next receipt only or permanently; default *#001 KIEROWNIK* | Yes | Fixed, fiscal footer | Per receipt or in the printer | Planned |
| Additional lines | `trftrln` (`id` 0–42, `na`, `sw`, `sh`) | 40 predefined labels (for example *Nr transakcji*, *Ilość sprzedanych towarów*, *Numer klienta*), plain text, left-aligned text, small font; up to 56 characters on 80 mm paper and 40 on 57 mm paper; double width or height; up to 60 lines | Yes | After the fiscal footer, in order | Per receipt | Supported as left-aligned text: `cbReceiptLines` and payment receipts, see [Additional lines on the receipt](../../data-structures/data-structures.md#additional-lines-on-the-receipt). Labels and the other line types: Planned |
| System number | `ftrcfg` (`sn`) | Up to 30 characters, printed as a line *Nr sys.* | Yes | Fixed, footer | Per receipt | Not available |
| Information lines | `ftrcfg` (`ln`, `lb`), `ftrinfoset` (`tx`, `lb`) | Up to 3 lines, formatting as in the header | Yes | Fixed, end of the receipt, above the barcode | Per receipt or in the printer | Planned |
| Barcode | `ftrcfg` (`bc`) | Up to 30 characters | Yes | **Fixed, end of the receipt** | Per receipt | Supported: `PL.printout.barcode`, see [Barcode](../../data-structures/data-structures.md#barcode) |
| Barcode height | `barcodeheightset` (`ht`) | 2–30 mm | Yes | | In the printer | Not available |
| 2D code (QR code, Aztec, Data Matrix, PDF417) | `qrcode`, `azteccode`, `dmcode`, `pdf417code`, printed with `ftrcfg` (`bb`) | `bb`: `0` no code, `1` above the barcode, `2` below the barcode; up to 2000 bytes; dot size; error correction | Yes | **Fixed, at the barcode** | Per receipt | QR code: Supported: `PL.printout.qrCode`, see [QR code](../../data-structures/data-structures.md#qr-code); a GS1 QR code is not possible. Aztec, Data Matrix, PDF417: Not available |
| Footer graphic | `imgfooterset` (`no`) | Graphic slot 1–500; `0` = no graphic | Yes | Fixed, footer | In the printer | Not available |
| End of the receipt | `ftrcfg` (`fe`) | `0` paper feed and cut; `1` feed without cut; `2` neither; `3` neither, and the next non-fiscal printout without its header | Yes | End of the receipt | Per receipt | Not available |

*Table 4. Elements in the footer.*

## Printed by the printer or set centrally

These elements are not sent with a receipt; they are configured in the printer or centrally.

| Element | Printer command | Options | fiskaltrust.Middleware |
|---------|-----------------|---------|------------------------|
| 2D code of the document signature | `signatureprintcfgset` (`pc`) | On or off | Not available |
| QR code of the receipt lottery (*Loteria Paragonowa*) | `billlotteryconfigget` (read only) | Set centrally by the repository of the tax administration, with a minimum receipt value | Not available |
| Printing of cancelled receipts | `cancelledsaleprintcfgset` (`en`) | On or off; cancelled receipts are always stored in the printer | Not available |
| Paper saving | `papersavecfg` (`ps`) | On or off; less space between documents | Not available |
| Print density | `prnparamset` (`ps`, `px`, `sp`) | Density 1–4, extended 1–16; the THERMAL XL2 has no economy mode | Not available |

*Table 5. Elements configured in the printer or centrally.*

## Which positions can be chosen

- **Fixed by the printer**: the header and the header graphic are always at the top; the payments are in the payment block; the tax number of the buyer, the cashier and the register number are in the fiscal footer; the information lines, the barcode and the 2D code are always at the end of the receipt.
- **Chosen by the request**: the order of the sale lines and their discounts, and the order of the additional lines. For the 2D code, only whether it is printed above or below the barcode can be chosen.
- **One code of each kind**: a fiscal receipt carries at most one barcode and one 2D code. More codes can only be printed on a non-fiscal printout, which is a separate document with its own number.
- **Stored in the printer**: the header, the header graphic and the footer graphic are stored in the printer once and are not sent with a receipt. The header data is also used for the JPK file, so it is not a free text field.
