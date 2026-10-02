---
slug: /poscreators/middleware-doc/italy/data-structures
title: Data Structures
description: Receipt request fields needing special handling in Italy, such as cbTerminalID, cbReceiptReference and cbCustomer customer data.
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

*Table 2. `cbCustomer` fields with rules specific to the Italian market.*

:::caution The codice fiscale moved from `CustomerId` to `CustomerTaxId`

Up to version 1.3.88 the codice fiscale was sent in `CustomerId`. It now belongs in `CustomerTaxId`; `CustomerId` is still accepted, but it is no longer read.

Each field takes one kind of identifier only. A legal entity that uses its partita IVA as codice fiscale has to send it in `CustomerVATId`: a partita IVA in `CustomerTaxId` is rejected, and so is a codice fiscale in `CustomerVATId`.

:::

:::note The lottery code is not part of `cbCustomer`

The *codice lotteria* is sent in `ftReceiptCaseData`, as `{"servizi_lotteriadegliscontrini_gov_it":{"codicelotteria":"XXXXXXXX"}}`, and not in `cbCustomer`. On the *Documento Commerciale*, an identified customer and the lottery data are mutually exclusive: when the customer is identified, the lottery data is omitted.

:::
