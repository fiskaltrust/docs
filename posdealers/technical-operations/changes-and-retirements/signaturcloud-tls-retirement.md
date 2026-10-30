---
slug: /posdealers/technical-operations/changes-and-retirements/signaturcloud-tls-retirement
title: Retirement of TLS 1.0 and TLS 1.1 for SignaturCloud Austria and France
description: From 1 December 2026, SignaturCloud Austria and France accept only TLS 1.2 or higher and use new IP addresses. Who is affected and what to do before 30 November 2026.
tags: [Changes and Retirements, TLS, CloudCashBox, Network Requirements, Austria, France, PosDealers]
---

# Retirement of TLS 1.0 and TLS 1.1 for SignaturCloud Austria and France

:::info summary

After reading this, you can check whether your POS systems are affected by the retirement of TLS 1.0 and TLS 1.1 for SignaturCloud and prepare them before 30 November 2026.

:::

**Applies to:** SignaturCloud Austria and France, in production and sandbox.

## Introduction

SignaturCloud is the v0 API endpoint of the Cloud CashBox in Austria and France. POS systems call it directly over the internet.

SignaturCloud Austria and France accept TLS 1.0 and TLS 1.1 until 30 November 2026. On 1 December 2026, fiskaltrust moves both to new infrastructure that accepts only TLS 1.2 or higher. The IP addresses behind the SignaturCloud hostnames change at the same time.

TLS 1.0 and TLS 1.1 are deprecated by the IETF. For more information, see [RFC 8996](https://datatracker.ietf.org/doc/html/rfc8996).

| Date             | What happens                                                                                                  |
|------------------|---------------------------------------------------------------------------------------------------------------|
| 30 November 2026 | Last day on which SignaturCloud Austria and France accept TLS 1.0 and TLS 1.1.                                |
| 1 December 2026  | SignaturCloud Austria and France accept only TLS 1.2 or higher. The IP addresses behind the hostnames change. |

*Table 1. Key dates.*

## Is my POS system affected?

Your POS system is affected if it connects to one of the following hostnames with TLS 1.0 or TLS 1.1.

| Hostname                               | Market  | Environment |
|----------------------------------------|---------|-------------|
| `signaturcloud.fiskaltrust.at`         | Austria | Production  |
| `signaturcloud-sandbox.fiskaltrust.at` | Austria | Sandbox     |
| `signaturcloud.fiskaltrust.fr`         | France  | Production  |
| `signaturcloud-sandbox.fiskaltrust.fr` | France  | Sandbox     |

*Table 2. SignaturCloud hostnames covered by this change.*

This typically concerns POS systems on older operating systems, such as older Windows or embedded versions, and applications built on older .NET Framework versions that do not use TLS 1.2 by default.

This change does not cover the connections of the installed fiskaltrust.Middleware to other fiskaltrust services. Changes to those services will be announced separately.

## What do I need to do?

Make sure that your POS systems connect to SignaturCloud with TLS 1.2 or higher before 30 November 2026.

- If your POS systems already use TLS 1.2 or higher, you do not need to do anything.
- If your POS systems still use TLS 1.0 or TLS 1.1, enable TLS 1.2 before 30 November 2026:
  1. Install the latest updates for the operating system.
  2. If the POS application runs on the .NET Framework, configure it to use TLS 1.2 as described in [Transport Layer Security (TLS) best practices with the .NET Framework](https://learn.microsoft.com/en-us/dotnet/framework/network-programming/tls). For applications on .NET Framework 4.x, this typically means enabling strong cryptography (`SchUseStrongCrypto`).
  3. Test the connection as described in [How do I test the connection?](#how-do-i-test-the-connection)

If a POS software provider maintains your POS application, ask them to confirm that it supports TLS 1.2.

## Do I need to change my firewall?

Only if your firewall or proxy allows SignaturCloud by IP address. The IP addresses behind the SignaturCloud hostnames change on 1 December 2026. Before that date, allow the hostnames from Table 2 instead of IP addresses. For more information, see [Network Requirements](../middleware/network-requirements.md#signaturcloud-austria-and-france).

## How do I test the connection?

On the machine where the POS system runs, open a command prompt and run the following command. Replace the hostname with the one your POS system uses.

```console
curl.exe -I --tlsv1.2 https://signaturcloud.fiskaltrust.at
```

If you receive an HTTP response with a status code, the machine can reach SignaturCloud with TLS 1.2 or higher. If you receive an error message about the TLS or SSL handshake, TLS 1.2 is not available on the machine.

This test does not check the TLS settings of the POS application itself. The POS application must also use TLS 1.2.

For more information, see [Network troubleshooting](../troubleshooting/network-troubleshooting.md#ssl).

## Help and support

If you have questions about this change, contact the fiskaltrust Customer Success Team of your market. For more information, see [Contacting support](../../information-sources/contacting-support.md#country-specific-information).

## Related content

- [Network Requirements](../middleware/network-requirements.md)
- [Network troubleshooting](../troubleshooting/network-troubleshooting.md)
- [Migration Guide (v0 to v2)](../../../poscreators/middleware-doc/possystem-api/migration-guide.md)
- [RFC 8996: Deprecating TLS 1.0 and TLS 1.1](https://datatracker.ietf.org/doc/html/rfc8996)
