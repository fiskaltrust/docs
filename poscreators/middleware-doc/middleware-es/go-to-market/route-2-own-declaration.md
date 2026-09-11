---
slug: /poscreators/middleware-doc/spain/go-to-market/own-declaration
title: "Route 2: Declaring and registering your own solution"
---

# Route 2: Declaring and registering your own solution

On this route you build your product on top of the fiskaltrust.Middleware and become the **declared producer** yourself: you sign the declaración responsable of the *Sistema Informático de Facturación* for your combined solution towards the AEAT, and you register your solution as *software garante* with one of the Basque provincial tax authorities to obtain your own TicketBAI licence code. You are responsible for everything the authorities expect from the producer: the declaration and the *memoria descriptiva*, the software identification in every record, the on-site verification screen, the certificate handling, the document layout and the operation of the system.

Choose this route when you need a self-hosted or on-device deployment, a document layout or functionality outside the [supported scope](../declaration/declaration.md#boundaries) of the fiskaltrust.Middleware for Cloud, or when your product must appear as the declared and registered software.

:::note We are looking for partners for this route

fiskaltrust has declared and registered its own Middleware, but has **not yet accompanied a partner** through a declaration or registration of their own solution built on the fiskaltrust.Middleware. The description below is based on the regulatory requirements and on fiskaltrust's own procedures; the division of responsibilities and the support described on this page are what we offer to a first partner. If you are considering this route, contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu) early so we can plan the procedure together.

:::

:::info Plan the procedure with fiskaltrust

Several values that are fixed for the fiskaltrust.Middleware for Cloud belong to the producer and must be set up for your product before the first record is transmitted: the system name, identification code and version in the `SistemaInformatico` block of every VERI\*FACTU record, and the developer NIF, software name, version and licence code in the `Software` block of every TicketBAI file. The fiskaltrust cloud signing service can carry these values per merchant account or cash box; for a self-hosted deployment they are part of the SCU configuration. Contact fiskaltrust before you submit your declaration so these are in place.

:::

## Division of responsibilities

The left column corresponds to the components that are [always provided by the fiskaltrust.Middleware](../declaration/declaration.md#what-fiskaltrust-takes-care-of); the right column is what fiskaltrust provides as producer on Route 1 and what becomes yours on this route.

| Area | Provided by the fiskaltrust.Middleware | Provided by you |
| ---- | -------------------------------------- | --------------- |
| Declaration | Description of the Middleware's mechanisms (hash, chain, transmission, export) that you can reuse in your *memoria* | The declaración responsable for your product, per version; the TicketBAI *memoria descriptiva* and registration; keeping them available for merchants and authorities |
| Software identification | Configurable `SistemaInformatico` and `Software` blocks | Your producer name and NIF, system name, identification code, version and TicketBAI licence code |
| Validation | Every request is checked against the Spanish rules before signing or transmission | Correct master data in the request: VAT nibble and nature of VAT, type of service, customer data |
| Numbering | Two sequences per queue, sequential numbering, chaining | Nothing; numbering is managed by the Middleware. If the AEAT's recommendations on series characters matter for your product, discuss the series format with fiskaltrust |
| Records and signature | VERI\*FACTU records with *huella* and chain; TicketBAI files with XAdES signature and chain; exemption and regime keys | Safekeeping of the merchant certificates in your deployment |
| Transmission | Synchronous transmission to the AEAT and to the three provinces, including the Batuz LROE wrapper for Bizkaia | Availability of your deployment; retry and monitoring of rejected records |
| Document | QR code, legend, TBAI identifier, hash and series/number as signature items | Your layout with every mandatory element of a Spanish invoice; TicketBAI placement rules for the identifier and QR code |
| On-site verification | The software identification values | The screen in your POS that shows developer, software name and version |
| Corrections | Cancellation records, validated refunds | UI that only offers these operations; corrective invoice types if your product needs them |
| Event log | Start and stop events in the action journal | The event log export (*registro de eventos*) if you operate in No VERI\*FACTU mode |
| Operations | Cloud or self-hosted Middleware | Backup and continuity, protection of certificates and database, system time control |

## The procedure in the common territory (VERI\*FACTU)

There is no approval procedure with the AEAT. The producer's obligations are:

1. **Write the declaración responsable** with the minimum content of chapter IV of *Orden HAC/1177/2024*: identification of the producer, name, identification code and version of the system, the hardware and software it runs on, the statement that the system complies with art. 29.2.j of the *Ley General Tributaria* and *Real Decreto 1007/2023*, the operating modes (VERI\*FACTU and/or No VERI\*FACTU) and the place, date and signature. The AEAT publishes an example declaration on its developer pages. fiskaltrust's own declaration additionally describes how the hash, the chaining, the response handling, the storage and the export are implemented.
2. **Describe the components.** If your product consists of components from different producers (your POS and the fiskaltrust.Middleware), each component is declared by its producer and the declarations reference each other.
3. **Make the declaration available** in the system itself or as a download, hand it to every merchant who buys the system, and keep it for the AEAT.
4. **Test against the AEAT pre-production environment.** Test certificates are requested from the AEAT with the *formulario de solicitud de certificado de pruebas*; a Spanish NIF is required. The Middleware transmits to the pre-production endpoint on sandbox queues.
5. **Keep the declaration current.** Every new version of the system needs a new declaration.

## The procedure in the Basque Country (TicketBAI)

1. **Test environment access** is requested separately from each province you want to test against: by e-mail to the technical contact of Araba or Gipuzkoa (which answer with a temporary licence code for their test environment) or to Bizkaia (which answers with test data sets for the *modelo 140* and *240*). Bizkaia provides test certificates; Araba and Gipuzkoa require a real certificate, and device certificates must be registered before use.
2. **Prepare the memoria descriptiva** according to article 11 of the provincial order (Bizkaia: *Orden Foral 1482/2020*). It must describe the type of software (desktop or distributed architecture), the chaining of the TicketBAI files, the signing process and the certificate types that can be used, the invoice types issued, the placement of the TicketBAI code and QR code, the on-site verification screen, and the storage of the files. fiskaltrust's own *memoria* covers the Middleware's part of these points and can be referenced.
3. **Register the software** online with one provincial tax authority (registration in one province is valid in all three). The registration form asks for the developer's NIF, the software name, a description, the developer's website, whether the software is prepared for Basque, and whether it is for the developer's exclusive use. A digital certificate accepted by the Basque administration (Izenpe, BakQ or another Spanish qualified certificate) is required to access the registration service.
4. **Respond to findings.** The provincial tax authority reviews the *memoria* and may answer with findings that require a revised version. Plan for at least one round.
5. **Receive the licence code** and configure it, together with your developer NIF, software name and version, for your deployment. From then on every TicketBAI file carries your identification.

## What to expect

- **The declaration is a legal statement, not a technical test.** The AEAT does not validate your system; it holds you to your declaration in an audit. Describe only what your system does.
- **The Basque registration reviews documentation, not code.** The review focuses on the completeness and precision of the *memoria*, in particular the explicit statement that non-fiscal documents carry no TicketBAI code, the formal identification of the on-site verification function, and the exact description of the chaining and signature data.
- **Certificates are the merchant's.** Both systems sign or authenticate with the merchant's certificate. If you self-host, you hold these certificates for your merchants and must protect them accordingly.
- **Corrections and special cases are yours to complete.** Corrective invoices (`R1` to `R5`), TicketBAI cancellations, vouchers, the equivalence surcharge and the No VERI\*FACTU event log are not provided by the Middleware today. If your product needs them, they become part of your declaration.

## Effort

fiskaltrust cannot yet give a reliable figure for a partner's procedure. A partner that reuses the Middleware's record generation, chaining, signature, transmission and validation starts from a much better position, but should plan for writing and maintaining the declaration per version, the registration procedure with one Basque province including at least one round of findings, and the implementation of the on-site verification screen and the document layout. fiskaltrust supports partners on this route with the documentation of the Middleware's behaviour, its own declaration and *memoria* as references, sample requests for every case, and the experience from its own procedures; contact [sales@fiskaltrust.eu](mailto:sales@fiskaltrust.eu).
