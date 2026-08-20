---
slug: /poscreators/middleware-doc/poland/reference-tables/ftsignaturetype
title: 'Type of Signature: ftSignatureType'
---

# Type of Signature: ftSignatureType

The `ftSignatureType` indicates the type and origin of the signature. The data type is `Int64` and can contain a country-specific code, a value following the ISO-3166-1-ALPHA-2 standard, converted from ASCII into hex and used as byte 8 and 7.

For definitions regarding national laws, refer to the appropriate appendix.

## Format

_CCCC_vlll_gggg_tsss 

#### v - version
version 2

#### t - Type/Category

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0` | Uncategorized, Normal use (notification) | preview |
| `1` | Information (notification), low priority | preview |
| `2` | Alert (notification), high priority | preview |
| `3` | Failure (notification), high priority | preview |

#### gggg - global flags

| **Value** | **Description** | **Middleware Version** |
| --------- | --------------- | ---------------------- |
| `0001` | Archiving required.<br />Signatures marked with this flag are known to be archived related to market specific bookkeeping requirements. In case of offline usage or pure open-source usage, receipts/artefacts having this flag need to be handled as bookkeeping/accounting-relevant item. | preview |
| `0010` | Printing/Visualization is optional. | preview |
| `0020` | Do not print/visualize. | preview |
| `0040` | Printed receipt only. | preview |
| `0080` | Digital receipt only. | preview |

#### sss - SignatureCase 

| **Value** | **Description** | **Caption** | **Middleware Version** |
| --------- | --------------- | ----------- | ---------------------- |
| `003` | **Initial-operation / out-of-operation receipt**<br />Confirms the queue start/stop lifecycle operation. | Initial-operation receipt / Out-of-operation receipt | preview |
| `101` | **Fiscal document number**<br />The fiscal document number assigned by the certified register. | Numer dokumentu fiskalnego | preview |
| `102` | **Register factory (serial) number**<br />The numer fabryczny of the hardware register. Software registers (kasy wirtualne) do not have a factory number, so this signature is absent for them. | Numer fabryczny | preview |
| `103` | **Register unique number**<br />The numer unikatowy of the register, assigned from the central numbering pool. | Numer unikatowy | preview |
| `104` | **Daily (Z) report number**<br />The number of the daily fiscal report (raport dobowy) produced by the register. | Numer raportu dobowego | preview |
| `105` | **E-receipt reference**<br />Reference for the electronically issued receipt (e-paragon). | E-paragon | preview |
| `106` | **Stored, not fiscalized**<br />Informational signature on invoice cases (`0x1xxx`): the invoice was persisted by the middleware but not transmitted to KSeF. Configure a KSeF SCU to fiscalize invoice cases. | Stored, not fiscalized | preview |
