---
slug: /poscreators/middleware-doc/belgium/reference-tables/ftchargeitemcase
title: 'Type of Service: ftChargeItemCase'
---

# Type of Service: ftChargeItemCase

This table expands on the values provided in the [Type of Service: ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) reference table of the Compliance Middleware, with country-specific values applicable to the Belgian market.

## Format
_CCCC_vlll_gggg_NNSV_ 

#### v - version
version 2

#### V - VAT

For more information, see [VAT rules and rates](https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm).

Belgium uses the VAT codes defined by the FPS Finance for the fiscal data module (FDM): `A` = 21 %, `B` = 12 %, `C` = 6 %, `D` = 0 % (zero rate) and `X` = outside the scope of VAT (e.g. deposits, empties, sale of multi-purpose vouchers).

The Middleware derives the FDM VAT code from the `VATRate` of the charge item. Only the rates 21 %, 12 %, 6 % and 0 % are accepted; any other rate is rejected. A `VATRate` of 0 % is reported as `D` if the VAT part of the `ftChargeItemCase` is set to zero VAT rate (`7`), and as `X` otherwise. Set the V value so that it matches the `VATRate`, as listed below.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | **Unknown VAT rate for BE**<br />Not recommended. The FDM VAT code is derived from the `VATRate` only; a `VATRate` of 0 % is reported as `X`. | 1.3.45 |
| `1` | **Discounted-1 VAT rate**<br />6 %, FDM VAT code `C`. | 1.3.45 |
| `2` | **Discounted-2 VAT rate**<br />12 %, FDM VAT code `B`. | 1.3.45 |
| `3` | **Normal VAT rate**<br />21 %, FDM VAT code `A`. | 1.3.45 |
| `4` | **Super reduced-1 VAT rate**<br />Not applicable in Belgium. | 1.3.45 |
| `5` | **Super reduced-2 VAT rate**<br />Not applicable in Belgium. | 1.3.45 |
| `6` | **Parking VAT rate**<br />Not applicable in Belgium. | 1.3.45 |
| `7` | **Zero VAT rate**<br />0 %, FDM VAT code `D`. The `VATRate` must be 0. | 1.3.45 |
| `8` | **Not taxable**<br />Outside the scope of VAT, FDM VAT code `X`. The `VATRate` must be 0. Use it for deposits, empties (see the `Returnable` flag) and the sale of multi-purpose vouchers. | 1.3.45 |

*Table 1. ftChargeItemCase VAT rate values for the Belgian market.*


#### S - Type of Service  

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | **Unknown type of service** | 1.3.45 |
| `1` | **Delivery (supply of goods)** | 1.3.45 |
| `2` | **Other service (supply of service)** | 1.3.45 |
| `3` | **Tip**<br /> For owner use V=0 to 7, related to total amount <br /> For Employee use V=8, Not Taxable. | 1.3.45 |
| `4` | **Voucher**<br /> For Single-Use-Voucher use V=0 to 7<br />For Multi-Use-Voucher use V=8, Not Taxable (FDM VAT code `X`)<br />Voucher Sale is a positive (+) amount.<br />Voucher Redeem is a negative (-) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this for Multi-Use-Voucher, use PayItem instead, with ShowInChargeItems flag. For Single-Use-Voucher, apply the ShowInPayItems flag to visualize it similar to payment and to keep the total amount unreduced. | 1.3.45 |
| `5` | **Catalog service** | 1.3.45 |
| `6` | **Not own sales / Agency business** | 1.3.45 |
| `7` | **Own Consumption** | 1.3.45 |
| `8` | **Grant**<br />For Unreal Grant use V=0 to 7<br />For Real Grant use V=8  | 1.3.45 | 
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this, use PayItem instead. | 1.3.45 |   
| `A` | **Cash Transfer**<br />Cash Transfer to till is positive (+) amount<br />Cash Transfer from till is negative (-) amount.<br />Only useable with V=8, Not Taxable. <br />IsVoid can be applied to reverse amounts | 1.3.45 |    

*Table 2. ftChargeItemCase type-of-service values for the Belgian market.*

#### NN - nature of VAT  

The nature of VAT is not used to determine the FDM VAT code. Belgian-specific values are to be defined (TBD).

| **Value**  | **Description** | **Spec. for Belgian reg.** | **Middleware Version** |
| ---------- | --------------- | -------------------------- | ---------------------- |
| `00` | **Usual VAT applies** | | 1.3.45 |
| `10` | **Not Taxable**<br />1x can be used to specify more country specific details. | TBD | 1.3.45 |
| `20` | **Not Subject**<br />2x can be used to specify more country specific details. | TBD | 1.3.45 |
| `30` | **Exempt**<br />3x can be used to specify more country specific details. | TBD | 1.3.45 |
| `40` | **Margin scheme**<br />Do not print/show VAT rate and amount on receipt/invoice.<br />4x can be used to specify more country specific details. | TBD | 1.3.45 |
| `50` | **Reverse charge**<br />5x can be used to specify more country specific details. | TBD | 1.3.45 |
| `60` | **VAT paid in other EU country**<br />6x can be used to specify more country specific details. | TBD | 1.3.45 |
| `70` | **VAT distribution**<br />7x can be used to specify more country specific details. | TBD | 1.3.45 |
| `80` | **Excluded**<br />8x can be used to specify more country specific details. | TBD | 1.3.45 |

*Table 3. ftChargeItemCase nature-of-VAT values for the Belgian market.*


#### lll - local tagging/flag

TBD

#### gggg - global tagging/flag 

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **IsVoid**<br />Marks ChargeItem as Void previous position. Quantity and amount are inverted, related to original item. | 1.3.45 |
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as Return of good or service. Quantity and amount are inverted, related to original item. | 1.3.45 |
| `0004` | **Discount**<br />Marks ChargeItem as Discount/Extra for previous position. <br />Positive (+) amount is extra. <br />Negative (-) amount is discount<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 1.3.45 |
| `0008` | **Downpayment**<br /> Marks ChargeItem as a downpayment.<br />Positive (+) amount is the creation of downpayment.<br />Negative (-) amount is reduction of downpayment.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 1.3.45 |
| `0010` | **Returnable**<br /> Marks ChargeItem as a returnable.<br />Positive (+) amount/quantity is handout.<br />Negative (-) amount/quantity is reverse.<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 1.3.45 |
| `0020` | **TakeAway** <br />Marks ChargeItem as TakeAway item to prove special VAT application | 1.3.45 |
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. This inverts amount and does not include the amount into the visualized total amount on the receipt.  | 1.3.45 |

*Table 4. ftChargeItemCase global tagging/flag values for the Belgian market.*

## ftChargeItemCaseFlag

This table shows flags that can be added to each `ftChargeItemCase` with values applicable to the Belgian market. 
