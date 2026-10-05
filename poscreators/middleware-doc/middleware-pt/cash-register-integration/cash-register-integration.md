---
slug: /poscreators/middleware-doc/portugal/cash-register-integration
title: Cash Register Integration
description: Cash register integration under Portuguese law, including the validation errors the Portuguese Middleware returns.
tags: [Cash Register Integration, Portugal, Middleware]
---

# Cash Register Integration

This chapter describes the cash register integration in accordance with Portuguese law. The general rules for cash register integration are described in the Chapter [Cash Register Integration](../../general/cash-register-integration/cash-register-integration-regular-workflow.md) of the general part.

## Validation errors

The Portuguese Middleware validates each `ReceiptRequest` before it signs it. If a request fails validation, the receipt is not signed, no receipt number is consumed, and the response is returned as described in [Error Handling](../../general/cash-register-integration/error-handling.md#how-error-messages-are-returned):

- `ftState` is `0x5054_2000_EEEE_EEEE` (see [ftState](../reference-tables/service-status-ftstate.md)).
- `ftSignatures` contains exactly one failure signature with `Caption` `FAILURE`, `ftSignatureFormat` `0x1` (text) and `ftSignatureType` `0x5054_2000_0000_3000`.
- `Data` contains the error message.

The response contains one failure signature, even if the request violates several rules. Correct the reported error and send the request again; further errors are reported one at a time.

### Message format

`Data` has the following format:

```
Validation error [<Code>]: <Message> (Field: <Field>, Index: <Index>)
```

- `<Code>` identifies the rule, for example `EEEE_ReceiptNotBalanced`. The codes are listed in the tables below.
- `<Message>` describes the error, usually also starting with `EEEE_`.
- `<Field>` names the request field the rule applies to, for example `cbChargeItems.VATRate`. It is empty for some rules.
- `<Index>` is the 0-based index of the affected item in `cbChargeItems` or `cbPayItems`. It is empty for rules that do not apply to a single item. The same 0-based index is used for "position" in charge item messages; it is not the value of `Position`.

```json
{
  "ftSignatures": [
    {
      "ftSignatureFormat": 1,
      "ftSignatureType": 5788286605450031104,
      "Caption": "FAILURE",
      "Data": "Validation error [EEEE_ReceiptNotBalanced]: EEEE_Receipt is not balanced: Sum of charge items (12.30) does not match sum of pay items (12.00). Difference: 0.30. (Field: , Index: )"
    }
  ],
  "ftState": 5788286609458654958
}
```

*Figure 1. Shortened example of a validation error response from a Portuguese queue: `ftState` `0x5054_2000_EEEE_EEEE` with a failure signature of type `0x5054_2000_0000_3000`.*

The POS system should base its logic on the `ftState` and use `Code` and the message for display and logging.

### General checks

| Code | Triggered when |
|------|----------------|
| `EEEE_InvalidCountryCodeForPT` | The country code in `ftReceiptCase` is not `PT` (`0x5054`). |
| `EEEE_ChargeItemsMissing` | `cbChargeItems` is `null`. |
| `EEEE_PayItemsMissing` | `cbPayItems` is `null`. |
| `EEEE_InvalidCountryCodeInChargeItemsForPT` | The country code of any `ftChargeItemCase` is not `PT`. |
| `EEEE_InvalidCountryCodeInPayItemsForPT` | The country code of any `ftPayItemCase` is not `PT`. |
| `EEEE_OnlyEuroCurrencySupported` | `Currency` is not `EUR`. |
| `EEEE_TrainingModeNotSupported` | The training flag is set in `ftReceiptCase`. |
| `EEEE_ReceiptReferenceAlreadyUsed` | A receipt with the same `cbReceiptReference` has already been processed successfully. `cbReceiptReference` must be unique. |
| `EEEE_CbReceiptMomentNotUtc` | `cbReceiptMoment` is not in UTC. |
| `EEEE_ReceiptMomentTimeDifferenceExceeded` | `cbReceiptMoment` differs from the Middleware's `ftReceiptMoment` by more than 1 minute. |
| `EEEE_InvalidPositions` | `Position` is set on charge items or pay items, but the positions do not start at 1 and increase by 1 without gaps. |

*Table 1. General validation rules.*

### cbUser and cbCustomer

| Code | Triggered when |
|------|----------------|
| `EEEE_UserTooShort` | `cbUser` is missing or shorter than 3 characters. |
| `EEEE_InvalidUserStructure` | `cbUser` is not a valid JSON object with the structure `UserId`, `UserDisplayName`, `UserEmail`. |
| `EEEE_CustomerInvalid` | `cbCustomer` cannot be read as a customer object. |
| `EEEE_InvalidPortugueseTaxId` | `cbCustomer.CustomerVATId` is set, `CustomerCountry` is empty or `PT`, and the value is not a valid Portuguese NIF (9 digits, valid first digit and check digit). |

*Table 2. Validation rules for the user and the customer.*

### Charge items

| Code | Triggered when |
|------|----------------|
| `EEEE_ChargeItemDescriptionMissing` | `Description` is empty. |
| `EEEE_ChargeItemDescriptionTooShort` | `Description` is shorter than 3 characters. |
| `EEEE_ChargeItemDescriptionEncodingInvalid` | `Description` contains characters that cannot be encoded in Windows-1252. |
| `EEEE_ChargeItemVATRateMissing` | `VATRate` is negative. |
| `EEEE_ChargeItemAmountMissing` | `Amount` is 0. |
| `EEEE_ChargeItemQuantityZeroNotAllowed` | `Quantity` is 0. |
| `EEEE_UnsupportedVatRate` | The VAT rate of `ftChargeItemCase` is not one of _discounted 1_ (6 %), _discounted 2_ (13 %), _normal_ (23 %) or _not taxable_ (0 %). See [ftChargeItemCase](../reference-tables/type-of-service-ftchargeitemcase.md). |
| `EEEE_VatRateMismatch` | `VATRate` does not match the VAT rate of `ftChargeItemCase` (6, 13, 23 or 0 %). |
| `EEEE_VatAmountMismatch` | `VATAmount` differs from `Amount / (100 + VATRate) * VATRate` by more than 0.01. If `VATAmount` is not set, the Middleware calculates it. |
| `EEEE_UnsupportedChargeItemServiceType` | The type of service in `ftChargeItemCase` is not _unknown_, _delivery_, _other service_, _tip_, _catalog service_ or _receivable_. |
| `EEEE_ZeroVatRateMissingNature` | `VATRate` is 0, but the nature of VAT (`NN`) in `ftChargeItemCase` is not set. A tax exemption reason is required. Does not apply to receivable items. |
| `EEEE_UnknownTaxExemptionCode` | `VATRate` is 0 and the nature of VAT in `ftChargeItemCase` is not a known Portuguese tax exemption code. |
| `EEEE_DiscountVatRateOrCaseMismatch` | A discount or extra has a different `VATRate` or VAT rate in `ftChargeItemCase` than the line item it belongs to. |
| `EEEE_DiscountExceedsArticleAmount` | The discounts on a line item are greater than the amount of the line item. |
| `EEEE_PositiveDiscountNotAllowed` | A discount or extra has a positive `Amount`. Does not apply to refunds and voids. |
| `EEEE_NegativeQuantityNotAllowed` | A charge item that is not a discount has a negative `Quantity`. Does not apply to refunds and voids. |
| `EEEE_NegativeAmountNotAllowed` | A charge item that is not a discount has a negative `Amount`. Does not apply to refunds and voids. |

*Table 3. Validation rules for charge items.*

### Totals and legal limits

| Code | Triggered when |
|------|----------------|
| `EEEE_ReceiptNotBalanced` | The sum of `cbChargeItems[].Amount` differs from the sum of `cbPayItems[].Amount` by more than 0.01. Not checked for table checks (`0x0006`) and pro forma invoices (`0x0007`). |
| `EEEE_CashPaymentExceedsLimit` | The sum of cash pay items is greater than 3,000 €. |
| `EEEE_PosReceiptNetAmountExceedsLimit` | The net amount of a POS receipt (`0x0001`) is greater than 100 €. Such receipts require a different document type. Does not apply to refunds. |
| `EEEE_OtherServiceNetAmountExceedsLimit` | The net amount of charge items with type of service _other service_ on a POS receipt (`0x0001`) is greater than 100 €. Does not apply to refunds. |
| `EEEE_WorkingDocumentPayItemsNotAllowed` | A table check (`0x0006`) or pro forma invoice (`0x0007`) contains pay items. |
| `EEEE_TransportationIsNotSupported` | A delivery note (`0x0005`) or pro forma invoice (`0x0007`) has the transport information flag set. |

*Table 4. Validation rules for totals, legal limits and receipt types.*

### Handwritten receipts

If the handwritten flag is set in `ftReceiptCase`, only the following rules are checked in addition to the general checks and the `cbUser` checks.

| Code | Triggered when |
|------|----------------|
| `EEEE_HandwrittenReceiptsNotSupported` | The handwritten flag is combined with a refund, partial refund or void. |
| `EEEE_HandwrittenReceiptOnlyForInvoices` | The receipt case is not an invoice (`0x1000`–`0x1003`). |
| `EEEE_HandwrittenReceiptSeriesAndNumberMandatory` | `ftReceiptCaseData.PT.Series` or `ftReceiptCaseData.PT.Number` is missing, or `Number` is less than 1. |
| `EEEE_HandwrittenReceiptSeriesInvalidCharacter` | `ftReceiptCaseData.PT.Series` contains a space. |
| `EEEE_HandwrittenReceiptSeriesNumberAlreadyLinked` | The combination of series and number has already been used by another handwritten receipt. |

*Table 5. Validation rules for handwritten receipts.*

### References, refunds, voids and payment transfers

| Code | Triggered when |
|------|----------------|
| `EEEE_PreviousReceiptReference` | `cbPreviousReceiptReference` is missing on a payment transfer (`0x0002`), void, refund, partial refund or copy (`0x3010`). |
| `EEEE_RefundMissingPreviousReceiptReference` | The refund flag is set and `cbPreviousReceiptReference` is missing. |
| `EEEE_PreviousReceiptLineItemMismatch` | `cbPreviousReceiptReference` is set on a receipt that is not a refund, void or payment transfer, and the receipt shares no line item with the referenced receipt. |
| `EEEE_PreviousReceiptIsVoided` | The referenced receipt has already been voided. |
| `EEEE_VoidAlreadyExists` | A void for the referenced receipt already exists. |
| `EEEE_CannotVoidInvoicedDocument` | The referenced document has already been invoiced. |
| `EEEE_CannotVoidRefundedDocument` | The referenced document has already been refunded. |
| `EEEE_CannotVoidPartiallyRefundedDocument` | The referenced document has already been partially refunded. |
| `EEEE_RefundAlreadyExists` | A full refund (or, for a payment transfer, a payment transfer) for the referenced receipt already exists. |
| `EEEE_MixedRefundItemsNotAllowed` | A partial refund contains charge items with and without the refund flag. |
| `EEEE_MixedRefundPayItemsNotAllowed` | A partial refund contains pay items with and without the refund flag. |
| `EEEE_PaymentTransferRequiresAccountReceivableItem` | A payment transfer (`0x0002`) has no charge item with type of service _receivable_. |
| `EEEE_PaymentTransferForRefundedReceipt` | The receipt referenced by a payment transfer has already been refunded. |
| `EEEE_PaymentTransferCustomerMismatch` | `cbCustomer` of the payment transfer differs from the referenced invoice. The message lists the different fields. |

*Table 6. Validation rules for references, refunds, voids and payment transfers.*

The following errors have an empty `Code` (`Validation error []: ...`). The message names the field that does not match the referenced receipt.

| Message starts with | Triggered when |
|---------------------|----------------|
| `EEEE_Void does not match the original invoice` | The void does not contain the same items as the referenced receipt with negated `Quantity` and `Amount`. |
| `EEEE_Full refund does not match the original invoice` | The refund does not contain the same items as the referenced receipt with negated `Quantity` and `Amount`. |
| `EEEE_Partial refund does not match the original invoice` | A refunded item cannot be found in the referenced receipt, or its unit price, VAT rate or `ftChargeItemCase` differs, or the refunded amounts exceed the original. |
| `[EEEE_PartialRefund] Total amount to be refunded` | The total refunded amount for an item, including earlier partial refunds, exceeds the original amount. |
| `EEEE_Payment transfer amount` | The payment transfer amount exceeds the remaining receivable amount of the referenced invoice. |
| `The original receipt '...' is not a valid receipt for payment transfer` | The receipt referenced by a payment transfer is not an invoice (`0x1000`–`0x1003`). |
| `Multiple receipt references are currently not supported.` | A partial refund references more than one receipt. |

*Table 7. Validation errors without a code.*
