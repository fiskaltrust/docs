---
slug: /poscreators/middleware-doc/general/cash-register-integration/error-handling
title: Error Handling
---

# Error Handling

This page describes how the fiskaltrust.Middleware reports errors and how the POS system should react to them. Errors are reported on two levels:

1. **In the `ReceiptResponse`:** the request reached the Middleware and was answered. The result is indicated by the `ftState`, and any error message is contained in the `ftSignatures`.
2. **On the transport level:** the POS system receives no response, a timeout, or a transport error (for example an HTTP error status). In this case, no `ReceiptResponse` is available.

## Evaluating the ftState

The `ftState` is returned with every `ReceiptResponse` and has the format _CCCC_vlll_gggg_gggg_ (see [Service Status: ftState](../reference-tables/reference-tables.md#service-status-ftstate)). The lower 32 bits (`gggg_gggg`) contain either a combination of status flags or one of the two error values:

| `gggg_gggg` | Meaning | Receipt processed? |
|-------------|---------|--------------------|
| `0000_0000` | **OK.** The receipt was processed without any remarks. | Yes |
| Status flags, e.g. `0000_0002`, `0000_0008`, `0000_0040`, `0000_0100` | **Processed with status information.** The receipt was processed, and the Middleware reports a state that requires attention (for example SCU out of service, late-signing mode active, message pending, daily closing due). | Yes |
| `0000_0001` | **Security mechanism out of operation.** The queue is not started yet or has already been stopped. | No |
| `EEEE_EEEE` | **Error.** The request was stored as a queue item, but it was not processed as a receipt: no `ftReceiptNumber` was consumed, and the receipt is not part of the receipt chain. The error reason is contained in the `ftSignatures`. This happens, for example, if the `ftReceiptCase` is not recognized or the request fails validation. | No |
| `FFFF_FFFF` | **Fail.** The request was not processed, and nothing was persisted in the queue. The fail reason is contained in the `ftSignatures`. | No |

*Table 1. ftState values relevant for error handling.*

The error values `EEEE_EEEE` and `FFFF_FFFF` set all bits of the lower 32 bits, so they must be checked by comparing the complete lower 32 bits, **before** checking individual status flags:

```csharp
var state = receiptResponse.ftState & 0xFFFF_FFFF;

if (state == 0xEEEE_EEEE || state == 0xFFFF_FFFF)
{
    // Error / Fail: the receipt was not fiscalized
}
else if (state == 0)
{
    // OK
}
else
{
    // Processed; evaluate the individual status flags
}
```

The upper part of the `ftState` keeps the country code (`CCCC`) and can contain local flags (`lll`) that further specify an error. For example, in Poland `0x504C_2001_EEEE_EEEE` indicates that the fiscal register could not be reached. The local flags are described in the `ftState` reference table of each country-specific appendix.

## How error messages are returned

An error state is returned as a regular `ReceiptResponse`, not as a transport error. The error reason is contained in one or more `SignatureItems` in `ftSignatures`:

- `ftSignatureFormat` is `0x1` (text).
- `ftSignatureType` has the type/category `3` (_Failure_), for example `0x4245_2000_0000_3000` for Belgium (see [ftSignatureType](../reference-tables/reference-tables.md#type-of-signature-ftsignaturetype)).
- `Caption` contains a short identifier of the error (for example `FAILURE`).
- `Data` contains the human-readable error message.

If a request fails validation, the response may contain one failure signature per validation error. The text of `Caption` and `Data` differs between markets, so the POS system should base its logic on the `ftState` and use the signature texts for display and logging. In addition, the Middleware records the error in the ActionJournal.

```json
{
  "ftCashBoxIdentification": "CPOS0031234567",
  "cbReceiptReference": "1234-e847a83d-afc0-4978-b2b0-df63d57ca621",
  "ftQueueItemID": "df32698e-f744-4bf2-9bef-6c2e86420a0c",
  "ftReceiptIdentification": "ft2D#",
  "ftSignatures": [
    {
      "ftSignatureFormat": 1,
      "ftSignatureType": 4775258164268380160,
      "Caption": "FAILURE",
      "Data": "VAT rate 20.0 is not supported."
    }
  ],
  "ftState": 4775258168277004014
}
```

*Figure 1. Shortened example of an error response from a Belgian queue: `ftState` `0x4245_2000_EEEE_EEEE` with a failure signature of type `0x4245_2000_0000_3000`.*

Errors that occur before a request can be assigned to a queue item (for example a malformed request, an invalid `ftCashBoxID` or invalid credentials) are returned on the transport level. When using the [POS System API](../../possystem-api/introduction.md), these are returned as HTTP error responses; see the [POS System API reference](https://docs.fiskaltrust.cloud/apis/pos-system-api) for the error codes per endpoint.

## How the POS system should react

| Situation | Reaction of the POS system |
|-----------|----------------------------|
| `ftState` OK | Print or issue the receipt, including all returned `ftSignatures`. |
| `ftState` with status flags | Print or issue the receipt, including all returned `ftSignatures`, and signal the state to the operator. Resolve the state as described for the flag, usually with a Zero-Receipt or the due closing receipt (see [Service Status: ftState](../reference-tables/reference-tables.md#service-status-ftstate) and [Failure Scenarios](./cash-register-integration-failure-scenarios.md)). |
| `ftState` `0000_0001` | Start the queue with an initial-operation receipt. A stopped queue cannot be reopened; a new queue must be created and started instead (see [Stop Receipt](./cash-register-integration-regular-workflow.md#stop-receipt-closing-receipt)). |
| `ftState` `EEEE_EEEE` or `FFFF_FFFF` | The receipt was not fiscalized and must not be issued as a fiscal receipt. Show the error message from the failure signature(s) to the operator, correct the cause, and send the request again. Check the country-specific appendix for market-specific rules, for example in Poland sales must not continue while the fiscal register is unreachable (see [Cash Register Integration (PL)](../../middleware-pl/cash-register-integration/cash-register-integration.md)). |
| No response, timeout or transport error | Do not assume that the receipt was or was not processed. Resend the unchanged request (same `cbReceiptReference`) with the `ReceiptRequest` flag `0x0000_0000_8000_0000` to receive the stored response of an already processed receipt (see [ftReceiptCaseFlag](../reference-tables/reference-tables.md#ftreceiptcaseflag)). With the POS System API, retry with the same `x-operation-id` and the same body (see [Process-Driven and Idempotent Design](../../possystem-api/introduction.md#process-driven-and-idempotent-design)). If the Middleware stays unreachable, continue as described in [Middleware not reachable or failing](./cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing). |

*Table 2. Recommended reactions of the POS system per error situation.*

:::tip

In most markets, a failed SCU (signing device or service) does not result in an error state: the Middleware continues to sign receipts in failed mode and sets the flag `0000_0002`, so the POS system can continue to operate (see [Signature Creation Unit not reachable or failing](./cash-register-integration-failure-scenarios.md#signature-creation-unit-not-reachable-or-failing)). Markets without such a fallback, for example Poland, return an error state instead.

:::
