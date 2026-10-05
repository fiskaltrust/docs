---
slug: /poscreators/middleware-doc/e-invoicing/payitems
title: Payment data (cbPayItems)
---

# Payment data (`cbPayItems`) in eInvoicing

This page describes which fields of the [`PayItem`](../general/data-structures/data-structures.md#payitem) data structure in `cbPayItems` are written to the payment fields of the European eInvoicing standard **EN 16931**. For the buyer fields, see [Buyer data (`cbCustomer`) in eInvoicing](./cbcustomer.md).

The links in the following table point to the [Peppol BIS Billing 3.0](https://docs.peppol.eu/poacc/billing/3.0/bis/) syntax reference, which documents every EN 16931 business term with its UBL element.

## Field mapping

| `PayItem` field | EN 16931 business term | UBL element |
| --- | --- | --- |
| `ftPayItemCase` | BT-81 Payment means type code | [`cac:PaymentMeans/cbc:PaymentMeansCode`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-PaymentMeans/cbc-PaymentMeansCode/) |
| `MoneyNumber` (card payments) | BT-87 Payment card primary account number | [`cac:PaymentMeans/cac:CardAccount/cbc:PrimaryAccountNumberID`](https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice/cac-PaymentMeans/cac-CardAccount/cbc-PrimaryAccountNumberID/) |

*Table 1. Mapping of `PayItem` fields to EN 16931 business terms.*

## Card payments

For a pay item with the case `DebitCardPayment` (`0x0004`) or `CreditCardPayment` (`0x0005`), send the number of the payment card in `MoneyNumber`, masked to at most the first 6 and the last 4 digits, for example `XXXX XXXX XXXX 4242`.

- Only the **last 4 digits** of `MoneyNumber` are written to BT-87. EN 16931 rule BR-51 allows at most the first 6 and the last 4 digits of a card number in an invoice.
- EN 16931 allows one payment card per invoice. If a receipt is paid with several payment means, the eInvoice names one of them: the amount on credit (`AccountsReceivable`, `0x0009`) if there is one, otherwise the largest payment.

Whether the card number is required depends on the country and its format. See the eInvoicing setup page of the respective country.
