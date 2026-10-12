---
slug: /posdealers/technical-operations/troubleshooting/middleware-startup-failures
title: Middleware startup failures
---
# Middleware startup failures

:::info summary

After reading this, you can diagnose a local Middleware instance that fails to start, and repair the local database it depends on.

:::

## Introduction

This chapter covers a Middleware instance that does not come up at all, or comes up and stops again immediately. These failures happen on the machine running the Middleware, before the instance is able to report anything to the fiskaltrust.Portal. That distinguishes them from [CashBox failures](cashbox-failures.md), which are exceptions raised by an instance that is running and reachable.

Because a failing instance transfers no data, the Portal's Metrics section will not help you here. Work from the console output of a manual start, or from a [log file](../middleware/logging.md).

:::tip start the Middleware manually

Most of the symptoms below are only visible when you start the Middleware from a command prompt rather than as a service. Run `test.cmd` with administrative rights from the installation directory and watch the output.

A component can run either in test mode or as a Windows service, not both at the same time. If the service is installed and running, stop it before starting the Middleware in test mode, and vice versa.

:::

:::caution first start takes longer

The first start after an installation or a configuration change is considerably slower than later ones, because the Middleware downloads its packages and unpacks its components. Give it time before concluding it has hung.

:::

## The service does not start automatically

On Windows the Middleware runs as a service. On some systems that service does not start automatically at boot, or starts and stops again immediately, even though starting it by hand afterwards works fine. This almost always means the service started before something it depends on was ready — most commonly the network stack.

Two settings help, and they can be combined.

**Delay the start.** Change the service's start type from `Automatic` to `Automatic (Delayed Start)` in `services.msc`. Microsoft documents the behaviour in [How to delay loading of specific services](https://support.microsoft.com/help/193888).

**Declare a dependency.** Tell Windows not to start the Middleware until another service has finished loading. To make the Middleware depend on the TCP/IP stack, run the following from an elevated command prompt, substituting the CashBoxId of your instance.

```console
sc config fiskaltrust-<cashboxid> depend=(tcpip)
```

The same can be set directly in the registry, under `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\fiskaltrust-<cashboxid>`, by adding a `DependOnService` value of type `REG_MULTI_SZ` containing `tcpip`.

### Proxy auto-detection at boot

A particular form of this race involves the WinHTTP Web Proxy Auto-Discovery service. If the Middleware starts while that service has not yet determined the proxy settings, its attempt to download the configuration hangs until it times out, and the start fails. Started by hand after the system has settled, the same instance works. The log shows a long gap between `Try to download configuration` and a `System.Net.WebException: The operation has timed out`.

The delayed start and the service dependency above both help. In addition, where **no proxy is in use at all**, or where the proxy settings do not come from a DHCP server, you can take the system proxy out of the picture by starting the Middleware with `-proxy=off`.

Where a proxy *is* in use, configure it explicitly instead of relying on auto-detection, as described under [Proxy setups](../middleware/network-requirements.md#proxy-setups).

## The service starts the wrong installation

If a start attempt fails with an HTTP 500 error, check that you are looking at the installation you think you are. The usual cause is several downloaded copies of the launcher on the same machine, where the configuration is edited in one directory while the service runs from another.

1. Open the service in `services.msc` and read the full path of its executable.
2. Change to exactly that directory.
3. Treat it as the only working directory for this instance, and make your configuration changes there.

Removing the unused copies afterwards prevents the problem from coming back.

## `pad-block corrupted` on start

A `pad-block corrupted` error on start comes from a damaged configuration file.

1. [Rebuild the configuration](../middleware/cashbox.md#rebuilding) in the fiskaltrust.Portal and restart the Middleware.
2. If the error persists, rename `C:\ProgramData\fiskaltrust\service\<cashboxid>-configuration.json` to `<cashboxid>-configuration.json.bak` and repeat step 1. Renaming rather than deleting keeps the old file available if you need to inspect it.

## Components are not extracted

A start that fails immediately with `Error launching service, retry in 15s with download! (Object reference not set to an instance of an object.)`, and never gets as far as initialising a queue, means the Middleware could not unpack its component binaries.

**Not enough temporary disk space.** The Middleware extracts its code libraries into the temporary directory. Free up space on that partition, or point `$TMPDIR` at one with more room.

**An incompatible Mono version.** Mono 6.10 changed how the base directory is determined in a service context (`mono-service`). Version 1 of the launcher is not compatible with that change, so on Mono you need **6.8 or older**. Binaries are available from the [Mono project](https://www.mono-project.com/docs/getting-started/install/linux/). Under .NET Framework 4.8 on Windows the issue does not occur.

## The instance runs but returns no signatures

A cloud CashBox that answers requests but returns an empty `ftSignatures` collection has not had its signature creation unit activated yet. The signature chain only becomes operational once the point-of-sale system has been put into operation.

Send a start receipt. That activates the point-of-sale system and, with it, the SCU, and signatures are returned from then on.

For a local installation the equivalent prerequisites are that the CashBox exists in the fiskaltrust.Portal, that a queue and an SCU have been created and the SCU assigned to the queue, that the configuration has been [rebuilt](../middleware/cashbox.md#rebuilding), and that the installation scripts were run with administrative rights before the point-of-sale system was restarted.

## SQLite database problems

The standard on-premise installation stores its queue data in a SQLite database under `C:\ProgramData\fiskaltrust\service`, named after the queue it belongs to: `[00000000-0000-0000-0000-000000000000].sqlite`. If several queues run on one machine, there is one database per queue. The queue ID is printed in the console output at startup and can be looked up in the fiskaltrust.Portal.

### The database is malformed

Errors reported just after the `init service.sqlite.storage` line — typically `database disk image is malformed` — point at a corrupt database.

:::caution never repair on a productive till

Rebuilding a database is memory- and CPU-intensive and takes longer the larger the database is. Do this on a separate machine, never directly on a cash register in operation. Back up the fiskaltrust directories before you start, and run a functional test afterwards: a repaired database is not guaranteed to be sound, and damage can resurface later.

:::

1. Download the [SQLite command-line tools](https://www.sqlite.org/download.html) for your platform.
2. Copy the affected database into a working directory of its own, for example `C:\SQLite-Repair`, and put `sqlite3.exe` next to it.
3. Open a command prompt in that directory and check the database.

   ```console
   sqlite3 [00000000-0000-0000-0000-000000000000].sqlite
   pragma integrity_check;
   ```

4. If the check reports errors, leave `sqlite3` with `Ctrl` + `C` and dump the database to a script.

   ```console
   echo .dump | sqlite3 [00000000-0000-0000-0000-000000000000].sqlite > repaired.sql
   ```

5. Rename the damaged database, for example to `[00000000-0000-0000-0000-000000000000]-old.sqlite`, so the next step can write a fresh one.
6. Open `repaired.sql` in a text editor and delete the `BEGIN TRANSACTION` command on the second line and the `ROLLBACK` command on the last line, then save the file.
7. Build the new database from the script.

   ```console
   sqlite3.exe -init repaired.sql [00000000-0000-0000-0000-000000000000].sqlite
   ```

8. Check the new database with the command from step 3.
9. Copy the repaired database back over the damaged one under `C:\ProgramData\fiskaltrust\service`, keeping the damaged copy as a backup.

### The database is locked

An `Exception-database is locked` entry in the log, usually accompanied by others, means another process holds the database open.

Identify what else has the file open, close it, and restart the Middleware. Bear in mind that a second Middleware instance started from a different directory is a common culprit — see [The service starts the wrong installation](#the-service-starts-the-wrong-installation).

If the problem persists, open the database with the `sqlite3` shell and set a busy timeout, which lets the database wait for a lock to clear instead of failing immediately.

```console
PRAGMA busy_timeout = 5000;
```

## Market-specific startup failures

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import StartupAT from '../../_markets/at/technical-operations/troubleshooting/middleware-startup-failures/_startup.mdx';
import StartupFR from '../../_markets/fr/technical-operations/troubleshooting/middleware-startup-failures/_startup.mdx';
import StartupDE from '../../_markets/de/technical-operations/troubleshooting/middleware-startup-failures/_startup.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <StartupAT />
  </TabItem>

  <TabItem value="FR" label="France">
    <StartupFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <StartupDE />
  </TabItem>

</Tabs>
