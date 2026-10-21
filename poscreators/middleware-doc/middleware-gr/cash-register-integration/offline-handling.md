---
slug: /poscreators/middleware-doc/greece/cash-register-integration/offline-handling
title: Offline Handling
description: What the POS system must do in Greece when the Middleware cannot be reached, how documents are transmitted to myDATA afterwards, and how handwritten receipts are recovered.
tags: [Greece, myDATA, Offline, Failure Handling, Cash Register Integration]
---

# Offline Handling

This page describes what the POS system must do in Greece when a connection is lost. It expands on [Offline Handling](../../general/cash-register-integration/offline-handling.md) of the general part and documents only what applies in Greece.

## Which setups need an internet connection

In Greece, the fiskaltrust.Middleware runs in the fiskaltrust cloud, and every document is transmitted to myDATA at the moment it is issued. Every document therefore needs an internet connection. For more information, see [Key factors for the Greek market](../go-to-market/go-to-market.md#key-factors-for-the-greek-market).

AADE distinguishes two failures:

- **Transmission failure 1**: loss of connection between the business and the provider. This is the case when the POS system cannot reach the fiskaltrust.Middleware.
- **Transmission failure 2**: loss of connection between the provider and myDATA. The retransmission of these documents is handled by fiskaltrust.

## POS system cannot reach the fiskaltrust.Middleware

1. Retry the request with the same `x-operation-id` and the same body. If the fiskaltrust.Middleware has already processed the document, it returns the original response. For more information, see [Error Handling](../../general/cash-register-integration/error-handling.md#how-the-pos-system-should-react).
2. If the fiskaltrust.Middleware stays unreachable, issue the receipt with the hint "Security mechanism not reachable" and buffer it.
3. Once the fiskaltrust.Middleware is reachable again, send the buffered receipts without delay with the flag `0x0000_0000_0001_0000` (**Process as Late Signing Receipt**), in ascending order of `cbReceiptMoment`. The fiskaltrust.Middleware transmits them to myDATA with `transmissionFailure = 1`.
4. The response contains the signature item `TransmissionFailure` with the notice *Απώλεια Διασύνδεσης Οντότητας - Παρόχου*. It must be printed.

For more information, see [Signature items returned by the Middleware](../receipt-printing/receipt-printing.md#signature-items-returned-by-the-middleware) and [Type of Receipt: ftReceiptCase](../reference-tables/type-of-receipt-ftreceiptcase.md).

## Handwritten receipts

Handwritten receipts are sent with the flag `0x0000_0000_0008_0000` (**Process as Handwritten Receipt**) and transmitted with the series and number of the paper document. `ftReceiptCaseData.GR` must contain:

| Field | Value |
|-------|-------|
| `Series` | The series of the paper document. It must differ from the queue's own series. |
| `AA` | The number of the paper document, greater than 0. |
| `MerchantVATID` | The VAT number of the merchant, matching the account. |
| `HashAlg` | The hash algorithm. |
| `HashPayload` | `MerchantVATID-Series-AA-cbReceiptReference-cbReceiptMoment-TotalAmount`. It must match the transmitted data exactly. |

*Table 1. Fields of `ftReceiptCaseData.GR` for a handwritten receipt.*

The response carries the signature item `HandwrittenSignature` with a link, which is not printed. For more information, see [Supported document types](../licensing/licensing.md#supported-document-types).

## Checklist

- Plan a reliable internet connection for every location.
- Buffer receipts persistently while the fiskaltrust.Middleware is unreachable, and send them without delay once it is reachable again.
- Print the `TransmissionFailure` notice on late-signed receipts.
- Offer a way to record handwritten receipts with the series and number of the paper document.
