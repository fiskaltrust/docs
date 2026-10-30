---
slug: /posdealers/buy-resell/products/digital-receipt
title: Digital Receipt
description: Preparations PosDealers and PosOperators need for digital receipts, plus how to evaluate digital receipt retrievals.
type: guide
tags: [Digital receipt, Portal, PosDealers]
---

# Digital Receipt

:::info summary

After reading this, you can explain the preparations for PosOperators to use digital receipts.

:::

If you include digital receipts in the sales process, the customer chooses between a digital receipt and a printout. With digital receipts, the PosOperator reduces the cost of printouts and helps the environment. As a PosDealer, you offer a state-of-the-art POS system.

Regulations and requirements can differ depending on the country where the POS system is used. Check the regulations of your country. The Sandbox can look different from the live system.

## Prepare digital receipts

PosDealers or PosOperators prepare digital receipts in the fiskaltrust.Portal. The only requirement is access to the fiskaltrust.Portal with **write authorizations**.

![Workflow with two swimlanes, PosDealer in the fiskaltrust.Portal and PosOperator account: the PosDealer switches to the PosOperator account, checks the master data with Data Check and saves, then edits the outlet, checks its data, adds the outlet logo and saves](../images/digital-receipt-flowchart.svg)

*Figure 1. Workflow for preparing digital receipts.*

1. If you are a PosDealer, switch to the PosOperator's account. For more information, see [Surrogating](../../getting-started/operator-onboarding/surrogating.md).
2. Check that the **master data** of the PosOperator's account is complete, and validate the tax identification numbers.
3. Check the **outlet** data for completeness and correct it if necessary. The digital receipt shows the address of the outlet, not the address of the company.
4. Optionally, add a **logo** to the outlet. The digital receipt shows it at the top. For the best result, use a PNG file with a transparent background.

For the steps in the fiskaltrust.Portal, see [Master data](../../getting-started/operator-onboarding/master-data.md) and [Edit outlets](../../getting-started/operator-onboarding/master-data.md#edit-outlets).

## Evaluate retrievals of digital receipts

For a tax audit, or in general, you can check which receipts were transmitted, retrieved or printed with an export in the fiskaltrust.Portal.

1. In the Portal, open `Configuration` > `Queues` in the left sidebar and select the Queue.
2. Click `Export`. The page for creating a new export opens.
3. Select the export type `Full export (XML)` and create the export.

With digital receipts, the `Full export (XML)` contains an additional file with the status of each digital receipt. You link its records to the raw and print data records by the `ftReceiptJournalID`, which all of them contain.

The file has a simple format that you can open with a spreadsheet application, for example Excel. *Table 1* describes its fields.

| Field name | Description | Example |
|:---|:---|:---|
| `ftReceiptMoment` | **Time** (UTC +2) at which the fiskaltrust.Middleware processed the receipt. | 04/14/2023 11:20:31 |
| `ftReceiptIdentification` | **Number** of the receipt, assigned by the fiskaltrust security mechanism. | ft1D#24 |
| `ftQueueItemid` | Number of the **Queue** item that processed the receipt. | 9df671cf-d0a8-4824-9bd0-9000d8dcd8ea |
| `ftReceiptJournalId` | **Number** created by the fiskaltrust.ReceiptJournal, which collects, hashes and links all receipt requests from the Middleware. | 1626d96a-ae5b-4a6bb1f9-6468a83ef749 |
| `ftSubmittedMoment` | **Time** (UTC +2) at which the taxpayer provided the QR code. | 04/14/2023 11:21:09 |
| `ftDeliveredMoment` | **Time** (UTC +2) at which the consumer retrieved the QR code. | 04/14/2023 11:21:09 |
| `ftDeliveredStatus` | Output or retrieval **status** of the receipt: `printed` (the receipt was printed), `accepted` (the receipt was received elsewhere), `submitted` (the taxpayer provided the receipt) or `delivered` (the consumer received the receipt). | `printed` |
| `ftDeliveredStatusData` | Additional **parameters**, for example the model number of the terminal. This function is not active yet. | Hobex ViA Pro |

*Table 1. Fields of the digital receipt status file in the export.*
