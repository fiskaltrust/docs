---
slug: /posdealers/buy-resell/subscription-management
title: Subscription management
description: Managing PosOperator subscriptions in the Portal — automatic and manual annual renewals and cancellation.
type: guide
tags: [Subscriptions, Portal, PosDealers]
---
# Subscription management

:::info summary

After reading this, you can renew subscriptions automatically or manually, and cancel them.

:::

fiskaltrust's recurring products work on a subscription basis with annual payment. For the products, see [Products & Services](./products/overview.md). You renew subscriptions **automatically** or **manually**. If you no longer want to use a product, cancel its subscription. The cancellation takes effect on the last day of the current subscription period.

## Subscriptions page

To get an overview of the subscriptions of all your PosOperators, open `PosDealer` > `PosOperator Subscriptions` in the left sidebar of the Portal. On this page, you can:

- filter the list, for example to show overdue or upcoming subscriptions
- enable or disable automatic renewals
- renew one or several subscriptions manually
- cancel subscriptions

## Renew subscriptions

Subscriptions are renewed every year, either manually or automatically by the fiskaltrust.Portal. Automatic renewal is an opt-in feature that you need to enable.

### Automatic renewals

To enable automatic renewals, sign a side letter to the PosDealer contract. It allows fiskaltrust to renew the subscriptions for you. To sign it, turn on the `Allow renewing subscriptions automatically` toggle, either in the banner of the subscriptions page or in `Company info` > `Overview`. As with role contracts, turning off the toggle disallows automatic renewals again. For more information, see [Company Roles](../getting-started/company-roles.md).

Automatic renewals run monthly: at the beginning of each month, the fiskaltrust.Portal renews all subscriptions that expire in this month and sends you a collective invoice by e-mail.

To enable or disable the automatic renewal for a single subscription, select the value in its `Renewal type` column.

### Manual renewals

You can always renew subscriptions manually, for example because you prefer this, or because you disabled automatic renewal for some subscriptions.

1. Choose the subscriptions to renew:
   - **One subscription**: select `Renew subscriptions` in the `Actions` column of its row.
   - **Several subscriptions**: select their rows and click `Renew subscriptions` below the list.
2. In the dialog, choose how the quote covers the entitlements:
   - **Dealer package**: if you do not have the entitlements in your account, the quote includes a dealer package, and you buy the required entitlements during the checkout.
   - **Move entitlements**: the quote moves existing entitlements from your account to the PosOperator.
3. Confirm the dialog. The fiskaltrust.Portal creates a quote and loads it into the `Basket`.
4. Complete the checkout.

## Cancel subscriptions

:::caution

**Cancelling a subscription is permanent.** After you cancel a subscription, you cannot reactivate it or take any further action on it.

:::

1. Choose the subscriptions to cancel:
   - **One subscription**: select `Cancel subscription` in the `Actions` column of its row.
   - **Several subscriptions**: select their rows and click `Cancel subscriptions` below the list.
2. Confirm the cancellation.

**Result:** If you cancel a subscription during the billing period, the cancellation takes effect at the end of the period. Until then, the product works as before.
