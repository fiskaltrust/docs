---
slug: /poscreators/middleware-doc/italy/data-structures
title: Data Structures
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

Customer data is sent in via the field `cbCustomer` as a **JSON string**, not as a JSON object. The POSSystem API types `cbCustomer` as a string and the Italian SCU deserializes its content, so the customer structure has to be serialized before it is placed into the request. A nested JSON object is rejected together with the whole receipt.

| **Field name**    | **Data type**                   | **Default Value Mandatory Field** | **Description**                                                                                                                                                                                                                                                                       | **Version** |
|-------------------|---------------------------------|-----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `CustomerTaxId`   | `string (16)`                   | Optional                          | **Codice fiscale of the customer.** <br />Exactly 16 characters with a valid check character (CIN), including the omocodia substitutions. It is the identifier printed on the *scontrino parlante*. A partita IVA is not accepted here, it belongs in `CustomerVATId`.                    | 1.3.88      |
| `CustomerVATId`   | `string (11)`                   | Optional                          | **Partita IVA of the customer.** <br />11 digits with a valid check digit. An `IT` country prefix is accepted and stripped, any other prefix is invalid. The placeholder `00000000000` is rejected.                                                                                      | 1.3         |
| `CustomerId`      | `string (50)`                   | Optional                          | **Customer identifier of the POS software.** <br />Carries no fiscal meaning and is not read by the Middleware for the Italian market. Up to version 1.3.88 this field carried the codice fiscale, which now belongs in `CustomerTaxId`.                                                 | 1.3         |
| `CustomerName`    | `string (50)`                   | Optional                          | **Name or company name of the customer.** <br />Printed on the invoice.                                                                                                                                                                                                                 | 1.3         |
| `CustomerStreet`  | `string (60)`                   | Optional                          | **Street and house number of the customer.** <br />Printed on the invoice.                                                                                                                                                                                                              | 1.3         |
| `CustomerZip`     | `string (10)`                   | Optional                          | **Zip of the customer.** <br />Printed on the invoice, on a single line together with `CustomerCountry` and `CustomerCity`.                                                                                                                                                              | 1.3         |
| `CustomerCity`    | `string (62)`                   | Optional                          | **City of the customer.** <br />Printed on the invoice, on a single line together with `CustomerCountry` and `CustomerZip`.                                                                                                                                                              | 1.3         |
| `CustomerCountry` | `string`                        | Optional                          | **Country of the customer.** <br />Printed on the invoice, on a single line together with `CustomerZip` and `CustomerCity`.                                                                                                                                                              | 1.3         |
| `CustomerType`    | `string (50)`                   | Optional                          | **Type of the customer** (e.g. `B2B`, `B2C`). <br />Not read by the Middleware for the Italian market: the business case is expressed through `ftReceiptCase`.                                                                                                                           | 1.3         |

*Table 2. Customer data fields sent via `cbCustomer`.*

:::caution The codice fiscale moved from `CustomerId` to `CustomerTaxId`

Up to version 1.3.88 the codice fiscale was sent in `CustomerId`. It now belongs in `CustomerTaxId`; `CustomerId` is still accepted, but it is no longer read.

Each field takes one kind of identifier only. A legal entity that uses its partita IVA as codice fiscale has to send it in `CustomerVATId`: a partita IVA in `CustomerTaxId` is rejected, and so is a codice fiscale in `CustomerVATId`.

:::

:::note The lottery code is not part of `cbCustomer`

The *codice lotteria* is sent in `ftReceiptCaseData`, as `{"servizi_lotteriadegliscontrini_gov_it":{"codicelotteria":"XXXXXXXX"}}`, and not in `cbCustomer`. On the *Documento Commerciale*, an identified customer and the lottery data are mutually exclusive: when the customer is identified, the lottery data is omitted.

:::
