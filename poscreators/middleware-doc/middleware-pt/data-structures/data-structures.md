---
slug: /poscreators/middleware-doc/portugal/data-structures
title: Data Structures
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Portuguese market.

## cbCustomer

This section describes how the Middleware processes `cbCustomer` for the Portuguese market. For the structure and all of its fields, see [cbCustomer](../../general/data-structures/data-structures.md#cbcustomer) in the General Part.

- Without `cbCustomer`, or with `CustomerVATId` `999999990`, the receipt is issued to the final consumer (*Consumidor final*).
- `CustomerVATId` is validated as a Portuguese NIF when `CustomerCountry` is `PT` or empty.
- On a refund or a payment transfer, the customer data must match the data of the original receipt. `CustomerName`, `CustomerId`, `CustomerType`, `CustomerStreet`, `CustomerZip`, `CustomerCity`, `CustomerCountry` and `CustomerVATId` are compared.

The column **Read by** lists the components of the Middleware that use the field. The refund check also applies to payment transfers.

| Field Name        | Read by | Description |
|-------------------|-----|-------------|
| `CustomerId`      | SAF-T export, refund check | Customer ID in the SAF-T export. When empty, the Middleware derives it from `CustomerVATId`, or from `CustomerName` when `CustomerVATId` is empty or `999999990`. |
| `CustomerName`    | SAF-T export, refund check | Company name in the SAF-T export. `Desconhecido` is used when empty. |
| `CustomerVATId`   | Validation, SAF-T export, receipt signature, refund check | NIF of the customer. `999999990` identifies the final consumer and is used in the SAF-T export when empty. |
| `CustomerStreet`  | SAF-T export, refund check | Street of the customer's address. `Desconhecido` is used when empty. |
| `CustomerZip`     | SAF-T export, refund check | Postal code of the customer's address. `Desconhecido` is used when empty. |
| `CustomerCity`    | SAF-T export, refund check | City of the customer's address. `Desconhecido` is used when empty. |
| `CustomerCountry` | Validation, SAF-T export, refund check | Country of the customer. `Desconhecido` is used when empty. |
| `CustomerType`    | Refund check | Only compared between a refund or a payment transfer and the original receipt. |

*Table 1. cbCustomer fields read by the Middleware for the Portuguese market.*
