---
slug: /poscreators/middleware-doc/general/platforms
title: Platforms
description: Overview of the platforms the fiskaltrust.Middleware runs on — Windows, Linux, macOS, Android, Docker and the hosted fiskaltrust.Middleware for Cloud — with download links and installation steps.
tags: [Platforms, Launcher, Installation, Windows, Linux, macOS, Android, Middleware]
---

# Platforms

The fiskaltrust.Middleware runs either locally on the POS device or in a data center. On a local device, a **Launcher** starts the components of the fiskaltrust.Middleware (Queue, SCU, Helpers). In a data center, the fiskaltrust.Middleware runs in a container or is hosted by fiskaltrust as the fiskaltrust.Middleware for Cloud.

This page gives an overview of the available platforms, where to download the matching Launcher and how to install it. Which platforms are available depends on the market. For the platforms per market, see [Availability by market](../../../getting-started/choosing-an-architecture.md#availability-by-market).

## Overview

| Platform | Launcher | Runtime prerequisites | Download | Installation |
| -------- | -------- | --------------------- | -------- | ------------ |
| Windows | Launcher 1.3 (`fiskaltrust.exe`) | .NET Framework 4.8 recommended | fiskaltrust.Portal | [Windows](#windows) |
| Windows | Launcher 2.0 (`fiskaltrust.Launcher.exe`) | None (self-contained) | fiskaltrust.Portal, [GitHub](https://github.com/fiskaltrust/middleware-launcher/releases) | [Windows](#windows) |
| Linux, macOS | Launcher 1.3 (`fiskaltrust.exe` on Mono) | Mono 6.8.0 or higher | fiskaltrust.Portal | [Linux and macOS](#linux-and-macos) |
| Linux, macOS | Launcher 2.0 (`fiskaltrust.Launcher`) | None (self-contained) | fiskaltrust.Portal, [GitHub](https://github.com/fiskaltrust/middleware-launcher/releases) | [Linux and macOS](#linux-and-macos) |
| Android | Android Launcher (app) | Android 7 or higher | fiskaltrust.Portal (APK), Google Play | [Android](#android) |
| Docker, Kubernetes | Bring your own Data Center (Germany only) | Docker; Helm for Kubernetes | [GitHub](https://github.com/fiskaltrust/product-de-bring-your-own-datacenter) | [Docker and Kubernetes](#docker-and-kubernetes) |
| Any (hosted) | None | None | No download | [fiskaltrust.Middleware for Cloud](#fiskaltrustmiddleware-for-cloud) |

*Table 1. Platforms of the fiskaltrust.Middleware with Launcher, prerequisites, download and installation.*

### Launcher 1.3 and Launcher 2.0

Two generations of the Launcher for Windows, Linux and macOS exist:

- **Launcher 1.3** (`fiskaltrust.exe`) runs on the .NET Framework on Windows and on Mono on Linux and macOS. On Linux and macOS, SOAP is not supported and the REST endpoints differ from Windows. For more information, see [Supported Environments](../../../../posdealers/technical-operations/middleware/supported-environments.md#linux--macos).
- **Launcher 2.0** (`fiskaltrust.Launcher`) is self-contained and needs no third-party runtime on any of these platforms. It is used, for example, by the Italian Middleware and is required for the local POS System API. For more information, see [Installation for Italy](../../middleware-it-registratore-telematico/installation/installation.md) and [POS System API platforms](../../../../posdealers/technical-operations/possystem-api-platforms/overview.md).

The fiskaltrust.Portal offers the Launcher that matches the configured CashBox. To migrate from Launcher 1.3 to Launcher 2.0, see the [migration guide](https://github.com/fiskaltrust/middleware-launcher#migration-guide) in the middleware-launcher repository.

Launcher 2.0 is built for the following operating systems and architectures:

| Operating system | Architecture |
| ---------------- | ------------ |
| Windows | x64, x86 |
| Linux | x64, arm64, arm |
| macOS | x64, arm64 |

*Table 2. Operating systems and architectures for which Launcher 2.0 is built.*

Launcher 2.0 supports the operating system versions that [.NET 8 supports](https://github.com/dotnet/core/blob/main/release-notes/8.0/supported-os.md).

## Download from the fiskaltrust.Portal

For Windows, Linux, macOS and Android, download the Launcher for a configured CashBox from the fiskaltrust.Portal:

1. Open the fiskaltrust.Portal in the environment you need (sandbox or production).
2. Select `Configuration` > `CashBoxes`.
3. Select `Rebuild configuration` for the CashBox, and wait for the success confirmation.
4. Select `Download` for the CashBox and choose the Launcher for the operating system **and** the processor architecture of the target device.

For Windows, Linux and macOS, the download is a ZIP archive that already contains the configuration of the CashBox (CashBox ID and access token). Extract it into the folder from which the Middleware is to run. For Android, the download is an APK; see [Android](#android) for installation and startup.

For a description of the Launcher variants offered in the download dialog (.NET Launcher, .NET Offline Launcher, Mono Launcher, Android Launcher), see [Download of the Launcher](../components/components-install-config.md#download-of-the-launcher).

## Windows

**Requirements**

- Launcher 1.3: Windows 7 or higher, 32 or 64 bit; .NET Framework 4.8 recommended.
- Launcher 2.0: a Windows version supported by .NET 8, x86 or x64; no additional software.

For the supported Windows versions per market, see [Windows (Germany)](../../middleware-de-kassensichv/operation-modes/on-premise-platforms/windows.md) and [Windows (Italy)](../../middleware-it-registratore-telematico/operation-modes/on-premise-platforms/windows.md).

**Installation**

| Step | Launcher 1.3 | Launcher 2.0 |
| ---- | ------------ | ------------ |
| Test in the console | Run `test.cmd` as administrator. | Run `launcher-test.cmd`. |
| Install as a Windows service | Run `install-service.cmd` as administrator. | Run `launcher-install.cmd`. |
| Uninstall the service | Run `uninstall-service.cmd` as administrator. | Run `launcher-uninstall.cmd`. |
| Start and stop the service | Windows Services dashboard, or `net start [SERVICENAME]` and `net stop [SERVICENAME]` | Windows Services dashboard, or `net start [SERVICENAME]` and `net stop [SERVICENAME]` |

*Table 3. Installation steps on Windows for Launcher 1.3 and Launcher 2.0.*

For more information, see [Launcher for Windows, Linux and macOS](../../../../posdealers/technical-operations/middleware/launchers/desktop.md) (Launcher 1.3) and [Getting Started](https://github.com/fiskaltrust/middleware-launcher#getting-started) (Launcher 2.0).

## Linux and macOS

**Requirements**

- Ubuntu or Debian recommended; most testing at fiskaltrust is done on these distributions.
- Launcher 1.3: Mono 6.8.0 or higher. The Mono versions in the default package repositories are usually outdated; install Mono following the [official Mono guidelines](https://www.mono-project.com/download/stable/#download-lin-ubuntu).
- Launcher 2.0: no additional software.

The supported distributions, data storages and SCUs differ per market. For more information, see [Linux and macOS (Germany)](../../middleware-de-kassensichv/operation-modes/on-premise-platforms/linux.md) and [Linux and macOS (Italy)](../../middleware-it-registratore-telematico/operation-modes/on-premise-platforms/linux.md).

**Installation**

| Step | Launcher 1.3 (Mono) | Launcher 2.0 |
| ---- | ------------------- | ------------ |
| Test in the console | Run `test.sh`, or `sudo mono fiskaltrust.exe -test`. | Run `launcher-test.sh`. |
| Install as a service | Run `install-service.sh` as root. | Run `launcher-install.sh` (requires `systemd`). |
| Uninstall the service | Run `uninstall-service.sh` as root. | Run `launcher-uninstall.sh`. |
| Start and stop the service | For example `systemctl start [SERVICENAME]` and `systemctl stop [SERVICENAME]` | For example `systemctl start [SERVICENAME]` and `systemctl stop [SERVICENAME]` |

*Table 4. Installation steps on Linux and macOS for Launcher 1.3 and Launcher 2.0.*

For more information, see [Mono Service Installation](../components/components-install-config.md#mono-service-installation) (Launcher 1.3) and [Getting Started](https://github.com/fiskaltrust/middleware-launcher#getting-started) (Launcher 2.0).

## Android

**Requirements**

- Android 7 or higher.
- A CashBox with only the packages that the Android Launcher contains. If the CashBox contains other Queues or SCUs, the Launcher throws an exception.

The Android Launcher is an app that runs the Middleware as a foreground service. The Queue and SCU packages are bundled with the app and cannot be downloaded at runtime, so updates are rolled out as app updates. We recommend a mobile device management (MDM) solution to control the rollout of updates.

To keep the app small, there are separate apps for HTTP and gRPC:

| | fiskaltrust.Middleware for Android (HTTP) | fiskaltrust.Middleware for Android (gRPC) |
| --- | --- | --- |
| **Google Play** | [Download on Google Play](https://play.google.com/store/apps/details?id=eu.fiskaltrust.androidlauncher.http) | [Download on Google Play](https://play.google.com/store/apps/details?id=eu.fiskaltrust.androidlauncher.grpc) |
| **APK** | fiskaltrust.Portal, `Download` on the CashBox | fiskaltrust.Portal, `Download` on the CashBox |

*Table 5. Download options for the HTTP and gRPC variants of the Android Launcher.*

**Installation**

1. Install the app from Google Play, or install the APK from the fiskaltrust.Portal (ideally through MDM).
2. Start the Middleware from the POS app via Android intents. An internet connection is required at least on the first start, to download the configuration.

The bundled packages differ per market. For more information, see [Android (Germany)](../../middleware-de-kassensichv/operation-modes/on-premise-platforms/android.md), [Android (Italy)](../../middleware-it-registratore-telematico/operation-modes/on-premise-platforms/android.md), [Launcher for Android](../../../../posdealers/technical-operations/middleware/launchers/android.md) and the [Android demo repository](https://github.com/fiskaltrust/middleware-demo-android).

## Docker and Kubernetes

:::info Germany only

Bring your own Data Center is only available in Germany.

:::

For cloud POS systems in a private data center or a public cloud (for example Azure or AWS), the Middleware runs in a Docker container. For high-load installations, a Helm chart for Kubernetes clusters is provided. We recommend the fiskaltrust.Middleware for Cloud over a Bring your own Data Center setup for simpler installation and maintenance.

The installation guidelines are maintained in the [product-de-bring-your-own-datacenter](https://github.com/fiskaltrust/product-de-bring-your-own-datacenter) repository. For more information, see [Custom data center](../../../../posdealers/technical-operations/middleware/launchers/custom-data-center.md).

## fiskaltrust.Middleware for Cloud

The fiskaltrust.Middleware for Cloud is the fiskaltrust.Middleware hosted by fiskaltrust. Nothing is installed on the POS device, so any platform with an internet connection can use it, including iOS and web-based POS systems. The POS system connects with the CashBox ID, an access token and a URL.

For more information, see [CloudCashbox](../../../../posdealers/technical-operations/middleware/launchers/cloudcashbox.md).

## Network requirements

The Launchers download their configuration and, except on Android, their packages from the fiskaltrust servers. Allow the outbound connections listed in [Network requirements](../../../../posdealers/technical-operations/middleware/network-requirements.md).
