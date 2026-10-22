---
slug: /poscreators/middleware-doc/germany/cash-register-integration
title: Cash Register Integration
description: Which ftSignatures to print on receipts in Germany, with or without a QR code, and how the printing-optional flag is used.
tags: [Germany, Printing, Signature, Cash Register Integration, KassenSichV]
---

# Cash Register Integration

This chapter describes the cash register integration in accordance with German law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of the general part.

## fiskaltrust.Middleware, terminals and the TSE

The general model of the fiskaltrust.Middleware, input devices and locations applies to Germany as well: the fiskaltrust.Middleware is the electronic recording system (DE: elektronisches Aufzeichnungssystem) in the terms of §146a AO, and the POS terminals connected to it are input devices. For more information, see [fiskaltrust.Middleware, Terminals and Locations](../../general/components/queues-terminals-locations.md).

In addition, the following applies to the TSE in Germany:

- Every TSE is bound to one location. A PosOperator with several locations needs at least one TSE per location.
- Several on-premise fiskaltrust.Middleware instances can share one TSE, within the number of clients the TSE supports.
- A fiskaltrust.Middleware hosted in the cloud (CloudCashBox) needs its own TSE per installation.

For more information on the number of clients per TSE, see [On-Premise Installation](../operation-modes/on-premise-installation.md#scucharacteristics--platform-support-matrix).

The `cbTerminalID` sent by the POS system is not part of the DSFinV-K export. For more information, see [DSFinV-K generation](../procedural-documentation/dsfinv-k-generation.md).

### Resolving failures

Two failure situations must be distinguished:

- **The POS system cannot reach the fiskaltrust.Middleware.** The POS system buffers the receipts and sends them to the fiskaltrust.Middleware as soon as it is reachable again.
- **The fiskaltrust.Middleware cannot reach the TSE.** The fiskaltrust.Middleware continues to accept receipts in failed mode. These receipts are not sent again; a Zero-Receipt ends failed mode once the TSE is reachable again.

In Germany, the PosOperator must remedy the cause of both failure situations immediately (DE: unverzüglich). The law does not define a time frame. Configure the buffering of receipts on the POS system accordingly.

For more information, see [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

### Resending receipts without signing them twice

If the POS system did not receive a response, it cannot know whether the fiskaltrust.Middleware has already processed the receipt. To find out, send the receipt again with the flag `0x0000800000000000` (**Receipt request**) set in the `ftReceiptCase`:

- Use the same `cbReceiptReference` and, if used, the same `cbTerminalID` as in the original request.
- The ChargeItems and PayItems must be exactly the same as in the original request.

If the fiskaltrust.Middleware has already processed a matching receipt, it returns the stored response of that receipt, and the receipt is not processed a second time. If no matching receipt is found, the fiskaltrust.Middleware returns no response; in this case, send the receipt as a new request, flagged as a failed receipt. For more information, see [Middleware not reachable or failing](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing) and [ftReceiptCaseFlag](../reference-tables/type-of-receipt-ftreceiptcase.md#ftreceiptcaseflag).

## Printing receipts
Like in all other supported countries, the German Middleware returns all compliance-relevant data that need to be printed onto the receipt. In Germany, it's either possible to print a QR code **or** to print the data otherwise contained in this QR code as text. 

We generally recommend using QR codes wherever possible to reduce the amount of required paper. 

### Printing receipts with QR codes
As the Middleware returns additional data in the `ftSignatures` field that is e.g. used by ourselves to create the DSFinV-K, we introduced a flag for the `ftSignatureFormat` field that signalizes if a signature needs to be printed or is optional. More details about this flag are described [here](../reference-tables/type-of-signature-ftsignatureformat.md)

Hence, when printing QR codes, all returned signatures should be printed that **do not** have the _ftSignatureFormatFlag_ `0x0000000000010000` ("printing is optional").

#### Content of the QR code

The Middleware returns the QR code ready to encode in one signature item. You do not need to assemble it from the individual signature items. The signature item has:

- `ftSignatureFormat` `0x03` (QR code)
- `ftSignatureType` `0x4445000000000001` (QR code according to KassenSichV)
- `Caption` `www.fiskaltrust.de`
- `Data`: the complete QR code content

Encode the content of `Data` unchanged as a QR code. The encoding is the same as the encoding of `processData` (UTF-8). The DSFinV-K recommends a size of at least 3 cm and a print quality of at least 300 dpi.

The structure of the QR code is defined in the DSFinV-K, Anhang I, chapter 2, "Definition des QR-Codes für maschinell prüfbare Kassenbelege". Its fields are separated by `;`, in this order:

```
<qr-code-version>;<kassen-seriennummer>;<processType>;<processData>;<transaktions-nummer>;<signatur-zaehler>;<start-zeit>;<log-time>;<sig-alg>;<log-time-format>;<signatur>;<public-key>
```

The individual values of the QR code are also returned as separate text signature items, with the field name as the caption and the flag `0x0000000000010000` (printing is optional). If you print the QR code, you do not need to print them; they are only needed if you print the data as text instead of the QR code.

| **Field**               | **Content**                                      | **Example**                                | **ftSignatureType**  |
| ----------------------- | ------------------------------------------------ | ------------------------------------------ | -------------------- |
| `<qr-code-version>`     | Version of the QR code format                    | `V0`                                       | `0x4445000000000013` |
| `<kassen-seriennummer>` | Serial number of the cash register               | `220130d5-9060-4e26-b75c-35968f49aae3`     | `0x4445000000000014` |
| `<processType>`         | Process type of the TSE transaction              | `Kassenbeleg-V1`                           | `0x4445000000000015` |
| `<processData>`         | Process data of the TSE transaction              | `Beleg^7.50_0.00_0.00_0.00_0.00^7.50:Bar`  | `0x4445000000000016` |
| `<transaktions-nummer>` | TSE transaction number                           | `11`                                       | `0x4445000000000017` |
| `<signatur-zaehler>`    | TSE signature counter                            | `21`                                       | `0x4445000000000018` |
| `<start-zeit>`          | TSE start time                                   | `2020-05-22T11:33:01.000Z`                 | `0x4445000000000019` |
| `<log-time>`            | TSE log time                                     | `2020-05-22T11:33:02.000Z`                 | `0x444500000000001A` |
| `<sig-alg>`             | TSE signature algorithm                          | `ecdsa-plain-SHA256`                       | `0x444500000000001B` |
| `<log-time-format>`     | TSE log time format                              | `utcTime`                                  | `0x444500000000001C` |
| `<signatur>`            | TSE signature                                    | Base64 string                              | `0x444500000000001D` |
| `<public-key>`          | Public key of the TSE                            | Base64 string                              | `0x444500000000001E` |

*Table 1. Fields of the QR code, with their ftSignatureType values.*

The certification ID of the TSE (`0x4445000000000022`), the serial number of the TSE (`0x4445000000000023`) and the overall start time of the business case (`0x444500000000001F`) are not part of the QR code. For a complete example response, see [Single Receipt Creation](single-receipt-creation.md).

### Printing receipts without QR codes
For supporting cases where the used printer does not support QR codes, the Middleware's returned signatures also contain all required information in textual form. The following items from the response's `ftSignatures` property needs to be printed:

| **Description**                         | **Caption**             | **ftSignatureType**  |
| --------------------------------------- | ----------------------- | -------------------- |
| Certification ID of the TSE             | `<certification-id>`    | `0x4445000000000022` |
| Serial number of the TSE                | `<tse-seriennummer>`    | `0x4445000000000023` |
| Serial number of the cash register      | `<kassen-seriennummer>` | `0x4445000000000014` |
| Process type of the TSE transaction     | `<processType>`         | `0x4445000000000015` |
| Process data of the TSE transaction     | `<processData>`         | `0x4445000000000016` |
| TSE transaction number                  | `<transaktions-nummer>` | `0x4445000000000017` |
| TSE signature counter                   | `<signatur-zaehler>`    | `0x4445000000000018` |
| TSE start time                          | `<start-zeit>`          | `0x4445000000000019` |
| TSE log time                            | `<log-time>`            | `0x444500000000001A` |
| TSE signature algorithm                 | `<sig-alg>`             | `0x444500000000001B` |
| TSE log time format                     | `<log-time-format>`     | `0x444500000000001C` |
| TSE signature                           | `<signatur>`            | `0x444500000000001D` |
| Overall start time of the business case | `<vorgangsbeginn>`      | `0x444500000000001F` |

*Table 2. Signature items to print on receipts without QR codes, with their ftSignatureType values.*
