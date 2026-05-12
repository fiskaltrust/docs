---
title: Delivery
slug: /poscreators/experience-middleware/delivery
---

# Delivery

The **Delivery** component in the Experience Middleware defines how invoices and receipts are handed over to customers after checkout.

It combines point-of-sale processes with customer-facing delivery channels so merchants can offer compliant handover options while keeping the experience simple and consistent.

## Supported and Planned Delivery Formats

The following formats are currently supported or planned in the Experience Middleware delivery journey:

| Format | Status | Description |
|--------|--------|-------------|
| Digital receipt | Supported | Receipt is delivered through digital channels, for example QR code, HTTPS link, email, or message-based delivery flows. |
| Printed receipt | Supported | Receipt is printed at the point of sale as a paper handover option. |
| Structured invoices | Supported | Invoice information is provided in structured data formats for downstream processing and integrations. |
| E-invoicing | In progress | Electronic invoicing flows are being prepared to support market and regulatory requirements. |

## Delivery Journey

Delivery is designed as a full journey, not only a final output format.

1. The POS completes the sale and fiscalization process.
2. fiskaltrust links transaction, payment, and receipt/invoice data.
3. The merchant or checkout flow selects the preferred delivery format.
4. The customer receives the document in the selected channel.
5. The delivered receipt or invoice remains available for later access, depending on the selected flow.

## Point-of-Sale Perspective

From the POS perspective, delivery should stay operationally simple:

- One integration flow should support multiple delivery formats.
- Delivery can be handled digitally, on paper, or in structured invoice form.
- The POS can adapt delivery based on merchant setup, market expectations, and customer choice.

## Customer Perspective

From the customer perspective, delivery should be flexible and easy to use:

- Customers can receive their documents in a way that fits their checkout context.
- Digital channels reduce paper dependency and improve later access.
- Printed output remains available where required or preferred.
- Invoice and receipt handover should feel consistent across channels.

## Goal

The goal of the Delivery component is to support a unified handover experience across receipts and invoices, bridging checkout operations with customer communication while keeping room for ongoing expansion such as e-invoicing.
