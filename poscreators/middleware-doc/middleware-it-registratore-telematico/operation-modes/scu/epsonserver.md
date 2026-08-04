---
slug: /poscreators/middleware-doc/italy/scu/epsonserver
title: Epson-Server
---

# Epson Server

## Signature Creation Unit

### Support

**Stable from version:** TBD

The _fiskaltrust.Middleware.SCU.IT.EpsonRTServer_ package connects the middleware with an Epson RT Server (Registratore Telematico Server, e.g. the FP-S series) — the multi-till fiscal-server counterpart of the Epson RT Printer. It communicates with the device over its SOAP/XML protocol.

### Parameters

| Name | Description | Optional |
| ---- | ------------ |--------- |
| ServerUrl | The URL or IP address of the Epson RT Server (e.g. `https://192.168.1.10`). The `cgi-bin` endpoints are appended automatically. | mandatory |
| Username | HTTP Basic authentication user for the RT Server. | `epson`<br />optional |
| Password | HTTP Basic authentication password for the RT Server. | `epson`<br />optional |
| DisableSSLValidation | Disables the TLS certificate verification. Epson RT Servers ship with self-signed certificates, so this is usually required when connecting to the device by IP address. | `false`<br />optional |
| SendReceiptsSync | `true`: each receipt is sent to the RT Server synchronously. `false`: receipts are cached locally and transmitted in the background (offline resilience). Asynchronous mode **requires an explicitly configured persistent `ServiceFolder` or `CacheDirectory`**; without one the SCU signs synchronously (see *Synchronous vs. asynchronous signing*). | `true`<br />optional |
| IgnoreRTServerErrors | `true`: non-critical RT Server errors are logged instead of thrown (the status and logs must then be monitored). `false`: the exceptions are thrown. | `false`<br />optional |
| MaxDocumentSendRetries | Asynchronous mode only: how many times a cached document that the RT Server actively rejects is retried before being parked for manual analysis. | `5`<br />optional |
| ServerBusyRetries | How many times a request is retried when the RT Server answers `-8 Server busy` (a transient condition). | `5`<br />optional |
| ServerBusyRetryDelayInMs | Delay in milliseconds between `-8 Server busy` retries. | `2000`<br />optional |
| PerformServerZReportOnDailyClosing | `true`: also request a device-wide server Z report after the till closure. Leave `false` on multi-till installations — the server Z report keeps the device busy and should follow the RT Server's own schedule. | `false`<br />optional |
| RTServerHttpTimeoutInMs | The HTTP client timeout in milliseconds used when communicating with the RT Server. | `15000`<br />optional |
| ServerCommandTimeoutInMs | The server-side command timeout in milliseconds appended to the `fpmate.cgi` endpoint. | `10000`<br />optional |
| ServiceFolder | Local folder for the per-till state cache. Configuring it (or `CacheDirectory`) also provides the persistent location required for asynchronous mode. | optional |
| CacheDirectory | Local folder for the background document queue. Configuring it (or `ServiceFolder`) enables asynchronous mode. | optional |

Please pay attention to the case-sensitive use of the parameters.

### Till identification

The `ftCashBoxIdentification` **must be exactly 8 characters** — a 4-character store id followed by a 4-character till id (e.g. `FISK0001`) — and it must be present in the RT Server till map.

### Synchronous vs. asynchronous signing

`SendReceiptsSync` selects how receipts reach the device:

- **Synchronous (`true`, default):** the caller waits for the `createReceipt` round-trip. A device outage fails the receipt immediately.
- **Asynchronous (`false`):** the document's integrity code (CCDC) is computed locally, so the POS receives its signatures immediately even when the device is temporarily unreachable; the document is cached on disk and transmitted in the background, strictly in blockchain order.

:::caution
Asynchronous mode (`SendReceiptsSync = false`) requires an explicitly configured **persistent** `ServiceFolder` or `CacheDirectory` to buffer not-yet-transmitted fiscal documents. If neither is configured — as on **CloudCashbox** and any stateless or containerised host, which have no persistent local storage — the SCU **signs synchronously** regardless of `SendReceiptsSync`. This prevents buffering fiscal documents to ephemeral storage, where they would be lost when the instance restarts. Use `SendReceiptsSync = false` (with a persistent folder) only on local / on-premise installations.
:::
