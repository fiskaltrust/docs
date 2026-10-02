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

![Flowchart for the QR-Code digital receipt: /sign, /print, response endpoint URL shown as QR code on customer display, then status check](./images/getting_started_qr-code.png)

*Figure 1. High-level implementation and configuration steps for the digital receipt via QR-Code.*

<br/>

![Flowchart for Give-Away: scan ReceiptTag from QR-Label, /sign including it, /print, and cashier hands out goods with the QR-Label](./images/getting_started_give-away.png)

*Figure 2. High-level implementation and configuration steps for the digital receipt via Give-Away (QR-Label).*
