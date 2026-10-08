---
slug: /poscreators/middleware-doc/general/data-structures
title: Data Structures
description: Field reference for ReceiptRequest, cbCustomer, ReceiptResponse, ChargeItem, PayItem and SignatureItem used with fiskaltrust.Middleware.
tags: [Data Structures, ReceiptRequest, ReceiptResponse, cbCustomer, Middleware]
---

# Data Structures

This chapter outlines several data structures, which are used in the communication with the fiskaltrust.Middleware.

The following conventions apply to all tables in this chapter:

- Field names are the JSON property names and are case-sensitive.
- Fields marked with `*` are required and are always serialized, even when they hold their default value. All other fields are optional and are omitted from the JSON payload when they are `null`. Optional numeric fields are also omitted when they hold their default value (for example `Position` with the value **0**). Collections that are initialized by the Middleware, such as `ftSignatures`, are always serialized, even when they are empty.
- **Nullable** indicates whether the field accepts `null`.
- Fields of type `number($decimal)` are interpreted according to the `DecimalPrecisionMultiplier` of the containing structure. See [DecimalPrecisionMultiplier](#decimalprecisionmultiplier).
- Fields of type `object` are JSON objects. See [Object fields](#object-fields).

## Object fields

Fields of type `object`, for example `ftReceiptCaseData`, `ftChargeItemCaseData`, `ftPayItemCaseData`, `cbUser`, `cbArea`, `cbSettlement` or [`cbCustomer`](#cbcustomer), are sent as [JSON objects](https://www.rfc-editor.org/rfc/rfc8259#section-4): a set of name/value pairs enclosed in curly braces. Their properties at the top level apply to all markets.

```json
"ftReceiptCaseData": {
  "<property1>": "<string value>",
  "<property2>": 123,
  "<property3>": true
}
```

### Market-specific content

Market-specific content is placed in a sub-object keyed by the two-letter ISO code of the market, for example `"DE"`. Its properties override the top-level properties for that market. Properties that exist for one market only, for example German fields, are placed in that market's sub-object only.

```json
"ftReceiptCaseData": {
  "<property>": "<value for all markets>",
  "DE": {
    "<property>": "<value for Germany>"
  }
}
```

The market-specific fields are described on the pages of each market.

## ReceiptRequest

The cash register transfers the data of an entire receipt request to **fiskaltrust.Middleware** using the `ReceiptRequest` data structure. The details of the fields supported by this structure are outlined in the following table.

The `ftReceiptCase` **fiskaltrust** field is of critical importance for the correct processing of the receipt. This field defines the receipt type, determines whether the receipt must be secured according to national law, and specifies how to calculate the correct values for each national counter.

| Field Name              | Data Type                 | Default Value     | Nullable    | Description                                                                                                                                               |
|-------------------------|---------------------------|-------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cbTerminalID`          | `string`<br />Max 1023    | null              | true        | Optional unique identification of the input-station/terminal within a cash-register/pos-system identified by `ftCashBoxID`. |
| `cbReceiptReference*`   | `string`<br />Max 1023    | -                 | false       | The reference number sent by the cash register. This value must be a unique string/receipt number related to the calling cash register. This string/receipt number is a unique primary key for the cash register's dataset. |
| `cbReceiptMoment*`      | `string($date-time)`      | -                 | false       | The moment at which the receipt was created by the cash register. It must be provided in UTC. Example: 2020-06-29T17:45:40.505Z. |
| `cbChargeItems*`        | `ChargeItem[]`            | -                 | false       | List of line items related to services and products. See [ChargeItem](#chargeitem). |
| `cbPayItems*`           | `PayItem[]`               | -                 | false       | List of line items related to payments. See [PayItem](#payitem). |
| `ftCashBoxID`           | `string($uuid)`           | null              | true        | Identification of the cash register. |
| `ftPosSystemId`         | `string($uuid)`           | null              | true        | Identification of the used software of the cash register. |
| `ftReceiptCase*`        | `integer($uint64)`        | 0                 | false       | Type of business according to **fiskaltrust** reference. For more information, see [ftReceiptCase](../../general/reference-tables/reference-tables.md#type-of-receipt-ftreceiptcase). This field is relevant for **fiskaltrust.middleware** processing and represents a country-specific mapping. |
| `ftReceiptCaseData`     | `object`                  | null              | true        | This optional field provides additional details for the defined type of business, as referenced by **fiskaltrust**. |
| `ftQueueID`             | `string($uuid)`           | null              | true        | Optional routing instruction used to identify a specific queue behind a load balancer or in other use cases. |
| `cbPreviousReceiptReference` | `string`<br />Max 1023<br />or `string[]` | null | true    | Optional reference to the `cbReceiptReference` of one or more previous receipts. This is used to connect multiple requests within a single Business Case. Either a single string or an array of strings can be provided. In voids, refunds, partial refunds and exchanges, this field references an original receipt that was processed by the same queue; original receipts from other devices or systems and unreferenced refunds are described in [Refunds and Voids](../cash-register-integration/refunds-and-voids.md#referenced-and-unreferenced-refunds). |
| `cbReceiptAmount`       | `number($decimal)`        | null              | true        | Optional total receipt amount, including value added taxes (i.e., gross receipt amount). This field is provided to prevent calculation and rounding differences. Systems that use net amounts as the central calculation should always use this property. If not provided, the sum of amount in all provided `cbChargeItems` is used as total receipt amount. |
| `cbUser`                | `object`                  | null              | true        | Optional Identification of the user who creates the receipt. |
| `cbArea`                | `object`                  | null              | true        | Optional Identification of the area, section, or field in which the receipt is created. Examples include table number of a restaurant business, a department of a commercial establishment, or the vehicle of a taxi company. |
| `cbCustomer`            | `object`                  | null              | true        | Optional identification of the customer for whom the receipt is created, such as name, address and tax identification numbers. See [cbCustomer](#cbcustomer). |
| `cbSettlement`          | `object`                  | null              | true        | Optional Settlement identification indicating where this receipt will be added. Examples include a shift number or the day of operation. |
| `Currency`              | `string` (enum)           | EUR               | false       | This field is used as currency code for money numbers along [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217). Must be set if the currency is not EUR. See [Currency](#currency). Enum: [EUR, CHF, CZK, HUF, BAM, DKK, RON, NOK, PLN, RSD, SEK, UAH, USD, AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHW, CLF, CLP, CNY, COP, COU, CRC, CUP, CVE, DJF, DOP, DZD, EGP, ERN, ETB, FJD, FKP, GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HTG, IDR, ILS, INR, IQD, IRR, ISK, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PYG, QAR, RUB, RWF, SAR, SBD, SCR, SDG, SGD, SHP, SLE, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UGX, USN, UYI, UYU, UYW, UZS, VED, VES, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL] |
| `DecimalPrecisionMultiplier` | `integer($int32)`    | 1                 | false       | This field is used as a multiplier for decimal numbers. When the value is **1**, the relevant numbers are interpreted as floating-point numbers. For all other values, the relevant numbers are interpreted as integers and must be divided by the Multiplier to obtain the decimal representation. See [DecimalPrecisionMultiplier](#decimalprecisionmultiplier). Enum: [1, 100, 10000, 1000000, 100000000] |

*Table 1. Fields of the ReceiptRequest data structure sent by the cash register to the Middleware.*

### Currency

`Currency` is the [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency code of the money amounts. It is available on the `ReceiptRequest`, on each [ChargeItem](#chargeitem) and on each [PayItem](#payitem). The default is `EUR`; the field must be set if the currency is not EUR.

### DecimalPrecisionMultiplier

`DecimalPrecisionMultiplier` defines how the fields of type `number($decimal)` of the containing structure are interpreted. It is available on the `ReceiptRequest`, on each [ChargeItem](#chargeitem) and on each [PayItem](#payitem).

- With the default value `1`, these fields are floating-point numbers.
- With any other allowed value (`100`, `10000`, `1000000`, `100000000`), these fields are integers that must be divided by the multiplier to obtain the decimal representation.

## cbCustomer

The `cbCustomer` field of the `ReceiptRequest` identifies the customer (buyer) for whom the receipt is created. The Middleware reads it as a JSON object with the fields listed in the following table.

```json
{
  "cbCustomer": {
    "CustomerName": "Erika Musterfrau",
    "CustomerId": "C-10042",
    "CustomerStreet": "Rua Augusta 100",
    "CustomerZip": "1100-053",
    "CustomerCity": "Lisboa",
    "CustomerCountry": "PT",
    "CustomerVATId": "123456789",
    "CustomerTaxId": "987654321"
  }
}
```

### Why cbCustomer and its fields are optional

- **Most receipts have no identified customer.** A typical point-of-sale receipt is issued to an anonymous consumer, so `cbCustomer` is omitted.
- **Whether customer data is required depends on the market and the receipt case.** Each market enforces its own rules, for example for invoices or for receipts to business customers.
- **The same structure is shared by all markets, and each market reads a different subset of it.** Fields that a market does not read are ignored, so none of them can be required globally.

### Market-specific rules

Required fields, validations and default values differ per market. They are described on the market pages:

- [Germany](../../middleware-de-kassensichv/data-structures/data-structures.md#customer-data-cbcustomer)
- [Greece](../../middleware-gr/data-structures/data-structures.md#cbcustomer)
- [Italy](../../middleware-it-registratore-telematico/data-structures/data-structures.md#customer-data-cbcustomer)
- [Poland](../../middleware-pl/receipt-case-definitions/receipt-case-definitions.md#constraints-enforced-by-the-queue) (receipt case definitions, *Paragon z NIP*)
- [Portugal](../../middleware-pt/certification/certification.md#always-provided-by-the-fiskaltrustmiddleware) (certification page, row *Customer data*)
- [Spain](../../middleware-es/data-structures/data-structures.md#cbcustomer)

### Fields

The following table lists every field that the Middleware reads from the structure.

:::info eInvoicing
For eInvoicing-specific information on `cbCustomer`, see [Buyer data (`cbCustomer`) in eInvoicing](../../e-invoicing/cbcustomer.md) and the eInvoicing setup page of each country: [Austria](../../middleware-at-rksv/e-invoicing/setup.md), [France](../../middleware-fr-boi-tva-decla-30-10-30/e-invoicing/setup.md), [Germany](../../middleware-de-kassensichv/e-invoicing/setup.md), [Italy](../../middleware-it-registratore-telematico/e-invoicing/setup.md) and [Poland](../../middleware-pl/e-invoicing/setup.md).
:::

| Field Name            | Data Type | Default Value | Nullable | Description |
|-----------------------|-----------|---------------|----------|-------------|
| `CustomerName`        | `string`  | null          | true     | Name or company name of the customer. |
| `CustomerId`          | `string`  | null          | true     | Identification of the customer in the POS system, for example a customer number. Not an identity document number such as an ID card or passport number. |
| `CustomerStreet`      | `string`  | null          | true     | Street and house number of the customer's address. |
| `CustomerZip`         | `string`  | null          | true     | Postal code of the customer's address. |
| `CustomerCity`        | `string`  | null          | true     | City of the customer's address. |
| `CustomerCountrySubentity` | `string`  | null          | true     | Subdivision of the country in the customer's address, such as a province, state or county. |
| `CustomerCountry`     | `string`  | null          | true     | Country of the customer as ISO 3166-1 alpha-2 code, for example `DE`. |
| `CustomerVATId`       | `string`  | null          | true     | VAT or tax identification number of the customer. |
| `CustomerTaxId`       | `string`  | null          | true     | Tax identification number of the customer that is not a VAT ID. |
| `CustomerEndpointId`  | `string`  | null          | true     | Electronic address under which the customer receives documents, such as the address of the customer in a delivery network. It consists of the identification scheme and the identifier, separated by a colon (`<scheme>:<id>`). |
| `CustomerReference`   | `string`  | null          | true     | Reference that the customer assigned and asked to be stated on the document. The customer uses it to forward the document internally to the responsible department or person and to assign it in its own accounting. |

*Table 2. Fields of the cbCustomer data structure identifying the customer of a receipt.*

## ReceiptResponse

**fiskaltrust.Middleware** sends the processed data back to the cash register through the `ReceiptResponse`. The data included in the request, such as header, service, pay items, and footer, will not be sent back. The returned data is added to the receipt as supplement to the data of the receipt request.

| Field Name              | Data Type                 | Default Value     | Nullable    | Description                                                                                                                                               |
|-------------------------|---------------------------|-------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ftQueueID*`            | `string($uuid)`           | 00000000-0000-0000-0000-000000000000 | false | Identification of the queue used for processing. |
| `ftQueueItemID*`        | `string($uuid)`           | 00000000-0000-0000-0000-000000000000 | false | Identification of the item within a specific queue that is used for processing. |
| `ftQueueRow*`           | `integer($int64)`         | 0                 | false       | Row in which the item is stored within a specific queue used for processing. |
| `ftCashBoxIdentification*` | `string`<br />Max 1023 | -                 | false       | Human-readable identification or serial number of the cash register, as required by national regulations/law. This must be printed on the receipt to identify the cash register within a merchant and is unique over a single merchant.<br />**Note:** do not confuse `ftCashBoxID` with `ftCashBoxIdentification`. The `ftCashBoxID` identifies a configuration container and is used for authentication purposes. In contrast, `ftCashBoxIdentification` is the human-readable identification of the queue. |
| `ftCashBoxID*`          | `string($uuid)`           | null              | true        | Mirror from `ReceiptRequest` identification of the cash register. |
| `cbTerminalID`          | `string`<br />Max 1023    | null              | true        | Mirror from `ReceiptRequest`. Represents the unique identification of the input station or terminal within a cash-register or POS system, as identified by `ftCashBoxID`. |
| `cbReceiptReference*`   | `string`<br />Max 1023    | null              | true        | Mirror from `ReceiptRequest`. Represents the reference number sent by the cash register. This value must be a unique string/receipt number related to the calling cash register and serves as a unique primary key within the cash register's dataset. |
| `ftReceiptIdentification*` | `string`<br />Max 1023 | -                 | false       | Human-readable identification of the receipt, as required by national regulations/law and the `ftCashBoxIdentification/Queue`. This must be printed on the receipt to identify it within a merchant and cash register. This always starts with `ft`, followed by the row number of the queue in hexadecimal, then a `#`, followed by the national required or defined receipt numbering. |
| `ftReceiptMoment*`      | `string($date-time)`      | -                 | false       | The moment at which the receipt was processed by **fiskaltrust.Middleware**. It must be provided in UTC. This must be printed on the receipt at local date/time. Example: 2020-06-29T17:45:40.505Z. |
| `ftReceiptHeader`       | `string[]`                | null              | true        | Additional header lines that must be printed on the receipt. |
| `ftChargeItems`         | `ChargeItem[]`            | null              | true        | List of line items added by **fiskaltrust.Middleware** during request processing, related to services and products. These items must be printed on the receipt. See [ChargeItem](#chargeitem). |
| `ftChargeLines`         | `string[]`                | null              | true        | Additional text lines for line items related to services and products. This must be printed on the receipt. |
| `ftPayItems`            | `PayItem[]`               | null              | true        | List of line items added by **fiskaltrust.Middleware** during request processing, related to payments. These items must be printed on the receipt. See [PayItem](#payitem). |
| `ftPayLines`            | `string[]`                | null              | true        | Additional text lines for line items related to payments. This must be printed on the receipt. |
| `ftSignatures`          | `SignatureItem[]`         | []                | false       | List of signature items generated by **fiskaltrust.Middleware**. This field is always present in the response and is an empty list when no signatures were generated. This must be printed on the receipt according to given format instructions to comply with national regulations/law and to enable **fiskaltrust's** Compliance-as-a-Service. See [SignatureItem](#signatureitem). |
| `ftReceiptFooter`       | `string[]`                | null              | true        | Additional footer lines that must be printed on the receipt. |
| `ftState*`              | `integer($uint64)`        | 0                 | false       | Indicates the status of the **fiskaltrust.Middleware** according to **fiskaltrust** reference. For more information, see [ftState](../../general/reference-tables/reference-tables.md#service-status-ftstate). |
| `ftStateData`           | `object`                  | null              | true        | This optional field provides additional details for the status of **fiskaltrust.Middleware** related to **fiskaltrust** reference. |

*Table 3. Fields of the ReceiptResponse data structure returned by the Middleware to the cash register.*

## ChargeItem

Represents an item related to a service or a product that is taxable.

| Field Name              | Data Type                 | Default Value     | Nullable    | Description                                                                                                                                               |
|-------------------------|---------------------------|-------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ftChargeItemId`        | `string($uuid)`           | null              | true        | Optional. This field is used as an identifier of a `chargeitem` when reading data. |
| `Quantity*`             | `number($decimal)`        | 1                 | false       | Defines the quantity of the line item. The line items with the same Description, VATRate, and `itemprice` (=Amount/Quantity) can be accumulated for better visualization. |
| `Description*`          | `string`<br />Max 1023    | -                 | false       | Defines the description of the line item. The line items with the same Description, VATRate, and `itemprice` (=Amount/Quantity) can be accumulated for better visualization. |
| `Amount*`               | `number($decimal)`        | 0                 | false       | Defines the (total) amount of the line item. To obtain `itemprice`, the amount must be divided by quantity. |
| `VATRate*`              | `number($decimal)`        | 0                 | false       | Defines the value added tax rate as a percentage of the line item. The line items with same Description, VATRate, and `itemprice` (=Amount/Quantity) can be accumulated for better visualization. |
| `ftChargeItemCase`      | `integer($uint64)`        | 0                 | false       | Optional. Defines the type of service or product related to **fiskaltrust** reference. For more information, see [ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase). This field is relevant for **fiskaltrust.middleware** processing and represents a country-specific mapping. If not specified, the service or product delivered at the point of sale with the defined VATRate is used as a fallback. |
| `ftChargeItemCaseData`  | `object`                  | null              | true        | Optional. Provides additional details for defined type of service or product related to **fiskaltrust** reference. Sublines printed below the charge item are sent in `cbChargeItemLines`, see [Additional Lines on the Receipt](../cash-register-integration/additional-lines.md). |
| `VATAmount`             | `number($decimal)`        | null              | true        | Optional. When provided and not null, this amount is used as the total value-added tax for the line item to avoid rounding when accumulating value added taxes. The systems that use net amounts as central calculation should always use this property. |
| `Moment`                | `string($date-time)`      | null              | true        | Optional. The moment at which the service or product was ordered or delivered. It must be provided in UTC. The accumulated line items obtain the minimum (first) moment. If not provided, the `cbReceiptMoment` is used as fallback. Example: 2020-06-29T17:45:40.505Z. |
| `Position`              | `number($decimal)`        | 0                 | false       | Optional. Used to sort and group the line items for receipt visualization. The accumulated line items obtain the minimum (first) position. When grouping of multiple line items is activated with a specific instruction/flag in `ftReceiptCase`, `Position` is treated as a decimal number: the whole number represents the grouped line item, and the fractional part is used within the group. |
| `AccountNumber`         | `string`<br />Max 1023    | null              | true        | Optional account number for bookkeeping export purposes. |
| `CostCenter`            | `string`<br />Max 1023    | null              | true        | Optional cost center for cost accounting purposes. |
| `ProductGroup`          | `string`<br />Max 1023    | null              | true        | Optional product group related to line item. |
| `ProductNumber`         | `string`<br />Max 1023    | null              | true        | Optional product number related to line item. |
| `ProductBarcode`        | `string`<br />Max 1023    | null              | true        | Optional product barcode related to line item. |
| `Unit`                  | `string`<br />Max 1023    | null              | true        | Optional unit of measurement for the line item. For example, on one charging session of an electric vehicle, this would be Quantity 1 and the total amount of the session within amount. The unit of measurement could be kW for DC charging or minutes for AC charging. |
| `UnitQuantity`          | `number($decimal)`        | null              | true        | Optional. The quantity related to the unit of measurement defined in `Unit`. For example, on one charging session of an electric vehicle, this would be Quantity 1 and the total amount of the session within amount. If the unit of measurement is kW for DC charging, the `UnitQuantity` could be 65.4, indicating that the line item represents a charging session with a total amount of power of 65.4 kW. |
| `UnitPrice`             | `number($decimal)`        | null              | true        | Optional. The price related to the unit of measurement defined in `Unit`. For example, on one charging session of an electric vehicle, this would be Quantity 1 and the total amount of 30.7 of the session within amount. If the unit of measurement is kW for DC charging, the `UnitQuantity` could be 65.4 as an example, and for the given total amount the `UnitPrice` would be 0.5, indicating that the line item represents a charging session with a total amount of power of 65.4 kW with a price of 0.5 per kW. |
| `Currency`              | `string` (enum)           | EUR               | false       | This field is used as currency code for money numbers along [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217). Must be set if the currency is not EUR. See [Currency](#currency). Enum: [EUR, CHF, CZK, HUF, BAM, DKK, RON, NOK, PLN, RSD, SEK, UAH, USD, AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHW, CLF, CLP, CNY, COP, COU, CRC, CUP, CVE, DJF, DOP, DZD, EGP, ERN, ETB, FJD, FKP, GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HTG, IDR, ILS, INR, IQD, IRR, ISK, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PYG, QAR, RUB, RWF, SAR, SBD, SCR, SDG, SGD, SHP, SLE, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UGX, USN, UYI, UYU, UYW, UZS, VED, VES, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL] |
| `DecimalPrecisionMultiplier` | `integer($int32)`    | 1                 | false       | This field is used as a multiplier for decimal numbers. When the value is **1**, the relevant numbers are interpreted as floating-point numbers. For all other values, the relevant numbers are interpreted as integers and must be divided by the Multiplier to obtain the decimal representation. See [DecimalPrecisionMultiplier](#decimalprecisionmultiplier). Enum: [1, 100, 10000, 1000000, 100000000] |

*Table 4. Fields of the ChargeItem data structure representing a taxable service or product.*

## PayItem

Represents an item related to a payment.

| Field Name              | Data Type                 | Default Value     | Nullable    | Description                                                                                                                                               |
|-------------------------|---------------------------|-------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ftPayItemId`           | `string($uuid)`           | null              | true        | Optional. This field is used as an identifier of a `payitem` when reading data. |
| `Quantity`              | `number($decimal)`        | 1                 | false       | Optional. Defines the quantity of the line item. The line items with the same Description and `itemprice` (=Amount/Quantity) can be accumulated for better visualization. The field is omitted from the JSON payload when it holds the default value **1**. |
| `Description*`          | `string`<br />Max 1023    | -                 | false       | Defines the description of the line item. The line items with the same Description and `itemprice` (=Amount/Quantity) can be accumulated for better visualization. |
| `Amount*`               | `number($decimal)`        | 0                 | false       | Defines the (total) amount of the line item. |
| `ftPayItemCase`         | `integer($uint64)`        | 0                 | false       | Optional. Defines the type of payment related to **fiskaltrust** reference. For more information, see [ftPayItemCase](../../general/reference-tables/reference-tables.md#type-of-payment-ftpayitemcase). This field is relevant for **fiskaltrust.middleware** processing and represents a country-specific mapping. If not specified, the cash payment at the point of sale is used as a fallback. |
| `ftPayItemCaseData`     | `object`                  | null              | true        | Optional. Provides additional details for defined type of payment related to **fiskaltrust** reference. |
| `Moment`                | `string($date-time)`      | null              | true        | Optional. The moment at which the payment was executed. It must be provided in UTC. The accumulated line items obtain the minimum (first) moment. If not provided, the `cbReceiptMoment` is used as fallback. Example: 2020-06-29T17:45:40.505Z. |
| `Position`              | `number($decimal)`        | 0                 | false       | Optional. Used to sort and group the line items for receipt visualization. The accumulated line items obtain the minimum (first) position. When grouping of multiple line items is activated with a specific instruction/flag in `ftReceiptCase`, `Position` is treated as a decimal number: the whole number represents the grouped line item, and the fractional part is used within the group. |
| `AccountNumber`         | `string`<br />Max 1023    | null              | true        | Optional account number for bookkeeping export purposes. |
| `CostCenter`            | `string`<br />Max 1023    | null              | true        | Optional cost center for cost accounting purposes. |
| `MoneyGroup`            | `string`<br />Max 1023    | null              | true        | Optional group related to line item. |
| `MoneyNumber`           | `string`<br />Max 1023    | null              | true        | Optional number related to line item. |
| `MoneyBarcode`          | `string`<br />Max 1023    | null              | true        | Optional barcode or serial number related to line item. |
| `Currency`              | `string` (enum)           | EUR               | false       | This field is used as currency code for money numbers along [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217). Must be set if the currency is not EUR. See [Currency](#currency). Enum: [EUR, CHF, CZK, HUF, BAM, DKK, RON, NOK, PLN, RSD, SEK, UAH, USD, AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHW, CLF, CLP, CNY, COP, COU, CRC, CUP, CVE, DJF, DOP, DZD, EGP, ERN, ETB, FJD, FKP, GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HTG, IDR, ILS, INR, IQD, IRR, ISK, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PYG, QAR, RUB, RWF, SAR, SBD, SCR, SDG, SGD, SHP, SLE, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UGX, USN, UYI, UYU, UYW, UZS, VED, VES, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL] |
| `DecimalPrecisionMultiplier` | `integer($int32)`    | 1                 | false       | This field is used as a multiplier for decimal numbers. When the value is **1**, the relevant numbers are interpreted as floating-point numbers. For all other values, the relevant numbers are interpreted as integers and must be divided by the Multiplier to obtain the decimal representation. See [DecimalPrecisionMultiplier](#decimalprecisionmultiplier). Enum: [1, 100, 10000, 1000000, 100000000] |

*Table 5. Fields of the PayItem data structure representing a payment.*

## SignatureItem

The signature of the receipt must comply with national law. The signature data returned in the response must be visualized on the receipt according to the format instructions and the **fiskaltrust** reference.

The signature entries can also be used to visualize hints and messages related to the `fiskaltrust.SecurityMechanism`.

| Field Name              | Data Type                 | Default Value     | Nullable    | Description                                                                                                                                               |
|-------------------------|---------------------------|-------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ftSignatureItemId`     | `string($uuid)`           | null              | true        | Optional. This field is used as an identifier of a `signatureitem` when reading data. |
| `ftSignatureFormat*`    | `integer($uint64)`        | 0                 | false       | Format for displaying signature data according to **fiskaltrust** reference. For more information, see [ftSignatureFormat](../../general/reference-tables/reference-tables.md#format-of-signature-ftsignatureformat). |
| `ftSignatureType*`      | `integer($uint64)`        | 0                 | false       | Type of signature according to **fiskaltrust** reference. For more information, see [ftSignatureType](../../general/reference-tables/reference-tables.md#type-of-signature-ftsignaturetype). |
| `Caption`               | `string`<br />Max 1023    | null              | true        | Optional heading displayed as text above the signature data. |
| `Data*`                 | `string`<br />Max 1023    | -                 | false       | Signature content displayed in the specified format. |

*Table 6. Fields of the SignatureItem data structure describing receipt signature data.*
