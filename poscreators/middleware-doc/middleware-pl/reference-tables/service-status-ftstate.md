---
slug: /poscreators/middleware-doc/poland/reference-tables/ftstate
title: 'Service Status: ftState'
description: ftState values the Polish Queue returns — out of operation and error; no failed mode, as sales must not continue without a working register (Art. 111(3) VAT Act).
tags: [ftState, Poland, Reference Tables, Failure Handling]
---

# Service Status: ftState

## Format

_CCCC_vlll_gggg_gggg_ 

#### v - version
version 2

#### gggg_gggg - global tagging/flag

The Polish Queue returns only the global flags below. Unlike in other markets, it has no "SCU temporarily out of service" mode (`0000_0002`): a receipt that the register cannot fiscalize is refused, not stored for later signing.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0000_0001` | **Security Mechanism is out of Operation**<br />Queue is not started or already stopped. | preview |
| `EEEE_EEEE` | **Error**<br />Something went wrong while processing the last request. QueueItem exists but didn’t reach the state of a ReceiptItem. Error reason is shown within the responded ftSignatureItems.<br />This happens, for example, if the ReceiptCase is not recognized or is wrong. | preview |

#### lll - local flags

The middle three nibbles carry the Polish local flags. No Polish local flags are defined at the moment: every error is returned as `0x504C_2000_EEEE_EEEE`, and the `FAILURE` signature tells the reason.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0x504C_2000_EEEE_EEEE` | **Error**<br />The request failed. A signature with the caption `FAILURE` says what to do next: if the register could not be reached, the receipt was **not** fiscalized and can be sent again once the register is reachable; if the receipt was not issued, the message says so; for a validation error, it names the field to correct. Under Art. 111(3) of the Polish VAT Act sales must not continue without a working register. There is no late-signing fallback for fiscal receipt cases in Poland. See [Failure handling](../operation-modes/scu/posnet.md#failure-handling). | preview |
