---
slug: /posdealers/getting-started/posdealer-onboarding
title: PosDealer Onboarding
description: Step-by-step PosDealer onboarding checklist from account and roles through operator invitations, architecture, procurement and contracts.
tags: [Onboarding, PosDealers, Portal, Company Roles]
---

# PosDealer Onboarding Guide

:::info summary

After reading, you know the onboarding steps from your initial account setup to a successful PosOperator rollout.

:::

As a PosDealer, you deploy compliant fiscalization solutions by connecting the POS systems of PosCreators with the daily operations of PosOperators.

| Party | Responsibility |
| ----- | -------------- |
| **fiskaltrust** | Provides the fiscalization infrastructure. |
| **PosCreator** | Delivers the technical integration. |
| **PosDealer** | Configures, deploys and supports compliant systems for PosOperators. |

*Table 1. Responsibilities in a fiskaltrust rollout.*

In some cases, a PosCreator also takes on the commercial role of a PosDealer.

Work through the following checklist in order. Completing each step helps ensure a smooth, compliant and scalable deployment for your customers.

## 1. Account and roles

Check your initial configuration in the [fiskaltrust.Portal](https://portal.fiskaltrust.de/):

1. Complete the [Registration](./registration.md). Your fiskaltrust account is created in the Portal.
2. Make sure the **PosDealer** role is assigned. Assign the **PosCreator** role only if you implemented your own POS system. For more information, see [How to activate a role](./company-roles.md#how-to-activate-a-role).

## 2. Invitation process

Connect your customer (PosOperator):

1. Send the account link to the new PosOperator through the invitation process. For more information, see [Invitation](./operator-onboarding/invitation-process.md).
2. To check the status, open `PosDealer` > `PosOperators` in the Portal. When the link is marked as **Active**, the PosOperator is connected.

:::tip

To manage PosOperators on their behalf, see [Surrogating](./operator-onboarding/surrogating.md).

:::

## 3. PosOperator role and master data

Check that the PosOperator account is configured as follows:

- The **PosOperator** role is assigned. For more information, see [Company Roles](./company-roles.md#principal-roles).
- The tax number and address are entered correctly. To validate them, open `Company info` > `Master data`, find the tax number, and check that the `Data Check` (blue checkmark) on the right is present. For more information, see [Master Data](./operator-onboarding/master-data.md).

## 4. PosOperator architecture

Set up the environment of the PosOperator:

1. Introduce the PosOperator to the fiskaltrust architecture. For more information, see [Architecture](../business-basics/architecture.md).
2. Open `Company info` > `Outlets` and click `+Add new outlet` to create the PosOperator's locations.
3. For each location, assign cash registers, add SCUs, and link products or entitlements.

## 5. Technical implementation

Align on rollout and technical requirements:

- Discuss the technical implementation needs. For more information, see [Rollout Scenarios](../technical-operations/rollout-scenarios.md).
- Clarify the required products and service packages. For more information, see [Product overview](../buy-resell/products/overview.md).

## 6. Procurement and subscription

Make sure you understand the procurement process through **Entitlements** and **Business Rollout**. For more information, see [Overview - Buy & Resell](../buy-resell/overview.md).

## 7. Contracts

Receive and sign the **Contract Partner Agreement** (VPA). For more information, see [Volume purchase agreement](../buy-resell/overview.md#volume-purchase-agreement).

## 8. Knowledge and documentation

Know where to find help:

- Open `Help` > `Knowledge articles` in the Portal for the knowledge articles ([direct link](https://portal.fiskaltrust.de/#/KBArticles)).
- Open `Help` > `Documentation` for the fiskaltrust documentation, or go to [docs.fiskaltrust.eu](https://docs.fiskaltrust.eu/).
