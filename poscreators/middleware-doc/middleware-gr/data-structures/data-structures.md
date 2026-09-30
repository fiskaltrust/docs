---
slug: /poscreators/middleware-doc/greece/data-structures
title: Data Structures
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Greek market.

## cbCustomer

This section describes how the Middleware processes `cbCustomer` for the Greek market. For the structure and all of its fields, see [cbCustomer](../../general/data-structures/data-structures.md#cbcustomer) in the General Part.

- The customer is transmitted to myDATA as the counterpart of the document. Without `cbCustomer`, no counterpart is transmitted and the customer is treated as domestic.
- `cbCustomer` is required for myDATA document types that need customer information, such as invoices.

The column **Read by** lists the components of the Middleware that use the field.

| Field Name            | Read by | Description |
|-----------------------|-----|-------------|
| `CustomerCountry`     | myDATA counterpart, myDATA document type and income classification | Determines whether the customer is domestic (`GR`, `EL` or empty), from another EU country or from a third country. This category also determines the myDATA document type and income classification. The counterpart is only transmitted when the country code is valid. |
| `CustomerVATId`       | myDATA counterpart | VAT number of the counterpart. |
| `CustomerName`        | myDATA counterpart | Name of the counterpart. Only transmitted for customers outside Greece or when the receipt carries transport information. |
| `CustomerStreet`      | myDATA counterpart | Street of the counterpart's address. |
| `CustomerHouseNumber` | myDATA counterpart | House number of the counterpart's address. When the receipt carries transport information and no house number is given, `0` is transmitted. |
| `CustomerZip`         | myDATA counterpart | Postal code of the counterpart's address. The address is only transmitted when both `CustomerZip` and `CustomerCity` are set. |
| `CustomerCity`        | myDATA counterpart | City of the counterpart's address. The address is only transmitted when both `CustomerZip` and `CustomerCity` are set. |

*Table 1. cbCustomer fields read by the Middleware for the Greek market.*
