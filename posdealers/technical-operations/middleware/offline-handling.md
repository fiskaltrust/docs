---
slug: /posdealers/technical-operations/middleware/offline-handling
title: Offline Handling
description: What happens when the Middleware, the signature device or the internet connection is not available, and what PosDealers and PosOperators must do in each market.
tags: [Offline, Failure Handling, Middleware, PosDealers]
---
# Offline Handling

:::info summary

After reading this, you know which Middleware setups depend on an internet connection and what you and the PosOperator must do during and after an outage in each market.

:::

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Introduction

Offline means every situation in which the POS system does not receive a processed response from the Middleware, whatever the reason:

- The network between the POS system and the Middleware fails, for example the local network or Wi-Fi, or the internet connection of the location to the CloudCashbox.
- The device or server on which the Middleware runs is switched off, has no power or fails.
- The Middleware has not been started, has been stopped or has crashed.
- The request times out or the connection is interrupted.
- The Middleware cannot store the request, for example because it has no access to its database.
- The whole POS system is down, for example during a power outage.

In addition, the Middleware itself can lose its connection to the signature device, signing service or tax authority while the POS system still reaches it. Whether a POS system may continue to sell in these situations, and what must be done afterwards, depends on the market.

The implementation in the POS system is described for PosCreators in [Offline Handling](../../../poscreators/middleware-doc/general/cash-register-integration/offline-handling.md).

## Which setups depend on an internet connection

| Setup | Internet needed for each receipt | Effect of an internet outage |
|-------|----------------------------------|------------------------------|
| Middleware and hardware signature device on site | No | The POS system keeps fiscalizing. |
| Middleware on site, cloud signing service | Yes | The Middleware cannot reach the signing service. |
| Middleware hosted by fiskaltrust (CloudCashbox) | Yes | The POS system cannot reach the Middleware. |

*Table 1. Effect of an internet outage per setup.*

In markets where every document is transmitted to the tax authority in real time, every receipt needs an internet connection regardless of the setup. Independent of signing, a locally installed Middleware needs access to the fiskaltrust cloud for its configuration, updates and the upload of receipt data. For the hostnames, see [Network Requirements](./network-requirements.md).

## Before an outage

- **Plan the internet connection** of every location according to the setup and the market.
- **Make sure the POS system supports the offline procedure of the market**, for example buffering receipts, recording handwritten receipts or stopping sales.
- **Train the PosOperator** to recognize a failure state on the POS system and to send a Zero-Receipt once the cause is resolved.

## Market-specific rules

import OfflineAT from '../../_markets/at/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineBE from '../../_markets/be/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineFR from '../../_markets/fr/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineDE from '../../_markets/de/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineGR from '../../_markets/gr/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineIT from '../../_markets/it/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflinePL from '../../_markets/pl/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflinePT from '../../_markets/pt/technical-operations/middleware/offline-handling/_offline.mdx';
import OfflineES from '../../_markets/es/technical-operations/middleware/offline-handling/_offline.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <OfflineAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <OfflineBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <OfflineFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <OfflineDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <OfflineGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <OfflineIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <OfflinePL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <OfflinePT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <OfflineES />
  </TabItem>

</Tabs>
<br />

:::tip troubleshooting

In case of connectivity issues, please check out the dedicated chapter [Network Troubleshooting](../troubleshooting/network-troubleshooting.md).

:::
