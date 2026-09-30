---
slug: /poscreators/middleware-doc/austria/data-structures
title: Data Structures
---

# Data Structures

This chapter expands more on describing the data structures covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with country-specific information applicable to the Austrian market.

## Receipt Request

There are no special requirements or laws for the Austrian market.

## cbCustomer

This section describes how the Middleware processes `cbCustomer` for the Austrian market. For the structure and all of its fields, see [cbCustomer](../../general/data-structures/data-structures.md#cbcustomer) in the General Part.

`cbCustomer` is only read for [eInvoicing](../e-invoicing/setup.md), where it carries the buyer's master data of a B2B invoice. The column **Read by** lists the components of the Middleware that use the field.

| Field Name        | Read by | Description |
|-------------------|---------|-------------|
| `CustomerVATId`   | eInvoicing | VAT ID of the buyer. |
| `CustomerName`    | eInvoicing | Name or company name of the buyer. |
| `CustomerStreet`  | eInvoicing | Street of the buyer's address. |
| `CustomerZip`     | eInvoicing | Postal code of the buyer's address. |
| `CustomerCity`    | eInvoicing | City of the buyer's address. |
| `CustomerCountry` | eInvoicing | Country of the buyer. |

*Table 1. cbCustomer fields read by the Middleware for the Austrian market.*

## Receipt Response

This table describes additional fields of the Receipt Response applicable to the Austrian market.

| **Field name**            | **Data type** | **Default Value Mandatory Field** | **Description**                                                                                         | **Version** |
|---------------------------|---------------|-----------------------------------|---------------------------------------------------------------------------------------------------------|-------------|
| `ftCashBoxIdentification` | `string`      | mandatory                         | Cash register identification number in accordance with the RKSV.                                        | 0-          |
| `ftReceiptIdentification` | `string`      | mandatory                         | Upcounting receipt number allocated through fiskaltrust.SecurityMechanisms in accordance with the RKSV. | 0-          |

*Table 2. Receipt Response (AT - RKSVO)*

## Charge Items Entry

This entry determines which counter will be used to sum up the value of the sales tax field (normal, discounted-1, discounted-2, zero or special) for the individual services. It is required for signature creation.

This table describes additional fields of the Charge Items Entry applicable to the Austrian market.

| **Field Name** | **Data Type** | **Default Value Mandatory Field** | **Description**                                                                                        | **Version** |
|----------------|---------------|-----------------------------------|--------------------------------------------------------------------------------------------------------|-------------|
| `Description`  | `string`      | empty-string<br />mandatory       | Name, description of customary indication, or type of the service or item in accordance with the RKSV. | 0-          |

*Table 3. Charge Items Entry (ftChargeItems) (AT - RKSVO)*

## Pay Items Entry

There are no special requirements or laws for the Austrian market.

## Signature Entry

The Signature Entry for Austrian market may contain a FinanzOnline notification, which can be sent back depending on the operating mode. This is in particular the case for receipts with special functions.

| **Field Name**      | **Data Type** | **Default Value**<br />**Mandatory Field** | **Description**                                                                                                                                                                       | **Version** |
|---------------------|---------------|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `ftSignatureFormat` | `Int64`       | 0<br />mandatory                           | Format for displaying signature data according to the reference table in the appendix.                                                        | 0-          |
| `ftSignatureType`   | `Int64`       | 0<br />mandatory                           | Type of signature according to the reference table in the appendix, for example signature according to the RKSV or FinanzOnline notification. | 0-          |

*Table 4. Signature Entry (AT - RKSVO)*
