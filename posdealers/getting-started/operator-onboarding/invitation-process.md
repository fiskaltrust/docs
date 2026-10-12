---
slug: /posdealers/getting-started/operator-onboarding/invitation-process
title: Invitation process
description: Inviting a single PosOperator or bulk-inviting several via CSV in the Portal, managing invitations and handling errors.
tags: [Invitation, Onboarding, Portal, PosDealers, Troubleshooting]
---
# Invitation process

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

1. Choose `PosDealer` > `PosOperators` to see the PosOperators already assigned to your account.
2. Choose `PosDealer` > `Invitation`. In Austria, Germany and France, `PosOperator` > `Invitation` opens the same page.
3. In `PosOperator invitation settings`, check or change the settings described in Table 2.
4. Continue with [Invitation of a single PosOperator](#invitation-of-a-single-posoperator) or [Bulk invitation of PosOperators](#bulk-invitation-of-posoperators).

![PosOperator invitation settings in the fiskaltrust.Portal with the PDF-Attachment, Additional information and Surrogate rights fields marked 1 to 3](images/11-onboarding-portal.png)

*Figure 1. PosOperator invitation settings in the fiskaltrust.Portal.*

| Setting | Description |
|:-------:|-------------|
|![Number 1](../../images/numbers/circle-1o.png)| `PDF-Attachment`: Attach a document to the e-mail invitation. Use it as an accompanying letter that explains that you, as a PosDealer, are extending your offers and invite your PosOperators to register with the fiskaltrust.Portal via the confirmation link. This avoids confusion when PosOperators receive an e-mail from an unknown sender such as sandbox@fiskaltrust.TLD or robot@fiskaltrust.TLD. Select the PDF file with `Choose file` and upload it with `Import`. After the upload, `Download invitation pdf` and `Delete invitation pdf` are available. |
|![Number 2](../../images/numbers/circle-2o.png)| `Additional information for the PosOperator. This text will be added to the invitation e-mail.`: Add your own text of up to 1000 characters to the automated e-mail invitation (see [Preview of the e-mail invitation](#preview-of-the-e-mail-invitation)). Use it to inform your PosOperators personally, for the same reason as the PDF attachment. The counter next to the field shows the remaining characters. The text is saved when you leave the field. |
|![Number 3](../../images/numbers/circle-3o.png)| `Surrogate rights`: The permission level you get when you switch to the PosOperator's account (surrogating). The options are `Full (Write/Read, Contract Conclusion)` (default), `Write/Read`, `Read Only` and `None`. Select `Full (Write/Read, Contract Conclusion)`. With any other option you can access the PosOperator's account, but you cannot conclude contracts on the PosOperator's behalf, which is necessary for cooperation with third parties. For more information, see [Surrogating](surrogating.md). |

*Table 2. Invitation settings.*

## Invitation of a single PosOperator

Invite a single PosOperator, for example, when you give on-site support to a PosOperator who wants to use the fiskaltrust services immediately when a POS system is put into operation, or when you test the fiskaltrust.Portal and its processes in the sandbox.

Depending on the country, when a PosOperator is registered for the first time, further master data can be retrieved from the relevant authority and checked by entering a tax number.

![Flowchart of the single invitation: the PosDealer configures the invitation, adds the PosOperator and sends the invitation; the PosOperator accepts it, activates the PosOperator role and verifies master data and outlets; the PosDealer then checks whether the PosOperator name is an active link and either surrogates or resends the invitation](images/1-onboarding-individual-relaunch.png)

*Figure 2. Process of inviting a single PosOperator.*

### Steps

1. Choose `PosDealer` > `Invitation`.
2. Check the settings as described in [Preparation of invitations](#preparation-of-invitations).
3. Choose `Add`.
4. Fill in the mandatory fields. They are required so that the PosOperator can be found and assigned correctly in the fiskaltrust.Portal via the e-mail address:
   - `Company data`: company name, e-mail address, address line 1, postal code, city, country
   - `User data`: first name, last name, contact e-mail address
5. Fill in the tax identification numbers. They are not mandatory for the invitation, but they and their validation are **essential** for the correct management of the cash register systems (for example AccountIdVat, AccountIdGln, AccountUStIdNr).
6. Choose `Save`. The PosOperator is added to the list `PosOperators that should be invited`.
7. Choose `Invite all PosOperators` to send the e-mail invitation.

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

![Flowchart of the bulk invitation of PosOperators from a CSV file](images/2-onboarding-bulk-relaunch.png "Invitation of PosOperators in a bulk process")

*Figure 3. Process of the bulk invitation of PosOperators.*

### Steps

![Invitation page in the fiskaltrust.Portal with the menu entry, invitation settings, Choose file, Import, Download demo CSV file and the button to send all invitations marked](images/6-onboarding-portal.png)

*Figure 4. Bulk invitation via CSV file in the fiskaltrust.Portal.*

| Step | Description |
|:----:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |Choose `PosDealer` > `Invitation`. |
|![Number 2](../../images/numbers/circle-2o.png) |Check the settings as described in [Preparation of invitations](#preparation-of-invitations). |
|![Number 3](../../images/numbers/circle-3o.png) |Choose `Download demo CSV file`. |
|![Number 4](../../images/numbers/circle-4o.png) |Open the demo CSV file. |
|![Number 5](../../images/numbers/circle-5o.png) |Add the data of the PosOperators as described in [Fields of the CSV file](#fields-of-the-csv-file) and save the file as a CSV file. |
|![Number 6](../../images/numbers/circle-6o.png) |Go back to the fiskaltrust.Portal and choose `PosDealer` > `Invitation`. |
|![Number 7](../../images/numbers/circle-7o.png) |In `PosOperators that should be invited`, under `Import CSV file`, select your CSV file with `Choose file`. |
|![Number 8](../../images/numbers/circle-8o.png) |Choose `Import`. The data is uploaded and checked for duplicate or incomplete records. You can check and complete each record. If records are incomplete, the import error page opens (see [Handling error messages](#handling-error-messages)). |
|![Number 9](../../images/numbers/circle-9o.png) |Choose `Invite all PosOperators` to send the e-mail invitation to each business partner in your CSV file. For a preview of the e-mail, see [Preview of the e-mail invitation](#preview-of-the-e-mail-invitation). |

*Table 3. Steps of the bulk invitation, shown in Figure 4.*

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

If mandatory fields in the CSV file are empty or wrong, the import error page lists each error with its line (`Line`) and message (`Error`).

1. Note the error messages.
2. Add the missing data in the respective lines of the CSV file.
3. Choose `Back` and import the corrected file again.

![Import error page in the fiskaltrust.Portal listing CSV lines with missing e-mail address, address line 1, ZIP code, city and country, marked 1 to 5](images/7-onboarding-portal.png)

*Figure 5. Import error messages after uploading an incomplete CSV file.*

| Message | Description |
|:-------:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |`Email-address is required!` |
|![Number 2](../../images/numbers/circle-2o.png) |`Address line 1 is required!` |
|![Number 3](../../images/numbers/circle-3o.png) |`ZIP-code is required!` |
|![Number 4](../../images/numbers/circle-4o.png) |`City is required!` |
|![Number 5](../../images/numbers/circle-5o.png) |`Country is required!` |

*Table 4. Import error messages for missing mandatory CSV fields.*

## Managing the invitations

If the preparation is complete, the invitation process runs automatically. If problems arise, you can fix most of them yourself. For example, if a PosOperator says that no e-mail invitation arrived, check the invitation history.

### Troubleshooting

#### Status and error messages

![Invitation list in the fiskaltrust.Portal with the status icon and the send, edit and delete buttons of a row marked 1 to 4](images/8-onboarding-portal.png)

*Figure 6. Invitation list with invitation status and row actions.*

| Step | Description |
|:----:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |Check the `Status` of the invitation: `Invitation Sent`, `Press "Send" to invite PosOperator` (not sent yet), or `Failed sending` (red symbol; hover over it to see the reason). |
|![Number 2](../../images/numbers/circle-2o.png) |Choose `Send Invitation to this PosOperator` (envelope icon) to send this single e-mail invitation, or `Invite all PosOperators` to send all. For an invitation that was already sent, the row shows `Resend invitation to this PosOperator` instead. |
|![Number 3](../../images/numbers/circle-3o.png) |If the invitation cannot be assigned to your account because the PosOperator's data is incorrect or incomplete, choose `Edit` to correct it. |
|![Number 4](../../images/numbers/circle-4o.png) |Choose `Delete` to remove the data of a PosOperator who is not yet assigned. |
| |If `This E-Mail address already exists` appears, see [Onboarding of existing PosOperators](#onboarding-of-existing-posoperators). |

*Table 5. Checking the invitation status and handling error messages.*

#### Assigning PosOperators in a bulk process

![Invitation page in the fiskaltrust.Portal with the buttons to send all invitations, add a PosOperator and open the history marked 1 to 3](images/9-onboarding-portal.png)

*Figure 7. Buttons for assigning PosOperators in a bulk process.*

| Button | Description |
|:------:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |`Invite all PosOperators`: sends the e-mail invitation to **all** PosOperators in the list who have not yet been invited. |
|![Number 2](../../images/numbers/circle-2o.png) |`Add`: adds a single PosOperator manually. For more information, see [Invitation of a single PosOperator](#invitation-of-a-single-posoperator). |
|![Number 3](../../images/numbers/circle-3o.png) |`History`: opens the invitation history to check or repair e-mail invitations (see [Options with invited PosOperators](#options-with-invited-posoperators)). |

*Table 6. Buttons for assigning PosOperators in a bulk process.*

#### Onboarding of existing PosOperators

If the message `This E-Mail address already exists` appears, another PosDealer has already onboarded the PosOperator. In this case, the PosOperator requests the assignment to your account.

:::warning
**Do not, under any circumstances, invite this PosOperator again using a different e-mail address.** This causes problems when verifying the business identifications used to authenticate with tax authorities or third-party services.
:::

![Flowchart: the PosDealer's invitation fails with "E-mail address already exists", the PosOperator searches for the PosDealer and requests the assignment, the PosDealer accepts and can then surrogate](images/15-onboarding-already-existing-PosOperators.png)

*Figure 8. Onboarding a PosOperator who already has an account.*

| Step | Description |
|:----:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) |You choose `Invite all PosOperators` (`PosDealer` > `Invitation`) and get the message `This E-Mail address already exists`. |
|![Number 2](../../images/numbers/circle-2o.png) |Do not invite this PosOperator again with a different e-mail address. |
|![Number 3](../../images/numbers/circle-3o.png) |Ask the PosOperator to add your account as a new or further PosDealer. |
|![Number 4](../../images/numbers/circle-4o.png) |The PosOperator opens the fiskaltrust.Portal and chooses `PosOperator` > `Search dealer/consultant`. |
|![Number 5](../../images/numbers/circle-5o.png) |The PosOperator searches for your account, for example by name or e-mail address. |
|![Number 6](../../images/numbers/circle-6o.png) |After checking name, e-mail address and access rights, the PosOperator chooses `Request assignment – dealer`. |
|![Number 7](../../images/numbers/circle-7o.png) |You choose `PosDealer` > `PosOperators`, find the new PosOperator and choose `Accept`. The PosOperator's name becomes an active link that you can use for surrogating. |

*Table 7. Steps to onboard a PosOperator who already has an account.*

#### Options with invited PosOperators

Choose `PosDealer` > `Invitation` > `History` to open the invitation history.

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

*Table 8. Options in the invitation history.*

To return to the invitation page, choose `Overview of PosOperator`.
