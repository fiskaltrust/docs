---
slug: /posdealers/getting-started/operator-onboarding/master-data
title: Master Data
description: Why complete master data matters and how to check company data, tax numbers and outlets in the fiskaltrust.Portal.
tags: [Master Data, Onboarding, Portal, PosDealers]
---
# Master Data

:::info summary
After reading this, you can keep your and the PosOperators Master data up-to-date and explain why that is important.
:::

## Introduction

The **Master data** of a company are essential for various reasons in the fiskaltrust.Portal:  

* **Accounting** between fiskaltrust and you as PosDealer requires complete and verified Master data.  

* To set up and use various [**signing devices and services**](../../buy-resell/products/signing/signing-overview.md) PosDealer and PosOperator need at least one of their tax identification numbers. 

* For **authentication** towards fiscal authorities or [third-party integrations](../../buy-resell/products/3rd-party/3rd-party-overview.md) Tax registration numbers are essential.  

**Outlets** are the locations of a PosOperator's enterprise, for example shops, event locations or production, distribution and administration sites. A company's outlets data is significant and should be checked:

* **Tax regulations** in some countries require exact data on the primary outlet and further outlets.

* **Shipping hardware** via the fiskaltrust.Portal requires exact address details.

### Work steps to check Master data

It is essential to check the completeness of Master data in the fiskaltrust.Portal. Country-specific check mechanisms are also available for checking the data entered.
Such check mechanisms check, depending on the legal situation and the technical equipment of the fiscal administration, whether an entered value meets the formal requirements.   
Under country-specific circumstances, when a PosOperator is first registered, the other Master data can be retrieved from the relevant authority and checked by entering a tax number.

After logging on to the fiskaltrust.Portal, as a PosDealer, you should check the completeness and use the available checking mechanisms.

The information about the user at `[USERNAME]` / `Data` is only essential for using the fiskaltrust.Portal. For data protection reasons, function designations (like _fiscalizing_) or fictitious names can also be used instead of accurate data.  
But the E-Mail address must be a real, working one because you use this address for login to the fiskaltrust.Portal. You can avoid using real names using functional designations (like fiscalizing@PosOperator.TLD).

For PosOperators, it is equally essential to check the Master data for completeness and correctness. 

To illustrate the processes of checking and validating Master data, we show the procedure for checking your Master data in detail.  
Having this and the import of PosOperators done, you use surrogating to change into the account of your PosOperators. Please refer to the section [Surrogating](surrogating.md) to check the Master data for completeness and correctness.

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

### Work steps to check outlets

:::info **Outlet numbers**
When creating an Outlet manually, you can edit the `Outlet number` yourself. 
`Outlet number 1` is automatically assigned when creating an account in the fiskaltrust.Portal. 
`Outlet number 2` is not available.
Once an `Outlet number` has been set, it cannot be subsequently changed.
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


#### Edit outlets

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
