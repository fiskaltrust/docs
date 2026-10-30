---
slug: /posdealers/buy-resell/products/revision-safe-archiving
title: Revision-safe archiving
description: Cloud-based revision-safe receipt archiving mirrored from the Middleware, with country-specific storage variants for Austria, France and Germany.
type: overview
tags: [Revision-Safe Archiving, Journal, PosDealers, Austria, France, Germany]
---

# Revision-safe archiving

In addition to basic fiscalization, fiskaltrust offers cloud-based add-ons for revision-safe storage, which is required by law in most countries with fiscalization regulations. You can implement these requirements yourself, but storing data securely for up to 12 years, as some countries require, takes a high organizational effort, for example for regular backups.

:::tip

**Revision-safe** means that data is stored in a secure and immutable way: it cannot be changed after it was saved.

:::

## Receipt archiving

fiskaltrust's cloud services are closely integrated with the fiskaltrust.Middleware, which mirrors the data to the cloud as part of its security mechanism:

- **Integrity**: the hash values of the requests and responses ensure the integrity of the data.
- **Completeness**: you can verify completeness by following the receipt hash chain.
- **Preservation**: all original records are **preserved** and **immutable**.
- **Protection against data loss**: the data is duplicated in different cloud regions.
- **Location**: the data is stored according to tax regulations, for example German receipt data in German data centers.

For more information on the hash chain, see [Security mechanism](middleware.md#security-mechanism).

## Archiving products per market

The kind of revision-safe storage depends on the requirements of the market. Storing receipts is the base product in every market. All storage products keep the data for at least as long as the tax regulations require. Select your market in the following tabs.

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