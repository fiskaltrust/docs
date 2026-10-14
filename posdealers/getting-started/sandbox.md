---
slug: /posdealers/getting-started/sandbox
title: Sandbox
description: What the fiskaltrust Sandbox offers for testing and demos, how it differs from the live system, and its URLs per market.
tags: [Sandbox, Portal, Onboarding, PosDealers]
---

# Sandbox

:::info summary

After reading this, you can set up and use the Sandbox for testing and demos.

:::

The Sandbox is the fiskaltrust "playground": a full copy of the live system where you can **explore the Middleware, the Portal and all associated systems freely and at no cost**. Use it to test integrations, build proof-of-concept setups and run demos before going live.

## Differences from the live system

* **No credit limits**: nothing needs to be set up by the sales team.
* **No payment** is required to activate paid features.
* Signatures are for **testing only** and are **not fiscally compliant**.
* **No SLA** applies.

The Sandbox is entirely separate from the live system, and no data is transferred between the two. As a result:

* You need **separate accounts** for the Sandbox and the live system.
* A CashBox created in the Sandbox **cannot be used in production**, and a live CashBox cannot be used in the Sandbox.

:::caution

Never deploy a Sandbox CashBox on a production system. Its signatures are not fiscally compliant and will not pass an audit.

**Receipts signed in the Sandbox must print the Sandbox signature.**

:::

## How to reach the Sandbox

All Sandbox systems use the same names as their live counterparts, with a `-sandbox` suffix (for example, `portal` &rarr; `portal-sandbox`). The exact URL depends on your market. Select your country:

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import DetailsAT from '../_markets/at/getting-started/sandbox/_details.mdx';
import DetailsBE from '../_markets/be/getting-started/sandbox/_details.mdx';
import DetailsFR from '../_markets/fr/getting-started/sandbox/_details.mdx';
import DetailsDE from '../_markets/de/getting-started/sandbox/_details.mdx';
import DetailsGR from '../_markets/gr/getting-started/sandbox/_details.mdx';
import DetailsIT from '../_markets/it/getting-started/sandbox/_details.mdx';
import DetailsPL from '../_markets/pl/getting-started/sandbox/_details.mdx';
import DetailsPT from '../_markets/pt/getting-started/sandbox/_details.mdx';
import DetailsES from '../_markets/es/getting-started/sandbox/_details.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <DetailsAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <DetailsBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <DetailsFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <DetailsDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <DetailsGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <DetailsIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <DetailsPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <DetailsPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <DetailsES />
  </TabItem>

</Tabs>