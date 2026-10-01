---
slug: /poscreators/middleware-doc/digital-receipt/general/receive-receipts
title: Receiving Digital Receipts
---

# Receiving Digital Receipts

There are various ways receipts are provided and transported towards the consumer. When a merchant uses digital receipts, it is important to teach the staff on how to use the system and to provide information on the availability of the different methods used. Not all available methods should be implemented, only the most efficient way related to the business should be used. 

## With customer facing display/device 

```mermaid
sequenceDiagram
  accTitle: Digital receipt via QR code on a customer-facing display
  accDescr: In store the merchant collects items, processes payment or checkout and fiscalizes the receipt with fiskaltrust, then shows a QR code on a consumer-facing display or handheld; the consumer scans it with a mobile phone and gets the receipt from fiskaltrust. Later the consumer has the HTML receipt document and sends feedback to fiskaltrust.
  participant merchant
  participant fiskaltrust
  participant consumer
  Note over merchant,consumer: instore
  Note left of merchant: collect items,<br/>process payment<br/>or checkout
  merchant-)fiskaltrust: fiscalize receipt
  activate merchant
  Note right of merchant: show qr-code<br/>on consumer<br/>facing display<br/>or handheld
  Note left of consumer: scan qr-code<br/>on display<br/>with mobile phone
  consumer->>fiskaltrust: get receipt
  deactivate merchant
  Note over fiskaltrust,consumer: later
  Note left of consumer: html<br/>receipt<br/>document
  consumer--)fiskaltrust: feedback
```

*Figure 1. Sequence diagram of providing a digital receipt via a QR-Code on a customer-facing display or device.*

This sequence diagram describes the process of generating a digital receipt with a customer display, handheld or self-checkout device using the fiskaltrust digital receipt solution. The participants in the process are the merchant, fiskaltrust and the consumer. 

In store, the merchant collects the items and processes the checkout. Then the merchant sends a sign message to fiskaltrust for fiscalization purposes. The merchant then shows a QR-Code on a customer-facing display/device, which can be scanned by the consumer using their mobile phone. 

The consumer accesses the receipt by scanning the QR-Code displayed on the customer-facing display/device with their mobile phone. The consumer requests the receipt from fiskaltrust and receives an HTML document as the receipt. The consumer can then provide feedback regarding the receipt. 

Overall, this diagram illustrates the process of generating a digital receipt with customer display, handheld or self-checkout devices, where the receipt is accessed by the consumer through a QR-Code displayed on the customer-facing display/device. 

## With Give-Away (QR-Label)

```mermaid
sequenceDiagram
  accTitle: Digital receipt via give-away (QR label)
  accDescr: In store the merchant collects items, processes payment or checkout, scans the give-away while checking out, fiscalizes the receipt with fiskaltrust and hands over the item with the give-away to the consumer. Later the consumer scans the give-away with a mobile phone, gets the receipt as an HTML receipt document from fiskaltrust and sends feedback.
  participant merchant
  participant fiskaltrust
  participant consumer
  Note over merchant,consumer: instore
  Note left of merchant: collect items,<br/>process payment<br/>or checkout
  Note left of merchant: scan give-away while<br/>checkout
  merchant-)fiskaltrust: fiscalize receipt
  merchant-)consumer: hand over item with give-away
  Note over fiskaltrust,consumer: later
  Note left of consumer: scan<br/>give-away<br/>with mobile phone
  consumer->>fiskaltrust: get receipt
  Note left of consumer: html<br/>receipt<br/>document
  consumer--)fiskaltrust: feedback
```

*Figure 2. Sequence diagram of providing a digital receipt via Give-Away (QR-Label).*

This sequence diagram describes the process of generating a digital receipt with Give-Away (QR-Labels) using the fiskaltrust digital receipt solution. The participants in the process are the merchant, fiskaltrust and the consumer. 

In store, the cashier can flexibly scan the QR-Code label on the Give-Away during the production process or during the payment process and thus establish the connection to the receipt created. Then the merchant sends a sign message to fiskaltrust for fiscalization purposes. The merchant then hands over the Give-Away or the item with the QR-Label to the consumer.

The consumer accesses the receipt by scanning the QR-Label on the Give-Away with their mobile phone. The consumer requests the receipt from fiskaltrust and receives an HTML document as the receipt. The consumer can then provide feedback regarding the receipt. 

From the fiskaltrust.Portal, prefabricated adhesive labels can be purchased to be resold, which then serve as carriers of a QR-Code for the digital receipt. There are no delays due to the interaction of the cash register or the operating staff with the consumer, because the consumer only receives a QR-Label on a Give-Away and can retrieve the digital receipt later, regardless of time and location.

The merchants PosDealer can participate by means of placing orders and intermediary in support and billing for each transaction of the POS operator. This applies to every single receipt issued, as the giveaway is issued regardless of how it is viewed and used by the consumer. Since the cost of a QR-Code label for the digital receipt is less than one third of an 80/80/12 thermal roll at an average length of 20cm per receipt, the margin to be achieved for the PosDealer is higher than for thermal paper (if the PosDealer does not want to contribute an additional investment for giveaways in consumer satisfaction).

## With InStore App

```mermaid
sequenceDiagram
  accTitle: fiskaltrust receipt with instore-app
  accDescr: The merchant fiscalizes the receipt with fiskaltrust, which pushes it to the instore-app; the instore-app generates a display QR code with the https receipt link, the consumer scans it to view the HTML receipt and can give feedback, and the consumer can then acknowledge the receipt or print it via the instore-app after a 15 second countdown, with fiskaltrust logging views and prints.
  participant merchant
  participant fiskaltrust
  participant consumer
  participant app as instore-app
  Note over merchant,fiskaltrust: instore
  Note left of merchant: collect items,<br/>process payment<br/>or checkout
  merchant-)fiskaltrust: fiscalize receipt
  Note over fiskaltrust,app: instore-app scan qr-code
  fiskaltrust-)app: on push get receipt
  app-)app: generate display<br/>qr-code<br/>(https receipt link)
  Note left of consumer: scan qr-code<br/>with mobile phone
  consumer-)fiskaltrust: get https receipt link
  app-)fiskaltrust: log view
  fiskaltrust-)consumer: render receipt
  fiskaltrust-)app: on viewed, close qr-code display
  consumer-)consumer: see receipt
  Note left of consumer: html<br/>receipt<br/>document
  consumer-->>fiskaltrust: feedback
  Note over fiskaltrust,app: acknowledge
  consumer-)app: acknowledge receipt
  app-)fiskaltrust: acknowledge receipt
  fiskaltrust-)fiskaltrust: log view
  fiskaltrust-)app: on viewed, close display
  Note over fiskaltrust,app: print receipt
  consumer-)app: print receipt
  loop countdown 15s
    app-->>app: countdown
  end
  app-)app: print receipt
  app-)app: on printed, close display
  app-)fiskaltrust: print
  fiskaltrust-)fiskaltrust: log print
```

*Figure 3. Sequence diagram of providing a digital receipt via the InStore App.*

The following diagram describes the process of generating a digital receipt with the InStore App. The participants in the process are the merchant, fiskaltrust, the consumer and the InStore App.

The InStore App offers five options: scanning the QR code to receive the digital receipt on a mobile phone, tapping the OK button to manually acknowledge receipt, printing the receipt on thermal paper, sending the receipt via email, or sending it via SMS.

In-store, the merchant collects items and processes the payment or checkout. The merchant then sends a sign message to fiskaltrust for fiscalization purposes. 

- **Scan QR code:** The InStore App continuously listens to the fiskaltrust receipt backend for incoming receipt push events. When an HTTPS receipt link is received, it displays a QR code on the device screen. The consumer scans the QR code with their mobile phone and receives the HTTPS receipt link. The InStore app sends a log to the fiskaltrust backend indicating that the receipt was scanned by the consumer. The fiskaltrust backend renders the receipt, and the QR code display on the InStore App device is closed. The consumer can now access the HTML receipt document and provide feedback regarding the receipt. 

- **Acknowledge:** The consumer manually acknowledges receipt by tapping the OK button in the InStore App. The InStore app sends a log to the fiskaltrust backend indicating that the receipt was acknowledged manually. The InStore app receives a response from the fiskaltrust backend to close the display. 

- **Print receipt:** Consumers can manually initiate paper receipt printing on the InStore App device by tapping the Print button. Additionally, if there is no user interaction, a paper receipt is automatically printed after a default countdown of 15 seconds. Once the receipt is printed, the display closes and the print command is logged.

- **Send receipt via email:** Consumers can choose to receive the digital receipt via email by tapping the Send by Email button on the InStore App device. A screen will then be displayed where the consumer can enter their email address.

- **Send receipt via SMS:** Consumers can choose to receive the digital receipt via SMS by tapping the Send by SMS button on the InStore App device. A screen will then be displayed where the consumer can enter their phone number.
