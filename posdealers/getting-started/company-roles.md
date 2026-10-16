---
slug: /posdealers/getting-started/company-roles
title: Company Roles
description: The principal company roles in the fiskaltrust.Portal, what each one can do, and how to activate or deactivate a role.
tags: [Company Roles, Portal, Onboarding, PosDealers]
---
# Company Roles

:::info summary

After reading, you can activate or deactivate appropriate roles for customers and explain their effects.

:::

fiskaltrust distinguishes between five principal **company roles** in the fiskaltrust.Portal. Each role has its own audience, features and permissions. You find the roles of your company in `Company info` > `Overview`, in the `Roles` section.

![Roles section on the Company overview page in the fiskaltrust.Portal, with the role descriptions and toggles for PosOperator, PosDealer, PosCreator, Consultant and AppCreator, all switched off](./images/company-roles/roles.png)

*Figure 1. The `Roles` section in `Company info` > `Overview`.*

## Principal roles

| Role | Description |
| ---- | ----------- |
| **PosOperator** | For **end users of POS systems** who manage their POS receipts in the context of the fiskaltrust services. They purchased the POS platform from their PosDealer and operate the POS system.<br /><br />Accounts with this role use the Portal primarily to access their fiscal data and to perform maintenance steps not covered by their PosDealer. |
| **PosDealer** | For **POS system distributors** who sell POS systems to PosOperators and support and maintain these setups.<br /><br />Accounts with this role use the Portal primarily to act on behalf of their PosOperators. The PosDealer role includes invitation management, a credit limit, rollouts of CashBox setups and maintenance for PosOperators. |
| **PosCreator** | For **manufacturers who develop POS systems**. PosCreators are not involved in the rollout at PosOperators; they focus on the technical integration of the Middleware.<br /><br />PosCreators use the Portal primarily to enter their POS systems and to invite PosDealers to use them. In addition to the business areas and properties of the POS system, the Portal creates a `PosSystemId` as a unique identifier.<br /><br />**The `PosSystemId` is currently not mandatory in every country, but its use in the fiskaltrust.Portal is crucial for our compliance service.** |
| **Consultant** | For **tax consultants** who advise PosOperators on related topics.<br /><br />Accounts with this role use the Portal primarily to access the fiscal data of associated and authorized PosOperator accounts. |
| **AppCreator** | For individuals or entities that register and integrate third-party applications in the fiskaltrust.Portal. |

*Table 1. Principal company roles.*

## Additional roles

Depending on the market, the `Roles` section can show further roles.

| Role | Shown in | Description |
| ---- | -------- | ----------- |
| **PosDealer auto-invitation (opt-in)** | Germany and Italy | An **optional add-on** to the PosDealer role for POS system distributors who want to automate the onboarding of their PosOperators as much as possible.<br /><br />Accounts with this role get an extended onboarding user interface. It allows them to fully and legally activate a PosOperator's account by signing the PosOperator's partner contracts as a representative, instead of sending a regular invitation that the PosOperator must accept first.<br /><br />The toggle is only shown when the PosDealer role is active. **This role may require particular attention to legal aspects on your side.** |
| **PosDealer for RKSV Sign** | Austria | Adds the capability to manage RKSV.Sign products in the account. RKSV.Sign is a sign-only product in Austria that replaces HSMs and smart cards in existing implementations for POS systems where the Middleware cannot be used. |
| **PosOperatorOptInIVAServizi** | Italy | For PosOperators who manage the provision of access credentials or delegation. To deactivate the PosOperator role, deactivate this role first. |

*Table 2. Additional roles shown depending on the market.*

:::caution

You can select more than one role. **Only pick the roles that apply to your business case**, because each role entails different contractual requirements and obligations.

:::

## Prerequisites

- Your user has the `Contract conclusion` authorization. Without it, the role toggles are disabled. For more information, see [Manage user rights](registration.md#manage-user-rights).
- If **PosOperator** is the only principal role of your company, you cannot activate PosDealer, PosCreator, Consultant or AppCreator. The Portal shows the tooltip "When PosOperator role is enabled, you can't sign any other roles."

## Activate a role

1. In the left-hand navigation, open `Company info` > `Overview`.
2. In the `Roles` section, **turn on the toggle** of the role you want to activate: from <em><img src={require("./images/company-roles/toggle-off.png").default} alt="Role toggle switched off" width="34" style={{verticalAlign: "middle"}} /></em> to <em><img src={require("./images/company-roles/toggle-on.png").default} alt="Role toggle switched on" width="34" style={{verticalAlign: "middle"}} /></em>. The Portal opens the agreement page of the role.

   ![Roles section on the Company overview page in the fiskaltrust.Portal with the toggles for PosOperator, PosDealer, PosCreator, Consultant and AppCreator all turned off; PosOperator and PosDealer show the note that the role was disabled and can be enabled again with the toggle](./images/company-roles/roles-all-off.png)

   *Figure 2. The `Roles` section with all role toggles turned off.*

3. Read the **agreement**.
4. Enter your **legal name** in the `Signatory` field at the bottom of the page.
5. Select the checkbox `Read and accepted T&C and Privacy Policy`.
6. Click `Sign`.

   ![PosDealer Contract page in the fiskaltrust.Portal with the contract text (blurred), the Signatory field, the checkbox to accept the terms and conditions and the privacy policy, and the Cancel and Sign buttons](./images/company-roles/sign-contract.png)

   *Figure 3. Agreement page of a role, here the `PosDealer Contract`, with the `Signatory` field and the `Sign` button.*

**Result:** The role is active for your account. You receive an email confirming the activation of the role. In the `Roles` section, you can download the signed contract with `Download Contract (pdf.)`.

## Deactivate a role

1. In the left-hand navigation, open `Company info` > `Overview`.
2. In the `Roles` section, **turn off the toggle** of the role you want to deactivate: from <em><img src={require("./images/company-roles/toggle-on.png").default} alt="Role toggle switched on" width="34" style={{verticalAlign: "middle"}} /></em> to <em><img src={require("./images/company-roles/toggle-off.png").default} alt="Role toggle switched off" width="34" style={{verticalAlign: "middle"}} /></em>. The Portal opens the confirmation page for the termination of the role contract.

   ![Roles section on the Company overview page in the fiskaltrust.Portal with the PosDealer toggle switched on, the confirmation that the company is assigned as PosDealer and the Download Contract button; PosOperator shows the note that the role was disabled, and the toggles for PosCreator, Consultant and AppCreator are switched off](./images/company-roles/role-deactivate.png)

   *Figure 4. The `Roles` section with the active PosDealer role and its `Download Contract (pdf.)` button.*

3. Enter your **legal name** in the `Signatory` field at the bottom of the page.
4. Select the checkbox `Read and accepted T&C and Privacy Policy`.
5. Click `Sign`.

   ![PosDealer Contract termination page in the fiskaltrust.Portal with the note that the existing contract is terminated, the company address, the termination text (blurred), the Signatory field, the checkbox to accept the terms and conditions and the privacy policy, and the Cancel and Sign buttons](./images/company-roles/cancel-contract.png)

   *Figure 5. Termination page of a role, here for the PosDealer role, with the `Signatory` field and the `Sign` button.*

**Result:** The role is inactive for your account. You receive an email confirming the deactivation of the role. To activate the role again, turn on its toggle and sign the agreement again.
