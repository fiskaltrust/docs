---
slug: /poscreators/middleware-doc/general/cash-register-integration/error-handling
title: Error Handling
---

# Error Handling

This page describes how errors are reported to the POS system and how the POS system should react to them. Errors are reported on three levels:

| Level | What happens | `ReceiptResponse` available? |
|-------|--------------|------------------------------|
| [Transport-level error](#transport-level-errors) | The POS system receives no answer, for example because the connection fails, is interrupted or times out. It is unknown whether the request was processed. | No |
| [HTTP-level error](#http-level-errors) | The request reaches the service, but is rejected or fails before a `ReceiptResponse` is created. The service answers with an HTTP error status (for example `400` or `500`). | No |
| [fiskaltrust.Middleware error](#fiskaltrustmiddleware-errors) | The request is processed by the Middleware, which returns a `ReceiptResponse` with a successful HTTP status. The `ftState` indicates that the receipt could not be processed. | Yes |

*Table 1. Levels on which errors are reported to the POS system.*

## Transport-level errors

A transport-level error occurs when the POS system does not receive an answer at all, for example because the network connection or the Middleware host is not available, the connection is interrupted, or the request times out. As the POS system receives no answer, it cannot know whether the request was processed.

## HTTP-level errors

HTTP-level errors are returned by the [POS System API](../../possystem-api/introduction.md) when a request cannot be accepted or processed, for example because it is malformed or the credentials are invalid. In this case, no `ReceiptResponse` is returned. The most relevant status codes are:

| Status code | Meaning |
|-------------|---------|
| `400 Bad Request` | The request was malformed or could not be processed. |
| `401 Unauthorized` | The access token is not set or invalid. |
| `409 Conflict` | The `x-operation-id` was reused with a different request body. |
| `500 Internal Server Error` | The server encountered an unexpected error. |

*Table 2. Relevant HTTP error status codes of the POS System API.*

The error codes per endpoint are listed in the [POS System API reference](https://docs.fiskaltrust.eu/apis/pos-system-api). Error responses use the content type `application/problem+json` and contain a `ProblemDetails` object with a short summary in `title`, the HTTP status in `status` and a description in `detail`. The optional `errors` array can contain details for individual request properties, parameters or headers.

```json
{
  "type": "about:blank",
  "title": "Unauthorized",
  "detail": "Access token not set or invalid. The requested resource could not be returned",
  "status": 401
}
```

*Figure 1. Example of an HTTP-level error response of the POS System API.*

## fiskaltrust.Middleware errors

Errors that occur while the Middleware processes a request are returned as a regular `ReceiptResponse` with a successful HTTP status. The result is indicated by the `ftState`, and the error message is contained in the `ftSignatures`.

### Evaluating the ftState

The `ftState` is returned with every `ReceiptResponse` and has the format _CCCC_vlll_gggg_gggg_ (see [Service Status: ftState](../reference-tables/reference-tables.md#service-status-ftstate)). The lower 32 bits (`gggg_gggg`) contain either a combination of status flags or one of the two error values:

| `gggg_gggg` | Meaning | Receipt processed? |
|-------------|---------|--------------------|
| `0000_0000` | **OK.** The receipt was processed without any remarks. | Yes |
| Status flags, e.g. `0000_0002`, `0000_0008`, `0000_0040`, `0000_0100` | **Processed with status information.** The receipt was processed, and the Middleware reports a state that requires attention (for example SCU out of service, late-signing mode active, message pending, daily closing due). | Yes |
| `0000_0001` | **Security mechanism out of operation.** The queue is not started yet or has already been stopped. | No |
| `EEEE_EEEE` | **Error.** The request was stored as a queue item, but it was not processed as a receipt: no `ftReceiptNumber` was consumed, and the receipt is not part of the receipt chain. The error reason is contained in the `ftSignatures`. This happens, for example, if the `ftReceiptCase` is not recognized or the request fails validation. | No |
| `FFFF_FFFF` | **Fail.** The request was not processed, and nothing was persisted in the queue. The fail reason is contained in the `ftSignatures`. This happens, for example, if the fiskaltrust.Middleware has no access to its database and therefore cannot store the request. | No |

*Table 3. ftState values relevant for error handling.*

The error values `EEEE_EEEE` and `FFFF_FFFF` set all bits of the lower 32 bits, so they must be checked by comparing the complete lower 32 bits, **before** checking individual status flags:

```csharp
var state = receiptResponse.ftState & 0xFFFF_FFFF;

if (state == 0xEEEE_EEEE || state == 0xFFFF_FFFF)
{
    // Error / Fail: the receipt was not processed
}
else if ((state & 0x0000_0001) != 0)
{
    // Security mechanism out of operation: the receipt was not processed
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

### How error messages are returned

The error reason is contained in one or more `SignatureItems` in `ftSignatures`:

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

*Figure 2. Shortened example of an error response from a Belgian queue: `ftState` `0x4245_2000_EEEE_EEEE` with a failure signature of type `0x4245_2000_0000_3000`.*

## How the POS system should react

| Level | Situation | Reaction of the POS system |
|-------|-----------|----------------------------|
| Transport | No answer, connection interrupted or timeout | Do not assume that the receipt was or was not processed. Resend the unchanged request (same `cbReceiptReference`) with the `ReceiptRequest` flag `0x0000_0000_8000_0000` to receive the stored response of an already processed receipt (see [ftReceiptCaseFlag](../reference-tables/reference-tables.md#ftreceiptcaseflag)). With the POS System API, retry with the same `x-operation-id` and the same body (see [Process-Driven and Idempotent Design](../../possystem-api/introduction.md#process-driven-and-idempotent-design)). If the Middleware stays unreachable, continue as described in [Middleware not reachable or failing](./cash-register-integration-failure-scenarios.md#middleware-not-reachable-or-failing). |
| HTTP | `400`, `401` or `409` | Resending the unchanged request does not resolve the error. Correct the cause described in the `ProblemDetails` (for example the request body or the credentials) and send the corrected request with a new `x-operation-id`, because reusing the `x-operation-id` with a different body is rejected with `409 Conflict`. |
| HTTP | `500` | The request can be retried with the same `x-operation-id` and the same body, as calls to the POS System API are idempotent (see [Process-Driven and Idempotent Design](../../possystem-api/introduction.md#process-driven-and-idempotent-design)). |
| Middleware | `ftState` OK | Print or issue the receipt, including all returned `ftSignatures`. |
| Middleware | `ftState` with status flags | Print or issue the receipt, including all returned `ftSignatures`, and signal the state to the operator. Resolve the state as described for the flag, usually with a Zero-Receipt or the due closing receipt (see [Service Status: ftState](../reference-tables/reference-tables.md#service-status-ftstate) and [Failure Scenarios](./cash-register-integration-failure-scenarios.md)). |
| Middleware | `ftState` `0000_0001` | Start the queue with an initial-operation receipt. A stopped queue cannot be reopened; a new queue must be created and started instead (see [Stop Receipt](./cash-register-integration-regular-workflow.md#stop-receipt-closing-receipt)). |
| Middleware | `ftState` `EEEE_EEEE` or `FFFF_FFFF` | The receipt was not fiscalized and must not be issued as a fiscal receipt. Show the error message from the failure signature(s) to the operator, correct the cause, and send the request again. Check the country-specific appendix for market-specific rules. For example, in Poland sales must not continue while the fiscal register is unreachable (see [Cash Register Integration (PL)](../../middleware-pl/cash-register-integration/cash-register-integration.md)). The state `0x504C_2001_EEEE_EEEE` is also returned when the outcome on the register is unknown, so the device state must be verified (for example via a Zero-Receipt) before the request is sent again (see [Response handling — ambiguous outcomes](../../middleware-pl/operation-modes/scu/posnet.md#response-handling--ambiguous-outcomes)). |

*Table 4. Recommended reactions of the POS system per error level and situation.*

:::tip

In most markets, a failed SCU (signing device or service) does not result in an error state: the Middleware continues to sign receipts in failed mode and sets the flag `0000_0002`, so the POS system can continue to operate (see [Signature Creation Unit not reachable or failing](./cash-register-integration-failure-scenarios.md#signature-creation-unit-not-reachable-or-failing)). Markets without such a fallback, for example Poland, return an error state instead.

:::
