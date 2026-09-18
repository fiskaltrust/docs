---
slug: /business-basics/legal-data-protection/data-protection
title: Data Protection
---
# Data Protection

:::info summary

After reading this, you can explain what we do to ensure data protection.

:::

## What we store

| Category | Examples |
| -------- | -------- |
| Customer data | Name, address, contact details, VAT identification number and orders of PosCreators, PosDealers and PosOperators |
| Configuration and state data | ClientId, queue state |
| Mass data | `ReceiptRequest` and `ReceiptResponse` |
| Revision-secured mass data | Archives |
| Revision-secured general customer data | Invoices, contracts, and anything else stored manually against the customer record |

*Table 1. Categories of data processed by fiskaltrust.*

## Where we process and store it

Customer data is held in a **separate Dynamics 365 instance per country**, in the EMEA region. General workloads are processed in Western Europe, and CPU-intensive workloads in Northern Europe and in the Austrian data centre.

Processing takes place in Azure West Europe, Azure Germany West Central, Azure France Central, the [Equinix data centre in Amsterdam](https://www.equinix.com/data-centers/europe-colocation/netherlands-colocation/amsterdam-data-centers) and the [RRZ data centre in Raaba near Graz](https://www.rrz.co.at/).

Some markets deviate from this pattern, because national rules require data to stay in the country. Those cases are listed below.

## Country-specific information

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import DataAT from '../../_markets/at/overview/legal-data-protection/data-protection/_data.mdx';
import DataFR from '../../_markets/fr/overview/legal-data-protection/data-protection/_data.mdx';
import DataDE from '../../_markets/de/overview/legal-data-protection/data-protection/_data.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
      <DataAT />
  </TabItem>

  <TabItem value="FR" label="France">
      <DataFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
      <DataDE />
  </TabItem>

</Tabs>


