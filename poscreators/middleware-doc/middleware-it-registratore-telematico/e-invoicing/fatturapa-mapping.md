---
slug: /poscreators/middleware-doc/italy/e-invoicing/fatturapa-mapping
title: FatturaPA mapping
---

# FatturaPA mapping (Italy)

This page describes how fiskaltrust turns an Italian invoice receipt into a **FatturaPA** document (format FPR12, schema 1.2.x): which receipts get one, which document types are supported, where every FatturaPA element comes from, what the fiskaltrust.Middleware returns, and which validation rules a receipt has to pass. For the supported scope (B2C and B2B, sending only), see [What fiskaltrust supports](./overview.md#what-fiskaltrust-supports); for regulatory status, see the [Overview](./overview.md); for prerequisites and the end-to-end flow, see [Setup & testing](./setup.md).

## How the mapping runs

The FatturaPA is **generated as part of `/sign`** by the fiskaltrust eInvoicing service for Italy. Its transmission to SDI is described in [Setup & testing](./setup.md#end-to-end-example).

The fiskaltrust.Middleware calls the service twice for every receipt you send to `/sign`:

1. **Validate — before fiscalization.** The service receives the `ReceiptRequest`, decides whether the receipt gets a FatturaPA, and checks it against the [validation rules](#validation-rules). A receipt that breaks a rule is **rejected and not fiscalized**: the response carries an error state and a signature naming the reason. Correct the receipt and send it again.
2. **Process — after fiscalization.** The service receives the `ReceiptRequest` and the fiscalized `ReceiptResponse`, runs the same rules again, builds the FatturaPA XML, checks the built document against the FatturaPA rules, and appends the result to `ftSignatures` (see [Output](#output)).

Everything that can be decided from the request and the merchant's account is checked in the validate step, so a receipt is rejected before a fiscal record exists.

### Transmission data

The XML is generated **unsigned**. `DatiTrasmissione` (`IdTrasmittente`, `ProgressivoInvio`), the file name and `TerzoIntermediarioOSoggettoEmittente` are completed when the document is transmitted to SDI. What the service writes in those places is a schema-valid placeholder, not a value SdI will see.

## Which receipts get a FatturaPA

| Condition | Rule | When not met |
| --- | --- | --- |
| Invoice receipt case | `ftReceiptCase` is `0x1001` (B2C) or `0x1002` (B2B). B2G (`0x1003`) is not supported. See [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md#txcc---receiptcase). | No FatturaPA; the receipt is fiscalized as usual. |
| Buyer in Italy | For a document the merchant **issues** (see [Document types](#document-types)): `cbCustomer.CustomerCountry` is empty, `IT`, or not a recognized country code. Purchase and self-issued documents apply whatever the country; their own rules decide which countries are valid. | A recognized country code other than `IT` on an issued document: no FatturaPA; the receipt is fiscalized as usual. |
| Currency | `Currency` is `EUR` or not set. | The receipt is rejected. |

*Table 1. Conditions for a FatturaPA.*

A `CustomerCountry` that is not a country code at all does not skip the FatturaPA: the receipt is rejected by the [buyer rules](#buyer) instead.

## Document types

`ftReceiptCaseData` → `IT.einvoicing.tipoDocumento` names the FatturaPA `TipoDocumento`. When it is omitted, the document is **TD04** (nota di credito) for a receipt with the **IsReturn/IsRefund** flag `0100`, and **TD01** (fattura) otherwise. The simplified format (TD07–TD09) and the retired esterometro codes (TD10–TD12) are not rendered.

The parties follow the AdE compilation guide (v1.10, *Corretto utilizzo dei codici Tipo-Documento*):

| Parties | Codes | `CedentePrestatore` | `CessionarioCommittente` | `cbCustomer` | Routing | `DatiPagamento` |
| --- | --- | --- | --- | --- | --- | --- |
| **Issued** | TD01 fattura, TD02 acconto su fattura, TD03 acconto su parcella, TD04 nota di credito, TD05 nota di debito, TD06 parcella, TD24/TD25 fattura differita, TD26 beni ammortizzabili e passaggi interni | the merchant | the buyer (`cbCustomer`, Italian) | the buyer | per receipt case | from `cbPayItems` |
| **Self-issued** | TD21 autofattura per splafonamento, TD27 autoconsumo o cessioni gratuite | the merchant | the merchant | not used | to the merchant | none |
| **Purchase** | TD16, TD17, TD18, TD19, TD20, TD22, TD23, TD28, TD29 | the **supplier** (`cbCustomer`) | the **merchant** | the supplier | to the merchant; `SoggettoEmittente` `CC` | none |

*Table 2. Parties per document type.*

A purchase document is sent as an **InvoiceB2B** (`0x1002`) receipt.

| Code | Supplier established in (SdI 00473) | `DatiFattureCollegate` | Refund receipt |
| --- | --- | --- | --- |
| TD04 | — | from `cbPreviousReceiptReference` (optional) | is the TD04 |
| TD05 | — | from `cbPreviousReceiptReference` (optional) | not allowed |
| TD26 | — | — | same code, negative amounts |
| Other issued codes, TD27 | — | — | not allowed: send a TD04 |
| TD16 reverse charge interno | Italy | **required** | same code, negative amounts |
| TD17 servizi dall'estero | abroad | **required** | same code, negative amounts |
| TD18 beni intracomunitari | another EU member state | **required** | same code, negative amounts |
| TD19 beni ex art. 17 c.2 | abroad | **required** | same code, negative amounts |
| TD20 regolarizzazione | any | optional | same code, negative amounts |
| TD21 splafonamento | — (no supplier) | — | same code, negative amounts; no 0% line (SdI 00474) |
| TD22, TD23 estrazione da deposito IVA | any | **required** | same code, negative amounts |
| TD28 San Marino con IVA | abroad | **required** | same code, negative amounts |
| TD29 omessa/irregolare fatturazione | Italy | optional | not allowed |

*Table 3. Rules per document type.*

For TD16–TD20 and TD29, the supplier's P.IVA must differ from the merchant's (SdI 00471).

A **rectification** — a refund receipt that keeps a purchase code or TD26 — keeps the quantity positive and turns the unit price, the imponibile and the imposta negative. A TD04 is always a refund receipt and carries **positive** amounts: the sign is expressed by the document type.

## Data sources

| Source | Carries |
| --- | --- |
| The merchant's **AdE connection** in fiskaltrust | The merchant: `CedentePrestatore` of what it issues, `CessionarioCommittente` of a purchase or self-issued document. The P.IVA and the *denominazione* are verified with the Agenzia delle Entrate when the merchant connects their fiskaltrust account to their AdE account from the fiskaltrust.Portal; the *regime fiscale* and the registered seat (*sede*) are configured together with that connection. |
| `cbCustomer` | The counterparty: the buyer of a sale, the supplier of a purchase document. The fields and the way the customer is sent (a serialized JSON string) are described in [Customer data `cbCustomer`](../data-structures/data-structures.md#customer-data-cbcustomer). |
| `ftReceiptCaseData` → `IT.einvoicing` | Invoice number, document type, SdI routing, *causale*, the counterparty's province, linked documents, delivery notes. |
| `cbChargeItems` | The invoice lines and the VAT summary. |
| `cbPayItems` (and `ftPayItemCaseData` → `IT.einvoicing`) | `DatiPagamento`. |
| `cbPreviousReceiptReference` | `DatiFattureCollegate` of a TD04, a TD05 or a rectification. |
| The fiscalized `ReceiptResponse` | The document date (`ftReceiptMoment`). |

*Table 4. Where the FatturaPA data comes from.*

:::warning The merchant is configured, not sent
Whose name is on an invoice is not decided by the receipt. A receipt whose `ftReceiptCaseData` carries a `cedente` is **rejected**; configure the merchant on its AdE connection instead.
:::

:::note Sandbox seller
In the sandbox, seller data the merchant's account is missing is filled with a sandbox seller (`SANDBOX MERCHANT S.R.L.`, P.IVA `00000000000`), so invoices can be rendered before the merchant has connected to AdE. Production does not do this: a receipt for an account without seller data is rejected.
:::

### The `ftReceiptCaseData` payload

```json
{
  "IT": {
    "einvoicing": {
      "numero": "2026/00042",
      "tipoDocumento": "TD01",
      "codiceDestinatario": "ABCDEFG",
      "pec": "cliente@pec.it",
      "causale": "Consulenza settembre 2026",
      "cessionario": { "provincia": "MI" },
      "fattureCollegate": [ { "idDocumento": "INV-778", "data": "2026-09-02" } ],
      "ddt": [ { "numeroDdt": "DDT-12", "dataDdt": "2026-09-10", "riferimentoNumeroLinea": [1] } ]
    }
  }
}
```

| Field | Description |
| --- | --- |
| `numero` | **Required.** The invoice number from the merchant's own progressive series (art. 21 DPR 633/72). The fiskaltrust `ftReceiptIdentification` is not used: it is a receipt counter, not a per-year series, and it collides across the cashboxes of one merchant. |
| `tipoDocumento` | The FatturaPA document type. Optional; see [Document types](#document-types). |
| `codiceDestinatario` | The SdI routing code: 7 characters for B2B. See [Routing](#routing). |
| `pec` | The recipient's certified email address. See [Routing](#routing). |
| `causale` | Free text for `Causale`. Optional. |
| `cessionario.provincia` | The counterparty's two-letter province code, since `cbCustomer` has no province field. Optional. |
| `fattureCollegate` | Documents this service did not render that the document refers to — above all the supplier's invoice a purchase code completes. Each entry has `idDocumento` and `data`. |
| `ddt` | Delivery notes, for an issued document (for example a TD24/TD25 deferred invoice). Each entry has `numeroDdt`, `dataDdt` and optionally `riferimentoNumeroLinea`. |

*Table 5. Fields of `ftReceiptCaseData` → `IT.einvoicing`.*

`ftReceiptCaseData` can be sent as a JSON object, as above, or as a JSON string holding the serialized object; the same holds for `ftPayItemCaseData`. Property names are read case-insensitively; dates are written as `yyyy-MM-dd`. A malformed date anywhere in the payload makes the whole payload unreadable: the receipt is then rejected for the number and routing it seems to lack.

### The `ftPayItemCaseData` payload

Per pay item, `ftPayItemCaseData` → `IT.einvoicing` can override the payment method and add a due date and an IBAN:

```json
{
  "Description": "Credito",
  "Amount": 1220,
  "ftPayItemCase": 5283883447184523273,
  "ftPayItemCaseData": {
    "IT": {
      "einvoicing": {
        "modalitaPagamento": "MP05",
        "dataScadenzaPagamento": "2026-10-31",
        "iban": "IT60X0542811101000000123456"
      }
    }
  }
}
```

| Field | Description |
| --- | --- |
| `modalitaPagamento` | A FatturaPA payment method code (`MP01`–`MP23`), instead of the one derived from `ftPayItemCase`. |
| `dataScadenzaPagamento` | Due date, written to `DataScadenzaPagamento`. |
| `iban` | IBAN, written to `IBAN`. Spaces are dropped. |

*Table 6. Fields of `ftPayItemCaseData` → `IT.einvoicing`.*

## Mapping

### Header — `DatiTrasmissione`

| FatturaPA element | Value |
| --- | --- |
| `IdTrasmittente/IdPaese` | `IT` — placeholder, replaced at transmission. |
| `IdTrasmittente/IdCodice` | The merchant's codice fiscale — placeholder, replaced at transmission. |
| `ProgressivoInvio` | Five base-36 characters derived from `ftQueueItemID` — placeholder, replaced at transmission. |
| `FormatoTrasmissione` | `FPR12` |
| `CodiceDestinatario` | See [Routing](#routing). |
| `PECDestinatario` | `pec`, written only when `CodiceDestinatario` is `0000000`. |

*Table 7. Mapping of `DatiTrasmissione`.*

### Routing

| Receipt | `codiceDestinatario` | `pec` | `CodiceDestinatario` in the XML |
| --- | --- | --- | --- |
| B2B `0x1002` | A 7-character channel code. A 6-character code (a public office) is rejected. | Required when there is no 7-character code. | The 7 characters, or `0000000` + `PECDestinatario`. |
| B2C `0x1001` | Omitted or `0000000`. | Optional. | `0000000`, with `PECDestinatario` when `pec` is sent. |
| Purchase and self-issued documents | When sent, the merchant's **own** 7-character code. | When sent, the merchant's own PEC. | The merchant's code; `0000000` (the merchant's *cassetto fiscale*) when neither is sent. |
| TD29 | Must not be sent. | Must not be sent. | Always `0000000`, without PEC. |

*Table 8. SdI routing.*

### Header — `CedentePrestatore` and `CessionarioCommittente`

For an **issued** document, the merchant is `CedentePrestatore` and the buyer is `CessionarioCommittente`. For a **self-issued** document, the merchant is both. For a **purchase** document, the supplier is `CedentePrestatore`, the merchant is `CessionarioCommittente`, and `SoggettoEmittente` is `CC`.

#### The merchant

| FatturaPA element | Value from the merchant's AdE connection |
| --- | --- |
| `DatiAnagrafici/IdFiscaleIVA/IdPaese` | `IT` |
| `DatiAnagrafici/IdFiscaleIVA/IdCodice` | P.IVA, 11 digits; an `IT` prefix is stripped. |
| `DatiAnagrafici/CodiceFiscale` | The merchant's codice fiscale; the P.IVA digits when none is configured. |
| `DatiAnagrafici/Anagrafica/Denominazione` | *Denominazione* |
| `DatiAnagrafici/RegimeFiscale` | *Regime fiscale*; `RF01` (regime ordinario) when none is configured. Only in `CedentePrestatore`. |
| `Sede/Indirizzo`, `Sede/CAP`, `Sede/Comune` | *Sede* `indirizzo`, `cap`, `comune` |
| `Sede/Provincia` | *Sede* `provincia`, when configured. |
| `Sede/Nazione` | *Sede* `nazione`; `IT` when none is configured. |

*Table 9. Mapping of the merchant.*

#### The buyer of an issued document

| FatturaPA element (`CessionarioCommittente`) | Value |
| --- | --- |
| `DatiAnagrafici/IdFiscaleIVA/IdPaese`, `IdCodice` | `IT` and `CustomerVATId`, the partita IVA; an `IT` prefix is stripped. Omitted when `CustomerVATId` is empty. |
| `DatiAnagrafici/CodiceFiscale` | `CustomerTaxId`, the codice fiscale, in upper case. Omitted when `CustomerTaxId` is empty. |
| `DatiAnagrafici/Anagrafica/Denominazione` | `CustomerName` |
| `Sede/Indirizzo` | `CustomerStreet` |
| `Sede/CAP` | `CustomerZip` |
| `Sede/Comune` | `CustomerCity` |
| `Sede/Provincia` | `ftReceiptCaseData` → `IT.einvoicing.cessionario.provincia`, in upper case. Omitted when not sent. |
| `Sede/Nazione` | `CustomerCountry`; `IT` when empty. |

*Table 10. Mapping of the buyer.*

The identifiers follow the Italian [`cbCustomer` fields](../data-structures/data-structures.md#customer-data-cbcustomer): the partita IVA in `CustomerVATId`, the codice fiscale in `CustomerTaxId`, each validated with the same rules. `CustomerId` is not read. A buyer may send both, and both are written. A private person (B2C) sends the codice fiscale in `CustomerTaxId` and the full name in `CustomerName`; the document uses `Denominazione`, not `Nome`/`Cognome`.

The address (`CustomerStreet`, `CustomerZip`, `CustomerCity`) is required for B2B. A B2C receipt may leave it out; the `Sede` is then filled with placeholders: `Indirizzo` `-`, `CAP` `00000`, `Comune` `-`, `Provincia` `RM`, `Nazione` `IT`.

#### The supplier of a purchase document

| FatturaPA element (`CedentePrestatore`) | Value |
| --- | --- |
| `DatiAnagrafici/IdFiscaleIVA/IdPaese` | `CustomerCountry`; `IT` when empty. Must be allowed for the document type (see [Table 3](#document-types)). |
| `DatiAnagrafici/IdFiscaleIVA/IdCodice` | `CustomerVATId`, **required**. Italian supplier: a partita IVA with a valid check digit. Foreign supplier: 1 to 28 letters or digits, the country prefix stripped (`EL` for Greece). |
| `DatiAnagrafici/Anagrafica/Denominazione` | `CustomerName`, required. |
| `DatiAnagrafici/RegimeFiscale` | `RF01` for an Italian supplier, `RF18` (altro) for a foreign one. |
| `Sede/Indirizzo`, `Sede/Comune` | `CustomerStreet`, `CustomerCity`, required. |
| `Sede/CAP` | `CustomerZip`. Italian supplier: required, 5 characters. Foreign supplier: the zip when it has 5 digits, otherwise `00000`. |
| `Sede/Provincia` | `ftReceiptCaseData` → `IT.einvoicing.cessionario.provincia`, for an Italian supplier only. |
| `Sede/Nazione` | `CustomerCountry` |

*Table 11. Mapping of the supplier.*

### Body — `DatiGeneraliDocumento`

| FatturaPA element | Value |
| --- | --- |
| `TipoDocumento` | `tipoDocumento`; otherwise `TD04` for a refund receipt and `TD01` for any other. See [Document types](#document-types). |
| `Divisa` | `EUR` |
| `Data` | Date part of `ftReceiptMoment` of the `ReceiptResponse`. |
| `Numero` | `numero` from `ftReceiptCaseData`. |
| `Causale` | `causale` from `ftReceiptCaseData`, cut to 200 characters. Omitted when not sent. |
| `ImportoTotaleDocumento` | Sum of `ImponibileImporto` + `Imposta` over all `DatiRiepilogo` blocks. |

*Table 12. Mapping of `DatiGeneraliDocumento`.*

#### Invoice numbers

A `numero` must not have been issued already for the same merchant, year and number space (SdI 00404). Credit notes (TD04) have a number space of their own, and a purchase document is numbered against its supplier, since SdI checks duplicates per `CedentePrestatore`. The validate step dates the invoice by `cbReceiptMoment`, the process step by `ftReceiptMoment`. A number is registered after its document was rendered; a retry of the same queue item does not count as a duplicate.

### Body — `DatiFattureCollegate`

Linked documents come from two sources, which can be combined on one document:

- **Documents this service rendered**, through `cbPreviousReceiptReference`. It is read only on a TD04, a TD05 or a rectification; on any other document it is the POS's own link and is ignored. Every value of `cbPreviousReceiptReference` (a single reference or a group) must be the `cbReceiptReference` of an invoice this service rendered **for the same merchant**; it becomes one `DatiFattureCollegate` with that invoice's `Numero` as `IdDocumento` and its `Data`.
- **Documents this service did not render**, from `fattureCollegate` in `ftReceiptCaseData`: `idDocumento` (1 to 20 Latin-1 characters) and `data`.

The document types marked **required** in [Table 3](#document-types) must name at least one linked document. No linked document may be dated after the document itself (SdI 00418).

### Body — `DatiDDT`

For an **issued** document, each entry of `ddt` in `ftReceiptCaseData` becomes one `DatiDDT` with `NumeroDDT` (`numeroDdt`, 1 to 20 Latin-1 characters), `DataDDT` (`dataDdt`) and `RiferimentoNumeroLinea` (`riferimentoNumeroLinea`, the invoice lines the delivery note covers, 1-based in request order; empty means the whole invoice).

### Body — `DettaglioLinee` (one per charge item)

Each entry of `cbChargeItems` becomes one line, in the order sent. Modifiers such as discounts and vouchers are not grouped: each charge item is its own line, with its own sign. `Amount` is gross; the line carries the net amount.

| FatturaPA element | Value |
| --- | --- |
| `NumeroLinea` | Position of the charge item in `cbChargeItems`, starting at 1. `Position` is not used. |
| `Descrizione` | `Description`; `Articolo` when empty. Cut to 1000 characters. |
| `Quantita` | `Quantity`, up to 8 decimals. Positive on a TD04 and on a rectification. |
| `PrezzoUnitario` | Net amount ÷ `Quantity`, up to 8 decimals. The net amount is `Amount` − VAT, where the VAT is `VATAmount` or, when not sent, `Amount` ÷ (100 + `VATRate`) × `VATRate`. Positive on a TD04, negative on a rectification. |
| `PrezzoTotale` | `Quantita` × `PrezzoUnitario` as written, rounded to cents. |
| `AliquotaIVA` | `VATRate` |
| `Natura` | Only when `VATRate` is 0: derived from `ftChargeItemCase` (see [Natura](#natura)). |

*Table 13. Mapping of `DettaglioLinee`.*

`Quantita` and `PrezzoUnitario` keep up to 8 decimals because SdI recomputes `PrezzoTotale` as `PrezzoUnitario` × `Quantita` and tolerates a difference of less than one cent (SdI 00423). A unit price cut to cents fails that check as soon as the quantity is above 1: two items at 44.00 gross (7.93 VAT) are 18.04 × 2 = 36.08 against a net amount of 36.07; with `PrezzoUnitario` 18.035 the product is 36.07.

Amounts are rounded to two decimals **half away from zero** (2.345 becomes 2.35).

### Natura

`Natura` is required on every line and summary block with a VAT rate of 0. It is derived from the `ftChargeItemCase` of the charge item — its type of service (`S`), VAT (`V`) and nature of VAT (`NN`) — as documented in [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md).

| `ftChargeItemCase` | `Natura` |
| --- | --- |
| Type of service `3` (Tip) | `N2.2` |
| Type of service `4` (Voucher) with VAT `8` (Not Taxable) | `N2.2` |
| VAT `7` (Zero VAT rate) | `N2.2` |
| VAT `8` (Not Taxable), NN `10` | `N3.1` — exports |
| VAT `8`, NN `11` | `N3.2` — intra-community supplies |
| VAT `8`, NN `12` | `N3.3` — transfers to San Marino |
| VAT `8`, NN `13` | `N3.4` — assimilated to export supplies |
| VAT `8`, NN `14` | `N3.5` — declarations of intent |
| VAT `8`, NN `15`–`1F` | `N3.6` — other operations |
| VAT `8`, NN `20` | `N2.1` — not subject, arts. 7 to 7-septies DPR 633/72 |
| VAT `8`, NN `21`–`2F` | `N2.2` — not subject, other cases |
| VAT `8`, NN `3x` | `N4` — exempt |
| VAT `8`, NN `4x` | `N5` — margin scheme |
| VAT `8`, NN `50` | `N6.1` — reverse charge, scrap and salvage materials |
| VAT `8`, NN `51` | `N6.2` — reverse charge, gold and silver |
| VAT `8`, NN `52` | `N6.3` — reverse charge, construction subcontracting |
| VAT `8`, NN `53` | `N6.4` — reverse charge, buildings |
| VAT `8`, NN `54` | `N6.5` — reverse charge, mobile phones |
| VAT `8`, NN `55` | `N6.6` — reverse charge, electronic products |
| VAT `8`, NN `56` | `N6.7` — reverse charge, construction and related sectors |
| VAT `8`, NN `57` | `N6.8` — reverse charge, energy sector |
| VAT `8`, NN `58`–`5F` | `N6.9` — reverse charge, other cases |
| VAT `8`, NN `6x` | `N7` — VAT paid in another EU country |
| VAT `8`, NN `80`–`FF` | `N1` — excluded pursuant to art. 15 DPR 633/72 |

*Table 14. Derivation of `Natura` from `ftChargeItemCase`.*

The rules are applied top to bottom. No `Natura` can be derived — and a line with `VATRate` 0 is [rejected](#charge-items-currency-and-causale) — for:

- VAT `8` with NN `00`–`0F`,
- VAT `8` with NN `7x` (*ventilazione IVA*, which has no FatturaPA `Natura`),
- any other VAT value (`0`–`6`), since a taxed line cannot have a rate of 0.

### Body — `DatiRiepilogo` (VAT summary)

The lines are grouped by `AliquotaIVA` and `Natura`; each group becomes one `DatiRiepilogo` block.

| FatturaPA element | Value |
| --- | --- |
| `AliquotaIVA` | The group's VAT rate. |
| `Natura` | The group's `Natura`, only when the rate is 0. |
| `ImponibileImporto` | Sum of the group's `PrezzoTotale` as written (SdI 00422). |
| `Imposta` | The VAT the POS charged (sum of the lines' VAT, rounded to cents) when it is less than one cent away from `ImponibileImporto` × `AliquotaIVA` ÷ 100 (SdI 00421); otherwise that product, rounded to cents. |
| `EsigibilitaIVA` | `I` (immediata). |

*Table 15. Mapping of `DatiRiepilogo`.*

Keeping the POS's own VAT makes the document total equal the receipt total. Example: 1019.68 at 22% is 224.3296; the POS charged 224.32, which is 0.0096 away and is kept, so the 22% group totals 1244.00 like the receipt instead of 1244.01.

### Body — `DatiPagamento`

`DatiPagamento` is derived from `cbPayItems`, and only for an **issued** document. It carries `CondizioniPagamento` **TP02** (pagamento completo) and one `DettaglioPagamento` per payment method, with `ModalitaPagamento`, `ImportoPagamento` (the summed amount) and, when sent in `ftPayItemCaseData`, `DataScadenzaPagamento` and `IBAN`:

- Pay items are grouped by payment method, due date and IBAN, and summed, so a change item (a negative amount of the same method) nets out.
- The negative pay items of a refund are written as positive amounts.
- A group whose sum is not positive is dropped. With nothing left, `DatiPagamento` is omitted, which the schema allows.

| `ftPayItemCase` (PP) | `ModalitaPagamento` |
| --- | --- |
| `01` Cash | `MP01` contanti |
| `02` Non-cash | `MP08` carta di pagamento |
| `03` Crossed cheque | `MP02` assegno |
| `04` Debit card, `05` Credit card, `07` Online payment | `MP08` carta di pagamento |
| `06` Voucher | `MP22` trattenuta su somme già riscosse — the voucher was paid when it was sold |
| `09` Accounts receivable | `MP05` bonifico — settled later; send the due date (and IBAN) in `ftPayItemCaseData` |
| `0A` SEPA transfer, `0B` Other bank transfer | `MP05` bonifico |
| `0F` Ticket restaurant | `MP08` carta di pagamento — meal tickets are electronic cards since the 2020 reform |
| `00` Unknown, `08` Loyalty, `0C` Transfer to cashbook, `0D` Internal consumption, `0E` Grant | Not written: these settle nothing. |

*Table 16. Derivation of `ModalitaPagamento` from `ftPayItemCase`. See [Type of Payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md#pp---payment-type).*

There is no FatturaPA code for a voucher, a meal ticket or a sale on account; the defaults above are the closest ones. A POS that knows better names the method per pay item in [`ftPayItemCaseData`](#the-ftpayitemcasedata-payload).

### Not rendered

These optional elements of the FatturaPA schema ([`Schema_VFPR12` v1.2.3](https://www.agenziaentrate.gov.it/portale/documents/d/guest/schema_vfpr12_v1-2-3), used by specification version 1.9.1) are not written:

| Block | Needed when |
| --- | --- |
| `RappresentanteFiscale` (of the seller or the buyer) | A party acting through a fiscal representative in Italy. |
| `StabileOrganizzazione` (of the seller or the buyer) | A non-resident party with a permanent establishment in Italy. |
| Seller `IscrizioneREA` | A company registered in the Registro delle Imprese (REA data). |
| Seller `AlboProfessionale`, `ProvinciaAlbo`, `NumeroIscrizioneAlbo`, `DataIscrizioneAlbo` | A professional registered in a professional register (albo). |
| Seller `Contatti`, `ContattiTrasmittente` | Contact details of the seller or the transmitter; the transmitter's are added at transmission. |
| `Anagrafica` `Titolo` and `CodEORI`, `Sede` `NumeroCivico` | Honorific title, EORI code, house number as a separate element (the house number is part of `Indirizzo`). |
| `SoggettoEmittente` `TZ` | A document issued by a third party; added at transmission when it applies. |
| `DatiOrdineAcquisto`, `DatiContratto`, `DatiConvenzione` (CIG, CUP) | Orders, contracts and agreements the invoice refers to; for B2G, which is not supported, a public office rejects an invoice without them. |
| `DatiRicezione`, `DatiSAL`, `FatturaPrincipale` | References to a goods receipt, a work progress stage (SAL), or the main invoice of an ancillary transport invoice. |
| `Art73` | Documents issued under art. 73 DPR 633/72. |
| `DatiVeicoli` | Intra-community sale of new means of transport. |
| `Allegati` | Attachments to the invoice. |
| `DatiTrasporto` | Accompanying invoice (fattura accompagnatoria). |
| `DatiBollo`, `DatiRitenuta`, `DatiCassaPrevidenziale`, document-level `ScontoMaggiorazione`, `Arrotondamento` | Specific regimes. |
| `DettaglioPagamento` `IstitutoFinanziario`, `ABI`/`CAB`/`BIC`, instalments (`TP01`) | Detailed bank data, payment by instalments. |
| `CondizioniPagamento` `TP03`; `DettaglioPagamento` `Beneficiario`, `DataRiferimentoTerminiPagamento`, `GiorniTerminiPagamento`, `CodUfficioPostale`, quietanzante fields, `ScontoPagamentoAnticipato`, `DataLimitePagamentoAnticipato`, `PenalitaPagamentiRitardati`, `DataDecorrenzaPenale`, `CodicePagamento` | Advance payment, payment terms, early-payment discount, late-payment penalty, payment reference. |
| `EsigibilitaIVA` `D` and `S` | Deferred VAT (esigibilità differita) and split payment (scissione dei pagamenti); every summary block carries `I`. |
| `DatiRiepilogo` `SpeseAccessorie`, `Arrotondamento`, `RiferimentoNormativo` | Ancillary expenses, rounding, or the legal reference of a summary block (for example the provision behind a `Natura`). |
| Line-level `CodiceArticolo`, `UnitaMisura`, `ScontoMaggiorazione`, `DataInizioPeriodo`/`DataFinePeriodo`, `RiferimentoAmministrazione`, `AltriDatiGestionali` | `ProductNumber`, `ProductBarcode` and `Unit` of the charge item are not read. `AltriDatiGestionali` also carries the `ESENZSPORT` value introduced with specification 1.9.1. |
| Line-level `TipoCessionePrestazione`, `Ritenuta` | A line marked as discount, premium, rebate or ancillary expense; a line subject to withholding tax. |
| Buyer `Nome`/`Cognome` | Private person, ditta individuale. |
| IdSdI of a linked document | Has no element in schema 1.2.x. |
| TD07–TD09 simplified invoices | A different format (FSM10). |

*Table 17. FatturaPA elements that are not rendered.*

Foreign buyers of an issued document are excluded by decision: such a receipt gets no FatturaPA (see [Which receipts get a FatturaPA](#which-receipts-get-a-fatturapa)).

## Output

On success, the process step appends two signatures to `ftSignatures` of the `ReceiptResponse`. Existing signatures and the identifying fields of the response are not changed.

| `Caption` | `ftSignatureFormat` | `Data` |
| --- | --- | --- |
| `einvoice-fattura-pa` | Text | The FatturaPA XML, UTF-8, on a single line, unsigned. The signature type carries the **DontVisualize** flag, so the XML is not printed on the receipt. |
| `einvoice-file-name` | Text | A suggested SdI file name, `IT{codice fiscale}_{ProgressivoInvio}.xml`. The file is named at transmission. |

*Table 18. Signatures returned on success.*

If the process step fails, `ftState` is set to the error state (see [Service Status: ftState](../reference-tables/service-status-ftstate.md)) and one signature is appended:

| `Caption` | `ftSignatureFormat` | `Data` |
| --- | --- | --- |
| `einvoice-error` | Text | The broken rules, separated by `; `, cut to 4000 characters. The signature type carries the **Failure** category. |

*Table 19. Signature returned on failure.*

:::caution A process failure happens after fiscalization
Unlike a validation rejection, a failure in the process step happens after the receipt was fiscalized. The validation rules below catch everything that can be decided from the request and the merchant's account, so this case is limited to rules only the built document can check.
:::

## Validation rules

The validate step checks every rule below and returns **all** violations at once; the process step runs them again. A violation rejects the receipt in the validate step, and fails the process step with an `einvoice-error` signature. The messages are quoted as the service returns them, with `…` for the values it fills in, so you can search for them.

### Seller

These rules apply to the merchant's AdE connection. The same rules are applied when the *regime fiscale* and the *sede* are configured, so master data that could never be rendered is normally refused there already.

| Rule | Message |
| --- | --- |
| The receipt must not carry a `cedente`. | `ftReceiptCaseData must not carry a cedente: the seller is the merchant's configured identity, not the receipt's. Remove it and configure the account with POST /v0/ade/connection.` |
| The account must have seller data. | `The seller is unknown: this account has no AdE connection carrying one. Connect it with POST /v0/ade/connection, including regimeFiscale and sede.` |
| P.IVA has 11 digits. | `cedente.partitaIva must be the seller's 11-digit P.IVA (an optional IT prefix is stripped).` |
| *Denominazione* is set. | `cedente.denominazione is required.` |
| *Regime fiscale* is a FatturaPA code. | `cedente.regimeFiscale must be a code from the FatturaPA list (e.g. RF01), but is '…'.` |
| *Sede* has `indirizzo`, a 5-character `cap` and `comune`. | `The seller's sede is missing: the account's AdE connection carries no indirizzo, 5-char cap and comune. Add them with POST /v0/ade/connection.` |
| *Denominazione* ≤ 80, `indirizzo` ≤ 60, `comune` ≤ 60 characters. | `cedente.… is … characters; a FatturaPA accepts at most ….` |
| Latin-1 text only. | `cedente.… contains characters outside Latin-1; a FatturaPA (and SdI) accepts Latin-1 text only.` |
| `provincia` is an Italian province code. | `cedente.sede.provincia must be a two-letter Italian province code (e.g. RM), but is '…'.` |
| `nazione` is a known country code. | `cedente.sede.nazione must be an ISO 3166-1 alpha-2 country code the FatturaPA list knows (e.g. IT), but is '…'.` |

*Table 20. Validation rules for the seller.*

### Buyer

| Rule | Message |
| --- | --- |
| `CustomerVATId`, when sent, is a partita IVA: 11 digits with a valid check digit, optionally prefixed with `IT`. | `The given partita IVA '…' is not valid. cbCustomer.CustomerVATId must contain 11 digits with a valid check digit, optionally prefixed with 'IT', or must be left empty. A codice fiscale belongs in cbCustomer.CustomerTaxId.` |
| `CustomerTaxId`, when sent, is a codice fiscale: 16 characters with a valid check character. | `The given codice fiscale '…' is not valid. cbCustomer.CustomerTaxId must contain a 16 character Italian codice fiscale. A partita IVA belongs in cbCustomer.CustomerVATId.` |
| `CustomerName` is set. | `cbCustomer with CustomerName is required for an invoice receipt.` |
| `CustomerName` ≤ 80, `CustomerStreet` ≤ 60, `CustomerCity` ≤ 60 characters. | `cbCustomer.… is … characters; a FatturaPA accepts at most ….` |
| Latin-1 text only in `CustomerName`, `CustomerStreet`, `CustomerCity`. | `cbCustomer.… contains characters outside Latin-1; …` |
| `CustomerZip`, when sent, has exactly 5 characters. | `cbCustomer.CustomerZip must be the 5-character CAP (00000 outside Italy), but is '…'.` |
| `CustomerCountry`, when sent, is a known country code. | `cbCustomer.CustomerCountry must be an ISO 3166-1 alpha-2 country code the FatturaPA list knows (e.g. IT), but is '…'.` |
| `cessionario.provincia`, when sent, is an Italian province code. | `einvoicing.cessionario.provincia must be a two-letter Italian province code (e.g. RM), but is '…'.` |
| `cessionario.provincia` needs the buyer address. | `einvoicing.cessionario.provincia belongs to the buyer's address: cbCustomer must also carry CustomerStreet, CustomerZip and CustomerCity.` |

*Table 21. Validation rules for the buyer.*

### Routing per receipt case

| Receipt case | Rule | Message |
| --- | --- | --- |
| B2B | Buyer identity required. | `cbCustomer.CustomerVATId (the buyer's partita IVA) or cbCustomer.CustomerTaxId (its codice fiscale) is required for a B2B invoice.` |
| B2B | A 6-character code names a public office. | `A 6-char codiceDestinatario names a public office; use the InvoiceB2G receipt case.` (B2G is not supported.) |
| B2B | 7-character code or `pec` required. | `A B2B invoice needs a 7-char codiceDestinatario or a pec for SdI routing.` |
| B2C | Only the `0000000` code. | `A B2C invoice is routed with codiceDestinatario 0000000; leave it out or pass the sentinel.` |
| B2C | Consumer's identity required. | `cbCustomer.CustomerTaxId (the consumer's codice fiscale) or cbCustomer.CustomerVATId (a partita IVA) is required for a B2C invoice.` |
| B2B | Buyer address required. | `cbCustomer must carry CustomerStreet, CustomerZip and CustomerCity for a B2B/B2G invoice.` |

*Table 22. Routing rules per invoice receipt case.*

### Charge items, currency and causale

| Rule | Message |
| --- | --- |
| At least one charge item. | `cbChargeItems must not be empty: the invoice lines are built from them.` |
| `Quantity` is not 0. | `cbChargeItems[…] has Quantity 0; a FatturaPA line needs a quantity.` |
| `VATRate` between 0 and 100. | `cbChargeItems[…] has VATRate …; a FatturaPA AliquotaIVA is a percentage between 0 and 100.` |
| A 0% line has a derivable `Natura`. | `cbChargeItems[…] has VATRate 0 but its ftChargeItemCase (0x…) yields no FatturaPA Natura.` |
| Latin-1 `Description`. | `cbChargeItems[…].Description contains characters outside Latin-1; …` |
| Currency is EUR. | `Only EUR is supported on a FatturaPA, but the receipt carries '…'.` |
| Latin-1 `causale`. | `einvoicing.causale contains characters outside Latin-1; …` |

*Table 23. Validation rules for charge items, currency and causale.*

### Invoice number and linked invoices

| Rule | Message |
| --- | --- |
| `numero` is set. | `ftReceiptCaseData must carry the invoice number as {"IT":{"einvoicing":{"numero":"..."}}}: it comes from the cedente's own progressive series, which nothing else in the receipt or the account holds.` |
| `numero` ≤ 20 characters. | `einvoicing.numero is … characters; a FatturaPA accepts at most 20.` |
| Latin-1 `numero`. | `einvoicing.numero contains characters outside Latin-1; …` |
| `numero` contains a digit (SdI 00425). | `einvoicing.numero must contain at least one digit (SdI control 00425), but is '…'.` |
| `numero` not issued yet for the merchant, year and number space (SdI 00404). | `einvoicing.numero '…' is already the number of the … of … rendered from receipt '…'; SdI rejects a second document with the same seller, year and number (control 00404).` |
| `cbPreviousReceiptReference` of a TD04, TD05 or rectification names a rendered invoice. | `cbPreviousReceiptReference '…' names no invoice rendered for this seller; a credit note links the invoice it corrects (DatiFattureCollegate), so the reference must be the cbReceiptReference of that invoice.` |

*Table 24. Validation rules for the invoice number and linked invoices.*

### Document types, linked documents, delivery notes and payments

In these messages, `…` at the start stands for the document type.

| Rule | Message |
| --- | --- |
| Known document type. | `einvoicing.tipoDocumento must be one of TD01, …, TD29, but is '…' (TD07 … TD09 are the simplified format, which is not rendered).` |
| TD04 only on a refund receipt. | `einvoicing.tipoDocumento TD04 is a credit note: send it as a refund receipt (the Refund flag on ftReceiptCase), with the refunded items.` |
| A refund is a TD04 or a rectifiable code. | `A refund renders a credit note (TD04); … is not rectified with negative amounts. Leave einvoicing.tipoDocumento out or send TD04.` |
| Purchase documents as InvoiceB2B. | `… completes a supplier's document, with the supplier in cbCustomer: send it as an InvoiceB2B receipt.` |
| Supplier name. | `… names the supplier in cbCustomer: CustomerName is required.` |
| Supplier country (SdI 00473). | `… names a supplier established in Italy, but cbCustomer.CustomerCountry is '…' (SdI control 00473).`, or the corresponding message for a supplier established abroad or in another EU member state. |
| Supplier VAT number. | `… needs the supplier's VAT number in cbCustomer.CustomerVATId: the CedentePrestatore's IdFiscaleIVA is mandatory.`, `cbCustomer.CustomerVATId must be the supplier's partita IVA: 11 digits with a valid check digit.`, or `cbCustomer.CustomerVATId must be the supplier's VAT number: 1 to 28 letters or digits, the country prefix optional.` |
| Supplier is not the merchant (SdI 00471). | `… is issued by the merchant for a supplier: the supplier's P.IVA cannot be the merchant's own (SdI control 00471).` |
| Supplier address. | `… needs the supplier's address in cbCustomer: CustomerStreet and CustomerCity, and CustomerZip for an Italian supplier (the CedentePrestatore's Sede is mandatory).` |
| No province for a foreign supplier. | `einvoicing.cessionario.provincia is an Italian province; a supplier established abroad has none.` |
| Linked document required. | `… completes the supplier's document, which DatiFattureCollegate must name: add einvoicing.fattureCollegate with its idDocumento and data (or, for a rectification, cbPreviousReceiptReference to the document it corrects).` |
| Linked document complete. | `einvoicing.fattureCollegate[…] needs idDocumento (the linked document's number) and data (its date, yyyy-MM-dd).` |
| Linked document not dated later (SdI 00418). | `The linked document … is dated …, after this document (…); a document cannot refer to a later one (SdI control 00418).` |
| No 0% line on a TD21 (SdI 00474). | `cbChargeItems[…] has VATRate 0, which a TD21 does not allow (SdI control 00474).` |
| Purchase and self-issued documents go to the merchant. | `A … goes to the merchant itself: codiceDestinatario, when given, is the merchant's own 7-char code.` |
| TD29 routing. | `A TD29 is routed with codiceDestinatario 0000000 and no pec (AdE guide); leave both out.` |
| Delivery notes only on issued documents. | `einvoicing.ddt names delivery notes, which only a document the merchant issues carries; … is not one.` |
| Delivery notes complete. | `einvoicing.ddt[…] needs numeroDdt and dataDdt (yyyy-MM-dd).` |
| Delivery note line references. | `einvoicing.ddt[…].riferimentoNumeroLinea must name invoice lines 1 to …, one per charge item.` |
| Payment method override is a FatturaPA code. | `cbPayItems[…].ftPayItemCaseData einvoicing.modalitaPagamento must be a FatturaPA code (MP01 … MP23), but is '…'.` |
| IBAN shape. | `cbPayItems[…].ftPayItemCaseData einvoicing.iban must be an IBAN (2 letters, 2 digits, 11 to 30 letters or digits), but is '…'.` |

*Table 25. Validation rules for document types, linked documents, delivery notes and payments.*

:::info Latin-1 only
FatturaPA and SdI accept Latin-1 text only. Any character outside Latin-1 (above `U+00FF`) — for example emoji, or characters of non-Latin scripts — in a name, address, description, number or *causale* rejects the receipt.
:::

### Rules checked on the built document

After building the XML, the process step checks the complete document against the FatturaPA rules, using the validators of the FatturaElettronica.NET library. Their errors come back as `<code> - <property>: <message>` in the `einvoice-error` signature.

## Example

A B2B invoice with one 22% line, paid in cash, rendered in the sandbox. As the [`cbCustomer` contract](../data-structures/data-structures.md#customer-data-cbcustomer) requires, the customer is sent as a serialized JSON string:

```json
{
  "ftReceiptCase": 35184372092930,
  "cbCustomer": "{\"CustomerVATId\":\"12345678903\",\"CustomerName\":\"Cliente Esempio S.r.l.\",\"CustomerStreet\":\"Via Dante 4\",\"CustomerZip\":\"20121\",\"CustomerCity\":\"Milano\",\"CustomerCountry\":\"IT\"}",
  "cbChargeItems": [
    { "Quantity": 1, "Description": "Couch", "Amount": 1200, "VATRate": 22, "VATAmount": 216.39, "ftChargeItemCase": 35184372088851 }
  ],
  "cbPayItems": [
    { "Description": "Cash", "Amount": 1200, "ftPayItemCase": 35184372088833 }
  ],
  "ftReceiptCaseData": {
    "IT": {
      "einvoicing": {
        "numero": "2026/00042",
        "codiceDestinatario": "ABCDEFG",
        "cessionario": { "provincia": "MI" }
      }
    }
  }
}
```

| FatturaPA element | Value | Source |
| --- | --- | --- |
| `FormatoTrasmissione` / `CodiceDestinatario` | `FPR12` / `ABCDEFG` | `codiceDestinatario`, 7 characters |
| `CedentePrestatore` | SANDBOX MERCHANT S.R.L., 00000000000, RF01, Via di Prova 1, 00100 Roma RM | Sandbox seller |
| `CessionarioCommittente` | IT 12345678903, Cliente Esempio S.r.l., Via Dante 4, 20121 Milano MI IT | `cbCustomer` and `cessionario.provincia` |
| `TipoDocumento` / `Numero` / `Data` | `TD01` / `2026/00042` / the date of `ftReceiptMoment` | No refund flag / `numero` / `ReceiptResponse` |
| `DettaglioLinee` | 1 × Couch, `PrezzoUnitario` 983.61, `PrezzoTotale` 983.61, `AliquotaIVA` 22.00 | 1200 − 216.39 |
| `DatiRiepilogo` | 22.00: `ImponibileImporto` 983.61, `Imposta` 216.39, `EsigibilitaIVA` I | Grouped lines |
| `ImportoTotaleDocumento` | 1200.00 | Sum of the summary |
| `DatiPagamento` | `TP02`, `MP01` 1200.00 | `cbPayItems`, cash |

*Table 26. FatturaPA values rendered from the example.*

## Related pages

- [Overview](./overview.md) — scope, regulatory status, and terminology.
- [Setup & testing](./setup.md) — prerequisites and the end-to-end sandbox example.
- [Data Structures](../data-structures/data-structures.md) — the `cbCustomer` fields and how the customer is sent.
- [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md) — the invoice receipt cases and the refund flag.
- [Type of Service: ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md) — the VAT and nature-of-VAT values behind `Natura`.
- [Type of Payment: ftPayItemCase](../reference-tables/type-of-payment-ftpayitemcase.md) — the payment types behind `ModalitaPagamento`.

External references:

- [Specifiche tecniche versione 1.9.1 (Agenzia delle Entrate)](https://www.agenziaentrate.gov.it/portale/specifiche-tecniche-versione-1.9.1-%C2%A0-utilizzabili-dal-15-maggio-2026-) — the current FatturaPA specification, usable from 15 May 2026, with the schemas and tabular layouts.
- [Allegato A – Specifiche tecniche vers. 1.9.1 (PDF)](https://www.agenziaentrate.gov.it/portale/documents/d/guest/allegato-a-specifiche-tecniche-vers-1-9-1) — the technical specification document, including the SdI controls.
- [`Schema_VFPR12` v1.2.3 (XSD)](https://www.agenziaentrate.gov.it/portale/documents/d/guest/schema_vfpr12_v1-2-3) — the XML schema of the ordinary invoice.
- [Specifiche tecniche versione 1.9 (Agenzia delle Entrate)](https://www.agenziaentrate.gov.it/portale/specifiche-tecniche-versione-1.9) — the previous specification version.
- [Documentazione Sistema di Interscambio (fatturapa.gov.it)](https://www.fatturapa.gov.it/it/norme-e-regole/DocumentazioneSDI/) — the SdI documentation.
