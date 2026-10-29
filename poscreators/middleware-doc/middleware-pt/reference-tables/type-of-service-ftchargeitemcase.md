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

`VATRate` must match the rate of the VAT value. The Middleware accepts only the rates listed in Table 1; the regional rates of Madeira and the Azores are not supported.

| **Value** | **Description** | **SAF-T `TaxType` / `TaxCode`** |
| --------- | --------------- | ------------------------------- |
| `0` | **Unknown VAT rate**<br />Not supported in Portugal; rejected. | – |
| `1` | **Discounted-1 VAT rate**<br />Reduced rate (*taxa reduzida*), 6 %. | `IVA` / `RED` |
| `2` | **Discounted-2 VAT rate**<br />Intermediate rate (*taxa intermédia*), 13 %. | `IVA` / `INT` |
| `3` | **Normal VAT rate**<br />Normal rate (*taxa normal*), 23 %. | `IVA` / `NOR` |
| `4` | **Super reduced 1 VAT rate**<br />Not supported in Portugal; rejected. | – |
| `5` | **Super reduced 2 VAT rate**<br />Not supported in Portugal; rejected. | – |
| `6` | **Parking VAT rate**<br />Not supported in Portugal; rejected. | – |
| `7` | **Zero VAT rate**<br />0 %, exempt. Requires a tax exemption code in `ftChargeItemCaseData.PT.TaxExemptionCode`. For more information, see [Tax exemption code in ftChargeItemCaseData](#tax-exemption-code-in-ftchargeitemcasedata). | `IVA` / `ISE` (*Isenta*, exempt) |
| `8` | **Not Taxable**<br />0 %. Not subject to VAT (*não sujeito*). If `NN` is set, the line is exempt instead; see [NN - nature of VAT](#nn---nature-of-vat). | `NS` / `NS` (not subject to VAT or Stamp Duty) |

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
| `6` | **Not own sales / Agency business**<br />Not supported in Portugal; rejected with `EEEE_UnsupportedChargeItemServiceType`. | 1.3.45 |
| `7` | **Own Consumption** | 1.3.45 |
| `8` | **Grant**<br />For Unreal Grant use V=0 to 7<br />For Real Grant use V=8  |1.3.45| 
| `9` | **Receivable**<br />Receivable creation is negative (-) amount<br />Receivable reduction is positive (+) amount.<br />IsVoid can be applied to reverse amounts.<br />Avoid to use this, use PayItem instead.  |1.3.45|   
| `A` | **Cash Transfer**<br />Cash Transfer to till is positive (+) amount<br />Cash Transfer from till is negative (-) amount.<br />Only useable with V=8, Not Taxable. <br />IsVoid can be applied to reverse amounts|1.3.45|    

*Table 2. Type of Service (S) values of ftChargeItemCase for Portugal.*

#### NN - nature of VAT

Use `00` for charge items with VAT.

Whenever `NN` is set to a value other than `00`, the charge item is exempt and the VAT rate (`V`) is ignored: the line is reported with the tax type `IVA` and the tax code `ISE` (*Isenta*, exempt), whatever `V` is. This also applies to `V` = `8`. `VATRate` must be `0`; a charge item with a VAT rate other than 0 % and an `NN` other than `00` is rejected.

The individual values of `NN` for exempt charge items are not yet specified for Portugal. Send the tax exemption code of an exempt charge item in `ftChargeItemCaseData`, as described in the next section.

#### Tax exemption code in ftChargeItemCaseData

An exempt charge item needs a tax exemption code (*motivo de isenção*). Send it in `ftChargeItemCaseData.PT.TaxExemptionCode` and use the zero VAT rate (`V` = `7`) in `ftChargeItemCase`. The Middleware writes the code to `TaxExemptionCode` and the mention to `TaxExemptionReason` of the SAF-T (PT) line, and reports the line with the tax type `IVA` and the tax code `ISE` (*Isenta*, exempt).

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

- `TaxExemptionCode` must be one of the exemption codes in Table 3, for example `M06`. Upper and lower case and surrounding spaces are ignored. An unknown code is rejected.
- `TaxExemptionCode` is only allowed on charge items with 0 % VAT, and `V` must be `7` (Zero VAT rate). Any other `V`, including `8` (Not Taxable), is rejected.
- `NN` is not evaluated and can be `00`.
- The mention (`TaxExemptionReason`) is always taken from Table 3 and cannot be sent in the request.
- A refund must repeat the `ftChargeItemCaseData` of the original charge item.

| **Exemption code** | **Mention (`TaxExemptionReason`)** | **Legal basis** |
| ------------------ | ---------------------------------- | --------------- |
| `M01` | Artigo 16.º, n.º 6 do CIVA | Artigo 16.º, n.º 6, alíneas a) a d) do CIVA |
| `M02` | Artigo 6.º do Decreto-Lei n.º 198/90, de 19 de junho | Artigo 6.º do Decreto-Lei n.º 198/90, de 19 de junho |
| `M04` | Isento artigo 13.º do CIVA | Artigo 13.º do CIVA |
| `M05` | Isento artigo 14.º do CIVA | Artigo 14.º do CIVA |
| `M06` | Isento artigo 15.º do CIVA | Artigo 15.º do CIVA |
| `M07` | Isento artigo 9.º do CIVA | Artigo 9.º do CIVA |
| `M09` | IVA - não confere direito a dedução | Artigo 62.º alínea b) do CIVA |
| `M10` | IVA – regime de isenção | Artigo 57.º do CIVA |
| `M11` | Regime particular do tabaco | Decreto-Lei n.º 346/85, de 23 de agosto |
| `M12` | Regime da margem de lucro – Agências de viagens | Decreto-Lei n.º 221/85, de 3 de julho |
| `M13` | Regime da margem de lucro – Bens em segunda mão | Decreto-Lei n.º 199/96, de 18 de outubro |
| `M14` | Regime da margem de lucro – Objetos de arte | Decreto-Lei n.º 199/96, de 18 de outubro |
| `M15` | Regime da margem de lucro – Objetos de coleção e antiguidades | Decreto-Lei n.º 199/96, de 18 de outubro |
| `M16` | Isento artigo 14.º do RITI | Artigo 14.º do RITI |
| `M19` | Outras isenções | Isenções temporárias determinadas em diploma próprio |
| `M20` | IVA - regime forfetário | Artigo 59.º-D n.º 2 do CIVA |
| `M21` | IVA – não confere direito à dedução (ou expressão similar) | Artigo 72.º n.º 4 do CIVA |
| `M25` | Mercadorias à consignação | Artigo 38.º n.º 1 alínea a) do CIVA |
| `M26` | Isenção de IVA com direito à dedução no cabaz alimentar | Lei n.º 17/2023, de 14 de abril |
| `M30` | IVA - autoliquidação | Artigo 2.º n.º 1 alínea i) do CIVA |
| `M31` | IVA - autoliquidação | Artigo 2.º n.º 1 alínea j) do CIVA |
| `M32` | IVA - autoliquidação | Artigo 2.º n.º 1 alínea l) do CIVA |
| `M33` | IVA - autoliquidação | Artigo 2.º n.º 1 alínea m) do CIVA |
| `M34` | IVA - autoliquidação | Artigo 2.º n.º 1 alínea n) do CIVA |
| `M40` | IVA - autoliquidação | Artigo 6.º n.º 6 alínea a) do CIVA, a contrário |
| `M41` | IVA - autoliquidação | Artigo 8.º n.º 3 do RITI |
| `M42` | IVA - autoliquidação | Decreto-Lei n.º 21/2007, de 29 de janeiro |
| `M43` | IVA - autoliquidação | Decreto-Lei n.º 362/99, de 16 de setembro |
| `M44` | IVA – Regras específicas - artigo 6.º | Artigo 6.º do CIVA |
| `M45` | IVA – regime transfronteiriço de isenção | Artigo 58.º-A do CIVA |
| `M46` | IVA – e-TaxFree | Decreto-Lei n.º 19/2017, de 14 de fevereiro |
| `M99` | Não sujeito ou não tributado | Outras situações de não liquidação do imposto |

*Table 3. Tax exemption codes for ftChargeItemCaseData.PT.TaxExemptionCode.*

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
