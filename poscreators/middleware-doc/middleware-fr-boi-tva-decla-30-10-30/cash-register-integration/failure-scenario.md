---
slug: /poscreators/middleware-doc/france/failure-scenario
title: Failure Scenario
---

## Failure Scenario

This chapter describes the failure scenario and how to handle it in accordance with French law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of this document.

### Middleware not reachable or failing


If a cash register cannot communicate with the fiskaltrust.Middleware it is most likely due to a failure of the network connection, the Middleware host, or the Middleware itself. Such a failure means that the electronic recording system is not operational and there is no access to the appropriate journal.

```mermaid
flowchart TD
    accTitle: Cash register unable to connect to the Queue
    accDescr: The POS server persists the charge and pay items and sends a sign request, the Queue is not reachable, so the server marks the data to be sent later again, persists it, and the terminal prints a receipt with the hint "Sicherheitsmechanismus ausgefallen".
    S1["Terminal:<br/>1.<br/>collect charge and<br/>pay items"]
    S6["Terminal:<br/>6.<br/>print receipt with<br/>hint: #quot;Sicherheits<br/>mechanismus<br/>ausgefallen#quot;"]
    S2["Server:<br/>2.<br/>persist data"]
    S3["Server:<br/>3.<br/>send<br/>sign request"]
    DB[("Server:<br/>DB")]
    S5["Server:<br/>5.<br/>persist data"]
    S4["Server:<br/>4.<br/>mark data to be<br/>send later again"]
    Q[("Queue")]
    S1 --> S2
    S2 --> S3
    S3 -- "Queue is not<br/>reachable" --x Q
    S3 --> S4
    S4 --> S5
    S5 --> S6
    S2 <--> DB
    DB <--> S5
```

*Figure 1. Cash register unable to connect to the fiskaltrust.Middleware.*


If the cash register doesn’t receive a response from the Middleware (e.g., due to a network or server outage), the following steps should be taken:


  - The cash register or input station  must automatically generate a receipt and a copy of it.
  - The receipt should be labeled with "mode dégradé" (degraded mode) and include the current failure counter.
  - The receipt copy should be stored until the problem is resolved. The cash register can store this copy electronically.
  - Once the Middleware is reachable again, send all receipts marked as "receipt copy, electronic recording system failed" to the Middleware.
  - Mark these receipts with the "failed receipt" flag to indicate the issue. The flag can be found in the [Reference Table Chapter - ftReceiptCaseFlag](../../general/reference-tables/reference-tables.md#ftreceiptcaseflag).
  The Middleware will respond with a "Late Signing Mode" status.

```mermaid
flowchart TD
    accTitle: Queue responding with Late-Signing-Mode
    accDescr: The terminal starts post recording, the POS server loads the next marked request, flags it with 0x0000000000010000 and sends the sign request, the Queue switches to Late-Signing-Mode and returns ft.State 0x08, and the server processes the response, persists the data and repeats with the next marked request while the terminal composes and prints the receipt.
    S1["Terminal:<br/>1.<br/>start post<br/>recording"]
    S6["Terminal:<br/>6.<br/>compose<br/>and print receipt"]
    S2["Server:<br/>2.<br/>load next marked<br/>request and flag it<br/>(0x0000000000010000)"]
    S3["Server:<br/>3.<br/>send<br/>sign request"]
    DB[("Server:<br/>DB")]
    S5["Server:<br/>5.<br/>persist data"]
    S4["Server:<br/>4.<br/>process<br/>response"]
    N["Switch to<br/>Late-Signing-<br/>Mode"]
    Q[("Queue")]
    SCU["SCU"]
    S1 --> S2
    S2 --> S3
    S3 --> Q
    N -.- Q
    Q --> SCU
    SCU --> Q
    Q -- "ft.State = 0x08<br/>(Late-Signing-Mode)" --> S4
    S4 --> S5
    S5 --> S6
    S5 --> S2
    S2 <--> DB
    DB <--> S5
```

*Figure 2. Middleware responding with the Late Signing Mode status.*

Mark these receipts with the "failed receipt" code to indicate the issue. The Middleware will respond with a "Late Signing Mode" status.

```mermaid
flowchart TD
    accTitle: End of Late-Signing-Mode with a zero receipt
    accDescr: The terminal triggers the end of post recording, the POS server persists the data and sends a zero receipt sign request, the Queue ends Late-Signing-Mode and returns ft.State 0x00 (success), and the server processes the response and persists the data before the terminal composes and prints the receipt.
    S1["Terminal:<br/>1.<br/>trigger<br/>functionality<br/>(end post<br/>recording)"]
    S6["Terminal:<br/>6.<br/>compose and print<br/>receipt"]
    S2["Server:<br/>2.<br/>persist data"]
    S3["Server:<br/>3.<br/>send<br/>sign request<br/>(zero receipt)"]
    DB[("Server:<br/>DB")]
    S5["Server:<br/>5.<br/>persist data"]
    S4["Server:<br/>4.<br/>process<br/>response"]
    N["Late-Signing-<br/>Mode is ended"]
    Q[("Queue")]
    SCU["SCU"]
    S1 --> S2
    S2 --> S3
    S3 -- "zero receipt" --> Q
    N -.- Q
    Q --> SCU
    SCU --> Q
    Q -- "ft.State = 0x00<br/>(success)" --> S4
    S4 --> S5
    S5 --> S6
    S2 <--> DB
    DB <--> S5
```

*Figure 3. End of Late Signing Mode after the failed receipts are re-sent.*

:::tip

We recommend re-sending the first failed receipt with the receipt request flag 0x0000800000000000. This ensures that if the receipt was already sent but the response was lost (e.g., due to a network issue), the Middleware will retrieve and return the original receipt. More details about this flag can be found [here](../../general/reference-tables/reference-tables.md#ftreceiptcaseflag)

:::