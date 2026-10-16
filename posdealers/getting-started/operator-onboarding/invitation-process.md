---
slug: /posdealers/getting-started/operator-onboarding/invitation-process
title: Invitation
description: Inviting a single PosOperator or bulk-inviting several via CSV in the Portal, managing invitations and handling errors.
tags: [Invitation, Onboarding, Portal, PosDealers, Troubleshooting]
---
# Invitation

:::info summary
After reading this, you can invite a single PosOperator and invite several PosOperators at once with a CSV file.
:::

A PosCreator invites you, as a PosDealer, to the fiskaltrust.Portal. You invite your PosOperators. Once a PosOperator has an account in the fiskaltrust.Portal, you can transfer fiskaltrust products that you purchased in the Portal shop to that account. For more information, see [Business Model](../../business-basics/business-model.md).

There are two ways to invite PosOperators:

| Way | Use it for |
|-----|------------|
| [Invitation of a single PosOperator](#invitation-of-a-single-posoperator) | One PosOperator, for example a new contact, on-site support, or testing in the sandbox. |
| [Bulk invitation of PosOperators](#bulk-invitation-of-posoperators) | Several PosOperators at once, imported from a CSV file. |

*Table 1. Ways to invite PosOperators.*

:::warning E-mail addresses cannot be deleted
You cannot delete an e-mail address entirely in the fiskaltrust.Portal, so you cannot transfer an e-mail address that was used once to any other account. Test the invitation process in the sandbox first to avoid problems with e-mail addresses in the production system.
:::

## Prerequisites

- Your account has the PosDealer role. Only PosDealers can invite PosOperators; PosCreators and consultants cannot. Both can additionally activate the PosDealer role to get these options in the fiskaltrust.Portal. For more information, see [Company Roles](../company-roles.md).
- You have checked the invitation settings as described in [Preparation of invitations](#preparation-of-invitations).

## Preparation of invitations

Check the invitation settings before you invite PosOperators, regardless of which way you use.

1. Open `PosDealer` > `PosOperators` to see the PosOperators already assigned to your account.
2. Open `PosDealer` > `Invitation`. In Austria, Germany and France, `PosOperator` > `Invitation` opens the same page.

   ![Invitation page in the fiskaltrust.Portal with the PosOperator invitation settings, including PDF-Attachment with an uploaded PDF file and the Download invitation PDF and Delete invitation pdf buttons, Surrogate rights set to Full (Write/Read, Contract Conclusion) and the Additional information field with its character counter, and the section PosOperators that should be invited with Import CSV file, Download demo CSV file, +Add, History and the search field](images/invitation-page.png)

   *Figure 1. The `Invitation` page with the `PosOperator invitation settings`.*

3. In `PosOperator invitation settings`, check or change the settings described in Table 2.
4. Continue with [Invitation of a single PosOperator](#invitation-of-a-single-posoperator) or [Bulk invitation of PosOperators](#bulk-invitation-of-posoperators).

| Setting | Description |
| ------- | ----------- |
| `PDF-Attachment` | Attach a document to the e-mail invitation. Use it as an accompanying letter that explains that you, as a PosDealer, are extending your offers and invite your PosOperators to register with the fiskaltrust.Portal via the confirmation link. This avoids confusion when PosOperators receive an e-mail from an unknown sender such as sandbox@fiskaltrust.TLD or robot@fiskaltrust.TLD. Click `Choose file`, browse to the PDF file and click `Import`. After the upload, `Download invitation PDF` and `Delete invitation pdf` are available. |
| `Additional information for the PosOperator. This text will be added to the invitation e-mail.` | Add your own text of up to 1000 characters to the automated e-mail invitation (see [Preview of the e-mail invitation](#preview-of-the-e-mail-invitation)). Use it to inform your PosOperators personally, for the same reason as the PDF attachment. The counter next to the field shows the remaining characters. The text is saved when you leave the field. |
| `Surrogate rights` | The permission level you get when you switch to the PosOperator's account (surrogating). The options are `Full (Write/Read, Contract Conclusion)` (default), `Write/Read`, `Read Only` and `None`. Select `Full (Write/Read, Contract Conclusion)`. With any other option you can access the PosOperator's account, but you cannot conclude contracts on the PosOperator's behalf, which is necessary for cooperation with third parties. For more information, see [Surrogating](surrogating.md). |

*Table 2. Invitation settings.*

## Invitation of a single PosOperator

Invite a single PosOperator, for example, when you give on-site support to a PosOperator who wants to use the fiskaltrust services immediately when a POS system is put into operation, or when you test the fiskaltrust.Portal and its processes in the sandbox.

Depending on the country, when a PosOperator is registered for the first time, further master data can be retrieved from the relevant authority and checked by entering a tax number.

![Workflow with two swimlanes, PosDealer and PosOperator: the PosDealer opens the Invitation page, checks the invitation settings, clicks +Add, enters the PosOperator details and clicks Invite all PosOperators; the PosOperator accepts the e-mail invitation, activates the PosOperator role and verifies master data and outlets; the PosDealer then checks in PosOperators whether the PosOperator name is an active link and either is ready to surrogate or resends the invitation from the invitation history](images/invitation-single-flowchart.svg)

*Figure 2. Workflow for inviting a single PosOperator.*

### Steps

1. Open `PosDealer` > `Invitation`.
2. Check the settings as described in [Preparation of invitations](#preparation-of-invitations).
3. In `PosOperators that should be invited`, click `+Add`.
4. Fill in the mandatory fields. They are required so that the PosOperator can be found and assigned correctly in the fiskaltrust.Portal via the e-mail address:
   - `Company data`: company name, e-mail address, address line 1, postal code, city, country
   - `User data`: first name, last name, contact e-mail address
5. Fill in the tax identification numbers. They are not mandatory for the invitation, but they and their validation are **essential** for the correct management of the cash register systems (for example AccountIdVat, AccountIdGln, AccountUStIdNr).
6. Click `Save`. The PosOperator is added to the list `PosOperators that should be invited`.
7. Click `Invite all PosOperators` to send the e-mail invitation.

If the invitation does not reach the PosOperator, see [Managing the invitations](#managing-the-invitations).

### Preview of the e-mail invitation

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import PreviewAT from '../../_markets/at/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewBE from '../../_markets/be/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewFR from '../../_markets/fr/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewDE from '../../_markets/de/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewGR from '../../_markets/gr/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewIT from '../../_markets/it/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewPL from '../../_markets/pl/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewPT from '../../_markets/pt/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';
import PreviewES from '../../_markets/es/getting-started/operator-onboarding/invitation-process/_preview-email.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <PreviewAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <PreviewBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <PreviewFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <PreviewDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <PreviewGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <PreviewIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <PreviewPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <PreviewPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <PreviewES />
  </TabItem>

</Tabs>

## Bulk invitation of PosOperators

Import a CSV file to invite many business partners at once. The fiskaltrust.Portal creates and sends the invitations automatically, so the data of your business partners must be correct. Check the [preparation](#preparation-of-invitations) first, so that invitations are not mistakenly treated as spam. The fiskaltrust.Portal provides a demo CSV file with the required structure; the columns are described in [Fields of the CSV file](#fields-of-the-csv-file).

![Workflow with two swimlanes, PosDealer and PosOperator: the PosDealer opens the Invitation page, checks the invitation settings, downloads the demo CSV file, enters the data, imports the CSV file and clicks Invite all PosOperators; each PosOperator accepts the e-mail invitation, activates the PosOperator role and verifies master data and outlets; the PosDealer then checks in PosOperators whether the PosOperator name is an active link and either is ready to surrogate or resends the invitation from the invitation history](images/invitation-bulk-flowchart.svg)

*Figure 3. Workflow for inviting PosOperators in a bulk process.*

### Steps

1. Open `PosDealer` > `Invitation`.
2. Check the settings as described in [Preparation of invitations](#preparation-of-invitations).
3. In `PosOperators that should be invited`, click `Download demo CSV file`.
4. Open the demo CSV file.
5. Add the data of the PosOperators as described in [Fields of the CSV file](#fields-of-the-csv-file) and save the file as a CSV file.
6. Go back to the fiskaltrust.Portal and open `PosDealer` > `Invitation`.
7. In `PosOperators that should be invited`, click `Choose file` in `Import CSV file` and browse to your CSV file.
8. Click `Import`. The data is uploaded and checked for duplicate or incomplete records. You can check and complete each record. If records are incomplete, the import error page opens (see [Handling error messages](#handling-error-messages)).
9. Click `Invite all PosOperators` to send the e-mail invitation to each business partner in your CSV file. For a preview of the e-mail, see [Preview of the e-mail invitation](#preview-of-the-e-mail-invitation).

   ![Invitation page in the fiskaltrust.Portal after a CSV import, with the uploaded PDF attachment and the Download invitation PDF and Delete invitation pdf buttons, the Import CSV file field with Choose file, Import and Download demo CSV file, the buttons Invite all PosOperators, +Add and History, and the list PosOperators that should be invited with one entry, its status and the actions](images/invitation-bulk-page.png)

   *Figure 4. The `Invitation` page with an imported PosOperator in `PosOperators that should be invited`.*

### Fields of the CSV file

import FieldsAT from '../../_markets/at/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsBE from '../../_markets/be/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsFR from '../../_markets/fr/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsDE from '../../_markets/de/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsGR from '../../_markets/gr/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsIT from '../../_markets/it/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsPL from '../../_markets/pl/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsPT from '../../_markets/pt/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';
import FieldsES from '../../_markets/es/getting-started/operator-onboarding/invitation-process/_fields-details.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <FieldsAT />
  </TabItem>

  <TabItem value="BE" label="Belgium">
    <FieldsBE />
  </TabItem>

  <TabItem value="FR" label="France">
    <FieldsFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <FieldsDE />
  </TabItem>

  <TabItem value="GR" label="Greece">
    <FieldsGR />
  </TabItem>

  <TabItem value="IT" label="Italy">
    <FieldsIT />
  </TabItem>

  <TabItem value="PL" label="Poland">
    <FieldsPL />
  </TabItem>

  <TabItem value="PT" label="Portugal">
    <FieldsPT />
  </TabItem>

  <TabItem value="ES" label="Spain">
    <FieldsES />
  </TabItem>

</Tabs>

### Handling error messages

If mandatory fields in the CSV file are empty or wrong, the `Import error` page opens. It lists the required fields and each error with its line (`Line`) and message (`Error`).

![Import error page in the fiskaltrust.Portal with the list of required fields, including company name, postal code, city, country code and one of the business identifiers VAT number or TIN, a table of errors per CSV line for a missing address line 1, ZIP code and contact e-mail address, and the Back button](images/import-error.png)

*Figure 5. The `Import error` page with the required fields and the errors per CSV line.*

1. Note the error messages.
2. Add the missing data in the respective lines of the CSV file.
3. Click `Back` and import the corrected file again.

## Managing the invitations

If the preparation is complete, the invitation process runs automatically. If problems arise, you can fix most of them yourself. For example, if a PosOperator says that no e-mail invitation arrived, check the invitation history.

### Status and error messages

1. Check the `Status` of the invitation: `Invitation Sent`, `Press "Send" to invite PosOperator` or `Failed sending`.
2. If the status is `Press "Send" to invite PosOperator`, the invitation is not sent yet. Use the buttons in the `Actions` column:
   - Click `Send Invitation to this PosOperator` (envelope icon) to send this single e-mail invitation, or `Invite all PosOperators` to send all. For an invitation that was already sent, the row shows `Resend invitation to this PosOperator` instead.
   - Click `Create (Auto Invitation)` (lightning icon) to create the PosOperator. This button is not shown in every account.
   - Click `Edit` (pencil icon) to edit the invitation details, for example if the invitation cannot be assigned to your account because the PosOperator's data is incorrect or incomplete.
   - Click `Delete` (recycle icon) to delete the invitation of a PosOperator who is not yet assigned.

   ![List PosOperators that should be invited in the fiskaltrust.Portal with one entry with the status Press Send to invite PosOperator, which is not sent yet, and the buttons to send the invitation, create the PosOperator, edit and delete](images/invitation-status-not-sent.png)

   *Figure 6. An invitation with the status `Press "Send" to invite PosOperator`.*

3. If the status is `Failed sending` (red symbol), hover over the status to see the reason.

   ![List PosOperators that should be invited in the fiskaltrust.Portal with one entry with the status Failed sending, shown with a red symbol, and the buttons to send the invitation, edit and delete](images/invitation-status-failed.png)

   *Figure 7. An invitation with the status `Failed sending`.*

4. If `This E-Mail address already exists` appears, the PosOperator already has an account. For more information, see [Onboarding of existing PosOperators](#onboarding-of-existing-posoperators).

### Onboarding of existing PosOperators

If the message `This E-Mail address already exists` appears, another PosDealer has already onboarded the PosOperator. In this case, the PosOperator requests the assignment to your account.

:::warning
**Do not, under any circumstances, invite this PosOperator again using a different e-mail address.** This causes problems when verifying the business identifications used to authenticate with tax authorities or third-party services.
:::

![Workflow with two swimlanes, PosDealer and PosOperator: the invitation of the PosDealer fails with the error that the e-mail address already exists; the PosOperator searches for the PosDealer, checks name, e-mail address and access rights and requests the assignment; the PosDealer finds the PosOperator in PosOperators, clicks Accept and is then ready to surrogate](images/invitation-existing-posoperator-flowchart.svg)

*Figure 8. Workflow for onboarding a PosOperator who already has an account.*

| Step | Description |
|:----:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |You click `Invite all PosOperators` (`PosDealer` > `Invitation`) and get the message `This E-Mail address already exists`. |
|![Number 2](../../images/numbers/circle-2o.png) |Do not invite this PosOperator again with a different e-mail address. |
|![Number 3](../../images/numbers/circle-3o.png) |Ask the PosOperator to add your account as a new or further PosDealer. |
|![Number 4](../../images/numbers/circle-4o.png) |The PosOperator opens the fiskaltrust.Portal and chooses `PosOperator` > `Search dealer/consultant`. |
|![Number 5](../../images/numbers/circle-5o.png) |The PosOperator searches for your account, for example by name or e-mail address. |
|![Number 6](../../images/numbers/circle-6o.png) |After checking name, e-mail address and access rights, the PosOperator chooses `Request assignment – dealer`. |
|![Number 7](../../images/numbers/circle-7o.png) |You open `PosDealer` > `PosOperators`, find the new PosOperator and click `Accept`. The PosOperator's name becomes an active link that you can use for surrogating. |

*Table 3. Steps to onboard a PosOperator who already has an account.*

### Options with invited PosOperators

Open `PosDealer` > `Invitation` and click `History` to open the invitation history.

![Invitation history in the fiskaltrust.Portal with the date fields and the row buttons marked 1 to 6](images/10-onboarding-portal.png)

*Figure 9. Invitation history.*

| Option | Description |
|:------:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |Start date: restricts the history to invitations from this date. |
|![Number 2](../../images/numbers/circle-2o.png) |End date (after `until`): restricts the history to invitations up to this date. Without dates, the whole history is shown. To narrow down the list further, enter text in the search field (`Search...`); clear the field to see all entries again. |
|![Number 3](../../images/numbers/circle-3o.png) |`Details`: shows the data of the invitation. |
|![Number 4](../../images/numbers/circle-4o.png) |`Send invitation again`: resends the e-mail invitation for this record. |
|![Number 5](../../images/numbers/circle-5o.png) |Delete the record. You cannot delete an e-mail address entirely in the fiskaltrust.Portal, so you cannot transfer an e-mail address that was used once to any other account. |
|![Number 6](../../images/numbers/circle-6o.png) |`Copy link to Clipboard`: shows the direct invitation link. Copy it and send it to your PosOperator by direct message. |

*Table 4. Options in the invitation history.*

To return to the invitation page, click `Overview of PosOperator`.
