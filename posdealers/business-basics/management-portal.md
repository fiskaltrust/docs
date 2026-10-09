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

![fiskaltrust.Portal Overview page: the sidebar menu (including Overview, Company info, PosOperator, PosDealer, Rollout management, Tools, PosSystems, Configuration and Shop), the Master data of User and Master data of company panels, and the user menu at the top right](./images/portal.png "https://portal-sandbox.fiskaltrust.TLD/#/")

*Figure 1. The `Overview` page of the fiskaltrust.Portal with the sidebar menu, the user and company master data, and the user menu at the top right.*

| Task | Portal area |
|---|---|
| [Account Management](#account-management) | `Company info` and the user menu (top right) |
| [Operator Management](#operator-management) | `PosDealer` |
| [Surrogating](#surrogating) | Switching into a PosOperator account |
| [Data Management](#data-management) | `Tools` > `Exports` |
| [CashBox Maintenance](#cashbox-maintenance) | `Configuration` |
| [Shop](#shop) | `Shop` |

*Table 1. Tasks in the fiskaltrust.Portal.*

:::tip surrogating

[Surrogating](#surrogating) lets you, as a PosDealer, perform many steps for your associated PosOperators.

:::

## Account Management

In `Company info`:

1. In `Overview`, select the applicable **roles** and sign the **contractual agreements** for your company. For more information, see [Company Roles](../getting-started/company-roles.md).
2. In `Master data`, check the data for completeness and the business data for validity.
3. In `Outlets`, add your company's **outlets** and their configurations.
4. In `Employees`, create accounts for your **employees** and manage their permissions.

### User Menu

Open the user menu under your name at the top right to manage your personal settings: `Edit profile` (**contact and address details**), `Change password` and `Change username`. The user menu also contains the `Language` section, where you switch the language of the fiskaltrust.Portal, and `Sign out`.

<p><img src={require("./images/user-menu.png").default} alt="fiskaltrust.Portal user menu opened under the user name at the top right, with Overview, Edit profile, Change password and Change username, the Language section with the available languages, and Sign out" width="321" /></p>

*Figure 2. The user menu with the personal settings, the `Language` section and `Sign out`.*

## Operator Management

In the `PosDealer` menu, you **invite** your customers to fiskaltrust (`Invitation`) and manage their accounts (`PosOperators`). Once a PosOperator accepts your invitation and signs a **contract** for the PosOperator role, their **account is associated** with yours, which enables [surrogating](#surrogating).

For more information, see [Invitation process](../getting-started/operator-onboarding/invitation-process.md).

## Surrogating

As a PosDealer, you can switch into the accounts of your PosOperators. Depending on the permission granted, you have:

* `Read Only` access,
* `Write/Read` access, or
* `Full (Write/Read, Contract Conclusion)`: write access plus the authority to sign contracts on behalf of the PosOperator.

Surrogating is an essential feature for PosDealers to establish and expand their business collaboration with PosOperators. For more information, see [Surrogating](../getting-started/operator-onboarding/surrogating.md).

## Data Management

In `Tools` > `Exports`, you **export your data** by export type and by a range of receipt dates or numbers. As `Export target`, select for example `Azure Storage` or `DATEV MeinFiskal`. Availability depends on the country. For more information, see [Exports](../technical-operations/maintenance/exports.md).

## CashBox Maintenance

The `Configuration` menu is the starting point for every CashBox. It contains `CashBoxes`, `Queues`, `Helpers`, `Signature creation unit`, `Template` and `Update Configuration`.

1. Create and configure the **CashBox components** (Queue, SCU, and Helpers if needed).
2. **Assemble** the components into a CashBox in `CashBoxes`.
3. In the `CashBoxes` list, click `Download` to get the **Launcher** for your target system.

To update the configuration of several CashBoxes at once, use `Update Configuration`.

For more information, see [Manual Configuration](../technical-operations/middleware/manual-configuration.md).

## Shop

The `Shop` menu gives access to all fiskaltrust **add-on products and services**, for example product bundles, hardware solutions and archives. Purchase items individually or as part of pre-configured **rollout plans**. For more information, see [Shop](../buy-resell/shop.md) and [Rollout Plans](../buy-resell/rollout-plans.md).
