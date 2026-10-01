---
slug: /poscreators/middleware-doc/austria/cash-register-integration
title: Cash Register Integration
---

# Cash Register Integration

This chapter describes the cash register integration following the Austrian law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of the general part.

## Receipt Creation Process

This chapter describes the general process of creating receipts with fiskaltrust.Middleware and its workflow, following the Austrian law.

### The fiskaltrust.SecurityMechanism

The regular workflow of the fiskaltrust.SecurityMechanism in the Austrian market defines the steps required for the creation of a receipt as follows:

  - assign a sequential receipt number
  - increase the cumulative sales counter according to the RKSV
  - encrypt the cumulative sales counter
  - create a signature
  - create machine-readable code according to the RKSV and
  - create all other necessary receipts
  - save all data

![Diagram: POS exchanges requests and responses with the fiskaltrust.Middleware via the POS-Interface; the SignatureCard handles RKSV duties like signing, DCL and FinanzOnline](./images/12.png)

*Figure 1. Process of the cash register integration (AT) with the fiskaltrust.SecurityMechanism (AT - RKSVO).*

### Workflow - regular operation

The following diagram illustrates the regular creation of a receipt with fiskaltrust.Middleware following Austrian law.

```mermaid
flowchart TD
  accTitle: Workflow - regular operation (AT)
  accDescr: Flowchart of regular operation: the POS collects charge and pay items, sends a fiskaltrust.ReceiptRequest via fiskaltrust.iPOS to the Queue, the signature creation unit calculates the signature value, and the returned fiskaltrust.ReceiptResponse drives receipt generation.
  A(["Input station:<br/>Collect charge items and pay items"])
  J(["Input station: Receipt generation"])
  K["Input station: Receipt"]
  B[("Server:<br/>Database cash register")]
  C{"Server:<br/>Business transaction"}
  I[("Server:<br/>Database cash register")]
  D[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  E[["Queue: Process ReceiptRequest"]]
  G[["Queue: Prepare signature block"]]
  L[("Queue:<br/>RKSV-DCL<br/>+E131-DCL<br/>+ Action journal")]
  F[["Signature creation unit:<br/>Calculate signature value"]]
  A --> B
  B --> C
  C --> D
  C --> J
  D --> E
  E --> F
  E --> G
  F --> G
  G --> H
  G --> L
  H --> I
  I --> J
  J --> K
```

*Figure 2. Workflow of the regular receipt creation operation (AT - RKSVO).*

### Workflow - special receipts

The following diagram illustrates the creation of a special receipt with fiskaltrust.Middleware following Austrian law.

```mermaid
flowchart TD
  accTitle: Workflow - special receipts (AT)
  accDescr: Flowchart for special receipts (initial-, zero-, collective-, closing-receipt, shift-, daily-, monthly-, yearly-tally): a special request with zero-receipt goes via fiskaltrust.iPOS to the Queue, which executes it, gets a signature value and returns a fiskaltrust.ReceiptResponse, with an optional FON report and FON review.
  A(["Input station:<br/>Start special request with zero-receipt"])
  J(["Input station: Receipt generation"])
  K["Input station: Receipt"]
  B[("Server:<br/>Database cash register")]
  I[("Server:<br/>Database cash register")]
  C[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  D[["Queue: Process ReceiptRequest"]]
  E[["Queue: Execute special request"]]
  G[["Queue: Prepare signature block"]]
  L[("Queue:<br/>RKSV-DCL<br/>+ E131-DCL<br/>+ Action journal")]
  M["Queue:<br/>FON-report<br/>FON-review"]
  F[["Signature creation unit:<br/>Calculate signature value"]]
  A --> B
  A --> J
  B --> C
  C --> D
  D --> E
  E --> F
  E --> G
  F --> G
  G --> H
  G --> L
  L -.-> M
  H --> I
  I --> J
  J --> K
```

*Figure 3. Workflow of special receipts (AT): initial-, zero-, collective-, closing-, shift-, daily-, monthly- and yearly-tally receipts (AT - RKSVO).*

### Workflow - failure of the signature creation unit (queue timeout)

The following diagram illustrates the workflow of a failure of the signature creation device following Austrian law.

```mermaid
flowchart TD
  accTitle: Workflow - failure of the signature creation device (queue timeout) (AT)
  accDescr: Flowchart for the first receipt failing to reach the signature creation unit: the Queue retries calculating the signature value, then prepares a signature block noting security mechanism failed, sets ftState 0x02 for all further receipts, and the sales receipt is printed as security mechanism failed.
  A(["Input station:<br/>Collect charge items and pay items"])
  J(["Input station: Receipt generation"])
  K["Input station:<br/>Sales receipt<br/>„security mechanism failed“"]
  B[("Server:<br/>Database cash register")]
  C{"Server:<br/>Business transaction"}
  I[("Server:<br/>Database cash register")]
  D[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  E[["Queue: Process ReceiptRequest"]]
  E2[["Queue:<br/>Timeout or error calculating<br/>signature value retries"]]
  G[["Queue:<br/>Prepare signature block with note<br/>„security mechanism failed“"]]
  G2[["Queue:<br/>ftState |= 0x02<br/>„security mechanism failed“<br/>for all further receipts"]]
  L[("Queue:<br/>RKSV-DCL<br/>+ E131-DCL<br/>+ Action journal")]
  F1[["Signature creation unit:<br/>Calculate signature value"]]
  F2[["Signature creation unit:<br/>Calculate signature value"]]
  A --> B
  B --> C
  C --> D
  C --> J
  D --> E
  E <-.-> F1
  E --> E2
  E2 <-.-> F2
  E2 --> G
  G --> G2
  G2 --> H
  G2 --> L
  H --> I
  I --> J
  J --> K
```

*Figure 4. Workflow of a signature creation device failure (queue timeout) (AT - RKSVO).*

```mermaid
flowchart TD
  accTitle: Workflow - failure of the signature creation device (wrong state) (AT)
  accDescr: Flowchart for further receipts processed while the signature creation unit is in a failed state: if ftState |= 0x02 the Queue skips calculating the signature value, prepares a signature block noting security mechanism failed, and after more than 48 hours a FON report follows.
  A(["Input station:<br/>Collect charge items and pay items"])
  J(["Input station: Receipt generation"])
  K["Input station:<br/>Sales receipt<br/>„security mechanism failed“"]
  B[("Server:<br/>Database cash register")]
  C{"Server:<br/>Business transaction"}
  I[("Server:<br/>Database cash register")]
  D[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  E[["Queue: Process ReceiptRequest"]]
  S{"Queue:<br/>ftState |= 0x02"}
  G[["Queue:<br/>Prepare signature block with note<br/>„security mechanism failed“"]]
  L[("Queue:<br/>RKSV DCL<br/>+ E131 DCL<br/>+ Action journal")]
  T{"Queue: >48h"}
  M["Queue: FON report"]
  F[["Signature creation unit:<br/>Calculate signature value"]]
  A --> B
  B --> C
  C --> D
  C --> J
  D --> E
  E --> S
  S -- No --> F
  S --> G
  G --> H
  G --> L
  L --> T
  T -.-> M
  H --> I
  I --> J
  J --> K
```

*Figure 5. Workflow of a signature creation device failure (wrong state) (AT - RKSVO).*

```mermaid
flowchart TD
  accTitle: Workflow - failure of the signature creation device (signature creation unit timeout) (AT)
  accDescr: Flowchart for stop mode using a collective-receipt: after a timeout error of the signature creation unit the Queue prepares a signature block noting security mechanism failed in stop mode, and after more than 48 hours a FON report follows.
  A(["Input station:<br/>Start special request with zero-receipt"])
  J(["Input station: Receipt generation"])
  K["Input station: Receipt"]
  B[("Server:<br/>Database cash register")]
  I[("Server:<br/>Database cash register")]
  C[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  D[["Queue: Process ReceiptRequest"]]
  X{"Queue:<br/>Timeout error"}
  G[["Queue:<br/>Prepare signature block with note<br/>„security mechanism failed“<br/>stop mode"]]
  L[("Queue:<br/>RKSV-DCL<br/>+ E131-DCL<br/>+ Action journal")]
  T{"Queue: >48h"}
  M["Queue: FON-report"]
  F[["Signature creation unit:<br/>Calculate signature value"]]
  Y[/"Signature creation unit:<br/>Failure of the signature creation unit<br/>(queue timeout)"\]
  A --> B
  B --> C
  C --> D
  D --> F
  F --> X
  X -- Yes --> Y
  X -- No --> G
  G --> H
  G --> L
  L --> T
  T -.-> M
  H --> I
  I --> J
  J --> K
```

*Figure 6. Workflow of a signature creation device failure (SCD timeout) (AT - RKSVO).*

### Workflow - failure of the fiskaltrust.SecurityMechanism (network error)

The following diagram illustrates the workflow of a failure of the fiskaltrust.SecurityMechanism following the Austrian law.

```mermaid
flowchart TD
  accTitle: Workflow - failure of the fiskaltrust.Middleware (network error) (AT)
  accDescr: Flowchart for a receipt failing to reach the fiskaltrust.Service: if the ReceiptRequest times out with a network error, the POS marks the receipt to be used later as proof of loss and to be sent again, retries, and prints a sales receipt marked security mechanism failed without a machine-readable code, otherwise regular operation continues.
  A(["Input station:<br/>Collect charge items and pay items"])
  J(["Input station: Receipt generation"])
  K["Input station:<br/>Sales receipt<br/>„security mechanism failed“<br/>(no machine readable code)"]
  B[("Server:<br/>Database cash register")]
  C{"Server:<br/>Business transaction"}
  R[["Server:<br/>Mark receipt to be used later<br/>as proof of loss, send again<br/>to the fiskaltrust.Service"]]
  I[("Server:<br/>Database cash register")]
  D[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  X{"fiskaltrust.iPOS:<br/>Timeout<br/>ReceiptRequest == null<br/>network error"}
  Z[\"Queue: regular operation"/]
  A --> B
  B --> C
  C --> D
  C --> J
  D --> X
  X -- Yes --> R
  X -- No --> Z
  R -- Retry --> C
  R --> I
  I --> J
  J --> K
```

*Figure 7. Workflow of a fiskaltrust.SecurityMechanism failure (network error) (AT - RKSVO).*

```mermaid
flowchart TD
  accTitle: Workflow - failure of the fiskaltrust.Middleware (recover after more than 48 hours) (AT)
  accDescr: Flowchart for data entry at a later stage: the POS starts data entry with a collective receipt, the Queue processes it and calculates the signature value, after the last outage receipt the POS ends data entry with a zero receipt, and for an outage over 48 hours a FON report follows.
  A(["Input station:<br/>start data entry at a later stage<br/>using a collective receipt"])
  J(["Input station: generation"])
  K["Input station: Receipt"]
  B[("Server:<br/>Database cash register")]
  Z[["Server:<br/>end data entry at a later stage<br/>using a zero receipt"]]
  O{"Server:<br/>Last Outage receipt"}
  I[("Server:<br/>Database cash register")]
  C[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptRequest"/]
  H[/"fiskaltrust.iPOS:<br/>fiskaltrust.ReceiptResponse"/]
  D[["Queue: Process ReceiptRequest"]]
  E[["Queue:<br/>end data entry at a later stage<br/>using a collective receipt"]]
  G[["Queue: Prepare signature block"]]
  L[("Queue:<br/>RKSV DCL<br/>+ E131 DCL<br/>+ Action journal")]
  T{"Queue:<br/>Outage>48h"}
  M["Queue: FON report"]
  F[["Signature creation unit:<br/>Calculate signature value"]]
  A --> B
  B --> C
  C --> D
  D --> E
  E --> F
  E --> G
  F --> G
  G --> H
  G --> L
  L --> T
  T -.-> M
  H --> I
  I --> O
  O --> Z
  Z --> B
  I --> J
  J --> K
```

*Figure 8. Workflow of a fiskaltrust.Middleware failure (recovery after more than 48 hours) (AT - RKSVO).*

## Receipt for special functions

This section describes receipt types used for special functions on the Austrian market and expands on the descriptions from the Chapter ["Receipt for special functions"](../../general/cash-register-integration/cash-register-integration-regular-workflow.md#receipt-for-special-functions) of the general part.

In accordance with §131b para. 2 BAO and the RKSV, as per 1.1.2017 (now 1.4.2017), each transaction receipt needs to be cryptographically signed with a signature creation device assigned to the taxpayer, to guarantee the immutability of the recording. In addition to these receipts, several other requirements are stated by the RKSV which can be met by creating the following receipts with special functions.

### Zero Receipt

You can find examples of special cases of zero receipts applicable to the Austrian market in the following chapters.

### Start Receipt (Initial Receipt)

There are many RKSV requirements for implementing a new, or a replaced security mechanism (RKSV-DEP). A new data collection log (RKSV-DEP) must be started, with the register ID used as a start value for the signature linking. An initial receipt must be issued after the implementation and must be checked for correctness. Such check is at fiskaltrust a verification if the certificate serial number of the data record corresponds with the number registered in the BMF security mechanisms database and if the signature matches the certificate's public key code.

The PosOperator must archive this receipt.

### Stop Receipt (Closing Receipt)

In case of a scheduled decommissioning of a security mechanism or a cash register, the RKSV requires a generation of a closing receipt. The closing receipt concludes the data collection log (RKSV-DEP) and has to be archived.

At fiskaltrust.SecurityMechanisms, a scheduled decommissioning triggers after returning the data to the cash register and discarding the currently used certificate (so that the signature creation device (security mechanism) cannot issue any more valid signatures). Within the framework of the data collection log (RKSV-DEP), the certificate remains preserved. In the case of decommissioning, a "FinanzOnline" (finance online) notification is required (it will also be created through the fiskaltrust.SecurityMechanism).

Once the queue has been closed with a stop receipt, no hashing and signing of receipts will be done for that queue.

### End of Failure Receipt (Collective Failure Report)

If, for technical reasons, signatures cannot be created by fiskaltrust.SecurityMechanisms, receipts need to be issued (according to the RKSV) and marked with a comment "security mechanism failed". Once the technical failure has been resolved, a signed collective receipt must be issued to make up for the signature linking of all receipts issued during the technical failure.

Furthermore, you can find two fundamentally different types of failure distinguished by fiskaltrust.SecurityMechanisms:

### Signature Creation Device Failure

A signature creation device failure must be assumed if fiskaltrust.SecurityMechanisms cannot communicate with the signature creation device temporarily. This can happen when e.g. the chip-card reader is faulty.

In case of a signature creation device failure, the machine-readable code from fiskaltrust.SecurityMechanisms (following the RKSV) is processed and sent back to the cash register. The status of the fiskaltrust.SecurityMechanism is communicated to the cash register input station with every response. The failure status can only be terminated through a zero receipt. Requesting the zero receipt can be done automatically through the input station or manually by the user.

The PosOperator must report a non-temporary failure (longer than 48 hours) of the signature creation device through FinanzOnline without undue delay. Afterwards, the return to service also must be reported through FinanzOnline. These reports are automatically done through the extension of the fiskaltrust.Carefree package.

### fiskaltrust.SecurityMechanism Failure

A fiskaltrust.SecurityMechanism failure means that there is no access to the RKSV-DEP. If the failure lasts for more than 48 hours, the PosOperator must trigger a failure notification via FinanzOnline. When using fiskaltrust.Carefree, this notification is sent automatically. Otherwise, the notification regarding the reporting requirement is issued on the failure zero receipt.

### Monthly Receipt

Before the beginning of a new monthly period, the preliminary result of the cumulative sales counter (monthly counter) has to be recorded accordingly to §8 Abs 2 RKSV. The cash register can request this monthly receipt via zero receipt from fiskaltrust.SecurityMechanisms for this purpose. The running sales counter is sent back to the cash register within the charge items block in an unencrypted format.

### Annual Receipt

Before the beginning of a new annual period, the PosOperator must note the counter reading in accordance with §8 para. 3 RKSV. This procedure replaces the monthly receipt at the end of the year. As an additional requirement, the signature's correctness on this annual receipt needs to be checked against the database through fiskaltrust.SecurityMechanisms. When using fiskaltrust.Carefree, the check is processed automatically. Otherwise, the PosOperator can do it manually through the BMF App, which is available at:

https://www.bmf.gv.at/services/apps.html

## Receipt structure

This chapter describes the receipt structure applicable to the Austrian market.

![Receipt structure: request blocks from POS to fiskaltrust, response blocks back to POS incl. signature block, and the merged printed receipt](./images/20.png)

*Figure 9. Receipt structure (AT): cash register receipt data (header, charge items, pay items, footer) and fiskaltrust receipt data (header, charge items, pay items, signature, footer) (AT - RKSVO).*

### Receipt Header

Following §132a para. 3 BAO, the receipt header should receive a label or a logo of the issuing company (see figure above) already from the cash register. For example, it is necessary for annual receipts where the heading "Annual Receipt" is added to a zero receipt (receipt with a value of zero).

### Charge Items Block

The charge items block on the cash register receipt contains the services (quantity and customary description of the purchased goods or type and extent of other services following §132a para. 3 Z 4 BAO or else in the form of symbols, code numbers or reference displayed).

As previously mentioned, a Charge Items block can be extended through the fiskaltrust.SecurityMechanism. An example of such an extension is the monthly receipt where the sum of current business transactions (cumulative sales counter) is listed as a charge item within the charge items block of a zero receipt at the end of the month.

### Pay Items Block

According to the RKSV, there are currently no specific applications where the pay items block should be extended.

### Signature Block

If a cryptographic signature is required by §131b para. 2 BAO the signature block is generated by the fiskaltrust.SecurityMechanism. This includes receipt signature as required by RKSV, information about the signature format, and potential further details such as references to training or reverse posting, or an operational failure of the signature creation device. The cash register should contain the signature block between the Pay Items block and the Receipt Footer.

### Receipt Footer

According to the RKSV, there is currently no specific information where the footer should be extended.

## Data Collection Log

The RKSV defines the following logging features as obligatory for cash registers.

### Data Collection Log according to RKSV (RKSV-DEP)

The fiskaltrust.SecurityMechanism autonomously manages the RKSV-DEP. We recommend saving the values returned from the fiskaltrust.SecurityMechanism in the cash register's database. A connection between the return values and the receipt is established through the receipt reference of the cash register request and the receipt ID of the fiskaltrust.ReceiptResponse.

Data from the data collection log can also be provided in the form of a data stream, following the format specified by the RKSV.

When using the fiskaltrust.Carefree package, the RKSV-DEP is automated timely and saved in an external cloud, which is revision-safe and cannot be altered by the user.

### Data Collection Log according to §131 para. 1 Z 6 b BAO (E131-DEP)

A E131-DEP, conducted by Cash Register, can be sent to fiskaltrust.SecurityMechanisms.

When using the fiskaltrust.Carefree package, the E131-DEP is automated timely and saved in an external cloud, which is revision-safe and cannot be altered by the user.
