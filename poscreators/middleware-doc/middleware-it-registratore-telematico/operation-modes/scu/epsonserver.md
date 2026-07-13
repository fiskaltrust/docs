---
slug: /poscreators/middleware-doc/italy/scu/epsonserver
title: Epson-Server
---

# Epson Server

## Signature Creation Unit

### Support

The _fiskaltrust.Middleware.SCU.IT.EpsonRTServer_ package connects the middleware with an Epson RT Server.

### Parameters

| Name | Description | Optional |
| ---- | ------------ |--------- |
| ServerUrl | The URL or IP address of the Epson RT Server | mandatory |
| RTServerHttpTimeoutInMs | The HTTP client timeout used when communicating with the Epson RT Server. | `15000`<br />optional |
| Username | The HTTP Basic authentication user for the Epson RT Server. | `epson`<br />optional |
| Password | The HTTP Basic authentication password for the Epson RT Server. | `epson`<br />optional |

Please pay attention to the case-sensitive use of the parameters.
