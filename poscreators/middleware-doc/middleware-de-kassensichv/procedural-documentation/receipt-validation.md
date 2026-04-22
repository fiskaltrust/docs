---
slug: /poscreators/middleware-doc/germany/receiptvalidation
title: DSFinV-K Receipt Validation
---

# Procedural documentation for clarifying errors shown in the fiskaltrust Receipt Validation

## Receipt Validation

The Fiskaltrust Receipt Validation provides the possibility to validate customer implementations based on queue data. The test cases are defined according to the DSFinV‑K specification. It provides customers with a tool to easily adjust their implementation to fully comply with the requirements set by the tax authorities.

Below you will find a list of all possible errors, including detailed descriptions of how to resolve them.



## Error-1000

### Missing Daily Closing Receipt

This error indicates that at least one receipt exists for the specified business day, but no daily closing receipt (DailyClosing) was found for that date. For every business day with fiscal receipts, a daily closing receipt is required to generate a valid DSFinV‑K export.


## Error-5010

### Vat Cross Net Missmatch
![Receipt validation error E5010](../../images/receiptvalidationE5010.png)

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

## Error-5011

### VAT rate does not match ftChargeItemCase

**Description**  
This error occurs when the VATRate specified on a charge item does not match the VAT rate implied by the given ftChargeItemCase. Each ftChargeItemCase represents a predefined VAT category and therefore implies an expected VAT rate. If the transmitted VATRate conflicts with that expectation, receipt validation fails.

**Example**
Position 1 in receipt ft19F#IT416: VATRate (20.00%) does not match the rate implied by ftChargeItemCase (0x4445000000000001, expected 19.00%).

**Cause**  
The POS system transmitted inconsistent VAT information for a charge item:
- The ftChargeItemCase implies a fixed VAT rate.
- The VATRate field contains a different percentage.

**Resolution**
Ensure that the VAT information is consistent:
- If the VATRate is correct, use a matching ftChargeItemCase.
- If the ftChargeItemCase is correct, adjust the VATRate accordingly.
- Verify that the POS tax configuration matches the fiscal country configuration.

**Notes**
This validation prevents incorrect VAT reporting in DSFinV-K exports and fiscal audits.
