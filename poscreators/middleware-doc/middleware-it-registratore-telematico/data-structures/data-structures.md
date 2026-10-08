---
slug: /poscreators/middleware-doc/italy/data-structures
title: Data Structures
description: Receipt request fields needing special handling in Italy, such as cbTerminalID, cbReceiptReference and cbCustomer customer data, and how refunds and voids reference the original receipt.
tags: [Data Structures, cbCustomer, cbReceiptReference, RT, Italy]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Italian market.

## Receipt Request

### Single fields

Fields from the receipt request that need special handling for the Italian market are listed below:

| **Field name**               | **Data type**        | **Default Value Mandatory Field**                     | **Description**                                                                                                                                                                                                                                                                                                        | **Version** |
|------------------------------|----------------------|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `cbTerminalID`               | `string (50)`        | Mandatory                                             | The unique identification of the input station/cash register/terminal within a ftCashBoxID                                                                                                                                                                                                                             | 1.3         |
| `cbUser`                     | `string (50)`        | Mandatory                                             | Name (not ID) of the user who creates the receipt.                                                                                                                                                                                                                                                                     | 1.3         |
| `cbReceiptReference`         | `string (50)`        | Mandatory | Unique Reference for the Receipt. It is used to identify the receipt as well as reference receipts that are connected, like refunds, via cbPreviousReceiptReference.                                                                                                                                                                                                                                                    | 1.3         |
| `ftPosSystemId`              | `GUID / string (36)` | Mandatory                                             | This field identifies and documents the type and software version of the POS-System sending the request. It is used to identify the used POS-System. The POS-System itself has to be created in the fiskaltrust.Portal and its ID can be implemented as a constant value by the PosCreator. | 1.3         |
| `cbPreviousReceiptReference` | `string`             | Optional                                              | Points to `cbReceiptReference` of a previous request. Used to connect requests representing a business action. E.g. split, merge or reference a receipt to be voided.                                                                                                                                                  | 1.3         |

*Table 1. Receipt request fields that need special handling for the Italian market.*


Examples of using `cbReceiptReference` and `cbPreviousReceiptReference` to connect requests representing a business action can be found in our Postman collection.

#### Customer data `cbCustomer`

The following `cbCustomer` fields have rules specific to the Italian market.

| **Field name**    | **Data type**                   | **Description**                                                                                                                                                                                                                                                                       | **Version** |
|-------------------|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `CustomerTaxId`   | `string (16)`                   | **Codice fiscale of the customer.** <br />Exactly 16 characters with a valid check character (CIN), including the omocodia substitutions. It is the identifier printed on the *scontrino parlante*. A partita IVA is not accepted here, it belongs in `CustomerVATId`.                    | 1.3.88      |
| `CustomerVATId`   | `string (11)`                   | **Partita IVA of the customer.** <br />11 digits with a valid check digit. An `IT` country prefix is accepted and stripped, any other prefix is invalid. The placeholder `00000000000` is rejected.                                                                                      | 1.3         |
| `CustomerCountrySubentity` | `string (2)`                    | **Province of the customer** (*sigla della provincia*, e.g. `RM`). <br />Read for eInvoicing only: written to the FatturaPA `Sede/Provincia`. Must be a known Italian province code and needs the address (`CustomerStreet`, `CustomerZip`, `CustomerCity`).                             | –           |
| `CustomerEndpointId` | `string`                        | **SDI routing of the customer**, as `<scheme>:<id>`: `0205:<codice destinatario>` (7 characters) or `0202:<pec>`. <br />Read for eInvoicing only; required for a B2B invoice. See [SDI routing](../e-invoicing/fatturapa-mapping.md#sdi-routing).                                        | –           |

*Table 2. `cbCustomer` fields with rules specific to the Italian market.*

:::caution The codice fiscale moved from `CustomerId` to `CustomerTaxId`

Up to version 1.3.88 the codice fiscale was sent in `CustomerId`. It now belongs in `CustomerTaxId`; `CustomerId` is still accepted, but it is no longer read.

Each field takes one kind of identifier only. A legal entity that uses its partita IVA as codice fiscale has to send it in `CustomerVATId`: a partita IVA in `CustomerTaxId` is rejected, and so is a codice fiscale in `CustomerVATId`.

:::

:::note The lottery code is not part of `cbCustomer`

The *codice lotteria* is sent in `ftReceiptCaseData`, as `{"servizi_lotteriadegliscontrini_gov_it":{"codicelotteria":"XXXXXXXX"}}`, and not in `cbCustomer`. On the *Documento Commerciale*, an identified customer and the lottery data are mutually exclusive: when the customer is identified, the lottery data is omitted.

:::

### Reference to the original receipt in refunds and voids

A refund or void references the original receipt with `cbPreviousReceiptReference`. The Middleware looks up the receipt with this `cbReceiptReference` in the same queue, ignoring receipts that were answered with an error state, and takes the Z-number, the document number and the document date of the original *Documento Commerciale* from its signatures. These values are transmitted to the RT printer or RT server together with the identification of the RT printer or RT server till connected to the queue. If no receipt in the queue matches, the request is rejected with the error `There is no item available with the given cbPreviousReceiptReference '…'`.

A receipt that was issued by another queue, another RT device or another system cannot be referenced: for Italy, `ftReceiptCaseData` does not carry reference data such as the serial number, Z-number or document number of another device. A refund or void without `cbPreviousReceiptReference` is processed as an unreferenced document, for which the Middleware transmits neutral reference values to the RT device.

## Additional lines on the RT receipt

In Italy, the *Documento Commerciale* is printed by the RT printer or RT server, not rendered by fiskaltrust. The fields described in [Additional Lines on the Receipt](../../general/cash-register-integration/additional-lines.md) are therefore handled differently: `ftChargeItemCaseData.cbChargeItemLines` is not printed, and which other options work depends on the SCU of the queue.

| Option | Epson RT Printer | Epson RT Server | Custom RT Printer | Custom RT Server |
|--------|------------------|-----------------|-------------------|------------------|
| Charge item with `Amount` or `Quantity` 0 | Text line with the `Description` | Text line with the `Description` | Item line with amount 0,00 | Item line with amount 0,00 |
| `ftReceiptCaseData.cbReceiptLines` | Trailer lines at the end of the receipt | Not printed | Not printed | Not printed |
| Grouping flag `0x0000_0000_0800_0000` in `ftReceiptCase` | Supported | Not supported | Not supported | Not supported |

*Table 3. Options for additional lines on the RT receipt, by SCU.*

### Text lines between charge items

To print a line of text between the charge items, the POS system sends a charge item with `Amount` 0 or `Quantity` 0 at the position where the text is to appear. On the Epson RT printer and the Epson RT server, such a charge item is printed as a text line with its `Description` and without quantity or amount. A text line directly after a charge item therefore works as a subline of that charge item.

The following restrictions apply:

- On the Custom RT printer and the Custom RT server, the charge item is printed as an item line with the amount 0,00. The Custom RT server shortens the description of an item line to 20 characters.
- In refund and void receipts, every charge item is printed as a refund or void line, also on the Epson RT printer. A charge item with `Amount` 0 is printed as a line with the amount 0,00.

:::caution `ftChargeItemCaseData` is no longer printed
Up to version 1.3.89, the Epson RT printer SCU printed the content of `ftChargeItemCaseData` as a text line after each sale and tip item. Since version 1.3.90, `ftChargeItemCaseData` is not printed. To print text below a charge item, send a charge item with `Amount` 0 after it.
:::

### Trailer lines

On the Epson RT printer, the strings in the array `cbReceiptLines` of `ftReceiptCaseData` are printed as trailer lines at the end of the receipt, in sale, delivery note, refund and void receipts. The placeholders `{cbArea}` and `{cbUser}` in a line are replaced with the values of `cbArea` and `cbUser` of the request. `cbReceiptLines` can be sent in the same object as the lottery data:

```json
"ftReceiptCaseData": {
  "cbReceiptLines": [
    "Table {cbArea}, waiter {cbUser}",
    "Thank you for your visit"
  ],
  "servizi_lotteriadegliscontrini_gov_it": {
    "codicelotteria": "XXXXXXXX"
  }
}
```

The SCU configuration parameter `AdditionalTrailerLines` of the Epson RT printer adds trailer lines to every receipt; they are printed before the lines of `cbReceiptLines`.

### Grouping charge items

With the flag `0x0000_0000_0800_0000` in `ftReceiptCase`, the Epson RT printer groups the charge items by `Position` / 100: `Position` 100 is the main item of the first group, 101 and 102 are its sub-items, 200 is the main item of the second group, and so on. See [ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md). Within a group:

| Item | `Amount` | Printed as |
|------|----------|------------|
| Main item | Not 0 | Item line |
| Main item | 0 | Text line, for example a menu title |
| Sub-item | 0 | Text line |
| Sub-item | Positive | Surcharge on the main item if the main item has an amount; otherwise item line |
| Sub-item | Negative | Item void line |

*Table 4. How the Epson RT printer prints grouped charge items.*

A charge item with `Quantity` 0 is handled like a charge item with `Amount` 0.
