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


