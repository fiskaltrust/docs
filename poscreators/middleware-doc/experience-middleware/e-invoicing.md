---
title: E-Invoicing
slug: /poscreators/experience-middleware/e-invoicing
---

# E-Invoicing

**E-Invoicing** (electronic invoicing) enables businesses to exchange invoice documents in a structured, machine-readable format rather than as unstructured PDF files or paper. As an integral part of the **Experience Middleware**, fiskaltrust provides a unified E-Invoicing integration so that POS, ERP, and e-commerce systems can generate and deliver compliant e-invoices through a single interface — regardless of country-specific formats or delivery networks.

## Why E-Invoicing Matters

E-Invoicing is rapidly becoming a legal requirement across Europe and beyond. Tax authorities are mandating that businesses — particularly in B2B and B2G (government procurement) contexts — submit structured invoice data, either as a direct exchange between trading partners or as a fiscal report to government authorities.

For POS and ERP operators, the key implications are:

- **Compliance deadlines are country-specific and approaching fast.** Germany, France, Belgium, Poland, Italy, and others have enacted or announced mandatory e-invoicing for B2B transactions, often phased by company size.
- **Paper or PDF invoices are no longer sufficient.** Tax authorities require structured data they can validate and cross-reference automatically.
- **Fiscalization and e-invoicing are increasingly converging.** In several markets, e-invoicing is part of the continuous transaction control model, which overlaps directly with fiscal middleware responsibilities.

By handling E-Invoicing inside the Experience Middleware, fiskaltrust ensures that the transition to mandatory e-invoicing does not require a separate integration project for systems already using the fiskaltrust.Middleware.

## Terminology

The following terms are used throughout E-Invoicing documentation and regulatory texts.

| Term | Description |
|------|-------------|
| **eInvoice** | A structured, machine-readable invoice document that complies with an agreed-upon data standard (such as EN 16931). Unlike a PDF, an eInvoice can be processed automatically by the recipient's accounting or ERP system. |
| **eDelivery** | The network or transport mechanism used to send an eInvoice from the sender to the recipient. Common delivery networks include the **Peppol** network and direct web service APIs. eDelivery is separate from the invoice format itself. |
| **eReporting** | The obligation in some countries to report invoice data (or summaries) to a tax authority, either in real time or on a periodic basis. eReporting does not always mean exchanging an invoice with the buyer — in some models, only the tax authority receives the data. |
| **EN 16931** | The European standard for the semantic data model of an electronic invoice. Most country-specific formats (XRechnung, Peppol BIS, Factur-X) are implementations of or extensions to EN 16931. |
| **Peppol** | An international network and set of interoperability standards (OpenPeppol) that allows businesses to exchange electronic documents — including invoices — through a shared access point infrastructure. |
| **Peppol BIS Billing** | A Peppol-compliant invoice format based on EN 16931, widely used in public sector procurement across Europe and beyond. |
| **XRechnung** | Germany's mandatory e-invoice standard for B2G invoicing, based on EN 16931. |
| **ZUGFeRD / Factur-X** | A hybrid PDF/XML invoice format co-developed by German and French standardization bodies. It embeds a structured XML invoice inside a human-readable PDF, satisfying both readability and machine-processing requirements. |
| **FatturaPA** | Italy's mandatory XML e-invoice format for B2G and B2B invoicing, routed via the government-operated SDI interchange system. |
| **B2G** | Business-to-Government invoicing: invoices sent from a supplier to a public authority. E-invoicing is already mandatory in this context in most EU countries. |
| **B2B** | Business-to-Business invoicing: invoices exchanged between private companies. Mandatory e-invoicing for B2B is being rolled out progressively across Europe. |
| **Access Point** | A certified service provider that connects a sender or receiver to the Peppol network for document exchange. |
| **CTC (Continuous Transaction Controls)** | A regulatory model in which tax authorities receive invoice data in real time or near-real time, rather than in periodic reports. Italy's SDI and Spain's SII are prominent examples. |

## Formats vs. Delivery Channels

E-Invoicing requires thinking about two separate concerns: **what format the invoice document uses** and **how that document reaches its destination**.

### Invoice Formats

| Format | Standard | Key Markets | Notes |
|--------|----------|-------------|-------|
| Peppol BIS Billing 3.0 | EN 16931 (UBL/CII) | EU-wide, Nordic, AU, SG | Interoperable across Peppol-connected countries |
| XRechnung | EN 16931 (UBL/CII) | Germany | Mandatory for B2G; increasingly relevant for B2B |
| ZUGFeRD 2.x / Factur-X | EN 16931 (embedded XML) | Germany, France | Hybrid PDF+XML; useful for human and machine readability |
| FatturaPA | Italian national standard | Italy | Mandatory B2G and B2B; routed via SDI |
| FacturaE | Spanish national standard | Spain | Required for B2G |
| CFDI | Mexican national standard | Mexico | Mandatory B2B, issued via authorized certification providers (PAC) |

### Delivery Channels

| Channel | Description | Typical Use |
|---------|-------------|-------------|
| Peppol Network | Structured peer-to-peer exchange via certified access points | B2G and B2B across EU and internationally |
| Government Portal / SDI | Direct submission to a tax authority portal (e.g., Italy SDI, German ZRE) | B2G, and B2B in CTC markets |
| Email / SFTP | Direct transmission, sometimes accepted alongside structured formats | Bilateral B2B agreements |
| POS System API | fiskaltrust's own integration point for POS and ERP systems to submit e-invoices | Supported through Experience Middleware |

## Regulatory Models

Different countries take different approaches to e-invoicing mandates. Understanding the model in your target market determines what type of integration is needed.

| Model | Description | Example Countries |
|-------|-------------|-------------------|
| **Post-audit** | Invoices are exchanged directly between trading partners in any agreed format; audits happen after the fact. | Germany (transitioning), Netherlands |
| **Clearance** | Invoices must be submitted to a tax authority for validation (clearance) before or immediately after being sent to the buyer. | Italy (SDI), Mexico (CFDI via PAC) |
| **Decentralized Continuous Transaction Controls (DCTC)** | Invoices are transmitted via a government-approved network without a central clearinghouse, with real-time reporting to tax authorities. | France (Chorus Pro network, in rollout) |
| **Reporting-only (eReporting)** | Structured invoice data is periodically reported to tax authorities, even when the invoice itself is exchanged freely between parties. | Spain (SII), planned Germany B2B |

## How fiskaltrust Handles E-Invoicing in the Middleware

fiskaltrust integrates E-Invoicing as an additional capability within the **Experience Middleware**, building on the same ReceiptRequest/ReceiptResponse flow used for fiscal receipts.

### Integration Overview

POS, ERP, and e-commerce systems communicate with fiskaltrust through the **POS System API**. When a transaction requires an e-invoice (either by business logic or by regulatory mandate), the POS system includes the relevant recipient and invoice data in the ReceiptRequest. The Middleware then:

1. **Generates a compliant e-invoice** in the required format for the target country (e.g., XRechnung for German B2G, Peppol BIS for cross-border B2B).
2. **Delivers the invoice** via the appropriate channel — Peppol access point, government portal, or direct delivery endpoint.
3. **Links the e-invoice to the fiscal receipt**, maintaining a consistent audit trail across both the fiscalization and invoicing records.
4. **Returns confirmation and references** in the ReceiptResponse, including any acknowledgement or clearance tokens provided by the delivery network or tax authority.

### Key Design Principles

- **Single integration point**: POS systems do not need separate integrations per country or per e-invoice format. fiskaltrust handles format translation and delivery routing internally.
- **Fiscal receipt and e-invoice are linked**: The same transaction produces both a compliant fiscal receipt and a compliant e-invoice, ensuring consistency between VAT declarations and invoice records.
- **Incremental adoption**: E-Invoicing is additive. Systems already integrated with fiskaltrust for fiscal compliance can extend to e-invoicing without rebuilding their middleware connection.
- **Country-specific rules are abstracted**: Regulatory differences (clearance vs. post-audit, format variations, reporting obligations) are handled by the Middleware, not by the POS system.

### Typical Integration Flow

```
POS/ERP System
     │
     │  ReceiptRequest (with invoice recipient data)
     ▼
fiskaltrust Middleware (Experience Middleware)
     │
     ├─► Fiscal processing (signing, journaling)
     │
     ├─► E-Invoice generation (EN 16931, country format)
     │
     └─► E-Invoice delivery (Peppol / SDI / portal)
     │
     │  ReceiptResponse (with invoice reference + delivery status)
     ▼
POS/ERP System
```

## Country and Market Overview

The following table summarizes the E-Invoicing landscape in markets where fiskaltrust operates or plans to operate.

| Country | B2G Status | B2B Status | Primary Format | Delivery | fiskaltrust Status |
|---------|-----------|-----------|----------------|----------|--------------------|
| **Germany (DE)** | Mandatory (XRechnung) | Mandatory from 2025–2028 (phased) | XRechnung, ZUGFeRD, Peppol BIS | Peppol, ZRE/OZG-RE portals | In roadmap |
| **Austria (AT)** | Mandatory (ebInterface / Peppol) | Voluntary | ebInterface, Peppol BIS | Peppol, government portal | In roadmap |
| **France (FR)** | Mandatory (Chorus Pro) | Mandatory rollout 2026–2027 | Factur-X, UBL, CII | Chorus Pro, PDP operators | In roadmap |
| **Italy (IT)** | Mandatory (FatturaPA) | Mandatory (FatturaPA) | FatturaPA (XML) | SDI (government clearance) | In roadmap |
| **Portugal (PT)** | Mandatory | B2B reform in progress | CIUS-PT / Peppol BIS | Peppol, ESPAP portal | In roadmap |
| **Belgium (BE)** | Mandatory (Peppol) | Mandatory from 2026 | Peppol BIS | Peppol | In roadmap |
| **Spain (ES)** | Mandatory (FacturaE) | SII real-time reporting | FacturaE, Peppol BIS | Peppol, AEAT portal | In roadmap |

> **Note:** Roadmap timelines and country availability are subject to change. For the latest status, contact your fiskaltrust account team or visit the [fiskaltrust Portal](https://portal.fiskaltrust.cloud).

## FAQ

### Is E-Invoicing the same as a digital receipt?

No. A **digital receipt** is a consumer-facing document confirming a retail transaction. An **e-invoice** is a structured B2B or B2G document exchanged between a seller and a business buyer (or a government authority) for accounting and VAT purposes. fiskaltrust supports both, but they serve different purposes and comply with different regulations.

### Do I need to change my POS integration to support E-Invoicing?

The Experience Middleware is designed for minimal change. Systems already integrated via the POS System API need to supply additional invoice recipient data (buyer name, address, VAT ID, delivery endpoint) in the ReceiptRequest. The format and delivery are handled by fiskaltrust.

### Can I use E-Invoicing without fiskaltrust fiscalization?

In most markets, E-Invoicing through the Experience Middleware is designed to complement fiscal compliance. However, for markets where fiskaltrust does not currently provide fiscal middleware, standalone e-invoicing availability may differ. Contact fiskaltrust for your specific scenario.

### Which e-invoice formats are supported?

The supported formats depend on the target country and the applicable regulatory model. fiskaltrust targets EN 16931-compliant formats (including Peppol BIS, XRechnung, ZUGFeRD/Factur-X) as well as country-specific formats where required (FatturaPA, ebInterface, FacturaE). See the country overview table above for details.

### Where can I find more technical detail on the POS System API fields for e-invoices?

Refer to the fiskaltrust interface documentation and the [Middleware API reference](https://docs.fiskaltrust.cloud) for ReceiptRequest and ReceiptResponse field descriptions. For country-specific field mappings, see the relevant country middleware documentation in this portal.

## Next Steps

- Review the [Experience Middleware Introduction](./introduction.md) for an overview of all Experience components.
- Explore the [Compliance Middleware documentation](/docs/poscreators/get-started) for country-specific fiscal requirements that often align with e-invoicing mandates.
- Contact [fiskaltrust support](https://portal.fiskaltrust.cloud) to discuss E-Invoicing availability and rollout timelines for your target markets.
