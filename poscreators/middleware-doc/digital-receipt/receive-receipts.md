---
slug: /poscreators/middleware-doc/digital-receipt/general/receive-receipts
title: Receiving Digital Receipts
---

# Receiving Digital Receipts

There are various ways receipts are provided and transported towards the consumer. When a merchant uses digital receipts, it is important to teach the staff on how to use the system and to provide information on the availability of the different methods used. Not all available methods should be implemented, only the most efficient way related to the business should be used. 

## With customer facing display/device 

![qr-code_on_display](./images/sequenz_diagramm_qr-code_display.png)

*Figure 1. Sequence diagram of providing a digital receipt via a QR-Code on a customer-facing display or device.*

This sequence diagram describes the process of generating a digital receipt with a customer display, handheld or self-checkout device using the fiskaltrust digital receipt solution. The participants in the process are the merchant, fiskaltrust and the consumer. 

In store, the merchant collects the items and processes the checkout. Then the receipt is signed and issued through fiskaltrust. Only a signed and issued receipt has a QR-Code that can be retrieved and shown to the consumer. The merchant then shows the QR-Code on a customer-facing display/device, which can be scanned by the consumer using their mobile phone. 

The consumer accesses the receipt by scanning the QR-Code displayed on the customer-facing display/device with their mobile phone. The receipt opens immediately as an HTML document (a web page) on the consumer's mobile phone. The consumer can then provide feedback regarding the receipt. 

Overall, this diagram illustrates the process of generating a digital receipt with customer display, handheld or self-checkout devices, where the receipt is accessed by the consumer through a QR-Code displayed on the customer-facing display/device. 

## With Give-Away (QR-Label)

- A give-away is any small item handed to the guest, such as a voucher, gift card or sticker, that carries a QR label. The label becomes the guest's digital receipt.
- **QR label value:** `https://r.ft.ms/?<unique value>` (sandbox: `https://r-sb.ft.ms/?<unique value>`).
  - The part after `?` identifies the give-away and must be unique per label.
  - Don't add extra parameters such as `format` or `appid`. The value is matched exactly.
- **Linking:** the label is linked to a receipt *after* the receipt has been signed and issued. The cashier scans it with the InStore App while the receipt is shown on the device. Scans before issuing, or after the receipt was accepted or timed out, are ignored.
- **Guest:** later scans the same label with their own phone and gets the digital receipt. Before it is linked, the label shows a "no digital receipt yet" page.
- **Re-linking:** a label scanned again for a later receipt points to the newest receipt.
- **Sandbox vs production:** the label's host must match the cashbox. Sandbox cashboxes use `r-sb.ft.ms`.

## With InStore App

![instore-app](./images/sequenze_diagramm_instore_app.png)

*Figure 2. Sequence diagram of providing a digital receipt via the InStore App.*

The InStore App displays the digital receipt on a device at the point of sale. The consumer can scan the QR code to receive the receipt on their mobile phone, acknowledge it with the OK button, print it, or have it sent via email or SMS. Every consumer interaction is logged in the fiskaltrust backend.

For a detailed description of this process, see [Receiving Digital Receipts with InStore App](../instore-app/introduction/introduction.md#receiving-digital-receipts-with-instore-app).
