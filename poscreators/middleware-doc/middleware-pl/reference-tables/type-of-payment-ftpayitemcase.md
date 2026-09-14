---
slug: /poscreators/middleware-doc/poland/reference-tables/ftpayitemcase
title: 'Type of Payment: ftPayItemCase'
---

# Type of Payment: ftPayItemCase

This table expands on the values provided in the [Type of Payment: ftPayItemCase](../../general/reference-tables/reference-tables.md#type-of-payment-ftpayitemcase) reference table of the Compliance Middleware with values applicable to the Polish market.

Every pay item must carry the currency `PLN` (see [Data Structures](../data-structures/data-structures.md)).

## Format

_CCCC_vlll_gggg_xxPP_

#### v - version
version 2

#### PP - payment type

| **Value** | **Description** | **Middleware version** |
| --- | --- | --- |
| `00` | **Unknown payment type for PL**<br />This is handled like a cash payment in national currency (PLN). | preview |
| `01` | **Cash payment**<br />cash | preview |
| `02` | **NonCash**<br />noncash | preview |
| `03` | **Crossed cheque** | preview |
| `04` | **Debit card payment** | preview |
| `05` | **Credit card payment** | preview |
| `06` | **Voucher payment (coupon) - voucher by money value** | preview |
| `07` | **Online payment**<br />noncash | preview |
| `08` | **Loyalty program Customer card payment** | preview |
| `09` | **Accounts receivable** | preview |
| `0A` | **SEPA transfer** | preview |
| `0B` | **Other Bank transfer** | preview |
| `0C` | **Transfer to Cashbook / Vault / Owner / Employee**<br />Positive (+) amount contributes to cashbox/vault. This higher the amount in cashbox/vault.<br />Negative (-) amount lowers the amount in cashbox/vault. | preview |
| `0D` | **Internal / Material consumption** | preview |
| `0E` | **Grant** | preview |
| `0F` | **Ticket Restaurant / (Sodexo, edenred, usw.)** | preview |

#### gggg - global tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --- | --- | --- |
| `0001` | **IsVoid**<br />Marks PayItem as Void previous position. Quantity and amount are inverted, related to original item. <br />IsVoid is used in cases where the exchange of money has not been executed yet. | preview |
| `0002` | **IsReturn/IsRefund**<br />Marks PayItem as Return of good or service. Quantity and amount are inverted, related to original item.<br />IsReturn/IsRefund is used in cases where the exchange of money has been executed already. | preview |
| `0004` | **(reserved)**<br /> | preview |
| `0008` | **Downpayment**<br />Marks PayItem as a downpayment. <br />Positive (+) amount is reduction of downpayment. <br/>Negative (-) amount is creation of downpayment. | preview |
| `0010` | **IsForeignCurrency**<br />The amount is still in PLN, at the moment of acceptance. ftPayItemData requires two data elements with “foreignCurrencySymbol” and “foreignCurrencyAmount” to persist data for daily closing and later bookkeeping transactions. | preview |
| `0020` | **IsChange**<br />Usually contains a negative (-) amount.<br /> (IsVoid => can be inverted) | preview |
| `0040` | **IsTip**<br />Must be a negative (-) amount to flow out of payment method.<br />ShowInChargeItems flag can be used to raise the total amount by the tip amount, to have a more convenient visualization. | preview |
| `0080` | **IsDigital/IsElectronic**<br />Electronic money, digital money | preview |
| `0100` | **IsInterface/AmountVerified**<br />Was verified by interface, automated amount transfer | preview |
| `8000` | **ShowInChargeItems**<br />Visualize the item before Total Amount. This inverts amount and does include the amount into the visualized total amount on the receipt. | preview |
