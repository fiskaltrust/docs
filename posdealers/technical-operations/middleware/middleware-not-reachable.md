---
slug: /posdealers/technical-operations/middleware/middleware-not-reachable
title: Middleware Not Reachable
description: The failure scenario in which the POS system cannot reach the Middleware - its causes, which connection each setup depends on, and what PosDealers and PosOperators must do in each market.
tags: [Failure Handling, Offline, Middleware, PosDealers]
---
# Middleware Not Reachable

:::info summary

After reading this, you know when the POS system cannot reach the Middleware, which connection each setup depends on, and what you and the PosOperator must do during and after such a failure in each market.

:::

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Introduction

This page covers one failure scenario: the POS system cannot reach the Middleware. This happens whenever the POS system does not receive a response from the Middleware, whatever the cause:

- The network between the POS system and the Middleware fails, for example the local network or Wi-Fi, or the internet connection of the location to the CloudCashbox.
- The device or server on which the Middleware runs is switched off, has no power or fails.
- The Middleware has not been started, has been stopped or has crashed.
- The request times out or the connection is interrupted.

Whether a POS system may continue to sell in this case, and what must be done afterwards, depends on the market. The implementation in the POS system is described for PosCreators in [Middleware Not Reachable](../../../poscreators/middleware-doc/general/cash-register-integration/middleware-not-reachable.md). The other failure scenarios are described in [Failure Scenarios](../../../poscreators/middleware-doc/general/cash-register-integration/cash-register-integration-failure-scenarios.md).

## Which connection the POS system depends on

| Where the Middleware runs | Connection from the POS system |
|---------------------------|--------------------------------|
| On premise, on the POS device or a local server | Local network. An internet outage alone does not make the Middleware unreachable. |
| In the cloud (CloudCashbox) | Internet connection of the location. An internet outage makes the Middleware unreachable. |

*Table 1. Connection the POS system needs to reach the Middleware.*

## Before a failure

- **Plan the connection** of every location according to where the Middleware runs.
- **Make sure the POS system supports the procedure of the market**, for example buffering receipts, recording paper documents or stopping sales.
- **Train the PosOperator** to recognize the failure on the POS system and to send a Zero-Receipt once the Middleware is reachable again, where the market requires it.

## Market-specific rules

import NotReachableAT from '../../_markets/at/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableBE from '../../_markets/be/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableFR from '../../_markets/fr/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableDE from '../../_markets/de/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableGR from '../../_markets/gr/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableIT from '../../_markets/it/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachablePL from '../../_markets/pl/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachablePT from '../../_markets/pt/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';
import NotReachableES from '../../_markets/es/technical-operations/middleware/middleware-not-reachable/_middleware-not-reachable.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <NotReachableAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <NotReachableBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <NotReachableFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <NotReachableDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <NotReachableGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <NotReachableIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <NotReachablePL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <NotReachablePT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <NotReachableES />
  </TabItem>

</Tabs>
<br />

:::tip troubleshooting

In case of connectivity issues, please check out the dedicated chapter [Network Troubleshooting](../troubleshooting/network-troubleshooting.md).

:::
