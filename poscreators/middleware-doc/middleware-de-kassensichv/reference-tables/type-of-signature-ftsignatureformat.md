---
slug: /poscreators/middleware-doc/germany/reference-tables/ftsignatureformat
title: 'Format of Signature: ftSignatureFormat'
description: ftSignatureFormat in Germany and the flag that marks signatures as optional to print when the receipt shows a QR code.
tags: [Germany, ftSignatureFormat, Signature, Printing, Reference Tables]
---

# Format of Signature: ftSignatureFormat

The Middleware uses the same ftSignatureFormat in Germany as in all other countries, as described in the [Format of Signature: ftSignatureFormat](../../general/reference-tables/reference-tables.md#format-of-signature-ftsignatureformat) reference table of the Compliance Middleware.

In Germany, you can print the fiscalization details either as a QR code or as text. The QR code specified by the DSFinV-K does not contain all values, so the Middleware adds a flag to the `ftSignatureFormat` value that marks signatures as optional to print when you print the QR code. For more information, see [Printing receipts](../cash-register-integration/cash-register-integration.md#printing-receipts).

## ftSignatureFormatFlag

| **Value** | **Description** | **Middleware Version** | 
| --------- | --------------- | ---------------------- |
| `0x0000000000010000` | **Printing is optional** <br />When included in the `ftSignatureFormat`, printing the signature to the physical receipt is **not** required. The returned QR code replaces these signatures. If the hardware used does not support printing QR codes, these values must be printed instead. For more information, see [Content of the QR code](../cash-register-integration/cash-register-integration.md#content-of-the-qr-code). The Queue configuration parameter `FlagOptionalSignatures` (which can be set in the Portal) can be set to `false` to disable adding this flag to any items. | 1.3.23- |

*Table 1. ftSignatureFormatFlag values applicable to the German market.*