---
slug: /poscreators/middleware-doc/portugal/data-structures
title: Data Structures
description: Portugal-specific data structures, including the fields in ftChargeItemCaseData, as an extension of the Data Structures chapter of the General Part.
tags: [Data Structures, Portugal, Middleware]
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Portuguese market.

## ftChargeItemCaseData

| **Field** | **Type** | **Description** |
| --------- | -------- | --------------- |
| `PT.TaxExemptionCode` | `string` | Portuguese tax exemption code of a charge item with 0 % VAT, for example `M06`. Requires the zero VAT rate (`V` = `7`) in `ftChargeItemCase`. For more information, see [Tax exemption code in ftChargeItemCaseData](../reference-tables/type-of-service-ftchargeitemcase.md#tax-exemption-code-in-ftchargeitemcasedata). |

*Table 1. Portugal-specific fields in ftChargeItemCaseData.*
