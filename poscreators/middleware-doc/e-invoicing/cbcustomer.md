---
slug: /poscreators/middleware-doc/e-invoicing/cbcustomer
title: Buyer data (cbCustomer)
---

# Buyer data (`cbCustomer`) in eInvoicing

This page maps the fields of [`cbCustomer`](../general/data-structures/data-structures.md#cbcustomer) to the buyer fields of the European eInvoicing standard **EN 16931**. The national formats (XRechnung, ZUGFeRD / Factur-X, Peppol BIS Billing) are profiles of EN 16931 and use the same business terms (BT). For how invoices and invoice types are handled, see [Invoices and invoice types](./overview.md#invoices-and-invoice-types).

EN 16931-1 is published by CEN and is not freely available. The links in the following table point to the [Peppol BIS Billing 3.0](https://docs.peppol.eu/poacc/billing/3.0/bis/) syntax reference, which documents every EN 16931 business term with its UBL element.

## Field mapping

| `cbCustomer` field | EN 16931 business term | UBL element |
| --- | --- | --- |
| `CustomerName` | BT-44 Buyer name | [`cac:PartyLegalEntity/cbc:RegistrationName`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PartyLegalEntity/cbc-RegistrationName/) |
| `CustomerId` | BT-46 Buyer identifier | [`cac:PartyIdentification/cbc:ID`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PartyIdentification/cbc-ID/) |
| `CustomerStreet` | BT-50 Buyer address line 1 | [`cac:PostalAddress/cbc:StreetName`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PostalAddress/cbc-StreetName/) |
| `CustomerZip` | BT-53 Buyer post code | [`cac:PostalAddress/cbc:PostalZone`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PostalAddress/cbc-PostalZone/) |
| `CustomerCity` | BT-52 Buyer city | [`cac:PostalAddress/cbc:CityName`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PostalAddress/cbc-CityName/) |
| `CustomerCountrySubentity` | BT-54 Buyer country subdivision | [`cac:PostalAddress/cbc:CountrySubentity`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PostalAddress/cbc-CountrySubentity/) |
| `CustomerCountry` | BT-55 Buyer country code | [`cac:PostalAddress/cac:Country/cbc:IdentificationCode`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PostalAddress/cac-Country/cbc-IdentificationCode/) |
| `CustomerVATId` | BT-48 Buyer VAT identifier | [`cac:PartyTaxScheme/cbc:CompanyID`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cac-PartyTaxScheme/cbc-CompanyID/) |
| `CustomerEndpointId` | BT-49 Buyer electronic address and BT-49-1 scheme identifier | [`cbc:EndpointID`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-AccountingCustomerParty/cac-Party/cbc-EndpointID/) and its `schemeID` attribute |
| `CustomerReference` | BT-10 Buyer reference | [`cbc:BuyerReference`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cbc-BuyerReference/) |
| `CustomerTaxId` | – | – |

*Table 1. Mapping of `cbCustomer` fields to EN 16931 business terms. UBL elements of the buyer party are relative to `cac:AccountingCustomerParty/cac:Party`.*

## Mapping rules

- **`CustomerEndpointId`** is split at the first colon: the part before it is written to BT-49-1 (the `schemeID` attribute), the part after it to BT-49.
- **`CustomerReference`**: if it is empty and `CustomerEndpointId` uses scheme `0204`, the Leitweg-ID is written to BT-10.
- **`CustomerTaxId`** has no EN 16931 business term, because EN 16931 has no tax number of the buyer other than the VAT identifier. National formats can read it, for example FatturaPA as `CodiceFiscale`.
