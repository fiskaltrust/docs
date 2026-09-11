---
slug: /poscreators/middleware-doc/spain/reference-tables/ftchargeitemcase
title: 'Type of Service: ftChargeItemCase'
---

# Type of Service: ftChargeItemCase

This table expands on the values provided in the [Type of Service: ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) reference table of the Compliance Middleware with country-specific values applicable to the Spanish market.

## Format
_CCCC_vlll_gggg_NNSV_

#### v - version
version 2

#### V - VAT

For more information, see [VAT rules and rates](https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm). The Middleware checks that the `VATRate` of the charge item matches the rate of the category and that the `VATAmount` matches the rate within 0.01; mismatches are rejected.

| **Value** | **Description** | **Middleware Version** |
| --------- | -------------- | ---------------------- |
| `0` | **Unknown type of service for ES**<br />Not supported in Spain; charge items with this value are rejected (`EEEE_UnsupportedVatRate`). | 1.3.81 |
| `1` | **Discounted-1 VAT rate**<br />Reduced rate (*tipo reducido*), 10 %. | 1.3.67 |
| `2` | **Discounted 2 VAT rate**<br />Reduced rate, 10 % (same rate as `1`). | 1.3.67 |
| `3` | **Normal VAT rate**<br />General rate (*tipo general*), 21 %. | 1.3.67 |
| `4` | **Super reduced 1 VAT rate**<br />Super-reduced rate (*tipo superreducido*), 4 %. | 1.3.67 |
| `5` | **Super reduced 2 VAT rate**<br />Super-reduced rate, 4 % (same rate as `4`). | 1.3.67 |
| `6` | **Parking VAT rate**<br />Not supported in Spain; charge items with this value are rejected. | 1.3.81 |
| `7` | **Zero VAT rate**<br />0 %. The nature-of-VAT segment (`NN`) must identify the exemption or not-subject reason. | 1.3.67 |
| `8` | **Not Taxable**<br />0 %. The nature-of-VAT segment (`NN`) must identify the exemption or not-subject reason. | 1.3.67 |

*Table 1. VAT rate values (V) for Spain.*


#### S - Type of Service

Only the types of service `0`, `1`, `2`, `3`, `5` and `9` are accepted by the Middleware in Spain; the other values are rejected with `EEEE_UnsupportedChargeItemServiceType`. For invoices to foreign customers the TicketBAI file distinguishes deliveries of goods (*Entrega*: `0`, `1`, `5`) from services (*PrestacionServicios*: `2`, `3`, `9`).

| **Value** | **Description** | **Middleware Version** |
| --------- | -------------- | ---------------------- |
| `0` | **Unknown type of service**<br />Handled as delivery of goods. | 1.3.67 |
| `1` | **Delivery (supply of goods)** | 1.3.67 |
| `2` | **Other service (supply of service)** | 1.3.67 |
| `3` | **Tip**<br />Handled as a service. | 1.3.67 |
| `4` | **Voucher**<br />Not supported in Spain; rejected. | 1.3.81 |
| `5` | **Catalog service**<br />Handled as delivery of goods. | 1.3.67 |
| `6` | **Not own sales / Agency business**<br />Not supported in Spain; rejected. | 1.3.81 |
| `7` | **Own Consumption**<br />Not supported in Spain; rejected. | 1.3.81 |
| `8` | **Grant**<br />Not supported in Spain; rejected. | 1.3.81 |
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />Handled as a service. | 1.3.67 |
| `A` | **Cash Transfer**<br />Not supported in Spain; rejected. | 1.3.81 |

*Table 2. Type of service values (S) for Spain.*

#### NN - nature of VAT

The nature of VAT identifies why a line carries no VAT or a special treatment. The values follow the key lists of the AEAT (VERI\*FACTU: *L8A ClaveRegimen*, *L9 CalificacionOperacion*, *L10 OperacionExenta*) and of the Basque provinces (TicketBAI: *L9 ClaveRegimenIvaOpTrascendencia*, *L10 CausaExencion*, *L11 TipoNoExenta*, *L13 Causa* of *NoSujeta*). Every 0 % line must carry one of the values below; a value that is not listed is rejected.

| **Value** | **Description** | **VERI\*FACTU record** | **TicketBAI file** | **Middleware Version** |
| --------- | -------------- | ---------------------- | ------------------ | ---------------------- |
| `00` | **Usual VAT applies** | `CalificacionOperacion` `S1`, `ClaveRegimen` `01` | *Sujeta/NoExenta*, `TipoNoExenta` `S1`, clave `01` | 1.3.67 |
| `10` | **Exempt: exports** (art. 21 LIVA) | `OperacionExenta` `E2`, `ClaveRegimen` `02` | *Sujeta/Exenta*, `CausaExencion` `E2`, clave `02` | 1.3.83 |
| `11` | **Exempt: intra-Community delivery of goods** (art. 25 LIVA) | `E5`, clave `01` | *Exenta* `E5`, clave `01` | 1.3.83 |
| `13` | **Exempt: transactions treated as exports** (art. 22 LIVA) | `E3`, clave `02` | *Exenta* `E3`, clave `02` | 1.3.83 |
| `14` | **Exempt: customs and tax-warehouse regimes** (art. 23 and 24 LIVA) | `E4`, clave `02` | *Exenta* `E4`, clave `02` | 1.3.83 |
| `20` | **Not subject: location rules** | `CalificacionOperacion` `N2`, clave `01` | *NoSujeta*, `Causa` `RL` | 1.3.67 |
| `21` | **Not subject: art. 7 and 14 LIVA and others** | `N1`, clave `01` | *NoSujeta*, `Causa` `OT` | 1.3.67 |
| `30` | **Exempt: domestic transactions** (art. 20 LIVA) | `E1`, clave `01` | *Exenta* `E1`, clave `01` | 1.3.67 |
| `31` | **Exempt: other exemptions** | `E6`, clave `01` | *Exenta* `E6`, clave `01` | 1.3.83 |
| `50` | **Reverse charge** (*inversión del sujeto pasivo*) | `CalificacionOperacion` `S2`, clave `01` | *Sujeta/NoExenta*, `TipoNoExenta` `S2`, clave `01` | 1.3.67 |
| `60` | **Not subject: foreign tax applies** (IPSI/IGIC territories or another country) | `N1`, clave `01`; the applied tax (`Impuesto`) follows the tax regime configured for the queue | *NoSujeta*, `Causa` `IE`, clave `08` | 1.3.83 |
| `80` | **Excluded: transactions on behalf of third parties** | `N1`, clave `01` | *NoSujeta*, `Causa` `VT`, clave `01` | 1.3.83 |

*Table 3. Nature of VAT values (NN) for Spain.*

The applied tax of a VERI\*FACTU record (*Impuesto*: `01` VAT, `02` IPSI for Ceuta and Melilla, `03` IGIC for the Canary Islands) is a property of the queue configuration, not of the charge item. The special regimes of *ClaveRegimen* beyond `01` (general) and `02` (exports) and the equivalence surcharge are not supported yet.

#### lll - local tagging/flag

TBD

#### gggg - global tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --------- | -------------- | ---------------------- |
| `0001` | **IsVoid**<br />Marks ChargeItem as Void previous position. Quantity and amount are inverted, related to original item. | 1.3.67 |
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as Return of good or service. Quantity and amount are inverted, related to original item. | 1.3.67 |
| `0004` | **Discount**<br />Marks ChargeItem as Discount/Extra for previous position.<br />Positive (+) amount is extra.<br />Negative (-) amount is discount<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 1.3.67 |
| `0008` | **Downpayment**<br />Marks ChargeItem as a downpayment.<br />Positive (+) amount is the creation of downpayment.<br />Negative (-) amount is reduction of downpayment.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 1.3.67 |
| `0010` | **Returnable**<br />Marks ChargeItem as a returnable.<br />Positive (+) amount/quantity is handout.<br />Negative (-) amount/quantity is reverse.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 1.3.67 |
| `0020` | **TakeAway**<br />Marks ChargeItem as TakeAway item to prove special VAT application | 1.3.67 |
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. This inverts amount and does not include the amount into the visualized total amount on the receipt. | 1.3.67 |

*Table 4. Global tagging/flag values (gggg) for Spain.*

## ftChargeItemCaseFlag

This table shows flags that can be added to each `ftChargeItemCase` with values applicable to the Spanish market.
