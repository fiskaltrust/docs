---
slug: /poscreators/middleware-doc/france/operation-modes
title: Operation Modes
---

# Operation Modes

## Components of fiskaltrust.Middleware

### Launcher

### Queue Nutshell

## Configuration of the fiskaltrust.Middleware

### Online Portal

All configuration settings, as well as relevant extensions, are managed via the fiskaltrust.Portal, which for the French market is available at:

https://portal.fiskaltrust.fr

### Queue

### Journal

## On-premise databases

A ChaîneLocale stores its queue data on the machine it runs on. By default that is a SQLite database, which needs no configuration. Where a point-of-sale system already brings its own database system, the queue can be pointed at that instead.

### Entity Framework

Use the Entity Framework storage provider to keep the queue data in a Microsoft SQL Server database rather than in SQLite. This suits installations that already operate a SQL Server, and setups built for failover.

Configure it in the fiskaltrust.Portal as follows.

1. Create a queue with the package name `fiskaltrust.service.ef`.
2. Set the `CashboxIdentification` as you would for any other queue.
3. Enter the SQL connection string.

For a standalone SQL Server:

```
Server=myServer\SQL2014;Database=Fiskaltrust1;User Id=sa;Password=sA123123123;
```

For a LocalDB instance from a standard installation:

```
Data Source=(localdb)\mssqllocaldb; Initial Catalog=fiskaltrust-|[queue0_id]|; Integrated Security=True;
```

Everything else — the rest of the queue configuration, the CashBox and the helpers — is identical to a standard fiskaltrust.ChaîneLocale.

:::tip locating a LocalDB database

On Windows, LocalDB keeps its instances under `C:\Users\<user>\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB`.

:::
