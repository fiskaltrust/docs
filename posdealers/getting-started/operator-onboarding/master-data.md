---
slug: /posdealers/getting-started/operator-onboarding/master-data
title: Master data
description: Why complete master data matters and how to check company data, tax numbers and outlets in the fiskaltrust.Portal.
tags: [Master Data, Onboarding, Portal, PosDealers]
---
# Master data

:::info summary
After reading this, you can keep your own and your PosOperators' master data up to date and explain why that is important.
:::

## Why master data matters

The **master data** of a company is essential in the fiskaltrust.Portal:

- **Accounting** between fiskaltrust and you as a PosDealer requires complete and verified master data.
- **Signing devices and services**: to set up and use them, PosDealers and PosOperators need at least one of their tax identification numbers. For more information, see [Signing devices and services](../../buy-resell/products/signing/signing-overview.md).
- **Authentication** towards fiscal authorities or [third-party integrations](../../buy-resell/products/3rd-party/3rd-party-overview.md) requires the tax registration numbers.

**Outlets** are the locations of a PosOperator's business, for example shops, event locations, or production, distribution and administration sites. Check the outlet data, because:

- **Tax regulations** in some countries require exact data on the primary outlet and further outlets.
- **Shipping hardware** via the fiskaltrust.Portal requires exact address details.

## Which data to review

- **Company master data**: check it for completeness and use the available check mechanisms. Country-specific check mechanisms verify, depending on the legal situation and the technical equipment of the fiscal administration, whether an entered value meets the formal requirements. Depending on the country, when a PosOperator is registered for the first time, further master data can be retrieved from the relevant authority and checked by entering a tax number.
- **User data** (user menu at the top right > `Edit profile`): only needed for using the fiskaltrust.Portal. For data protection reasons, you can use function designations (like **fiscalizing**) or fictitious names instead of real names. The e-mail address, however, must be real and working, because it is used to sign in to the fiskaltrust.Portal. To avoid real names, use a functional address (like fiscalizing@PosOperator.TLD).
- **PosOperators' master data**: check it for completeness and correctness in the same way as your own.

The following sections show how to check your own master data. After you have done this and invited your PosOperators, switch to each PosOperator's account and check their master data the same way. For more information, see [Surrogating](surrogating.md).

## Review the master data

The steps are the same in all markets. Only the tax identification numbers and their format depend on the country. The `Master data` page explains them below the fields.

1. In the Portal, open `Company info` > `Master data` in the left sidebar.
2. Check that the fields marked with * contain correct and complete data.
3. In `Identification numbers`, check the tax identification numbers against the explanations below the fields. Observe the notes on notation, such as the number of digits and the omission of spaces, and whether one or more values are required.
4. Click `Data Check` for each tax identification number. The symbol shows the result, as described in *Table 1*.
5. Save your changes before you leave the page.

| Data check result | Meaning |
|:-----------------:|---------|
|![Data Check symbol for an unchecked value](../../_markets/at/getting-started/operator-onboarding/master-data/images/data-undone.png) |The value in the data field has not been checked yet. |
|![Data Check symbol for an invalid value](../../_markets/at/getting-started/operator-onboarding/master-data/images/data-invalid.png) |The value is invalid. Hover over the symbol to see the description, change the value accordingly and run the data check again. |
|![Data Check symbol for a valid value](../../_markets/at/getting-started/operator-onboarding/master-data/images/data-valid.png) |The value is valid. This does not protect against duplicates. |

*Table 1. Data check result symbols and their meaning.*

## Manage the outlets

:::info Outlet numbers
- `Outlet number 1` is assigned automatically when an account is created in the fiskaltrust.Portal.
- `Outlet number 2` is not available.
- When you create an outlet manually, you can set the `Outlet number` yourself.
- Once an `Outlet number` has been set, it cannot be changed.
:::

The steps are the same in all markets.

1. In the Portal, open `Company info` > `Outlets` in the left sidebar. The page shows your primary outlet and the list of all other outlets. Check that their data is complete and correct.

   ![Outlets page in the fiskaltrust.Portal for the German market with the primary outlet and the Edit Primary Outlet button, the Import CSV file controls, the Download demo CSV file and Add new outlet buttons, the list of outlets with the German Carefree and AKO columns and their edit buttons, and the Export as CSV button](images/outlets-page.png)

   *Figure 1. The `Outlets` page in the German market, as an example. The `Carefree` and `AKO` columns are specific to this market.*

2. To add several outlets at once, import them from a CSV file:
   1. Click `Download demo CSV file`.
   2. Open the CSV file, add the values and save it.
   3. In `Import CSV file`, click `Choose` and browse to the CSV file.
   4. Click `Import`. The data is checked and listed on the `Bulk import of outlets` page.
   5. Click `Proceed with valid outlets`.
3. To add a single outlet, click `+ Add new outlet`.
4. To change the address of the primary outlet, click `Edit Primary Outlet`. This changes the address values in `Company info` > `Master data`.
5. To change the data of another outlet, click the edit button (pencil icon) in its row. For more information, see [Edit outlets](#edit-outlets).
6. To export the list of outlets, click `Export as CSV`.

:::caution France
The **SIRET is mandatory for each outlet**. To import several outlets with their SIRET, use the `LocationId` column of the CSV file.
:::

### Edit outlets

1. In the Portal, open `Company info` > `Outlets` in the left sidebar and click the edit button (pencil icon) of the outlet you want to check or edit.
2. Check the address data. It is relevant for the automated invoice generation between PosDealer and PosOperators and for the digital receipt.
3. Optionally, under `Outlet Logo`, click `Select Image File` to upload an image that customizes the digital receipts of this outlet.
4. Click `Save` to save your changes, or `Cancel` to return to `Company info` > `Outlets`.
