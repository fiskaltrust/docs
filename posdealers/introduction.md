---
slug: /posdealers/introduction
title: Introduction
description: Introduction to the PosDealer documentation — sections on business basics, getting started, buy/resell, technical operations, and information sources.
tags: [PosDealers, Onboarding, Portal]
---
# Introduction

This documentation is for cash register dealers (_PosDealers_). It covers the fiskaltrust-recommended steps to purchase, resell, roll out and support fiskaltrust products at your customers (_PosOperators_).

For the terms used throughout, see [Terminology](../poscreators/middleware-doc/general/terminology/terminology.md).

## Prerequisites

Before you roll out a POS system at a PosOperator, make sure the following is in place:

| Requirement | Details | Reference |
|---|---|---|
| **fiskaltrust.Portal account (Sandbox)** | Register your company yourself or accept an invitation from your PosCreator. Sandbox and live system are separate; you need a separate account for each. | [Registration](getting-started/registration.md), [Sandbox](getting-started/sandbox.md) |
| **PosDealer company role** | Activate only the roles that apply to your business case; each role entails different contractual requirements and obligations. | [Company Roles](getting-started/company-roles.md) |
| **Integrated PosSystem** | A PosCreator must have integrated the PosSystem in the fiskaltrust.Portal. Check `PosSystems` in your PosDealer account to confirm a `PosSystemId` is available. | [My First Cashbox](getting-started/my-first-cashbox.md#prerequisites) |
| **Complete master data** | Master data must be complete, match the registration with the tax authorities, and include at least one outlet. | [Master Data](getting-started/operator-onboarding/master-data.md) |
| **Internet connection** | Required by the Middleware. | [Network Requirements](technical-operations/middleware/network-requirements.md) |
| **Supported environment** | Only for a local Middleware installation: the system must meet the hardware and software requirements. | [Supported Environments](technical-operations/middleware/supported-environments.md) |
| **SSCD components** | Hardware or SaaS credentials required for the setup, unless created during the setup itself. | [Signing devices and services](buy-resell/products/signing/signing-overview.md) |

*Table 1. Prerequisites for a first rollout.*

To **buy and resell** in the live system, you additionally need to sign the cooperation agreement as PosDealer. See [Overview - Buy & Resell](buy-resell/overview.md).

:::caution

Run all first steps in the Sandbox. Sandbox signatures are for testing only, are not fiscally compliant and must never be used on a production system.

:::

## Recommended path

1. **Learn the business basics.** Read how fiskaltrust's business model, services, supported countries and the fiskaltrust.Portal work. Start at [Overview - Business Basics](business-basics/overview-business-basics.md).
2. **Set up the Sandbox.** Register a Sandbox account free of charge and activate the PosDealer role. See [Sandbox](getting-started/sandbox.md) and [Registration](getting-started/registration.md).
3. **Onboard a PosOperator.** Invite a PosOperator, or act on their behalf by surrogating, and verify their master data. See [Operator Onboarding](getting-started/operator-onboarding/invitation-process.md).
4. **Create your first CashBox.** Use a Rollout Plan (recommended) or a manual configuration, then run a test request. See [My First Cashbox](getting-started/my-first-cashbox.md).
5. **Plan purchasing.** Buy Entitlements and transfer them to PosOperators. If you plan to buy ten or more product bundles, consider a volume purchase agreement. See [Overview - Buy & Resell](buy-resell/overview.md).
6. **Roll out and operate.** Choose a rollout scenario, automate rollouts with templates, and set up monitoring and maintenance. See [Overview - Technical Operations](technical-operations/overview-technical-operations.md).

## Documentation sections

| Section | Contents | Start here |
|---|---|---|
| **Business Basics** | Business model, company roles, services, supported countries, architecture, fiskaltrust.Portal, Fair Use Policy. | [Overview - Business Basics](business-basics/overview-business-basics.md) |
| **Getting Started** | Sandbox, registration, company roles, PosOperator onboarding (invitation, surrogating, master data), first CashBox. | [Overview - Getting Started](getting-started/overview-getting-started.md) |
| **Buy & Resell** | Entitlements, credit limit, volume purchase agreements, rollout plans, Shop, subscription management, products and bundles. | [Overview - Buy & Resell](buy-resell/overview.md) |
| **Technical Operations** | Rollout scenarios, Middleware launchers and configuration, PosSystem API platforms, rollout automation, troubleshooting, maintenance and exports. | [Overview - Technical Operations](technical-operations/overview-technical-operations.md) |
| **Information Sources** | Knowledge base, support cases, downloads, third-party partner status, news, videos, webinars, contacting support. | [Overview - Information Sources](information-sources/overview-information-sources.md) |

*Table 2. Sections of the PosDealer documentation.*

## Recommended reading by role

This documentation is for all PosDealer employees who work with fiskaltrust products. Most content is technical or business-related; individual sections are also relevant for other audiences, for example legal departments.

| Reader group | Business Basics | Getting Started | Buy & Resell | Technical Operations | Information Sources |
|---|:---:|:---:|:---:|:---:|:---:|
| **Project managers and support staff** | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| **Rollout technicians and testers** | ✔️ | ✔️ | — | ✔️ | ✔️ |
| **Procurement, sales and account managers** | ✔️ | — | ✔️ | — | — |
| **Legal department** | ✔️ | — | ✔️ | — | — |

*Table 3. Recommended reading sections per PosDealer reader group.*

## When something goes wrong

Work through the steps of the [Troubleshooting Guide](technical-operations/troubleshooting/troubleshooting-guide.md) in order. Table 4 maps common problems to the page that resolves them.

| Problem | Where to look | Action |
|---|---|---|
| Middleware or related services have no internet connection | [Network troubleshooting](technical-operations/troubleshooting/network-troubleshooting.md) | Check the [network requirements](technical-operations/middleware/network-requirements.md), then work through the DNS, network, SSL and Queue/SCU connection checks. |
| CashBox requests fail | [CashBox failures](technical-operations/troubleshooting/cashbox-failures.md) | In the fiskaltrust.Portal, open `Metrics` > `CashBox` and click `Go to failed requests`. Not available if the launcher runs offline or with `--telemetry-opt-out`. |
| Purchase or rollout blocked by the credit limit | [Credit limit](buy-resell/overview.md#credit-limit) | Settle open invoices, or contact fiskaltrust to request a higher credit limit. |
| A PosOperator or employee forgot their password | [Contacting support](information-sources/contacting-support.md#work-steps) | Use the password reset link on the fiskaltrust.Portal login page. |
| Problem not solved by the steps above | [Contacting support](information-sources/contacting-support.md) | Contact the fiskaltrust Customer Success Team at your country-specific address and track the request under [Cases](information-sources/cases.md). |

*Table 4. Common problems and where to resolve them.*

:::info

The fiskaltrust Customer Success Team handles requests from PosDealers and PosCreators. PosOperators are referred to their PosDealer.

:::
