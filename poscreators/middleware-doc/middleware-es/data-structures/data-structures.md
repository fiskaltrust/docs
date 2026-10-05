---
slug: /poscreators/middleware-doc/spain/data-structures
title: Data Structures
description: Spanish rules for cbCustomer — required fields for invoices, NIF validation and TicketBAI foreign customer identification.
tags: [Spain, cbCustomer, Data Structures, TicketBAI, Middleware]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Spanish market.

## cbCustomer

- `cbCustomer` is required for invoices (`ftReceiptCase` of type invoice).
- When `cbCustomer` is sent, `CustomerName`, `CustomerStreet` and `CustomerZip` must not be empty.
- `CustomerVATId` is validated as a Spanish NIF when `CustomerCountry` is `ES` or empty.
- TicketBAI: a `CustomerCountry` other than `ES` marks a foreign customer, who is identified by `CustomerVATId` or, if it is empty, by `CustomerTaxId`.
