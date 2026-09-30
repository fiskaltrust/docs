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

| Field Name        | Description |
|-------------------|-------------|
| `CustomerId`      | Customer ID in the SAF-T export. When empty, the Middleware derives it from `CustomerVATId`, or from `CustomerName` when `CustomerVATId` is empty or `999999990`. |
| `CustomerName`    | Company name in the SAF-T export. `Desconhecido` is used when empty. |
| `CustomerVATId`   | NIF of the customer. `999999990` identifies the final consumer and is used in the SAF-T export when empty. |
| `CustomerStreet`  | Street of the customer's address. `Desconhecido` is used when empty. |
| `CustomerZip`     | Postal code of the customer's address. `Desconhecido` is used when empty. |
| `CustomerCity`    | City of the customer's address. `Desconhecido` is used when empty. |
| `CustomerCountry` | Country of the customer. `Desconhecido` is used when empty. |
| `CustomerType`    | Only compared between a refund or a payment transfer and the original receipt. |

*Table 1. cbCustomer fields read by the Middleware for the Portuguese market.*
