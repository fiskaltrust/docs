---
slug: /posdealers/business-basics/management-portal
title: Management Portal
description: Tasks PosDealers perform in the fiskaltrust.Portal — account, operator and data management, surrogating, CashBox maintenance and the shop.
tags: [Portal, Surrogating, CashBox, PosDealers]
---
# Management Portal

:::info summary

After reading this, you can explain the tasks performed in the fiskaltrust.Portal.

:::

The fiskaltrust.Portal is the central **management dashboard** for your fiskaltrust account and services. It covers your account and company data, PosOperator associations, configuration and rollout of your Middleware instances, and orders for products and services.

![fiskaltrust.Portal dashboard with the navigation menu, user and company master data, and the unfinished validations table](./images/portal.png "https://portal-SANDBOX.fiskaltrust.TLD/Home/Dashboard")

*Figure 1. The dashboard of the fiskaltrust.Portal.*

| Task | Portal area |
|---|---|
| [Account Management](#account-management) | _Company info_ and _User info_ |
| [Operator Management](#operator-management) | _PosDealer_ |
| [Surrogating](#surrogating) | Switching into a PosOperator account |
| [Data Management](#data-management) | _Tools_ > _Exports_ |
| [CashBox Maintenance](#cashbox-maintenance) | _Configuration_ |
| [Shop](#shop) | Add-on products and rollout plans |

*Table 1. Tasks in the fiskaltrust.Portal.*

:::tip surrogating

[Surrogating](#surrogating) lets you, as a PosDealer, perform many steps for your associated PosOperators.

:::

## Account Management

In _Company info_:

1. In `Overview`, select the applicable **roles** and sign the **contractual agreements** for your company. See [Company Roles](../getting-started/company-roles.md).
2. In `master data`, check the data for completeness and the business data for validity.
3. In `Outlets`, add your company's **outlets** and their configurations.
4. In `Employees`, create accounts for your **employees** and manage their permissions.

In _User info_, manage your user data: `Edit profile` (**contact and address details**), `Change password` and `Change user name`.

## Operator Management

In the _PosDealer_ menu, you **invite** your customers to fiskaltrust (`Invitation`) and manage their accounts (`PosOperators`). Once a PosOperator accepts your invitation and signs a **contract** for the PosOperator role, their **account is associated** with yours, which enables [surrogating](#surrogating).

See [Invitation process](../getting-started/operator-onboarding/invitation-process.md).

## Surrogating

As a PosDealer, you can switch into the accounts of your PosOperators. Depending on the permission granted, you have:

* `Read Only` access,
* `Write/Read` access, or
* `Full (Write/Read, Contract Conclusion)`: write access plus the authority to sign contracts on behalf of the PosOperator.

Surrogating is an essential feature for PosDealers to establish and expand their business collaboration with PosOperators. See [Surrogating](../getting-started/operator-onboarding/surrogating.md).

## Data Management

In `Tools` > `Exports`, you **export your data** by export type and by a range of receipt dates or numbers. As export target, select for example Azure Storage or **DATEV MeinFiskal**. Availability depends on the country. See [Exports](../technical-operations/maintenance/exports.md).

## CashBox Maintenance

The _Configuration_ menu is the starting point for every CashBox. It contains `CashBoxes`, `Queues`, `Helpers`, `Signature creation unit`, `Template` and `Update Configuration`.

1. Create and configure the **CashBox components** (Queue, SCU, and Helpers if needed).
2. **Assemble** the components into a CashBox in `CashBoxes`.
3. In the `CashBoxes` list, click `Download` to get the **Launcher** for your target system.

To update the configuration of several CashBoxes at once, use `Update Configuration`.

See [Manual Configuration](../technical-operations/middleware/manual-configuration.md).

## Shop

The shop gives access to all fiskaltrust **add-on products and services**, for example product bundles, hardware solutions and archives. Purchase items individually or as part of pre-configured **rollout plans**. See [Shop](../buy-resell/shop.md) and [Rollout Plans](../buy-resell/rollout-plans.md).
