---
slug: /poscreators/middleware-doc/digital-receipt/general/receive-receipts
title: Receiving Digital Receipts
description: Ways consumers receive digital receipts — QR-Code on a customer-facing display, Give-Away (QR-Label) and the InStore App, with sequence diagrams.
tags: [Digital receipt, QR Code, InStore App, Experience Middleware]
---

# Receiving Digital Receipts

There are various ways receipts are provided and transported towards the consumer. When a merchant uses digital receipts, it is important to teach the staff on how to use the system and to provide information on the availability of the different methods used. Not all available methods should be implemented, only the most efficient way related to the business should be used. 

## With customer facing display/device 

![qr-code_on_display](./images/sequenz_diagramm_qr-code_display.png)

*Figure 1. Sequence diagram of providing a digital receipt via a QR-Code on a customer-facing display or device.*

This sequence diagram describes the process of generating a digital receipt with a customer display, handheld or self-checkout device using the fiskaltrust digital receipt solution. The participants in the process are the merchant, fiskaltrust and the consumer. 

In store, the merchant collects the items and processes the checkout. Then the merchant sends a sign message to fiskaltrust for fiscalization purposes. The merchant then shows a QR-Code on a customer-facing display/device, which can be scanned by the consumer using their mobile phone. 

The consumer accesses the receipt by scanning the QR-Code displayed on the customer-facing display/device with their mobile phone. The consumer requests the receipt from fiskaltrust and receives an HTML document as the receipt. The consumer can then provide feedback regarding the receipt. 

Overall, this diagram illustrates the process of generating a digital receipt with customer display, handheld or self-checkout devices, where the receipt is accessed by the consumer through a QR-Code displayed on the customer-facing display/device. 

## With Give-Away (QR-Label)

![give-away](./images/sequenz_diagramm_give-awaypng.png)

*Figure 2. Sequence diagram of providing a digital receipt via Give-Away (QR-Label).*

This sequence diagram describes the process of generating a digital receipt with Give-Away (QR-Labels) using the fiskaltrust digital receipt solution. The participants in the process are the merchant, fiskaltrust and the consumer. 

In store, the cashier can flexibly scan the QR-Code label on the Give-Away during the production process or during the payment process and thus establish the connection to the receipt created. Then the merchant sends a sign message to fiskaltrust for fiscalization purposes. The merchant then hands over the Give-Away or the item with the QR-Label to the consumer.

The consumer accesses the receipt by scanning the QR-Label on the Give-Away with their mobile phone. The consumer requests the receipt from fiskaltrust and receives an HTML document as the receipt. The consumer can then provide feedback regarding the receipt. 

From the fiskaltrust.Portal, prefabricated adhesive labels can be purchased to be resold, which then serve as carriers of a QR-Code for the digital receipt. There are no delays due to the interaction of the cash register or the operating staff with the consumer, because the consumer only receives a QR-Label on a Give-Away and can retrieve the digital receipt later, regardless of time and location.

The merchants PosDealer can participate by means of placing orders and intermediary in support and billing for each transaction of the POS operator. This applies to every single receipt issued, as the giveaway is issued regardless of how it is viewed and used by the consumer. Since the cost of a QR-Code label for the digital receipt is less than one third of an 80/80/12 thermal roll at an average length of 20cm per receipt, the margin to be achieved for the PosDealer is higher than for thermal paper (if the PosDealer does not want to contribute an additional investment for giveaways in consumer satisfaction).

## With InStore App

![instore-app](./images/sequenze_diagramm_instore_app.png)

*Figure 3. Sequence diagram of providing a digital receipt via the InStore App.*

The InStore App displays the digital receipt on a device at the point of sale. The consumer can scan the QR code to receive the receipt on their mobile phone, acknowledge it with the OK button, print it, or have it sent via email or SMS. Every consumer interaction is logged in the fiskaltrust backend.

For a detailed description of this process, see [Receiving Digital Receipts with InStore App](../instore-app/introduction/introduction.md#receiving-digital-receipts-with-instore-app).
