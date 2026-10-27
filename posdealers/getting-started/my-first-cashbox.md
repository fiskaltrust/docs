---
slug: /posdealers/getting-started/my-first-cashbox
title: My First Cashbox
description: Creating a first CashBox as a PosDealer with a Business Rollout plan or manual configuration, then running a test request.
tags: [CashBox, Rollout Plans, Middleware, Onboarding, PosDealers]
---
# My First Cashbox

:::info summary

After reading this, you can create a CashBox in the Sandbox and have a functioning fiskaltrust.Middleware instance.

:::

As a PosDealer, you have two options to create your first CashBox in the fiskaltrust.Portal:

- **Rollout management (recommended)**: the deployment wizards of the Portal. They create, buy and set up CashBoxes and related components for your PosOperators, and you can select several PosOperators and outlets at the same time. For more information, see [Rollout management](#rollout-management).
- **Manual configuration**: you create the components yourself. First read [Architecture](../business-basics/architecture.md) to learn which components a CashBox needs, then follow [Manual CashBox Creation](../technical-operations/middleware/manual-configuration.md).

Both options require the legal and commercial preparations described earlier in this documentation. They are summarized under [Prerequisites](#prerequisites).

:::tip

Use your [Sandbox](sandbox.md) account to avoid charges on your account.

If you do not have a Sandbox account yet, ask your PosCreator for an invitation or [register](registration.md) a new PosDealer Sandbox account yourself.

:::

![Workflow with two swimlanes, PosDealer account and PosOperator account: the PosDealer checks the prerequisites and decides whether to use a rollout plan. With a rollout plan, a Business Rollout for one or more PosOperators and a Technical Rollout follow. Without, the SCU, an optional Helper, the Queue and the CashBox are created manually in the PosOperator account. Both ways continue with rebuilding the CashBox, downloading the Launcher, and starting the Middleware and testing](./images/my-first-cashbox/first-cashbox-flowchart.svg)

*Figure 1. Workflow for creating your first CashBox.*

## Prerequisites

Before you roll out a Middleware instance, make sure that the following prerequisites are in place:

- A working **Internet connection**. For more information, see [Network Requirements](../technical-operations/middleware/network-requirements.md).
- An active **PosDealer account** in the fiskaltrust.Portal (Sandbox), either by [registration](registration.md) or by invitation through your PosCreator. In the `PosSystems` menu, check that a `PosSystemId` is available. This menu is not available in PosOperator accounts.
- Checked **master data** and at least one **outlet**. For more information, see [Master data](operator-onboarding/master-data.md).
- For a local Middleware installation: a system that meets the **hardware and software requirements**. For more information, see [Supported Environments](../technical-operations/middleware/supported-environments.md).
- Any **SSCD components** (hardware or SaaS credentials) that the setup requires, unless the setup itself creates them.

## Rollout management

### Business Rollout

A Business Rollout follows these steps:

1. Select the **product** you want to roll out.
2. Select one or more **PosOperators** for the rollout.
3. Select one or more **outlets** for the rollout.
4. Create a **quote** and load it into your **shopping cart**.
5. Complete the **checkout**.

The following example walks through these steps for your own account in the Sandbox.

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

import BusinessRolloutAT from '../_markets/at/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutBE from '../_markets/be/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutFR from '../_markets/fr/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutDE from '../_markets/de/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutGR from '../_markets/gr/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutIT from '../_markets/it/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutPL from '../_markets/pl/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutPT from '../_markets/pt/getting-started/my-first-cashbox/_business.mdx';
import BusinessRolloutES from '../_markets/es/getting-started/my-first-cashbox/_business.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <BusinessRolloutAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <BusinessRolloutBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <BusinessRolloutFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <BusinessRolloutDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <BusinessRolloutGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <BusinessRolloutIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <BusinessRolloutPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <BusinessRolloutPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <BusinessRolloutES />
  </TabItem>

</Tabs>

## Start the Middleware

The CashBox configuration determines how the Middleware runs:

- **CloudCashbox**: fiskaltrust operates the Middleware, so you do not download anything. To connect, use the URL in the Queue configuration. For more information, see [CloudCashbox](../technical-operations/middleware/launchers/cloudcashbox.md).
- **Local Middleware**: in `Configuration` > `CashBoxes`, click `Download` in the row of your CashBox to download the Launcher, then start it. The Launcher fetches the CashBox configuration each time it starts, so configuration changes apply after a restart. For more information, see [Windows, Linux & macOS](../technical-operations/middleware/launchers/desktop.md) and [Android](../technical-operations/middleware/launchers/android.md).

## Run a test request

After the Middleware is deployed and started, check that it is available and responds to requests.

The Middleware provides an echo request that returns the data it receives. If you get a response, the Middleware is also ready to accept signing requests.

:::tip Postman collection

For Postman, you can download a request collection from the [GitHub repository](https://github.com/fiskaltrust/middleware-demo-postman).

:::

### Request details

import EchoAT from '../_markets/at/getting-started/my-first-cashbox/_echo.mdx';
import EchoBE from '../_markets/be/getting-started/my-first-cashbox/_echo.mdx';
import EchoFR from '../_markets/fr/getting-started/my-first-cashbox/_echo.mdx';
import EchoDE from '../_markets/de/getting-started/my-first-cashbox/_echo.mdx';
import EchoGR from '../_markets/gr/getting-started/my-first-cashbox/_echo.mdx';
import EchoIT from '../_markets/it/getting-started/my-first-cashbox/_echo.mdx';
import EchoPL from '../_markets/pl/getting-started/my-first-cashbox/_echo.mdx';
import EchoPT from '../_markets/pt/getting-started/my-first-cashbox/_echo.mdx';
import EchoES from '../_markets/es/getting-started/my-first-cashbox/_echo.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <EchoAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <EchoBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <EchoFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <EchoDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <EchoGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <EchoIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <EchoPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <EchoPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <EchoES />
  </TabItem>

</Tabs>
