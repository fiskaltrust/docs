---
slug: /poscreators/middleware-doc/poland/reference-tables/ftchargeitemcase
title: 'Type of Service: ftChargeItemCase'
---

# Type of Service: ftChargeItemCase

This table expands on the values provided in the [Type of Service: ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) reference table of the Compliance Middleware, with country-specific values applicable to the Polish market.

Every charge item must carry the currency `PLN` (see [Data Structures](../data-structures/data-structures.md)).

## Format
_CCCC_vlll_gggg_NNSV_ 

#### v - version
version 2

#### V - VAT

The VAT case maps to the statutory Polish VAT (PTU) rates. The register keeps its VAT rates in lettered PTU slots (A–G); **which slot letter carries which rate is owned by the register's rate table** — only the case→rate mapping below is fixed. The Middleware resolves the PTU slot for each charge item against the rate table reported by the register.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | **Unknown type of service for PL**<br />Resolved with the help of the VAT-rate table of the register. | preview |
| `1` | **Discounted-1 VAT rate**<br />Maps to the reduced rate of 8%. | preview |
| `2` | **Discounted-2 VAT rate**<br />Maps to the reduced rate of 5%. | preview |
| `3` | **Normal VAT rate**<br />Maps to the standard rate of 23%. | preview |
| `4` | **Super reduced 1 VAT rate**<br />No Polish PTU mapping; the request is rejected. | preview |
| `5` | **Super reduced 2 VAT rate**<br />No Polish PTU mapping; the request is rejected. | preview |
| `6` | **Parking VAT rate**<br />No Polish PTU mapping; the request is rejected. | preview |
| `7` | **Zero VAT rate**<br />Maps to the 0% rate. | preview |
| `8` | **Not Taxable**<br />Maps to the tax-exempt (zw.) PTU slot of the register. | preview |

#### S - Type of Service  

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | **Unknown type of service**<br />With the help of the VAT-rates table saved within fiskaltrust.SecurityMechanisms. | preview |
| `1` | **Delivery (supply of goods)** | preview |
| `2` | **Other service (supply of service)** | preview |
| `3` | **Tip** | preview |
| `4` | **Voucher**<br /> For Single-Use-Voucher use V=0 to 7<br />For Multi-Use-Voucher use V=8, Not Taxable<br />Voucher Sale is a positive (+) amount.<br />Voucher Redeem is a negative (-) amount.<br />IsVoid can be applied to reverse amounts. | preview |
| `5` | **Catalog service** | preview |
| `6` | **Not own sales / Agency business** | preview |
| `7` | **Own Consumption** | preview |
| `8` | **Grant**<br />For Unreal Grant use V=0 to 7<br />For Real Grant use V=8  | preview | 
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this, use PayItem instead. | preview |   
| `A` | **Cash Transfer**<br />Cash Transfer to till is positive (+) amount<br />Cash Transfer from till is negative (-) amount.<br />Only useable with V=8, Not Taxable. <br />IsVoid can be applied to reverse amounts | preview |    

#### NN - nature of VAT  

| **Value**  | **Description** | **Middleware Version** |
| ---------- | --------------- | ---------------------- |
| `00` | **usual VAT applies** | preview |
| `10` | **Not Taxable** | preview |
| `20` | **Not Subject** | preview |
| `30` | **Exempt**<br />In Poland, exempt items (zwolnione, "zw.") are recorded on the register's tax-exempt PTU slot. | preview |
| `40` | **Margin scheme**<br />Do not print/show VAT rate and amount on receipt/invoice. | preview |
| `50` | **Reverse charge** | preview |
| `60` | **VAT paid in other EU country** | preview |
| `80` | **Excluded** | preview |

#### lll - local tagging/flag

TBD

#### gggg - global tagging/flag 

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **IsVoid**<br />Marks ChargeItem as Void previous position. Quantity and amount are inverted, related to original item. | preview |
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as Return of good or service. Quantity and amount are inverted, related to original item.<br />In Poland, sale and return positions must not be mixed in one document. | preview |
| `0004` | **Discount**<br />Marks ChargeItem as Discount/Extra for previous position. <br />Positive (+) amount is extra. <br />Negative (-) amount is discount<br />IsVoid or IsReturn/IsRefund will invert this behavior.| preview |
| `0008` | **Downpayment**<br /> Marks ChargeItem as a downpayment.<br />Positive (+) amount is the creation of downpayment.<br />Negative (-) amount is reduction of downpayment.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | preview |
| `0010` | **Returnable**<br /> Marks ChargeItem as a returnable.<br />Positive (+) amount/quantity is handout.<br />Negative (-) amount/quantity is reverse.<br />IsVoid or IsReturn/IsRefund will invert this behavior.| preview |
| `0020` | **TakeAway** <br />Marks ChargeItem as TakeAway item to prove special VAT application | preview |
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. This inverts amount and does not include the amount into the visualized total amount on the receipt.  | preview |
