---
slug: /poscreators/middleware-doc/poland/reference-tables/ftstate
title: 'Service Status: ftState'
---

# Service Status: ftState

## Format

_CCCC_vlll_gggg_gggg_ 

#### v - version
version 2

#### gggg_gggg - global tagging/flag

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0000_0001` | **Security Mechanism is out of Operation**<br />Queue is not started or already stopped. | preview |
| `0000_0002` | **SCU (Signature Creation Unit) temporary out of service**<br />For at least one receipt, it was not possible to receive the signature from an allocated SCU, therefore the security mechanism has been put into "signature creation device out of service" mode. Regardless of whether an allocated SCU is available again or not, the mode remains in place until a ZeroReceipt cleans up the state and takes the market specific action required. | preview |
| `0000_0040` | **Message Pending**<br />Middleware/Queue is a headless background service, but there are situations where communication with the cashier/operator or the cash register is necessary. By executing a ZeroReceipt, the cashier can read the message or instruction on the printed or displayed receipt. | preview |
| `0000_0100` | **DailyClosing due**<br />When the first cbReceiptMoment used since the last DailyClosing and the current/latest cbReceiptMoment in the ReceiptRequest have a date-gap of more than two days, then this state indicates, a Daily Closing should be done.<br />In Poland the daily closing triggers the daily (Z) report on the register. | preview |
| `EEEE_EEEE` | **Error**<br />Something went wrong while processing the last request. QueueItem exists but didn’t reach the state of a ReceiptItem. Error reason is shown within the responded ftSignatureItems.<br />This happens, for example, if the ReceiptCase is not recognized or is wrong. | preview |
| `FFFF_FFFF` | **Fail**<br />Something went wrong while processing the last request, and nothing persisted within the Queue. Fail reason is shown within the responded ftSignatureItems. | preview |

#### lll - local flags

The middle three nibbles carry the Polish local flags. The lowest local-flag bit marks **"fiscal register unreachable"** — in Poland a non-working register legally means no sale (Art. 111(3) VAT Act), so this failure is distinguishable from any other error.

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0x504C_2000_EEEE_EEEE` | **Error**<br />The request failed for a reason other than register unavailability. The error reason is shown within the responded ftSignatureItems. | preview |
| `0x504C_2001_EEEE_EEEE` | **Register unreachable (DeviceUnreachableError)**<br />The certified register could not be reached, so the receipt was **not** fiscalized. Under Art. 111(3) of the Polish VAT Act sales must not continue without a working register — the POS must stop selling and surface the failure to the operator. There is no late-signing fallback for fiscal receipt cases in Poland. | preview |
