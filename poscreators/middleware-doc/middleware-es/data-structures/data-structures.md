---
slug: /poscreators/middleware-doc/spain/data-structures
title: Data Structures
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Spanish market.

## cbCustomer

- `cbCustomer` is required for invoices (`ftReceiptCase` of type invoice).
- When `cbCustomer` is sent, `CustomerName`, `CustomerStreet` and `CustomerZip` must not be empty.
- `CustomerVATId` is validated as a Spanish NIF when `CustomerCountry` is `ES` or empty.

The column **Read by** lists the components of the Middleware that use the field.

| Field Name           | Read by | Description |
|----------------------|-----|-------------|
| `CustomerCountry`    | Validation, TicketBAI | `ES` or empty marks a domestic customer, which is identified by `CustomerVATId`. Any other country marks a foreign customer (TicketBAI). |
| `CustomerVATId`      | Validation, TicketBAI | NIF of a domestic customer, or VAT ID of a foreign customer. |
| `CustomerTaxId`      | TicketBAI | TicketBAI: identification of a foreign customer when no `CustomerVATId` is given. |
| `CustomerIdentifier` | TicketBAI | TicketBAI: identification of a foreign customer when neither `CustomerVATId` nor `CustomerTaxId` is given. On a B2C invoice it is treated as a passport number, otherwise as another identification document. |

*Table 1. cbCustomer fields read by the Middleware for the Spanish market.*
