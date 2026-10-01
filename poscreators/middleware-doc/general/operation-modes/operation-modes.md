---
slug: /poscreators/middleware-doc/general/operation-modes
title: Operation Modes
---

# Operation Modes

The fiskaltrust.Middleware can be operated in following operational environments:

![operational-environments](images/operational-environments.svg)

*Figure 1. Operational environments in which the fiskaltrust.Middleware can be operated.*

Identification of the operational environment from the perspective of a POS operator:

| Hosted in-house | Hosted in a different building | Dedicated hardware resource | Privately shared (hardware) resource | Operational environment |
|-----------------|------------------------|------------------|---------------------|-------------------------|
| **Yes** | No | **Yes**<br />*(e.g. on a cash register or local network server)* | No | **On-premise** |
| No | **Yes**<br />*(e.g. in a data center)* | **Yes**<br />*(e.g. dedicated server)* | No | **Off-premise** |
| No | **Yes** | No | **Yes**<br />*(e.g. virtualised resources)* | **Private Cloud** |

*Table 1. Identification of the operational environment from the perspective of a POS operator.*

The availability of supported operational environments depends on the market, as shown in the following table:

| Operation mode | AT | DE | FR | IT |
|----------------|----|----|----|----|
| **On- & off-premise** | **Available** | **Available** | **Available** | **Available** |
| **Private Cloud**<br />*operated by a third party* | **Available** | **Available** | Not available<br />*generally supported, but not offered* | **Available** |
| **Private Cloud**<br />*operated by fiskaltrust* | **Available**<br />*(by the fiskaltrust product CloudCashbox)* | **Available**<br />*(by the fiskaltrust product CloudCashbox)*  | **Available**<br />*(by the fiskaltrust product CloudCashbox)* | **Available** |

*Table 2. Availability of supported operational environments per market.*

## On-premise storage

An on-premise queue keeps its data on the machine it runs on. By default that is a **SQLite** database, which needs no configuration and is created automatically on first start.

Where a point-of-sale system already operates a database server, the queue can be pointed at that instead. This suits installations that already run a SQL Server and setups built for failover, since the queue data then lives wherever that server's own backup and redundancy arrangements put it.

To use the **Entity Framework** storage provider, create the queue with the corresponding package instead of the SQLite one, and give it an EF-compatible connection string.

For a standalone SQL Server:

```
Server=myServer\SQL2014;Database=Fiskaltrust1;User Id=sa;Password=sA123123123;
```

For a LocalDB instance from a standard installation:

```
Data Source=(localdb)\mssqllocaldb; Initial Catalog=fiskaltrust-|[queue0_id]|; Integrated Security=True;
```

Everything else — the rest of the queue configuration, the CashBox and the helpers — is unchanged.

:::tip locating a LocalDB database

On Windows, LocalDB keeps its instances under `C:\Users\<user>\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB`.

:::

Which storage providers are available, the exact package names, and any additional parameters they accept differ per market. See the operation modes chapter for the market you are integrating with.

