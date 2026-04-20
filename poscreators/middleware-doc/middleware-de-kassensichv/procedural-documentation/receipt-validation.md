---
slug: /poscreators/middleware-doc/germany/receiptvalidation
title: DSFinV-K Receipt Validation
---

# Procedural documentation for clarifying errors shown in the fiskaltrust Receipt Validation

## Receipt Validation

The Fiskaltrust Receipt Validation provides the possibility to validate customer implementations based on queue data. The test cases are defined according to the DSFinV‑K specification. It provides customers with a tool to easily adjust their implementation to fully comply with the requirements set by the tax authorities.

Below you will find a list of all possible errors, including detailed descriptions of how to resolve them.



## Error1000

### Missing Daily Closing Receipt

This error indicates that at least one receipt exists for the specified business day, but no daily closing receipt (DailyClosing) was found for that date. For every business day with fiscal receipts, a daily closing receipt is required to generate a valid DSFinV‑K export.


## Error 5010

### Vat Cross Net Missmatch

### Description

This error indicates an inconsistency between Net, VAT, and Gross amounts on a receipt line item.

### Background

fiskaltrust applies the gross (brutto) calculation method.  
In this method, the net amount and VAT are derived from the gross amount using the applicable VAT rate.

The validation verifies that:

- Gross − VATAmount = Net
- Net × VATRate = VATAmount

Minor rounding differences may occur, depending on the POS calculation method.

### Cause

This error can occur in the following cases:

- The POS system uses a net-based calculation method, while fiskaltrust validates using the gross-based method
- A rounding difference occurs during the conversion between net, VAT, and gross values
- The rounding difference exceeds an acceptable tolerance
- Incorrect or inconsistent values were sent for Net, VATAmount, Gross, or VATRate

While small rounding differences are acceptable, larger deviations indicate incorrect data sent by the POS system.

### Resolution

To resolve this error, perform the following checks:

**Verify calculation method**

Ensure the POS system uses a gross-based (brutto) calculation or produces values compatible with it.

**Check rounding behavior**

Validate that rounding is applied consistently and only at the correct calculation step.

**Validate transmitted values**

Ensure that Net, VATAmount, Gross, and VATRate are mathematically consistent.  
Avoid manually mixing net-calculated and gross-calculated values.

**Review unreasonable differences**

If the difference is too large to be explained by rounding, incorrect values are being transmitted and must be corrected.

### Notes

- Small rounding differences may occur due to calculation order and decimal precision.
- Unreasonable or large differences are always treated as errors.
- The POS system is responsible for transmitting internally consistent fiscal values.
