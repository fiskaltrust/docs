---
slug: /poscreators/middleware-doc/belgium/go-to-market/faq
title: FAQ
---

# FAQ for PosCreators in Belgium

These are the questions PosCreators most often ask before integrating the fiskaltrust.Middleware for the Belgian market. The answers describe what the fiskaltrust.Middleware does and what remains with the cash register system. Questions on the interpretation of the regulation are answered by the FPS Finance; where a question falls into that area, this is stated.

The requirements quoted on this page are taken from the FPS Finance technical specifications for registered cash register systems (version 2.1 of 27 August 2025), available on [geregistreerdkassasysteem.be](https://www.geregistreerdkassasysteem.be).

## Registration and scope

### Do I need a company registered in Belgium?

Not for the fiskaltrust.Middleware. You can register in the Belgian fiskaltrust.Portal, integrate against the sandbox, and roll out the fiskaltrust.Middleware to your customers without a Belgian entity.

Whether the producer of a cash register system needs a Belgian registration to apply for certification is decided by the FPS Finance. Contact the RCRS service of the FPS Finance (NCI department RCRS, secr.gksce@minfin.fed.be) for a binding answer.

### Does the obligation apply to a POS at the same site that only handles non-hospitality sales?

The scope of the obligation is defined by the regulation, not by the fiskaltrust.Middleware. Clarify it with the FPS Finance for your customers' setups.

For the fiskaltrust.Middleware the rule is simple: **everything that is sent to the fiskaltrust.Middleware is considered in scope** of the registered cash register system. There is no per-transaction exemption; the FPS Finance requires every event on a registered cash register system to be sent to the FDM. If a POS at the same site is out of scope, do not send its transactions to the fiskaltrust.Middleware for Belgium, or operate it as a separate cash register system.

Which receipt case results in which FDM event, and what is sent to the FDM, is described in [FDM event operations](./fdm-event-operations.md).

### Do we have to support every payment type and transaction scenario our software offers, even if our Belgian customers do not use them?

Which functions are tested is decided in the certification procedure of the FPS Finance. From the fiskaltrust.Middleware's side there is no need to use every feature: it maps whatever your POS sends. A pragmatic approach is to switch off functions your Belgian customers do not use in the Belgian configuration of your POS, so that the certified scope matches what the POS actually offers.

How payment types, VAT codes, and transaction lines are mapped to the FDM is described in [FDM event operations](./fdm-event-operations.md#mapping-of-the-fiskaltrust-data-model).

## Architecture and operation

### Where is the FDM installed, and how does the fiskaltrust.Middleware connect to it?

The POS does not connect to the FDM. It connects to the fiskaltrust.Middleware, and the fiskaltrust.Middleware connects to the FDM (see [Architecture](./go-to-market.md#architecture)).

- The fiskaltrust.Middleware can be managed by fiskaltrust in the cloud (**fiskaltrust.Middleware for Cloud**), or operated locally on **Windows, Linux, or Android**. In both cases it reaches the FDM over HTTPS. With the fiskaltrust.Middleware for Cloud, no cable or Wi-Fi connection between the POS terminal and an FDM is needed on site. See [Operation Modes](../../general/operation-modes/operation-modes.md).
- The fiskaltrust.Middleware currently supports the FDM of **ZwarteDoos**. It authenticates with the FDM's device ID and shared secret, which are part of the fiskaltrust.Middleware configuration in the fiskaltrust.Portal, together with the merchant's VAT number and establishment unit number.
- One FDM configuration belongs to one establishment unit. Several terminals of the same cash register system are distinguished by `cbTerminalID`, which the fiskaltrust.Middleware sends as `terminalId`.
- If the connection to the FDM runs over the internet and the connection fails, the cash register system can no longer register sales. Plan the internet connection of the site accordingly.

:::caution Disclaimer

The distributor or installer is responsible for the correct and secure installation and configuration of the connection to the FDM.

:::

### Must the POS wait for the FDM before completing a transaction, and what happens after payment?

Yes. The FPS Finance requires that a transaction cannot be completed until the FDM has signed it, and that sales may only be registered while the FDM is connected and working. Unlike in some other markets, there is no offline mode in which the fiskaltrust.Middleware signs receipts later.

In the fiskaltrust.Middleware this works as follows:

1. The POS sends the `ReceiptRequest` to `/sign`. The call is synchronous: the fiskaltrust.Middleware sends the event to the FDM and waits for its answer.
2. If the FDM signs the event, the response contains the signature items (`DigitalSignature`, `ShortSignature`, `VerificationUrl`). Only then does the POS print or send the VAT receipt.
3. If the FDM refuses the event or cannot be reached, the response is marked as failed, contains no FDM signature, and carries the error message. The POS must not issue a VAT receipt. It keeps the transaction open, shows the error to the user, and sends it again once the cause is resolved.

**Payment already taken.** The fiskaltrust.Middleware registers the sale; it does not move money. A card payment that was already authorised remains valid while the POS retries the registration. Only if the sale cannot be registered at all must the payment be reversed with the payment provider, outside the fiskaltrust.Middleware. To keep this case rare:

- Register the sale right after the payment is confirmed and before the customer leaves.
- For interrupted sales (table service, web orders), register the orders on the way as PRO FORMA events, so that the final sale only closes an already registered transaction (`signOrder` is in development, see [FDM event operations](./fdm-event-operations.md)).
- If the call to the fiskaltrust.Middleware times out, send the same request again with the *ReceiptRequest* flag (`0x8000`). The fiskaltrust.Middleware returns the stored result if the receipt was already processed, so the sale is not registered twice. See [Failure Scenarios](../../general/cash-register-integration/cash-register-integration-failure-scenarios.md).

### Does fiskaltrust take over the data retention and data integrity requirements?

In part. The FPS Finance makes the **taxpayer** responsible for retaining the data of the cash register system and of the FDM, and the **producer** of the cash register system responsible for describing the database and its security mechanisms in the certification application.

What the fiskaltrust.Middleware covers:

- Every `ReceiptRequest`, the GraphQL request sent to the FDM, the FDM's response, and the resulting `ReceiptResponse` are stored in the journals of the fiskaltrust.Middleware, in their original form. The FDM request and response are included in `ftStateData` of each response.
- The journals are append-only; processed receipts are never changed or deleted.
- The data can be exported at any time as JSON through the journal endpoint, for example for an inspection.
- fiskaltrust provides the description of the fiskaltrust.Middleware's data storage and security mechanisms for your certification application.

What remains with you and your customers:

- Data the POS keeps outside the fiskaltrust.Middleware: master data, user administration including the INSZ of every user and its link to the identification printed on the receipt, and any event data the POS stores itself.
- Presenting the data in readable form on request, and the hardware requirement that the cash register provides at least one port for an external data carrier (for example USB).
- The retention period itself. The taxpayer remains responsible for keeping the data for the legal retention period; agree with fiskaltrust how long the cloud journals are kept for your customers, or export them regularly.

### Does the software version have to be shown in channels other than the POS, e.g. the customer-facing website?

The display requirements for the user interface are defined by the regulation; ask the FPS Finance whether they apply to your web channel.

From the fiskaltrust.Middleware's side, every channel is treated alike. Every event sent to the FDM carries the software version of the cash register system (`posSwVersion`), whether it comes from a POS terminal, a kiosk, or a web shop. For web and kiosk orders the FPS Finance also requires:

- the robot user `00000000029` as `employeeId`, passed in `cbUser`;
- the web shop's URL, or the name of the ordering platform, as the identification of the input device.

The way the POS passes its software version and the input-device identification to the fiskaltrust.Middleware is being added to the PosSystem API mapping.

## FDM operations

### Does fiskaltrust support all FDM event operations?

The fiskaltrust.Middleware implements the request formats of all fifteen mutations (`signWorkIn`, `signWorkOut`, `signInvoice`, `signSale`, `signCostCenterChange`, `signOrder`, `signPreBill`, `signMoneyInOut`, `signDrawerOpen`, `signPaymentCorrection`, `signReportTurnoverX`, `signReportTurnoverZ`, `signReportUserX`, `signReportUserZ`, `signCopy`). Their mapping to receipt cases is being added step by step. Today `signSale` (including refunds and training mode) and `signReportTurnoverZ` are available in the sandbox.

The [FDM event operations](./fdm-event-operations.md) page lists every mutation with its receipt case and status. fiskaltrust walks through the supported operations with you in the sandbox; contact your fiskaltrust account manager to schedule a session.
