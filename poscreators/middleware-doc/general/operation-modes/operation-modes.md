---
slug: /poscreators/middleware-doc/general/operation-modes
title: Operation Modes
---

# Operation Modes

The fiskaltrust.Middleware can be operated in following operational environments:

![operational-environments](images/operational-environments.svg)

Identification of the operational environment from the perspective of a POS operator:

| Hosted in-house | Hosted in a different building | Dedicated hardware resource | Privately shared (hardware) resource | Operational environment |
|-----------------|------------------------|------------------|---------------------|-------------------------|
| **Yes** | No | **Yes**<br />*(e.g. on a cash register or local network server)* | No | **On-premise** |
| No | **Yes**<br />*(e.g. in a data center)* | **Yes**<br />*(e.g. dedicated server)* | No | **Off-premise** |
| No | **Yes** | No | **Yes**<br />*(e.g. virtualised resources)* | **Private Cloud** |

The availability of supported operational environments depends on the market, as shown in the following table:

| Operation mode | AT | DE | FR | IT |
|----------------|----|----|----|----|
| **On- & off-premise** | **Available** | **Available** | **Available** | **Available** |
| **Private Cloud**<br />*operated by a third party* | **Available** | **Available** | Not available<br />*generally supported, but not offered* | **Available** |
| **Private Cloud**<br />*operated by fiskaltrust* | **Available**<br />*(by the fiskaltrust product CloudCashbox)* | **Available**<br />*(by the fiskaltrust product CloudCashbox)*  | **Available**<br />*(by the fiskaltrust product CloudCashbox)* | **Available** |
