---
slug: /poscreators/middleware-doc/digital-receipt/getting-started
title: Getting Started
---

# Getting Started

In this section, the implementation steps to achieve and ensure a complete integration into your Point of Sale software are described. 

:::note

Currently the digital receipt can only be implemented into existing middleware integrations. An own standalone digital receipt API is not available yet. 

:::

This high level overview shows you the implementation and configuration steps, who are required for the digital receipt via QR-Code, Give-Away (QR-Label) and the InStore App. 

<br/>

```mermaid
flowchart TD
  accTitle: Digital receipt via QR-Code (POS API)
  accDescr: Implementation steps for the digital receipt via QR-Code with the POS API: sign the receipt with /sign, print it digitally with /print, request the receipt URL with /response and show it as a QR-Code on the customer facing display, then get the receipt status and close the display once the status is submitted.
  subgraph Sign["/sign endpoint"]
    A["POST sign receipts with /sign endpoint"]
    B["/sign request will be fiscalized by fiskaltrust.Middleware"]
  end
  subgraph Print["/print endpoint"]
    C["POST response body from /sign to /print endpoint"]
    D["Digitally &quot;print&quot; digital receipts with /print endpoint"]
  end
  subgraph Response["/response endpoint"]
    E["POST returned identifier from /print endpoint to receive URL from digital receipt"]
    F["POST returned identifier from /print endpoint to receive URL from digital receipt"]
    G["Use URL to visualize QR-Code on customer facing display"]
  end
  subgraph Print2["/print endpoint"]
    H["GET current receipt status"]
    I["Close QR-Code visualization on customer facing display, when consumer received digital receipt on his device. Receipt status = &quot;submitted&quot;"]
  end
  A --> B --> C --> D --> E --> F --> G --> H --> I
  N["POS API<br/>---<br/>Please note:<br/>Set your logo in fiskaltrust.Portal and check the master data (Company legal name, address, VAT number, etc.)<br/>Implementation of /sign endpoint optional for digital receipt"]
```

*Figure 1. High-level implementation and configuration steps for the digital receipt via QR-Code.*

<br/>

```mermaid
flowchart TD
  accTitle: Digital receipt via Give-Away (QR-Label)
  accDescr: Implementation steps for the digital receipt via Give-Away: scan and store the ReceiptTag from the QR-Label, sign the receipt with /sign including the ReceiptTag, print it digitally with /print, and the cashier hands out the goods with the QR-Label that contains the URL to the digital receipt.
  subgraph Sign["/sign endpoint"]
    A["Scan and store &quot;ReceiptTag&quot; from QR-Label"]
    B["POST sign receipts with /sign endpoint including the &quot;ReceiptTag&quot;"]
    C["/sign request will be fiscalized by fiskaltrust.Middleware"]
  end
  subgraph Print["/print endpoint"]
    D["POST response body from /sign to /print endpoint"]
    E["Digitally &quot;print&quot; digital receipts with /print endpoint"]
  end
  subgraph Cashier["Cashier"]
    F["Hands out the sold goods with the QR-Label to the consumer. The QR-Label contains the URL to the digital receipt"]
  end
  A --> B --> C --> D --> E --> F
  G["For Give-Away the POS API Helper can also be used instead of POS API. Please note, that POS API Helper needs to be configured in the fiskaltrust.Portal for each CashBox"]
  N["Give-Away (QR-Label)<br/>---<br/>Please note:<br/>Set your logo in fiskaltrust.Portal and check the master data (Company legal name, address, VAT number, etc.)<br/>Implementation of /sign endpoint optional for Give-Away"]
```

*Figure 2. High-level implementation and configuration steps for the digital receipt via Give-Away (QR-Label).*
