---
slug: /poscreators/middleware-doc/poland/receipt-case-definitions
title: Receipt Case Definitions
---

# Receipt Case Definitions

This chapter expands on the definitions of Receipt Cases covered in Chapter ["Receipt Case Definitions"](../../general/receipt-case-definitions/receipt-case-definitions.md) of the General Part, with country-specific information applicable to the Polish market.

## Processing overview

How the Middleware processes each receipt case category in Poland:

| **Category** | **Cases** | **Polish processing** |
| ------------ | --------- | --------------------- |
| Receipt | `0000`, `0001`, `0004` | Sent to the certified register through the SCU; the register assigns the fiscal document number and reports to the CRK. `0000` (unknown) is handled like a POS receipt (`0001`). |
| Receipt | `0002`, `0003` | Recorded by the queue only (no register interaction). `0003` covers sales outside the fiscalization obligation. |
| Receipt | `0005`–`0007` | Rejected as not supported for the Polish market. |
| Invoice | `1000`–`1003` | **Never sent to the register.** Persisted by the queue and marked with the signature *"Stored, not fiscalized"* (`0x504C_2000_0000_0106`); fiscalization happens via KSeF once a KSeF SCU is configured. |
| DailyOperations | `2000` | Zero receipt — reads the register status through the SCU. |
| DailyOperations | `2011` | Daily closing — triggers the legally required daily (Z) report (raport dobowy) on the register. |
| DailyOperations | `2012`, `2013` | Monthly/yearly closing — trigger the periodic report on the register. |
| DailyOperations | `2001`, `2010` | Recorded by the queue only. |
| Log/Protocol | `3xxx` | Recorded by the queue; no register interaction. |
| Lifecycle | `4001` | Initial operation — registers the queue and verifies via the SCU that the connected register reports itself as fiscalized (fiscalizing the register itself is a certified-technician act). |
| Lifecycle | `4002` | Out of operation — deregisters the queue. |
| Lifecycle | `4011`, `4012` | Acknowledged without register interaction. |

## Constraints enforced by the queue

- **Currency PLN** on the receipt and on every charge/pay item (error code `CurrencyMustMatchMarket`).
- **No mixed sale and return positions** in one document — returns are separate documents on the register side.
- **Paragon z NIP**: the `ReceiverIsBusiness` flag requires the buyer's NIP as `CustomerVATId` in `cbCustomer`.
- **Register unreachable**: fiscal cases fail with `0x504C_2001_EEEE_EEEE` (Art. 111(3) — no working register, no sale).
