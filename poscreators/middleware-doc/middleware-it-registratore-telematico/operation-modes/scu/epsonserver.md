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
| SendReceiptsSync | `true`: each receipt is sent to the RT Server synchronously. `false`: receipts are cached locally and transmitted to the RT Server in the background (offline resilience). See *Synchronous vs. asynchronous signing* below — `false` is only supported on local/on-premise installations. | `true`<br />optional |
| IgnoreRTServerErrors | `true`: non-critical RT Server errors are logged instead of thrown (the status and logs must then be monitored). `false`: the exceptions are thrown. | `false`<br />optional |
| MaxDocumentSendRetries | Asynchronous mode only: how many times a cached document that the RT Server actively rejects is retried before being parked for manual analysis. | `5`<br />optional |
| ServerBusyRetries | How many times a request is retried when the RT Server answers `-8 Server busy` (a transient condition). | `5`<br />optional |
| ServerBusyRetryDelayInMs | Delay in milliseconds between `-8 Server busy` retries. | `2000`<br />optional |
| PerformServerZReportOnDailyClosing | `true`: also request a device-wide server Z report after the till closure. Leave `false` on multi-till installations — the server Z report keeps the device busy and should follow the RT Server's own schedule. | `false`<br />optional |
| RTServerHttpTimeoutInMs | The HTTP client timeout in milliseconds used when communicating with the RT Server. | `15000`<br />optional |
| ServerCommandTimeoutInMs | The server-side command timeout in milliseconds appended to the `fpmate.cgi` endpoint. | `10000`<br />optional |
| ServiceFolder | Local folder for the per-till state cache (on-premise). | optional |
| CacheDirectory | Local folder for the background document queue (on-premise). | optional |

Please pay attention to the case-sensitive use of the parameters.

### Till identification

The `ftCashBoxIdentification` **must be exactly 8 characters** — a 4-character store id followed by a 4-character till id (e.g. `FISK0001`) — and it must be present in the RT Server till map.

### Synchronous vs. asynchronous signing

`SendReceiptsSync` selects how receipts reach the device:

- **Synchronous (`true`, default):** the caller waits for the `createReceipt` round-trip. A device outage fails the receipt immediately.
- **Asynchronous (`false`):** the document's integrity code (CCDC) is computed locally, so the POS receives its signatures immediately even when the device is temporarily unreachable; the document is cached on disk and transmitted in the background, strictly in blockchain order.

:::caution
Asynchronous mode (`SendReceiptsSync = false`) is supported **only on local / on-premise** installations that have a persistent service folder. On **CloudCashbox** — and any stateless or containerised host — signing is **always synchronous** and this setting is ignored: asynchronous mode would cache not-yet-transmitted fiscal documents on ephemeral storage, which is lost when the instance restarts. Set `SendReceiptsSync = false` for on-premise deployments only.
:::
