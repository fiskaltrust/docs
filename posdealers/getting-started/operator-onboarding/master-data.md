---
slug: /posdealers/getting-started/operator-onboarding/master-data
title: Master Data
description: Why complete master data matters and how to check company data, tax numbers and outlets in the fiskaltrust.Portal.
tags: [Master Data, Onboarding, Portal, PosDealers]
---
# Master Data

:::info summary
After reading this, you can keep your own and your PosOperators' master data up to date and explain why that is important.
:::

## Why master data matters

The **master data** of a company is essential in the fiskaltrust.Portal:

- **Accounting** between fiskaltrust and you as a PosDealer requires complete and verified master data.
- **Signing devices and services**: to set up and use them, PosDealers and PosOperators need at least one of their tax identification numbers. For more information, see [Signing devices and services](../../buy-resell/products/signing/signing-overview.md).
- **Authentication** towards fiscal authorities or [third-party integrations](../../buy-resell/products/3rd-party/3rd-party-overview.md) requires the tax registration numbers.

**Outlets** are the locations of a PosOperator's business, for example shops, event locations, or production, distribution and administration sites. Check the outlet data, because:

- **Tax regulations** in some countries require exact data on the primary outlet and further outlets.
- **Shipping hardware** via the fiskaltrust.Portal requires exact address details.

## Which data to check

- **Company master data**: check it for completeness and use the available check mechanisms. Country-specific check mechanisms verify, depending on the legal situation and the technical equipment of the fiscal administration, whether an entered value meets the formal requirements. Depending on the country, when a PosOperator is registered for the first time, further master data can be retrieved from the relevant authority and checked by entering a tax number.
- **User data** (user menu at the top right > `Edit profile`): only needed for using the fiskaltrust.Portal. For data protection reasons, you can use function designations (like **fiscalizing**) or fictitious names instead of real names. The e-mail address, however, must be real and working, because it is used to sign in to the fiskaltrust.Portal. To avoid real names, use a functional address (like fiscalizing@PosOperator.TLD).
- **PosOperators' master data**: check it for completeness and correctness in the same way as your own.

The following sections show how to check your own master data. After you have done this and invited your PosOperators, switch to each PosOperator's account and check their master data the same way. For more information, see [Surrogating](surrogating.md).

## Check the master data

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import PreviewAT from '../../_markets/at/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewBE from '../../_markets/be/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewFR from '../../_markets/fr/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewDE from '../../_markets/de/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewGR from '../../_markets/gr/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewIT from '../../_markets/it/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewPL from '../../_markets/pl/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewPT from '../../_markets/pt/getting-started/operator-onboarding/master-data/_edit-master.mdx';
import PreviewES from '../../_markets/es/getting-started/operator-onboarding/master-data/_edit-master.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <PreviewAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <PreviewBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <PreviewFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <PreviewDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <PreviewGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <PreviewIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <PreviewPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <PreviewPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <PreviewES />
  </TabItem>

</Tabs>

## Check the outlets

:::info Outlet numbers
- `Outlet number 1` is assigned automatically when an account is created in the fiskaltrust.Portal.
- `Outlet number 2` is not available.
- When you create an outlet manually, you can set the `Outlet number` yourself.
- Once an `Outlet number` has been set, it cannot be changed.
:::

import OutletAT from '../../_markets/at/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletBE from '../../_markets/be/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletFR from '../../_markets/fr/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletDE from '../../_markets/de/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletGR from '../../_markets/gr/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletIT from '../../_markets/it/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletPL from '../../_markets/pl/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletPT from '../../_markets/pt/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';
import OutletES from '../../_markets/es/getting-started/operator-onboarding/master-data/_checking-outlets.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <OutletAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <OutletBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <OutletFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <OutletDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <OutletGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <OutletIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <OutletPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <OutletPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <OutletES />
  </TabItem>

</Tabs>

### Edit outlets

import EditOutletAT from '../../_markets/at/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletBE from '../../_markets/be/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletFR from '../../_markets/fr/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletDE from '../../_markets/de/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletGR from '../../_markets/gr/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletIT from '../../_markets/it/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletPL from '../../_markets/pl/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletPT from '../../_markets/pt/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';
import EditOutletES from '../../_markets/es/getting-started/operator-onboarding/master-data/_edit-outlet.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <EditOutletAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <EditOutletBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <EditOutletFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <EditOutletDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <EditOutletGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <EditOutletIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <EditOutletPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <EditOutletPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <EditOutletES />
  </TabItem>

</Tabs>
