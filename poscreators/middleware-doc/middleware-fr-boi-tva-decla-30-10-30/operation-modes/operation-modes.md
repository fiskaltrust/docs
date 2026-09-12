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

A ChaîneLocale stores its queue data on the machine it runs on. The concept, the connection-string formats and the LocalDB notes are described once in the [general operation modes chapter](../../general/operation-modes/operation-modes.md#on-premise-storage).

For the French market:

| Storage | Queue package |
| ------- | ------------- |
| SQLite (default) | `fiskaltrust.service.sqlite` |
| Entity Framework / SQL Server | `fiskaltrust.service.ef` |

*Table 1. Queue packages for on-premise storage in France.*

Set the `CashboxIdentification` as you would for any other queue, and enter the SQL connection string on the queue configuration.
