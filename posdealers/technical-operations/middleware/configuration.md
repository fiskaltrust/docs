---
slug: /posdealers/technical-operations/middleware/configuration
title: Configuration
---
# Configuration

:::info summary

After reading this, you can configure the system parameters of your Middleware instance.

:::

## Introduction

:::caution

This chapter is about locally deployed **.NET Middleware** setups (Windows or Mono on Unix). Other deployment types (e.g., Android, BYODC, hosted Middleware) may have significantly different layouts and requirements.

:::

The Middleware uses two types of configurations. One is for the actual CashBox instance running; the other defines the Middleware's general runtime settings. For information about the former,  read the chapter [CashBox](cashbox.md).
Read this chapter for information about the latter.

## The Configuration File

When the Middleware starts, the Launcher will try to find the file `fiskaltrust.exe.config` in its directory and loads its configuration from there.

The file contains a standard XML document with a `configuration / [appSettings | startup | runtime]` hierarchy; though, to configure the Middleware, we are solely focusing on the `appSettings` section. **Please leave the other sections and their values untouched.**

Each parameter is represented by an `<add>` tag beneath `<appSettings>`, which holds two attributes (`key` and `value`) indicating the relevant parameter and its value. The following example would configure the Middleware to run as production CashBox.

```xml
<appSettings>

  <add key="sandbox" value="false" />

</appSettings>
```

:::tip xml validation

After making manual changes, it is always a good idea to validate the XML syntax of your file. You can do so with the following PowerShell snippet. The file should be syntactically valid if it does not report any error messages.

```powershell
[xml](Get-Content fiskaltrust.exe.config)
```

Alternatively, you can also use an online validation service, such as [jsonformatter.org](https://jsonformatter.org/xml-validator).

:::

### Parameters

The following table contains the list of all currently supported configuration parameters.

| Parameter         | Description                                                  | Example Value                          |
| ----------------- | ------------------------------------------------------------ | -------------------------------------- |
| accesstoken       | The access token of the CashBox.                             | `McWDtOcxxN`                           |
| cashboxid         | The ID of the CashBox the Launcher should start.             | `00000000-0000-0000-0000-000000000000` |
| connectionretry   | The number of times the Middleware will attempt to fetch its configuration from the portal. | `1`                                    |
| connectiontimeout | The timeout (in seconds), after which the Middleware will abort. | `15`                                   |
| logfile           | Full path to log file. Please [Logging](logging.md) for details. | `D:\logs\fiskaltrust.log`              |
| packagesurl       | An alternative download URL for the _fiskaltrust_ package service. | `https://packages.fiskaltrust.cloud`   |
| proxy             | Connection details for a possible proxy connection. Please see [Proxy setups](network-requirements.md#proxy-setups) for details. | `address=10.0.0.0`                     |
| sandbox           | Boolean flag indicating whether the Middleware uses the [sandbox environment](../../getting-started/sandbox.md). | `false`                                |
| servicefolder     | Full path to the Middleware's [data directory](setup.md#data-directory). | `D:\data\fiskaltrust`                  |
| sslvalidation     | Boolean flag indicating whether the Middleware validates SSL certificates. | `true`                                 |
| useoffline        | Boolean flag indicating whether the Middleware should not attempt any network communication.<br />*Please be careful with this setting; enabling it will stop all online services.* | `false`                                |
|                   | **Following parameters are only available with version 1.3 of the Launcher on the German market** |                                        |
| scutimeout        | The timeout (in seconds), after which the queue will abort requests to the SCU. | `75`                                   |
| telemetry-optout  | flag indicating whether the Middleware should disable telemetry. | `false`                                |
| verbosity         | The level of logging the Middleware should use. Please [Logging](logging.md) for details. | `information`                          |

*Table 1. Supported Middleware configuration parameters.*

## Changing parameters with the Launcher

In addition to manually editing the configuration file `fiskaltrust.exe.config`, you can set parameters via the Launcher. Please see the chapter [Launcher](launchers/desktop.md#configuration-parameters) for more details on how to do that.

## Component parameters

The parameters above configure the Launcher, which is the process that hosts your Middleware instance. The individual components inside a CashBox — the queues, the SCUs and the helpers — carry their own parameters, and those are configured in the fiskaltrust.Portal rather than in `fiskaltrust.exe.config`.

To set one that is not offered as a field of its own, select the CashBox, choose `Edit`, open `Parameter`, and use `Add custom configuration` to add the parameter name and its value. Save the configuration afterwards and [rebuild](cashbox.md#rebuilding) the CashBox, so the new value reaches the deployed instance.

### Timeouts

Each component that forwards requests has a timeout, expressed in seconds.

| Component | Parameter | Default | Description |
| --------- | --------- | ------- | ----------- |
| Queue | `timeout` | `15` | How long the queue may take to process a request. |
| Balancer helper | `timeout` | `15` | How long the balancer waits for the queue behind it. |
| REST helper | `timeout` | `15` | How long the REST helper waits for the queue behind it. |

*Table 2. Timeout parameters of the request-processing components.*

Choosing these values is a trade-off. A timeout that is too short produces errors for requests that would have completed; one that is too long leaves the cashier, and the customer at the till, waiting.

The one hard rule is that **a helper must wait longer than the queue behind it**. If the helper gives up first, the queue keeps working on a request whose answer nobody is waiting for any more. Setting all three to the same value has the same effect, since the helper and the queue then expire together. Leave a margin — for a queue at 110 seconds, 120 seconds for the balancer and the REST helper works well.

The serial-port helper talks to hardware rather than to a queue, and takes its timeouts in milliseconds.

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `tcpreceivetimeout` | `1000` | How long a `TcpClient` waits to receive data once a read has started. |
| `tcpsendtimeout` | `1000` | How long a `TcpClient` waits for a send to complete. |
| `comreadtimeout` | `-1` | How long a read on the serial port may take before it times out. `-1` means no limit. |
| `comwritetimeout` | `-1` | How long a write on the serial port may take before it times out. `-1` means no limit. |
| `pollintervall` | `2000` | How long to wait before reconnecting and resuming reads after a connection was closed. |

*Table 3. Timeout parameters of the serial-port helper.*

### Market-specific parameters

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import ComponentParametersAT from '../../_markets/at/technical-operations/middleware/configuration/_component-parameters.mdx';
import ComponentParametersFR from '../../_markets/fr/technical-operations/middleware/configuration/_component-parameters.mdx';
import ComponentParametersDE from '../../_markets/de/technical-operations/middleware/configuration/_component-parameters.mdx';

<Tabs groupId="market">

  <TabItem value="AT" label="Austria">
    <ComponentParametersAT />
  </TabItem>

  <TabItem value="FR" label="France">
    <ComponentParametersFR />
  </TabItem>

  <TabItem value="DE" label="Germany">
    <ComponentParametersDE />
  </TabItem>

</Tabs>
