---
slug: /poscreators/middleware-doc/portugal/reference-tables/ftchargeitemcase
title: 'Type of Service: ftChargeItemCase'
description: ftChargeItemCase values for Portugal — VAT cases, service types, nature of VAT, and charge item flags.
tags: [Charge Item Case, Portugal, Reference Tables]
---

# Type of Service: ftChargeItemCase

This table expands on the values provided in the [Type of Service: ftChargeItemCase](../../general/reference-tables/reference-tables.md#type-of-service-ftchargeitemcase) reference table of the Compliance Middleware with country-specific values applicable to the Portuguese market.

## Format
_CCCC_vlll_gggg_NNSV_

#### v - version
version 2

#### V - VAT

For more information, see [VAT rules and rates](https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm).

| **Value** | **Description**| **Middleware Version** |
| --------- | -------------- | ---------------------- |
| `0` | **Unknown type of service for PT**<br />With the help of the VAT-rates table saved within fiskaltrust.SecurityMechanisms. | 1.3.45 |
| `1` | **Discounted-1 VAT rate**<br />(as of 1.1.2022, this is 10%). | 1.3.45 |
| `2` | **Discounted 2 VAT rate**<br />(as of 1.1.2022, this is calculated with 5%). | 1.3.45   |
| `3` | **Normal VAT rate**<br />(as of 1.1.2022, this is calculated with 22%). | 1.3.45  |
| `4` | **Super reduced 1 VAT rate**<br /> | 1.3.45 |
| `5` | **Super reduced 2 VAT rate**<br /> | 1.3.45 |
| `6` | **Parking VAT rate**<br />Reversal of tax liability. | 1.3.45 |
| `7` | **Zero VAT rate**<br />In the data, a VAT-rate can be indicated. | 1.3.45 |
| `8` | **Not Taxable**<br />For processing, see (`0x5054000000000001`) | 1.3.45 |

*Table 1. VAT (V) values of ftChargeItemCase for Portugal.*

#### S - Type of Service  

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | **Unknown type of service**<br />With the help of the VAT-rates table saved within fiskaltrust.SecurityMechanisms. | 1.3.45 |
| `1` | **Delivery (supply of goods)** | 1.3.45 |
| `2` | **Other service (supply of service)** | 1.3.45 |
| `3` | **Tip**<br /> For owner use V=0 to 7, related to total amount <br /> For Employee use V=8, Not Taxable (as of 1.1.2022, this is calculated with 5%). | 1.3.45 |
| `4` | **Voucher**<br />For Single-Use-Voucher use V=0 to 7<br />For Multi-Use-Voucher use V=8, Not Taxable<br />Voucher Sale is a positive (+) amount.<br />Voucher Redeem is a negative (-) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this for Multi-Use-Voucher, use PayItem instead, with ShowInChargeItems flag. For Single-Use-Voucher, apply the ShowInPayItems flag to visualize it similar to payment and to keep the total amount unreduced. | 1.3.45 |
| `5` | **Catalog service** | 1.3.45 |
| `6` | **Not own sales / Agency business** | 1.3.45 |
| `7` | **Own Consumption** | 1.3.45 |
| `8` | **Grant**<br />For Unreal Grant use V=0 to 7<br />For Real Grant use V=8  |1.3.45| 
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this, use PayItem instead.  |1.3.45|   
| `A` | **Cash Transfer**<br />Cash Transfer to till is positive (+) amount<br />Cash Transfer from till is negative (-) amount.<br />Only useable with V=8, Not Taxable. <br />IsVoid can be applied to reverse amounts|1.3.45|    

*Table 2. Type of Service (S) values of ftChargeItemCase for Portugal.*

#### NN - nature of VAT

In Portugal, `NN` carries the tax exemption code (*motivo de isenção*) of a charge item with 0 % VAT. Use `00` for charge items with VAT. For a charge item with 0 % VAT, set `NN` to the two digits of the exemption code from Table 3, for example `06` for M06. The Middleware writes the code to `TaxExemptionCode` and the mention to `TaxExemptionReason` of the SAF-T (PT) line. A 0 % charge item with `NN` `00` or with a value that is not listed in Table 3 is rejected.

When `NN` is set, the charge item is exempt and the VAT rate (`V`) of `ftChargeItemCase` is ignored: the line is always reported with the tax code `ISE` (*Isento*), whether `V` is `8` (Not Taxable), `7` (Zero VAT rate) or another value. `VATRate` must be `0`. A charge item with a VAT rate other than 0 % and an `NN` other than `00` is rejected.

For example, a not taxable (`V` = `8`) delivery (`S` = `1`) with the exemption code M06 has the `ftChargeItemCase` `0x5054_2000_0000_0618`.

:::warning Portugal uses its own NN values
The values in Table 3 replace the nature-of-VAT groups of the [general reference table](../../general/reference-tables/reference-tables.md#nn---nature-of-vat). For example, `30` is M30 (reverse charge) in Portugal, not "Exempt", and `10` is M10, not "Not Taxable".
:::

| **NN** | **Exemption code** | **Mention (`TaxExemptionReason`)** | **Legal basis** |
| ------ | ------------------ | ---------------------------------- | --------------- |
| `01` | M01 | Artigo 16.º, n.º 6 do CIVA | Artigo 16.º, n.º 6, alíneas a) a d) do CIVA |
| `02` | M02 | Artigo 6.º do Decreto-Lei n.º 198/90, de 19 de junho | Artigo 6.º do Decreto-Lei n.º 198/90, de 19 de junho |
| `04` | M04 | Isento artigo 13.º do CIVA | Artigo 13.º do CIVA |
| `05` | M05 | Isento artigo 14.º do CIVA | Artigo 14.º do CIVA |
| `06` | M06 | Isento artigo 15.º do CIVA | Artigo 15.º do CIVA |
| `07` | M07 | Isento artigo 9.º do CIVA | Artigo 9.º do CIVA |
| `09` | M09 | IVA - não confere direito a dedução | Artigo 62.º alínea b) do CIVA |
| `10` | M10 | IVA – regime de isenção | Artigo 57.º do CIVA |
| `11` | M11 | Regime particular do tabaco | Decreto-Lei n.º 346/85, de 23 de agosto |
| `12` | M12 | Regime da margem de lucro – Agências de viagens | Decreto-Lei n.º 221/85, de 3 de julho |
| `13` | M13 | Regime da margem de lucro – Bens em segunda mão | Decreto-Lei n.º 199/96, de 18 de outubro |
| `14` | M14 | Regime da margem de lucro – Objetos de arte | Decreto-Lei n.º 199/96, de 18 de outubro |
| `15` | M15 | Regime da margem de lucro – Objetos de coleção e antiguidades | Decreto-Lei n.º 199/96, de 18 de outubro |
| `16` | M16 | Isento artigo 14.º do RITI | Artigo 14.º do RITI |
| `19` | M19 | Outras isenções | Isenções temporárias determinadas em diploma próprio |
| `20` | M20 | IVA - regime forfetário | Artigo 59.º-D n.º 2 do CIVA |
| `21` | M21 | IVA – não confere direito à dedução (ou expressão similar) | Artigo 72.º n.º 4 do CIVA |
| `25` | M25 | Mercadorias à consignação | Artigo 38.º n.º 1 alínea a) do CIVA |
| `26` | M26 | Isenção de IVA com direito à dedução no cabaz alimentar | Lei n.º 17/2023, de 14 de abril |
| `30` | M30 | IVA - autoliquidação | Artigo 2.º n.º 1 alínea i) do CIVA |
| `31` | M31 | IVA - autoliquidação | Artigo 2.º n.º 1 alínea j) do CIVA |
| `32` | M32 | IVA - autoliquidação | Artigo 2.º n.º 1 alínea l) do CIVA |
| `33` | M33 | IVA - autoliquidação | Artigo 2.º n.º 1 alínea m) do CIVA |
| `34` | M34 | IVA - autoliquidação | Artigo 2.º n.º 1 alínea n) do CIVA |
| `40` | M40 | IVA - autoliquidação | Artigo 6.º n.º 6 alínea a) do CIVA, a contrário |
| `41` | M41 | IVA - autoliquidação | Artigo 8.º n.º 3 do RITI |
| `42` | M42 | IVA - autoliquidação | Decreto-Lei n.º 21/2007, de 29 de janeiro |
| `43` | M43 | IVA - autoliquidação | Decreto-Lei n.º 362/99, de 16 de setembro |
| `99` | M99 | Não sujeito ou não tributado | Outras situações de não liquidação do imposto |

*Table 3. Nature of VAT (NN) values of ftChargeItemCase for Portugal: tax exemption codes.*

#### Tax exemption code in ftChargeItemCaseData

Instead of encoding the exemption code in `NN`, the exemption code can be sent explicitly in `ftChargeItemCaseData.PT.TaxExemptionCode`. In this case `NN` is not needed and not evaluated: the exemption code comes from `TaxExemptionCode`, and the 0 % from the zero VAT rate (`V` = `7`).

```json
{
  "Position": 2,
  "Quantity": 1,
  "Amount": 50,
  "Description": "Transporte internacional",
  "VATRate": 0,
  "ftChargeItemCase": 5788286605450018839,
  "ftChargeItemCaseData": {
    "PT": {
      "TaxExemptionCode": "M06"
    }
  }
}
```

The `ftChargeItemCase` in this example is `0x5054_2000_0000_0017`: zero VAT rate, delivery, `NN` `00`.

The following rules apply:

- `TaxExemptionCode` takes precedence over `NN`. Without `TaxExemptionCode`, the code is read from `NN` as described above.
- `TaxExemptionCode` must be one of the exemption codes in Table 3, for example `M06`. Upper and lower case and surrounding spaces are ignored. An unknown code is rejected; the Middleware does not fall back to `NN`.
- `TaxExemptionCode` is only allowed on charge items with 0 % VAT. Because `NN` does not carry the exemption code in this case, the 0 % must be stated by the VAT rate: `V` must be `7` (Zero VAT rate). Any other `V`, including `8` (Not Taxable), is rejected. The line is reported with the tax code `ISE`.
- `NN` is not evaluated and can be `00`.
- The mention (`TaxExemptionReason`) is always taken from Table 3 and cannot be sent in the request.
- A refund must repeat the `ftChargeItemCaseData` of the original charge item.


#### lll - local tagging/flag

TBD

#### gggg - global tagging/flag 

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | **IsVoid**<br />Marks ChargeItem as Void previous position. Quantity and amount are inverted, related to original item. | 1.3.45  |
| `0002` | **IsReturn/IsRefund**<br />Marks ChargeItem as Return of good or service. Quantity and amount are inverted, related to original item. | 1.3.45 |
| `0004` | **Discount**<br />Marks ChargeItem as Discount/Extra for previous position. <br />Positive (+) amount is extra. <br />Negative (-) amount is discount<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 1.3.45  |
| `0008` | **Downpayment**<br /> Marks ChargeItem as a downpayment.<br />Positive (+) amount is the creation of downpayment.<br />Negative (-) amount is reduction of downpayment.<br />IsVoid or IsReturn/IsRefund will invert this behavior. | 1.3.45 |
| `0010` | **Returnable**<br /> Marks ChargeItem as a returnable.<br />Positive (+) amount/quantity is handout.<br />Negative (-) amount/quantity is reverse.<br />IsVoid or IsReturn/IsRefund will invert this behavior.| 1.3.45 |
| `0020` | **TakeAway** <br />Marks ChargeItem as TakeAway item to prove special VAT application | 1.3.45 |
| `8000` | **ShowInPayments**<br />Visualize the item after Total Amount. This inverts amount and does not include the amount into the visualized total amount on the receipt.  | 1.3.45 |

*Table 4. Global tagging/flag (gggg) values of ftChargeItemCase for Portugal.*

## ftChargeItemCaseFlag

This table shows flags that can be added to each `ftChargeItemCase` with values applicable to the Portuguese market. 
