---
slug: /poscreators/middleware-doc/poland/data-structures
title: Data Structures
---

# Data Structures

This chapter expands on the descriptions of the country-specific Data Structures, covered in the Chapter [Data Structures](../../general/data-structures/data-structures.md) of the General Part, with information applicable to the Polish market.

## Currency

The queue currency for Poland is **PLN**. The receipt (`Currency`) and every charge item and pay item must carry `PLN` explicitly — the data format defaults to EUR, so POS Creators must set the currency on each request. Requests violating this rule are rejected with the validation error code `CurrencyMustMatchMarket`.

## cbCustomer — buyer's NIP on a paragon z NIP

For a receipt with the buyer's tax ID (paragon z NIP), flag the receipt case with `ReceiverIsBusiness` (`0x0000_0020_0000`) and hand over the buyer's NIP as `CustomerVATId` inside the `cbCustomer` object (MiddlewareCustomer structure). Requests with the flag but without a NIP are rejected. Until 2026-12-31, such receipts up to 450 PLN act as simplified invoices.

## Sale and return positions

A Polish fiscal document must not mix sale and return positions: the register protocol processes returns as separate non-fiscal documents. Send returns as their own receipts flagged with `IsReturn/IsRefund` (`0x0100_0000_0000`) and reference the original receipt via `cbPreviousReceiptReference`. Discounts/extras and voids are position modifiers, not return positions.
