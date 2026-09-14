---
slug: /poscreators/middleware-doc/greece/reference-tables/ftchargeitemcase
title: 'Type of Service: ftChargeItemCase'
---

# Type of Service: ftChargeItemCase

This table expands on the values provided in the [Type of Service: ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) reference table of the Compliance Middleware with country-specific values applicable to the Greek market.

## Format
_CCCC_vlll_gggg_NNSV_

#### v - version
version 2

#### V - VAT

For more information, see [VAT rules and rates](https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm).

| **Value** | **Description**|
| --------- | -------------- | 
| `0` | **Unknown type of service for GR**<br />With the help of the VAT-rates table saved within fiskaltrust.SecurityMechanisms. |
| `1` | **Discounted-1 VAT rate** |
| `2` | **Discounted 2 VAT rate** |
| `3` | **Normal VAT rate** |
| `4` | **Super reduced 1 VAT rate** |
| `5` | **Super reduced 2 VAT rate** |
| `6` | **Parking VAT rate** |
| `7` | **Zero VAT rate** |
| `8` | **Not Taxable** |

*Table 1. VAT rate values (V) for Greece.*

#### S - Type of Service  

| **Value** | **Description** | 
| --------- | --------------- |
| `0` | **Unknown type of service**<br />With the help of the VAT-rates table saved within fiskaltrust.SecurityMechanisms. | 
| `1` | **Delivery (supply of goods)** | 
| `2` | **Other service (supply of service)** |
| `3` | **Tip**<br /> For owner use V=0 to 7, related to total amount <br /> For Employee use V=8, Not Taxable. | 1.3.67  |
| `4` | **Voucher**<br /> For Single-Use-Voucher use V=0 to 7<br />For Multi-Use-Voucher use V=8, Not Taxable<br />Voucher Sale is a positive (+) amount.<br />Voucher Redeem is a negative (-) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this for Multi-Use-Voucher, use PayItem instead, with ShowInChargeItems flag. For Single-Use-Voucher, apply the ShowInPayItems flag to visualize it similar to payment and to keep the total amount unreduced. | 
| `5` | **Catalog service** | 
| `6` | **Not own sales / Agency business** | 
| `7` | **Own Consumption** | 
| `8` | **Grant**<br />For Unreal Grant use V=0 to 7<br />For Real Grant use V=8  | 
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this, use PayItem instead.  |1.3.67|   
| `A` | **Cash Transfer**<br />Cash Transfer to till is positive (+) amount<br />Cash Transfer from till is negative (-) amount.<br />Only useable with V=8, Not Taxable. <br />IsVoid can be applied to reverse amounts|1.3.67|    

*Table 2. Type of service values (S) for Greece.*

#### NN - nature of VAT  

The `NN` byte identifies the legal reason a line is not taxed at the usual VAT rate, and drives the `vatExemptionCategory` reported to myDATA. Use it on lines that carry no VAT — that is, with the `V` nibble set to `7` (Zero VAT rate) or `8` (Not Taxable) and `VATRate` `0`. Whenever `NN` is anything other than `00`, the line is transmitted to myDATA with `vatCategory 7` (Άνευ ΦΠΑ) and `vatAmount 0`, together with the exemption category from the table below.

| **Value** | **Description** | **myDATA exemption category** |
| --------- | --------------- | ------------------------------ |
| `00` | **Usual VAT applies**<br />No exemption; the VAT rate is taken from the `V` nibble above. | — |
| `11` | Article 33: non-taxable intra-community supplies. | 14 |
| `12` | Article 29: export of goods outside the EU. | 8 |
| `13` | Article 29 par. 1(b): tax-free retail sales to non-EU citizens. | 28 |
| `14` | Article 45: reverse-charge regime — VAT payable by the recipient of goods/services, not the issuer. | 16 |
| `15` | Article 24: bottle-package recycling, ticket sales, newspapers and magazines. | 6 |
| `16` | Article 27: services in Greece such as medical/dental services, insurance, banking, and sale of a first residence. | 7 |
| `31` | Article 50: special regime for travel agencies; travel packages taxed in Greece. | 20 |
| `32` | Article 30: special customs regimes (e.g. customs warehousing, active processing). | 9 |
| `33` | Article 44: special regime for small businesses (below the €10,000 threshold). | 15 |
| `34` | Article 41: special regime for farmers. | 18 |
| `35` | Other exemption cases not covered by a more specific value below. | 27 |
| `36` | **Article 51: manufactured tobacco — VAT included (`ΦΠΑ εμπεριεχόμενος`).** Greek tobacco is sold at a state-set retail price with the VAT already collected upstream, so the retailer's line carries no separate VAT. Everyday retail for kiosks, petrol stations and supermarkets. | 21 |
| `41` | Article 52: margin scheme for taxable resellers of second-hand goods and items of artistic, collector's, or archaeological value. | 22 |
| `42` | **Article 53: sales by public auction — VAT included (`ΦΠΑ εμπεριεχόμενος`).** A margin-scheme variant of Article 52: the auctioneer selling on behalf of a principal is taxed on its margin, with the VAT embedded in the hammer price. | 23 |
| `51` | Article 54: investment gold transactions (delivery, intra-Community acquisition, import, gold-account transfers, loans and swaps). | 19 |
| `61` | Article 17: goods located outside Greece at the time of sale, and sales on boats/aircraft during intra-EU travel. | 3 |
| `62` | Article 18: services taxed outside Greece, including restaurant/catering services provided abroad and digital services to recipients abroad. | 4 |
| `63` | **Article 56: OSS non-union scheme.** A supplier established outside the EU providing services to EU consumers, declaring the VAT through a single One-Stop-Shop return instead of registering in each member state. | 29 |
| `64` | **Article 57: OSS union scheme.** An EU-established supplier making cross-border B2C sales, declaring the VAT via one One-Stop-Shop return in its home member state. | 30 |
| `65` | **Article 58: IOSS.** Distance sales of goods imported from outside the EU in consignments up to EUR 150, with the import VAT handled through the IOSS return. | 31 |
| `81` | Articles 2 & 3: transactions outside the scope of VAT (damage compensation, participation income, subsidies/grants, the Mount Athos regime). | 1 |
| `82` | Article 5: transfer of business assets — as a whole, as a branch, or as a part — for consideration or gratuitously. | 2 |
| `83` | Article 31: tax-warehouse sales. | 10 |
| `84` | Article 32: diplomatic and consular authorities, recognized international organizations, the EU, the ECB, NATO, and support for refugees/vulnerable groups and public donors. | 11 |
| `85` | **Article 32 §1(a): qualifying vessels.** Delivery and import of the vessel itself — commercial open-sea vessels, coastal fishing vessels, warships, government and salvage vessels — plus materials and equipment intended to be incorporated into or used on those vessels. Typical suppliers: shipbuilders, shipyards, vessel dealers, suppliers of onboard equipment and spare parts. | 12 |
| `86` | **Article 32 §1(γ): supply (εφοδιασμός) of qualifying vessels and aircraft.** Delivery and import of fuel, lubricants, provisions and other consumables intended for the operation of vessels and aircraft qualifying under Article 32 §1(a) and §1(b). Typical suppliers: bunker-fuel suppliers, ship chandlers, catering and provisioning companies. | 13 |
| `87` | **ΠΟΛ.1029/1995: Duty Free Shops (Καταστήματα Αφορολόγητων Ειδών).** Exemption on domestic purchases, imports and intra-EU acquisitions made by duty-free shops for goods intended for duty-free sale to eligible travellers, together with directly related services. | 25 |
| `88` | **ΠΟΛ.1167/2015: goods destined for export or another Member State.** Goods, and directly related services, supplied to a business that will subsequently export the goods or dispatch them to another Member State. Exempted up front against an exemption certificate, so the customer does not have to pay VAT and reclaim it later. | 26 |

*Table 3. NN (nature of VAT) values — the legal exemption basis and the corresponding myDATA exemption category for Greece.*

:::note VAT-included regimes

Natures `31`, `36`, `41` and `42` (myDATA categories 20, 21, 22, 23) are `ΦΠΑ εμπεριεχόμενος` — *VAT included* rather than *no VAT*. The VAT is due but embedded in the price, so it is not shown separately on the line. Send the price the customer actually pays as the charge item `Amount`.

:::

Article references above follow the current VAT Code (**ν. 5144/2024**), which renumbered the articles of the former ν. 2859/2000. The `vatExemptionCategory` numbers themselves are unchanged.

Values not listed above are not supported and are rejected by the Middleware. myDATA additionally defines categories **5** (Article 21), **17** (Article 47) and **24** (Article 8), which have no `NN` value: Article 21 governs the *time of the chargeable event* rather than an exemption, and the remaining two are not yet mapped. Where one of these is genuinely required, set it directly through `ftChargeItemCaseData.GR.mydataoverride.invoiceDetails.vatExemptionCategory`.

#### lll - local tagging/flag

Greece does not currently define local (`lll`) flags for `ftChargeItemCase`.

#### gggg - global tagging/flag 

| **Value** | **Description** | 
| --------- | --------------- | 
| `0001` | **IsVoid**<br />Marks ChargeItem as Void previous position. Quantity and amount are inverted, related to original item. | 
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as Return of good or service. Quantity and amount are inverted, related to original item. | 
| `0004` | **Discount**<br />Marks ChargeItem as Discount/Extra for previous position. <br />Positive (+) amount is extra. <br />Negative (-) amount is discount<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 1.3.67  |
| `0008` | **Downpayment**<br /> Marks ChargeItem as a downpayment.<br />Positive (+) amount is the creation of downpayment.<br />Negative (-) amount is reduction of downpayment.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 
| `0010` | **Returnable**<br /> Marks ChargeItem as a returnable.<br />Positive (+) amount/quantity is handout.<br />Negative (-) amount/quantity is reverse.<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 
| `0020` | **TakeAway** <br />Marks ChargeItem as TakeAway item to prove special VAT application | 
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. This inverts amount and does not include the amount into the visualized total amount on the receipt.  | 

*Table 4. Global tagging/flag values (gggg) for Greece.*
