---
slug: /posdealers/buy-resell/products/revision-safe-archiving
title: Revision-safe archiving
description: Cloud-based revision-safe receipt archiving mirrored from the Middleware, with country-specific storage variants for Austria, France and Germany.
tags: [Revision-Safe Archiving, Journal, PosDealers, Austria, France, Germany]
---

# Revision-safe archiving in fiskaltrust's cloud
In addition to basic fiscalization, we offer cloud-based add-ons for revision-safe storage, which is required by law in most countries with fiscalization regulations. While it's technically possible to implement these requirements by oneself, securely storing data for up to 12 years (which is required in some countries) has proven to be of high organizational effort, e.g., due to the requirement of regular backups.

:::tip tip

In this context, **revision-safe** means that data is stored in a secure and immutable way that makes it impossible to be changed after it was saved once.

:::

## Receipt archiving
fiskaltrust's cloud services are deeply integrated with the fiskaltrust.Middleware, which mirrors the data to the cloud as part of the security mechanism. Data integrity is ensured by the hash value of the requests and responses, and completeness can be verified by traversing the cash receipt hash chain. This means that all original records are **preserved** and **immutable**. Protection against data loss is ensured by duplicating the data into different cloud regions. We store data according to tax regulations, meaning that German receipt data is stored in German data centers.

## Country-specific variants
Depending on the market's requirements, we offer different kinds of revision-safe storage. Storing receipts is the _base product_ offered in each market we operate in. All storage products share the common trait that data is ensured to be stored for at least the amount of time required by tax regulations. Please select the market you're interested in below for further details.


import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import ArchiveAT from '../../_markets/at/buy-resell/products/_archive.mdx';
import ArchiveBE from '../../_markets/be/buy-resell/products/_archive.mdx';
import ArchiveFR from '../../_markets/fr/buy-resell/products/_archive.mdx';
import ArchiveDE from '../../_markets/de/buy-resell/products/_archive.mdx';
import ArchiveGR from '../../_markets/gr/buy-resell/products/_archive.mdx';
import ArchiveIT from '../../_markets/it/buy-resell/products/_archive.mdx';
import ArchivePL from '../../_markets/pl/buy-resell/products/_archive.mdx';
import ArchivePT from '../../_markets/pt/buy-resell/products/_archive.mdx';
import ArchiveES from '../../_markets/es/buy-resell/products/_archive.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <ArchiveAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <ArchiveBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <ArchiveFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <ArchiveDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <ArchiveGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <ArchiveIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <ArchivePL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <ArchivePT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <ArchiveES />
  </TabItem>

</Tabs>